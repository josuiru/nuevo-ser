<?php
/**
 * Smoke tests de validación de POST /companion/cuaderno/entries.
 * Sin PHPUnit ni WordPress: prueba la función pura
 * `NS_Companion_Cuaderno::validar_formato`. La parte que toca DB
 * (`juego_existe`) se valida con WP-CLI o tests de integración.
 *
 * Ejecutar con: `php tests/test_companion_cuaderno.php`.
 *
 * Si todo va bien imprime "OK" y sale con código 0; si falla, imprime
 * el caso roto y sale con código 1.
 */

define( 'ABSPATH', __DIR__ );

require_once __DIR__ . '/../includes/class-ns-companion-cuaderno.php';

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

// ─── Body válido mínimo ────────────────────────────────────────

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'title'   => 'Las fracciones',
	)
);
afirmar( array(), $campos, 'body mínimo válido' );

// ─── Body válido completo ──────────────────────────────────────

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id'      => 'uno-roto',
		'type'         => 'reflexion',
		'title'        => 'Hoy he visto un Pleno',
		'content_ref'  => 'doc/123',
		'content_meta' => array( 'palabras' => 42 ),
		'anchored_to'  => array( 'habilidad' => 'FR.05' ),
	)
);
afirmar( array(), $campos, 'body completo válido' );

// ─── game_id requerido ─────────────────────────────────────────

$campos = NS_Companion_Cuaderno::validar_formato( array( 'title' => 'X' ) );
afirmar( 'requerido', $campos['game_id'] ?? null, 'game_id requerido cuando falta' );

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id' => '   ',
		'title'   => 'X',
	)
);
afirmar( 'requerido', $campos['game_id'] ?? null, 'game_id requerido cuando es solo espacios' );

// ─── title requerido ───────────────────────────────────────────

$campos = NS_Companion_Cuaderno::validar_formato( array( 'game_id' => 'uno-roto' ) );
afirmar( 'requerido', $campos['title'] ?? null, 'title requerido cuando falta' );

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'title'   => '',
	)
);
afirmar( 'requerido', $campos['title'] ?? null, 'title requerido cuando es vacío' );

// ─── title demasiado largo ─────────────────────────────────────

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'title'   => str_repeat( 'a', 256 ),
	)
);
afirmar( 'demasiado_largo', $campos['title'] ?? null, 'title 256 chars rechaza' );

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'title'   => str_repeat( 'a', 255 ),
	)
);
afirmar( null, $campos['title'] ?? null, 'title 255 chars pasa' );

// ─── type formato ──────────────────────────────────────────────

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'title'   => 'X',
		'type'    => 'CON-MAYUS',
	)
);
afirmar( 'formato_invalido', $campos['type'] ?? null, 'type con guiones+mayus rechaza' );

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'title'   => 'X',
		'type'    => 'reflexion_sora',
	)
);
afirmar( null, $campos['type'] ?? null, 'type lowercase con _ pasa' );

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'title'   => 'X',
		'type'    => str_repeat( 'a', 33 ),
	)
);
afirmar( 'demasiado_largo', $campos['type'] ?? null, 'type 33 chars rechaza' );

// ─── content_ref demasiado largo ───────────────────────────────

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id'     => 'uno-roto',
		'title'       => 'X',
		'content_ref' => str_repeat( 'a', 256 ),
	)
);
afirmar( 'demasiado_largo', $campos['content_ref'] ?? null, 'content_ref 256 chars rechaza' );

// ─── content_meta / anchored_to deben ser objeto ────────────────

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id'      => 'uno-roto',
		'title'        => 'X',
		'content_meta' => 'no soy objeto',
	)
);
afirmar( 'debe_ser_objeto', $campos['content_meta'] ?? null, 'content_meta string rechaza' );

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id'     => 'uno-roto',
		'title'       => 'X',
		'anchored_to' => 42,
	)
);
afirmar( 'debe_ser_objeto', $campos['anchored_to'] ?? null, 'anchored_to int rechaza' );

// null se acepta (campo opcional ausente).
$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'game_id'      => 'uno-roto',
		'title'        => 'X',
		'content_meta' => null,
		'anchored_to'  => null,
	)
);
afirmar( null, $campos['content_meta'] ?? null, 'content_meta null pasa' );
afirmar( null, $campos['anchored_to'] ?? null, 'anchored_to null pasa' );

// ─── Múltiples errores se devuelven juntos ──────────────────────

$campos = NS_Companion_Cuaderno::validar_formato(
	array(
		'type'         => 'CON-GUIONES',
		'content_meta' => 'no objeto',
	)
);
afirmar( 'requerido', $campos['game_id'] ?? null, 'multi: game_id falta' );
afirmar( 'requerido', $campos['title'] ?? null, 'multi: title falta' );
afirmar( 'formato_invalido', $campos['type'] ?? null, 'multi: type formato' );
afirmar( 'debe_ser_objeto', $campos['content_meta'] ?? null, 'multi: content_meta tipo' );

// ─── validar_query_listado ──────────────────────────────────────

// Defaults cuando no hay query.
$resultado = NS_Companion_Cuaderno::validar_query_listado( array() );
afirmar( array(), $resultado['campos_invalidos'], 'listado: query vacía sin errores' );
afirmar( '', $resultado['game_id'], 'listado: game_id default vacío' );
afirmar( 20, $resultado['limit'], 'listado: limit default 20' );
afirmar( 0, $resultado['offset'], 'listado: offset default 0' );

// game_id se trim-ea.
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'game_id' => '  uno-roto  ' )
);
afirmar( 'uno-roto', $resultado['game_id'], 'listado: game_id se trim-ea' );

// limit válido.
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'limit' => '5' )
);
afirmar( array(), $resultado['campos_invalidos'], 'listado: limit numérico válido sin errores' );
afirmar( 5, $resultado['limit'], 'listado: limit string-numérico → int' );

// limit fuera de rango (alto).
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'limit' => 999 )
);
afirmar( 'fuera_de_rango', $resultado['campos_invalidos']['limit'] ?? null, 'listado: limit 999 rechaza' );

// limit fuera de rango (cero).
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'limit' => 0 )
);
afirmar( 'fuera_de_rango', $resultado['campos_invalidos']['limit'] ?? null, 'listado: limit 0 rechaza' );

// limit no entero.
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'limit' => 'abc' )
);
afirmar( 'no_es_entero', $resultado['campos_invalidos']['limit'] ?? null, 'listado: limit string no-numérico rechaza' );

// limit float-no-entero.
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'limit' => '5.5' )
);
afirmar( 'no_es_entero', $resultado['campos_invalidos']['limit'] ?? null, 'listado: limit con decimales rechaza' );

// offset válido.
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'offset' => 100 )
);
afirmar( array(), $resultado['campos_invalidos'], 'listado: offset 100 sin errores' );
afirmar( 100, $resultado['offset'], 'listado: offset 100 → int' );

// offset negativo.
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'offset' => -1 )
);
afirmar( 'fuera_de_rango', $resultado['campos_invalidos']['offset'] ?? null, 'listado: offset negativo rechaza' );

// offset no entero.
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'offset' => 'xx' )
);
afirmar( 'no_es_entero', $resultado['campos_invalidos']['offset'] ?? null, 'listado: offset string no-numérico rechaza' );

// Tope superior 100 pasa, 101 falla (frontera).
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'limit' => 100 )
);
afirmar( array(), $resultado['campos_invalidos'], 'listado: limit=100 pasa (tope)' );

$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array( 'limit' => 101 )
);
afirmar( 'fuera_de_rango', $resultado['campos_invalidos']['limit'] ?? null, 'listado: limit=101 rechaza' );

// Múltiples errores se acumulan.
$resultado = NS_Companion_Cuaderno::validar_query_listado(
	array(
		'limit'  => 'abc',
		'offset' => -5,
	)
);
afirmar( 'no_es_entero', $resultado['campos_invalidos']['limit'] ?? null, 'multi listado: limit error' );
afirmar( 'fuera_de_rango', $resultado['campos_invalidos']['offset'] ?? null, 'multi listado: offset error' );

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
} else {
	fprintf( STDERR, "%d fallo(s).\n", $fallos );
	exit( 1 );
}
