<?php
/**
 * Helpers compartidos entre templates del tema Cuadernos de Campo.
 *
 * @package cuadernos-de-campo
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Devuelve el valor de un Customizer con fallback. Wrapper trivial
 * para que el template no tenga que repetir el default.
 */
function cdc_mod( string $clave, $defecto = '' ) {
	return get_theme_mod( $clave, $defecto );
}

/**
 * Lista de los 14 periodos geológicos en orden cronoestratigráfico
 * estándar (más antiguo arriba). Se usa para sembrar la timescale
 * incluso si el operador no ha publicado ningún CPT `cdc_periodo`.
 *
 * Los IDs coinciden con los del catálogo Dart de Fósiles
 * (`apps/fosiles/lib/datos/datos_guia.dart`).
 */
function cdc_periodos_canonicos(): array {
	return array(
		array( 'id' => 'precambrico',        'name' => 'Precámbrico',        'age' => '4567 – 541 Ma',  'flex' => 2.2, 'text' => 'Hadeano, Arcaico y Proterozoico. Los afloramientos accesibles en Iberia son escasos (núcleos de Ossa-Morena, Centro-Ibérica). Los fósiles plausibles son estromatolitos del Proterozoico tardío.' ),
		array( 'id' => 'cambrico',           'name' => 'Cámbrico',           'age' => '541 – 485 Ma',   'flex' => 1.0, 'text' => 'Explosión cámbrica. Trilobites (Paradoxides), arqueociátidos formando los primeros arrecifes, braquiópodos primitivos. Macizo Ibérico: Sierra de la Demanda, Ossa-Morena.' ),
		array( 'id' => 'ordovicico',         'name' => 'Ordovícico',         'age' => '485 – 444 Ma',   'flex' => 1.0, 'text' => 'Graptolitos (Didymograptus) en pizarras negras, trilobites (Asaphus, Calymene), icnitas de Cruziana en la Cuarcita Armoricana. Macizo Ibérico y Pirineos.' ),
		array( 'id' => 'silurico',           'name' => 'Silúrico',           'age' => '444 – 419 Ma',   'flex' => 1.0, 'text' => 'Monograptus marcador del periodo. Nautiloideos rectos (Orthoceras) en calizas griotte de Pirineos y Cordillera Cantábrica.' ),
		array( 'id' => 'devonico',           'name' => 'Devónico',           'age' => '419 – 359 Ma',   'flex' => 1.0, 'text' => 'Phacops, Spirifer, Favosites. El "Devónico Asturiano" de la Cordillera Cantábrica es referencia internacional.' ),
		array( 'id' => 'carbonifero',        'name' => 'Carbonífero',        'age' => '359 – 299 Ma',   'flex' => 1.0, 'text' => 'Bosques carboníferos: Calamites, Lepidodendron. Goniatites marinos en Asturias. Cuencas hulleras de Asturias y Sierra Morena.' ),
		array( 'id' => 'permico',            'name' => 'Pérmico',            'age' => '299 – 252 Ma',   'flex' => 1.0, 'text' => 'Facies continentales rojas. Walchia (coníferas primitivas) en cuencas pirenaicas y del Sistema Ibérico.' ),
		array( 'id' => 'triasico',           'name' => 'Triásico',           'age' => '252 – 201 Ma',   'flex' => 1.0, 'text' => 'Muschelkalk con Ceratites y Encrinus en Bizkaia. Yesos del Keuper en La Rioja Alavesa y Salinas de Añana.' ),
		array( 'id' => 'jurasico',           'name' => 'Jurásico',           'age' => '201 – 145 Ma',   'flex' => 1.0, 'text' => 'Hildoceras, Harpoceras, belemnites, Gryphaea. Las margas toarcienses de la Cuenca Vasco-Cantábrica son el yacimiento más prolífico de Iberia.' ),
		array( 'id' => 'cretacico-inferior', 'name' => 'Cretácico Inferior', 'age' => '145 – 100 Ma',   'flex' => 1.0, 'text' => 'Urgoniano: rudistas (Toucasia, Requienia) sustituyen a los corales. Ámbar de Peñacerrada con inclusiones de insectos — uno de los mejores del mundo.' ),
		array( 'id' => 'cretacico-superior', 'name' => 'Cretácico Superior', 'age' => '100 – 66 Ma',    'flex' => 1.0, 'text' => 'Hippurites en arrecifes de Iparralde. El flysch de Zumaia contiene el GSSP del Daniense, el clavo dorado del límite K-Pg.' ),
		array( 'id' => 'paleoceno-eoceno',   'name' => 'Paleoceno – Eoceno', 'age' => '66 – 34 Ma',     'flex' => 1.0, 'text' => 'Nummulites y Alveolina forman calizas masivas en Iparralde. Dientes de tiburones primitivos (Otodus) y crustáceos en cuencas pirenaicas.' ),
		array( 'id' => 'oligoceno-mioceno',  'name' => 'Oligoceno – Mioceno','age' => '34 – 5 Ma',      'flex' => 1.0, 'text' => 'Mamíferos terrestres: Anchitherium, Hipparion, Mastodon. Yacimientos de Bardenas y Rioja Alavesa.' ),
		array( 'id' => 'cuaternario',        'name' => 'Cuaternario',        'age' => '2,6 Ma – hoy',   'flex' => 1.0, 'text' => 'Pleistoceno: oso de las cavernas (Ursus spelaeus), Megaloceros, fauna fría en cuevas vascas (Santimamiñe, Arrikrutz).' ),
	);
}

/**
 * Construye el mapa periodo_id → { name, age, text } combinando el
 * catálogo canónico con cualquier sobrescritura publicada desde
 * wp-admin como CPT `cdc_periodo`. Se inyecta al JS via wp_add_inline.
 */
function cdc_periodos_map(): array {
	$resultado = array();
	foreach ( cdc_periodos_canonicos() as $p ) {
		$resultado[ $p['id'] ] = array(
			'name' => $p['name'],
			'age'  => $p['age'],
			'text' => $p['text'],
		);
	}
	// Sobreescritura desde CPT: meta `cdc_periodo_id` referencia uno
	// de los 14 ids canónicos; los campos title/excerpt/content_meta
	// reemplazan los del array si están rellenos.
	$override = get_posts(
		array(
			'post_type'      => 'cdc_periodo',
			'posts_per_page' => -1,
			'post_status'    => 'publish',
			'no_found_rows'  => true,
		)
	);
	foreach ( (array) $override as $post_periodo ) {
		$id = (string) get_post_meta( $post_periodo->ID, 'cdc_periodo_id', true );
		if ( ! $id || ! isset( $resultado[ $id ] ) ) {
			continue;
		}
		$texto = trim( wp_strip_all_tags( $post_periodo->post_content ) );
		if ( '' !== $texto ) {
			$resultado[ $id ]['text'] = $texto;
		}
		$nombre = trim( $post_periodo->post_title );
		if ( '' !== $nombre ) {
			$resultado[ $id ]['name'] = $nombre;
		}
		$edad = (string) get_post_meta( $post_periodo->ID, 'cdc_edad_ma', true );
		if ( '' !== $edad ) {
			$resultado[ $id ]['age'] = $edad;
		}
	}
	return $resultado;
}

/**
 * Renderiza un icono Material Symbols. Sin emoji.
 */
function cdc_icon( string $nombre ): string {
	return '<span class="material-symbols-outlined">' . esc_html( $nombre ) . '</span>';
}

/**
 * Devuelve los posts publicados de un CPT del tema, ordenados por
 * `menu_order` ascendente (y, si empata, por fecha ascendente).
 */
function cdc_listar_cpt( string $post_type, int $limite = -1 ): array {
	return get_posts(
		array(
			'post_type'      => $post_type,
			'posts_per_page' => $limite,
			'orderby'        => array( 'menu_order' => 'ASC', 'date' => 'ASC' ),
			'post_status'    => 'publish',
			'no_found_rows'  => true,
		)
	);
}

/**
 * URL absoluta de un asset del tema.
 */
function cdc_asset( string $ruta ): string {
	return CDC_THEME_URL . '/assets/' . ltrim( $ruta, '/' );
}
