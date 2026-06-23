<?php
/**
 * Plantilla única de un proyecto del portfolio.
 *
 * Despacha por el meta `gxare_proyecto_landing`:
 *  - vacío → renderiza la página genérica (single-gxare_proyecto-generica.php).
 *  - `cuadernos-de-campo` → carga el design system completo de la
 *    landing de cuadernos-de-campo (Fósiles + Naturaleza).
 *  - `flavor-chat-ia` → delega al template del plugin flavor-landing
 *    si existe; si no, cae a la genérica.
 *
 * @package gailu-xare
 */

get_template_part( 'template-parts/single-proyecto-header' );

while ( have_posts() ) :
	the_post();
	$landing = (string) get_post_meta( get_the_ID(), 'gxare_proyecto_landing', true );

	switch ( $landing ) {
		case 'cuadernos-de-campo':
			get_template_part( 'template-parts/landing-cdc' );
			break;
		case 'solera':
			// Landing del ecosistema Solera — paraguas de las 6
			// verticales agrarias (agro, viticultura, apícola,
			// arbolado urbano, quesera, aceitera).
			get_template_part( 'template-parts/landing-solera' );
			break;
		case 'bloques':
			// Landing montada con bloques tipo VBP, importados desde
			// flavor-platform o creados directamente en el meta. El
			// portfolio renderiza con sus propios partials, sin tocar
			// código del plugin Flavor.
			get_template_part( 'template-parts/landing-bloques' );
			break;
		case 'flavor-chat-ia':
			// Si el plugin flavor-landing está activo y expone un
			// template, lo dejamos pintar. Si no, caemos a genérica.
			if ( function_exists( 'flavor_landing_render' ) ) {
				flavor_landing_render();
			} else {
				get_template_part( 'template-parts/landing-generica' );
			}
			break;
		default:
			get_template_part( 'template-parts/landing-generica' );
			break;
	}
endwhile;

get_footer();
