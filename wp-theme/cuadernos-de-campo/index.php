<?php
/**
 * Fallback genérico del tema Cuadernos de Campo.
 *
 * Se usa solo cuando alguien acude a una URL no-front (p.ej. una página
 * o entrada de blog que el operador haya creado). Para la portada
 * promocional, ver front-page.php.
 *
 * @package cuadernos-de-campo
 */

get_header();
?>

<section class="section" style="padding: 80px 64px;">
	<div class="wrap">
		<?php if ( have_posts() ) : ?>
			<?php while ( have_posts() ) : the_post(); ?>
				<article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
					<header>
						<div class="eyebrow"><?php echo esc_html( get_the_date() ); ?></div>
						<h1 class="section-title"><?php the_title(); ?></h1>
					</header>
					<div class="entry-content">
						<?php the_content(); ?>
					</div>
				</article>
				<hr>
			<?php endwhile; ?>
		<?php else : ?>
			<div class="eyebrow">Página vacía</div>
			<h1 class="section-title">No hay contenido aquí.</h1>
			<p>Vuelve a la <a href="<?php echo esc_url( home_url( '/' ) ); ?>">portada</a>.</p>
		<?php endif; ?>
	</div>
</section>

<?php
get_footer();
