<?php
/**
 * Hooks de activación y desactivación. En activación aplica las
 * migraciones con dbDelta() y resuelve la M001 (rename de prefijo
 * wp_uroto_* → wp_ns_*); idempotente si el esquema ya está al día.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Activacion {

	private const HOOK_PURGA_TUTOR = 'uroto_cron_purga_tutor';

	/**
	 * Nombre de la opción que registra la versión de schema instalada.
	 * Se mantiene el prefijo `uroto_` por decisión D5 — es BD persistent
	 * state que no aporta nada renombrar; se contemplará en v1.5 si hay
	 * una pasada de limpieza unificada de keys de wp_options.
	 */
	private const OPCION_VERSION = 'uroto_core_version';

	public static function activar(): void {
		self::desactivar_plugin_viejo();
		self::aplicar_migracion_m001();
		self::aplicar_esquema();
		self::sembrar_games();
		update_option( self::OPCION_VERSION, NS_CORE_VERSION );
		self::programar_cron();
	}

	/**
	 * Si el plugin antiguo `uno-roto-core` sigue activo (testers que tenían
	 * la versión previa instalada), lo desactivamos antes de proseguir.
	 * Sin esto, los dos plugins registrarían los mismos hooks y endpoints,
	 * provocando colisiones. La cabecera `Replaces: uno-roto-core` del
	 * archivo principal documenta este comportamiento.
	 */
	private static function desactivar_plugin_viejo(): void {
		$ruta_viejo = 'uno-roto-core/uno-roto-core.php';
		if ( ! function_exists( 'is_plugin_active' ) ) {
			require_once ABSPATH . 'wp-admin/includes/plugin.php';
		}
		if ( is_plugin_active( $ruta_viejo ) ) {
			deactivate_plugins( $ruta_viejo, true );
		}
	}

	public static function desactivar(): void {
		// Dejamos las tablas intactas al desactivar — solo se borran
		// en uninstall.php para evitar pérdida accidental de datos.
		// El cron sí lo desprogramamos: si el plugin no está activo,
		// el callback no existiría y WP loguearía warnings.
		wp_clear_scheduled_hook( self::HOOK_PURGA_TUTOR );
	}

	/**
	 * Migración silenciosa al cargar el plugin: si la versión guardada
	 * en BD es distinta de la del código, aplicamos el esquema de
	 * nuevo (dbDelta es idempotente) y la M001. Esto cubre el caso en
	 * que el plugin ya estaba activo cuando cambió el código — ahí
	 * register_activation_hook no se dispara, y sin esta verificación
	 * las tablas nuevas no se crean.
	 */
	public static function migrar_si_hace_falta(): void {
		$version_bd = get_option( self::OPCION_VERSION, '' );
		if ( NS_CORE_VERSION === $version_bd ) {
			return;
		}
		self::aplicar_migracion_m001();
		self::aplicar_esquema();
		self::sembrar_games();
		update_option( self::OPCION_VERSION, NS_CORE_VERSION );
		// Si el cron aún no estaba programado (sitio que se actualizó
		// desde una versión antes de existir el cron), lo añadimos
		// aquí — `programar_cron` es idempotente.
		self::programar_cron();
	}

	/**
	 * Migración M001 (C4 del refactor): para sitios con tablas del plugin
	 * antiguo (`{prefix}uroto_*`), las renombra al nuevo prefijo
	 * (`{prefix}ns_*`). Idempotente — si las nuevas ya existen, no toca
	 * nada. Si una vieja existe pero la nueva también, asume que la
	 * migración ya pasó y la vieja es residuo: la deja como está para
	 * que el operador humano la inspeccione antes de borrarla.
	 *
	 * No usa transacciones porque RENAME TABLE en MySQL no es
	 * transaccional. La idempotencia se basa en la condición previa:
	 * "renombrar solo si la vieja existe y la nueva no".
	 */
	private static function aplicar_migracion_m001(): void {
		global $wpdb;
		foreach ( NS_Esquema::SUFIJOS_VIEJOS as $clave => $sufijo_viejo ) {
			$tabla_vieja = $wpdb->prefix . $sufijo_viejo;
			$tabla_nueva = NS_Esquema::nombre_tabla( $clave );
			if ( ! self::tabla_existe( $tabla_vieja ) ) {
				continue;
			}
			if ( self::tabla_existe( $tabla_nueva ) ) {
				// Ambas existen: la migración ya pasó alguna vez. No tocar.
				continue;
			}
			$sql_vieja  = esc_sql( $tabla_vieja );
			$sql_nueva  = esc_sql( $tabla_nueva );
			$wpdb->query( "RENAME TABLE `{$sql_vieja}` TO `{$sql_nueva}`" ); // phpcs:ignore WordPress.DB.PreparedSQL
		}
	}

	private static function tabla_existe( string $tabla ): bool {
		global $wpdb;
		$sql_tabla = esc_sql( $tabla );
		$resultado = $wpdb->get_var( "SHOW TABLES LIKE '{$sql_tabla}'" ); // phpcs:ignore WordPress.DB.PreparedSQL
		return ! empty( $resultado );
	}

	/**
	 * Inserta los juegos seed en `ns_games` con INSERT IGNORE — idempotente
	 * y barato. Sin esto la tabla queda vacía tras la primera activación
	 * y los endpoints futuros que validen `game_id` rechazarían todo.
	 */
	private static function sembrar_games(): void {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'games' );
		foreach ( NS_Esquema::games_seed() as $fila ) {
			$wpdb->query( // phpcs:ignore WordPress.DB.PreparedSQL
				$wpdb->prepare(
					"INSERT IGNORE INTO {$tabla} (id, name, age_min, age_max, schema_version) VALUES (%s, %s, %d, %d, %s)",
					$fila['id'],
					$fila['name'],
					$fila['age_min'],
					$fila['age_max'],
					$fila['schema_version']
				)
			);
		}
	}

	/** Programa el cron diario si no estaba ya. Idempotente. */
	private static function programar_cron(): void {
		if ( false === wp_next_scheduled( self::HOOK_PURGA_TUTOR ) ) {
			wp_schedule_event( time() + HOUR_IN_SECONDS, 'daily', self::HOOK_PURGA_TUTOR );
		}
	}

	/** Callback del cron: borra entradas caducadas de la caché del tutor. */
	public static function ejecutar_purga_tutor(): void {
		if ( ! class_exists( 'NS_Tutor' ) ) {
			return;
		}
		NS_Tutor::purgar_caduca();
	}

	private static function aplicar_esquema(): void {
		require_once ABSPATH . 'wp-admin/includes/upgrade.php';
		foreach ( NS_Esquema::sentencias_create() as $sql ) {
			dbDelta( $sql );
		}
	}
}
