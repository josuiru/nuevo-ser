<?php
/**
 * Endpoints específicos del juego El Cuaderno (doc 03 §5.3).
 *
 * Bajo `/wp-json/nuevo-ser/v1/el-cuaderno/*`. Expone tres rutas:
 *
 *   POST /el-cuaderno/observaciones  → registra observación (metadatos
 *                                       únicamente; el texto libre del
 *                                       niño NUNCA viaja al servidor —
 *                                       lo que llega es `what_seen_hash`,
 *                                       sha256 calculado en cliente).
 *   POST /el-cuaderno/sit-spot       → establece o jubila el sit spot
 *                                       activo del niño.
 *   GET  /el-cuaderno/misterios      → devuelve el catálogo filtrado
 *                                       por region_code y season.
 *
 * Frontera de privacidad: doc 03 §3.3 + §7.1. Aquí solo entran
 * metadatos. Si un cliente intenta enviar `what_seen` en claro, se
 * rechaza con 400.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_El_Cuaderno {

	/** Confianzas válidas en una observación (doc 03 §3.1). */
	private const CONFIANZAS_OBSERVACION = array(
		'consenso',
		'hipotesis_activa',
		'no_segura',
	);

	/** Estados válidos de un Misterio (doc 03 §3.1). */
	private const ESTADOS_MISTERIO = array(
		'consenso',
		'hipotesis_activa',
		'abandonado',
	);

	/**
	 * POST /el-cuaderno/observaciones
	 *
	 * Body esperado (todos los strings; los hashes y UUIDs los hace
	 * el cliente):
	 *
	 *   uuid             CHAR(36)  — UUID v4. Idempotency key.
	 *   occurred_at      ISO-8601  — cuándo ocurrió la observación.
	 *   place_name       string    — nombre que el niño le pone al lugar.
	 *   region_code      string    — NUTS-3 (p.e. 'ES-NA-PA').
	 *   what_seen_hash   string    — sha256 hex del texto libre. NO el texto.
	 *   proposed_id      string?   — identificación propuesta. Opcional.
	 *   confidence       string    — consenso | hipotesis_activa | no_segura.
	 *   misterio_id      string?   — anclaje opcional.
	 *   sit_spot_id      string?   — UUID del sit spot si aplica.
	 *   has_photo        bool      — la app tiene foto en local.
	 *   has_drawing      bool      — la app tiene dibujo en local.
	 *
	 * Idempotente por `uuid` con índice único: reintento del mismo
	 * UUID devuelve 200 (no 409) porque la cola de sync del cliente
	 * confía en este comportamiento.
	 */
	public static function crear_observacion( WP_REST_Request $request ) {
		global $wpdb;

		$nino_id = (int) $request->get_param( '_nino_id' );
		if ( $nino_id <= 0 ) {
			return new WP_Error(
				'ns_el_cuaderno_sin_nino',
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

		// Si llega `what_seen` (texto en claro), rechazar — la
		// frontera de privacidad lo prohíbe (doc 03 §3.3).
		if ( array_key_exists( 'what_seen', $body ) ) {
			return self::error_validacion(
				'what_seen_no_permitido',
				'El servidor solo acepta what_seen_hash. El texto libre '
					. 'del niño nunca cruza red — calcula sha256 en el cliente.'
			);
		}

		$campos_invalidos = self::validar_observacion( $body );
		if ( ! empty( $campos_invalidos ) ) {
			return self::error_validacion(
				'campos_invalidos',
				'Algunos campos no pasan la validación.',
				array( 'invalid_fields' => $campos_invalidos )
			);
		}

		$tabla = NS_Esquema::nombre_tabla( 'el_cuaderno_observaciones' );

		$uuid = (string) $body['uuid'];

		// Idempotencia: si ya existe el UUID, devolver 200 con el id.
		$existente = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT id, occurred_at FROM {$tabla} WHERE uuid = %s",
				$uuid
			),
			ARRAY_A
		);
		if ( null !== $existente ) {
			$respuesta = new WP_REST_Response(
				array(
					'id'          => (int) $existente['id'],
					'uuid'        => $uuid,
					'occurred_at' => (string) $existente['occurred_at'],
					'idempotent'  => true,
				),
				200
			);
			$respuesta->header(
				'Location',
				rest_url( "nuevo-ser/v1/el-cuaderno/observaciones/{$existente['id']}" )
			);
			return $respuesta;
		}

		$ahora        = gmdate( 'Y-m-d H:i:s' );
		$occurred_at  = self::a_datetime_mysql( (string) $body['occurred_at'] );
		$weather_raw  = $body['weather'] ?? null;
		$shared_with  = $body['shared_with'] ?? null;

		$insertado = $wpdb->insert(
			$tabla,
			array(
				'uuid'            => $uuid,
				'user_id'         => $nino_id,
				'game_id'         => 'el-cuaderno',
				'created_at'      => $ahora,
				'occurred_at'     => $occurred_at,
				'place_name'      => (string) ( $body['place_name'] ?? '' ),
				'region_code'     => (string) ( $body['region_code'] ?? '' ),
				'weather_json'    => $weather_raw === null ? null : wp_json_encode( $weather_raw ),
				'what_seen_hash'  => strtolower( (string) $body['what_seen_hash'] ),
				'proposed_id'     => (string) ( $body['proposed_id'] ?? '' ),
				'confidence'      => (string) $body['confidence'],
				'has_photo'       => empty( $body['has_photo'] ) ? 0 : 1,
				'has_drawing'     => empty( $body['has_drawing'] ) ? 0 : 1,
				'photo_blob_id'   => (string) ( $body['photo_blob_id'] ?? '' ),
				'drawing_blob_id' => (string) ( $body['drawing_blob_id'] ?? '' ),
				'misterio_id'     => (string) ( $body['misterio_id'] ?? '' ),
				'sit_spot_id'     => (string) ( $body['sit_spot_id'] ?? '' ),
				'shared_with'     => $shared_with === null ? null : wp_json_encode( $shared_with ),
			),
			array(
				'%s', '%d', '%s', '%s', '%s', '%s', '%s', '%s', '%s',
				'%s', '%s', '%d', '%d', '%s', '%s', '%s', '%s', '%s',
			)
		);

		if ( false === $insertado ) {
			return new WP_Error(
				'ns_el_cuaderno_insert_error',
				'No se pudo guardar la observación.',
				array( 'status' => 500 )
			);
		}

		$id = (int) $wpdb->insert_id;

		$respuesta = new WP_REST_Response(
			array(
				'id'          => $id,
				'uuid'        => $uuid,
				'occurred_at' => $occurred_at,
				'idempotent'  => false,
			),
			201
		);
		$respuesta->header(
			'Location',
			rest_url( "nuevo-ser/v1/el-cuaderno/observaciones/{$id}" )
		);
		return $respuesta;
	}

	/**
	 * POST /el-cuaderno/sit-spot
	 *
	 * Body esperado:
	 *
	 *   uuid         CHAR(36)
	 *   name         string  — el nombre que el niño le pone.
	 *   region_code  string  — NUTS-3.
	 *   retire       bool?   — si true, jubila el sit spot.
	 *
	 * El MVP solo permite **un sit spot activo por niño** (biblia §5.1).
	 * Si la niña activa uno nuevo y ya había otro, el viejo recibe
	 * `retired_at = ahora` automáticamente y el nuevo queda como activo.
	 *
	 * Idempotente por `uuid`. Reintento del mismo UUID devuelve 200.
	 */
	public static function establecer_sit_spot( WP_REST_Request $request ) {
		global $wpdb;

		$nino_id = (int) $request->get_param( '_nino_id' );
		if ( $nino_id <= 0 ) {
			return new WP_Error(
				'ns_el_cuaderno_sin_nino',
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

		$campos_invalidos = self::validar_sit_spot( $body );
		if ( ! empty( $campos_invalidos ) ) {
			return self::error_validacion(
				'campos_invalidos',
				'Algunos campos no pasan la validación.',
				array( 'invalid_fields' => $campos_invalidos )
			);
		}

		$tabla = NS_Esquema::nombre_tabla( 'el_cuaderno_sit_spots' );
		$uuid  = (string) $body['uuid'];

		$ahora = gmdate( 'Y-m-d H:i:s' );

		$existente = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT id, retired_at FROM {$tabla} WHERE uuid = %s AND user_id = %d",
				$uuid,
				$nino_id
			),
			ARRAY_A
		);

		if ( null !== $existente ) {
			// Idempotente: el cliente está reenviando el mismo sit spot.
			return new WP_REST_Response(
				array(
					'id'         => (int) $existente['id'],
					'uuid'       => $uuid,
					'idempotent' => true,
					'retired_at' => $existente['retired_at'],
				),
				200
			);
		}

		// Si llega un sit spot nuevo y ya había otro activo, el otro
		// pasa a retirado. Doc 13 §2.6: "El Roble Grande seguirá en
		// tu cuaderno como página". La página la pinta el cliente; el
		// servidor solo marca `retired_at`.
		$wpdb->query(
			$wpdb->prepare(
				"UPDATE {$tabla}
				 SET retired_at = %s
				 WHERE user_id = %d
				   AND game_id = 'el-cuaderno'
				   AND retired_at IS NULL",
				$ahora,
				$nino_id
			)
		);

		$insertado = $wpdb->insert(
			$tabla,
			array(
				'uuid'        => $uuid,
				'user_id'     => $nino_id,
				'game_id'     => 'el-cuaderno',
				'name'        => (string) $body['name'],
				'region_code' => (string) ( $body['region_code'] ?? '' ),
				'created_at'  => $ahora,
			),
			array( '%s', '%d', '%s', '%s', '%s', '%s' )
		);

		if ( false === $insertado ) {
			return new WP_Error(
				'ns_el_cuaderno_sit_spot_error',
				'No se pudo guardar el sit spot.',
				array( 'status' => 500 )
			);
		}

		$id = (int) $wpdb->insert_id;

		$respuesta = new WP_REST_Response(
			array(
				'id'         => $id,
				'uuid'       => $uuid,
				'idempotent' => false,
			),
			201
		);
		$respuesta->header(
			'Location',
			rest_url( "nuevo-ser/v1/el-cuaderno/sit-spot/{$id}" )
		);
		return $respuesta;
	}

	/**
	 * GET /el-cuaderno/misterios
	 *
	 * Query params:
	 *   region   (opcional): NUTS-3, filtra el catálogo a Misterios
	 *                        que aplican a esa región.
	 *   season   (opcional): otono | invierno | primavera | verano |
	 *                        todo_el_anio.
	 *
	 * Devuelve un array de Misterios desde el catálogo embebido en
	 * el plugin. El catálogo crece hasta 60-80 Misterios cuando
	 * lleguen los lotes 2-5 redactados con doc 14; en S2 sirve los 2
	 * de muestra del seed del cliente para que el cableado funcione
	 * end-to-end.
	 *
	 * TODO #6 (memoria `decisiones_humanas_pendientes` ítem 6):
	 * verificación científica de los `[DATO A VERIFICAR]` con
	 * SEO/BirdLife, RJB-CSIC. Hasta entonces el catálogo no debe
	 * aumentar más allá de los Misterios ya validados por el equipo.
	 */
	public static function listar_misterios( WP_REST_Request $request ) {
		$region = trim( (string) $request->get_param( 'region' ) );
		$season = trim( (string) $request->get_param( 'season' ) );

		$catalogo = self::catalogo_misterios_embebido();

		$filtrados = array();
		foreach ( $catalogo as $misterio ) {
			if ( '' !== $region && ! self::aplica_a_region( $misterio, $region ) ) {
				continue;
			}
			if ( '' !== $season && ! self::aplica_a_season( $misterio, $season ) ) {
				continue;
			}
			$filtrados[] = $misterio;
		}

		return new WP_REST_Response(
			array(
				'misterios'       => $filtrados,
				'catalogo_total'  => count( $catalogo ),
				'aplican_filtros' => count( $filtrados ),
			),
			200
		);
	}

	/**
	 * Catálogo embebido de Misterios. Espejo PHP de un subconjunto del
	 * doc `catalogo-seminal-misterios.md`. La forma sigue lo que el
	 * cliente Dart espera (camelCase en JSON cliente / snake_case en
	 * BD; aquí se sirve snake_case).
	 *
	 * @return array<int,array<string,mixed>>
	 */
	private static function catalogo_misterios_embebido(): array {
		return array(
			array(
				'code'             => 'MIST.AVES.GOLONDRINAS_OTONO',
				'pregunta_es'      => '¿Cuándo se van las golondrinas de tu barrio?',
				'descripcion_es'   => 'Cada año las golondrinas vuelan al sur en otoño. La fecha cambia según el lugar y el año. ¿Las has visto este verano cerca de tu casa? ¿Cuándo dejaste de verlas?',
				'estado'           => 'hipotesis_activa',
				'season'           => array( 'verano', 'otono' ),
				'region_filter'    => null,
			),
			array(
				'code'             => 'MIST.LLUVIA.QUE_APARECE',
				'pregunta_es'      => 'Después de llover, ¿qué seres vivos aparecen que no estaban antes?',
				'descripcion_es'   => 'Después de una lluvia buena, salen seres que no estaban antes. Sal a tu sit spot o a un parque cuando pare de llover y mira. ¿Qué encuentras? ¿Por qué crees que salen ahora y no antes?',
				'estado'           => 'hipotesis_activa',
				'season'           => array( 'todo_el_anio' ),
				'region_filter'    => null,
			),
		);
	}

	public static function aplica_a_region( array $misterio, string $region ): bool {
		$filter = $misterio['region_filter'] ?? null;
		if ( null === $filter || ! is_array( $filter ) ) {
			return true; // catálogo sin filtro de región = global
		}
		// Match por prefijo: ES-NA-PA cae dentro de ES-NA y de ES.
		foreach ( $filter as $prefijo ) {
			if ( '' === $prefijo ) {
				continue;
			}
			if ( str_starts_with( $region, (string) $prefijo ) ) {
				return true;
			}
		}
		return false;
	}

	public static function aplica_a_season( array $misterio, string $season ): bool {
		$seasons = $misterio['season'] ?? array();
		if ( ! is_array( $seasons ) || empty( $seasons ) ) {
			return true;
		}
		if ( in_array( 'todo_el_anio', $seasons, true ) ) {
			return true;
		}
		return in_array( $season, $seasons, true );
	}

	/**
	 * @param array<string,mixed> $body
	 * @return array<string,string>
	 */
	public static function validar_observacion( array $body ): array {
		$invalidos = array();

		$uuid = isset( $body['uuid'] ) ? trim( (string) $body['uuid'] ) : '';
		if ( '' === $uuid || ! preg_match( '/^[0-9a-f-]{32,36}$/i', $uuid ) ) {
			$invalidos['uuid'] = 'invalid';
		}

		if ( ! isset( $body['occurred_at'] ) || '' === trim( (string) $body['occurred_at'] ) ) {
			$invalidos['occurred_at'] = 'requerido';
		}

		$hash = isset( $body['what_seen_hash'] ) ? trim( (string) $body['what_seen_hash'] ) : '';
		if ( '' === $hash || ! preg_match( '/^[0-9a-f]{64}$/i', $hash ) ) {
			$invalidos['what_seen_hash'] = 'sha256_hex_requerido';
		}

		$confidence = isset( $body['confidence'] ) ? (string) $body['confidence'] : '';
		if ( ! in_array( $confidence, self::CONFIANZAS_OBSERVACION, true ) ) {
			$invalidos['confidence'] = 'valor_invalido';
		}

		// `region_code` opcional pero si llega tiene que parecer NUTS.
		$region = isset( $body['region_code'] ) ? trim( (string) $body['region_code'] ) : '';
		if ( '' !== $region && ! preg_match( '/^[A-Z]{2}(-[A-Z0-9]{1,4}){0,3}$/', $region ) ) {
			$invalidos['region_code'] = 'formato_invalido';
		}

		// `place_name` opcional pero si está, no demasiado largo.
		$place = isset( $body['place_name'] ) ? trim( (string) $body['place_name'] ) : '';
		if ( strlen( $place ) > 255 ) {
			$invalidos['place_name'] = 'demasiado_largo';
		}

		return $invalidos;
	}

	/**
	 * @param array<string,mixed> $body
	 * @return array<string,string>
	 */
	public static function validar_sit_spot( array $body ): array {
		$invalidos = array();

		$uuid = isset( $body['uuid'] ) ? trim( (string) $body['uuid'] ) : '';
		if ( '' === $uuid || ! preg_match( '/^[0-9a-f-]{32,36}$/i', $uuid ) ) {
			$invalidos['uuid'] = 'invalid';
		}

		$name = isset( $body['name'] ) ? trim( (string) $body['name'] ) : '';
		if ( '' === $name ) {
			$invalidos['name'] = 'requerido';
		} elseif ( strlen( $name ) > 255 ) {
			$invalidos['name'] = 'demasiado_largo';
		}

		$region = isset( $body['region_code'] ) ? trim( (string) $body['region_code'] ) : '';
		if ( '' !== $region && ! preg_match( '/^[A-Z]{2}(-[A-Z0-9]{1,4}){0,3}$/', $region ) ) {
			$invalidos['region_code'] = 'formato_invalido';
		}

		return $invalidos;
	}

	private static function a_datetime_mysql( string $iso ): string {
		// Acepta ISO-8601 con o sin sufijo Z/UTC offset. Convertimos a
		// UTC y devolvemos en formato MySQL.
		$timestamp = strtotime( $iso );
		if ( false === $timestamp ) {
			$timestamp = time();
		}
		return gmdate( 'Y-m-d H:i:s', $timestamp );
	}

	private static function error_validacion(
		string $code,
		string $mensaje,
		array $data = array()
	): WP_Error {
		return new WP_Error(
			$code,
			$mensaje,
			array_merge( array( 'status' => 400 ), $data )
		);
	}
}
