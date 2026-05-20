<?php
/**
 * Tema "Gailu Xare" — portfolio del ecosistema del operador.
 *
 * Requiere el plugin `gailu-xare-portfolio` para los CPTs y los
 * shortcodes que el `front-page.php` consume. Sin el plugin, el tema
 * funciona pero no muestra proyectos ni descargas; en su lugar pinta
 * un aviso en wp-admin.
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

define( 'GXARE_THEME_VERSION', '1.0.0' );
define( 'GXARE_THEME_DIR', get_template_directory() );
define( 'GXARE_THEME_URL', get_template_directory_uri() );

/**
 * Cargamos los CPTs y el seed del tema `cuadernos-de-campo` aunque
 * no esté activo. Esto registra `cdc_especimen`, `cdc_periodo`,
 * `cdc_mapa`, `cdc_paso`, `cdc_caract`, `cdc_codigo` como tipos de
 * post disponibles vía `init` action — necesario para que las
 * landings custom que embebemos los puedan listar con get_posts().
 *
 * Constantes que esperan esos archivos:
 */
$gxare_ruta_cdc = get_theme_root() . '/cuadernos-de-campo';
if ( is_dir( $gxare_ruta_cdc ) ) {
	if ( ! defined( 'CDC_THEME_VERSION' ) ) define( 'CDC_THEME_VERSION', '1.0.0' );
	if ( ! defined( 'CDC_THEME_DIR' ) )     define( 'CDC_THEME_DIR', $gxare_ruta_cdc );
	if ( ! defined( 'CDC_THEME_URL' ) )     define( 'CDC_THEME_URL', get_theme_root_uri() . '/cuadernos-de-campo' );
	if ( is_readable( $gxare_ruta_cdc . '/inc/helpers.php' ) ) {
		require_once $gxare_ruta_cdc . '/inc/helpers.php';
	}
	if ( is_readable( $gxare_ruta_cdc . '/inc/cpts.php' ) ) {
		require_once $gxare_ruta_cdc . '/inc/cpts.php';
	}
	if ( is_readable( $gxare_ruta_cdc . '/inc/seed.php' ) ) {
		require_once $gxare_ruta_cdc . '/inc/seed.php';
	}
}
unset( $gxare_ruta_cdc );

add_action(
	'after_setup_theme',
	static function (): void {
		add_theme_support( 'title-tag' );
		add_theme_support( 'post-thumbnails' );
		add_theme_support( 'custom-logo' );
		add_theme_support( 'html5', array( 'script', 'style', 'caption', 'gallery' ) );
	}
);

add_action(
	'wp_enqueue_scripts',
	static function (): void {
		wp_enqueue_style(
			'gxare-material-symbols',
			'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&display=swap',
			array(),
			null
		);
		wp_enqueue_style(
			'gxare-tokens',
			GXARE_THEME_URL . '/assets/css/tokens.css',
			array(),
			GXARE_THEME_VERSION
		);
		wp_enqueue_style(
			'gxare-portfolio',
			GXARE_THEME_URL . '/assets/css/portfolio.css',
			array( 'gxare-tokens' ),
			GXARE_THEME_VERSION
		);
		wp_enqueue_script(
			'gxare-portfolio',
			GXARE_THEME_URL . '/assets/js/portfolio.js',
			array(),
			GXARE_THEME_VERSION,
			array( 'in_footer' => true, 'strategy' => 'defer' )
		);
	}
);

/**
 * Aviso en wp-admin si el plugin del portfolio no está activo. Sin él
 * la portada queda vacía y no es obvio por qué — este aviso lo
 * explica al primer login.
 */
add_action(
	'admin_notices',
	static function (): void {
		if ( shortcode_exists( 'gxare_proyectos' ) ) {
			return;
		}
		echo '<div class="notice notice-warning is-dismissible"><p>';
		echo '<strong>Gailu Xare:</strong> activa también el plugin <code>gailu-xare-portfolio</code> para que la portada muestre proyectos y descargas.';
		echo '</p></div>';
	}
);

/**
 * Mapa centralizado de defaults para los textos editables del
 * Customizer. Se usa tanto en `customize_register` (para mostrar los
 * defaults en wp-admin) como en `gxare_mod()` (para devolverlos al
 * template cuando el operador todavía no ha guardado nada).
 *
 * Sin esto, get_theme_mod devuelve string vacío en una instalación
 * recién activada y la portada sale con hero/sobre/pie vacíos hasta
 * que el operador entra al Customizer y pulsa "Publicar".
 */
function gxare_defaults(): array {
	return array(
		'gxare_hero_eyebrow'  => 'Gailu Xare',
		'gxare_hero_titulo'   => 'Trabajos del taller, listos para usar.',
		'gxare_hero_lead'     => 'Portfolio público del operador y hub de descargas: cuadernos de campo digitales, plataformas de comunidad, plugins WordPress y herramientas de IA. Cada proyecto se enlaza a su repo, su demo y su versión actual descargable.',
		'gxare_sobre_titulo'  => 'Sobre Gailu Xare',
		'gxare_sobre_cuerpo'  => 'Gailu Xare es el taller público de Josu Iru: software libre y de pago, divulgación y herramientas para colectivos. Tres líneas de trabajo conviven aquí: <b>Cuadernos de Campo</b> (apps para adulto aficionado), <b>Solera</b> (gestor agrícola para Iberia con verticales especializadas) y <b>Flavor</b> (plataforma WordPress y plugins de comunidad e IA).',
		'gxare_desc_titulo'   => 'Hub de descargas',
		'gxare_desc_lead'     => 'APKs Android, plugins WordPress y otros artefactos. Cada release lleva versión, fecha y notas — siempre verificable contra el repo o el SHA-256 cuando corresponde.',
		'gxare_pie_credito'   => 'Construido por Josu Iru · <a href="https://github.com/JosuIru">github.com/JosuIru</a> · <a href="https://gailu.net">gailu.net</a>',
	);
}

/**
 * Helper: lee un Customizer con fallback al default centralizado. Si
 * el segundo argumento es no-vacío gana sobre el default centralizado
 * (uso ad-hoc desde un template puntual).
 */
function gxare_mod( string $clave, $defecto = '' ) {
	$defaults = gxare_defaults();
	$valor = get_theme_mod( $clave, null );
	if ( null !== $valor && '' !== $valor ) {
		return $valor;
	}
	if ( '' !== $defecto ) {
		return $defecto;
	}
	return $defaults[ $clave ] ?? '';
}

/**
 * Customizer: textos editables de hero / sobre / pie.
 */
add_action(
	'customize_register',
	static function ( WP_Customize_Manager $wp_customize ): void {
		$defaults = gxare_defaults();
		$wp_customize->add_panel(
			'gxare_portfolio',
			array( 'title' => 'Gailu Xare · Portfolio', 'priority' => 30 )
		);

		// Hero
		$wp_customize->add_section( 'gxare_hero', array( 'title' => 'Cabecera (Hero)', 'panel' => 'gxare_portfolio' ) );
		gxare_settings_add( $wp_customize, 'gxare_hero_eyebrow', 'Antetítulo', $defaults['gxare_hero_eyebrow'], 'gxare_hero' );
		gxare_settings_add( $wp_customize, 'gxare_hero_titulo',  'Título', $defaults['gxare_hero_titulo'], 'gxare_hero', 'textarea' );
		gxare_settings_add( $wp_customize, 'gxare_hero_lead',    'Lead', $defaults['gxare_hero_lead'], 'gxare_hero', 'textarea' );

		// Sobre
		$wp_customize->add_section( 'gxare_sobre', array( 'title' => 'Sobre Gailu Xare', 'panel' => 'gxare_portfolio' ) );
		gxare_settings_add( $wp_customize, 'gxare_sobre_titulo',  'Título', $defaults['gxare_sobre_titulo'], 'gxare_sobre' );
		gxare_settings_add( $wp_customize, 'gxare_sobre_cuerpo',  'Cuerpo', $defaults['gxare_sobre_cuerpo'], 'gxare_sobre', 'textarea' );

		// Descargas
		$wp_customize->add_section( 'gxare_descargas_section', array( 'title' => 'Sección de Descargas', 'panel' => 'gxare_portfolio' ) );
		gxare_settings_add( $wp_customize, 'gxare_desc_titulo',   'Título', $defaults['gxare_desc_titulo'], 'gxare_descargas_section' );
		gxare_settings_add( $wp_customize, 'gxare_desc_lead',     'Lead',   $defaults['gxare_desc_lead'], 'gxare_descargas_section', 'textarea' );

		// Pie
		$wp_customize->add_section( 'gxare_pie', array( 'title' => 'Pie', 'panel' => 'gxare_portfolio' ) );
		gxare_settings_add( $wp_customize, 'gxare_pie_credito', 'Crédito', $defaults['gxare_pie_credito'], 'gxare_pie', 'textarea' );
	}
);

function gxare_settings_add( WP_Customize_Manager $wp_customize, string $clave, string $etiqueta, string $defecto, string $seccion, string $tipo = 'text' ): void {
	$wp_customize->add_setting(
		$clave,
		array(
			'default'           => $defecto,
			'sanitize_callback' => 'textarea' === $tipo ? 'sanitize_textarea_field' : 'sanitize_text_field',
			'transport'         => 'refresh',
		)
	);
	$wp_customize->add_control(
		$clave,
		array(
			'label'   => $etiqueta,
			'section' => $seccion,
			'type'    => $tipo,
		)
	);
}
