<?php
/**
 * Landing genérica de un proyecto: hero + contenido rico + chips +
 * tech + enlaces + bloque de descargas filtradas por slug.
 *
 * Diseñada para clientes / partners / colaboradores que llegan a la
 * ficha por primera vez. Si el operador rellena los metas
 * gxare_proyecto_*_largo, _para_quien, _virtudes, _pedagogia y _faq,
 * la ficha se vuelve mucho más informativa.
 *
 * @package gailu-xare
 */

$proyecto_id   = get_the_ID();
$subtitulo     = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_subtitulo', true );
$audiencia     = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_audiencia', true );
$estado        = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_estado', true );
$tipo          = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_tipo', true );
$tech          = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_tech', true );
$marca         = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_marca', true );
$url_web       = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_url_web', true );
$url_repo      = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_url_repo', true );
$url_demo      = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_url_demo', true );
$color         = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_color', true );
$slug          = get_post_field( 'post_name', $proyecto_id );
$que_hace      = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_que_hace_largo', true );
$para_quien    = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_para_quien', true );
$virtudes_raw  = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_virtudes', true );
$pedagogia     = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_pedagogia', true );
$estado_largo  = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_estado_largo', true );
$faq_raw       = (string) get_post_meta( $proyecto_id, 'gxare_proyecto_faq', true );

$virtudes = array_filter( array_map( 'trim', preg_split( "/\r?\n/", $virtudes_raw ) ) );
$techs    = array_filter( array_map( 'trim', explode( ',', $tech ) ) );

// Parsear FAQs en formato "pregunta :: respuesta"
$faqs = array();
foreach ( preg_split( "/\r?\n/", $faq_raw ) as $linea ) {
	if ( strpos( $linea, '::' ) === false ) {
		continue;
	}
	list( $pregunta, $respuesta ) = explode( '::', $linea, 2 );
	$faqs[] = array(
		'q' => trim( $pregunta ),
		'a' => trim( $respuesta ),
	);
}

$style_acento = '' !== $color ? sprintf( '--gxare-acento: %s;', esc_attr( $color ) ) : '';

// Otros proyectos de la misma colección
$colecciones = wp_get_post_terms( $proyecto_id, 'gxare_coleccion' );
$relacionados = array();
if ( ! empty( $colecciones ) && ! is_wp_error( $colecciones ) ) {
	$relacionados = get_posts(
		array(
			'post_type'      => 'gxare_proyecto',
			'post_status'    => 'publish',
			'posts_per_page' => 4,
			'post__not_in'   => array( $proyecto_id ),
			'orderby'        => array( 'menu_order' => 'ASC', 'date' => 'ASC' ),
			'tax_query'      => array(
				array(
					'taxonomy' => 'gxare_coleccion',
					'field'    => 'term_id',
					'terms'    => array( $colecciones[0]->term_id ),
				),
			),
		)
	);
}
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

	<?php if ( '' !== $que_hace ) : ?>
		<section class="gxare-proyecto-page__bloque">
			<h2>Qué hace</h2>
			<div class="gxare-proyecto-page__texto-largo">
				<?php echo wp_kses_post( wpautop( $que_hace ) ); ?>
			</div>
		</section>
	<?php else : // fallback al post_content si no hay descripción rica ?>
		<section class="gxare-proyecto-page__bloque">
			<?php the_content(); ?>
		</section>
	<?php endif; ?>

	<?php if ( '' !== $para_quien ) : ?>
		<section class="gxare-proyecto-page__bloque">
			<h2>Para quién</h2>
			<div class="gxare-proyecto-page__texto-largo">
				<?php echo wp_kses_post( wpautop( $para_quien ) ); ?>
			</div>
		</section>
	<?php endif; ?>

	<?php if ( ! empty( $virtudes ) ) : ?>
		<section class="gxare-proyecto-page__bloque">
			<h2>Virtudes</h2>
			<ul class="gxare-proyecto-page__virtudes">
				<?php foreach ( $virtudes as $v ) : ?>
					<li><?php echo esc_html( $v ); ?></li>
				<?php endforeach; ?>
			</ul>
		</section>
	<?php endif; ?>

	<?php if ( '' !== $pedagogia ) : ?>
		<section class="gxare-proyecto-page__bloque gxare-proyecto-page__bloque--pedagogia">
			<h2>Pedagogía</h2>
			<div class="gxare-proyecto-page__texto-largo">
				<?php echo wp_kses_post( wpautop( $pedagogia ) ); ?>
			</div>
		</section>
	<?php endif; ?>

	<?php if ( '' !== $estado_largo ) : ?>
		<section class="gxare-proyecto-page__bloque">
			<h2>Estado actual</h2>
			<div class="gxare-proyecto-page__texto-largo">
				<?php echo wp_kses_post( wpautop( $estado_largo ) ); ?>
			</div>
		</section>
	<?php endif; ?>

	<?php if ( ! empty( $techs ) ) : ?>
		<section class="gxare-proyecto-page__bloque">
			<h2>Tech stack</h2>
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
		<section class="gxare-proyecto-page__bloque">
			<h2>Descargas</h2>
			<?php echo do_shortcode( '[gxare_descargas proyecto="' . esc_attr( $slug ) . '"]' ); ?>
		</section>
	<?php endif; ?>

	<?php if ( ! empty( $faqs ) ) : ?>
		<section class="gxare-proyecto-page__bloque gxare-proyecto-page__bloque--faq">
			<h2>Preguntas frecuentes</h2>
			<div class="gxare-faqs">
				<?php foreach ( $faqs as $faq ) : ?>
					<details class="gxare-faq">
						<summary><?php echo esc_html( $faq['q'] ); ?></summary>
						<div class="gxare-faq__a"><?php echo wp_kses_post( wpautop( $faq['a'] ) ); ?></div>
					</details>
				<?php endforeach; ?>
			</div>
		</section>
	<?php endif; ?>

	<?php if ( ! empty( $relacionados ) ) : ?>
		<section class="gxare-proyecto-page__bloque gxare-proyecto-page__bloque--relacionados">
			<h2>Otros proyectos de <?php echo esc_html( $colecciones[0]->name ); ?></h2>
			<div class="gxare-relacionados">
				<?php foreach ( $relacionados as $rel ) :
					$rel_sub   = (string) get_post_meta( $rel->ID, 'gxare_proyecto_subtitulo', true );
					$rel_color = (string) get_post_meta( $rel->ID, 'gxare_proyecto_color', true );
				?>
					<a class="gxare-relacionado" href="<?php echo esc_url( get_permalink( $rel ) ); ?>" style="<?php echo $rel_color ? 'border-left-color: ' . esc_attr( $rel_color ) . ';' : ''; ?>">
						<h3><?php echo esc_html( $rel->post_title ); ?></h3>
						<p><?php echo esc_html( $rel_sub ); ?></p>
					</a>
				<?php endforeach; ?>
			</div>
		</section>
	<?php endif; ?>

	<footer class="gxare-proyecto-page__nav">
		<a class="gxare-btn" href="<?php echo esc_url( home_url( '/#proyectos' ) ); ?>">← Volver al portfolio</a>
	</footer>

</article>
