<?php
/**
 * Bloque VBP: hosting_dark — pasos numerados oscuros con dos CTAs.
 * Datos esperados:
 *   label, titulo_pre, titulo_em, descripcion,
 *   pasos[] { titulo, descripcion },
 *   boton_1_texto, boton_1_url, boton_1_estilo, boton_1_nueva,
 *   boton_2_texto, boton_2_url, boton_2_estilo, boton_2_nueva.
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos       = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$label       = isset( $datos['label'] ) ? (string) $datos['label'] : '';
$titulo_pre  = isset( $datos['titulo_pre'] ) ? (string) $datos['titulo_pre'] : '';
$titulo_em   = isset( $datos['titulo_em'] ) ? (string) $datos['titulo_em'] : '';
$descripcion = isset( $datos['descripcion'] ) ? (string) $datos['descripcion'] : '';
$pasos       = isset( $datos['pasos'] ) && is_array( $datos['pasos'] ) ? $datos['pasos'] : array();

$botones = array();
foreach ( array( 1, 2 ) as $indice ) {
	$texto = isset( $datos[ "boton_{$indice}_texto" ] ) ? (string) $datos[ "boton_{$indice}_texto" ] : '';
	$url   = isset( $datos[ "boton_{$indice}_url" ] ) ? (string) $datos[ "boton_{$indice}_url" ] : '';
	if ( '' === $texto || '' === $url ) {
		continue;
	}
	$botones[] = array(
		'texto'  => $texto,
		'url'    => $url,
		'estilo' => isset( $datos[ "boton_{$indice}_estilo" ] ) ? (string) $datos[ "boton_{$indice}_estilo" ] : 'light',
		'nueva'  => ! empty( $datos[ "boton_{$indice}_nueva" ] ),
	);
}
?>
<section class="gxbloque gxbloque-hosting">
	<div class="gxbloque__contenedor">
		<?php if ( '' !== $label ) : ?>
			<p class="gxbloque-hosting__label"><?php echo esc_html( $label ); ?></p>
		<?php endif; ?>
		<?php if ( '' !== $titulo_pre || '' !== $titulo_em ) : ?>
			<h2 class="gxbloque-hosting__titulo">
				<?php echo esc_html( $titulo_pre ); ?>
				<?php if ( '' !== $titulo_em ) : ?>
					<em><?php echo esc_html( $titulo_em ); ?></em>
				<?php endif; ?>
			</h2>
		<?php endif; ?>
		<?php if ( '' !== $descripcion ) : ?>
			<p class="gxbloque-hosting__descripcion"><?php echo esc_html( $descripcion ); ?></p>
		<?php endif; ?>
		<?php if ( ! empty( $pasos ) ) : ?>
			<ol class="gxbloque-hosting__pasos">
				<?php foreach ( $pasos as $i => $paso ) : ?>
					<?php
					$titulo_paso       = isset( $paso['titulo'] ) ? (string) $paso['titulo'] : '';
					$descripcion_paso  = isset( $paso['descripcion'] ) ? (string) $paso['descripcion'] : '';
					$numero_paso       = str_pad( (string) ( $i + 1 ), 2, '0', STR_PAD_LEFT );
					?>
					<li class="gxbloque-hosting__paso">
						<span class="gxbloque-hosting__paso-numero"><?php echo esc_html( $numero_paso ); ?></span>
						<div class="gxbloque-hosting__paso-texto">
							<strong><?php echo esc_html( $titulo_paso ); ?></strong>
							<?php if ( '' !== $descripcion_paso ) : ?>
								<span><?php echo esc_html( $descripcion_paso ); ?></span>
							<?php endif; ?>
						</div>
					</li>
				<?php endforeach; ?>
			</ol>
		<?php endif; ?>
		<?php if ( ! empty( $botones ) ) : ?>
			<div class="gxbloque-hosting__botones">
				<?php foreach ( $botones as $boton ) : ?>
					<a
						class="gxbloque-hosting__boton gxbloque-hosting__boton--<?php echo esc_attr( $boton['estilo'] ); ?>"
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
