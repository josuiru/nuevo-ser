<?php
/**
 * Bloque VBP: principles_list — rejilla de principios.
 * Datos esperados:
 *   titulo, columnas (string), color_fondo, color_texto,
 *   items[] { titulo, descripcion }.
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos       = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$titulo      = isset( $datos['titulo'] ) ? (string) $datos['titulo'] : '';
$columnas    = isset( $datos['columnas'] ) ? (int) $datos['columnas'] : 3;
$color_fondo = isset( $datos['color_fondo'] ) ? (string) $datos['color_fondo'] : '#C8261A';
$color_texto = isset( $datos['color_texto'] ) ? (string) $datos['color_texto'] : '#F2EDE3';
$items       = isset( $datos['items'] ) && is_array( $datos['items'] ) ? $datos['items'] : array();

if ( empty( $items ) ) {
	return;
}

$columnas = max( 1, min( 4, $columnas ) );
?>
<section
	class="gxbloque gxbloque-principles"
	style="--gxbloque-bg: <?php echo esc_attr( $color_fondo ); ?>; --gxbloque-fg: <?php echo esc_attr( $color_texto ); ?>; --gxbloque-principles-cols: <?php echo (int) $columnas; ?>;"
>
	<div class="gxbloque__contenedor">
		<?php if ( '' !== $titulo ) : ?>
			<h2 class="gxbloque-principles__titulo"><?php echo esc_html( $titulo ); ?></h2>
		<?php endif; ?>
		<div class="gxbloque-principles__rejilla">
			<?php foreach ( $items as $item ) : ?>
				<?php
				$titulo_item       = isset( $item['titulo'] ) ? (string) $item['titulo'] : '';
				$descripcion_item  = isset( $item['descripcion'] ) ? (string) $item['descripcion'] : '';
				?>
				<article class="gxbloque-principles__item">
					<?php if ( '' !== $titulo_item ) : ?>
						<h3 class="gxbloque-principles__item-titulo"><?php echo esc_html( $titulo_item ); ?></h3>
					<?php endif; ?>
					<?php if ( '' !== $descripcion_item ) : ?>
						<p class="gxbloque-principles__item-descripcion"><?php echo esc_html( $descripcion_item ); ?></p>
					<?php endif; ?>
				</article>
			<?php endforeach; ?>
		</div>
	</div>
</section>
