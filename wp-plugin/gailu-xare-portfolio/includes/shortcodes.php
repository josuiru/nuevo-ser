<?php
/**
 * Shortcodes que renderiza el plugin Gailu Xare Portfolio.
 *
 *  [gxare_proyectos marca="" tipo="" destacado="" limite="-1"]
 *  [gxare_descargas proyecto="" plataforma="" limite="-1"]
 *
 * Atributos opcionales filtran por meta. Sin filtros, devuelven todo.
 *
 * @package GailuXarePortfolio
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

add_shortcode( 'gxare_proyectos', 'gxare_shortcode_proyectos' );
add_shortcode( 'gxare_descargas', 'gxare_shortcode_descargas' );

function gxare_shortcode_proyectos( $atts ): string {
	$atts = shortcode_atts(
		array(
			'marca'      => '',
			'tipo'       => '',
			'destacado'  => '',
			'limite'     => -1,
		),
		$atts,
		'gxare_proyectos'
	);

	$query_args = array(
		'post_type'      => 'gxare_proyecto',
		'post_status'    => 'publish',
		'posts_per_page' => (int) $atts['limite'],
		'orderby'        => array( 'menu_order' => 'ASC', 'date' => 'ASC' ),
		'meta_query'     => array(),
	);
	if ( '' !== $atts['marca'] ) {
		$query_args['meta_query'][] = array( 'key' => 'gxare_proyecto_marca', 'value' => sanitize_text_field( $atts['marca'] ) );
	}
	if ( '' !== $atts['tipo'] ) {
		$query_args['meta_query'][] = array( 'key' => 'gxare_proyecto_tipo', 'value' => sanitize_text_field( $atts['tipo'] ) );
	}
	if ( '' !== $atts['destacado'] ) {
		$query_args['meta_query'][] = array( 'key' => 'gxare_proyecto_destacado', 'value' => sanitize_text_field( $atts['destacado'] ) );
	}

	$posts = get_posts( $query_args );
	if ( empty( $posts ) ) {
		return '<p class="gxare-vacio">Aún no hay proyectos publicados.</p>';
	}

	ob_start();
	echo '<div class="gxare-proyectos-grid">';
	foreach ( $posts as $proyecto ) {
		gxare_render_tarjeta_proyecto( $proyecto );
	}
	echo '</div>';
	return (string) ob_get_clean();
}

function gxare_render_tarjeta_proyecto( WP_Post $proyecto ): void {
	$subtitulo = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_subtitulo', true );
	$audiencia = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_audiencia', true );
	$estado    = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_estado', true );
	$tipo      = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_tipo', true );
	$tech      = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_tech', true );
	$marca     = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_marca', true );
	$url_web   = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_url_web', true );
	$url_repo  = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_url_repo', true );
	$url_demo  = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_url_demo', true );
	$color     = (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_color', true );
	$destacado = '1' === (string) get_post_meta( $proyecto->ID, 'gxare_proyecto_destacado', true );

	$techs = array_filter( array_map( 'trim', explode( ',', $tech ) ) );
	$style_borde = '' !== $color ? sprintf( 'style="border-left-color: %s;"', esc_attr( $color ) ) : '';

	$clase_destacado = $destacado ? ' gxare-proyecto--destacado' : '';
	echo '<article class="gxare-proyecto' . esc_attr( $clase_destacado ) . '" ' . $style_borde . '>'; // phpcs:ignore

	if ( has_post_thumbnail( $proyecto->ID ) ) {
		echo '<div class="gxare-proyecto__logo">' . get_the_post_thumbnail( $proyecto->ID, 'medium' ) . '</div>';
	}

	$permalink = (string) get_permalink( $proyecto );
	echo '<header class="gxare-proyecto__head">';
	if ( '' !== $marca ) {
		echo '<span class="gxare-proyecto__marca">' . esc_html( $marca ) . '</span>';
	}
	echo '<h3 class="gxare-proyecto__titulo"><a href="' . esc_url( $permalink ) . '">' . esc_html( $proyecto->post_title ) . '</a></h3>';
	if ( '' !== $subtitulo ) {
		echo '<p class="gxare-proyecto__sub">' . esc_html( $subtitulo ) . '</p>';
	}
	echo '</header>';

	$contenido = trim( wp_strip_all_tags( $proyecto->post_content ) );
	if ( '' === $contenido ) {
		$contenido = trim( wp_strip_all_tags( get_the_excerpt( $proyecto ) ) );
	}
	if ( '' !== $contenido ) {
		echo '<div class="gxare-proyecto__cuerpo">' . wp_kses_post( wpautop( $contenido ) ) . '</div>';
	}

	if ( '' !== $audiencia || '' !== $estado || '' !== $tipo ) {
		echo '<div class="gxare-proyecto__chips">';
		if ( '' !== $audiencia ) {
			echo '<span class="gxare-chip">' . esc_html( $audiencia ) . '</span>';
		}
		if ( '' !== $tipo ) {
			echo '<span class="gxare-chip gxare-chip--tipo">' . esc_html( gxare_etiqueta_tipo( $tipo ) ) . '</span>';
		}
		if ( '' !== $estado ) {
			echo '<span class="gxare-chip gxare-chip--estado">' . esc_html( gxare_etiqueta_estado( $estado ) ) . '</span>';
		}
		echo '</div>';
	}

	if ( ! empty( $techs ) ) {
		echo '<div class="gxare-proyecto__tech">';
		foreach ( $techs as $t ) {
			echo '<span>' . esc_html( $t ) . '</span>';
		}
		echo '</div>';
	}

	$enlaces = array();
	// El enlace principal es a la página interna del proyecto.
	$enlaces[] = array( 'href' => $permalink, 'label' => 'Ver detalle', 'extern' => false );
	if ( '' !== $url_web )  { $enlaces[] = array( 'href' => $url_web,  'label' => 'Web',         'extern' => true ); }
	if ( '' !== $url_demo ) { $enlaces[] = array( 'href' => $url_demo, 'label' => 'Demo',        'extern' => true ); }
	if ( '' !== $url_repo ) { $enlaces[] = array( 'href' => $url_repo, 'label' => 'Repositorio', 'extern' => true ); }

	echo '<nav class="gxare-proyecto__enlaces">';
	foreach ( $enlaces as $e ) {
		printf(
			'<a href="%s"%s>%s →</a>',
			esc_url( $e['href'] ),
			$e['extern'] ? ' target="_blank" rel="noopener"' : '',
			esc_html( $e['label'] )
		);
	}
	echo '</nav>';

	echo '</article>';
}

function gxare_etiqueta_estado( string $clave ): string {
	$mapa = array(
		'esqueleto'   => 'Esqueleto',
		'mvp'         => 'MVP',
		'produccion'  => 'En producción',
		'maduro'      => 'Maduro',
		'mantenimiento' => 'En mantenimiento',
	);
	return $mapa[ $clave ] ?? $clave;
}

function gxare_etiqueta_tipo( string $clave ): string {
	$mapa = array(
		'app'      => 'App',
		'plugin'   => 'Plugin WP',
		'theme'    => 'Tema WP',
		'servicio' => 'Servicio',
		'libreria' => 'Librería',
	);
	return $mapa[ $clave ] ?? $clave;
}

function gxare_etiqueta_plataforma( string $clave ): string {
	$mapa = array(
		'android' => 'Android',
		'wp'      => 'WordPress',
		'linux'   => 'Linux',
		'web'     => 'Web',
		'ios'     => 'iOS',
		'otros'   => 'Otros',
	);
	return $mapa[ $clave ] ?? $clave;
}

function gxare_shortcode_descargas( $atts ): string {
	$atts = shortcode_atts(
		array(
			'proyecto'   => '',
			'plataforma' => '',
			'limite'     => -1,
		),
		$atts,
		'gxare_descargas'
	);

	$args = array(
		'post_type'      => 'gxare_descarga',
		'post_status'    => 'publish',
		'posts_per_page' => (int) $atts['limite'],
		'orderby'        => array( 'menu_order' => 'ASC', 'date' => 'DESC' ),
		'meta_query'     => array(),
	);
	if ( '' !== $atts['proyecto'] ) {
		$args['meta_query'][] = array( 'key' => 'gxare_descarga_proyecto_slug', 'value' => sanitize_text_field( $atts['proyecto'] ) );
	}
	if ( '' !== $atts['plataforma'] ) {
		$args['meta_query'][] = array( 'key' => 'gxare_descarga_plataforma', 'value' => sanitize_text_field( $atts['plataforma'] ) );
	}

	$posts = get_posts( $args );
	if ( empty( $posts ) ) {
		return '<p class="gxare-vacio">Aún no hay descargas publicadas.</p>';
	}

	ob_start();
	echo '<div class="gxare-descargas">';
	foreach ( $posts as $desc ) {
		gxare_render_descarga( $desc );
	}
	echo '</div>';
	return (string) ob_get_clean();
}

function gxare_render_descarga( WP_Post $desc ): void {
	$slug       = (string) get_post_meta( $desc->ID, 'gxare_descarga_proyecto_slug', true );
	$version    = (string) get_post_meta( $desc->ID, 'gxare_descarga_version', true );
	$fecha      = (string) get_post_meta( $desc->ID, 'gxare_descarga_fecha', true );
	$plataforma = (string) get_post_meta( $desc->ID, 'gxare_descarga_plataforma', true );
	$url        = (string) get_post_meta( $desc->ID, 'gxare_descarga_url', true );
	$peso       = (string) get_post_meta( $desc->ID, 'gxare_descarga_peso', true );
	$sha256     = (string) get_post_meta( $desc->ID, 'gxare_descarga_sha256', true );
	$notas      = (string) get_post_meta( $desc->ID, 'gxare_descarga_notas', true );

	echo '<article class="gxare-descarga">';
	echo '<header class="gxare-descarga__head">';
	echo '<div>';
	echo '<h4 class="gxare-descarga__titulo">' . esc_html( $desc->post_title ) . '</h4>';
	if ( '' !== $slug ) {
		echo '<small class="gxare-descarga__slug">' . esc_html( $slug ) . '</small>';
	}
	echo '</div>';
	echo '<div class="gxare-descarga__meta">';
	if ( '' !== $version )    { echo '<span class="gxare-pill">v' . esc_html( ltrim( $version, 'v' ) ) . '</span>'; }
	if ( '' !== $plataforma ) { echo '<span class="gxare-pill gxare-pill--plat">' . esc_html( gxare_etiqueta_plataforma( $plataforma ) ) . '</span>'; }
	if ( '' !== $peso )       { echo '<span class="gxare-pill">' . esc_html( $peso ) . '</span>'; }
	if ( '' !== $fecha )      { echo '<small class="gxare-descarga__fecha">' . esc_html( $fecha ) . '</small>'; }
	echo '</div>';
	echo '</header>';

	if ( '' !== $notas ) {
		echo '<p class="gxare-descarga__notas">' . esc_html( $notas ) . '</p>';
	}

	if ( '' !== $sha256 ) {
		echo '<code class="gxare-descarga__sha">SHA-256 ' . esc_html( substr( $sha256, 0, 16 ) ) . '…</code>';
	}

	if ( '' !== $url ) {
		printf(
			'<a class="gxare-descarga__boton" href="%s" target="_blank" rel="noopener">Descargar</a>',
			esc_url( $url )
		);
	}

	echo '</article>';
}
