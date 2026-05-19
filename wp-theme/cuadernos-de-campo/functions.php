<?php
/**
 * Tema "Cuadernos de Campo" — bootstrap.
 *
 * Landing promocional de las apps Fósiles y Naturaleza. La estructura
 * visual está fijada (front-page.php + template-parts/). Lo editable
 * desde wp-admin son:
 *
 *  - Cabecera (eyebrow, título, lead, contadores) → Customizer.
 *  - Tomo I y Tomo II (versión, plataforma, color, URLs) → Customizer.
 *  - Especímenes (6 fichas con foto+chip+coord) → CPT `cdc_especimen`.
 *  - Periodos geológicos (14 bandas con texto) → CPT `cdc_periodo`.
 *  - Anotaciones del mapa (1-N pines numerados) → CPT `cdc_mapa`.
 *  - Pasos del proceso (1-N pasos numerados) → CPT `cdc_paso`.
 *  - Características (1-N notas con icono) → CPT `cdc_caract`.
 *  - Códigos de campo (1-N items numerados) → CPT `cdc_codigo`.
 *  - Descarga (APK Fósiles/Naturaleza, versión y peso) → Customizer.
 *  - Pie y enlaces → Customizer.
 *
 * @package cuadernos-de-campo
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

define( 'CDC_THEME_VERSION', '1.0.0' );
define( 'CDC_THEME_DIR', get_template_directory() );
define( 'CDC_THEME_URL', get_template_directory_uri() );

require_once CDC_THEME_DIR . '/inc/helpers.php';
require_once CDC_THEME_DIR . '/inc/cpts.php';
require_once CDC_THEME_DIR . '/inc/customizer.php';
require_once CDC_THEME_DIR . '/inc/seed.php';

/**
 * Soporte de tema: el título lo gestiona WP, hay logo personalizado, y
 * permitimos HTML5 para que los formularios no metan markup viejo.
 */
add_action(
	'after_setup_theme',
	static function (): void {
		add_theme_support( 'title-tag' );
		add_theme_support( 'custom-logo' );
		add_theme_support(
			'html5',
			array( 'search-form', 'comment-form', 'comment-list', 'gallery', 'caption', 'style', 'script' )
		);
	}
);

/**
 * Encola los estilos y JS de la landing en el front. No los cargamos
 * en wp-admin — el panel de moderación del tema usa los estilos de
 * WordPress por defecto.
 */
add_action(
	'wp_enqueue_scripts',
	static function (): void {
		// Material Symbols (CDN). El landing.css los reutiliza vía clase.
		wp_enqueue_style(
			'cdc-material-symbols',
			'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&display=swap',
			array(),
			null
		);
		// Tokens primero (variables CSS), luego la hoja real.
		wp_enqueue_style(
			'cdc-tokens',
			CDC_THEME_URL . '/assets/css/tokens.css',
			array(),
			CDC_THEME_VERSION
		);
		wp_enqueue_style(
			'cdc-landing',
			CDC_THEME_URL . '/assets/css/landing.css',
			array( 'cdc-tokens' ),
			CDC_THEME_VERSION
		);
		// JS al final, con defer.
		wp_enqueue_script(
			'cdc-landing',
			CDC_THEME_URL . '/assets/js/landing.js',
			array(),
			CDC_THEME_VERSION,
			array( 'in_footer' => true, 'strategy' => 'defer' )
		);

		// Pasar el diccionario de periodos al JS para que el detalle
		// del time-scale lo lea del CMS. La función `cdc_periodos_map`
		// vive en inc/helpers.php.
		wp_add_inline_script(
			'cdc-landing',
			'window.CDC_PERIODOS = ' . wp_json_encode( cdc_periodos_map() ) . ';',
			'before'
		);
	}
);

/**
 * Forzar el front-page del tema (`front-page.php`) como portada incluso
 * si el operador no la ha configurado en Ajustes → Lectura. Sin esto,
 * un WP recién instalado mostraría el index.php del blog y no la
 * landing — confunde a quien instale el tema.
 */
add_action(
	'after_switch_theme',
	static function (): void {
		update_option( 'show_on_front', 'posts' );
		// El front-page.php tiene precedencia sobre el blog si existe,
		// así que con show_on_front=posts es suficiente; mantenemos
		// el valor para no romper otras instalaciones.
	}
);
