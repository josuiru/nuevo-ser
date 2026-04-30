<?php
/**
 * Smoke tests del Tutor de El Cuaderno (doc 03 §6 + doc 04 §3).
 *
 * Cubre:
 *   - NS_Prompt_Cuaderno::construir(idioma, contexto)
 *   - NS_Filtro_Cuaderno::revisar() con casos de la lista negra y de
 *     fuera de oficio.
 *   - NS_Tutor_Cuaderno::responder() con cliente Anthropic stubeado.
 *
 * Sin PHPUnit ni WordPress. Ejecutar con
 *   `php tests/test_tutor_cuaderno.php` desde la raíz del plugin.
 */

define( 'NS_TEST_STANDALONE', true );

require_once __DIR__ . '/../includes/class-ns-prompt-cuaderno.php';
require_once __DIR__ . '/../includes/class-ns-filtro-cuaderno.php';
require_once __DIR__ . '/../includes/class-ns-tutor-cuaderno.php';

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

function afirmar_contiene( string $aguja, string $pajar, string $titulo ): void {
	global $fallos;
	if ( false === strpos( $pajar, $aguja ) ) {
		$fallos++;
		fprintf(
			STDERR,
			"FALLO: %s\n  buscando '%s' en:\n%s\n",
			$titulo,
			$aguja,
			$pajar
		);
	}
}

function afirmar_no_contiene( string $aguja, string $pajar, string $titulo ): void {
	global $fallos;
	if ( false !== strpos( $pajar, $aguja ) ) {
		$fallos++;
		fprintf(
			STDERR,
			"FALLO: %s\n  encontró '%s' en:\n%s\n",
			$titulo,
			$aguja,
			$pajar
		);
	}
}

// ═══ NS_Prompt_Cuaderno ════════════════════════════════════════════

$prompt = NS_Prompt_Cuaderno::construir( 'es' );
afirmar_contiene( 'Tutor de El Cuaderno', $prompt, 'prompt: header del Tutor presente' );
afirmar_contiene( 'oficio', $prompt, 'prompt: la palabra oficio aparece' );
afirmar_contiene( 'castellano', $prompt, 'prompt: castellano se cita como idioma' );
afirmar_no_contiene( 'Contexto:', $prompt, 'prompt: sin contexto NO debe aparecer el bloque' );

$prompt_eu = NS_Prompt_Cuaderno::construir( 'eu' );
afirmar_contiene( 'euskara', $prompt_eu, 'prompt: euskara aparece como idioma destino' );

$prompt_ca = NS_Prompt_Cuaderno::construir( 'ca' );
afirmar_contiene( 'català', $prompt_ca, 'prompt: català aparece como idioma destino' );

$prompt_xx = NS_Prompt_Cuaderno::construir( 'xx' );
afirmar_contiene( 'castellano', $prompt_xx, 'prompt: idioma desconocido fallbackea a castellano' );

$prompt_ctx = NS_Prompt_Cuaderno::construir( 'es', array(
	'edad'                => 11,
	'region_code'         => 'ES-NA-PA',
	'season'              => 'primavera',
	'skill_id'            => 'TAX.05',
	'nivel_skill'         => 2,
	'observacion_adjunta' => 'pájaro pequeño marrón en el roble',
) );
afirmar_contiene( 'Contexto:', $prompt_ctx, 'prompt con contexto: aparece el bloque' );
afirmar_contiene( '11 años', $prompt_ctx, 'prompt con contexto: edad' );
afirmar_contiene( 'ES-NA-PA', $prompt_ctx, 'prompt con contexto: region' );
afirmar_contiene( 'primavera', $prompt_ctx, 'prompt con contexto: season' );
afirmar_contiene( 'TAX.05', $prompt_ctx, 'prompt con contexto: skill_id' );
afirmar_contiene( 'nivel 2', $prompt_ctx, 'prompt con contexto: nivel skill' );
afirmar_contiene( 'pájaro pequeño marrón', $prompt_ctx, 'prompt con contexto: observación' );

// Versión expuesta y estable.
afirmar( true, NS_Prompt_Cuaderno::VERSION !== '', 'prompt: VERSION no está vacía' );

// ═══ NS_Filtro_Cuaderno ════════════════════════════════════════════

$revision = NS_Filtro_Cuaderno::revisar( 'Limonera. Coincide con la clave.' );
afirmar( 'aceptada', $revision['estado'], 'filtro: respuesta correcta del Tutor pasa' );

$revision = NS_Filtro_Cuaderno::revisar( '¡Bien hecho! Es una limonera.' );
afirmar( 'regenerar', $revision['estado'], 'filtro: ¡Bien hecho! → regenerar' );
afirmar( 'bien hecho', $revision['patron'], 'filtro: detecta el patrón "bien hecho"' );

$revision = NS_Filtro_Cuaderno::revisar( '¡Genial, casi lo tienes!' );
afirmar( 'regenerar', $revision['estado'], 'filtro: "casi lo tienes" → regenerar' );

$revision = NS_Filtro_Cuaderno::revisar( 'La naturaleza es maravillosa, ¿no crees?' );
afirmar( 'regenerar', $revision['estado'], 'filtro: juicio estético → regenerar' );

$revision = NS_Filtro_Cuaderno::revisar( 'Cariño, mira el ave con calma.' );
afirmar( 'regenerar', $revision['estado'], 'filtro: apelativo cariñoso → regenerar' );

$revision = NS_Filtro_Cuaderno::revisar( 'No puedo opinar sobre política. Mejor pregúntale a un adulto.' );
afirmar( 'reemplazar_canonico', $revision['estado'], 'filtro: política → canónico' );

$revision = NS_Filtro_Cuaderno::revisar( '¿Tu novia te ayudó? Eso depende.' );
afirmar( 'reemplazar_canonico', $revision['estado'], 'filtro: relaciones personales → canónico' );

$revision = NS_Filtro_Cuaderno::revisar( 'Es importante cuidar el planeta.' );
afirmar( 'regenerar', $revision['estado'], 'filtro: moralización → regenerar' );

afirmar(
	true,
	NS_Filtro_Cuaderno::tiene_nombre_cientifico( 'Es probable que sea Erithacus rubecula, según ciertos rasgos.' ),
	'filtro: detecta nombre científico Genus species'
);
afirmar(
	false,
	NS_Filtro_Cuaderno::tiene_nombre_cientifico( 'Es un petirrojo si tiene la pechuga roja.' ),
	'filtro: nombre común no se detecta como científico'
);

// ═══ NS_Tutor_Cuaderno ═════════════════════════════════════════════

// Stub que devuelve siempre el mismo texto (caso aceptado).
$cliente_ok = function ( string $system, string $pregunta ): string {
	return 'Mira las antenas. Si la punta es blanca, es limonera. Si no, mira otra clave.';
};
$resultado = NS_Tutor_Cuaderno::responder( 'es', '¿es una limonera?', array(), $cliente_ok );
afirmar( 'aceptada', $resultado['filtro'], 'tutor: respuesta limpia → aceptada' );
afirmar_contiene( 'antenas', $resultado['respuesta'], 'tutor: respuesta del modelo se devuelve tal cual' );
afirmar( NS_Prompt_Cuaderno::VERSION, $resultado['prompt_version'], 'tutor: prompt_version se propaga' );

// Stub que devuelve vocabulario prohibido la primera vez y limpio la segunda.
$intentos = 0;
$cliente_regenera = function ( string $system, string $pregunta ) use ( &$intentos ): string {
	$intentos++;
	if ( 1 === $intentos ) {
		return '¡Bien hecho! Es una limonera.';
	}
	return 'Limonera. Coincide con la clave.';
};
$resultado = NS_Tutor_Cuaderno::responder( 'es', '¿es una limonera?', array(), $cliente_regenera );
afirmar( 2, $intentos, 'tutor: regeneración llama dos veces al cliente' );
afirmar( 'regenerada', $resultado['filtro'], 'tutor: regeneración exitosa → filtro=regenerada' );
afirmar_contiene( 'Coincide con la clave', $resultado['respuesta'], 'tutor: devuelve la segunda respuesta' );

// Stub que vuelve a contener vocabulario prohibido tras regenerar → fallback.
$cliente_terco = function ( string $system, string $pregunta ): string {
	return '¡Bien hecho! Eres una campeona.';
};
$resultado = NS_Tutor_Cuaderno::responder( 'es', '¿es una limonera?', array(), $cliente_terco );
afirmar( 'fallback_filtrado', $resultado['filtro'], 'tutor: dos fallos → fallback' );
afirmar_contiene( 'no puedo responder a eso', $resultado['respuesta'], 'tutor: fallback en castellano' );

// Stub que devuelve fuera de oficio → canónico (sin reintento).
$cliente_off = function ( string $system, string $pregunta ): string {
	return 'Sobre política, prefiero no opinar.';
};
$resultado = NS_Tutor_Cuaderno::responder( 'es', '¿qué opinas del gobierno?', array(), $cliente_off );
afirmar( 'reemplazada_canonico', $resultado['filtro'], 'tutor: fuera de oficio → canónico' );
afirmar_contiene(
	'Eso queda fuera de lo que puedo ayudar',
	$resultado['respuesta'],
	'tutor: mensaje canónico de fuera de oficio en castellano'
);

// Pregunta vacía → InvalidArgumentException.
$lanzo_invalid = false;
try {
	NS_Tutor_Cuaderno::responder( 'es', '   ', array(), $cliente_ok );
} catch ( InvalidArgumentException $e ) {
	$lanzo_invalid = true;
}
afirmar( true, $lanzo_invalid, 'tutor: pregunta vacía lanza InvalidArgumentException' );

// Pregunta demasiado larga → InvalidArgumentException.
$lanzo_invalid = false;
try {
	NS_Tutor_Cuaderno::responder( 'es', str_repeat( 'a', 1001 ), array(), $cliente_ok );
} catch ( InvalidArgumentException $e ) {
	$lanzo_invalid = true;
}
afirmar( true, $lanzo_invalid, 'tutor: pregunta >1000 chars lanza InvalidArgumentException' );

// Cuota stub: siempre permitido (TODO M004).
$cuota = NS_Tutor_Cuaderno::verificar_cuota( 42 );
afirmar( true, $cuota['permitido'], 'cuota: stub permite siempre (M004 pendiente)' );

// ═══ Resultado final ════════════════════════════════════════════════

if ( $fallos > 0 ) {
	fprintf( STDERR, "\n%d test(s) fallaron.\n", $fallos );
	exit( 1 );
}

echo "OK: smoke tests del Tutor de El Cuaderno verde.\n";
exit( 0 );
