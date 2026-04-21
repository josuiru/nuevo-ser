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
		require_once ABSPATH . 'wp-admin/includes/upgrade.php';
		foreach ( UROTO_Esquema::sentencias_create() as $sql ) {
			dbDelta( $sql );
		}
		update_option( 'uroto_core_version', UROTO_CORE_VERSION );
	}

	public static function desactivar(): void {
		// Dejamos las tablas intactas al desactivar — solo se borran
		// en uninstall.php para evitar pérdida accidental de datos.
	}
}
