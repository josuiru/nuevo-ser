<?php
/**
 * Esquema de las tablas de Uno Roto en MySQL. Todas con prefijo
 * `{$wpdb->prefix}uroto_`. Diseñadas idempotentes con dbDelta().
 *
 * Modelo mínimo:
 * - uroto_usuarios: el tutor legal. Email + password.
 * - uroto_ninos: perfiles de niños asociados a un tutor.
 * - uroto_progreso: estado global del niño (esquirlas, rango,
 *   nombre_jugador, flags JSON, arco actual).
 * - uroto_estado_habilidades: fila por (niño, habilidad) con nivel,
 *   precisión y métricas del motor de maestría.
 *
 * El guion completo del juego y los flags narrativos se guardan como
 * JSON en uroto_progreso.flags_json — el cliente es la fuente de
 * verdad sobre qué flags significan qué; el servidor solo los persiste
 * y los sincroniza.
 *
 * @package UnoRotoCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class UROTO_Esquema {

	public static function nombre_tabla( string $clave ): string {
		global $wpdb;
		return $wpdb->prefix . 'uroto_' . $clave;
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
		$usuarios        = self::nombre_tabla( 'usuarios' );
		$ninos           = self::nombre_tabla( 'ninos' );
		$progreso        = self::nombre_tabla( 'progreso' );
		$habilidades     = self::nombre_tabla( 'estado_habilidades' );

		return array(
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
				nombre_jugador VARCHAR(60) NOT NULL DEFAULT '',
				esquirlas_total INT UNSIGNED NOT NULL DEFAULT 0,
				rango TINYINT UNSIGNED NOT NULL DEFAULT 0,
				arco_actual TINYINT UNSIGNED NOT NULL DEFAULT 1,
				flags_json LONGTEXT NOT NULL,
				actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
				PRIMARY KEY  (nino_id)
			) {$charset_collate};",

			"CREATE TABLE {$habilidades} (
				nino_id BIGINT UNSIGNED NOT NULL,
				id_habilidad VARCHAR(24) NOT NULL,
				nivel TINYINT UNSIGNED NOT NULL DEFAULT 0,
				precision_ponderada DECIMAL(4,3) NOT NULL DEFAULT 0,
				tiempo_mediano_seg DECIMAL(6,2) NOT NULL DEFAULT 0,
				total_exposiciones INT UNSIGNED NOT NULL DEFAULT 0,
				sesiones_consecutivas_buenas INT UNSIGNED NOT NULL DEFAULT 0,
				ultima_practica DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
				intentos_recientes_json LONGTEXT NOT NULL,
				actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
				PRIMARY KEY  (nino_id, id_habilidad)
			) {$charset_collate};",
		);
	}
}
