<?php
/**
 * Esquema MySQL de la plataforma Nuevo Ser Core. Todas las tablas con prefijo
 * `{$wpdb->prefix}ns_` (renombrado en C4 desde `{$wpdb->prefix}uroto_`).
 *
 * Modelo:
 * - ns_games: registro de juegos disponibles (uno-roto, las-versiones…).
 *   Permite multi-tenancy: una misma instalación puede alojar varios juegos.
 * - ns_usuarios: tutor legal. Email + password. Compartido entre juegos.
 * - ns_ninos: perfiles de niños asociados a un tutor. Compartidos entre juegos.
 * - ns_progreso: estado global del niño POR JUEGO (esquirlas, rango,
 *   nombre_jugador, flags JSON, arco actual). PK = (nino_id, game_id).
 * - ns_estado_habilidades: fila por (niño, habilidad, juego) con nivel,
 *   precisión y métricas del motor de maestría. PK = (nino_id, id_habilidad, game_id).
 * - ns_cache_tutor: caché de respuestas del Tutor IA. Compartida entre niños
 *   (sin PII en el contenido). game_id como columna informativa para stats.
 * - ns_password_reset: tokens de reset de contraseña. Compartido entre juegos.
 *
 * El guion completo del juego y los flags narrativos se guardan como JSON
 * en ns_progreso.flags_json — el cliente es la fuente de verdad sobre qué
 * flags significan qué; el servidor solo los persiste y los sincroniza.
 *
 * Renombrado semántico (`progreso` → `mastery_records`, etc.) diferido a v1.5.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Esquema {

	/**
	 * Mapa clave lógica → sufijo bajo el prefijo del wpdb. La clave es
	 * estable y vive en el código; el prefijo cambia entre instalaciones
	 * (`wp_`, `wp_test_`, …).
	 */
	public const SUFIJOS = array(
		'games'              => 'ns_games',
		'usuarios'           => 'ns_usuarios',
		'ninos'              => 'ns_ninos',
		'progreso'           => 'ns_progreso',
		'estado_habilidades' => 'ns_estado_habilidades',
		'cache_tutor'        => 'ns_cache_tutor',
		'password_reset'     => 'ns_password_reset',
	);

	/** Mapeo del prefijo viejo al nuevo. Lo usa la migración M001. */
	public const SUFIJOS_VIEJOS = array(
		'usuarios'           => 'uroto_usuarios',
		'ninos'              => 'uroto_ninos',
		'progreso'           => 'uroto_progreso',
		'estado_habilidades' => 'uroto_estado_habilidades',
		'cache_tutor'        => 'uroto_cache_tutor',
		'password_reset'     => 'uroto_password_reset',
	);

	public static function nombre_tabla( string $clave ): string {
		global $wpdb;
		if ( ! isset( self::SUFIJOS[ $clave ] ) ) {
			throw new InvalidArgumentException( "Tabla desconocida: {$clave}" );
		}
		return $wpdb->prefix . self::SUFIJOS[ $clave ];
	}

	public static function nombre_tabla_vieja( string $clave ): string {
		global $wpdb;
		if ( ! isset( self::SUFIJOS_VIEJOS[ $clave ] ) ) {
			throw new InvalidArgumentException( "Tabla vieja desconocida: {$clave}" );
		}
		return $wpdb->prefix . self::SUFIJOS_VIEJOS[ $clave ];
	}

	/**
	 * SQL CREATE TABLE para cada tabla. dbDelta() requiere formato
	 * específico: PRIMARY KEY  con dos espacios, sin AUTO_INCREMENT en
	 * el CREATE si ya lo tiene, etc. Ver codex.wordpress.org/Creating_Tables_with_Plugins.
	 *
	 * @return string[] SQL statements.
	 */
	public static function sentencias_create(): array {
		global $wpdb;
		$charset_collate = $wpdb->get_charset_collate();
		$games           = self::nombre_tabla( 'games' );
		$usuarios        = self::nombre_tabla( 'usuarios' );
		$ninos           = self::nombre_tabla( 'ninos' );
		$progreso        = self::nombre_tabla( 'progreso' );
		$habilidades     = self::nombre_tabla( 'estado_habilidades' );
		$cache_tutor     = self::nombre_tabla( 'cache_tutor' );
		$reset_password  = self::nombre_tabla( 'password_reset' );

		return array(
			"CREATE TABLE {$games} (
				id VARCHAR(64) NOT NULL,
				name VARCHAR(128) NOT NULL,
				age_min TINYINT UNSIGNED NOT NULL,
				age_max TINYINT UNSIGNED NOT NULL,
				schema_version VARCHAR(16) NOT NULL DEFAULT '1.0',
				active TINYINT(1) NOT NULL DEFAULT 1,
				created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
				PRIMARY KEY  (id)
			) {$charset_collate};",

			"CREATE TABLE {$usuarios} (
				id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
				email VARCHAR(190) NOT NULL,
				password_hash VARCHAR(255) NOT NULL,
				nombre_tutor VARCHAR(120) NOT NULL DEFAULT '',
				locale VARCHAR(8) NOT NULL DEFAULT 'es',
				creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
				actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
				PRIMARY KEY  (id),
				UNIQUE KEY email (email)
			) {$charset_collate};",

			"CREATE TABLE {$ninos} (
				id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
				usuario_id BIGINT UNSIGNED NOT NULL,
				nombre_mostrar VARCHAR(60) NOT NULL,
				locale VARCHAR(8) NOT NULL DEFAULT 'es',
				creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
				actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
				PRIMARY KEY  (id),
				KEY usuario_id (usuario_id)
			) {$charset_collate};",

			"CREATE TABLE {$progreso} (
				nino_id BIGINT UNSIGNED NOT NULL,
				game_id VARCHAR(64) NOT NULL DEFAULT 'uno-roto',
				nombre_jugador VARCHAR(60) NOT NULL DEFAULT '',
				esquirlas_total INT UNSIGNED NOT NULL DEFAULT 0,
				rango TINYINT UNSIGNED NOT NULL DEFAULT 0,
				arco_actual TINYINT UNSIGNED NOT NULL DEFAULT 1,
				flags_json LONGTEXT NOT NULL,
				actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
				PRIMARY KEY  (nino_id, game_id)
			) {$charset_collate};",

			"CREATE TABLE {$habilidades} (
				nino_id BIGINT UNSIGNED NOT NULL,
				id_habilidad VARCHAR(24) NOT NULL,
				game_id VARCHAR(64) NOT NULL DEFAULT 'uno-roto',
				nivel TINYINT UNSIGNED NOT NULL DEFAULT 0,
				precision_ponderada DECIMAL(4,3) NOT NULL DEFAULT 0,
				tiempo_mediano_seg DECIMAL(6,2) NOT NULL DEFAULT 0,
				total_exposiciones INT UNSIGNED NOT NULL DEFAULT 0,
				sesiones_consecutivas_buenas INT UNSIGNED NOT NULL DEFAULT 0,
				ultima_practica DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
				intentos_recientes_json LONGTEXT NOT NULL,
				actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
				PRIMARY KEY  (nino_id, id_habilidad, game_id)
			) {$charset_collate};",

			"CREATE TABLE {$cache_tutor} (
				clave_hash CHAR(64) NOT NULL,
				id_habilidad VARCHAR(24) NOT NULL,
				game_id VARCHAR(64) NOT NULL DEFAULT 'uno-roto',
				pregunta TEXT NOT NULL,
				respuesta LONGTEXT NOT NULL,
				creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
				usos INT UNSIGNED NOT NULL DEFAULT 0,
				PRIMARY KEY  (clave_hash),
				KEY id_habilidad (id_habilidad),
				KEY game_id (game_id),
				KEY creado_en (creado_en)
			) {$charset_collate};",

			"CREATE TABLE {$reset_password} (
				id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
				usuario_id BIGINT UNSIGNED NOT NULL,
				token_hash CHAR(64) NOT NULL,
				expira_en DATETIME NOT NULL,
				usado_en DATETIME NULL DEFAULT NULL,
				creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
				PRIMARY KEY  (id),
				UNIQUE KEY token_hash (token_hash),
				KEY usuario_id (usuario_id),
				KEY expira_en (expira_en)
			) {$charset_collate};",
		);
	}

	/**
	 * Filas seed para `ns_games`. INSERT IGNORE — idempotente.
	 *
	 * Las Versiones (10-14) y futuros juegos se añaden cuando sus apps
	 * empiecen a sincronizar; mantener esta lista corta evita que la tabla
	 * declare juegos que aún no existen como producto.
	 */
	public static function games_seed(): array {
		return array(
			array(
				'id'             => 'uno-roto',
				'name'           => 'Uno Roto',
				'age_min'        => 9,
				'age_max'        => 12,
				'schema_version' => '1.0',
			),
		);
	}
}
