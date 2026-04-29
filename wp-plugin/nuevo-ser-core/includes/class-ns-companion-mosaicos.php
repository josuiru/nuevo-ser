<?php
/**
 * Endpoints de Mosaicos (`/companion/mosaicos`).
 *
 * Un mosaico es el "trabajo final" de un arco: el niño lo crea cuando
 * termina (de ahí `completed_at` en lugar de `created_at`/`updated_at`).
 * Anclado obligatoriamente a un `arc_id` y, opcionalmente, a habilidades
 * (`required_anchors`/`fulfilled_anchors`).
 *
 * Hermano de NS_Companion_Cuaderno: misma forma de validación pura +
 * comprobación de existencia con DB, mismo error 400 con `invalid_fields`.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Companion_Mosaicos {

	/** Longitud máxima de `arc_id`. Coincide con el VARCHAR(64) de la tabla. */
	private const MAX_ARC_ID = 64;

	/** Longitud máxima de `format`. Coincide con el VARCHAR(32) de la tabla. */
	private const MAX_FORMAT = 32;

	/** Longitud máxima de `title`. Coincide con el VARCHAR(255) de la tabla. */
	private const MAX_TITLE = 255;

	/** Longitud máxima de `content_ref`. Coincide con el VARCHAR(255) de la tabla. */
	private const MAX_CONTENT_REF = 255;

	/** Tope superior del parámetro `limit` en el listado. */
	public const MAX_LIMIT = 100;

	/** Valor por defecto de `limit` cuando el cliente no lo pasa. */
	public const DEFAULT_LIMIT = 20;

	/**
	 * POST /companion/mosaicos
	 *
	 * Inserta un mosaico recién terminado para el niño dueño del JWT.
	 * `completed_at` lo pone el servidor — un mosaico que llega aquí está,
	 * por definición, terminado. El sharing (con aulas o cuidadores) NO
	 * se acepta en este endpoint todavía, igual que en cuaderno.
	 *
	 * @param WP_REST_Request $request
	 * @return WP_REST_Response|WP_Error
	 */
	public static function crear_mosaico( WP_REST_Request $request ) {
		global $wpdb;

		$nino_id = (int) $request->get_param( '_nino_id' );
		if ( $nino_id <= 0 ) {
			return new WP_Error(
				'ns_mosaicos_sin_nino',
				'Falta el identificador del niño en el token.',
				array( 'status' => 401 )
			);
		}

		$body = $request->get_json_params();
		if ( ! is_array( $body ) ) {
			return self::error_validacion( 'body_no_es_objeto', 'El cuerpo de la petición debe ser un objeto JSON.' );
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

		$arc_id                   = trim( (string) $body['arc_id'] );
		$format                   = isset( $body['format'] ) ? trim( (string) $body['format'] ) : '';
		$title                    = trim( (string) $body['title'] );
		$content_ref              = isset( $body['content_ref'] ) ? trim( (string) $body['content_ref'] ) : '';
		$content_meta_raw         = $body['content_meta'] ?? null;
		$required_anchors_raw     = $body['required_anchors'] ?? null;
		$fulfilled_anchors_raw    = $body['fulfilled_anchors'] ?? null;
		$qualitative_feedback_raw = $body['qualitative_feedback'] ?? null;

		$tabla = NS_Esquema::nombre_tabla( 'mosaicos' );
		$ahora = gmdate( 'Y-m-d H:i:s' );

		$insertado = $wpdb->insert(
			$tabla,
			array(
				'user_id'              => $nino_id,
				'game_id'              => $game_id,
				'arc_id'               => $arc_id,
				'format'               => $format,
				'title'                => $title,
				'content_ref'          => $content_ref,
				'content_meta'         => $content_meta_raw === null ? null : wp_json_encode( $content_meta_raw ),
				'required_anchors'     => $required_anchors_raw === null ? null : wp_json_encode( $required_anchors_raw ),
				'fulfilled_anchors'    => $fulfilled_anchors_raw === null ? null : wp_json_encode( $fulfilled_anchors_raw ),
				'qualitative_feedback' => $qualitative_feedback_raw === null ? null : (string) $qualitative_feedback_raw,
				'completed_at'         => $ahora,
			),
			array( '%d', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s' )
		);

		if ( false === $insertado ) {
			return new WP_Error(
				'ns_mosaicos_insert_error',
				'No se pudo guardar el mosaico.',
				array( 'status' => 500 )
			);
		}

		$id = (int) $wpdb->insert_id;

		$respuesta = new WP_REST_Response(
			array(
				'id'           => $id,
				'game_id'      => $game_id,
				'arc_id'       => $arc_id,
				'format'       => $format,
				'title'        => $title,
				'content_ref'  => $content_ref,
				'completed_at' => $ahora,
			),
			201
		);
		$respuesta->header( 'Location', rest_url( "nuevo-ser/v1/companion/mosaicos/{$id}" ) );
		return $respuesta;
	}

	/**
	 * GET /companion/mosaicos
	 *
	 * Lista los mosaicos del niño dueño del JWT, ordenados de más
	 * reciente a más antiguo por `completed_at`. Sólo se devuelven los
	 * suyos — `user_id` está hardcodeado al `nino_id` del token.
	 *
	 * Query params:
	 *   - `game_id` (opcional): filtra por juego (debe existir en `ns_games`).
	 *   - `arc_id` (opcional): filtra por arco.
	 *   - `limit` (opcional, default 20, max 100).
	 *   - `offset` (opcional, default 0).
	 *
	 * Devuelve `{ entries: [...], total: N, limit, offset }` — misma
	 * envoltura que el listado del cuaderno para que el cliente no tenga
	 * que conocer dos shapes de paginación.
	 *
	 * @param WP_REST_Request $request
	 * @return WP_REST_Response|WP_Error
	 */
	public static function listar_mosaicos( WP_REST_Request $request ) {
		global $wpdb;

		$nino_id = (int) $request->get_param( '_nino_id' );
		if ( $nino_id <= 0 ) {
			return new WP_Error(
				'ns_mosaicos_sin_nino',
				'Falta el identificador del niño en el token.',
				array( 'status' => 401 )
			);
		}

		$query = array(
			'game_id' => $request->get_param( 'game_id' ),
			'arc_id'  => $request->get_param( 'arc_id' ),
			'limit'   => $request->get_param( 'limit' ),
			'offset'  => $request->get_param( 'offset' ),
		);
		$validacion = self::validar_query_listado( $query );
		if ( ! empty( $validacion['campos_invalidos'] ) ) {
			return self::error_validacion(
				'campos_invalidos',
				'Algunos parámetros de la consulta no pasan la validación.',
				array( 'invalid_fields' => $validacion['campos_invalidos'] )
			);
		}

		$game_id = $validacion['game_id'];
		$arc_id  = $validacion['arc_id'];
		$limit   = $validacion['limit'];
		$offset  = $validacion['offset'];

		if ( '' !== $game_id && ! self::juego_existe( $game_id ) ) {
			return self::error_validacion(
				'campos_invalidos',
				'Algunos parámetros de la consulta no pasan la validación.',
				array( 'invalid_fields' => array( 'game_id' => 'no_existe' ) )
			);
		}

		$tabla = NS_Esquema::nombre_tabla( 'mosaicos' );

		// Construimos los filtros dinámicamente para no duplicar 4
		// variantes de SQL como en cuaderno (game_id ↔ no game_id).
		$where     = array( 'user_id = %d' );
		$args_base = array( $nino_id );
		if ( '' !== $game_id ) {
			$where[]     = 'game_id = %s';
			$args_base[] = $game_id;
		}
		if ( '' !== $arc_id ) {
			$where[]     = 'arc_id = %s';
			$args_base[] = $arc_id;
		}
		$where_sql = implode( ' AND ', $where );

		// phpcs:ignore WordPress.DB.PreparedSQL.InterpolatedNotPrepared
		$sql_total = $wpdb->prepare( "SELECT COUNT(*) FROM {$tabla} WHERE {$where_sql}", $args_base );

		$args_lista   = $args_base;
		$args_lista[] = $limit;
		$args_lista[] = $offset;
		// phpcs:ignore WordPress.DB.PreparedSQL.InterpolatedNotPrepared
		$sql_lista = $wpdb->prepare(
			"SELECT id, user_id, game_id, arc_id, format, title, content_ref, content_meta, required_anchors, fulfilled_anchors, qualitative_feedback, completed_at
			 FROM {$tabla}
			 WHERE {$where_sql}
			 ORDER BY completed_at DESC, id DESC
			 LIMIT %d OFFSET %d",
			$args_lista
		);

		$total = (int) $wpdb->get_var( $sql_total );
		$filas = $wpdb->get_results( $sql_lista, ARRAY_A );
		if ( ! is_array( $filas ) ) {
			$filas = array();
		}

		$entries = array_map( array( __CLASS__, 'serializar_fila' ), $filas );

		return new WP_REST_Response(
			array(
				'entries' => $entries,
				'total'   => $total,
				'limit'   => $limit,
				'offset'  => $offset,
			),
			200
		);
	}

	/**
	 * Convierte una fila cruda de la DB en la forma JSON que el cliente
	 * espera: claves snake_case, content_meta/required_anchors/
	 * fulfilled_anchors/qualitative_feedback deserializados de su
	 * LONGTEXT.
	 *
	 * @param array<string,mixed> $fila
	 * @return array<string,mixed>
	 */
	private static function serializar_fila( array $fila ): array {
		return array(
			'id'                   => (int) $fila['id'],
			'game_id'              => (string) $fila['game_id'],
			'arc_id'               => (string) $fila['arc_id'],
			'format'               => (string) $fila['format'],
			'title'                => (string) $fila['title'],
			'content_ref'          => (string) $fila['content_ref'],
			'content_meta'         => self::decodificar_json( $fila['content_meta'] ?? null ),
			'required_anchors'     => self::decodificar_json( $fila['required_anchors'] ?? null ),
			'fulfilled_anchors'    => self::decodificar_json( $fila['fulfilled_anchors'] ?? null ),
			'qualitative_feedback' => isset( $fila['qualitative_feedback'] ) && '' !== $fila['qualitative_feedback']
				? (string) $fila['qualitative_feedback']
				: null,
			'completed_at'         => (string) $fila['completed_at'],
		);
	}

	/**
	 * Devuelve null si el valor es null/cadena vacía/JSON inválido — la
	 * corrupción puntual de un campo no debe romper el listado entero.
	 *
	 * @param mixed $crudo
	 * @return array<int|string,mixed>|null
	 */
	private static function decodificar_json( $crudo ) {
		if ( null === $crudo || '' === $crudo ) {
			return null;
		}
		$decodificado = json_decode( (string) $crudo, true );
		if ( ! is_array( $decodificado ) ) {
			return null;
		}
		return $decodificado;
	}

	/**
	 * Valida y normaliza los parámetros del listado. Pura — testeable
	 * sin WP. Devuelve `['campos_invalidos' => [...], 'game_id' => str,
	 * 'arc_id' => str, 'limit' => int, 'offset' => int]`.
	 *
	 * @param array{game_id:mixed, arc_id:mixed, limit:mixed, offset:mixed} $query
	 * @return array{campos_invalidos:array<string,string>, game_id:string, arc_id:string, limit:int, offset:int}
	 */
	public static function validar_query_listado( array $query ): array {
		$campos_invalidos = array();

		$game_id = isset( $query['game_id'] ) ? trim( (string) $query['game_id'] ) : '';
		$arc_id  = isset( $query['arc_id'] ) ? trim( (string) $query['arc_id'] ) : '';
		if ( strlen( $arc_id ) > self::MAX_ARC_ID ) {
			$campos_invalidos['arc_id'] = 'demasiado_largo';
			$arc_id                     = '';
		}

		$limit_raw = $query['limit'] ?? null;
		if ( $limit_raw === null || $limit_raw === '' ) {
			$limit = self::DEFAULT_LIMIT;
		} elseif ( is_numeric( $limit_raw ) && (int) $limit_raw == (float) $limit_raw ) {
			$limit = (int) $limit_raw;
			if ( $limit < 1 || $limit > self::MAX_LIMIT ) {
				$campos_invalidos['limit'] = 'fuera_de_rango';
				$limit                     = self::DEFAULT_LIMIT;
			}
		} else {
			$campos_invalidos['limit'] = 'no_es_entero';
			$limit                     = self::DEFAULT_LIMIT;
		}

		$offset_raw = $query['offset'] ?? null;
		if ( $offset_raw === null || $offset_raw === '' ) {
			$offset = 0;
		} elseif ( is_numeric( $offset_raw ) && (int) $offset_raw == (float) $offset_raw ) {
			$offset = (int) $offset_raw;
			if ( $offset < 0 ) {
				$campos_invalidos['offset'] = 'fuera_de_rango';
				$offset                     = 0;
			}
		} else {
			$campos_invalidos['offset'] = 'no_es_entero';
			$offset                     = 0;
		}

		return array(
			'campos_invalidos' => $campos_invalidos,
			'game_id'          => $game_id,
			'arc_id'           => $arc_id,
			'limit'            => $limit,
			'offset'           => $offset,
		);
	}

	/**
	 * Valida el shape del body sin tocar la DB. Pura — testeable sin WP.
	 * Devuelve `clave_de_campo => motivo_de_fallo`. Si está vacío, los
	 * formatos son aceptables (queda comprobar la existencia de `game_id`
	 * con DB, que va aparte).
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

		$arc_id = isset( $body['arc_id'] ) ? trim( (string) $body['arc_id'] ) : '';
		if ( '' === $arc_id ) {
			$campos_invalidos['arc_id'] = 'requerido';
		} elseif ( strlen( $arc_id ) > self::MAX_ARC_ID ) {
			$campos_invalidos['arc_id'] = 'demasiado_largo';
		}

		$format = isset( $body['format'] ) ? trim( (string) $body['format'] ) : '';
		if ( strlen( $format ) > self::MAX_FORMAT ) {
			$campos_invalidos['format'] = 'demasiado_largo';
		} elseif ( $format !== '' && ! preg_match( '/^[a-z0-9_]+$/', $format ) ) {
			$campos_invalidos['format'] = 'formato_invalido';
		}

		$title = isset( $body['title'] ) ? trim( (string) $body['title'] ) : '';
		if ( '' === $title ) {
			$campos_invalidos['title'] = 'requerido';
		} elseif ( strlen( $title ) > self::MAX_TITLE ) {
			$campos_invalidos['title'] = 'demasiado_largo';
		}

		$content_ref = isset( $body['content_ref'] ) ? trim( (string) $body['content_ref'] ) : '';
		if ( strlen( $content_ref ) > self::MAX_CONTENT_REF ) {
			$campos_invalidos['content_ref'] = 'demasiado_largo';
		}

		if ( array_key_exists( 'content_meta', $body ) && $body['content_meta'] !== null && ! is_array( $body['content_meta'] ) ) {
			$campos_invalidos['content_meta'] = 'debe_ser_objeto';
		}

		// `required_anchors` y `fulfilled_anchors` pueden ser lista (de
		// IDs de habilidad) u objeto (con metadatos por habilidad). En
		// PHP, `is_array` cubre ambas formas; lo que no aceptamos son
		// strings o números sueltos.
		if ( array_key_exists( 'required_anchors', $body ) && $body['required_anchors'] !== null && ! is_array( $body['required_anchors'] ) ) {
			$campos_invalidos['required_anchors'] = 'debe_ser_lista_u_objeto';
		}

		if ( array_key_exists( 'fulfilled_anchors', $body ) && $body['fulfilled_anchors'] !== null && ! is_array( $body['fulfilled_anchors'] ) ) {
			$campos_invalidos['fulfilled_anchors'] = 'debe_ser_lista_u_objeto';
		}

		if ( array_key_exists( 'qualitative_feedback', $body ) && $body['qualitative_feedback'] !== null && ! is_string( $body['qualitative_feedback'] ) ) {
			$campos_invalidos['qualitative_feedback'] = 'debe_ser_string';
		}

		return $campos_invalidos;
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
