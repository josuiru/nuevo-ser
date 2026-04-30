<?php
/**
 * Smoke tests del POC `NS_Caregivers` (BORRADOR magic-link
 * pendiente de validación LOPDGDD). Sin PHPUnit ni WP cargado:
 * sólo prueba las funciones puras `validar_email_invitacion` y
 * `generar_consent_token`. La parte que toca DB / wp_users /
 * vínculos persistidos se valida manualmente en Local WP.
 *
 * Ejecutar: php tests/test_caregivers.php
 */

define( 'ABSPATH', __DIR__ );

require_once __DIR__ . '/../includes/class-ns-caregivers.php';

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

// ─── validar_email_invitacion ─────────────────────────────────

afirmar( null, NS_Caregivers::validar_email_invitacion( 'abuela@ejemplo.com' ), 'caregivers: email válido pasa' );
afirmar( null, NS_Caregivers::validar_email_invitacion( 'a.b+tag@dominio.es' ), 'caregivers: email con tag pasa' );

afirmar( 'cuidador_email requerido', NS_Caregivers::validar_email_invitacion( '' ), 'caregivers: email vacío rechaza' );
afirmar( 'cuidador_email requerido', NS_Caregivers::validar_email_invitacion( '   ' ), 'caregivers: email solo espacios rechaza' );
afirmar( 'cuidador_email requerido', NS_Caregivers::validar_email_invitacion( null ), 'caregivers: email null rechaza' );
afirmar( 'cuidador_email requerido', NS_Caregivers::validar_email_invitacion( 0 ), 'caregivers: email entero rechaza' );

afirmar( 'cuidador_email malformado', NS_Caregivers::validar_email_invitacion( 'sin-arroba' ), 'caregivers: email sin @ rechaza' );
afirmar( 'cuidador_email malformado', NS_Caregivers::validar_email_invitacion( 'doble@@arroba.com' ), 'caregivers: email doble @ rechaza' );
afirmar( 'cuidador_email malformado', NS_Caregivers::validar_email_invitacion( 'sin-dominio@' ), 'caregivers: email sin dominio rechaza' );

// ─── generar_consent_token ────────────────────────────────────

for ( $i = 0; $i < 50; $i++ ) {
	$token = NS_Caregivers::generar_consent_token();
	afirmar(
		NS_Caregivers::LONGITUD_CONSENT_TOKEN,
		strlen( $token ),
		'caregivers: token tiene LONGITUD_CONSENT_TOKEN chars'
	);
	afirmar( 1, preg_match( '/^[0-9a-f]+$/', $token ), 'caregivers: token es hex lowercase' );
}

// 50 tokens consecutivos no deben repetirse — el espacio (2^128)
// hace la colisión astronómicamente improbable; si dos coinciden,
// random_bytes está roto.
$generados = array();
for ( $i = 0; $i < 50; $i++ ) {
	$generados[] = NS_Caregivers::generar_consent_token();
}
afirmar( 50, count( array_unique( $generados ) ), 'caregivers: 50 tokens únicos' );

// ─── Constantes públicas estables ─────────────────────────────
// Los clientes Dart pueden hard-codear `'magic_link_borrador'`
// para detectar este modo POC, así que la string no debe cambiar
// sin alinear los clientes.
afirmar(
	'magic_link_borrador',
	NS_Caregivers::CONSENT_METHOD_BORRADOR,
	'caregivers: CONSENT_METHOD_BORRADOR estable'
);
afirmar( 32, NS_Caregivers::LONGITUD_CONSENT_TOKEN, 'caregivers: token 32 chars estable' );
afirmar( 86400, NS_Caregivers::SEGUNDOS_VALIDEZ_TOKEN, 'caregivers: validez 24 h estable' );

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
}
echo "FALLOS: {$fallos}\n";
exit( 1 );
