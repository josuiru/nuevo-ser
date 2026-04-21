<?php
/**
 * Firma y validación de JWTs HS256 sin dependencias externas.
 *
 * Formato del payload:
 *   {
 *     "nino_id": 42,
 *     "iat": 1713...,
 *     "exp": 1713... (iat + 30 días por defecto)
 *   }
 *
 * El secret vive en UROTO_JWT_SECRET (wp-config.php). Si no está
 * definido, la firma usa un secret derivado de AUTH_KEY — funcional
 * para desarrollo pero NO apto para producción.
 *
 * @package UnoRotoCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class UROTO_JWT {

	private const ALG                  = 'HS256';
	private const DIAS_EXPIRACION      = 30;

	public static function firmar( array $carga_util ): string {
		$cabecera = array( 'alg' => self::ALG, 'typ' => 'JWT' );
		$ahora    = time();
		$carga    = array_merge(
			$carga_util,
			array(
				'iat' => $ahora,
				'exp' => $ahora + ( self::DIAS_EXPIRACION * 86400 ),
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
		$secreto = defined( 'UROTO_JWT_SECRET' )
			? UROTO_JWT_SECRET
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
