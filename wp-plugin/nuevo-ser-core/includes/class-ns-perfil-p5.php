<?php
/**
 * Espejo PHP del perfil P5 compuesto (doc 03 §4 de El Cuaderno).
 *
 * Réplica literal de `PerfilP5Compuesto` (Dart, en
 * `packages/nuevo_ser_core/lib/src/mastery/perfiles/p5_compuesto.dart`).
 * Cualquier cambio en el algoritmo o en las umbrales debe espejarse en
 * ambos lados; el test `tests/test_paridad_perfil_p5.php` consume la
 * misma fixture que el equivalente Dart y debe pasar idénticamente.
 *
 * Diferencia con el motor P1: P5 no procesa intentos individuales sino
 * mediciones agregadas (precisión, rúbrica, cobertura, proxy) y devuelve
 * el nivel calculado a partir del score compuesto y umbrales adaptativos
 * sobre el histórico.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) && ! defined( 'NS_TEST_STANDALONE' ) ) {
	exit;
}

require_once __DIR__ . '/class-ns-mastery.php';

/** Componentes del perfil P5 (espejo de `ComponenteP5` Dart). */
final class NS_Componente_P5 {
	const PRECISION = 'precision';
	const RUBRICA   = 'rubrica';
	const COBERTURA = 'cobertura';
	const PROXY     = 'proxy';

	/**
	 * @return array<int,string>
	 */
	public static function todos(): array {
		return array( self::PRECISION, self::RUBRICA, self::COBERTURA, self::PROXY );
	}
}

/** Histórico abreviado para los umbrales adaptativos. */
final class NS_Historico_P5 {
	public int  $sesiones;
	public int  $semanas_distintas;
	public int  $estaciones_distintas;
	public bool $transferencia_confirmada;

	public function __construct(
		int $sesiones = 0,
		int $semanas_distintas = 0,
		int $estaciones_distintas = 0,
		bool $transferencia_confirmada = false
	) {
		$this->sesiones                 = $sesiones;
		$this->semanas_distintas        = $semanas_distintas;
		$this->estaciones_distintas     = $estaciones_distintas;
		$this->transferencia_confirmada = $transferencia_confirmada;
	}
}

/** Mediciones brutas para una habilidad. Espejo de `MedicionesP5` Dart. */
final class NS_Mediciones_P5 {
	public ?float $precision;
	public ?float $rubrica_media;
	public ?int   $cobertura_vistos;
	public ?int   $cobertura_esperados;
	public ?float $proxy;
	public NS_Historico_P5 $historico;

	public function __construct(
		NS_Historico_P5 $historico,
		?float $precision = null,
		?float $rubrica_media = null,
		?int $cobertura_vistos = null,
		?int $cobertura_esperados = null,
		?float $proxy = null
	) {
		$this->historico            = $historico;
		$this->precision            = $precision;
		$this->rubrica_media        = $rubrica_media;
		$this->cobertura_vistos     = $cobertura_vistos;
		$this->cobertura_esperados  = $cobertura_esperados;
		$this->proxy                = $proxy;
	}
}

/**
 * Pesos de cada componente para una habilidad concreta. Suman 1.0 con
 * tolerancia eps=1e-6; el constructor lo verifica.
 */
final class NS_Pesos_P5 {
	/** @var array<string,float> */
	private array $pesos;

	/**
	 * @param array<string,float> $pesos
	 */
	public function __construct( array $pesos ) {
		if ( empty( $pesos ) ) {
			throw new InvalidArgumentException( 'NS_Pesos_P5 necesita al menos un componente' );
		}
		foreach ( $pesos as $clave => $peso ) {
			if ( $peso < 0 || $peso > 1 ) {
				throw new InvalidArgumentException(
					"peso fuera de [0, 1] para '{$clave}': {$peso}"
				);
			}
		}
		$suma = array_sum( $pesos );
		if ( abs( $suma - 1.0 ) > 1e-6 ) {
			throw new InvalidArgumentException(
				"los pesos deben sumar 1.0 (suman {$suma})"
			);
		}
		$this->pesos = $pesos;
	}

	/** @return array<int,string> */
	public function componentes_aplicables(): array {
		return array_keys( $this->pesos );
	}

	public function peso_de( string $componente ): float {
		return $this->pesos[ $componente ] ?? 0.0;
	}
}

/**
 * Resultado del cálculo P5: nivel + score compuesto + breakdown.
 */
final class NS_Resultado_P5 {
	public int   $nivel;
	public float $score_compuesto;
	/** @var array<string,float> */
	public array $scores_normalizados;

	/**
	 * @param array<string,float> $scores_normalizados
	 */
	public function __construct(
		int $nivel,
		float $score_compuesto,
		array $scores_normalizados
	) {
		$this->nivel               = $nivel;
		$this->score_compuesto     = $score_compuesto;
		$this->scores_normalizados = $scores_normalizados;
	}
}

/** Umbrales adaptativos del perfil P5 (doc 03 §4.2). */
final class NS_Umbrales_P5 {
	public float $score_introducida;
	public int   $sesiones_introducida;
	public float $score_en_desarrollo;
	public int   $sesiones_en_desarrollo;
	public int   $semanas_distintas_en_desarrollo;
	public float $score_competente;
	public int   $estaciones_competente;
	public float $score_maestria;
	public int   $estaciones_maestria;
	public bool  $exige_transferencia_maestria;

	public function __construct(
		float $score_introducida = 0.30,
		int   $sesiones_introducida = 3,
		float $score_en_desarrollo = 0.50,
		int   $sesiones_en_desarrollo = 7,
		int   $semanas_distintas_en_desarrollo = 2,
		float $score_competente = 0.75,
		int   $estaciones_competente = 1,
		float $score_maestria = 0.90,
		int   $estaciones_maestria = 2,
		bool  $exige_transferencia_maestria = true
	) {
		$this->score_introducida              = $score_introducida;
		$this->sesiones_introducida           = $sesiones_introducida;
		$this->score_en_desarrollo            = $score_en_desarrollo;
		$this->sesiones_en_desarrollo         = $sesiones_en_desarrollo;
		$this->semanas_distintas_en_desarrollo = $semanas_distintas_en_desarrollo;
		$this->score_competente               = $score_competente;
		$this->estaciones_competente          = $estaciones_competente;
		$this->score_maestria                 = $score_maestria;
		$this->estaciones_maestria            = $estaciones_maestria;
		$this->exige_transferencia_maestria   = $exige_transferencia_maestria;
	}

	public static function el_cuaderno_mvp(): self {
		return new self();
	}
}

/**
 * Perfil de medición compuesto. Combina hasta cuatro componentes con
 * pesos por habilidad y umbrales adaptativos sobre el histórico.
 *
 * Esta clase es **pura**: no toca tiempo real ni almacenamiento. La
 * persistencia y el orquestado los hace el endpoint de companion que
 * consume agregados firmados.
 */
final class NS_Perfil_P5_Compuesto {
	public NS_Umbrales_P5 $umbrales;

	public function __construct( ?NS_Umbrales_P5 $umbrales = null ) {
		$this->umbrales = $umbrales ?? NS_Umbrales_P5::el_cuaderno_mvp();
	}

	public function calcular(
		NS_Mediciones_P5 $mediciones,
		NS_Pesos_P5 $pesos
	): NS_Resultado_P5 {
		$scores_normalizados = array();
		$score_compuesto     = 0.0;

		foreach ( $pesos->componentes_aplicables() as $componente ) {
			$crudo                                 = $this->normalizar( $componente, $mediciones );
			$scores_normalizados[ $componente ]    = $crudo;
			$score_compuesto                      += $crudo * $pesos->peso_de( $componente );
		}

		$nivel = $this->nivel_desde_score( $score_compuesto, $mediciones->historico );

		return new NS_Resultado_P5( $nivel, $score_compuesto, $scores_normalizados );
	}

	private function normalizar( string $componente, NS_Mediciones_P5 $m ): float {
		switch ( $componente ) {
			case NS_Componente_P5::PRECISION:
				return $this->clamp01( $m->precision ?? 0.0 );
			case NS_Componente_P5::RUBRICA:
				$media = $m->rubrica_media ?? 0.0;
				return $this->clamp01( $media / 3.0 );
			case NS_Componente_P5::COBERTURA:
				$vistos    = $m->cobertura_vistos ?? 0;
				$esperados = $m->cobertura_esperados ?? 0;
				if ( $esperados <= 0 ) {
					return 0.0;
				}
				return $this->clamp01( $vistos / $esperados );
			case NS_Componente_P5::PROXY:
				return $this->clamp01( $m->proxy ?? 0.0 );
		}
		throw new InvalidArgumentException( "Componente P5 desconocido: {$componente}" );
	}

	private function nivel_desde_score( float $score, NS_Historico_P5 $hist ): int {
		if (
			$score >= $this->umbrales->score_maestria
			&& $hist->estaciones_distintas >= $this->umbrales->estaciones_maestria
			&& ( ! $this->umbrales->exige_transferencia_maestria || $hist->transferencia_confirmada )
		) {
			return NS_Nivel_Maestria::MAESTRIA;
		}
		if (
			$score >= $this->umbrales->score_competente
			&& $hist->estaciones_distintas >= $this->umbrales->estaciones_competente
		) {
			return NS_Nivel_Maestria::COMPETENTE;
		}
		if (
			$score >= $this->umbrales->score_en_desarrollo
			&& $hist->sesiones >= $this->umbrales->sesiones_en_desarrollo
			&& $hist->semanas_distintas >= $this->umbrales->semanas_distintas_en_desarrollo
		) {
			return NS_Nivel_Maestria::EN_DESARROLLO;
		}
		if (
			$score >= $this->umbrales->score_introducida
			&& $hist->sesiones >= $this->umbrales->sesiones_introducida
		) {
			return NS_Nivel_Maestria::INTRODUCIDA;
		}
		return NS_Nivel_Maestria::INEXPLORADA;
	}

	private function clamp01( float $valor ): float {
		if ( is_nan( $valor ) ) {
			return 0.0;
		}
		if ( $valor < 0 ) {
			return 0.0;
		}
		if ( $valor > 1 ) {
			return 1.0;
		}
		return $valor;
	}
}
