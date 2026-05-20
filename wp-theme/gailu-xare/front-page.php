<?php
/**
 * Front page del tema Gailu Xare: hero + proyectos + descargas + sobre.
 *
 * Los proyectos y descargas vienen del plugin gailu-xare-portfolio
 * (CPTs + shortcodes). Si el plugin no está activo, los shortcodes
 * quedan inertes y aparece un aviso al admin desde functions.php.
 *
 * @package gailu-xare
 */

get_header();
?>

<section class="gxare-hero">
	<div class="gxare-hero__inner">
		<div class="gxare-eyebrow"><?php echo esc_html( gxare_mod( 'gxare_hero_eyebrow', '' ) ); ?></div>
		<h1 class="gxare-hero__titulo"><?php echo esc_html( gxare_mod( 'gxare_hero_titulo', '' ) ); ?></h1>
		<p class="gxare-hero__lead"><?php echo esc_html( gxare_mod( 'gxare_hero_lead', '' ) ); ?></p>

		<nav class="gxare-hero__cta">
			<a class="gxare-btn gxare-btn--primary" href="#proyectos">Ver proyectos</a>
			<a class="gxare-btn" href="#descargas">Descargar</a>
		</nav>
	</div>
</section>

<section id="proyectos" class="gxare-section">
	<div class="gxare-section__head">
		<div class="gxare-eyebrow">Trabajos</div>
		<h2>Lo que hay en el taller</h2>
		<p class="gxare-lead">Tres líneas conviven en este portfolio: Cuadernos de Campo (operador adulto), Solera (agricultura ibérica) y Flavor (plataforma WordPress y plugins). Cada tarjeta enlaza al repo, la demo o la página interna del proyecto.</p>
	</div>
	<div class="gxare-section__body">
		<?php echo do_shortcode( '[gxare_proyectos]' ); ?>
	</div>
</section>

<section id="descargas" class="gxare-section gxare-section--alt">
	<div class="gxare-section__head">
		<div class="gxare-eyebrow"><?php echo esc_html( gxare_mod( 'gxare_desc_titulo', 'Hub de descargas' ) ); ?></div>
		<h2><?php echo esc_html( gxare_mod( 'gxare_desc_titulo', 'Hub de descargas' ) ); ?></h2>
		<p class="gxare-lead"><?php echo esc_html( gxare_mod( 'gxare_desc_lead', '' ) ); ?></p>
	</div>
	<div class="gxare-section__body">
		<?php echo do_shortcode( '[gxare_descargas]' ); ?>
	</div>
</section>

<section id="sobre" class="gxare-section">
	<div class="gxare-section__head">
		<div class="gxare-eyebrow">Quién hay detrás</div>
		<h2><?php echo esc_html( gxare_mod( 'gxare_sobre_titulo', 'Sobre Gailu Xare' ) ); ?></h2>
	</div>
	<div class="gxare-section__body gxare-sobre">
		<?php echo wp_kses_post( wpautop( gxare_mod( 'gxare_sobre_cuerpo', '' ) ) ); ?>
	</div>
</section>

<?php
get_footer();
