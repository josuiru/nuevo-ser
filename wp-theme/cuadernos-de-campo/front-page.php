<?php
/**
 * Front page del tema Cuadernos de Campo: monta la landing completa
 * orquestando los 9 template-parts en el orden de las páginas del
 * cuaderno (portada → tomos → especímenes → tiempo → mapa → proceso →
 * características → código → descarga).
 *
 * @package cuadernos-de-campo
 */

get_header();

get_template_part( 'template-parts/section', 'hero' );
get_template_part( 'template-parts/section', 'tomos' );
get_template_part( 'template-parts/section', 'especimenes' );
get_template_part( 'template-parts/section', 'tiempo' );
get_template_part( 'template-parts/section', 'mapa' );
get_template_part( 'template-parts/section', 'proceso' );
get_template_part( 'template-parts/section', 'caracteristicas' );
get_template_part( 'template-parts/section', 'codigo' );
get_template_part( 'template-parts/section', 'descargar' );

get_footer();
