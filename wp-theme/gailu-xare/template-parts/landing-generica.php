<?php
/**
 * Landing genérica de un proyecto: hero + descripción + chips + tech +
 * enlaces + bloque de descargas filtradas por slug.
 *
 * Se usa para todos los proyectos que no tienen meta
 * `gxare_proyecto_landing` con un valor reconocido.
 *
 * @package gailu-xare
 */

$proyecto_id  = get_the_ID();
$subtitulo    = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_subtitulo', true );
$audiencia    = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_audiencia', true );
$estado       = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_estado', true );
$tipo         = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_tipo', true );
$tech         = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_tech', true );
$marca        = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_marca', true );
$url_web      = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_url_web', true );
$url_repo     = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_url_repo', true );
$url_demo     = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_url_demo', true );
$color        = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_color', true );
$slug         = get_post_field( 'post_name', $proyecto_id );

$techs = array_filter( array_map( 'trim', explode( ',', $tech ) ) );
$style_acento = '' !== $color ? sprintf( '--gxare-acento: %s;', esc_attr( $color ) ) : '';
?>

<article class="gxare-proyecto-page" style="<?php echo esc_attr( $style_acento ); ?>">

	<header class="gxare-proyecto-page__hero">
		<div class="gxare-proyecto-page__hero-inner">
			<a class="gxare-proyecto-page__volver" href="<?php echo esc_url( home_url( '/#proyectos' ) ); ?>">← Todos los proyectos</a>
			<?php if ( '' !== $marca ) : ?>
				<div class="gxare-eyebrow"><?php echo esc_html( $marca ); ?></div>
			<?php endif; ?>
			<h1 class="gxare-proyecto-page__titulo"><?php the_title(); ?></h1>
			<?php if ( '' !== $subtitulo ) : ?>
				<p class="gxare-proyecto-page__sub"><?php echo esc_html( $subtitulo ); ?></p>
			<?php endif; ?>

			<div class="gxare-proyecto-page__chips">
				<?php if ( '' !== $audiencia ) : ?>
					<span class="gxare-chip"><?php echo esc_html( $audiencia ); ?></span>
				<?php endif; ?>
				<?php if ( '' !== $tipo && function_exists( 'gxare_etiqueta_tipo' ) ) : ?>
					<span class="gxare-chip gxare-chip--tipo"><?php echo esc_html( gxare_etiqueta_tipo( $tipo ) ); ?></span>
				<?php endif; ?>
				<?php if ( '' !== $estado && function_exists( 'gxare_etiqueta_estado' ) ) : ?>
					<span class="gxare-chip gxare-chip--estado"><?php echo esc_html( gxare_etiqueta_estado( $estado ) ); ?></span>
				<?php endif; ?>
			</div>

			<nav class="gxare-proyecto-page__cta">
				<?php if ( '' !== $url_web ) : ?>
					<a class="gxare-btn gxare-btn--primary" href="<?php echo esc_url( $url_web ); ?>" target="_blank" rel="noopener">Ir a la web →</a>
				<?php endif; ?>
				<?php if ( '' !== $url_demo ) : ?>
					<a class="gxare-btn" href="<?php echo esc_url( $url_demo ); ?>" target="_blank" rel="noopener">Demo →</a>
				<?php endif; ?>
				<?php if ( '' !== $url_repo ) : ?>
					<a class="gxare-btn" href="<?php echo esc_url( $url_repo ); ?>" target="_blank" rel="noopener">Repositorio →</a>
				<?php endif; ?>
			</nav>
		</div>

		<?php if ( has_post_thumbnail() ) : ?>
			<div class="gxare-proyecto-page__hero-img">
				<?php the_post_thumbnail( 'large' ); ?>
			</div>
		<?php endif; ?>
	</header>

	<section class="gxare-proyecto-page__cuerpo">
		<?php the_content(); ?>
	</section>

	<?php if ( ! empty( $techs ) ) : ?>
		<section class="gxare-proyecto-page__tech-section">
			<h3>Tech stack</h3>
			<div class="gxare-proyecto-page__tech">
				<?php foreach ( $techs as $t ) : ?>
					<span><?php echo esc_html( $t ); ?></span>
				<?php endforeach; ?>
			</div>
		</section>
	<?php endif; ?>

	<?php
	// Descargas filtradas por slug del proyecto
	$descargas = get_posts(
		array(
			'post_type'      => 'gxare_descarga',
			'post_status'    => 'publish',
			'posts_per_page' => -1,
			'meta_query'     => array(
				array( 'key' => 'gxare_descarga_proyecto_slug', 'value' => $slug ),
			),
		)
	);
	if ( ! empty( $descargas ) ) :
	?>
		<section class="gxare-proyecto-page__descargas">
			<h3>Descargas</h3>
			<?php echo do_shortcode( '[gxare_descargas proyecto="' . esc_attr( $slug ) . '"]' ); ?>
		</section>
	<?php endif; ?>

	<footer class="gxare-proyecto-page__nav">
		<a class="gxare-btn" href="<?php echo esc_url( home_url( '/#proyectos' ) ); ?>">← Volver al portfolio</a>
	</footer>

</article>
