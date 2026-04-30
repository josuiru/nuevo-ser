<?php
/**
 * Smoke tests del JWT con tipo (niño / profesor / cuidador).
 * Ejecutar: php tests/test_jwt_actores.php
 *
 * Imprime "OK" y sale con 0 si todo verde; en error sale con 1.
 */

define( 'ABSPATH', __DIR__ );
define( 'AUTH_KEY', 'test-auth-key-suficientemente-largo-para-derivar' );

if ( ! function_exists( 'wp_json_encode' ) ) {
	function wp_json_encode( $datos, int $opciones = 0 ) {
		return json_encode( $datos, $opciones );
	}
}

require_once __DIR__ . '/../includes/class-ns-jwt.php';

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

// 1. Token de niño (forma legada, sin `tipo`) → tipo_de_carga
//    devuelve 'nino' por defecto, actor_de_carga devuelve nino_id.
$tokenNino = NS_JWT::firmar( array( 'nino_id' => 42 ) );
$cargaNino = NS_JWT::validar( $tokenNino );
afirmar( 'nino', NS_JWT::tipo_de_carga( $cargaNino ), 'tipo default = nino' );
afirmar( 42, NS_JWT::actor_de_carga( $cargaNino ), 'actor del niño = nino_id' );

// 2. Token de niño explícito (con `tipo='nino'`) → mismo
//    comportamiento que la forma legada.
$tokenNinoExp = NS_JWT::firmar( array( 'nino_id' => 7, 'tipo' => 'nino' ) );
$cargaNinoExp = NS_JWT::validar( $tokenNinoExp );
afirmar( 'nino', NS_JWT::tipo_de_carga( $cargaNinoExp ), 'tipo nino explícito' );
afirmar( 7, NS_JWT::actor_de_carga( $cargaNinoExp ), 'actor del niño explícito = nino_id' );

// 3. Token de profesor.
$tokenProfe = NS_JWT::firmar(
	array( 'user_id' => 13, 'tipo' => 'profesor' )
);
$cargaProfe = NS_JWT::validar( $tokenProfe );
afirmar( 'profesor', NS_JWT::tipo_de_carga( $cargaProfe ), 'tipo profesor' );
afirmar( 13, NS_JWT::actor_de_carga( $cargaProfe ), 'actor del profesor = user_id' );

// 4. Token de cuidador.
$tokenCuid = NS_JWT::firmar(
	array( 'user_id' => 19, 'tipo' => 'cuidador' )
);
$cargaCuid = NS_JWT::validar( $tokenCuid );
afirmar( 'cuidador', NS_JWT::tipo_de_carga( $cargaCuid ), 'tipo cuidador' );
afirmar( 19, NS_JWT::actor_de_carga( $cargaCuid ), 'actor del cuidador = user_id' );

// 5. Tipo desconocido se devuelve tal cual (los endpoints deciden si
//    aceptan más tipos en el futuro — la plataforma no encierra).
$tokenRaro = NS_JWT::firmar(
	array( 'user_id' => 1, 'tipo' => 'admin_de_la_coleccion' )
);
$cargaRara = NS_JWT::validar( $tokenRaro );
afirmar(
	'admin_de_la_coleccion',
	NS_JWT::tipo_de_carga( $cargaRara ),
	'tipo desconocido se preserva'
);

// 6. Una carga sin `nino_id` ni `user_id` devuelve actor null —
//    permission_callback debe rechazar el token.
$cargaCorrupta = array( 'tipo' => 'profesor', 'iat' => 1, 'exp' => time() + 60 );
afirmar( null, NS_JWT::actor_de_carga( $cargaCorrupta ), 'actor null si falta user_id' );
$cargaSinNada = array( 'iat' => 1, 'exp' => time() + 60 );
afirmar( null, NS_JWT::actor_de_carga( $cargaSinNada ), 'actor null si carga vacía' );

// 7. tipo_de_carga es defensivo ante shapes corruptos.
afirmar( 'nino', NS_JWT::tipo_de_carga( array() ), 'tipo de carga vacía = nino' );
afirmar(
	'nino',
	NS_JWT::tipo_de_carga( array( 'tipo' => 123 ) ),
	'tipo no-string = nino (defensivo)'
);

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
}
echo "FALLOS: {$fallos}\n";
exit( 1 );
