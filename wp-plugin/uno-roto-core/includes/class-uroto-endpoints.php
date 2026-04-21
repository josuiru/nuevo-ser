<?php
/**
 * Registra las rutas REST bajo /wp-json/uno-roto/v1/*.
 *
 * Endpoints públicos (sin JWT):
 *   POST /register   email + password + nombre_tutor + nombre_nino
 *   POST /login      email + password  → { token, nino_id }
 *
 * Endpoints protegidos (JWT en Authorization: Bearer):
 *   GET  /progress           → estado completo del niño
 *   POST /sync/progress      → merge LWW, devuelve estado final
 *   DELETE /account          → borrado GDPR completo
 *
 * Todos devuelven JSON. Errores como WP_REST_Response con código
 * HTTP apropiado.
 *
 * @package UnoRotoCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class UROTO_Endpoints {

	private const NAMESPACE = 'uno-roto/v1';

	public static function registrar(): void {
		register_rest_route(
			self::NAMESPACE,
			'/register',
			array(
				'methods'             => 'POST',
				'callback'            => array( __CLASS__, 'registrar_cuenta' ),
				'permission_callback' => '__return_true',
			)
		);

		register_rest_route(
			self::NAMESPACE,
			'/login',
			array(
				'methods'             => 'POST',
				'callback'            => array( __CLASS__, 'iniciar_sesion' ),
				'permission_callback' => '__return_true',
			)
		);

		register_rest_route(
			self::NAMESPACE,
			'/progress',
			array(
				'methods'             => 'GET',
				'callback'            => array( __CLASS__, 'obtener_progreso' ),
				'permission_callback' => array( __CLASS__, 'permiso_jwt' ),
			)
		);

		register_rest_route(
			self::NAMESPACE,
			'/sync/progress',
			array(
				'methods'             => 'POST',
				'callback'            => array( __CLASS__, 'sincronizar_progreso' ),
				'permission_callback' => array( __CLASS__, 'permiso_jwt' ),
			)
		);

		register_rest_route(
			self::NAMESPACE,
			'/account',
			array(
				'methods'             => 'DELETE',
				'callback'            => array( __CLASS__, 'borrar_cuenta' ),
				'permission_callback' => array( __CLASS__, 'permiso_jwt' ),
			)
		);
	}

	// -------------------------------------------------------------
	// Permission callback JWT.
	// -------------------------------------------------------------

	public static function permiso_jwt( WP_REST_Request $request ) {
		$token = UROTO_JWT::leer_token_de_request( $request );
		if ( ! $token ) {
			return new WP_Error(
				'uroto_sin_token',
				'Falta el header Authorization: Bearer.',
				array( 'status' => 401 )
			);
		}
		$carga = UROTO_JWT::validar( $token );
		if ( ! $carga || ! isset( $carga['nino_id'] ) ) {
			return new WP_Error(
				'uroto_token_invalido',
				'Token no válido o expirado.',
				array( 'status' => 401 )
			);
		}
		$request->set_param( '_nino_id', (int) $carga['nino_id'] );
		return true;
	}

	// -------------------------------------------------------------
	// POST /register
	// -------------------------------------------------------------

	public static function registrar_cuenta( WP_REST_Request $request ) {
		$email         = sanitize_email( (string) $request->get_param( 'email' ) );
		$password      = (string) $request->get_param( 'password' );
		$nombre_tutor  = sanitize_text_field(
			(string) $request->get_param( 'nombre_tutor' )
		);
		$nombre_nino   = sanitize_text_field(
			(string) $request->get_param( 'nombre_nino' )
		);
		$locale        = sanitize_text_field(
			(string) ( $request->get_param( 'locale' ) ?: 'es' )
		);

		if ( ! is_email( $email ) || strlen( $password ) < 8 || '' === $nombre_nino ) {
			return new WP_REST_Response(
				array( 'error' => 'Datos inválidos.' ),
				400
			);
		}

		if ( UROTO_Repositorio::buscar_usuario_por_email( $email ) ) {
			return new WP_REST_Response(
				array( 'error' => 'El email ya está registrado.' ),
				409
			);
		}

		$usuario_id = UROTO_Repositorio::crear_usuario(
			$email,
			password_hash( $password, PASSWORD_DEFAULT ),
			$nombre_tutor,
			$locale
		);
		$nino_id    = UROTO_Repositorio::crear_nino( $usuario_id, $nombre_nino, $locale );

		return new WP_REST_Response(
			array(
				'token'       => UROTO_JWT::firmar( array( 'nino_id' => $nino_id ) ),
				'nino_id'     => $nino_id,
				'usuario_id'  => $usuario_id,
			),
			201
		);
	}

	// -------------------------------------------------------------
	// POST /login
	// -------------------------------------------------------------

	public static function iniciar_sesion( WP_REST_Request $request ) {
		$email    = sanitize_email( (string) $request->get_param( 'email' ) );
		$password = (string) $request->get_param( 'password' );

		$usuario = UROTO_Repositorio::buscar_usuario_por_email( $email );
		if ( ! $usuario || ! password_verify( $password, $usuario['password_hash'] ) ) {
			return new WP_REST_Response(
				array( 'error' => 'Credenciales incorrectas.' ),
				401
			);
		}

		$ninos = UROTO_Repositorio::ninos_de_usuario( (int) $usuario['id'] );
		if ( empty( $ninos ) ) {
			return new WP_REST_Response(
				array( 'error' => 'La cuenta no tiene ningún perfil de niño.' ),
				404
			);
		}
		$nino_id = (int) $ninos[0]['id'];

		return new WP_REST_Response(
			array(
				'token'   => UROTO_JWT::firmar( array( 'nino_id' => $nino_id ) ),
				'nino_id' => $nino_id,
			),
			200
		);
	}

	// -------------------------------------------------------------
	// GET /progress
	// -------------------------------------------------------------

	public static function obtener_progreso( WP_REST_Request $request ) {
		$nino_id = (int) $request->get_param( '_nino_id' );
		return new WP_REST_Response(
			array(
				'progreso'    => UROTO_Repositorio::cargar_progreso( $nino_id ),
				'habilidades' => UROTO_Repositorio::cargar_habilidades( $nino_id ),
			),
			200
		);
	}

	// -------------------------------------------------------------
	// POST /sync/progress
	// -------------------------------------------------------------

	public static function sincronizar_progreso( WP_REST_Request $request ) {
		$nino_id = (int) $request->get_param( '_nino_id' );
		$entrada = array(
			'progreso'    => $request->get_param( 'progreso' ) ?: null,
			'habilidades' => $request->get_param( 'habilidades' ) ?: array(),
		);
		$resultado = UROTO_Sincronizador::sincronizar( $nino_id, $entrada );
		return new WP_REST_Response( $resultado, 200 );
	}

	// -------------------------------------------------------------
	// DELETE /account
	// -------------------------------------------------------------

	public static function borrar_cuenta( WP_REST_Request $request ) {
		$nino_id = (int) $request->get_param( '_nino_id' );
		$nino    = UROTO_Repositorio::buscar_nino( $nino_id );
		if ( ! $nino ) {
			return new WP_REST_Response(
				array( 'error' => 'Niño no encontrado.' ),
				404
			);
		}
		UROTO_Repositorio::borrar_cuenta( (int) $nino['usuario_id'] );
		return new WP_REST_Response( array( 'ok' => true ), 200 );
	}
}
