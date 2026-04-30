<?php
/**
 * Espejo PHP del módulo de calibración Brier multiclass — equivalente
 * de `packages/nuevo_ser_core/lib/src/calibration/evaluador_calibracion.dart`.
 *
 * La doc nuevo-ser-core-arquitectura.md §6.2 exige paridad bit a bit
 * con el cálculo Dart cuando el backend procese los agregados de
 * calibración (`/companion/aggregates/weekly` con metadata de
 * declaración por afirmación). Esta implementación reproduce
 * exactamente la fórmula Brier multiclass normalizada del cliente y
 * el test `tests/test_paridad_calibracion.php` consume la misma
 * fixture que el lado Dart.
 *
 * Niveles de confianza válidos: 'solido', 'probable', 'disputado'.
 * Cualquier otro valor en la entrada lanza InvalidArgumentException.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) && ! defined( 'NS_TEST_STANDALONE' ) ) {
	exit;
}

class NS_Calibracion {

	const NIVELES_VALIDOS = [ 'solido', 'probable', 'disputado' ];

	/**
	 * Score Brier multiclass normalizado para un par (correcto, declarado).
	 * Devuelve 1.0 si acierta, 0.0 si no — con predicciones duras
	 * (categóricas), pero la fórmula está preparada para que se
	 * generalice a probabilidades cuando se admitan.
	 *
	 * @param string $correcto Nivel canónico de la afirmación.
	 * @param string $declarado Nivel que declaró la persona usuaria.
	 * @return float Score normalizado en [0, 1].
	 * @throws InvalidArgumentException Si algún nivel no está en NIVELES_VALIDOS.
	 */
	public static function score_individual( $correcto, $declarado ) {
		self::validar_nivel( $correcto, 'correcto' );
		self::validar_nivel( $declarado, 'declarado' );
		$brier_max = 2.0;
		$brier     = 0.0;
		foreach ( self::NIVELES_VALIDOS as $nivel ) {
			$prediccion  = ( $nivel === $declarado ) ? 1.0 : 0.0;
			$observacion = ( $nivel === $correcto ) ? 1.0 : 0.0;
			$diff        = $prediccion - $observacion;
			$brier      += $diff * $diff;
		}
		return 1.0 - ( $brier / $brier_max );
	}

	/**
	 * Score medio sobre una lista de pares — equivalente del
	 * `ResultadoCalibracion.scoreMedio` de Dart.
	 *
	 * @param array<int, array{correcto: string, declarado: string}> $entradas
	 * @return float Promedio en [0, 1]. Lista vacía → 0.0.
	 */
	public static function score_medio( $entradas ) {
		if ( empty( $entradas ) ) {
			return 0.0;
		}
		$suma = 0.0;
		foreach ( $entradas as $entrada ) {
			if ( ! is_array( $entrada ) || ! isset( $entrada['correcto'], $entrada['declarado'] ) ) {
				throw new InvalidArgumentException(
					'Entrada de calibracion mal formada: requiere claves "correcto" y "declarado".'
				);
			}
			$suma += self::score_individual( $entrada['correcto'], $entrada['declarado'] );
		}
		return $suma / count( $entradas );
	}

	/**
	 * Cuenta cuántas entradas acertaron el nivel — útil para mostrar
	 * "X de N aciertos" en informes/dashboards.
	 *
	 * @param array<int, array{correcto: string, declarado: string}> $entradas
	 * @return int
	 */
	public static function contar_aciertos( $entradas ) {
		$aciertos = 0;
		foreach ( $entradas as $entrada ) {
			if ( ! is_array( $entrada ) || ! isset( $entrada['correcto'], $entrada['declarado'] ) ) {
				continue;
			}
			self::validar_nivel( $entrada['correcto'], 'correcto' );
			self::validar_nivel( $entrada['declarado'], 'declarado' );
			if ( $entrada['correcto'] === $entrada['declarado'] ) {
				$aciertos++;
			}
		}
		return $aciertos;
	}

	private static function validar_nivel( $valor, $etiqueta ) {
		if ( ! in_array( $valor, self::NIVELES_VALIDOS, true ) ) {
			throw new InvalidArgumentException(
				"Nivel de confianza desconocido en campo '$etiqueta': '$valor'. "
				. 'Esperado uno de: ' . implode( ', ', self::NIVELES_VALIDOS ) . '.'
			);
		}
	}
}
