<?php
/**
 * Endpoint de login para adultos (profesor/cuidador). Paralelo al
 * `/login` del niño (que vive en `NS_Endpoints::iniciar_sesion`):
 *
 *   POST /nuevo-ser/v1/auth/login
 *     body: { email, password, rol: 'profesor' | 'cuidador' }
 *     200:  { token, user_id, rol }
 *     400:  { error: 'rol inválido' }
 *     401:  { error: 'Credenciales incorrectas.' }
 *     403:  { error: 'El usuario no tiene el rol solicitado.' }
 *
 * El token resultante lleva `{ user_id, tipo: rol }` (ver
 * `NS_JWT::firmar`). Los endpoints que requieran identidad de
 * profesor/cuidador validan con `NS_Endpoints::permiso_jwt_profesor`
 * o `permiso_jwt_cuidador`.
 *
 * Diseño:
 * - El `/login` del niño (`NS_Endpoints::iniciar_sesion`) **no se
 *   toca**. Sigue devolviendo `{token, nino_id}` para el adulto-
 *   progenitor con perfil de niño asociado (caso del cliente
 *   `ClienteAuthCuaderno` en El Cuaderno).
 * - Este endpoint es para profesores/cuidadores reales — adultos
 *   que NO son progenitores del niño dueño del dispositivo, sino
 *   actores institucionales que necesitan acceder a aulas
 *   (profesor) o resúmenes del niño (cuidador).
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Auth_Adulto {

	public const ROL_PROFESOR = 'profesor';
	public const ROL_CUIDADOR = 'cuidador';

	/** Roles WP custom que el plugin registra en activación. */
	public const ROL_WP_PROFESOR = 'nuevoser_profesor';
	public const ROL_WP_CUIDADOR = 'nuevoser_cuidador';

	/**
	 * Mapa rol-de-token → rol-WP. Si añadimos más roles (p. ej.
	 * `coordinador`), basta con extender este mapa y la constante
	 * correspondiente; el handler trabaja sólo con esto.
	 */
	private const MAPA_ROL_WP = array(
		self::ROL_PROFESOR => self::ROL_WP_PROFESOR,
		self::ROL_CUIDADOR => self::ROL_WP_CUIDADOR,
	);

	/**
	 * Validación pura del rol recibido en el body. Devuelve null si
	 * es válido (uno de los conocidos), o un mensaje de error humano
	 * si no. No toca DB ni WP — sólo string-en, string|null-out.
	 */
	public static function validar_rol_login( $rol ): ?string {
		if ( ! is_string( $rol ) || '' === $rol ) {
			return 'rol requerido';
		}
		if ( ! isset( self::MAPA_ROL_WP[ $rol ] ) ) {
			return 'rol inválido';
		}
		return null;
	}

	/**
	 * Devuelve el slug del rol WP correspondiente al rol del token.
	 * Asume que `validar_rol_login` ya pasó — null si no.
	 */
	public static function rol_wp_para( string $rol_token ): ?string {
		return self::MAPA_ROL_WP[ $rol_token ] ?? null;
	}

	/**
	 * POST /auth/login
	 *
	 * Lee email, password, rol del body. Valida rol como función
	 * pura. Llama a `wp_authenticate` para validar credenciales.
	 * Comprueba que el usuario tenga el rol WP correspondiente.
	 * Si todo OK, emite JWT con `{user_id, tipo: rol}`.
	 */
	public static function login( WP_REST_Request $request ) {
		$email    = sanitize_email( (string) $request->get_param( 'email' ) );
		$password = (string) $request->get_param( 'password' );
		$rol      = (string) $request->get_param( 'rol' );

		$error_rol = self::validar_rol_login( $rol );
		if ( null !== $error_rol ) {
			return new WP_REST_Response(
				array( 'error' => $error_rol ),
				400
			);
		}
		if ( ! is_email( $email ) || '' === $password ) {
			return new WP_REST_Response(
				array( 'error' => 'Credenciales incorrectas.' ),
				401
			);
		}

		$usuario = wp_authenticate( $email, $password );
		if ( is_wp_error( $usuario ) || ! ( $usuario instanceof WP_User ) ) {
			return new WP_REST_Response(
				array( 'error' => 'Credenciales incorrectas.' ),
				401
			);
		}

		$rol_wp = self::rol_wp_para( $rol );
		if ( ! in_array( $rol_wp, (array) $usuario->roles, true ) ) {
			return new WP_REST_Response(
				array( 'error' => 'El usuario no tiene el rol solicitado.' ),
				403
			);
		}

		$token = NS_JWT::firmar(
			array(
				'user_id' => (int) $usuario->ID,
				'tipo'    => $rol,
			)
		);

		return new WP_REST_Response(
			array(
				'token'   => $token,
				'user_id' => (int) $usuario->ID,
				'rol'     => $rol,
			),
			200
		);
	}
}
