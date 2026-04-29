<?php
/**
 * Ejecutado cuando el usuario desinstala el plugin desde el panel de
 * WordPress. Borra todas las tablas Uno Roto. Irreversible.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'WP_UNINSTALL_PLUGIN' ) ) {
	exit;
}

require_once __DIR__ . '/includes/class-ns-esquema.php';

global $wpdb;

$tablas = array(
	NS_Esquema::nombre_tabla( 'estado_habilidades' ),
	NS_Esquema::nombre_tabla( 'progreso' ),
	NS_Esquema::nombre_tabla( 'ninos' ),
	NS_Esquema::nombre_tabla( 'usuarios' ),
);

foreach ( $tablas as $tabla ) {
	$wpdb->query( "DROP TABLE IF EXISTS {$tabla}" );
}

delete_option( 'uroto_core_version' );
