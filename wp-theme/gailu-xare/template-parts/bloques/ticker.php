<?php
/**
 * Bloque VBP: ticker.
 * Datos esperados: items[], duracion, separador (icono Material Symbols),
 *                   color_fondo, color_texto.
 *
 * Implementación: la animación CSS recorre el contenedor con
 * `animation: gxbloque-ticker-loop ...s linear infinite`. Duplicamos
 * los items in-line para que el bucle sea seamless visualmente.
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos       = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$items       = isset( $datos['items'] ) && is_array( $datos['items'] ) ? $datos['items'] : array();
$duracion    = isset( $datos['duracion'] ) ? (int) $datos['duracion'] : 30;
$separador   = isset( $datos['separador'] ) ? (string) $datos['separador'] : 'fiber_manual_record';
$color_fondo = isset( $datos['color_fondo'] ) ? (string) $datos['color_fondo'] : '#111';
$color_texto = isset( $datos['color_texto'] ) ? (string) $datos['color_texto'] : '#F2EDE3';

if ( empty( $items ) ) {
	return;
}
?>
<aside
	class="gxbloque gxbloque-ticker"
	style="--gxbloque-bg: <?php echo esc_attr( $color_fondo ); ?>; --gxbloque-fg: <?php echo esc_attr( $color_texto ); ?>; --gxbloque-ticker-duracion: <?php echo (int) $duracion; ?>s;"
>
	<div class="gxbloque-ticker__pista">
		<div class="gxbloque-ticker__cinta">
			<?php
			// La animación necesita que el contenido esté duplicado
			// para que cuando termine la primera copia ya esté
			// arrancando la segunda y no haya hueco visual.
			for ( $copia = 0; $copia < 2; $copia++ ) :
				foreach ( $items as $item ) :
					?>
					<span class="gxbloque-ticker__item"><?php echo esc_html( (string) $item ); ?></span>
					<span class="gxbloque-ticker__sep material-symbols-outlined" aria-hidden="true"><?php echo esc_html( $separador ); ?></span>
					<?php
				endforeach;
			endfor;
			?>
		</div>
	</div>
</aside>
