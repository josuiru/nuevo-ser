<?php
/**
 * Seed inicial del portfolio Gailu Xare con los 5 proyectos
 * seleccionados por el operador (Cuadernos de Campo Fósiles +
 * Naturaleza, Solera, Flavor Platform, Flavor News Hub, Flavor
 * Chat IA) + descargas iniciales.
 *
 * Idempotente vía meta `gxare_seed_id`.
 *
 * @package GailuXarePortfolio
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

function gxare_seed_run(): void {
	foreach ( gxare_seed_proyectos() as $entry ) {
		gxare_seed_insertar( $entry );
	}
	foreach ( gxare_seed_descargas() as $entry ) {
		gxare_seed_insertar( $entry );
	}
}

function gxare_seed_insertar( array $entry ): void {
	$existente = get_posts(
		array(
			'post_type'      => $entry['post_type'],
			'meta_key'       => 'gxare_seed_id',
			'meta_value'     => $entry['seed_id'],
			'posts_per_page' => 1,
			'post_status'    => 'any',
			'no_found_rows'  => true,
		)
	);
	if ( ! empty( $existente ) ) {
		return;
	}
	$post_id = wp_insert_post(
		array(
			'post_type'    => $entry['post_type'],
			'post_status'  => 'publish',
			'post_title'   => $entry['title'],
			'post_name'    => $entry['slug'] ?? '',
			'post_content' => $entry['content'] ?? '',
			'post_excerpt' => $entry['excerpt'] ?? '',
			'menu_order'   => $entry['orden'] ?? 0,
		)
	);
	if ( ! $post_id || is_wp_error( $post_id ) ) {
		return;
	}
	update_post_meta( $post_id, 'gxare_seed_id', $entry['seed_id'] );
	foreach ( ( $entry['meta'] ?? array() ) as $key => $value ) {
		update_post_meta( $post_id, $key, $value );
	}
}

function gxare_seed_proyectos(): array {
	return array(

		// ─── CUADERNOS DE CAMPO ─────────────────────────────────────

		array(
			'seed_id'  => 'proy-cdc-fosiles',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'cuadernos-de-campo-fosiles',
			'orden'    => 10,
			'title'    => 'Fósiles',
			'excerpt'  => 'Cuaderno de campo digital de paleontología y mineralogía con cobertura cartográfica IGME nacional.',
			'content'  => 'Anota hallazgos georreferenciados con foto, edad geológica, formación y orientación de estrato. Asistente IGME contextual, certificado verificable SHA-256, módulo opcional de ciencia ciudadana con curaduría profesional. Cobertura del Precámbrico al Cuaternario con 103 fósiles catalogados y 41 formaciones ibéricas.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Cuaderno de paleontología y mineralogía con asistente IGME.',
				'gxare_proyecto_audiencia'  => 'Adulto aficionado',
				'gxare_proyecto_estado'     => 'produccion',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, sqflite, IGME WMS, Ed25519, Anthropic Claude',
				'gxare_proyecto_marca'      => 'Cuadernos de Campo',
				'gxare_proyecto_url_web'    => 'https://github.com/JosuIru/cuadernos-de-campo',
				'gxare_proyecto_url_repo'   => 'https://github.com/JosuIru/cuadernos-de-campo',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#5E7D3A',
				'gxare_proyecto_destacado'  => '1',
				'gxare_proyecto_landing'    => 'cuadernos-de-campo',
			),
		),
		array(
			'seed_id'  => 'proy-cdc-naturaleza',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'cuadernos-de-campo-naturaleza',
			'orden'    => 20,
			'title'    => 'Naturaleza',
			'excerpt'  => 'Cuaderno de avistamientos de fauna, flora e insectos con identificación asistida por IA y datos GBIF.',
			'content'  => 'Misma arquitectura que Fósiles, dominio más estrecho. Identificación con Claude o Pl@ntNet (con tu propia API key). Datos GBIF de la zona. Quiz didáctico, mapas offline, certificado verificable.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Cuaderno de fauna, flora e insectos con IA opcional.',
				'gxare_proyecto_audiencia'  => 'Adulto aficionado',
				'gxare_proyecto_estado'     => 'produccion',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, sqflite, GBIF, Pl@ntNet, Anthropic Claude',
				'gxare_proyecto_marca'      => 'Cuadernos de Campo',
				'gxare_proyecto_url_web'    => 'https://github.com/JosuIru/cuadernos-de-campo',
				'gxare_proyecto_url_repo'   => 'https://github.com/JosuIru/cuadernos-de-campo',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#3A7D5A',
				'gxare_proyecto_destacado'  => '1',
				'gxare_proyecto_landing'    => 'cuadernos-de-campo',
			),
		),

		// ─── NUEVO SER KIDS (4 juegos del monorepo) ────────────────

		array(
			'seed_id'  => 'proy-uno-roto',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'uno-roto',
			'orden'    => 11,
			'title'    => 'Uno Roto',
			'excerpt'  => 'Juego de matemáticas con fragmentos y resolución de problemas, para niños de 9-12.',
			'content'  => 'Mecánica narrativa de "uno roto en pedazos": el niño recompone fracciones, resuelve problemas de proporcionalidad y construye habilidad matemática real (no rote learning). Motor de maestría con perfiles P1-P5, tutor IA opcional, sincronización con tutor / cuidador. En producción, fase ~8-9 MVP.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Matemáticas 9-12 con narrativa y motor de maestría.',
				'gxare_proyecto_audiencia'  => 'Niños 9-12',
				'gxare_proyecto_estado'     => 'produccion',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, Material 3, sqflite, motor maestría, Anthropic',
				'gxare_proyecto_marca'      => 'Nuevo Ser Kids',
				'gxare_proyecto_url_web'    => '',
				'gxare_proyecto_url_repo'   => 'https://github.com/JosuIru/nuevo-ser',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#8A4FBE',
				'gxare_proyecto_destacado'  => '1',
				'gxare_proyecto_landing'    => '',
			),
		),
		array(
			'seed_id'  => 'proy-las-versiones',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'las-versiones',
			'orden'    => 12,
			'title'    => 'Las Versiones',
			'excerpt'  => 'Pensamiento histórico crítico para 10-14: cada hecho admite varias narraciones.',
			'content'  => 'El jugador investiga episodios históricos comparando versiones contradictorias (testimonios, fuentes primarias, interpretaciones académicas). Construye 65 habilidades en 7 dominios — pensamiento causal, evidencia documental, perspectiva múltiple. Mosaico final con código de confianza por viñeta. Fase 10 MVP Arco 1+2 jugable.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Pensamiento histórico 10-14: cada hecho, varias narraciones.',
				'gxare_proyecto_audiencia'  => 'Niños 10-14',
				'gxare_proyecto_estado'     => 'mvp',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, motor maestría P1-P4, Companion',
				'gxare_proyecto_marca'      => 'Nuevo Ser Kids',
				'gxare_proyecto_url_web'    => '',
				'gxare_proyecto_url_repo'   => 'https://github.com/JosuIru/nuevo-ser',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#C4602E',
				'gxare_proyecto_destacado'  => '0',
				'gxare_proyecto_landing'    => '',
			),
		),
		array(
			'seed_id'  => 'proy-el-cuaderno',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'el-cuaderno',
			'orden'    => 13,
			'title'    => 'El Cuaderno',
			'excerpt'  => 'Cuaderno de campo digital infantil (9-13) para observar el medio sin gamificación intrusiva.',
			'content'  => 'Antítesis de Pokémon GO: el niño sale al campo, observa, dibuja, anota. Sin XP, sin quizzes, sin estadísticas que compitan. Misterios temáticos por estación y region (NUTS-3). El "sit spot" como práctica central. Sprint 2 con Companion para padres y profesores.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Cuaderno de campo de naturaleza para niños 9-13, sin gamificación intrusiva.',
				'gxare_proyecto_audiencia'  => 'Niños 9-13',
				'gxare_proyecto_estado'     => 'mvp',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, sqflite, tutor cuaderno IA, Companion',
				'gxare_proyecto_marca'      => 'Nuevo Ser Kids',
				'gxare_proyecto_url_web'    => '',
				'gxare_proyecto_url_repo'   => 'https://github.com/JosuIru/nuevo-ser',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#3A8B6A',
				'gxare_proyecto_destacado'  => '0',
				'gxare_proyecto_landing'    => '',
			),
		),
		array(
			'seed_id'  => 'proy-el-descifrador',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'el-descifrador',
			'orden'    => 14,
			'title'    => 'El Descifrador',
			'excerpt'  => 'Lengua + L2 + pensamiento crítico para 11-14: oficio civil de descifrar documentos en un puerto atlántico ficticio.',
			'content'  => 'Verbo motor: descifrar. Mundo: La Estafeta, puerto atlántico peninsular ficticio. Materia: lengua + idiomas L2 (lectura asistida en eu/ca/gl) + pensamiento crítico + redacción. Las cuatro cooficiales (es/eu/ca/gl) como contenido nuclear desde día uno. Esqueleto v0.1.0 en Fase 1, bloqueado por asesoría lingüística.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Lengua + L2 + crítica para 11-14, mundo de oficinas de un puerto atlántico.',
				'gxare_proyecto_audiencia'  => 'Niños 11-14',
				'gxare_proyecto_estado'     => 'esqueleto',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, Melos, multilingüe es/eu/ca/gl',
				'gxare_proyecto_marca'      => 'Nuevo Ser Kids',
				'gxare_proyecto_url_web'    => '',
				'gxare_proyecto_url_repo'   => 'https://github.com/JosuIru/nuevo-ser',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#2D6A92',
				'gxare_proyecto_destacado'  => '0',
				'gxare_proyecto_landing'    => '',
			),
		),

		// ─── SOLERA ────────────────────────────────────────────────

		array(
			'seed_id'  => 'proy-solera-agro',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'solera',
			'orden'    => 30,
			'title'    => 'Solera',
			'excerpt'  => 'Gestor de fincas agrícolas para Iberia. Modelo "planta con identidad persistente".',
			'content'  => 'Solera nace como cuaderno de campo agrícola: cada planta tiene su ficha persistente con foto, ubicación, historial de podas, riegos, fitosanitarios y cosechas. Diferenciador: modo trufas único en mercado, cuaderno MAPA integrado, cobertura PAC. Cinco verticales especializadas (vid, apícola, arbolado urbano, quesera, aceitera) construidas sobre la misma plataforma.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Gestor de fincas para agricultura ibérica.',
				'gxare_proyecto_audiencia'  => 'Agricultor profesional / cooperativa',
				'gxare_proyecto_estado'     => 'mvp',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, sqflite, MAPA, PAC, GPS',
				'gxare_proyecto_marca'      => 'Solera',
				'gxare_proyecto_url_web'    => '',
				'gxare_proyecto_url_repo'   => 'https://github.com/JosuIru/nuevo-ser',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#8B6F4E',
				'gxare_proyecto_destacado'  => '1',
			),
		),
		array(
			'seed_id'  => 'proy-solera-viticultura',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'solera-viticultura',
			'orden'    => 31,
			'title'    => 'Solera Viticultura',
			'excerpt'  => 'Cuaderno PAC móvil + IA vid para bodegas pequeñas y medianas (5-30 ha).',
			'content'  => 'Vertical especializada de Solera para viticultura. Cumple RD 1311/2012. Branding burdeos+crema.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Cuaderno PAC + IA vid para bodegas 5-30 ha.',
				'gxare_proyecto_audiencia'  => 'Bodegas pequeñas/medianas',
				'gxare_proyecto_estado'     => 'mvp',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, sqflite, PAC RD 1311/2012',
				'gxare_proyecto_marca'      => 'Solera',
				'gxare_proyecto_color'      => '#7B2D26',
				'gxare_proyecto_destacado'  => '0',
			),
		),
		array(
			'seed_id'  => 'proy-solera-apicola',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'solera-apicola',
			'orden'    => 32,
			'title'    => 'Solera Apícola',
			'excerpt'  => 'Libro REGA digital + gestión de varroa + IA apícola para 20-200 colmenas.',
			'content'  => 'Cuaderno apícola con cumplimiento legal. Vertical de Solera. Branding ámbar+crema.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Libro REGA + varroa + IA apícola, 20-200 colmenas.',
				'gxare_proyecto_audiencia'  => 'Apicultor profesional',
				'gxare_proyecto_estado'     => 'mvp',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, sqflite, REGA',
				'gxare_proyecto_marca'      => 'Solera',
				'gxare_proyecto_color'      => '#C99A3B',
				'gxare_proyecto_destacado'  => '0',
			),
		),
		array(
			'seed_id'  => 'proy-solera-arbolado',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'solera-arbolado-urbano',
			'orden'    => 33,
			'title'    => 'Solera Arbolado Urbano',
			'excerpt'  => 'B2B para ayuntamientos: QR chapa + valoración VTA + multi-operario.',
			'content'  => 'Vertical municipal de Solera. Branding verde+crema.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'QR chapa + VTA + multi-operario para ayuntamientos.',
				'gxare_proyecto_audiencia'  => 'Ayuntamientos',
				'gxare_proyecto_estado'     => 'mvp',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, sqflite, VTA',
				'gxare_proyecto_marca'      => 'Solera',
				'gxare_proyecto_color'      => '#3A7D5A',
				'gxare_proyecto_destacado'  => '0',
			),
		),
		array(
			'seed_id'  => 'proy-solera-quesera',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'solera-quesera',
			'orden'    => 34,
			'title'    => 'Solera Quesera',
			'excerpt'  => 'Cuaderno APPCC + curación + trazabilidad de lotes para queserías artesanas.',
			'content'  => 'Vertical de Solera para industria láctea artesana. Branding dorado+crema.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'APPCC + curación + trazabilidad para queserías artesanas.',
				'gxare_proyecto_audiencia'  => 'Queserías artesanas',
				'gxare_proyecto_estado'     => 'mvp',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, sqflite, APPCC',
				'gxare_proyecto_marca'      => 'Solera',
				'gxare_proyecto_color'      => '#D4A537',
				'gxare_proyecto_destacado'  => '0',
			),
		),
		array(
			'seed_id'  => 'proy-solera-aceitera',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'solera-aceitera',
			'orden'    => 35,
			'title'    => 'Solera Aceitera',
			'excerpt'  => 'Cuaderno PAC olivar + libro AICA + DOP + IA visual plagas para almazaras 100-2000 hl.',
			'content'  => 'Cumplimiento RD 1311/2012 (PAC) + RD 760/2021 (movimientos aceite) + DOP olivar + cierre fiscal REAGP. Branding verde oliva+crema.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'PAC + AICA + DOP + IA visual plagas para almazaras pequeñas.',
				'gxare_proyecto_audiencia'  => 'Almazaras 100-2000 hl/campaña',
				'gxare_proyecto_estado'     => 'esqueleto',
				'gxare_proyecto_tipo'       => 'app',
				'gxare_proyecto_tech'       => 'Flutter, sqflite, PAC, AICA, REAGP',
				'gxare_proyecto_marca'      => 'Solera',
				'gxare_proyecto_color'      => '#6B7B3A',
				'gxare_proyecto_destacado'  => '0',
			),
		),

		// ─── FLAVOR ────────────────────────────────────────────────

		array(
			'seed_id'  => 'proy-flavor-platform',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'flavor-platform',
			'orden'    => 50,
			'title'    => 'Flavor Platform',
			'excerpt'  => 'Plataforma integral para WordPress: comunidades, IA, page builder, deep links, matching, newsletter, sellos.',
			'content'  => 'Plugin WordPress modular que añade red de comunidades, asistente IA, page builder propio, deep links nativos, sistema de matching, newsletter integrado y sellos de calidad. Núcleo del ecosistema Gailu.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Plataforma integral WordPress: comunidades, IA, page builder.',
				'gxare_proyecto_audiencia'  => 'Operadores de comunidades digitales',
				'gxare_proyecto_estado'     => 'maduro',
				'gxare_proyecto_tipo'       => 'plugin',
				'gxare_proyecto_tech'       => 'PHP 8.1, WordPress 6.4, JavaScript, WooCommerce',
				'gxare_proyecto_marca'      => 'Flavor',
				'gxare_proyecto_url_web'    => 'https://gailu.net',
				'gxare_proyecto_url_repo'   => '',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#6C8AA0',
				'gxare_proyecto_destacado'  => '1',
			),
		),
		array(
			'seed_id'  => 'proy-flavor-news-hub',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'flavor-news-hub',
			'orden'    => 60,
			'title'    => 'Flavor News Hub',
			'excerpt'  => 'Backend headless para agregar medios alternativos y listar colectivos organizados.',
			'content'  => 'CPTs para medios + colectivos, ingesta automática vía RSS, REST pública para apps cliente, panel de verificación con curaduría humana. Complemento ideal para Flavor Platform.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Agregador headless de medios alternativos y colectivos.',
				'gxare_proyecto_audiencia'  => 'Operadores de medios + colectivos',
				'gxare_proyecto_estado'     => 'produccion',
				'gxare_proyecto_tipo'       => 'plugin',
				'gxare_proyecto_tech'       => 'PHP 8.1, WordPress, RSS, REST',
				'gxare_proyecto_marca'      => 'Flavor',
				'gxare_proyecto_url_web'    => '',
				'gxare_proyecto_url_repo'   => 'https://github.com/JosuIru/flavor-news-hub',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#B05E3B',
				'gxare_proyecto_destacado'  => '0',
			),
		),
		array(
			'seed_id'  => 'proy-flavor-chat-ia',
			'post_type'=> 'gxare_proyecto',
			'slug'     => 'flavor-chat-ia',
			'orden'    => 70,
			'title'    => 'Flavor Chat IA',
			'excerpt'  => 'Asistente conversacional con IA para sitios WordPress con tema minimalista propio.',
			'content'  => 'Plugin + tema minimalista (Flavor Starter) que dota a un WordPress de chat IA conversacional con tu propia API key. Integrado con el resto del ecosistema Flavor.',
			'meta' => array(
				'gxare_proyecto_subtitulo'  => 'Chat IA conversacional integrado en WordPress.',
				'gxare_proyecto_audiencia'  => 'Sitios WP con vocación conversacional',
				'gxare_proyecto_estado'     => 'produccion',
				'gxare_proyecto_tipo'       => 'plugin',
				'gxare_proyecto_tech'       => 'PHP 8.1, WordPress, Anthropic / DeepSeek',
				'gxare_proyecto_marca'      => 'Flavor',
				'gxare_proyecto_url_web'    => '',
				'gxare_proyecto_url_repo'   => '',
				'gxare_proyecto_url_demo'   => '',
				'gxare_proyecto_color'      => '#C99A3B',
				'gxare_proyecto_destacado'  => '0',
				'gxare_proyecto_landing'    => 'flavor-chat-ia',
			),
		),
	);
}

function gxare_seed_descargas(): array {
	return array(
		array(
			'seed_id'  => 'desc-fosiles-1.0.14',
			'post_type'=> 'gxare_descarga',
			'slug'     => 'fosiles-apk-1-0-14',
			'orden'    => 10,
			'title'    => 'Fósiles — APK Android',
			'meta' => array(
				'gxare_descarga_proyecto_slug' => 'cuadernos-de-campo-fosiles',
				'gxare_descarga_version'       => '1.0.14+15',
				'gxare_descarga_fecha'         => '2026-05-19',
				'gxare_descarga_plataforma'    => 'android',
				'gxare_descarga_url'           => 'https://github.com/JosuIru/cuadernos-de-campo/releases',
				'gxare_descarga_peso'          => '~71 MB',
				'gxare_descarga_sha256'        => '',
				'gxare_descarga_notas'         => 'Cobertura desde Precámbrico hasta Cuaternario. 12 formaciones paleozoicas nuevas. Política privacidad v2.0.',
			),
		),
		array(
			'seed_id'  => 'desc-naturaleza-1.0',
			'post_type'=> 'gxare_descarga',
			'slug'     => 'naturaleza-apk-1-0',
			'orden'    => 20,
			'title'    => 'Naturaleza — APK Android',
			'meta' => array(
				'gxare_descarga_proyecto_slug' => 'cuadernos-de-campo-naturaleza',
				'gxare_descarga_version'       => '1.0',
				'gxare_descarga_fecha'         => '2026-05-19',
				'gxare_descarga_plataforma'    => 'android',
				'gxare_descarga_url'           => 'https://github.com/JosuIru/cuadernos-de-campo/releases',
				'gxare_descarga_peso'          => '~32 MB',
				'gxare_descarga_sha256'        => '',
				'gxare_descarga_notas'         => 'Versión alineada con Fósiles. Identificación IA opcional.',
			),
		),
		array(
			'seed_id'  => 'desc-flavor-platform-3.5.13',
			'post_type'=> 'gxare_descarga',
			'slug'     => 'flavor-platform-3-5-13',
			'orden'    => 30,
			'title'    => 'Flavor Platform — ZIP WordPress',
			'meta' => array(
				'gxare_descarga_proyecto_slug' => 'flavor-platform',
				'gxare_descarga_version'       => '3.5.13',
				'gxare_descarga_fecha'         => '2026-05-19',
				'gxare_descarga_plataforma'    => 'wp',
				'gxare_descarga_url'           => 'https://gailu.net',
				'gxare_descarga_peso'          => '',
				'gxare_descarga_notas'         => 'Plataforma integral WP. Contacta para acceso.',
			),
		),
		array(
			'seed_id'  => 'desc-flavor-news-0.16.6',
			'post_type'=> 'gxare_descarga',
			'slug'     => 'flavor-news-hub-0-16-6',
			'orden'    => 40,
			'title'    => 'Flavor News Hub — ZIP WordPress',
			'meta' => array(
				'gxare_descarga_proyecto_slug' => 'flavor-news-hub',
				'gxare_descarga_version'       => '0.16.6',
				'gxare_descarga_fecha'         => '2026-05-19',
				'gxare_descarga_plataforma'    => 'wp',
				'gxare_descarga_url'           => 'https://github.com/JosuIru/flavor-news-hub',
				'gxare_descarga_peso'          => '',
				'gxare_descarga_notas'         => 'Backend headless de noticias y colectivos. AGPL-3.0.',
			),
		),
	);
}
