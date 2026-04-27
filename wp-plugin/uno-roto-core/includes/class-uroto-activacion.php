<?php
/**
 * Hooks de activación y desactivación. En activación aplica las
 * migraciones con dbDelta(); idempotente si el esquema ya existe.
 *
 * @package UnoRotoCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class UROTO_Activacion {

	private const HOOK_PURGA_TUTOR = 'uroto_cron_purga_tutor';

	public static function activar(): void {
		self::aplicar_esquema();
		update_option( 'uroto_core_version', UROTO_CORE_VERSION );
		self::programar_cron();
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
	 * nuevo (dbDelta es idempotente). Esto cubre el caso en que el
	 * plugin ya estaba activo cuando cambió el código — ahí
	 * register_activation_hook no se dispara, y sin esta verificación
	 * las tablas nuevas no se crean.
	 */
	public static function migrar_si_hace_falta(): void {
		$version_bd = get_option( 'uroto_core_version', '' );
		if ( UROTO_CORE_VERSION === $version_bd ) {
			return;
		}
		self::aplicar_esquema();
		update_option( 'uroto_core_version', UROTO_CORE_VERSION );
		// Si el cron aún no estaba programado (sitio que se actualizó
		// desde una versión antes de existir el cron), lo añadimos
		// aquí — `programar_cron` es idempotente.
		self::programar_cron();
	}

	/** Programa el cron diario si no estaba ya. Idempotente. */
	private static function programar_cron(): void {
		if ( false === wp_next_scheduled( self::HOOK_PURGA_TUTOR ) ) {
			wp_schedule_event( time() + HOUR_IN_SECONDS, 'daily', self::HOOK_PURGA_TUTOR );
		}
	}

	/** Callback del cron: borra entradas caducadas de la caché del tutor. */
	public static function ejecutar_purga_tutor(): void {
		if ( ! class_exists( 'UROTO_Tutor' ) ) {
			return;
		}
		UROTO_Tutor::purgar_caduca();
	}

	private static function aplicar_esquema(): void {
		require_once ABSPATH . 'wp-admin/includes/upgrade.php';
		foreach ( UROTO_Esquema::sentencias_create() as $sql ) {
			dbDelta( $sql );
		}
	}
}
