<?php
/**
 * Bloque VBP: footer_editorial — pie con logo descompuesto + links + licencia.
 * Datos esperados:
 *   logo_pre, logo_em, logo_post, license,
 *   links[] { texto, url, nueva }.
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos     = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$logo_pre  = isset( $datos['logo_pre'] ) ? (string) $datos['logo_pre'] : '';
$logo_em   = isset( $datos['logo_em'] ) ? (string) $datos['logo_em'] : '';
$logo_post = isset( $datos['logo_post'] ) ? (string) $datos['logo_post'] : '';
$license   = isset( $datos['license'] ) ? (string) $datos['license'] : '';
$links     = isset( $datos['links'] ) && is_array( $datos['links'] ) ? $datos['links'] : array();
?>
<footer class="gxbloque gxbloque-footer">
	<div class="gxbloque__contenedor gxbloque-footer__rejilla">
		<div class="gxbloque-footer__logo">
			<?php if ( '' !== $logo_pre ) : ?>
				<span><?php echo esc_html( $logo_pre ); ?></span>
			<?php endif; ?>
			<?php if ( '' !== $logo_em ) : ?>
				<em><?php echo esc_html( $logo_em ); ?></em>
			<?php endif; ?>
			<?php if ( '' !== $logo_post ) : ?>
				<span><?php echo esc_html( $logo_post ); ?></span>
			<?php endif; ?>
		</div>
		<?php if ( ! empty( $links ) ) : ?>
			<nav class="gxbloque-footer__links">
				<?php foreach ( $links as $link ) : ?>
					<?php
					$texto = isset( $link['texto'] ) ? (string) $link['texto'] : '';
					$url   = isset( $link['url'] ) ? (string) $link['url'] : '';
					$nueva = ! empty( $link['nueva'] );
					if ( '' === $texto || '' === $url ) {
						continue;
					}
					?>
					<a
						href="<?php echo esc_url( $url ); ?>"
						<?php if ( $nueva ) : ?>target="_blank" rel="noopener"<?php endif; ?>
					><?php echo esc_html( $texto ); ?></a>
				<?php endforeach; ?>
			</nav>
		<?php endif; ?>
		<?php if ( '' !== $license ) : ?>
			<p class="gxbloque-footer__license"><?php echo esc_html( $license ); ?></p>
		<?php endif; ?>
	</div>
</footer>
