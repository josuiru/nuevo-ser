<?php
/**
 * Ejecutado cuando el usuario desinstala el plugin desde el panel de
 * WordPress. Borra todas las tablas Uno Roto. Irreversible.
 *
 * @package UnoRotoCore
 */

if ( ! defined( 'WP_UNINSTALL_PLUGIN' ) ) {
	exit;
}

require_once __DIR__ . '/includes/class-uroto-esquema.php';

global $wpdb;

$tablas = array(
	UROTO_Esquema::nombre_tabla( 'estado_habilidades' ),
	UROTO_Esquema::nombre_tabla( 'progreso' ),
	UROTO_Esquema::nombre_tabla( 'ninos' ),
	UROTO_Esquema::nombre_tabla( 'usuarios' ),
);

foreach ( $tablas as $tabla ) {
	$wpdb->query( "DROP TABLE IF EXISTS {$tabla}" );
}

delete_option( 'uroto_core_version' );
