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

	public static function activar(): void {
		self::aplicar_esquema();
		update_option( 'uroto_core_version', UROTO_CORE_VERSION );
	}

	public static function desactivar(): void {
		// Dejamos las tablas intactas al desactivar — solo se borran
		// en uninstall.php para evitar pérdida accidental de datos.
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
	}

	private static function aplicar_esquema(): void {
		require_once ABSPATH . 'wp-admin/includes/upgrade.php';
		foreach ( UROTO_Esquema::sentencias_create() as $sql ) {
			dbDelta( $sql );
		}
	}
}
