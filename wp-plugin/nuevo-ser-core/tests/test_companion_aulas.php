<?php
/**
 * Smoke tests de validación de POST /classrooms/{code}/join.
 * Sin PHPUnit ni WordPress: prueba la función pura
 * `NS_Companion_Aulas::validar_codigo`. La parte que toca DB (existencia
 * del aula, estado active, idempotencia de la membresía) se valida con
 * WP-CLI o tests de integración.
 *
 * Ejecutar con: `php tests/test_companion_aulas.php`.
 */

define( 'ABSPATH', __DIR__ );

require_once __DIR__ . '/../includes/class-ns-companion-aulas.php';

$fallos = 0;

/**
 * @param mixed $esperado
 * @param mixed $real
 */
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

// ─── Códigos válidos ──────────────────────────────────────────

afirmar( array(), NS_Companion_Aulas::validar_codigo( 'ABCD' ), 'aulas: code 4 chars pasa' );
afirmar( array(), NS_Companion_Aulas::validar_codigo( 'ABC123' ), 'aulas: code mixto letras+nums pasa' );
afirmar( array(), NS_Companion_Aulas::validar_codigo( 'A1B2C3D4E5F6G7H8' ), 'aulas: code 16 chars pasa' );

// Lowercase se normaliza, no se rechaza por sí mismo.
afirmar( array(), NS_Companion_Aulas::validar_codigo( 'abc123' ), 'aulas: code lowercase se acepta (normaliza upper)' );

// Con espacios alrededor también pasa (trim).
afirmar( array(), NS_Companion_Aulas::validar_codigo( '  ABC123  ' ), 'aulas: code con espacios alrededor pasa' );

// ─── code requerido ───────────────────────────────────────────

$campos = NS_Companion_Aulas::validar_codigo( '' );
afirmar( 'requerido', $campos['code'] ?? null, 'aulas: code vacío rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( '   ' );
afirmar( 'requerido', $campos['code'] ?? null, 'aulas: code solo espacios rechaza' );

// ─── longitud_invalida ─────────────────────────────────────────

$campos = NS_Companion_Aulas::validar_codigo( 'ABC' );
afirmar( 'longitud_invalida', $campos['code'] ?? null, 'aulas: code 3 chars rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( str_repeat( 'A', 17 ) );
afirmar( 'longitud_invalida', $campos['code'] ?? null, 'aulas: code 17 chars rechaza' );

// ─── formato_invalido ──────────────────────────────────────────

$campos = NS_Companion_Aulas::validar_codigo( 'ABC-123' );
afirmar( 'formato_invalido', $campos['code'] ?? null, 'aulas: code con guion rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( 'ABC_DEF' );
afirmar( 'formato_invalido', $campos['code'] ?? null, 'aulas: code con underscore rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( 'ABC ÑDEF' );
afirmar( 'formato_invalido', $campos['code'] ?? null, 'aulas: code con espacio interior rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( 'ABCÑ' );
afirmar( 'formato_invalido', $campos['code'] ?? null, 'aulas: code con Ñ rechaza' );

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
} else {
	fprintf( STDERR, "%d fallo(s).\n", $fallos );
	exit( 1 );
}
