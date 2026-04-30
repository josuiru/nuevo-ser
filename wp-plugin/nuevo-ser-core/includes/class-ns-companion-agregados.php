<?php
/**
 * Endpoints de Agregados (`/companion/aggregates/*`).
 *
 * En este slice cubre `POST /companion/aggregates/weekly`: el cliente
 * sube un objeto de agregados anonimizados (contadores de juego,
 * habilidades practicadas, mosaicos completados…) por
 * `(user_id, game_id, iso_week)`. El servidor calcula un hash
 * determinista del shape, hace upsert en `ns_weekly_summaries` y devuelve
 * la fila — con idempotencia: si el cliente vuelve a subir los mismos
 * agregados (mismo hash) en la misma semana, devolvemos 200 sin tocar
 * `generated_at`.
 *
 * **Pendiente**: este endpoint NO genera todavía `summary_text` ni
 * `conversation_prompt`. La intención del shape de la tabla es que el
 * tutor IA produzca un resumen amable a partir de los agregados, con
 * caché por `aggregates_hash` para evitar pedirle al LLM dos veces lo
 * mismo. Conectar el tutor aquí es un slice posterior; por ahora
 * `summary_text` se almacena como cadena vacía.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Companion_Agregados {

	/** Longitud máxima de `iso_week`. Coincide con el VARCHAR(10) de la tabla. */
	private const MAX_ISO_WEEK = 10;

	/**
	 * POST /companion/aggregates/weekly
	 *
	 * @param WP_REST_Request $request
	 * @param callable|null   $cliente_anthropic Callable que recibe el
	 *      array de agregados y devuelve el texto crudo del LLM. Se
	 *      inyecta en tests; en producción usa
	 *      `NS_Anthropic::pedir_resumen_semanal`. Misma estrategia que
	 *      `NS_Tutor::explicar`.
	 * @return WP_REST_Response|WP_Error
	 */
	public static function archivar( WP_REST_Request $request, ?callable $cliente_anthropic = null ) {
		global $wpdb;

		$nino_id = (int) $request->get_param( '_nino_id' );
		if ( $nino_id <= 0 ) {
			return new WP_Error(
				'ns_agregados_sin_nino',
				'Falta el identificador del niño en el token.',
				array( 'status' => 401 )
			);
		}

		$body = $request->get_json_params();
		if ( ! is_array( $body ) ) {
			return self::error_validacion(
				'body_no_es_objeto',
				'El cuerpo de la petición debe ser un objeto JSON.'
			);
		}

		$campos_invalidos = self::validar_formato( $body );

		$game_id = isset( $body['game_id'] ) ? trim( (string) $body['game_id'] ) : '';
		if ( ! isset( $campos_invalidos['game_id'] ) && ! self::juego_existe( $game_id ) ) {
			$campos_invalidos['game_id'] = 'no_existe';
		}

		if ( ! empty( $campos_invalidos ) ) {
			return self::error_validacion(
				'campos_invalidos',
				'Algunos campos no pasan la validación.',
				array( 'invalid_fields' => $campos_invalidos )
			);
		}

		$iso_week    = trim( (string) $body['iso_week'] );
		$aggregates  = $body['aggregates'];
		$hash_actual = self::calcular_hash( $aggregates );

		$tabla = NS_Esquema::nombre_tabla( 'weekly_summaries' );

		$existente = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT summary_text, conversation_prompt, aggregates_hash, generated_at
				 FROM {$tabla}
				 WHERE user_id = %d AND game_id = %s AND iso_week = %s",
				$nino_id,
				$game_id,
				$iso_week
			),
			ARRAY_A
		);

		$ahora = gmdate( 'Y-m-d H:i:s' );

		// Idempotente con cache lleno: mismos agregados, mismo summary
		// guardado. Devolvemos cache sin invocar al LLM. NO se toca
		// `generated_at` para que el cliente vea la fecha original del
		// summary (es la respuesta más útil para "Esta semana").
		if (
			$existente
			&& (string) $existente['aggregates_hash'] === $hash_actual
			&& '' !== (string) $existente['summary_text']
		) {
			return new WP_REST_Response(
				array(
					'game_id'             => $game_id,
					'iso_week'            => $iso_week,
					'aggregates_hash'     => $hash_actual,
					'summary_text'        => (string) $existente['summary_text'],
					'conversation_prompt' => $existente['conversation_prompt'] === null
						? null
						: (string) $existente['conversation_prompt'],
					'generated_at'        => (string) $existente['generated_at'],
				),
				200
			);
		}

		// Generamos summary AHORA (antes de tocar la fila), así si falla
		// el cliente recibe summary vacío pero la fila queda escrita con
		// los agregados nuevos: la próxima llamada con el mismo hash
		// reintenta. Si sale bien, persistimos summary y prompt; si no,
		// dejamos el campo vacío y el cliente reintenta más tarde.
		try {
			$resumen = self::generar_resumen( $aggregates, $cliente_anthropic );
			$summary_text        = $resumen['summary_text'];
			$conversation_prompt = $resumen['conversation_prompt'];
		} catch ( Throwable $e ) {
			$summary_text        = '';
			$conversation_prompt = null;
		}

		// Persistimos también el JSON original de aggregates. La vista del
		// aula (k≥5, GET /classrooms/{id}/aggregates) lo lee y suma los
		// counts de los miembros activos. El payload son sólo metadatos
		// agregables (counts numéricos, IDs canónicos, region_code) — no
		// hay texto libre del niño aquí.
		$payload_serializado = wp_json_encode( $aggregates );
		if ( ! is_string( $payload_serializado ) ) {
			$payload_serializado = '';
		}

		if ( $existente ) {
			$resultado = $wpdb->update(
				$tabla,
				array(
					'summary_text'        => $summary_text,
					'conversation_prompt' => $conversation_prompt,
					'aggregates_hash'     => $hash_actual,
					'aggregates_payload'  => $payload_serializado,
					'generated_at'        => $ahora,
				),
				array(
					'user_id'  => $nino_id,
					'game_id'  => $game_id,
					'iso_week' => $iso_week,
				),
				array( '%s', '%s', '%s', '%s', '%s' ),
				array( '%d', '%s', '%s' )
			);
			if ( false === $resultado ) {
				return new WP_Error(
					'ns_agregados_update_error',
					'No se pudo actualizar el resumen semanal.',
					array( 'status' => 500 )
				);
			}
			$status = 200;
		} else {
			$resultado = $wpdb->insert(
				$tabla,
				array(
					'user_id'             => $nino_id,
					'game_id'             => $game_id,
					'iso_week'            => $iso_week,
					'summary_text'        => $summary_text,
					'conversation_prompt' => $conversation_prompt,
					'aggregates_hash'     => $hash_actual,
					'aggregates_payload'  => $payload_serializado,
					'generated_at'        => $ahora,
				),
				array( '%d', '%s', '%s', '%s', '%s', '%s', '%s', '%s' )
			);
			if ( false === $resultado ) {
				return new WP_Error(
					'ns_agregados_insert_error',
					'No se pudo guardar el resumen semanal.',
					array( 'status' => 500 )
				);
			}
			$status = 201;
		}

		return new WP_REST_Response(
			array(
				'game_id'             => $game_id,
				'iso_week'            => $iso_week,
				'aggregates_hash'     => $hash_actual,
				'summary_text'        => $summary_text,
				'conversation_prompt' => $conversation_prompt,
				'generated_at'        => $ahora,
			),
			$status
		);
	}

	/**
	 * Llama al cliente Anthropic, parsea el JSON crudo y aplica el
	 * filtro de salida. Lanza Throwable si la llamada falla, si el
	 * cuerpo no se puede parsear o si el filtro rechaza la respuesta —
	 * el caller decide qué hacer (en `archivar` se captura para que el
	 * archivado siga adelante con summary vacío).
	 *
	 * @param array<string,mixed> $aggregates
	 * @param callable|null       $cliente_anthropic
	 * @return array{summary_text:string, conversation_prompt:?string}
	 * @throws RuntimeException
	 */
	public static function generar_resumen(
		array $aggregates,
		?callable $cliente_anthropic = null
	): array {
		$cliente = $cliente_anthropic ?? array( 'NS_Anthropic', 'pedir_resumen_semanal' );
		$crudo   = (string) call_user_func( $cliente, $aggregates );

		$parseado = self::parsear_respuesta_llm( $crudo );

		// El filtro de salida es el mismo que el del tutor de matemáticas.
		// Aceptable: nos protege de PII y de respuestas vacías. Si más
		// adelante el filtro semántico cambia, refactorizar a una capa
		// específica de companion.
		$revision = NS_Filtro_Tutor::revisar_respuesta( $parseado['summary_text'] );
		if ( ! $revision['ok'] ) {
			throw new RuntimeException(
				'Filtro de salida rechaza summary_text: ' . (string) $revision['motivo']
			);
		}
		$summary = (string) $revision['limpio'];

		$prompt = null;
		if ( null !== $parseado['conversation_prompt'] ) {
			$revision_prompt = NS_Filtro_Tutor::revisar_respuesta( $parseado['conversation_prompt'] );
			if ( $revision_prompt['ok'] ) {
				$prompt = (string) $revision_prompt['limpio'];
			}
			// Si el filtro lo rechaza, dejamos prompt en null pero NO
			// tiramos toda la respuesta: el summary suele ser lo
			// importante.
		}

		return array(
			'summary_text'        => $summary,
			'conversation_prompt' => $prompt,
		);
	}

	/**
	 * Parsea el texto crudo del LLM y extrae `summary_text` y
	 * `conversation_prompt`. Tolerante:
	 * - Acepta JSON estricto.
	 * - Acepta JSON envuelto en ``` o markdown.
	 * - Si nada parsea, usa el texto entero como summary_text y deja
	 *   conversation_prompt en null.
	 *
	 * Pura — testeable sin WP.
	 *
	 * @return array{summary_text:string, conversation_prompt:?string}
	 */
	public static function parsear_respuesta_llm( string $crudo ): array {
		$texto = trim( $crudo );

		// Intento 1: parseo directo.
		$json = json_decode( $texto, true );
		if ( ! is_array( $json ) ) {
			// Intento 2: extraer el primer bloque {...} balanceado.
			if ( preg_match( '/\{(?:[^{}]|(?R))*\}/s', $texto, $coincidencias ) ) {
				$json = json_decode( $coincidencias[0], true );
			}
		}

		if ( is_array( $json ) ) {
			$summary = isset( $json['summary_text'] ) ? trim( (string) $json['summary_text'] ) : '';
			$prompt  = isset( $json['conversation_prompt'] ) && '' !== trim( (string) $json['conversation_prompt'] )
				? trim( (string) $json['conversation_prompt'] )
				: null;
			if ( '' !== $summary ) {
				return array(
					'summary_text'        => $summary,
					'conversation_prompt' => $prompt,
				);
			}
		}

		// Fallback: el texto entero es el summary. El cliente verá un
		// summary y null en prompt; no es ideal pero no se pierde la
		// info útil.
		return array(
			'summary_text'        => $texto,
			'conversation_prompt' => null,
		);
	}

	/**
	 * Valida el shape del body sin tocar la DB. Pura — testeable sin WP.
	 *
	 * @param array<string,mixed> $body
	 * @return array<string,string>
	 */
	public static function validar_formato( array $body ): array {
		$campos_invalidos = array();

		$game_id = isset( $body['game_id'] ) ? trim( (string) $body['game_id'] ) : '';
		if ( '' === $game_id ) {
			$campos_invalidos['game_id'] = 'requerido';
		}

		$iso_week = isset( $body['iso_week'] ) ? trim( (string) $body['iso_week'] ) : '';
		if ( '' === $iso_week ) {
			$campos_invalidos['iso_week'] = 'requerido';
		} elseif ( strlen( $iso_week ) > self::MAX_ISO_WEEK ) {
			$campos_invalidos['iso_week'] = 'demasiado_largo';
		} elseif ( ! preg_match( '/^\d{4}-W(0[1-9]|[1-4]\d|5[0-3])$/', $iso_week ) ) {
			$campos_invalidos['iso_week'] = 'formato_invalido';
		}

		// `aggregates` debe estar y ser un objeto/array. Lista pura
		// también vale (PHP `is_array` cubre ambos), pero el caso de uso
		// natural es un mapa de contadores; igualmente lo aceptamos.
		if ( ! array_key_exists( 'aggregates', $body ) || $body['aggregates'] === null ) {
			$campos_invalidos['aggregates'] = 'requerido';
		} elseif ( ! is_array( $body['aggregates'] ) ) {
			$campos_invalidos['aggregates'] = 'debe_ser_objeto';
		}

		return $campos_invalidos;
	}

	/**
	 * Hash determinista de un agregado. Ordena las claves recursivamente
	 * antes de codificar para que `{a:1,b:2}` y `{b:2,a:1}` produzcan el
	 * mismo hash (el cliente puede reordenar campos sin invalidar la
	 * caché del summary). Pura — testeable sin WP.
	 *
	 * @param mixed $aggregates
	 * @return string SHA-256 hex de 64 chars (cabe en VARCHAR(64) de la tabla).
	 */
	public static function calcular_hash( $aggregates ): string {
		$ordenado = self::ordenar_claves_recursivo( $aggregates );
		$json     = wp_json_encode( $ordenado, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES );
		if ( false === $json ) {
			$json = '';
		}
		return hash( 'sha256', $json );
	}

	/**
	 * Ordena las claves de un array asociativo de forma estable y
	 * recursiva. Las listas (arrays con claves numéricas consecutivas) se
	 * dejan intactas — el orden de los elementos en una lista sí es
	 * semánticamente significativo.
	 *
	 * @param mixed $valor
	 * @return mixed
	 */
	private static function ordenar_claves_recursivo( $valor ) {
		if ( ! is_array( $valor ) ) {
			return $valor;
		}
		$es_lista = array_is_list( $valor );
		if ( $es_lista ) {
			return array_map( array( __CLASS__, 'ordenar_claves_recursivo' ), $valor );
		}
		ksort( $valor );
		foreach ( $valor as $clave => $hijo ) {
			$valor[ $clave ] = self::ordenar_claves_recursivo( $hijo );
		}
		return $valor;
	}

	/**
	 * Comprueba si [game_id] está registrado en `ns_games`.
	 */
	private static function juego_existe( string $game_id ): bool {
		global $wpdb;
		$tabla  = NS_Esquema::nombre_tabla( 'games' );
		$existe = $wpdb->get_var( $wpdb->prepare( "SELECT id FROM {$tabla} WHERE id = %s", $game_id ) );
		return null !== $existe;
	}

	private static function error_validacion( string $code, string $mensaje, array $data = array() ): WP_Error {
		return new WP_Error(
			$code,
			$mensaje,
			array_merge( array( 'status' => 400 ), $data )
		);
	}
}
