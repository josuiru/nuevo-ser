<?php
/**
 * Endpoints de Cuaderno (`/companion/cuaderno/*`).
 *
 * Primer trozo del paquete companion (doc nuevo-ser-core-arquitectura.md
 * §7) que sale del estado 501 reservado y pasa a respuesta real.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Companion_Cuaderno {

	/** Longitud máxima del campo `type`. Coincide con el VARCHAR(32) de la tabla. */
	private const MAX_TYPE = 32;

	/** Longitud máxima de `title`. Coincide con el VARCHAR(255) de la tabla. */
	private const MAX_TITLE = 255;

	/** Longitud máxima de `content_ref`. Coincide con el VARCHAR(255) de la tabla. */
	private const MAX_CONTENT_REF = 255;

	/**
	 * POST /companion/cuaderno/entries
	 *
	 * Inserta una nueva entrada del cuaderno para el niño dueño del JWT.
	 * El sharing (con aulas o cuidadores) NO se acepta en este endpoint
	 * todavía — entra en un slice posterior con su flujo de consentimiento.
	 *
	 * @param WP_REST_Request $request
	 * @return WP_REST_Response|WP_Error
	 */
	public static function crear_entrada( WP_REST_Request $request ) {
		global $wpdb;

		$nino_id = (int) $request->get_param( '_nino_id' );
		if ( $nino_id <= 0 ) {
			// El permission_callback ya carga _nino_id; este check es un seguro
			// por si alguien instala un permission_callback distinto en el futuro.
			return new WP_Error(
				'ns_cuaderno_sin_nino',
				'Falta el identificador del niño en el token.',
				array( 'status' => 401 )
			);
		}

		$body = $request->get_json_params();
		if ( ! is_array( $body ) ) {
			return self::error_validacion( 'body_no_es_objeto', 'El cuerpo de la petición debe ser un objeto JSON.' );
		}

		$campos_invalidos = self::validar_formato( $body );

		// Validación que sí requiere DB: el game_id debe existir en
		// `ns_games`. Solo se chequea si la validación de formato no lo
		// ha marcado ya como inválido.
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

		$type             = isset( $body['type'] ) ? trim( (string) $body['type'] ) : '';
		$title            = trim( (string) $body['title'] );
		$content_ref      = isset( $body['content_ref'] ) ? trim( (string) $body['content_ref'] ) : '';
		$content_meta_raw = $body['content_meta'] ?? null;
		$anchored_to_raw  = $body['anchored_to'] ?? null;

		$tabla = NS_Esquema::nombre_tabla( 'cuaderno_entries' );
		$ahora = gmdate( 'Y-m-d H:i:s' );

		$insertado = $wpdb->insert(
			$tabla,
			array(
				'user_id'      => $nino_id,
				'game_id'      => $game_id,
				'type'         => $type,
				'title'        => $title,
				'content_ref'  => $content_ref,
				'content_meta' => $content_meta_raw === null ? null : wp_json_encode( $content_meta_raw ),
				'anchored_to'  => $anchored_to_raw === null ? null : wp_json_encode( $anchored_to_raw ),
				'created_at'   => $ahora,
				'updated_at'   => $ahora,
			),
			array( '%d', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s' )
		);

		if ( false === $insertado ) {
			return new WP_Error(
				'ns_cuaderno_insert_error',
				'No se pudo guardar la entrada del cuaderno.',
				array( 'status' => 500 )
			);
		}

		$id = (int) $wpdb->insert_id;

		$respuesta = new WP_REST_Response(
			array(
				'id'          => $id,
				'game_id'     => $game_id,
				'type'        => $type,
				'title'       => $title,
				'content_ref' => $content_ref,
				'created_at'  => $ahora,
			),
			201
		);
		$respuesta->header( 'Location', rest_url( "nuevo-ser/v1/companion/cuaderno/entries/{$id}" ) );
		return $respuesta;
	}

	/**
	 * Valida el shape del body sin tocar la DB. Pura — se puede invocar
	 * desde un test smoke sin levantar WordPress. Devuelve un array
	 * `clave_de_campo => motivo_de_fallo`. Si está vacío, los formatos
	 * son aceptables (queda comprobar la existencia de `game_id` con DB,
	 * que va aparte).
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

		$type = isset( $body['type'] ) ? trim( (string) $body['type'] ) : '';
		if ( strlen( $type ) > self::MAX_TYPE ) {
			$campos_invalidos['type'] = 'demasiado_largo';
		} elseif ( $type !== '' && ! preg_match( '/^[a-z0-9_]+$/', $type ) ) {
			$campos_invalidos['type'] = 'formato_invalido';
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

		if ( array_key_exists( 'anchored_to', $body ) && $body['anchored_to'] !== null && ! is_array( $body['anchored_to'] ) ) {
			$campos_invalidos['anchored_to'] = 'debe_ser_objeto';
		}

		return $campos_invalidos;
	}

	/**
	 * Comprueba si [game_id] está registrado en `ns_games`. Permite que el
	 * mismo backend sirva a Uno Roto y a Las Versiones sin que un cliente
	 * pueda inventar un juego.
	 */
	private static function juego_existe( string $game_id ): bool {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'games' );
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
