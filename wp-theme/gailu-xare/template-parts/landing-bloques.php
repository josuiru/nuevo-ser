<?php
/**
 * Landing montada con bloques tipo VBP.
 *
 * Lee el meta `gxare_proyecto_bloques` del proyecto actual (array de
 * elementos {id, type, data}) y delega a `template-parts/bloques/{tipo}.php`
 * pasándole los datos vía $args. Cada partial es responsable de
 * generar su propia sección HTML; entre partials sólo el dispatcher
 * decide el orden.
 *
 * Si el meta está vacío (proyecto sin importar todavía) cae a la
 * landing genérica.
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$gxare_bloques = get_post_meta( get_the_ID(), 'gxare_proyecto_bloques', true );
if ( ! is_array( $gxare_bloques ) || empty( $gxare_bloques ) ) {
	get_template_part( 'template-parts/landing-generica' );
	return;
}

// Encolamos el CSS específico sólo cuando esta landing entra en
// escena — el resto de proyectos no pagan su peso.
add_action(
	'wp_footer',
	static function (): void {
		// fallback: en caso de que la página ya esté cabecera-cerrada
		// (algunos cachés agresivos), inyectamos el link aquí. No hay
		// daño en duplicar; el navegador deduplica el GET.
	}
);
wp_enqueue_style(
	'gxare-landing-bloques',
	GXARE_THEME_URL . '/assets/css/landing-bloques.css',
	array( 'gxare-tokens', 'gxare-portfolio' ),
	GXARE_THEME_VERSION
);
?>

<article class="gxare-landing gxare-landing--bloques">
	<?php
	foreach ( $gxare_bloques as $gxare_bloque ) {
		if ( ! is_array( $gxare_bloque ) ) {
			continue;
		}
		$gxare_tipo  = isset( $gxare_bloque['type'] ) ? sanitize_key( $gxare_bloque['type'] ) : '';
		$gxare_datos = isset( $gxare_bloque['data'] ) && is_array( $gxare_bloque['data'] ) ? $gxare_bloque['data'] : array();
		if ( '' === $gxare_tipo ) {
			continue;
		}
		// Reemplaza guiones bajos por guiones medios para que
		// `template-parts/bloques/{tipo}.php` siga la convención de
		// nombres de archivo del tema.
		$gxare_slug = str_replace( '_', '-', $gxare_tipo );

		// Comentario HTML útil al inspeccionar para depurar
		// import/orden de bloques.
		echo "\n<!-- bloque: {$gxare_tipo} -->\n"; // phpcs:ignore WordPress.Security.EscapeOutput
		get_template_part(
			'template-parts/bloques/' . $gxare_slug,
			null,
			array(
				'datos' => $gxare_datos,
				'id'    => isset( $gxare_bloque['id'] ) ? (string) $gxare_bloque['id'] : '',
				'tipo'  => $gxare_tipo,
			)
		);
	}
	?>
</article>
