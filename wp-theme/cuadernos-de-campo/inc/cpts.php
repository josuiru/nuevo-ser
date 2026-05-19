<?php
/**
 * Custom Post Types y metaboxes del tema Cuadernos de Campo.
 *
 * Todos los CPTs siguen el patrón:
 *   - `show_in_rest` => false: el contenido se renderiza desde PHP,
 *     no necesitamos Gutenberg expuesto en REST.
 *   - `hierarchical` => false, soporte mínimo (title + editor + page_attributes
 *     para que el operador pueda reordenarlos vía `menu_order`).
 *   - Etiquetas siempre en castellano.
 *
 * @package cuadernos-de-campo
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

add_action( 'init', 'cdc_registrar_cpts' );
add_action( 'add_meta_boxes', 'cdc_registrar_metaboxes' );
add_action( 'save_post', 'cdc_guardar_meta', 10, 2 );

function cdc_registrar_cpts(): void {
	$base_args = array(
		'public'              => false,
		'show_ui'             => true,
		'show_in_menu'        => true,
		'show_in_rest'        => false,
		'hierarchical'        => false,
		'exclude_from_search' => true,
		'publicly_queryable'  => false,
		'has_archive'         => false,
		'supports'            => array( 'title', 'editor', 'page-attributes', 'thumbnail' ),
		'capability_type'     => 'page',
	);

	register_post_type(
		'cdc_especimen',
		array_merge(
			$base_args,
			array(
				'labels' => array(
					'name'          => 'Especímenes',
					'singular_name' => 'Espécimen',
					'add_new_item'  => 'Añadir espécimen',
					'edit_item'     => 'Editar espécimen',
					'menu_name'     => 'Especímenes',
				),
				'menu_icon' => 'dashicons-art',
				'menu_position' => 25,
			)
		)
	);

	register_post_type(
		'cdc_periodo',
		array_merge(
			$base_args,
			array(
				'labels' => array(
					'name'          => 'Periodos geológicos',
					'singular_name' => 'Periodo',
					'add_new_item'  => 'Añadir periodo',
					'edit_item'     => 'Editar periodo',
					'menu_name'     => 'Periodos geológicos',
				),
				'menu_icon' => 'dashicons-clock',
				'menu_position' => 26,
				'supports'  => array( 'title', 'editor', 'page-attributes' ),
			)
		)
	);

	register_post_type(
		'cdc_mapa',
		array_merge(
			$base_args,
			array(
				'labels' => array(
					'name'          => 'Anotaciones del mapa',
					'singular_name' => 'Anotación',
					'add_new_item'  => 'Añadir anotación',
					'edit_item'     => 'Editar anotación',
					'menu_name'     => 'Anotaciones del mapa',
				),
				'menu_icon' => 'dashicons-location-alt',
				'menu_position' => 27,
			)
		)
	);

	register_post_type(
		'cdc_paso',
		array_merge(
			$base_args,
			array(
				'labels' => array(
					'name'          => 'Pasos del proceso',
					'singular_name' => 'Paso',
					'add_new_item'  => 'Añadir paso',
					'edit_item'     => 'Editar paso',
					'menu_name'     => 'Pasos del proceso',
				),
				'menu_icon' => 'dashicons-list-view',
				'menu_position' => 28,
			)
		)
	);

	register_post_type(
		'cdc_caract',
		array_merge(
			$base_args,
			array(
				'labels' => array(
					'name'          => 'Características',
					'singular_name' => 'Característica',
					'add_new_item'  => 'Añadir característica',
					'edit_item'     => 'Editar característica',
					'menu_name'     => 'Características',
				),
				'menu_icon' => 'dashicons-yes-alt',
				'menu_position' => 29,
			)
		)
	);

	register_post_type(
		'cdc_codigo',
		array_merge(
			$base_args,
			array(
				'labels' => array(
					'name'          => 'Códigos de campo',
					'singular_name' => 'Código',
					'add_new_item'  => 'Añadir código',
					'edit_item'     => 'Editar código',
					'menu_name'     => 'Códigos de campo',
				),
				'menu_icon' => 'dashicons-shield',
				'menu_position' => 30,
			)
		)
	);
}

/**
 * Estructura de metaboxes por CPT.
 *
 * Cada metabox declara los campos que aparecen como inputs en la
 * pantalla de edición. La función `cdc_render_metabox` los pinta
 * de forma genérica leyendo los `meta_keys` declarados aquí.
 */
function cdc_metabox_defs(): array {
	return array(
		'cdc_especimen' => array(
			'titulo' => 'Datos del espécimen',
			'campos' => array(
				array( 'key' => 'cdc_grupo',         'label' => 'Grupo taxonómico',  'tipo' => 'text',     'desc' => 'Ej. Ammonoidea · Toarciense' ),
				array( 'key' => 'cdc_chip_label',    'label' => 'Etiqueta del chip', 'tipo' => 'text',     'desc' => 'Ej. Toarciense, Urgoniano, Lepidóptero' ),
				array( 'key' => 'cdc_chip_color',    'label' => 'Color del chip',    'tipo' => 'select_period_color',
					'desc' => 'Color del chip de periodo (usa los colores oficiales ICS) o color libre.' ),
				array( 'key' => 'cdc_chip_color_libre', 'label' => 'Color libre (hex)', 'tipo' => 'text', 'desc' => 'Solo si seleccionas "Color libre" arriba. Ej. #E6C275' ),
				array( 'key' => 'cdc_codigo_ref',    'label' => 'Código de referencia', 'tipo' => 'text', 'desc' => 'Ej. F-001, N-103' ),
				array( 'key' => 'cdc_localidad',     'label' => 'Localidad (esquina foto)', 'tipo' => 'text', 'desc' => 'Ej. Bizkaia, Ereño, Vitoria' ),
				array( 'key' => 'cdc_coord_lat',     'label' => 'Latitud (decimal)',  'tipo' => 'text', 'desc' => 'Ej. 43.287' ),
				array( 'key' => 'cdc_coord_lng',     'label' => 'Longitud (decimal)', 'tipo' => 'text', 'desc' => 'Ej. -2.611' ),
				array( 'key' => 'cdc_distintivos',   'label' => 'Distintivos (uno por línea)', 'tipo' => 'textarea', 'desc' => 'Lista de rasgos identificativos. Una línea por ítem.' ),
				array( 'key' => 'cdc_donde',         'label' => 'Dónde encontrar', 'tipo' => 'textarea', 'desc' => 'Localizaciones ibéricas relevantes.' ),
				array( 'key' => 'cdc_clase_visual',  'label' => 'Variante visual',  'tipo' => 'select',
					'opciones' => array(
						''         => '— Por defecto (sin clase) —',
						'bivalve'  => 'Bivalvo',
						'amber'    => 'Ámbar',
						'butterfly'=> 'Mariposa',
						'leaf'     => 'Hoja',
						'bird'     => 'Ave',
					),
					'desc' => 'La clase CSS aplicada al .specimen para variar el render placeholder. Si subes una foto destacada del post, ese render visual se ignora.' ),
			),
		),
		'cdc_periodo' => array(
			'titulo' => 'Mapeo con la cronoestratigrafía',
			'campos' => array(
				array( 'key' => 'cdc_periodo_id', 'label' => 'ID canónico',  'tipo' => 'select',
					'opciones' => array(
						''                     => '— Selecciona —',
						'precambrico'          => 'Precámbrico',
						'cambrico'             => 'Cámbrico',
						'ordovicico'           => 'Ordovícico',
						'silurico'             => 'Silúrico',
						'devonico'             => 'Devónico',
						'carbonifero'          => 'Carbonífero',
						'permico'              => 'Pérmico',
						'triasico'             => 'Triásico',
						'jurasico'             => 'Jurásico',
						'cretacico-inferior'   => 'Cretácico Inferior',
						'cretacico-superior'   => 'Cretácico Superior',
						'paleoceno-eoceno'     => 'Paleoceno – Eoceno',
						'oligoceno-mioceno'    => 'Oligoceno – Mioceno',
						'cuaternario'          => 'Cuaternario',
					),
					'desc' => 'Tiene que coincidir con uno de los 14 IDs canónicos para sobrescribir su tarjeta en la timescale.' ),
				array( 'key' => 'cdc_edad_ma',    'label' => 'Edad (Ma)', 'tipo' => 'text', 'desc' => 'Ej. "201 – 145 Ma".' ),
			),
		),
		'cdc_mapa' => array(
			'titulo' => 'Pin del mapa',
			'campos' => array(
				array( 'key' => 'cdc_pin_numero', 'label' => 'Número del pin (1-9)', 'tipo' => 'text', 'desc' => 'Aparece en círculo sobre el mapa.' ),
				array( 'key' => 'cdc_pin_left',   'label' => 'Posición horizontal (%)', 'tipo' => 'text', 'desc' => 'Ej. 28' ),
				array( 'key' => 'cdc_pin_top',    'label' => 'Posición vertical (%)',   'tipo' => 'text', 'desc' => 'Ej. 22' ),
				array( 'key' => 'cdc_pin_color',  'label' => 'Color del pin', 'tipo' => 'select',
					'opciones' => array(
						'olive' => 'Olivo (Fósiles)',
						'ochre' => 'Ocre (Naturaleza acento)',
						'terra' => 'Terracota (énfasis)',
					) ),
				array( 'key' => 'cdc_pin_dt',     'label' => 'Periodo / rango', 'tipo' => 'text', 'desc' => 'Ej. "Devónico – Carbonífero"' ),
			),
		),
		'cdc_paso' => array(
			'titulo' => 'Paso del proceso',
			'campos' => array(
				array( 'key' => 'cdc_paso_numero', 'label' => 'Número', 'tipo' => 'text', 'desc' => 'Ej. 1, 2, 3…' ),
			),
		),
		'cdc_caract' => array(
			'titulo' => 'Característica',
			'campos' => array(
				array( 'key' => 'cdc_caract_icon', 'label' => 'Icono Material Symbols', 'tipo' => 'text',
					'desc' => 'Nombre del icono (ej. layers, smart_toy, shield_lock, offline_bolt, verified, straighten). Sin emojis.' ),
				array( 'key' => 'cdc_caract_ref',  'label' => 'Referencia (§)', 'tipo' => 'text', 'desc' => 'Ej. §1, §2…' ),
			),
		),
		'cdc_codigo' => array(
			'titulo' => 'Código de campo',
			'campos' => array(
				array( 'key' => 'cdc_codigo_numero', 'label' => 'Numeral romano', 'tipo' => 'text', 'desc' => 'Ej. i, ii, iii, iv, v' ),
			),
		),
	);
}

function cdc_registrar_metaboxes(): void {
	foreach ( cdc_metabox_defs() as $cpt => $config ) {
		add_meta_box(
			$cpt . '_meta',
			$config['titulo'],
			'cdc_render_metabox',
			$cpt,
			'normal',
			'high',
			$config
		);
	}
}

function cdc_render_metabox( WP_Post $post, array $metabox ): void {
	$config = $metabox['args'];
	wp_nonce_field( 'cdc_guardar_meta', 'cdc_meta_nonce' );
	echo '<table class="form-table" role="presentation"><tbody>';
	foreach ( $config['campos'] as $campo ) {
		$valor = get_post_meta( $post->ID, $campo['key'], true );
		printf(
			'<tr><th scope="row"><label for="%s">%s</label></th><td>',
			esc_attr( $campo['key'] ),
			esc_html( $campo['label'] )
		);
		switch ( $campo['tipo'] ) {
			case 'textarea':
				printf(
					'<textarea name="%s" id="%s" rows="4" class="large-text">%s</textarea>',
					esc_attr( $campo['key'] ),
					esc_attr( $campo['key'] ),
					esc_textarea( (string) $valor )
				);
				break;
			case 'select':
			case 'select_period_color':
				$opciones = $campo['opciones'] ?? array();
				if ( 'select_period_color' === $campo['tipo'] ) {
					$opciones = array(
						''                         => '— Selecciona —',
						'era-precambrico'          => 'Precámbrico (rosa)',
						'era-cambrico'             => 'Cámbrico (verde claro)',
						'era-ordovicico'           => 'Ordovícico (verde oscuro)',
						'era-silurico'             => 'Silúrico (turquesa)',
						'era-devonico'             => 'Devónico (marrón)',
						'era-carbonifero'          => 'Carbonífero (gris azul)',
						'era-permico'              => 'Pérmico (coral)',
						'era-triasico'             => 'Triásico (malva)',
						'era-jurasico'             => 'Jurásico (turquesa azul)',
						'era-cretacico-inferior'   => 'Cretácico Inferior (verde)',
						'era-cretacico-superior'   => 'Cretácico Superior (verde-amarillo)',
						'era-paleoceno-eoceno'     => 'Paleoceno – Eoceno (naranja)',
						'era-oligoceno-mioceno'   => 'Oligoceno – Mioceno (amarillo)',
						'era-cuaternario'          => 'Cuaternario (crema)',
						'libre'                    => '— Color libre (debajo) —',
					);
				}
				printf( '<select name="%s" id="%s">', esc_attr( $campo['key'] ), esc_attr( $campo['key'] ) );
				foreach ( $opciones as $v => $etiqueta ) {
					printf(
						'<option value="%s"%s>%s</option>',
						esc_attr( (string) $v ),
						selected( (string) $valor, (string) $v, false ),
						esc_html( (string) $etiqueta )
					);
				}
				echo '</select>';
				break;
			case 'text':
			default:
				printf(
					'<input type="text" name="%s" id="%s" value="%s" class="regular-text">',
					esc_attr( $campo['key'] ),
					esc_attr( $campo['key'] ),
					esc_attr( (string) $valor )
				);
				break;
		}
		if ( ! empty( $campo['desc'] ) ) {
			printf( '<p class="description">%s</p>', esc_html( $campo['desc'] ) );
		}
		echo '</td></tr>';
	}
	echo '</tbody></table>';
}

function cdc_guardar_meta( int $post_id, WP_Post $post ): void {
	if ( ! isset( $_POST['cdc_meta_nonce'] ) || ! wp_verify_nonce( (string) $_POST['cdc_meta_nonce'], 'cdc_guardar_meta' ) ) {
		return;
	}
	if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE ) {
		return;
	}
	if ( ! current_user_can( 'edit_post', $post_id ) ) {
		return;
	}

	$defs = cdc_metabox_defs();
	if ( ! isset( $defs[ $post->post_type ] ) ) {
		return;
	}

	foreach ( $defs[ $post->post_type ]['campos'] as $campo ) {
		$key = $campo['key'];
		if ( ! isset( $_POST[ $key ] ) ) {
			continue;
		}
		$valor = wp_unslash( $_POST[ $key ] );
		if ( 'textarea' === $campo['tipo'] ) {
			$valor = sanitize_textarea_field( (string) $valor );
		} else {
			$valor = sanitize_text_field( (string) $valor );
		}
		update_post_meta( $post_id, $key, $valor );
	}
}
