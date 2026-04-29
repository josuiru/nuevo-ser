<?php
/**
 * Smoke tests de validación de POST /companion/mosaicos.
 * Sin PHPUnit ni WordPress: prueba la función pura
 * `NS_Companion_Mosaicos::validar_formato`. La parte que toca DB
 * (`juego_existe`) se valida con WP-CLI o tests de integración.
 *
 * Ejecutar con: `php tests/test_companion_mosaicos.php`.
 */

define( 'ABSPATH', __DIR__ );

require_once __DIR__ . '/../includes/class-ns-companion-mosaicos.php';

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

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'arc_id'  => 'distrito-A',
		'title'   => 'Mosaico',
	)
);
afirmar( array(), $campos, 'mosaicos: body mínimo válido' );

// ─── Body válido completo ──────────────────────────────────────

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'              => 'uno-roto',
		'arc_id'               => 'distrito-fracciones',
		'format'               => 'video',
		'title'                => 'El Pleno y las fracciones',
		'content_ref'          => 'video/abc',
		'content_meta'         => array( 'segundos' => 90 ),
		'required_anchors'     => array( 'FR.05', 'FR.07' ),
		'fulfilled_anchors'    => array( 'FR.05' ),
		'qualitative_feedback' => 'Buen ejemplo del concepto de Pleno.',
	)
);
afirmar( array(), $campos, 'mosaicos: body completo válido' );

// ─── game_id requerido ─────────────────────────────────────────

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'arc_id' => 'X',
		'title'  => 'Y',
	)
);
afirmar( 'requerido', $campos['game_id'] ?? null, 'mosaicos: game_id requerido cuando falta' );

// ─── arc_id requerido ──────────────────────────────────────────

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'title'   => 'X',
	)
);
afirmar( 'requerido', $campos['arc_id'] ?? null, 'mosaicos: arc_id requerido cuando falta' );

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'arc_id'  => '   ',
		'title'   => 'X',
	)
);
afirmar( 'requerido', $campos['arc_id'] ?? null, 'mosaicos: arc_id requerido cuando es solo espacios' );

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'arc_id'  => str_repeat( 'a', 65 ),
		'title'   => 'X',
	)
);
afirmar( 'demasiado_largo', $campos['arc_id'] ?? null, 'mosaicos: arc_id 65 chars rechaza' );

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'arc_id'  => str_repeat( 'a', 64 ),
		'title'   => 'X',
	)
);
afirmar( null, $campos['arc_id'] ?? null, 'mosaicos: arc_id 64 chars pasa' );

// ─── title requerido ───────────────────────────────────────────

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'arc_id'  => 'X',
	)
);
afirmar( 'requerido', $campos['title'] ?? null, 'mosaicos: title requerido cuando falta' );

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'arc_id'  => 'X',
		'title'   => str_repeat( 'a', 256 ),
	)
);
afirmar( 'demasiado_largo', $campos['title'] ?? null, 'mosaicos: title 256 chars rechaza' );

// ─── format ────────────────────────────────────────────────────

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'arc_id'  => 'X',
		'title'   => 'Y',
		'format'  => 'CON-MAYUS',
	)
);
afirmar( 'formato_invalido', $campos['format'] ?? null, 'mosaicos: format CON-MAYUS rechaza' );

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'arc_id'  => 'X',
		'title'   => 'Y',
		'format'  => 'video_largo',
	)
);
afirmar( null, $campos['format'] ?? null, 'mosaicos: format snake_case pasa' );

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id' => 'uno-roto',
		'arc_id'  => 'X',
		'title'   => 'Y',
		'format'  => str_repeat( 'a', 33 ),
	)
);
afirmar( 'demasiado_largo', $campos['format'] ?? null, 'mosaicos: format 33 chars rechaza' );

// ─── content_ref demasiado largo ───────────────────────────────

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'     => 'uno-roto',
		'arc_id'      => 'X',
		'title'       => 'Y',
		'content_ref' => str_repeat( 'a', 256 ),
	)
);
afirmar( 'demasiado_largo', $campos['content_ref'] ?? null, 'mosaicos: content_ref 256 chars rechaza' );

// ─── content_meta debe ser objeto ──────────────────────────────

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'      => 'uno-roto',
		'arc_id'       => 'X',
		'title'        => 'Y',
		'content_meta' => 'no soy objeto',
	)
);
afirmar( 'debe_ser_objeto', $campos['content_meta'] ?? null, 'mosaicos: content_meta string rechaza' );

// ─── required_anchors / fulfilled_anchors ──────────────────────

// Lista (array indexado) pasa.
$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'          => 'uno-roto',
		'arc_id'           => 'X',
		'title'            => 'Y',
		'required_anchors' => array( 'FR.05', 'FR.07' ),
	)
);
afirmar( null, $campos['required_anchors'] ?? null, 'mosaicos: required_anchors lista pasa' );

// Objeto (array asociativo) pasa.
$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'           => 'uno-roto',
		'arc_id'            => 'X',
		'title'             => 'Y',
		'fulfilled_anchors' => array( 'FR.05' => array( 'nivel' => 2 ) ),
	)
);
afirmar( null, $campos['fulfilled_anchors'] ?? null, 'mosaicos: fulfilled_anchors objeto pasa' );

// String NO pasa.
$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'          => 'uno-roto',
		'arc_id'           => 'X',
		'title'            => 'Y',
		'required_anchors' => 'FR.05',
	)
);
afirmar( 'debe_ser_lista_u_objeto', $campos['required_anchors'] ?? null, 'mosaicos: required_anchors string rechaza' );

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'           => 'uno-roto',
		'arc_id'            => 'X',
		'title'             => 'Y',
		'fulfilled_anchors' => 42,
	)
);
afirmar( 'debe_ser_lista_u_objeto', $campos['fulfilled_anchors'] ?? null, 'mosaicos: fulfilled_anchors int rechaza' );

// null se acepta (campo opcional ausente).
$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'           => 'uno-roto',
		'arc_id'            => 'X',
		'title'             => 'Y',
		'required_anchors'  => null,
		'fulfilled_anchors' => null,
	)
);
afirmar( null, $campos['required_anchors'] ?? null, 'mosaicos: required_anchors null pasa' );
afirmar( null, $campos['fulfilled_anchors'] ?? null, 'mosaicos: fulfilled_anchors null pasa' );

// ─── qualitative_feedback ──────────────────────────────────────

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'              => 'uno-roto',
		'arc_id'               => 'X',
		'title'                => 'Y',
		'qualitative_feedback' => 42,
	)
);
afirmar( 'debe_ser_string', $campos['qualitative_feedback'] ?? null, 'mosaicos: qualitative_feedback int rechaza' );

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'game_id'              => 'uno-roto',
		'arc_id'               => 'X',
		'title'                => 'Y',
		'qualitative_feedback' => 'Texto cualitativo válido.',
	)
);
afirmar( null, $campos['qualitative_feedback'] ?? null, 'mosaicos: qualitative_feedback string pasa' );

// ─── Múltiples errores se devuelven juntos ──────────────────────

$campos = NS_Companion_Mosaicos::validar_formato(
	array(
		'format'           => 'CON-GUIONES',
		'required_anchors' => 'no es lista',
	)
);
afirmar( 'requerido', $campos['game_id'] ?? null, 'multi: game_id falta' );
afirmar( 'requerido', $campos['arc_id'] ?? null, 'multi: arc_id falta' );
afirmar( 'requerido', $campos['title'] ?? null, 'multi: title falta' );
afirmar( 'formato_invalido', $campos['format'] ?? null, 'multi: format formato' );
afirmar( 'debe_ser_lista_u_objeto', $campos['required_anchors'] ?? null, 'multi: required_anchors tipo' );

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
} else {
	fprintf( STDERR, "%d fallo(s).\n", $fallos );
	exit( 1 );
}
