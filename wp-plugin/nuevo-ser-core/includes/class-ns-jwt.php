<?php
/**
 * Firma y validación de JWTs HS256 sin dependencias externas.
 *
 * Formato del payload (tres variantes):
 *   - Niño (sin `tipo`, retro-compat con tokens existentes):
 *       { "nino_id": 42, "iat": ..., "exp": ... }
 *   - Profesor:
 *       { "user_id": 7, "tipo": "profesor", "iat": ..., "exp": ... }
 *   - Cuidador:
 *       { "user_id": 19, "tipo": "cuidador", "iat": ..., "exp": ... }
 *
 * Helpers `tipo_de_carga` y `actor_de_carga` normalizan la lectura
 * para que los endpoints no tengan que distinguir entre las tres
 * formas a mano.
 *
 * El secret vive en NS_JWT_SECRET (wp-config.php). Si no está
 * definido, la firma usa un secret derivado de AUTH_KEY — funcional
 * para desarrollo pero NO apto para producción.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_JWT {

	private const ALG                  = 'HS256';
	private const DIAS_EXPIRACION      = 30;

	/**
	 * Firma un JWT con la carga útil dada. Por defecto expira en 30 días
	 * (uso normal del cliente del niño). Para tokens de corta duración
	 * (modo tutor: 15 min) pasar [expira_en_segundos].
	 *
	 * @param int|null $expira_en_segundos TTL del token. Si null, 30 días.
	 */
	public static function firmar(
		array $carga_util,
		?int $expira_en_segundos = null
	): string {
		$cabecera   = array( 'alg' => self::ALG, 'typ' => 'JWT' );
		$ahora      = time();
		$ttl        = $expira_en_segundos ?? ( self::DIAS_EXPIRACION * 86400 );
		$carga      = array_merge(
			$carga_util,
			array(
				'iat' => $ahora,
				'exp' => $ahora + $ttl,
			)
		);
		$cabecera_b64 = self::base64url_encode( wp_json_encode( $cabecera ) );
		$carga_b64    = self::base64url_encode( wp_json_encode( $carga ) );
		$firma        = self::firmar_hmac( $cabecera_b64 . '.' . $carga_b64 );
		return $cabecera_b64 . '.' . $carga_b64 . '.' . $firma;
	}

	/**
	 * Valida un token y devuelve el payload decodificado, o null si
	 * la firma es inválida o el token ha expirado.
	 */
	public static function validar( string $token ): ?array {
		$partes = explode( '.', $token );
		if ( count( $partes ) !== 3 ) {
			return null;
		}
		list( $cabecera_b64, $carga_b64, $firma_recibida ) = $partes;
		$firma_esperada = self::firmar_hmac( $cabecera_b64 . '.' . $carga_b64 );
		if ( ! hash_equals( $firma_esperada, $firma_recibida ) ) {
			return null;
		}
		$carga = json_decode( self::base64url_decode( $carga_b64 ), true );
		if ( ! is_array( $carga ) ) {
			return null;
		}
		if ( isset( $carga['exp'] ) && time() > (int) $carga['exp'] ) {
			return null;
		}
		return $carga;
	}

	/**
	 * Devuelve el `tipo` de la carga útil de un token. Por convención,
	 * la ausencia del campo `tipo` significa que el token es del niño
	 * (forma original, retro-compat con tokens emitidos antes de la
	 * adición de profesor/cuidador). Cualquier valor inesperado de
	 * `tipo` se devuelve tal cual — el endpoint que lo consuma decide
	 * si lo acepta.
	 *
	 * Tipos canónicos:
	 *   - 'nino'      (default si falta `tipo`)
	 *   - 'profesor'
	 *   - 'cuidador'
	 */
	public static function tipo_de_carga( array $carga ): string {
		if ( ! isset( $carga['tipo'] ) || ! is_string( $carga['tipo'] ) ) {
			return 'nino';
		}
		return $carga['tipo'];
	}

	/**
	 * Identificador del actor del token: `nino_id` para tokens del
	 * niño (sin `tipo` o con `tipo='nino'`); `user_id` para profesor
	 * o cuidador. Devuelve null si la carga no encaja con ninguna
	 * forma reconocida — el endpoint debe rechazar el token.
	 */
	public static function actor_de_carga( array $carga ): ?int {
		$tipo = self::tipo_de_carga( $carga );
		if ( 'nino' === $tipo ) {
			return isset( $carga['nino_id'] ) ? (int) $carga['nino_id'] : null;
		}
		return isset( $carga['user_id'] ) ? (int) $carga['user_id'] : null;
	}

	/**
	 * Extrae el token de un header Authorization: Bearer xxx. null si
	 * no hay cabecera o no es válido.
	 */
	public static function leer_token_de_request( WP_REST_Request $request ): ?string {
		$header = $request->get_header( 'authorization' );
		if ( ! $header ) {
			return null;
		}
		if ( stripos( $header, 'bearer ' ) !== 0 ) {
			return null;
		}
		return trim( substr( $header, 7 ) );
	}

	private static function firmar_hmac( string $mensaje ): string {
		$secreto = defined( 'NS_JWT_SECRET' )
			? NS_JWT_SECRET
			: hash( 'sha256', 'uroto-dev-' . ( defined( 'AUTH_KEY' ) ? AUTH_KEY : 'noauth' ) );
		return self::base64url_encode( hash_hmac( 'sha256', $mensaje, $secreto, true ) );
	}

	private static function base64url_encode( string $dato ): string {
		return rtrim( strtr( base64_encode( $dato ), '+/', '-_' ), '=' );
	}

	private static function base64url_decode( string $dato ): string {
		return base64_decode( strtr( $dato, '-_', '+/' ) );
	}
}
