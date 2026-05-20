<?php
/**
 * Fallback genérico del tema Gailu Xare.
 *
 * @package gailu-xare
 */

get_header();
?>
<section class="gxare-section">
	<div class="gxare-section__head">
		<?php if ( have_posts() ) : ?>
			<?php while ( have_posts() ) : the_post(); ?>
				<div class="gxare-eyebrow"><?php echo esc_html( get_the_date() ); ?></div>
				<h1><?php the_title(); ?></h1>
				<div class="gxare-entry-content">
					<?php the_content(); ?>
				</div>
				<hr>
			<?php endwhile; ?>
		<?php else : ?>
			<h1>No hay contenido aquí.</h1>
			<p><a href="<?php echo esc_url( home_url( '/' ) ); ?>">Volver a la portada</a>.</p>
		<?php endif; ?>
	</div>
</section>
<?php
get_footer();
