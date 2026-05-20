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
		<p class="gxare-lead">Cuatro líneas conviven en este portfolio: Cuadernos de Campo (cuadernos digitales para adulto aficionado), Nuevo Ser Kids (juegos educativos para 9-14), Solera (suite agrícola ibérica) y Flavor (plataforma WordPress de Gailu Labs). Cada tarjeta enlaza a la ficha completa del proyecto con explicación pedagógica, virtudes y preguntas frecuentes.</p>
	</div>
	<div class="gxare-section__body">
		<?php
		// Render agrupado por colección
		$colecciones = get_terms(
			array(
				'taxonomy'   => 'gxare_coleccion',
				'hide_empty' => true,
				'orderby'    => 'term_id',
				'order'      => 'ASC',
			)
		);
		if ( ! empty( $colecciones ) && ! is_wp_error( $colecciones ) ) :
			foreach ( $colecciones as $col ) :
				$count = (int) $col->count;
		?>
			<div class="gxare-coleccion" id="coleccion-<?php echo esc_attr( $col->slug ); ?>">
				<header class="gxare-coleccion__head">
					<h3 class="gxare-coleccion__titulo"><?php echo esc_html( $col->name ); ?></h3>
					<?php if ( $col->description ) : ?>
						<p class="gxare-coleccion__desc"><?php echo esc_html( $col->description ); ?></p>
					<?php endif; ?>
					<span class="gxare-coleccion__count"><?php echo (int) $count; ?> proyecto<?php echo $count === 1 ? '' : 's'; ?></span>
				</header>
				<?php
				$query_proyectos = new WP_Query(
					array(
						'post_type'      => 'gxare_proyecto',
						'post_status'    => 'publish',
						'posts_per_page' => -1,
						'orderby'        => array( 'menu_order' => 'ASC', 'date' => 'ASC' ),
						'tax_query'      => array(
							array(
								'taxonomy' => 'gxare_coleccion',
								'field'    => 'term_id',
								'terms'    => array( $col->term_id ),
							),
						),
					)
				);
				if ( $query_proyectos->have_posts() ) :
					echo '<div class="gxare-proyectos-grid">';
					while ( $query_proyectos->have_posts() ) :
						$query_proyectos->the_post();
						gxare_render_tarjeta_proyecto( get_post() );
					endwhile;
					echo '</div>';
					wp_reset_postdata();
				endif;
				?>
			</div>
		<?php
			endforeach;
		else :
			// Fallback al shortcode plano si no hay términos
			echo do_shortcode( '[gxare_proyectos]' );
		endif;
		?>
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
