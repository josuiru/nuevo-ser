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
 *
 * Guarda function_exists para permitir que otro tema (p. ej.
 * gailu-xare cargando este helper para embeber la landing en su
 * single-gxare_proyecto) declare una versión con sus propios
 * defaults antes de cargar este fichero.
 */
if ( ! function_exists( 'cdc_mod' ) ) {
	function cdc_mod( string $clave, $defecto = '' ) {
		return get_theme_mod( $clave, $defecto );
	}
}

/**
 * Lista de los 14 periodos geológicos en orden cronoestratigráfico
 * estándar (más antiguo arriba). Se usa para sembrar la timescale
 * incluso si el operador no ha publicado ningún CPT `cdc_periodo`.
 *
 * Los IDs coinciden con los del catálogo Dart de Fósiles
 * (`apps/fosiles/lib/datos/datos_guia.dart`).
 */
if ( ! function_exists( 'cdc_periodos_canonicos' ) ) :
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
endif;

/**
 * Construye el mapa periodo_id → { name, age, text } combinando el
 * catálogo canónico con cualquier sobrescritura publicada desde
 * wp-admin como CPT `cdc_periodo`. Se inyecta al JS via wp_add_inline.
 */
if ( ! function_exists( 'cdc_periodos_map' ) ) :
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
endif;

/**
 * Renderiza un icono Material Symbols. Sin emoji.
 */
if ( ! function_exists( 'cdc_icon' ) ) {
	function cdc_icon( string $nombre ): string {
		return '<span class="material-symbols-outlined">' . esc_html( $nombre ) . '</span>';
	}
}

/**
 * Devuelve los posts publicados de un CPT del tema, ordenados por
 * `menu_order` ascendente (y, si empata, por fecha ascendente).
 */
if ( ! function_exists( 'cdc_listar_cpt' ) ) {
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
}

/**
 * URL absoluta de un asset del tema.
 */
if ( ! function_exists( 'cdc_asset' ) ) {
	function cdc_asset( string $ruta ): string {
		return CDC_THEME_URL . '/assets/' . ltrim( $ruta, '/' );
	}
}

/**
 * Devuelve la URL de la miniatura de Wikipedia para un título dado
 * (artículo en es.wikipedia.org), o cadena vacía si no hay foto.
 * Cachea el resultado durante 30 días vía transient — la API REST
 * de Wikipedia rate-limita, pero el cache lo absorbe.
 *
 * Legal: la API REST de Wikipedia es libre, las miniaturas vienen
 * bajo CC-BY-SA o dominio público. Basta enlazar al artículo para
 * cumplir la atribución (lo hacemos en .bk-coord con "Wikipedia").
 *
 * @param string $titulo Título exacto del artículo en es.wikipedia.org.
 */
if ( ! function_exists( 'cdc_wikipedia_thumb' ) ) {
	function cdc_wikipedia_thumb( string $titulo ): string {
		if ( '' === trim( $titulo ) ) {
			return '';
		}
		$clave_cache = 'cdc_wiki_thumb_' . md5( strtolower( $titulo ) );
		$cacheado    = get_transient( $clave_cache );
		if ( false !== $cacheado ) {
			// 'none' = se intentó y no había foto, evita re-pedir.
			return 'none' === $cacheado ? '' : (string) $cacheado;
		}

		$url = 'https://es.wikipedia.org/api/rest_v1/page/summary/' . rawurlencode( $titulo );
		$resp = wp_remote_get(
			$url,
			array(
				'timeout'    => 6,
				'user-agent' => 'Cuadernos-de-Campo/1.0 (https://github.com/JosuIru/cuadernos-de-campo; contacto: gailu.net)',
				'headers'    => array( 'Accept' => 'application/json' ),
			)
		);

		if ( is_wp_error( $resp ) || 200 !== (int) wp_remote_retrieve_response_code( $resp ) ) {
			// Cachear el fallo 1 día para no machacar la API.
			set_transient( $clave_cache, 'none', DAY_IN_SECONDS );
			return '';
		}

		$body = json_decode( (string) wp_remote_retrieve_body( $resp ), true );
		$thumb = '';
		if ( is_array( $body ) ) {
			// thumbnail (256) o originalimage (más grande, pesa más).
			$thumb = (string) ( $body['thumbnail']['source'] ?? $body['originalimage']['source'] ?? '' );
		}

		set_transient(
			$clave_cache,
			'' === $thumb ? 'none' : $thumb,
			30 * DAY_IN_SECONDS
		);
		return $thumb;
	}
}
