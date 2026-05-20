<?php
/**
 * Seed de contenido por defecto del tema Cuadernos de Campo.
 *
 * Se ejecuta una sola vez en la activación del tema. Idempotente:
 * cada entrada lleva un meta `cdc_seed_id` único; si ya existe, se
 * salta. Quien quiera regenerar el seed tras borrar contenido a mano
 * puede llamar a `cdc_seed_run()` desde wp-admin (no expuesto en UI
 * por ahora, se invoca con `wp shell` o tras desactivar/reactivar).
 *
 * @package cuadernos-de-campo
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

add_action( 'after_switch_theme', 'cdc_seed_run' );

function cdc_seed_run(): void {
	foreach ( cdc_seed_data() as $entry ) {
		cdc_seed_insertar( $entry );
	}
}

/**
 * Inserta un post si no existe ya un post del mismo CPT con el mismo
 * meta `cdc_seed_id`. Asigna `menu_order` para preservar orden.
 */
function cdc_seed_insertar( array $entry ): void {
	$existente = get_posts(
		array(
			'post_type'      => $entry['post_type'],
			'meta_key'       => 'cdc_seed_id',
			'meta_value'     => $entry['seed_id'],
			'posts_per_page' => 1,
			'post_status'    => 'any',
			'no_found_rows'  => true,
		)
	);
	if ( ! empty( $existente ) ) {
		// Si ya existe, refrescar los metas (no toca title/content
		// para no pisar edición humana posterior; sí los metas
		// porque permite añadir overrides nuevos al seed sin borrar
		// el contenido).
		$post_id = (int) $existente[0]->ID;
		foreach ( ( $entry['meta'] ?? array() ) as $key => $value ) {
			update_post_meta( $post_id, $key, $value );
		}
		return;
	}

	$post_id = wp_insert_post(
		array(
			'post_type'    => $entry['post_type'],
			'post_status'  => 'publish',
			'post_title'   => $entry['title'],
			'post_content' => $entry['content'] ?? '',
			'menu_order'   => $entry['orden'] ?? 0,
		)
	);
	if ( ! $post_id || is_wp_error( $post_id ) ) {
		return;
	}
	update_post_meta( $post_id, 'cdc_seed_id', $entry['seed_id'] );
	foreach ( ( $entry['meta'] ?? array() ) as $key => $value ) {
		update_post_meta( $post_id, $key, $value );
	}
}

function cdc_seed_data(): array {
	return array(

		// ─── Especímenes (6 fichas del bloque "Especímenes de muestra") ───

		array(
			'seed_id'  => 'esp-hildoceras',
			'post_type'=> 'cdc_especimen',
			'orden'    => 10,
			'title'    => 'Hildoceras',
			'content'  => 'Concha discoidal aplanada de ammonites del Toarciense. Frecuente en las margas vasco-cantábricas.',
			'meta'     => array(
				'cdc_grupo'             => 'Ammonoidea · Toarciense',
				'cdc_chip_label'        => 'Toarciense',
				'cdc_chip_color'        => 'era-jurasico',
				'cdc_codigo_ref'        => 'F-001',
				'cdc_localidad'         => 'Bizkaia',
				'cdc_coord_lat'         => '43.287',
				'cdc_coord_lng'         => '-2.611',
				'cdc_distintivos'       => "Concha discoidal aplanada\nCostillas falciformes\nSurcos paralelos a la quilla",
				'cdc_donde'             => 'Margas toarcienses de Bizkaia y Cantabria oriental.',
				'cdc_clase_visual'      => '',
			),
		),
		array(
			'seed_id'  => 'esp-toucasia',
			'post_type'=> 'cdc_especimen',
			'orden'    => 20,
			'title'    => 'Toucasia',
			'content'  => 'Rudista del Cretácico Inferior que sustituyó a los corales en arrecifes someros.',
			'meta'     => array(
				'cdc_grupo'             => 'Bivalvia · Requiénidos',
				'cdc_chip_label'        => 'Urgoniano',
				'cdc_chip_color'        => 'era-cretacico-inferior',
				'cdc_codigo_ref'        => 'F-014',
				'cdc_localidad'         => 'Ereño',
				'cdc_coord_lat'         => '43.360',
				'cdc_coord_lng'         => '-2.658',
				'cdc_distintivos'       => "Concha enrollada espiralada\nPared gruesa, 5–15 cm\nSustituyó a corales en arrecifes someros",
				'cdc_donde'             => 'Caliza urgoniana de Bizkaia: Ereño, Atxarte, Jata.',
				'cdc_clase_visual'      => 'bivalve',
				'cdc_wiki_titulo'       => 'Rudista',
			),
		),
		array(
			'seed_id'  => 'esp-ambar',
			'post_type'=> 'cdc_especimen',
			'orden'    => 30,
			'title'    => 'Ámbar de Peñacerrada',
			'content'  => 'Resina fósil amarilla-ambarina del Albiense con inclusiones de insectos y vegetales.',
			'meta'     => array(
				'cdc_grupo'             => 'Resina fósil · Albiense',
				'cdc_chip_label'        => 'Albiense',
				'cdc_chip_color'        => 'era-cretacico-inferior',
				'cdc_codigo_ref'        => 'F-027',
				'cdc_localidad'         => 'Peñacerrada',
				'cdc_coord_lat'         => '42.797',
				'cdc_coord_lng'         => '-2.838',
				'cdc_distintivos'       => "Resina amarilla-ambarina semitransparente\nInclusiones: insectos, fragmentos vegetales\nFluorescente bajo luz UV",
				'cdc_donde'             => 'Peñacerrada (Álava), Moraza (Burgos). Uno de los mejores yacimientos del mundo.',
				'cdc_clase_visual'      => 'amber',
				'cdc_wiki_titulo'       => 'Ámbar',
			),
		),
		array(
			'seed_id'  => 'esp-aglais',
			'post_type'=> 'cdc_especimen',
			'orden'    => 40,
			'title'    => 'Aglais io',
			'content'  => 'Pavo real diurno, lepidóptero ninfálido frecuente en prados de toda la península.',
			'meta'     => array(
				'cdc_grupo'             => 'Lepidoptera · Nymphalidae',
				'cdc_chip_label'        => 'Lepidóptero',
				'cdc_chip_color'        => 'libre',
				'cdc_chip_color_libre'  => '#E6C275',
				'cdc_codigo_ref'        => 'N-103',
				'cdc_localidad'         => 'Vitoria',
				'cdc_coord_lat'         => '43.261',
				'cdc_coord_lng'         => '-2.872',
				'cdc_distintivos'       => "Cuatro ocelos vivos sobre fondo rojizo\nLiba en cardos y escabiosas\nActiva de junio a septiembre",
				'cdc_donde'             => 'Prados, márgenes y jardines de toda la península.',
				'cdc_clase_visual'      => 'butterfly',
			),
		),
		array(
			'seed_id'  => 'esp-quercus',
			'post_type'=> 'cdc_especimen',
			'orden'    => 50,
			'title'    => 'Quercus petraea',
			'content'  => 'Roble albar de caducifolios atlánticos, hojas lobuladas con pecíolo largo.',
			'meta'     => array(
				'cdc_grupo'             => 'Fagaceae · Roble albar',
				'cdc_chip_label'        => 'Roble',
				'cdc_chip_color'        => 'libre',
				'cdc_chip_color_libre'  => '#A8C593',
				'cdc_codigo_ref'        => 'N-088',
				'cdc_localidad'         => 'Cantabria',
				'cdc_coord_lat'         => '43.182',
				'cdc_coord_lng'         => '-2.543',
				'cdc_distintivos'       => "Hoja lobulada con pecíolo largo\nBellotas casi sin pedúnculo\nHojas alternas, no agrupadas",
				'cdc_donde'             => 'Caducifolios atlánticos, Cordillera Cantábrica y Pirineos.',
				'cdc_clase_visual'      => 'leaf',
			),
		),
		array(
			'seed_id'  => 'esp-gyps',
			'post_type'=> 'cdc_especimen',
			'orden'    => 60,
			'title'    => 'Gyps fulvus',
			'content'  => 'Buitre leonado de las hoces del Riaza y Duratón.',
			'meta'     => array(
				'cdc_grupo'             => 'Accipitridae · Buitre leonado',
				'cdc_chip_label'        => 'Accipitr.',
				'cdc_chip_color'        => 'libre',
				'cdc_chip_color_libre'  => '#B7D6C4',
				'cdc_codigo_ref'        => 'N-061',
				'cdc_localidad'         => 'Hoces Riaza',
				'cdc_coord_lat'         => '41.366',
				'cdc_coord_lng'         => '-3.534',
				'cdc_distintivos'       => "Envergadura hasta 2,8 m\nPlumaje pardo claro, cabeza desnuda\nVuela en círculos sobre cortados",
				'cdc_donde'             => 'Hoces del Riaza, Hoces del Duratón, Pirineo.',
				'cdc_clase_visual'      => 'bird',
			),
		),

		// ─── Anotaciones del mapa (4 pins) ────────────────────────────────

		array(
			'seed_id' => 'mapa-cantabrica',
			'post_type' => 'cdc_mapa',
			'orden' => 10,
			'title' => 'Cordillera Cantábrica',
			'content' => 'Phacops, Spirifer, Favosites. Calizas griotte y Devónico Asturiano.',
			'meta' => array(
				'cdc_pin_numero' => '1',
				'cdc_pin_left'   => '28',
				'cdc_pin_top'    => '22',
				'cdc_pin_color'  => 'olive',
				'cdc_pin_dt'     => 'Devónico – Carbonífero',
			),
		),
		array(
			'seed_id' => 'mapa-sierra-morena',
			'post_type' => 'cdc_mapa',
			'orden' => 20,
			'title' => 'Sierra Morena',
			'content' => 'Cuarcita Armoricana con Cruziana, trilobites, arqueociátidos.',
			'meta' => array(
				'cdc_pin_numero' => '3',
				'cdc_pin_left'   => '22',
				'cdc_pin_top'    => '78',
				'cdc_pin_color'  => 'ochre',
				'cdc_pin_dt'     => 'Cámbrico – Ordovícico',
			),
		),
		array(
			'seed_id' => 'mapa-vasco-cantabrica',
			'post_type' => 'cdc_mapa',
			'orden' => 30,
			'title' => 'Cuenca Vasco-Cantábrica',
			'content' => 'Margas toarcienses, caliza urgoniana, flysch de Zumaia (GSSP Daniense).',
			'meta' => array(
				'cdc_pin_numero' => '4',
				'cdc_pin_left'   => '64',
				'cdc_pin_top'    => '56',
				'cdc_pin_color'  => 'terra',
				'cdc_pin_dt'     => 'Jurásico – Cretácico',
			),
		),
		array(
			'seed_id' => 'mapa-pirineos',
			'post_type' => 'cdc_mapa',
			'orden' => 40,
			'title' => 'Pirineos',
			'content' => 'Calizas con Nummulites y Alveolina. Llano de Iparralde.',
			'meta' => array(
				'cdc_pin_numero' => '6',
				'cdc_pin_left'   => '82',
				'cdc_pin_top'    => '22',
				'cdc_pin_color'  => 'ochre',
				'cdc_pin_dt'     => 'Eoceno',
			),
		),

		// ─── Pasos del proceso (5) ────────────────────────────────────────

		array(
			'seed_id' => 'paso-1',
			'post_type' => 'cdc_paso',
			'orden' => 10,
			'title' => 'Foto en su capa',
			'content' => 'Cámara en cuaderno. La foto se redimensiona a 1600 px y se firma con tu clave Ed25519.',
			'meta'    => array( 'cdc_paso_numero' => '1' ),
		),
		array(
			'seed_id' => 'paso-2',
			'post_type' => 'cdc_paso',
			'orden' => 20,
			'title' => 'Coordenadas y precisión',
			'content' => 'GPS con ±metros. La coordenada precisa se queda en sqflite local; nunca sale del dispositivo sin tu permiso.',
			'meta'    => array( 'cdc_paso_numero' => '2' ),
		),
		array(
			'seed_id' => 'paso-3',
			'post_type' => 'cdc_paso',
			'orden' => 30,
			'title' => 'Strike / dip',
			'content' => 'Brújula y acelerómetro miden la orientación del estrato. Se guarda como par numérico estándar geológico.',
			'meta'    => array( 'cdc_paso_numero' => '3' ),
		),
		array(
			'seed_id' => 'paso-4',
			'post_type' => 'cdc_paso',
			'orden' => 40,
			'title' => 'Edad y formación',
			'content' => 'El asistente IGME sugiere la formación a partir de GEODE 50. Tú confirmas o corriges.',
			'meta'    => array( 'cdc_paso_numero' => '4' ),
		),
		array(
			'seed_id' => 'paso-5',
			'post_type' => 'cdc_paso',
			'orden' => 50,
			'title' => 'Certificado SHA-256',
			'content' => 'Hash verificable del hallazgo. Comparte un .fos-card con quien quieras; nadie podrá alterarlo.',
			'meta'    => array( 'cdc_paso_numero' => '5' ),
		),

		// ─── Características (6 field notes) ──────────────────────────────

		array(
			'seed_id' => 'caract-1',
			'post_type' => 'cdc_caract',
			'orden' => 10,
			'title' => 'Cartografía IGME nacional',
			'content' => 'GEODE 50, MAGNA 50, Edades 1M, Litologías 1M. Mosaicos WMS, caché tras la primera visita.',
			'meta' => array( 'cdc_caract_icon' => 'layers', 'cdc_caract_ref' => '§1' ),
		),
		array(
			'seed_id' => 'caract-2',
			'post_type' => 'cdc_caract',
			'orden' => 20,
			'title' => 'Identificación con IA',
			'content' => 'Claude para fósiles; Pl@ntNet o Claude para plantas y bichos. Con tu API key, en tus términos.',
			'meta' => array( 'cdc_caract_icon' => 'smart_toy', 'cdc_caract_ref' => '§2' ),
		),
		array(
			'seed_id' => 'caract-3',
			'post_type' => 'cdc_caract',
			'orden' => 30,
			'title' => 'Privacidad estructural',
			'content' => 'Coordenadas precisas en sqflite local. Lo que sale del dispositivo lo decides tú, hallazgo por hallazgo.',
			'meta' => array( 'cdc_caract_icon' => 'shield_lock', 'cdc_caract_ref' => '§3' ),
		),
		array(
			'seed_id' => 'caract-4',
			'post_type' => 'cdc_caract',
			'orden' => 40,
			'title' => 'Mapas offline',
			'content' => 'Descarga la zona a la que vas. Funciona sin cobertura. Buena para campo y rutas largas.',
			'meta' => array( 'cdc_caract_icon' => 'offline_bolt', 'cdc_caract_ref' => '§4' ),
		),
		array(
			'seed_id' => 'caract-5',
			'post_type' => 'cdc_caract',
			'orden' => 50,
			'title' => 'Certificado verificable',
			'content' => 'SHA-256 + firma Ed25519. Comparte un .fos-card y cualquiera puede validar autenticidad.',
			'meta' => array( 'cdc_caract_icon' => 'verified', 'cdc_caract_ref' => '§5' ),
		),
		array(
			'seed_id' => 'caract-6',
			'post_type' => 'cdc_caract',
			'orden' => 60,
			'title' => 'Strike / dip integrado',
			'content' => 'Brújula y acelerómetro miden la orientación de la capa al apoyar el teléfono. Como un goniómetro.',
			'meta' => array( 'cdc_caract_icon' => 'straighten', 'cdc_caract_ref' => '§6' ),
		),

		// ─── Códigos de campo (5) ─────────────────────────────────────────

		array(
			'seed_id' => 'codigo-i',
			'post_type' => 'cdc_codigo',
			'orden' => 10,
			'title' => 'Tu hallazgo puede ser importante',
			'content' => 'Cada fósil cuenta una historia. Si encuentras algo que te parezca especial, compártelo con un museo, una universidad o una sociedad geológica. Ellos sabrán valorarlo y tú formarás parte del descubrimiento.',
			'meta'    => array( 'cdc_codigo_numero' => 'i' ),
		),
		array(
			'seed_id' => 'codigo-ii',
			'post_type' => 'cdc_codigo',
			'orden' => 20,
			'title' => 'Primero observa y fotografía',
			'content' => 'El contexto es tan valioso como la pieza. Fotografía el fósil en su capa, mide la orientación del estrato, registra la formación. Una buena documentación multiplica el valor científico de lo que encuentras. Muchas veces la foto es suficiente: no siempre hace falta recoger.',
			'meta'    => array( 'cdc_codigo_numero' => 'ii' ),
		),
		array(
			'seed_id' => 'codigo-iii',
			'post_type' => 'cdc_codigo',
			'orden' => 30,
			'title' => 'Infórmate para disfrutar más',
			'content' => 'Cada comunidad autónoma tiene sus propias normas de protección del patrimonio. Conocerlas te convierte en mejor aficionado: sabrás dónde puedes recoger y dónde es mejor solo fotografiar. Ante la duda, disfruta del hallazgo in situ.',
			'meta'    => array( 'cdc_codigo_numero' => 'iii' ),
		),
		array(
			'seed_id' => 'codigo-iv',
			'post_type' => 'cdc_codigo',
			'orden' => 40,
			'title' => 'Deja el lugar como te gustaría encontrarlo',
			'content' => 'No excaves sin permiso del propietario. No dañes afloramientos. Cierra las cancelas. Llévate tu basura… y quizá alguna ajena. Cada persona que pasa después de ti merece la misma emoción del descubrimiento.',
			'meta'    => array( 'cdc_codigo_numero' => 'iv' ),
		),
		array(
			'seed_id' => 'codigo-v',
			'post_type' => 'cdc_codigo',
			'orden' => 50,
			'title' => 'Comparte para que la ciencia avance',
			'content' => 'Usa el certificado verificable de la app para compartir tus hallazgos. Cada registro documentado ayuda a completar el mapa paleontológico de tu región. Tu contribución, sumada a la de otros aficionados, es ciencia ciudadana real.',
			'meta'    => array( 'cdc_codigo_numero' => 'v' ),
		),
	);
}
