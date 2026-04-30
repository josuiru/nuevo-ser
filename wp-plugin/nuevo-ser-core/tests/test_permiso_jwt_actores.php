<?php
/**
 * Smoke tests de los helpers permission_callback de NS_Endpoints
 * para JWT de profesor y cuidador. Ejecutar:
 *   php tests/test_permiso_jwt_actores.php
 *
 * Imprime "OK" y sale con 0 si todo verde; en error sale con 1.
 *
 * Polyfills mínimos (sin cargar todo WP). NS_Endpoints::registrar()
 * no se ejecuta — sólo se llama a los métodos estáticos de permiso,
 * que no tocan DB.
 */

define( 'ABSPATH', __DIR__ );
define( 'AUTH_KEY', 'test-auth-key-suficientemente-largo-para-derivar' );

if ( ! function_exists( 'wp_json_encode' ) ) {
	function wp_json_encode( $datos, int $opciones = 0 ) {
		return json_encode( $datos, $opciones );
	}
}

if ( ! class_exists( 'WP_REST_Request' ) ) {
	class WP_REST_Request {
		private array $cabeceras = array();
		private array $params    = array();
		public function set_header( string $clave, string $valor ): void {
			$this->cabeceras[ strtolower( $clave ) ] = $valor;
		}
		public function get_header( string $clave ) {
			return $this->cabeceras[ strtolower( $clave ) ] ?? null;
		}
		public function set_param( string $clave, $valor ): void {
			$this->params[ $clave ] = $valor;
		}
		public function get_param( string $clave ) {
			return $this->params[ $clave ] ?? null;
		}
	}
}

if ( ! class_exists( 'WP_Error' ) ) {
	class WP_Error {
		public string $code;
		public string $message;
		public array  $data;
		public function __construct( string $code, string $message, array $data = array() ) {
			$this->code    = $code;
			$this->message = $message;
			$this->data    = $data;
		}
	}
}

// NS_Repositorio no está cargada — declaramos un stub vacío para que
// el require de class-ns-endpoints.php no se queje al referenciarla.
// Los helpers permiso_jwt_* no la invocan.
if ( ! class_exists( 'NS_Repositorio' ) ) {
	class NS_Repositorio {}
}

require_once __DIR__ . '/../includes/class-ns-jwt.php';
require_once __DIR__ . '/../includes/class-ns-endpoints.php';

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

function request_con_token( string $token ): WP_REST_Request {
	$req = new WP_REST_Request();
	$req->set_header( 'authorization', 'Bearer ' . $token );
	return $req;
}

// 1. Sin header → WP_Error 401.
$req = new WP_REST_Request();
$resultado = NS_Endpoints::permiso_jwt_profesor( $req );
afirmar( true, $resultado instanceof WP_Error, 'profesor: sin token → WP_Error' );
afirmar( 401, $resultado->data['status'] ?? null, 'profesor: sin token → status 401' );

// 2. Token válido de profesor → true + _user_id adjunto al request.
$tokenProfe = NS_JWT::firmar(
	array( 'user_id' => 13, 'tipo' => 'profesor' )
);
$req = request_con_token( $tokenProfe );
afirmar( true, NS_Endpoints::permiso_jwt_profesor( $req ), 'profesor: token válido → true' );
afirmar( 13, $req->get_param( '_user_id' ), 'profesor: _user_id adjunto' );

// 3. Token de cuidador NO pasa por permiso_jwt_profesor (mismatch).
$tokenCuid = NS_JWT::firmar(
	array( 'user_id' => 19, 'tipo' => 'cuidador' )
);
$req = request_con_token( $tokenCuid );
$resultado = NS_Endpoints::permiso_jwt_profesor( $req );
afirmar( true, $resultado instanceof WP_Error, 'profesor: token de cuidador rechazado' );

// 4. Token de niño NO pasa por permiso_jwt_profesor.
$tokenNino = NS_JWT::firmar( array( 'nino_id' => 42 ) );
$req = request_con_token( $tokenNino );
$resultado = NS_Endpoints::permiso_jwt_profesor( $req );
afirmar( true, $resultado instanceof WP_Error, 'profesor: token de niño rechazado' );

// 5. Token corrupto → WP_Error.
$req = request_con_token( $tokenProfe . 'X' );
$resultado = NS_Endpoints::permiso_jwt_profesor( $req );
afirmar( true, $resultado instanceof WP_Error, 'profesor: token corrupto rechazado' );

// 6. Mismas tres pruebas para cuidador.
$req = request_con_token( $tokenCuid );
afirmar( true, NS_Endpoints::permiso_jwt_cuidador( $req ), 'cuidador: token válido → true' );
afirmar( 19, $req->get_param( '_user_id' ), 'cuidador: _user_id adjunto' );

$req = request_con_token( $tokenProfe );
$resultado = NS_Endpoints::permiso_jwt_cuidador( $req );
afirmar( true, $resultado instanceof WP_Error, 'cuidador: token de profesor rechazado' );

$req = request_con_token( $tokenNino );
$resultado = NS_Endpoints::permiso_jwt_cuidador( $req );
afirmar( true, $resultado instanceof WP_Error, 'cuidador: token de niño rechazado' );

// 7. permiso_jwt original también se endurece: ahora exige `tipo='nino'`
//    o ausencia de `tipo`. Un token con tipo='profesor' que tenga un
//    nino_id por error no debe colarse.
$tokenChimera = NS_JWT::firmar(
	array( 'nino_id' => 1, 'tipo' => 'profesor' )
);
$req = request_con_token( $tokenChimera );
$resultado = NS_Endpoints::permiso_jwt( $req );
afirmar( true, $resultado instanceof WP_Error, 'permiso_jwt: tipo profesor con nino_id rechazado' );

// 8. Pero un token niño legacy (sin `tipo`, sólo nino_id) sigue
//    funcionando — backward-compat.
$req = request_con_token( $tokenNino );
afirmar( true, NS_Endpoints::permiso_jwt( $req ), 'permiso_jwt: token niño legacy sigue válido' );
afirmar( 42, $req->get_param( '_nino_id' ), 'permiso_jwt: _nino_id adjunto' );

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
}
echo "FALLOS: {$fallos}\n";
exit( 1 );
