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
				'qualitative_feedback' => $qualitative_feedback_raw === null ? null : wp_json_encode( $qualitative_feedback_raw ),
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
