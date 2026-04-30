<?php
/**
 * Test de paridad PHP/Dart del módulo de calibración Brier multiclass
 * — espejo de `packages/nuevo_ser_core/test/calibration/paridad_brier_test.dart`.
 *
 * Carga la fixture
 * `packages/nuevo_ser_core/test/fixtures/calibracion_brier.json` y
 * verifica que `NS_Calibracion::score_medio` produce los mismos
 * valores que el `EvaluadorCalibracion` Dart, dentro de una
 * tolerancia de 1e-12.
 *
 * Ejecutable directo: `php tests/test_paridad_calibracion.php` desde
 * la raíz del plugin. Código 0 si verde, 1 si algún caso falla.
 *
 * Sin PHPUnit, por simetría con los otros smoke tests del plugin.
 */

define( 'NS_TEST_STANDALONE', true );

require_once __DIR__ . '/../includes/class-ns-calibracion.php';

$ruta_fixture = __DIR__
	. '/../../../packages/nuevo_ser_core/test/fixtures/calibracion_brier.json';

if ( ! file_exists( $ruta_fixture ) ) {
	fwrite( STDERR, "FIXTURE NO ENCONTRADA: $ruta_fixture\n" );
	exit( 1 );
}

$fixture = json_decode( file_get_contents( $ruta_fixture ), true );
if ( null === $fixture || ! isset( $fixture['casos'] ) ) {
	fwrite( STDERR, "FIXTURE INVÁLIDA: $ruta_fixture\n" );
	exit( 1 );
}

$tolerancia = 1e-12;
$fallidos   = 0;

foreach ( $fixture['casos'] as $caso ) {
	$nombre   = $caso['nombre'];
	$entradas = $caso['entradas'];
	$esperado = (float) $caso['score_medio_esperado'];

	$obtenido = NS_Calibracion::score_medio( $entradas );
	$diff     = abs( $obtenido - $esperado );

	if ( $diff > $tolerancia ) {
		fwrite(
			STDERR,
			sprintf(
				"FALLO en caso '%s': esperado %.17f, obtenido %.17f (diff %.3e)\n",
				$nombre,
				$esperado,
				$obtenido,
				$diff
			)
		);
		$fallidos++;
		continue;
	}
	echo "OK  $nombre  → $obtenido\n";
}

echo "\n";
$total = count( $fixture['casos'] );
if ( 0 === $fallidos ) {
	echo "TODO VERDE: $total / $total casos pasaron paridad Dart/PHP.\n";
	exit( 0 );
}

fwrite( STDERR, "$fallidos de $total casos fallaron.\n" );
exit( 1 );
