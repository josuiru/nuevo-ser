<?php
/**
 * Política de merge en el sync. LWW por registro (doc 03 §8 pide LWW
 * por campo; en este MVP usamos el timestamp de `actualizado_en` a
 * nivel de fila — suficientemente bueno para un niño que juega en un
 * solo dispositivo a la vez).
 *
 * El cliente envía su estado local. El servidor compara timestamps
 * fila a fila y devuelve el estado ganador para cada una.
 *
 * @package UnoRotoCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class UROTO_Sincronizador {

	/**
	 * Aplica un sync completo para un niño. El $entrada es lo que
	 * mandó el cliente; la devuelta es el estado final (mezcla) que
	 * el cliente debe adoptar.
	 *
	 * Estructura de $entrada:
	 *   {
	 *     "progreso": { nombre_jugador, esquirlas_total, rango,
	 *                   arco_actual, flags, actualizado_en },
	 *     "habilidades": [ { id_habilidad, nivel, ... }, ... ]
	 *   }
	 */
	public static function sincronizar( int $nino_id, array $entrada ): array {
		$progreso_servidor = UROTO_Repositorio::cargar_progreso( $nino_id );
		$progreso_cliente  = $entrada['progreso'] ?? null;

		$progreso_final = self::mezclar_progreso(
			$nino_id,
			$progreso_servidor,
			$progreso_cliente
		);

		$habilidades_servidor = UROTO_Repositorio::cargar_habilidades( $nino_id );
		$habilidades_cliente  = $entrada['habilidades'] ?? array();

		$habilidades_finales = self::mezclar_habilidades(
			$nino_id,
			$habilidades_servidor,
			$habilidades_cliente
		);

		return array(
			'progreso'    => $progreso_final,
			'habilidades' => $habilidades_finales,
		);
	}

	private static function mezclar_progreso(
		int $nino_id,
		?array $servidor,
		?array $cliente
	): array {
		if ( ! $servidor && ! $cliente ) {
			return self::progreso_vacio( $nino_id );
		}
		if ( ! $servidor ) {
			$servidor = $cliente;
		} elseif ( ! $cliente ) {
			$cliente = $servidor;
		}

		$ganador = self::ganador_lww(
			$servidor['actualizado_en'] ?? '',
			$cliente['actualizado_en'] ?? ''
		) === 'servidor' ? $servidor : $cliente;

		UROTO_Repositorio::guardar_progreso(
			$nino_id,
			(string) ( $ganador['nombre_jugador'] ?? '' ),
			(int) ( $ganador['esquirlas_total'] ?? 0 ),
			(int) ( $ganador['rango'] ?? 0 ),
			(int) ( $ganador['arco_actual'] ?? 1 ),
			(array) ( $ganador['flags'] ?? array() ),
			(string) ( $ganador['actualizado_en'] ?? current_time( 'mysql' ) )
		);

		return UROTO_Repositorio::cargar_progreso( $nino_id );
	}

	private static function mezclar_habilidades(
		int $nino_id,
		array $servidor,
		array $cliente
	): array {
		$indice_servidor = array();
		foreach ( $servidor as $estado ) {
			$indice_servidor[ $estado['id_habilidad'] ] = $estado;
		}
		$indice_cliente = array();
		foreach ( $cliente as $estado ) {
			$indice_cliente[ $estado['id_habilidad'] ] = $estado;
		}

		$ids_todas = array_unique(
			array_merge(
				array_keys( $indice_servidor ),
				array_keys( $indice_cliente )
			)
		);

		foreach ( $ids_todas as $id_habilidad ) {
			$s = $indice_servidor[ $id_habilidad ] ?? null;
			$c = $indice_cliente[ $id_habilidad ] ?? null;
			if ( ! $s ) {
				UROTO_Repositorio::guardar_habilidad( $nino_id, $c );
				continue;
			}
			if ( ! $c ) {
				// Nada nuevo del cliente; el servidor mantiene lo suyo.
				continue;
			}
			$ganador = self::ganador_lww(
				$s['actualizado_en'] ?? '',
				$c['actualizado_en'] ?? ''
			) === 'servidor' ? $s : $c;
			UROTO_Repositorio::guardar_habilidad( $nino_id, $ganador );
		}

		return UROTO_Repositorio::cargar_habilidades( $nino_id );
	}

	private static function ganador_lww( string $ts_servidor, string $ts_cliente ): string {
		if ( ! $ts_servidor ) {
			return 'cliente';
		}
		if ( ! $ts_cliente ) {
			return 'servidor';
		}
		return strcmp( $ts_servidor, $ts_cliente ) >= 0 ? 'servidor' : 'cliente';
	}

	private static function progreso_vacio( int $nino_id ): array {
		return array(
			'nino_id'         => $nino_id,
			'nombre_jugador'  => '',
			'esquirlas_total' => 0,
			'rango'           => 0,
			'arco_actual'     => 1,
			'flags'           => array(),
			'actualizado_en'  => current_time( 'mysql' ),
		);
	}
}
