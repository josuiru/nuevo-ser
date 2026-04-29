<?php
/**
 * Smoke tests del JWT con TTL personalizado y separación
 * `nino_id` / `usuario_id`. Ejecutar:
 *   php tests/test_jwt_tutor.php
 *
 * Imprime "OK" y sale con 0 si todo verde; en error sale con 1.
 */

define( 'ABSPATH', __DIR__ );
define( 'AUTH_KEY', 'test-auth-key-suficientemente-largo-para-derivar' );

// Polyfill mínimo de funciones WP para correr fuera del entorno.
if ( ! function_exists( 'wp_json_encode' ) ) {
	function wp_json_encode( $datos, int $opciones = 0 ) {
		return json_encode( $datos, $opciones );
	}
}

require_once __DIR__ . '/../includes/class-uroto-jwt.php';

// Polyfill mínimo de WP_REST_Request para no cargar todo WP.
if ( ! class_exists( 'WP_REST_Request' ) ) {
	class WP_REST_Request {
		private array $cabeceras = array();
		public function set_header( string $clave, string $valor ): void {
			$this->cabeceras[ strtolower( $clave ) ] = $valor;
		}
		public function get_header( string $clave ) {
			return $this->cabeceras[ strtolower( $clave ) ] ?? null;
		}
	}
}

$fallos = 0;
function afirmar( $esperado, $real, string $titulo ): void {
	global $fallos;
	if ( $esperado !== $real ) {
		$fallos++;
		fprintf(
			STDERR,
			"FALLO: %s\n  esperado: %s\n  real:     %s\n",
			$titulo,
			var_export( $esperado, true ),
			var_export( $real, true )
		);
	}
}

// 1. Token de niño con TTL por defecto (30 días) firma y valida.
$tokenNino = UROTO_JWT::firmar( array( 'nino_id' => 7 ) );
$cargaNino = UROTO_JWT::validar( $tokenNino );
afirmar( true, is_array( $cargaNino ), 'token niño válido' );
afirmar( 7, $cargaNino['nino_id'] ?? null, 'nino_id presente' );
afirmar(
	true,
	( $cargaNino['exp'] - $cargaNino['iat'] ) === 30 * 86400,
	'TTL niño = 30 días por defecto'
);

// 2. Token de tutor con TTL 15 minutos.
$tokenTutor = UROTO_JWT::firmar( array( 'usuario_id' => 42 ), 15 * 60 );
$cargaTutor = UROTO_JWT::validar( $tokenTutor );
afirmar( true, is_array( $cargaTutor ), 'token tutor válido' );
afirmar( 42, $cargaTutor['usuario_id'] ?? null, 'usuario_id presente' );
afirmar(
	true,
	( $cargaTutor['exp'] - $cargaTutor['iat'] ) === 15 * 60,
	'TTL tutor = 15 min'
);

// 3. Un token de niño NO contiene usuario_id (los handlers tutor lo
//    rechazarán por permission_callback).
afirmar( true, ! isset( $cargaNino['usuario_id'] ), 'token niño no lleva usuario_id' );

// 4. Un token de tutor NO contiene nino_id (los handlers actuales lo
//    rechazarán por permission_callback existente).
afirmar( true, ! isset( $cargaTutor['nino_id'] ), 'token tutor no lleva nino_id' );

// 5. Token con firma corrupta es rechazado.
$tokenRoto = $tokenTutor . 'X';
afirmar( null, UROTO_JWT::validar( $tokenRoto ), 'firma corrupta rechazada' );

// 6. Lectura del header Authorization: Bearer.
$req = new WP_REST_Request();
$req->set_header( 'authorization', 'Bearer ' . $tokenTutor );
afirmar( $tokenTutor, UROTO_JWT::leer_token_de_request( $req ), 'header Bearer leído' );

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
}
echo "FALLOS: {$fallos}\n";
exit( 1 );
