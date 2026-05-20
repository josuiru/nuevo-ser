<?php
/**
 * Landing custom para proyectos de Cuadernos de Campo (Fósiles y
 * Naturaleza). Reaprovecha el design system del tema
 * `cuadernos-de-campo` siempre que esté instalado en
 * `wp-content/themes/cuadernos-de-campo/`.
 *
 * Estrategia: definimos las constantes `CDC_THEME_*` que esperan los
 * archivos del otro tema, cargamos su `helpers.php` (que declara todas
 * las funciones `cdc_*`), encolamos sus assets, y montamos sus 9
 * secciones desde sus template-parts. La activación del tema
 * cuadernos-de-campo NO se necesita — solo que sus archivos estén
 * presentes en `themes/`.
 *
 * @package gailu-xare
 */

$ruta_tema_cdc = get_theme_root() . '/cuadernos-de-campo';
$url_tema_cdc  = get_theme_root_uri() . '/cuadernos-de-campo';

if ( ! is_dir( $ruta_tema_cdc ) || ! is_readable( $ruta_tema_cdc . '/inc/helpers.php' ) ) {
	// Sin el tema cuadernos-de-campo instalado, caemos a la genérica.
	get_template_part( 'template-parts/landing-generica' );
	return;
}

// Definir las constantes que las funciones del otro tema esperan.
// Sus helpers.php no las necesita, pero sí algunos template-parts
// vía `cdc_asset()`. Las definimos antes de require_once.
if ( ! defined( 'CDC_THEME_VERSION' ) ) {
	define( 'CDC_THEME_VERSION', '1.0.0' );
}
if ( ! defined( 'CDC_THEME_DIR' ) ) {
	define( 'CDC_THEME_DIR', $ruta_tema_cdc );
}
if ( ! defined( 'CDC_THEME_URL' ) ) {
	define( 'CDC_THEME_URL', $url_tema_cdc );
}

// Declaramos primero NUESTRA versión de cdc_mod con los defaults que
// las template-parts del tema cuadernos-de-campo esperan. Como
// cuadernos-de-campo no está activo, get_theme_mod no encontraría
// nada y devolvería el segundo argumento (que las template-parts
// pasan como '' en la mayoría de las llamadas). Por eso aquí ponemos
// los defaults explícitamente.
//
// Los valores son los que aparecen en cuadernos-de-campo/inc/customizer.php
// como defaults del Customizer.
function cdc_mod( string $clave, $defecto = '' ) {
	// Si el operador alguna vez activó el tema cuadernos-de-campo
	// y dejó settings guardados, los respetamos.
	$guardado = get_theme_mod( $clave, null );
	if ( null !== $guardado && '' !== $guardado ) {
		return $guardado;
	}
	$defaults = array(
		'cdc_hero_brand_version'   => 'Cuadernos de Campo · v1.0 · 2026',
		'cdc_hero_eyebrow'         => 'Tomo I & II · 2026',
		'cdc_hero_titulo'          => 'Anota lo que encuentras, y lo que encuentras deja huella.',
		'cdc_hero_lead'            => 'Dos cuadernos de campo digitales para adulto aficionado. Fósiles para paleontología y mineralogía. Naturaleza para flora, fauna e insectos. Privacidad estructural y certificado verificable de cada hallazgo.',
		'cdc_hero_count_fosiles'      => '103',
		'cdc_hero_count_formaciones'  => '41',
		'cdc_hero_count_periodos'     => '14',
		'cdc_hero_repo_url'           => 'https://github.com/JosuIru/cuadernos-de-campo',
		'cdc_hero_stamp_texto'        => 'CUADERNO DE CAMPO · MAYO · 2026 · NORTE PENÍNSULA · ',
		'cdc_hero_stamp_iniciales'    => 'JOSU',
		'cdc_tomo1_titulo'       => 'Fósiles',
		'cdc_tomo1_sub'          => 'Paleontología y mineralogía. Hallazgos con foto, edad, formación y orientación de estrato. Asistente IGME contextual.',
		'cdc_tomo1_chips'        => 'GEODE 50|MAGNA 50|strike / dip|certificado SHA-256|comunidad opcional',
		'cdc_tomo1_version'      => '1.0.14+15',
		'cdc_tomo1_plataforma'   => 'Android · Linux desktop',
		'cdc_tomo1_color'        => '#5E7D3A · verde olivo',
		'cdc_tomo1_url_prototipo'=> '#',
		'cdc_tomo2_titulo'       => 'Naturaleza',
		'cdc_tomo2_sub'          => 'Avistamientos de fauna, flora e insectos. Identificación con Claude o Pl@ntNet. GBIF cercano.',
		'cdc_tomo2_chips'        => 'GBIF|Pl@ntNet|Wikipedia|identificación IA|quiz',
		'cdc_tomo2_version'      => '1.0 · alineada con Fósiles',
		'cdc_tomo2_plataforma'   => 'Android · Linux desktop',
		'cdc_tomo2_color'        => '#3A7D5A · verde naturaleza',
		'cdc_tomo2_url_prototipo'=> '#',
		'cdc_descarga_fosiles_url'     => 'https://github.com/JosuIru/cuadernos-de-campo/releases',
		'cdc_descarga_fosiles_meta'    => 'v1.0.14+15 · Android 7+ · ~71 MB',
		'cdc_descarga_naturaleza_url'  => 'https://github.com/JosuIru/cuadernos-de-campo/releases',
		'cdc_descarga_naturaleza_meta' => 'v1.0 · Android 7+ · ~32 MB',
		'cdc_descarga_aviso'           => 'iOS no soportado de momento. El proyecto es de un operador independiente, sin presupuesto comercial. Reportes y mejoras: vía GitHub Issues.',
		'cdc_descarga_coord'           => '43.2871° N · −2.6113° W',
		'cdc_pie_colofon'   => 'Cuadernos de Campo es un proyecto del operador <b>Josu Iru</b>. Las apps nacen del repositorio <a href="https://github.com/JosuIru/cuadernos-de-campo">JosuIru/cuadernos-de-campo</a>.',
		'cdc_pie_linea_carto' => 'Cartografía: IGME · GEODE 50, MAGNA 50, Edades 1M, Litologías 1M.',
		'cdc_pie_linea_tipo'  => 'Tipografía: Inter · Fraunces · JetBrains Mono.',
		'cdc_pie_linea_coord' => '43.2871° N · −2.6113° W · ±4 m',
	);
	if ( '' !== $defecto ) {
		return $defecto;
	}
	return $defaults[ $clave ] ?? '';
}

// Cargar el resto de helpers del otro tema (icon, asset, listar_cpt,
// periodos…). cdc_mod ya está declarada, así que su function_exists
// guard la saltará.
require_once $ruta_tema_cdc . '/inc/helpers.php';
?>

<link rel="stylesheet" href="<?php echo esc_url( $url_tema_cdc . '/assets/css/tokens.css' ); ?>?ver=cdc">
<link rel="stylesheet" href="<?php echo esc_url( $url_tema_cdc . '/assets/css/landing.css' ); ?>?ver=cdc">
<script>window.CDC_PERIODOS = <?php echo wp_json_encode( cdc_periodos_map() ); ?>;</script>
<script defer src="<?php echo esc_url( $url_tema_cdc . '/assets/js/landing.js' ); ?>?ver=cdc"></script>

<?php
// Las template-parts esperan que estemos "dentro del cuaderno" — su
// markup propio incluye el lomo lateral con la timescale. Reusamos
// directamente sus 9 archivos.
$secciones = array(
	'hero',
	'tomos',
	'especimenes',
	'tiempo',
	'mapa',
	'proceso',
	'caracteristicas',
	'codigo',
	'descargar',
);

echo '<div class="cdc-embed cdc-embed--' . esc_attr( get_post_field( 'post_name', get_the_ID() ) ) . '">';
foreach ( $secciones as $sec ) {
	$archivo = $ruta_tema_cdc . '/template-parts/section-' . $sec . '.php';
	if ( file_exists( $archivo ) ) {
		include $archivo;
	}
}
echo '</div>';
