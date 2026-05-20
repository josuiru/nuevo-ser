<?php
/**
 * Plugin Name: Gailu Xare Portfolio
 * Plugin URI:  https://gailu.net
 * Description: Portfolio + hub de descargas para el ecosistema del operador. Añade dos CPTs (Proyectos y Descargas) editables desde wp-admin y dos shortcodes ([gxare_proyectos] y [gxare_descargas]) que el tema usa para componer la portada. Convive sin pisar con flavor-platform, flavor-news-hub y flavor-landing.
 * Version:     1.0.0
 * Author:      Gailu Labs · Josu Iru
 * Author URI:  https://github.com/JosuIru
 * License:     GPL-2.0-or-later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: gailu-xare-portfolio
 * Domain Path: /languages
 * Requires at least: 6.4
 * Requires PHP: 8.1
 *
 * @package GailuXarePortfolio
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

define( 'GXARE_PORTFOLIO_VERSION', '1.0.0' );
define( 'GXARE_PORTFOLIO_DIR', plugin_dir_path( __FILE__ ) );
define( 'GXARE_PORTFOLIO_URL', plugin_dir_url( __FILE__ ) );

require_once GXARE_PORTFOLIO_DIR . 'includes/cpts.php';
require_once GXARE_PORTFOLIO_DIR . 'includes/metaboxes.php';
require_once GXARE_PORTFOLIO_DIR . 'includes/shortcodes.php';
require_once GXARE_PORTFOLIO_DIR . 'includes/seed.php';
require_once GXARE_PORTFOLIO_DIR . 'includes/importer-flavor.php';

register_activation_hook( __FILE__, 'gxare_portfolio_activar' );

function gxare_portfolio_activar(): void {
	gxare_cpts_registrar();
	gxare_seed_run();
	flush_rewrite_rules();
}

add_action( 'init', 'gxare_cpts_registrar' );
add_action( 'add_meta_boxes', 'gxare_metaboxes_registrar' );
add_action( 'save_post', 'gxare_metaboxes_guardar', 10, 2 );
