<?php
/**
 * Smoke tests de NS_Auth_Adulto. Sin PHPUnit ni WP cargado:
 * prueba la función pura `validar_rol_login` y el mapa
 * `rol_wp_para`. La parte que toca DB / wp_authenticate /
 * wp_users (validación de credenciales y rol del usuario) se
 * valida manualmente con un usuario WP real, fuera de smoke.
 *
 * Ejecutar: php tests/test_auth_adulto.php
 */

define( 'ABSPATH', __DIR__ );

require_once __DIR__ . '/../includes/class-ns-auth-adulto.php';

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

// ─── validar_rol_login ────────────────────────────────────────

afirmar( null, NS_Auth_Adulto::validar_rol_login( 'profesor' ), 'rol profesor pasa' );
afirmar( null, NS_Auth_Adulto::validar_rol_login( 'cuidador' ), 'rol cuidador pasa' );

afirmar( 'rol requerido', NS_Auth_Adulto::validar_rol_login( '' ), 'rol vacío rechaza' );
afirmar( 'rol requerido', NS_Auth_Adulto::validar_rol_login( null ), 'rol null rechaza' );
afirmar( 'rol requerido', NS_Auth_Adulto::validar_rol_login( 0 ), 'rol entero rechaza' );

afirmar( 'rol inválido', NS_Auth_Adulto::validar_rol_login( 'admin' ), 'rol admin rechaza' );
afirmar( 'rol inválido', NS_Auth_Adulto::validar_rol_login( 'PROFESOR' ), 'rol mayúsculas rechaza (case-sensitive)' );
afirmar( 'rol inválido', NS_Auth_Adulto::validar_rol_login( 'nino' ), 'rol nino rechaza — el endpoint del niño es /login, no /auth/login' );
afirmar( 'rol inválido', NS_Auth_Adulto::validar_rol_login( ' profesor ' ), 'rol con espacios rechaza' );

// ─── rol_wp_para ──────────────────────────────────────────────

afirmar(
	'nuevoser_profesor',
	NS_Auth_Adulto::rol_wp_para( 'profesor' ),
	'profesor → nuevoser_profesor'
);
afirmar(
	'nuevoser_cuidador',
	NS_Auth_Adulto::rol_wp_para( 'cuidador' ),
	'cuidador → nuevoser_cuidador'
);
afirmar( null, NS_Auth_Adulto::rol_wp_para( 'desconocido' ), 'rol desconocido → null' );

// ─── Constantes públicas estables (los clientes Dart pueden
//     hard-codearlas, así que no deben cambiar de valor sin
//     alinear la app del profesor/cuidador) ──────────────────

afirmar( 'profesor', NS_Auth_Adulto::ROL_PROFESOR, 'constante ROL_PROFESOR estable' );
afirmar( 'cuidador', NS_Auth_Adulto::ROL_CUIDADOR, 'constante ROL_CUIDADOR estable' );

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
}
echo "FALLOS: {$fallos}\n";
exit( 1 );
