<?php
/**
 * Bloque VBP: hero_editorial.
 * Datos esperados:
 *   kicker, titulo_pre, titulo_em, titulo_post, lead_html (HTML simple),
 *   pull_quote, meta[] (lista de bullets de pie del hero).
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos        = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$kicker       = isset( $datos['kicker'] ) ? (string) $datos['kicker'] : '';
$titulo_pre   = isset( $datos['titulo_pre'] ) ? (string) $datos['titulo_pre'] : '';
$titulo_em    = isset( $datos['titulo_em'] ) ? (string) $datos['titulo_em'] : '';
$titulo_post  = isset( $datos['titulo_post'] ) ? (string) $datos['titulo_post'] : '';
$lead_html    = isset( $datos['lead_html'] ) ? (string) $datos['lead_html'] : '';
$pull_quote   = isset( $datos['pull_quote'] ) ? (string) $datos['pull_quote'] : '';
$lista_meta   = isset( $datos['meta'] ) && is_array( $datos['meta'] ) ? $datos['meta'] : array();

// El lead viene con párrafos en HTML desde el builder; lo permitimos
// pero pasamos por wp_kses para acotar tags y proteger contra XSS.
$html_permitido = array(
	'p'      => array(),
	'strong' => array(),
	'em'     => array(),
	'br'     => array(),
	'a'      => array(
		'href'   => true,
		'rel'    => true,
		'target' => true,
	),
);
?>
<section class="gxbloque gxbloque-hero">
	<div class="gxbloque__contenedor gxbloque-hero__rejilla">
		<div class="gxbloque-hero__principal">
			<?php if ( '' !== $kicker ) : ?>
				<p class="gxbloque-hero__kicker"><?php echo esc_html( $kicker ); ?></p>
			<?php endif; ?>
			<h2 class="gxbloque-hero__titulo">
				<?php if ( '' !== $titulo_pre ) : ?>
					<span class="gxbloque-hero__titulo-pre"><?php echo esc_html( $titulo_pre ); ?></span>
				<?php endif; ?>
				<?php if ( '' !== $titulo_em ) : ?>
					<em class="gxbloque-hero__titulo-em"><?php echo esc_html( $titulo_em ); ?></em>
				<?php endif; ?>
				<?php if ( '' !== $titulo_post ) : ?>
					<span class="gxbloque-hero__titulo-post"><?php echo esc_html( $titulo_post ); ?></span>
				<?php endif; ?>
			</h2>
			<?php if ( '' !== $lead_html ) : ?>
				<div class="gxbloque-hero__lead">
					<?php echo wp_kses( $lead_html, $html_permitido ); ?>
				</div>
			<?php endif; ?>
		</div>
		<aside class="gxbloque-hero__lateral">
			<?php if ( '' !== $pull_quote ) : ?>
				<blockquote class="gxbloque-hero__quote">
					<?php echo esc_html( $pull_quote ); ?>
				</blockquote>
			<?php endif; ?>
			<?php if ( ! empty( $lista_meta ) ) : ?>
				<ul class="gxbloque-hero__meta">
					<?php foreach ( $lista_meta as $linea ) : ?>
						<li><?php echo esc_html( (string) $linea ); ?></li>
					<?php endforeach; ?>
				</ul>
			<?php endif; ?>
		</aside>
	</div>
</section>
