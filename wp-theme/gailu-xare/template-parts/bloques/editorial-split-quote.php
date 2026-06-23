<?php
/**
 * Bloque VBP: editorial_split_quote — aside con título + tags +
 * párrafo principal + quote destacada.
 * Datos esperados:
 *   aside_titulo_pre, aside_titulo_em, aside_tags[],
 *   body_html (HTML simple), quote_html (texto, sin HTML).
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos             = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$aside_titulo_pre  = isset( $datos['aside_titulo_pre'] ) ? (string) $datos['aside_titulo_pre'] : '';
$aside_titulo_em   = isset( $datos['aside_titulo_em'] ) ? (string) $datos['aside_titulo_em'] : '';
$aside_tags        = isset( $datos['aside_tags'] ) && is_array( $datos['aside_tags'] ) ? $datos['aside_tags'] : array();
$body_html         = isset( $datos['body_html'] ) ? (string) $datos['body_html'] : '';
$quote_html        = isset( $datos['quote_html'] ) ? (string) $datos['quote_html'] : '';

$html_permitido = array(
	'p'      => array(),
	'strong' => array(),
	'em'     => array(),
	'br'     => array(),
	'a'      => array( 'href' => true, 'rel' => true, 'target' => true ),
);
?>
<section class="gxbloque gxbloque-split-quote">
	<div class="gxbloque__contenedor gxbloque-split-quote__rejilla">
		<aside class="gxbloque-split-quote__aside">
			<?php if ( '' !== $aside_titulo_pre || '' !== $aside_titulo_em ) : ?>
				<h2 class="gxbloque-split-quote__titulo">
					<?php echo esc_html( $aside_titulo_pre ); ?>
					<?php if ( '' !== $aside_titulo_em ) : ?>
						<em><?php echo esc_html( $aside_titulo_em ); ?></em>
					<?php endif; ?>
				</h2>
			<?php endif; ?>
			<?php if ( ! empty( $aside_tags ) ) : ?>
				<ul class="gxbloque-split-quote__tags">
					<?php foreach ( $aside_tags as $tag ) : ?>
						<li><?php echo esc_html( (string) $tag ); ?></li>
					<?php endforeach; ?>
				</ul>
			<?php endif; ?>
		</aside>
		<div class="gxbloque-split-quote__body">
			<?php if ( '' !== $body_html ) : ?>
				<div class="gxbloque-split-quote__texto">
					<?php echo wp_kses( $body_html, $html_permitido ); ?>
				</div>
			<?php endif; ?>
			<?php if ( '' !== $quote_html ) : ?>
				<blockquote class="gxbloque-split-quote__quote">
					<?php echo esc_html( $quote_html ); ?>
				</blockquote>
			<?php endif; ?>
		</div>
	</div>
</section>
