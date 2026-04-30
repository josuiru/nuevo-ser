<?php
/**
 * Endpoints de Aulas (`/classrooms/*`).
 *
 * Cubre:
 * - `POST /classrooms/{code}/join` con JWT del niño (`unirse`).
 * - `POST /classrooms` con JWT del profesor (`crear_aula`) — el
 *   profesor crea un aula, el servidor le devuelve el código de
 *   invitación. El JWT del profesor lo emite `NS_Auth_Adulto::login`
 *   (POST /auth/login con rol='profesor').
 *
 * Pendiente: `GET /classrooms/{id}/aggregates` (agregados del aula
 * para el profesor) — entra en un slice posterior.
 *
 * Hermano de NS_Companion_Cuaderno y NS_Companion_Mosaicos: misma forma
 * de validación pura + comprobación con DB, mismo error 400 con
 * `invalid_fields`.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Companion_Aulas {

	/** Longitud mínima de un código de aula. */
	public const MIN_CODE = 4;

	/** Longitud máxima. Coincide con el VARCHAR(16) de la tabla. */
	public const MAX_CODE = 16;

	/** Longitud del code que genera el servidor al crear un aula. */
	public const LONGITUD_CODE_GENERADO = 6;

	/** Caracteres permitidos en code. Sin O / 0 / I / 1 — confusión visual. */
	private const ALFABETO_CODE = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

	/** Máximo de reintentos al generar un code único. */
	private const MAX_INTENTOS_CODE = 16;

	/** Max chars de `name` (coincide con VARCHAR(128) de la tabla). */
	public const MAX_NOMBRE = 128;

	/** Max chars de `language` (coincide con VARCHAR(8) de la tabla). */
	public const MAX_IDIOMA = 8;

	/**
	 * POST /classrooms/{code}/join
	 *
	 * El niño dueño del JWT se une al aula que tiene ese `code`. Si ya
	 * era miembro activo, devuelve 200 con su membresía existente
	 * (operación idempotente — la misma app puede invocar el endpoint
	 * tras una reinstalación sin observar duplicados ni errores).
	 *
	 * @param WP_REST_Request $request
	 * @return WP_REST_Response|WP_Error
	 */
	public static function unirse( WP_REST_Request $request ) {
		global $wpdb;

		$nino_id = (int) $request->get_param( '_nino_id' );
		if ( $nino_id <= 0 ) {
			return new WP_Error(
				'ns_aulas_sin_nino',
				'Falta el identificador del niño en el token.',
				array( 'status' => 401 )
			);
		}

		$code = (string) $request->get_param( 'code' );
		$campos_invalidos = self::validar_codigo( $code );
		if ( ! empty( $campos_invalidos ) ) {
			return self::error_validacion(
				'campos_invalidos',
				'El código del aula no pasa la validación.',
				array( 'invalid_fields' => $campos_invalidos )
			);
		}

		$tabla_aulas    = NS_Esquema::nombre_tabla( 'classrooms' );
		$tabla_miembros = NS_Esquema::nombre_tabla( 'classroom_members' );

		// El code se busca en mayúsculas — convención de los códigos de
		// invitación. La columna es CI por defecto en MySQL pero
		// normalizar reduce sorpresas.
		$code_normalizado = strtoupper( $code );

		$aula = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT id, code, name, game_ids, language, active
				 FROM {$tabla_aulas}
				 WHERE code = %s",
				$code_normalizado
			),
			ARRAY_A
		);

		if ( ! $aula ) {
			return new WP_Error(
				'ns_aulas_codigo_no_existe',
				'No existe ningún aula con ese código.',
				array( 'status' => 404 )
			);
		}

		if ( (int) $aula['active'] !== 1 ) {
			return new WP_Error(
				'ns_aulas_inactiva',
				'El aula está inactiva y no admite nuevos miembros.',
				array( 'status' => 409 )
			);
		}

		$classroom_id = (int) $aula['id'];

		// ¿Ya es miembro?
		$existente = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT joined_at, active FROM {$tabla_miembros}
				 WHERE classroom_id = %d AND user_id = %d",
				$classroom_id,
				$nino_id
			),
			ARRAY_A
		);

		$ahora = gmdate( 'Y-m-d H:i:s' );

		if ( $existente ) {
			// Si fue dado de baja en su día, lo reactivamos. El joined_at
			// histórico se preserva — es la fecha de su primer ingreso.
			if ( (int) $existente['active'] !== 1 ) {
				$wpdb->update(
					$tabla_miembros,
					array( 'active' => 1 ),
					array(
						'classroom_id' => $classroom_id,
						'user_id'      => $nino_id,
					),
					array( '%d' ),
					array( '%d', '%d' )
				);
			}
			$joined_at = (string) $existente['joined_at'];
			$status    = 200;
		} else {
			$insertado = $wpdb->insert(
				$tabla_miembros,
				array(
					'classroom_id' => $classroom_id,
					'user_id'      => $nino_id,
					'joined_at'    => $ahora,
					'active'       => 1,
				),
				array( '%d', '%d', '%s', '%d' )
			);
			if ( false === $insertado ) {
				return new WP_Error(
					'ns_aulas_join_error',
					'No se pudo registrar la membresía.',
					array( 'status' => 500 )
				);
			}
			$joined_at = $ahora;
			$status    = 201;
		}

		$respuesta = new WP_REST_Response(
			array(
				'classroom_id' => $classroom_id,
				'code'         => (string) $aula['code'],
				'name'         => (string) $aula['name'],
				'game_ids'     => self::decodificar_lista_games( $aula['game_ids'] ?? null ),
				'language'     => (string) $aula['language'],
				'joined_at'    => $joined_at,
			),
			$status
		);
		return $respuesta;
	}

	/**
	 * POST /classrooms (con JWT del profesor)
	 *
	 * El profesor crea un aula nueva. El servidor genera el `code` de
	 * invitación (ver `generar_codigo`); el cliente sólo provee
	 * `name`, `language` (opcional) y `game_ids` (lista no vacía de
	 * juegos catalogados en `ns_games`).
	 *
	 * Devuelve 201 con la fila completa, incluyendo `code` y
	 * `created_at`. El profesor reparte el `code` a su clase y los
	 * niños se unen vía `POST /classrooms/{code}/join`.
	 *
	 * @return WP_REST_Response|WP_Error
	 */
	public static function crear_aula( WP_REST_Request $request ) {
		global $wpdb;

		$user_id = (int) $request->get_param( '_user_id' );
		if ( $user_id <= 0 ) {
			return new WP_Error(
				'ns_aulas_sin_user',
				'Falta el identificador del profesor en el token.',
				array( 'status' => 401 )
			);
		}

		$name     = trim( (string) $request->get_param( 'name' ) );
		$language = (string) ( $request->get_param( 'language' ) ?? 'es' );
		$language = '' === trim( $language ) ? 'es' : strtolower( trim( $language ) );
		$game_ids = $request->get_param( 'game_ids' );

		$campos_invalidos = self::validar_input_creacion( $name, $language, $game_ids );
		if ( ! empty( $campos_invalidos ) ) {
			return self::error_validacion(
				'campos_invalidos',
				'Los datos del aula no pasan la validación.',
				array( 'invalid_fields' => $campos_invalidos )
			);
		}

		// Tras validación, sabemos que game_ids es lista no vacía de
		// strings. Comprobamos que cada uno exista en ns_games.
		$tabla_games = NS_Esquema::nombre_tabla( 'games' );
		$game_ids    = array_values( array_unique( array_map( 'strval', $game_ids ) ) );
		$placeholders = implode( ',', array_fill( 0, count( $game_ids ), '%s' ) );
		$existentes  = $wpdb->get_col(
			$wpdb->prepare(
				"SELECT id FROM {$tabla_games} WHERE id IN ({$placeholders})", // phpcs:ignore WordPress.DB.PreparedSQL
				...$game_ids
			)
		);
		$inexistentes = array_values( array_diff( $game_ids, (array) $existentes ) );
		if ( ! empty( $inexistentes ) ) {
			return self::error_validacion(
				'campos_invalidos',
				'Alguno de los game_ids no existe en el catálogo.',
				array(
					'invalid_fields' => array(
						'game_ids' => 'no_catalogados',
					),
					'unknown_game_ids' => $inexistentes,
				)
			);
		}

		$tabla_aulas = NS_Esquema::nombre_tabla( 'classrooms' );
		$ahora       = gmdate( 'Y-m-d H:i:s' );

		// Generamos code y reintentamos si choca con uno existente. La
		// columna tiene UNIQUE KEY, así que la propia base nos protege —
		// el INSERT devuelve false en colisión y reintentamos.
		$code = null;
		for ( $intento = 0; $intento < self::MAX_INTENTOS_CODE; $intento++ ) {
			$candidato = self::generar_codigo();
			$insertado = $wpdb->insert(
				$tabla_aulas,
				array(
					'code'            => $candidato,
					'teacher_user_id' => $user_id,
					'name'            => $name,
					'game_ids'        => wp_json_encode( $game_ids ),
					'language'        => $language,
					'active'          => 1,
					'created_at'      => $ahora,
				),
				array( '%s', '%d', '%s', '%s', '%s', '%d', '%s' )
			);
			if ( false !== $insertado ) {
				$code = $candidato;
				break;
			}
		}
		if ( null === $code ) {
			return new WP_Error(
				'ns_aulas_code_colision',
				'No se pudo generar un código único para el aula.',
				array( 'status' => 503 )
			);
		}

		$classroom_id = (int) $wpdb->insert_id;

		$respuesta = new WP_REST_Response(
			array(
				'classroom_id' => $classroom_id,
				'code'         => $code,
				'name'         => $name,
				'language'     => $language,
				'game_ids'     => $game_ids,
				'active'       => true,
				'created_at'   => $ahora,
			),
			201
		);
		$respuesta->header(
			'Location',
			sprintf( '/wp-json/nuevo-ser/v1/classrooms/%d', $classroom_id )
		);
		return $respuesta;
	}

	/**
	 * Validación pura del input de creación. No toca DB — sólo
	 * shape, longitudes y tipos. La comprobación de que cada
	 * `game_id` exista en `ns_games` la hace `crear_aula` directamente.
	 *
	 * @param string|null $name
	 * @param string|null $language
	 * @param mixed       $game_ids
	 * @return array<string,string> `campo => motivo`. Vacío si OK.
	 */
	public static function validar_input_creacion(
		?string $name,
		?string $language,
		$game_ids
	): array {
		$campos_invalidos = array();

		if ( null === $name || '' === trim( (string) $name ) ) {
			$campos_invalidos['name'] = 'requerido';
		} elseif ( strlen( $name ) > self::MAX_NOMBRE ) {
			$campos_invalidos['name'] = 'demasiado_largo';
		}

		if ( null !== $language && strlen( $language ) > self::MAX_IDIOMA ) {
			$campos_invalidos['language'] = 'demasiado_largo';
		}

		if ( ! is_array( $game_ids ) || empty( $game_ids ) ) {
			$campos_invalidos['game_ids'] = 'requerido';
		} else {
			foreach ( $game_ids as $candidato ) {
				if ( ! is_string( $candidato ) || '' === trim( $candidato ) ) {
					$campos_invalidos['game_ids'] = 'formato_invalido';
					break;
				}
			}
		}

		return $campos_invalidos;
	}

	/**
	 * Genera un code aleatorio de 6 caracteres del alfabeto sin
	 * confusiones visuales (ABCDEFGHJKLMNPQRSTUVWXYZ23456789 — 32
	 * chars, sin O/0/I/1). Pura — usa `random_int` que es
	 * criptográficamente seguro y disponible desde PHP 7.0.
	 *
	 * Espacio total: 32^6 ≈ 1.07 · 10⁹. La probabilidad de colisión
	 * con 1.000 aulas activas es ~5 · 10⁻⁴ (paradoja del cumpleaños);
	 * el INSERT con UNIQUE KEY protege en cualquier caso.
	 */
	public static function generar_codigo(): string {
		$alfabeto = self::ALFABETO_CODE;
		$longitud_alfabeto = strlen( $alfabeto );
		$resultado = '';
		for ( $i = 0; $i < self::LONGITUD_CODE_GENERADO; $i++ ) {
			$resultado .= $alfabeto[ random_int( 0, $longitud_alfabeto - 1 ) ];
		}
		return $resultado;
	}

	/**
	 * Valida el formato del código del aula. Pura — testeable sin WP.
	 * No comprueba existencia (eso requiere DB).
	 *
	 * @return array<string,string> `campo => motivo`. Vacío si OK.
	 */
	public static function validar_codigo( string $code ): array {
		$campos_invalidos = array();
		$normalizado      = strtoupper( trim( $code ) );

		if ( '' === $normalizado ) {
			$campos_invalidos['code'] = 'requerido';
			return $campos_invalidos;
		}

		$longitud = strlen( $normalizado );
		if ( $longitud < self::MIN_CODE || $longitud > self::MAX_CODE ) {
			$campos_invalidos['code'] = 'longitud_invalida';
			return $campos_invalidos;
		}

		if ( ! preg_match( '/^[A-Z0-9]+$/', $normalizado ) ) {
			$campos_invalidos['code'] = 'formato_invalido';
		}

		return $campos_invalidos;
	}

	/**
	 * `game_ids` se guarda como LONGTEXT JSON. Si está corrupto o
	 * vacío, se devuelve lista vacía (auto-curación) en lugar de
	 * romper el join — el aula sigue siendo válida aunque su lista de
	 * juegos sea ilegible.
	 *
	 * @param mixed $crudo
	 * @return array<int,string>
	 */
	private static function decodificar_lista_games( $crudo ): array {
		if ( null === $crudo || '' === $crudo ) {
			return array();
		}
		$decodificado = json_decode( (string) $crudo, true );
		if ( ! is_array( $decodificado ) ) {
			return array();
		}
		// Forzamos que sean strings (los game_ids viven en VARCHAR de
		// `ns_games`); descartamos shapes inesperados.
		$resultado = array();
		foreach ( $decodificado as $valor ) {
			if ( is_string( $valor ) && '' !== $valor ) {
				$resultado[] = $valor;
			}
		}
		return $resultado;
	}

	private static function error_validacion( string $code, string $mensaje, array $data = array() ): WP_Error {
		return new WP_Error(
			$code,
			$mensaje,
			array_merge( array( 'status' => 400 ), $data )
		);
	}
}
