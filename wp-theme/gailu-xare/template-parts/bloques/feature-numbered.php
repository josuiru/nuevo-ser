<?php
/**
 * Bloque VBP: feature_numbered — rejilla numerada de items.
 * Datos esperados:
 *   label, columnas (string numérico), items[] con campos
 *   numero (puede no ser numérico, e.g. "Backend"/"App"),
 *   icono (Material Symbols), titulo, descripcion (HTML simple),
 *   url (opcional), nueva (opcional), tags[] (opcional).
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos    = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$label    = isset( $datos['label'] ) ? (string) $datos['label'] : '';
$columnas = isset( $datos['columnas'] ) ? (int) $datos['columnas'] : 3;
$items    = isset( $datos['items'] ) && is_array( $datos['items'] ) ? $datos['items'] : array();

if ( empty( $items ) ) {
	return;
}

$columnas = max( 1, min( 5, $columnas ) );

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
<section class="gxbloque gxbloque-feature-numbered" style="--gxbloque-feature-cols: <?php echo (int) $columnas; ?>;">
	<div class="gxbloque__contenedor">
		<?php if ( '' !== $label ) : ?>
			<p class="gxbloque-feature-numbered__label"><?php echo esc_html( $label ); ?></p>
		<?php endif; ?>
		<div class="gxbloque-feature-numbered__rejilla">
			<?php foreach ( $items as $item ) : ?>
				<?php
				$numero      = isset( $item['numero'] ) ? (string) $item['numero'] : '';
				$icono       = isset( $item['icono'] ) ? (string) $item['icono'] : '';
				$titulo      = isset( $item['titulo'] ) ? (string) $item['titulo'] : '';
				$descripcion = isset( $item['descripcion'] ) ? (string) $item['descripcion'] : '';
				$url         = isset( $item['url'] ) ? (string) $item['url'] : '';
				$nueva       = ! empty( $item['nueva'] );
				$tags        = isset( $item['tags'] ) && is_array( $item['tags'] ) ? $item['tags'] : array();
				$etiqueta_envoltorio = '' !== $url ? 'a' : 'div';
				?>
				<<?php echo esc_html( $etiqueta_envoltorio ); ?>
					class="gxbloque-feature-numbered__item<?php echo '' !== $url ? ' gxbloque-feature-numbered__item--enlace' : ''; ?>"
					<?php if ( '' !== $url ) : ?>
						href="<?php echo esc_url( $url ); ?>"
						<?php if ( $nueva ) : ?>target="_blank" rel="noopener"<?php endif; ?>
					<?php endif; ?>
				>
					<div class="gxbloque-feature-numbered__cabecera">
						<?php if ( '' !== $numero ) : ?>
							<span class="gxbloque-feature-numbered__numero"><?php echo esc_html( $numero ); ?></span>
						<?php endif; ?>
						<?php if ( '' !== $icono ) : ?>
							<span class="gxbloque-feature-numbered__icono material-symbols-outlined" aria-hidden="true"><?php echo esc_html( $icono ); ?></span>
						<?php endif; ?>
					</div>
					<?php if ( '' !== $titulo ) : ?>
						<h3 class="gxbloque-feature-numbered__titulo"><?php echo esc_html( $titulo ); ?></h3>
					<?php endif; ?>
					<?php if ( '' !== $descripcion ) : ?>
						<div class="gxbloque-feature-numbered__descripcion">
							<?php echo wp_kses( $descripcion, $html_permitido ); ?>
						</div>
					<?php endif; ?>
					<?php if ( ! empty( $tags ) ) : ?>
						<ul class="gxbloque-feature-numbered__tags">
							<?php foreach ( $tags as $tag ) : ?>
								<li><?php echo esc_html( (string) $tag ); ?></li>
							<?php endforeach; ?>
						</ul>
					<?php endif; ?>
				</<?php echo esc_html( $etiqueta_envoltorio ); ?>>
			<?php endforeach; ?>
		</div>
	</div>
</section>
