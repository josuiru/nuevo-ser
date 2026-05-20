<?php
/**
 * Importer Flavor Landing → proyecto del portfolio.
 *
 * Permite traer una landing creada en el Visual Builder Pro del plugin
 * `flavor-platform` a un proyecto `gxare_proyecto` del portfolio. Tras
 * la importación, el plugin Flavor Platform deja de ser necesario
 * para que la landing siga renderizándose: el portfolio guarda copia
 * de los datos en su propio meta `gxare_proyecto_bloques`.
 *
 * Schema del meta (mismo formato que VBP para reutilizar):
 *   array(
 *     array(
 *       'id'   => 'el_XXXX',
 *       'type' => 'masthead_editorial' | 'ticker' | 'hero_editorial' | ...,
 *       'data' => array(...),  // estructura específica del tipo
 *     ),
 *     ...
 *   )
 *
 * Se mantiene como array nativo PHP (no JSON) porque WordPress lo
 * serializa automáticamente al guardarlo en wp_postmeta.
 *
 * @package GailuXarePortfolio
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Copia los bloques VBP de un `flavor_landing` al meta del proyecto.
 *
 * Idempotente: re-ejecutar pisa el meta con la versión actual del
 * post de Flavor. Lanza WP_Error con código identificable si algo
 * falla — los callers (WP-CLI, AJAX, futuro botón en admin) deciden
 * qué hacer.
 *
 * @param int    $id_landing_flavor   ID del post `flavor_landing` origen.
 * @param string $slug_proyecto       Slug del `gxare_proyecto` destino.
 * @return array{numero_bloques:int,id_proyecto:int}|WP_Error
 */
function gxare_importar_flavor_landing( int $id_landing_flavor, string $slug_proyecto ) {
	$post_flavor = get_post( $id_landing_flavor );
	if ( ! $post_flavor || 'flavor_landing' !== $post_flavor->post_type ) {
		return new WP_Error(
			'gxare_flavor_no_es_landing',
			"El post #{$id_landing_flavor} no existe o no es de tipo flavor_landing."
		);
	}

	$datos_vbp = get_post_meta( $id_landing_flavor, '_flavor_vbp_data', true );
	if ( ! is_array( $datos_vbp ) || empty( $datos_vbp['elements'] ) ) {
		return new WP_Error(
			'gxare_flavor_sin_bloques',
			"El post #{$id_landing_flavor} no tiene bloques VBP en _flavor_vbp_data."
		);
	}

	$proyectos = get_posts(
		array(
			'name'        => $slug_proyecto,
			'post_type'   => 'gxare_proyecto',
			'post_status' => array( 'publish', 'draft', 'pending', 'private' ),
			'numberposts' => 1,
		)
	);
	if ( empty( $proyectos ) ) {
		return new WP_Error(
			'gxare_proyecto_no_encontrado',
			"No hay gxare_proyecto con slug '{$slug_proyecto}'."
		);
	}
	$proyecto = $proyectos[0];

	// Normalizamos: el meta del portfolio guarda sólo la lista de
	// elementos, sin la envoltura {version, settings, elements} que
	// añade VBP. La versión origen y los settings se quedan aparte
	// para trazabilidad pero no estorban al renderer del tema.
	$bloques  = array_values( (array) $datos_vbp['elements'] );
	$ajustes  = isset( $datos_vbp['settings'] ) ? (array) $datos_vbp['settings'] : array();
	$version  = isset( $datos_vbp['version'] ) ? (string) $datos_vbp['version'] : '';

	update_post_meta( $proyecto->ID, 'gxare_proyecto_bloques', $bloques );
	update_post_meta( $proyecto->ID, 'gxare_proyecto_bloques_ajustes', $ajustes );
	update_post_meta(
		$proyecto->ID,
		'gxare_proyecto_bloques_origen',
		array(
			'tipo'        => 'flavor_vbp',
			'flavor_post' => $id_landing_flavor,
			'vbp_version' => $version,
			'importado'   => current_time( 'mysql' ),
		)
	);

	return array(
		'numero_bloques' => count( $bloques ),
		'id_proyecto'    => $proyecto->ID,
	);
}

/**
 * Comando WP-CLI:
 *
 *   wp gxare importar-flavor-landing <id_flavor> --proyecto=<slug>
 *
 * Ej.:
 *   wp gxare importar-flavor-landing 8426 --proyecto=flavor-news-hub
 */
if ( defined( 'WP_CLI' ) && WP_CLI ) {
	WP_CLI::add_command(
		'gxare importar-flavor-landing',
		static function ( array $args, array $assoc ): void {
			$id_landing = isset( $args[0] ) ? (int) $args[0] : 0;
			$slug       = isset( $assoc['proyecto'] ) ? (string) $assoc['proyecto'] : '';

			if ( $id_landing <= 0 || '' === $slug ) {
				WP_CLI::error(
					'Uso: wp gxare importar-flavor-landing <id_flavor> --proyecto=<slug>'
				);
			}

			$resultado = gxare_importar_flavor_landing( $id_landing, $slug );
			if ( is_wp_error( $resultado ) ) {
				WP_CLI::error( $resultado->get_error_message() );
			}
			WP_CLI::success(
				sprintf(
					'Importados %d bloques al proyecto #%d.',
					$resultado['numero_bloques'],
					$resultado['id_proyecto']
				)
			);
		}
	);
}
