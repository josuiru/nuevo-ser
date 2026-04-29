<?php
/**
 * Smoke tests de validación y hashing de
 * POST /companion/aggregates/weekly. Sin PHPUnit ni WordPress: prueba
 * las funciones puras `validar_formato` y `calcular_hash`. La parte que
 * toca DB (juego_existe, upsert, idempotencia con cache real) se valida
 * con WP-CLI o tests de integración.
 *
 * Como `calcular_hash` usa `wp_json_encode` (alias de `json_encode` con
 * algunas opciones por defecto), este harness define un fallback simple
 * para que el script corra sin WordPress cargado.
 *
 * Ejecutar con: `php tests/test_companion_agregados.php`.
 */

define( 'ABSPATH', __DIR__ );

if ( ! function_exists( 'wp_json_encode' ) ) {
	function wp_json_encode( $data, int $opciones = 0, int $profundidad = 512 ) {
		return json_encode( $data, $opciones, $profundidad );
	}
}

require_once __DIR__ . '/../includes/class-ns-filtro-tutor.php';
require_once __DIR__ . '/../includes/class-ns-companion-agregados.php';

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

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-W18',
		'aggregates' => array( 'minutos' => 42 ),
	)
);
afirmar( array(), $campos, 'agregados: body mínimo válido' );

// ─── game_id requerido ─────────────────────────────────────────

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'iso_week'   => '2026-W18',
		'aggregates' => array(),
	)
);
afirmar( 'requerido', $campos['game_id'] ?? null, 'agregados: game_id requerido cuando falta' );

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => '   ',
		'iso_week'   => '2026-W18',
		'aggregates' => array(),
	)
);
afirmar( 'requerido', $campos['game_id'] ?? null, 'agregados: game_id solo espacios rechaza' );

// ─── iso_week formato ──────────────────────────────────────────

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'aggregates' => array(),
	)
);
afirmar( 'requerido', $campos['iso_week'] ?? null, 'agregados: iso_week requerido cuando falta' );

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-18',
		'aggregates' => array(),
	)
);
afirmar( 'formato_invalido', $campos['iso_week'] ?? null, 'agregados: iso_week sin W rechaza' );

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-W00',
		'aggregates' => array(),
	)
);
afirmar( 'formato_invalido', $campos['iso_week'] ?? null, 'agregados: iso_week W00 rechaza' );

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-W54',
		'aggregates' => array(),
	)
);
afirmar( 'formato_invalido', $campos['iso_week'] ?? null, 'agregados: iso_week W54 rechaza' );

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-W53',
		'aggregates' => array(),
	)
);
afirmar( null, $campos['iso_week'] ?? null, 'agregados: iso_week W53 pasa (frontera)' );

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-W01',
		'aggregates' => array(),
	)
);
afirmar( null, $campos['iso_week'] ?? null, 'agregados: iso_week W01 pasa (frontera)' );

// ─── aggregates ────────────────────────────────────────────────

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'  => 'uno-roto',
		'iso_week' => '2026-W18',
	)
);
afirmar( 'requerido', $campos['aggregates'] ?? null, 'agregados: aggregates ausente rechaza' );

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-W18',
		'aggregates' => null,
	)
);
afirmar( 'requerido', $campos['aggregates'] ?? null, 'agregados: aggregates null rechaza' );

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-W18',
		'aggregates' => 'no-es-objeto',
	)
);
afirmar( 'debe_ser_objeto', $campos['aggregates'] ?? null, 'agregados: aggregates string rechaza' );

$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-W18',
		'aggregates' => 42,
	)
);
afirmar( 'debe_ser_objeto', $campos['aggregates'] ?? null, 'agregados: aggregates int rechaza' );

// Aggregates vacío SÍ pasa (es un objeto válido aunque sin contadores).
$campos = NS_Companion_Agregados::validar_formato(
	array(
		'game_id'    => 'uno-roto',
		'iso_week'   => '2026-W18',
		'aggregates' => array(),
	)
);
afirmar( null, $campos['aggregates'] ?? null, 'agregados: aggregates {} pasa' );

// ─── calcular_hash determinista ────────────────────────────────

$h1 = NS_Companion_Agregados::calcular_hash( array( 'a' => 1, 'b' => 2 ) );
$h2 = NS_Companion_Agregados::calcular_hash( array( 'b' => 2, 'a' => 1 ) );
afirmar( $h1, $h2, 'hash: orden de claves no afecta' );

$h3 = NS_Companion_Agregados::calcular_hash(
	array(
		'totales'     => array( 'minutos' => 42, 'mosaicos' => 1 ),
		'por_distrito' => array( 'fracciones' => array( 'aciertos' => 12 ) ),
	)
);
$h4 = NS_Companion_Agregados::calcular_hash(
	array(
		'por_distrito' => array( 'fracciones' => array( 'aciertos' => 12 ) ),
		'totales'     => array( 'mosaicos' => 1, 'minutos' => 42 ),
	)
);
afirmar( $h3, $h4, 'hash: orden de claves recursivo no afecta' );

// Listas SÍ son sensibles al orden (un cambio de orden en la lista cambia hash).
$h5 = NS_Companion_Agregados::calcular_hash( array( 'lista' => array( 'a', 'b' ) ) );
$h6 = NS_Companion_Agregados::calcular_hash( array( 'lista' => array( 'b', 'a' ) ) );
if ( $h5 === $h6 ) {
	$fallos++;
	fprintf( STDERR, "FALLO: listas deberían ser sensibles al orden\n" );
}

// Hash es SHA-256 hex de 64 chars.
afirmar( 64, strlen( $h1 ), 'hash: longitud SHA-256 hex' );

// Hash distinto para datos distintos.
$h7 = NS_Companion_Agregados::calcular_hash( array( 'a' => 1 ) );
$h8 = NS_Companion_Agregados::calcular_hash( array( 'a' => 2 ) );
if ( $h7 === $h8 ) {
	$fallos++;
	fprintf( STDERR, "FALLO: hash colisiona entre {a:1} y {a:2}\n" );
}

// ─── parsear_respuesta_llm ──────────────────────────────────────

// JSON estricto.
$r = NS_Companion_Agregados::parsear_respuesta_llm(
	'{"summary_text":"Has practicado fracciones.","conversation_prompt":"¿Qué te ha gustado?"}'
);
afirmar( 'Has practicado fracciones.', $r['summary_text'], 'parse: JSON estricto summary' );
afirmar( '¿Qué te ha gustado?', $r['conversation_prompt'], 'parse: JSON estricto prompt' );

// JSON con espacios y saltos.
$r = NS_Companion_Agregados::parsear_respuesta_llm(
	"  \n{\n  \"summary_text\": \"Buen trabajo.\",\n  \"conversation_prompt\": null\n}\n"
);
afirmar( 'Buen trabajo.', $r['summary_text'], 'parse: JSON con whitespace summary' );
afirmar( null, $r['conversation_prompt'], 'parse: JSON con prompt explícito null' );

// JSON envuelto en bloque de código markdown.
$r = NS_Companion_Agregados::parsear_respuesta_llm(
	"```json\n{\"summary_text\": \"Sigue así.\", \"conversation_prompt\": \"¿Qué pregunta tienes?\"}\n```"
);
afirmar( 'Sigue así.', $r['summary_text'], 'parse: JSON en bloque markdown summary' );
afirmar( '¿Qué pregunta tienes?', $r['conversation_prompt'], 'parse: JSON en bloque markdown prompt' );

// Texto crudo sin JSON → todo va al summary, prompt null.
$r = NS_Companion_Agregados::parsear_respuesta_llm(
	'Esta semana has avanzado en fracciones equivalentes. Sigue así.'
);
afirmar(
	'Esta semana has avanzado en fracciones equivalentes. Sigue así.',
	$r['summary_text'],
	'parse: texto crudo → summary entero'
);
afirmar( null, $r['conversation_prompt'], 'parse: texto crudo → prompt null' );

// JSON sin summary_text → fallback a texto entero.
$r = NS_Companion_Agregados::parsear_respuesta_llm( '{"otro_campo": "x"}' );
afirmar( '{"otro_campo": "x"}', $r['summary_text'], 'parse: JSON sin summary → texto entero' );
afirmar( null, $r['conversation_prompt'], 'parse: JSON sin summary → prompt null' );

// JSON con prompt vacío → null (no string vacío).
$r = NS_Companion_Agregados::parsear_respuesta_llm(
	'{"summary_text":"x","conversation_prompt":""}'
);
afirmar( 'x', $r['summary_text'], 'parse: prompt vacío summary' );
afirmar( null, $r['conversation_prompt'], 'parse: prompt vacío → null' );

// JSON anidado en texto adicional → extracción del primer bloque.
$r = NS_Companion_Agregados::parsear_respuesta_llm(
	"Aquí tienes:\n\n{\"summary_text\":\"Buen ritmo.\",\"conversation_prompt\":\"¿Qué fue lo más fácil?\"}\n\nEspero que ayude."
);
afirmar( 'Buen ritmo.', $r['summary_text'], 'parse: JSON anidado en texto summary' );
afirmar( '¿Qué fue lo más fácil?', $r['conversation_prompt'], 'parse: JSON anidado en texto prompt' );

// ─── generar_resumen integrado con stub callable ────────────────

$cliente_stub = function ( array $aggregates ): string {
	return '{"summary_text":"Has trabajado fracciones esta semana.","conversation_prompt":"¿Qué te ha sorprendido?"}';
};
$resumen = NS_Companion_Agregados::generar_resumen(
	array( 'minutos_jugados' => 42 ),
	$cliente_stub
);
afirmar( 'Has trabajado fracciones esta semana.', $resumen['summary_text'], 'generar: stub OK summary' );
afirmar( '¿Qué te ha sorprendido?', $resumen['conversation_prompt'], 'generar: stub OK prompt' );

// Filtro PII: si el LLM devuelve un email en el summary, generar_resumen lanza.
$cliente_pii = function ( array $aggregates ): string {
	return '{"summary_text":"Escríbeme a foo@bar.com","conversation_prompt":null}';
};
$lanzo = false;
try {
	NS_Companion_Agregados::generar_resumen( array(), $cliente_pii );
} catch ( Throwable $e ) {
	$lanzo = true;
}
afirmar( true, $lanzo, 'generar: filtro rechaza summary con email' );

// Filtro PII en prompt no rompe el summary; el prompt queda null.
$cliente_pii_prompt = function ( array $aggregates ): string {
	return '{"summary_text":"Buen trabajo.","conversation_prompt":"Llama al 600123456"}';
};
$resumen = NS_Companion_Agregados::generar_resumen( array(), $cliente_pii_prompt );
afirmar( 'Buen trabajo.', $resumen['summary_text'], 'generar: PII en prompt → summary se mantiene' );
afirmar( null, $resumen['conversation_prompt'], 'generar: PII en prompt → prompt null' );

// Si el cliente lanza, generar_resumen propaga.
$cliente_falla = function ( array $aggregates ): string {
	throw new RuntimeException( 'simulado' );
};
$lanzo = false;
try {
	NS_Companion_Agregados::generar_resumen( array(), $cliente_falla );
} catch ( Throwable $e ) {
	$lanzo = true;
}
afirmar( true, $lanzo, 'generar: cliente que lanza propaga' );

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
} else {
	fprintf( STDERR, "%d fallo(s).\n", $fallos );
	exit( 1 );
}
