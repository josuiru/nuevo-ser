<?php
/**
 * Test de paridad PHP/Dart del perfil P5 compuesto (doc 03 §4.4 de
 * El Cuaderno).
 *
 * Carga las fixtures de
 * `packages/nuevo_ser_core/test/fixtures/perfil_p5.json` — las mismas
 * que consume `perfil_p5_test.dart` — y verifica que la implementación
 * PHP produce el mismo nivel + score compuesto (eps=1e-6) + scores
 * normalizados.
 *
 * Ejecutable directo: `php tests/test_paridad_perfil_p5.php` desde la
 * raíz del plugin. Sale 0 verde, 1 con detalle del fallo.
 */

define( 'NS_TEST_STANDALONE', true );

require_once __DIR__ . '/../includes/class-ns-perfil-p5.php';

$ruta_fixture = __DIR__
	. '/../../../packages/nuevo_ser_core/test/fixtures/perfil_p5.json';

if ( ! file_exists( $ruta_fixture ) ) {
	fwrite( STDERR, "FIXTURE NO ENCONTRADA: {$ruta_fixture}\n" );
	exit( 1 );
}

$fixture = json_decode( file_get_contents( $ruta_fixture ), true );
if ( null === $fixture || ! isset( $fixture['casos'] ) ) {
	fwrite( STDERR, "FIXTURE INVÁLIDA: {$ruta_fixture}\n" );
	exit( 1 );
}

$perfil   = new NS_Perfil_P5_Compuesto();
$fallidos = 0;
$eps      = 1e-6;

foreach ( $fixture['casos'] as $caso ) {
	$nombre = $caso['nombre'];

	$mediciones = construir_mediciones( $caso['mediciones'] );
	$pesos      = new NS_Pesos_P5( normalizar_pesos( $caso['pesos'] ) );
	$esperado   = $caso['esperado'];

	$resultado = $perfil->calcular( $mediciones, $pesos );
	$errores   = comparar_resultado( $resultado, $esperado, $eps );

	if ( empty( $errores ) ) {
		echo "OK  {$nombre}\n";
	} else {
		$fallidos++;
		echo "FAIL  {$nombre}\n";
		foreach ( $errores as $err ) {
			echo "      - {$err}\n";
		}
	}
}

if ( $fallidos > 0 ) {
	fwrite( STDERR, "\n{$fallidos} caso(s) fallaron.\n" );
	exit( 1 );
}

echo "\nOK: paridad P5 PHP/Dart verde para todos los casos.\n";
exit( 0 );


// ─── helpers ────────────────────────────────────────────────────────

function construir_mediciones( array $datos ): NS_Mediciones_P5 {
	$h        = $datos['historico'];
	$historico = new NS_Historico_P5(
		$h['sesiones']             ?? 0,
		$h['semanas_distintas']    ?? 0,
		$h['estaciones']           ?? 0,
		(bool) ( $h['transferencia'] ?? false )
	);
	return new NS_Mediciones_P5(
		$historico,
		isset( $datos['precision'] ) ? (float) $datos['precision'] : null,
		isset( $datos['rubrica_media'] ) ? (float) $datos['rubrica_media'] : null,
		isset( $datos['cobertura_vistos'] ) ? (int) $datos['cobertura_vistos'] : null,
		isset( $datos['cobertura_esperados'] ) ? (int) $datos['cobertura_esperados'] : null,
		isset( $datos['proxy'] ) ? (float) $datos['proxy'] : null
	);
}

function normalizar_pesos( array $pesos ): array {
	$resultado = array();
	foreach ( $pesos as $clave => $valor ) {
		$resultado[ $clave ] = (float) $valor;
	}
	return $resultado;
}

function comparar_resultado( NS_Resultado_P5 $real, array $esperado, float $eps ): array {
	$errores = array();
	if ( $real->nivel !== (int) $esperado['nivel'] ) {
		$errores[] = "nivel: esperado {$esperado['nivel']}, obtenido {$real->nivel}";
	}
	$score_esperado = (float) $esperado['score_compuesto'];
	if ( abs( $real->score_compuesto - $score_esperado ) > $eps ) {
		$errores[] = sprintf(
			'score_compuesto: esperado %.10f, obtenido %.10f (delta %.10f > eps %.10f)',
			$score_esperado,
			$real->score_compuesto,
			abs( $real->score_compuesto - $score_esperado ),
			$eps
		);
	}
	foreach ( $esperado['scores'] as $componente => $valor_esperado ) {
		$valor_obtenido = $real->scores_normalizados[ $componente ] ?? null;
		if ( null === $valor_obtenido ) {
			$errores[] = "scores[{$componente}]: ausente en el resultado";
			continue;
		}
		if ( abs( $valor_obtenido - (float) $valor_esperado ) > $eps ) {
			$errores[] = sprintf(
				'scores[%s]: esperado %.10f, obtenido %.10f',
				$componente,
				(float) $valor_esperado,
				$valor_obtenido
			);
		}
	}
	return $errores;
}
