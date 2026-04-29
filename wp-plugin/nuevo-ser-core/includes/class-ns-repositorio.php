<?php
/**
 * CRUD sobre las tablas de Uno Roto. Capa fina encima de $wpdb que
 * centraliza nombres de tabla, prepared statements y conversiones
 * JSON. No hace validación ni negocio; eso vive en los endpoints y
 * el sincronizador.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Repositorio {

	// -------------------------------------------------------------
	// Usuarios (tutores legales).
	// -------------------------------------------------------------

	public static function crear_usuario(
		string $email,
		string $password_hash,
		string $nombre_tutor,
		string $locale = 'es'
	): int {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'usuarios' );
		$wpdb->insert(
			$tabla,
			array(
				'email'         => $email,
				'password_hash' => $password_hash,
				'nombre_tutor'  => $nombre_tutor,
				'locale'        => $locale,
			),
			array( '%s', '%s', '%s', '%s' )
		);
		return (int) $wpdb->insert_id;
	}

	public static function buscar_usuario_por_email( string $email ): ?array {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'usuarios' );
		$fila  = $wpdb->get_row(
			$wpdb->prepare( "SELECT * FROM {$tabla} WHERE email = %s LIMIT 1", $email ),
			ARRAY_A
		);
		return $fila ?: null;
	}

	// -------------------------------------------------------------
	// Niños.
	// -------------------------------------------------------------

	public static function crear_nino(
		int $usuario_id,
		string $nombre_mostrar,
		string $locale = 'es'
	): int {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'ninos' );
		$wpdb->insert(
			$tabla,
			array(
				'usuario_id'     => $usuario_id,
				'nombre_mostrar' => $nombre_mostrar,
				'locale'         => $locale,
			),
			array( '%d', '%s', '%s' )
		);
		return (int) $wpdb->insert_id;
	}

	public static function buscar_nino( int $nino_id ): ?array {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'ninos' );
		$fila  = $wpdb->get_row(
			$wpdb->prepare( "SELECT * FROM {$tabla} WHERE id = %d LIMIT 1", $nino_id ),
			ARRAY_A
		);
		return $fila ?: null;
	}

	public static function ninos_de_usuario( int $usuario_id ): array {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'ninos' );
		return $wpdb->get_results(
			$wpdb->prepare(
				"SELECT * FROM {$tabla} WHERE usuario_id = %d ORDER BY creado_en ASC",
				$usuario_id
			),
			ARRAY_A
		) ?: array();
	}

	// -------------------------------------------------------------
	// Progreso.
	// -------------------------------------------------------------

	public static function cargar_progreso( int $nino_id ): ?array {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'progreso' );
		$fila  = $wpdb->get_row(
			$wpdb->prepare( "SELECT * FROM {$tabla} WHERE nino_id = %d LIMIT 1", $nino_id ),
			ARRAY_A
		);
		if ( ! $fila ) {
			return null;
		}
		// MySQL devuelve todo como string; casteamos a los tipos que
		// el cliente Dart espera.
		return array(
			'nino_id'         => (int) $fila['nino_id'],
			'nombre_jugador'  => (string) $fila['nombre_jugador'],
			'esquirlas_total' => (int) $fila['esquirlas_total'],
			'rango'           => (int) $fila['rango'],
			'arco_actual'     => (int) $fila['arco_actual'],
			'flags'           => json_decode( $fila['flags_json'] ?: '{}', true ) ?: array(),
			'actualizado_en'  => (string) $fila['actualizado_en'],
		);
	}

	/**
	 * Inserta o actualiza el progreso del niño. Sobrescribe; la
	 * política de merge (LWW por registro) la aplica el llamador.
	 */
	public static function guardar_progreso(
		int $nino_id,
		string $nombre_jugador,
		int $esquirlas_total,
		int $rango,
		int $arco_actual,
		array $flags,
		string $actualizado_en
	): void {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'progreso' );
		$wpdb->replace(
			$tabla,
			array(
				'nino_id'         => $nino_id,
				'nombre_jugador'  => $nombre_jugador,
				'esquirlas_total' => $esquirlas_total,
				'rango'           => $rango,
				'arco_actual'     => $arco_actual,
				'flags_json'      => wp_json_encode( $flags ),
				'actualizado_en'  => $actualizado_en,
			),
			array( '%d', '%s', '%d', '%d', '%d', '%s', '%s' )
		);
	}

	// -------------------------------------------------------------
	// Estado de habilidades.
	// -------------------------------------------------------------

	public static function cargar_habilidades( int $nino_id ): array {
		global $wpdb;
		$tabla    = NS_Esquema::nombre_tabla( 'estado_habilidades' );
		$filas    = $wpdb->get_results(
			$wpdb->prepare( "SELECT * FROM {$tabla} WHERE nino_id = %d", $nino_id ),
			ARRAY_A
		) ?: array();
		$normales = array();
		foreach ( $filas as $fila ) {
			$normales[] = array(
				'nino_id'                      => (int) $fila['nino_id'],
				'id_habilidad'                 => (string) $fila['id_habilidad'],
				'nivel'                        => (int) $fila['nivel'],
				'precision_ponderada'          => (float) $fila['precision_ponderada'],
				'tiempo_mediano_seg'           => (float) $fila['tiempo_mediano_seg'],
				'total_exposiciones'           => (int) $fila['total_exposiciones'],
				'sesiones_consecutivas_buenas' => (int) $fila['sesiones_consecutivas_buenas'],
				'ultima_practica'              => (string) $fila['ultima_practica'],
				'intentos_recientes'           => json_decode(
					$fila['intentos_recientes_json'] ?: '[]',
					true
				) ?: array(),
				'actualizado_en'               => (string) $fila['actualizado_en'],
			);
		}
		return $normales;
	}

	public static function guardar_habilidad( int $nino_id, array $estado ): void {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'estado_habilidades' );
		$wpdb->replace(
			$tabla,
			array(
				'nino_id'                       => $nino_id,
				'id_habilidad'                  => (string) $estado['id_habilidad'],
				'nivel'                         => (int) ( $estado['nivel'] ?? 0 ),
				'precision_ponderada'           => (float) ( $estado['precision_ponderada'] ?? 0 ),
				'tiempo_mediano_seg'            => (float) ( $estado['tiempo_mediano_seg'] ?? 0 ),
				'total_exposiciones'            => (int) ( $estado['total_exposiciones'] ?? 0 ),
				'sesiones_consecutivas_buenas'  => (int) ( $estado['sesiones_consecutivas_buenas'] ?? 0 ),
				'ultima_practica'               => (string) ( $estado['ultima_practica'] ?? '1970-01-01 00:00:00' ),
				'intentos_recientes_json'       => wp_json_encode( $estado['intentos_recientes'] ?? array() ),
				'actualizado_en'                => (string) ( $estado['actualizado_en'] ?? current_time( 'mysql' ) ),
			),
			array( '%d', '%s', '%d', '%f', '%f', '%d', '%d', '%s', '%s', '%s' )
		);
	}

	// -------------------------------------------------------------
	// Borrado GDPR.
	// -------------------------------------------------------------

	public static function borrar_cuenta( int $usuario_id ): void {
		global $wpdb;
		$ninos = self::ninos_de_usuario( $usuario_id );
		foreach ( $ninos as $nino ) {
			$wpdb->delete(
				NS_Esquema::nombre_tabla( 'estado_habilidades' ),
				array( 'nino_id' => (int) $nino['id'] ),
				array( '%d' )
			);
			$wpdb->delete(
				NS_Esquema::nombre_tabla( 'progreso' ),
				array( 'nino_id' => (int) $nino['id'] ),
				array( '%d' )
			);
		}
		$wpdb->delete(
			NS_Esquema::nombre_tabla( 'ninos' ),
			array( 'usuario_id' => $usuario_id ),
			array( '%d' )
		);
		$wpdb->delete(
			NS_Esquema::nombre_tabla( 'usuarios' ),
			array( 'id' => $usuario_id ),
			array( '%d' )
		);
	}
}
