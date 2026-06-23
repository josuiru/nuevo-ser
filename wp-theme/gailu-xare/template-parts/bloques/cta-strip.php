<?php
/**
 * Bloque VBP: cta_strip — banda con texto + dos botones.
 * Datos esperados:
 *   texto, boton_1_texto, boton_1_url, boton_1_estilo, boton_1_nueva,
 *   boton_2_texto, boton_2_url, boton_2_estilo, boton_2_nueva,
 *   color_fondo, color_texto.
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos       = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$texto       = isset( $datos['texto'] ) ? (string) $datos['texto'] : '';
$color_fondo = isset( $datos['color_fondo'] ) ? (string) $datos['color_fondo'] : '#111';
$color_texto = isset( $datos['color_texto'] ) ? (string) $datos['color_texto'] : '#F2EDE3';

$botones = array();
foreach ( array( 1, 2 ) as $indice ) {
	$texto_boton = isset( $datos[ "boton_{$indice}_texto" ] ) ? (string) $datos[ "boton_{$indice}_texto" ] : '';
	$url_boton   = isset( $datos[ "boton_{$indice}_url" ] ) ? (string) $datos[ "boton_{$indice}_url" ] : '';
	if ( '' === $texto_boton || '' === $url_boton ) {
		continue;
	}
	$botones[] = array(
		'texto'  => $texto_boton,
		'url'    => $url_boton,
		'estilo' => isset( $datos[ "boton_{$indice}_estilo" ] ) ? (string) $datos[ "boton_{$indice}_estilo" ] : 'light',
		'nueva'  => ! empty( $datos[ "boton_{$indice}_nueva" ] ),
	);
}
?>
<section
	class="gxbloque gxbloque-cta-strip"
	style="--gxbloque-bg: <?php echo esc_attr( $color_fondo ); ?>; --gxbloque-fg: <?php echo esc_attr( $color_texto ); ?>;"
>
	<div class="gxbloque__contenedor gxbloque-cta-strip__rejilla">
		<?php if ( '' !== $texto ) : ?>
			<p class="gxbloque-cta-strip__texto"><?php echo esc_html( $texto ); ?></p>
		<?php endif; ?>
		<?php if ( ! empty( $botones ) ) : ?>
			<div class="gxbloque-cta-strip__botones">
				<?php foreach ( $botones as $boton ) : ?>
					<a
						class="gxbloque-cta-strip__boton gxbloque-cta-strip__boton--<?php echo esc_attr( $boton['estilo'] ); ?>"
						href="<?php echo esc_url( $boton['url'] ); ?>"
						<?php if ( $boton['nueva'] ) : ?>target="_blank" rel="noopener"<?php endif; ?>
					>
						<?php echo esc_html( $boton['texto'] ); ?>
					</a>
				<?php endforeach; ?>
			</div>
		<?php endif; ?>
	</div>
</section>
