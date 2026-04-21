<?php
/**
 * Plugin Name: Uno Roto Core
 * Plugin URI:  https://github.com/josu/uno-roto
 * Description: Backend de sync, auth y tutor IA para la app Uno Roto.
 *              Expone /wp-json/uno-roto/v1/* con JWT propios. No depende
 *              de Flavor Platform ni de ningún servicio externo.
 * Version:     0.1.0
 * Author:      Equipo Uno Roto
 * Author URI:  https://unoroto.org
 * License:     GPL-2.0-or-later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: uno-roto-core
 * Requires PHP: 8.1
 * Requires at least: 6.4
 *
 * @package UnoRotoCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

define( 'UROTO_CORE_VERSION', '0.1.0' );
define( 'UROTO_CORE_DIR', plugin_dir_path( __FILE__ ) );
define( 'UROTO_CORE_URL', plugin_dir_url( __FILE__ ) );

require_once UROTO_CORE_DIR . 'includes/class-uroto-esquema.php';
require_once UROTO_CORE_DIR . 'includes/class-uroto-activacion.php';
require_once UROTO_CORE_DIR . 'includes/class-uroto-jwt.php';
require_once UROTO_CORE_DIR . 'includes/class-uroto-repositorio.php';
require_once UROTO_CORE_DIR . 'includes/class-uroto-sincronizador.php';
require_once UROTO_CORE_DIR . 'includes/class-uroto-endpoints.php';

register_activation_hook( __FILE__, array( 'UROTO_Activacion', 'activar' ) );
register_deactivation_hook( __FILE__, array( 'UROTO_Activacion', 'desactivar' ) );

add_action( 'rest_api_init', array( 'UROTO_Endpoints', 'registrar' ) );

/**
 * Secreto para firmar JWTs. Se espera definir en wp-config.php:
 *   define( 'UROTO_JWT_SECRET', 'cadena-aleatoria-64-chars-minimo' );
 * Si no está definido, se emite un aviso al activar el plugin.
 */
if ( ! defined( 'UROTO_JWT_SECRET' ) ) {
	add_action(
		'admin_notices',
		static function () {
			echo '<div class="notice notice-error"><p><strong>Uno Roto Core:</strong> ';
			echo 'define <code>UROTO_JWT_SECRET</code> en <code>wp-config.php</code> ';
			echo 'antes de usar el plugin en producción.</p></div>';
		}
	);
}
