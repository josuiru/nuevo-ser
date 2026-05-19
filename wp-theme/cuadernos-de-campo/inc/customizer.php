<?php
/**
 * Theme Customizer del tema Cuadernos de Campo.
 *
 * Apariencia → Personalizar → estos paneles. Lo dinámico (especímenes,
 * códigos, anotaciones del mapa, periodos…) vive en los CPTs;
 * aquí solo los campos de texto fijo que no merecen un CPT propio.
 *
 * @package cuadernos-de-campo
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

add_action( 'customize_register', 'cdc_customizer_registrar' );

function cdc_customizer_registrar( WP_Customize_Manager $wp_customize ): void {

	// ─── Panel principal ───────────────────────────────────────────
	$wp_customize->add_panel(
		'cdc_landing',
		array(
			'title'       => 'Cuadernos de Campo · Landing',
			'description' => 'Textos editables de la landing promocional. Los bloques con varios elementos (especímenes, códigos, etc.) se gestionan desde sus propios menús del lateral izquierdo de wp-admin.',
			'priority'    => 30,
		)
	);

	// ─── Sección: Hero ─────────────────────────────────────────────
	$wp_customize->add_section(
		'cdc_hero',
		array( 'title' => 'Cabecera (Hero)', 'panel' => 'cdc_landing', 'priority' => 10 )
	);

	cdc_add( $wp_customize, 'cdc_hero_brand_version', 'Marca · versión', 'Cuadernos de Campo · v1.0 · 2026', 'cdc_hero' );
	cdc_add( $wp_customize, 'cdc_hero_eyebrow',       'Antetítulo (eyebrow)', 'Tomo I & II · 2026', 'cdc_hero' );
	cdc_add( $wp_customize, 'cdc_hero_titulo',        'Título grande', 'Anota lo que encuentras, y lo que encuentras deja huella.', 'cdc_hero', 'textarea' );
	cdc_add( $wp_customize, 'cdc_hero_lead',          'Texto de entrada (lead)', 'Dos cuadernos de campo digitales para adulto aficionado. Fósiles para paleontología y mineralogía. Naturaleza para flora, fauna e insectos. Privacidad estructural y certificado verificable de cada hallazgo.', 'cdc_hero', 'textarea' );
	cdc_add( $wp_customize, 'cdc_hero_count_fosiles',      'Contador · fósiles catalogados', '103', 'cdc_hero' );
	cdc_add( $wp_customize, 'cdc_hero_count_formaciones',  'Contador · formaciones ibéricas', '41', 'cdc_hero' );
	cdc_add( $wp_customize, 'cdc_hero_count_periodos',     'Contador · periodos cronoestratigráficos', '14', 'cdc_hero' );
	cdc_add( $wp_customize, 'cdc_hero_repo_url',           'URL del repositorio (botón "Repositorio")', 'https://github.com/JosuIru/cuadernos-de-campo', 'cdc_hero' );
	cdc_add( $wp_customize, 'cdc_hero_stamp_texto',        'Texto del sello rectangular', 'CUADERNO DE CAMPO · MAYO · 2026 · NORTE PENÍNSULA · ', 'cdc_hero' );
	cdc_add( $wp_customize, 'cdc_hero_stamp_iniciales',    'Iniciales del sello', 'JOSU', 'cdc_hero' );

	// ─── Sección: Tomos ────────────────────────────────────────────
	$wp_customize->add_section(
		'cdc_tomos',
		array( 'title' => 'Tomos (Fósiles + Naturaleza)', 'panel' => 'cdc_landing', 'priority' => 20 )
	);

	// Tomo I (Fósiles)
	cdc_add( $wp_customize, 'cdc_tomo1_titulo',       'Tomo I · nombre', 'Fósiles', 'cdc_tomos' );
	cdc_add( $wp_customize, 'cdc_tomo1_sub',          'Tomo I · subtítulo', 'Paleontología y mineralogía. Hallazgos con foto, edad, formación y orientación de estrato. Asistente IGME contextual.', 'cdc_tomos', 'textarea' );
	cdc_add( $wp_customize, 'cdc_tomo1_chips',        'Tomo I · chips (separados por |)', 'GEODE 50|MAGNA 50|strike / dip|certificado SHA-256|comunidad opcional', 'cdc_tomos', 'textarea' );
	cdc_add( $wp_customize, 'cdc_tomo1_version',      'Tomo I · versión actual', '1.0.14+15', 'cdc_tomos' );
	cdc_add( $wp_customize, 'cdc_tomo1_plataforma',   'Tomo I · plataforma', 'Android · Linux desktop', 'cdc_tomos' );
	cdc_add( $wp_customize, 'cdc_tomo1_color',        'Tomo I · etiqueta de color', '#5E7D3A · verde olivo', 'cdc_tomos' );
	cdc_add( $wp_customize, 'cdc_tomo1_url_prototipo','Tomo I · URL prototipo web', '#', 'cdc_tomos' );

	// Tomo II (Naturaleza)
	cdc_add( $wp_customize, 'cdc_tomo2_titulo',       'Tomo II · nombre', 'Naturaleza', 'cdc_tomos' );
	cdc_add( $wp_customize, 'cdc_tomo2_sub',          'Tomo II · subtítulo', 'Avistamientos de fauna, flora e insectos. Identificación con Claude o Pl@ntNet. GBIF cercano.', 'cdc_tomos', 'textarea' );
	cdc_add( $wp_customize, 'cdc_tomo2_chips',        'Tomo II · chips (separados por |)', 'GBIF|Pl@ntNet|Wikipedia|identificación IA|quiz', 'cdc_tomos', 'textarea' );
	cdc_add( $wp_customize, 'cdc_tomo2_version',      'Tomo II · versión actual', '1.0 · alineada con Fósiles', 'cdc_tomos' );
	cdc_add( $wp_customize, 'cdc_tomo2_plataforma',   'Tomo II · plataforma', 'Android · Linux desktop', 'cdc_tomos' );
	cdc_add( $wp_customize, 'cdc_tomo2_color',        'Tomo II · etiqueta de color', '#3A7D5A · verde naturaleza', 'cdc_tomos' );
	cdc_add( $wp_customize, 'cdc_tomo2_url_prototipo','Tomo II · URL prototipo web', '#', 'cdc_tomos' );

	// ─── Sección: Descargar ────────────────────────────────────────
	$wp_customize->add_section(
		'cdc_descargar',
		array( 'title' => 'Descargas (APK)', 'panel' => 'cdc_landing', 'priority' => 30 )
	);

	cdc_add( $wp_customize, 'cdc_descarga_fosiles_url',     'Fósiles · URL APK', 'https://github.com/JosuIru/cuadernos-de-campo/releases', 'cdc_descargar' );
	cdc_add( $wp_customize, 'cdc_descarga_fosiles_meta',    'Fósiles · meta (versión · android · peso)', 'v1.0.14+15 · Android 7+ · ~38 MB', 'cdc_descargar' );
	cdc_add( $wp_customize, 'cdc_descarga_naturaleza_url',  'Naturaleza · URL APK', 'https://github.com/JosuIru/cuadernos-de-campo/releases', 'cdc_descargar' );
	cdc_add( $wp_customize, 'cdc_descarga_naturaleza_meta', 'Naturaleza · meta', 'v1.0 · Android 7+ · ~32 MB', 'cdc_descargar' );
	cdc_add( $wp_customize, 'cdc_descarga_aviso',           'Aviso al pie del bloque', 'iOS no soportado de momento. El proyecto es de un operador independiente, sin presupuesto comercial. Reportes y mejoras: vía GitHub Issues.', 'cdc_descargar', 'textarea' );
	cdc_add( $wp_customize, 'cdc_descarga_coord',           'Coordenadas (cartel pequeño)', '43.2871° N · −2.6113° W', 'cdc_descargar' );

	// ─── Sección: Pie / colofón ────────────────────────────────────
	$wp_customize->add_section(
		'cdc_pie',
		array( 'title' => 'Pie / Colofón', 'panel' => 'cdc_landing', 'priority' => 40 )
	);

	cdc_add( $wp_customize, 'cdc_pie_colofon', 'Texto del colofón', 'Cuadernos de Campo es un proyecto del operador <b>Josu Iru</b>. Las apps nacen del repositorio <a href="https://github.com/JosuIru/cuadernos-de-campo">JosuIru/cuadernos-de-campo</a> y comparten plataforma técnica con el monorepo <a href="https://github.com/JosuIru/nuevo-ser">nuevo-ser</a>.', 'cdc_pie', 'textarea' );
	cdc_add( $wp_customize, 'cdc_pie_linea_carto', 'Línea 1 (cartografía)', 'Cartografía: IGME · GEODE 50, MAGNA 50, Edades 1M, Litologías 1M.', 'cdc_pie' );
	cdc_add( $wp_customize, 'cdc_pie_linea_tipo',  'Línea 2 (tipografía)', 'Tipografía: Inter · Fraunces · JetBrains Mono.', 'cdc_pie' );
	cdc_add( $wp_customize, 'cdc_pie_linea_coord', 'Línea 3 (coordenadas)', '43.2871° N · −2.6113° W · ±4 m', 'cdc_pie' );
}

/**
 * Helper: añade setting + control de tipo `text` o `textarea` en un
 * solo paso. Reduce el ruido del registro.
 */
function cdc_add( WP_Customize_Manager $wp_customize, string $clave, string $etiqueta, string $defecto, string $seccion, string $tipo = 'text' ): void {
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
