<?php
/**
 * Bloque VBP: relation_split — dos columnas con conector central.
 * Datos esperados:
 *   izq_titulo, izq_html (HTML simple),
 *   conector (texto plano con saltos de línea),
 *   der_titulo, der_html (HTML simple).
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos      = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$izq_titulo = isset( $datos['izq_titulo'] ) ? (string) $datos['izq_titulo'] : '';
$izq_html   = isset( $datos['izq_html'] ) ? (string) $datos['izq_html'] : '';
$conector   = isset( $datos['conector'] ) ? (string) $datos['conector'] : '';
$der_titulo = isset( $datos['der_titulo'] ) ? (string) $datos['der_titulo'] : '';
$der_html   = isset( $datos['der_html'] ) ? (string) $datos['der_html'] : '';

$html_permitido = array(
	'p'      => array(),
	'strong' => array(),
	'em'     => array(),
	'br'     => array(),
	'a'      => array( 'href' => true, 'rel' => true, 'target' => true ),
);

// El conector llega con saltos de línea reales; los respetamos
// convirtiéndolos a <br> en el render.
$conector_html = nl2br( esc_html( $conector ) );
?>
<section class="gxbloque gxbloque-relation">
	<div class="gxbloque__contenedor gxbloque-relation__rejilla">
		<div class="gxbloque-relation__col gxbloque-relation__col--izq">
			<?php if ( '' !== $izq_titulo ) : ?>
				<h3 class="gxbloque-relation__col-titulo"><?php echo esc_html( $izq_titulo ); ?></h3>
			<?php endif; ?>
			<?php if ( '' !== $izq_html ) : ?>
				<div class="gxbloque-relation__col-html">
					<?php echo wp_kses( $izq_html, $html_permitido ); ?>
				</div>
			<?php endif; ?>
		</div>
		<div class="gxbloque-relation__conector" aria-hidden="true">
			<?php echo $conector_html; // phpcs:ignore WordPress.Security.EscapeOutput.OutputNotEscaped ?>
		</div>
		<div class="gxbloque-relation__col gxbloque-relation__col--der">
			<?php if ( '' !== $der_titulo ) : ?>
				<h3 class="gxbloque-relation__col-titulo"><?php echo esc_html( $der_titulo ); ?></h3>
			<?php endif; ?>
			<?php if ( '' !== $der_html ) : ?>
				<div class="gxbloque-relation__col-html">
					<?php echo wp_kses( $der_html, $html_permitido ); ?>
				</div>
			<?php endif; ?>
		</div>
	</div>
</section>
