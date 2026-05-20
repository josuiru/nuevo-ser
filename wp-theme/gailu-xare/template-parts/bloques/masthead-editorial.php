<?php
/**
 * Bloque VBP: masthead_editorial.
 * Datos esperados: tagline, badge.
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$datos   = isset( $args['datos'] ) ? (array) $args['datos'] : array();
$tagline = isset( $datos['tagline'] ) ? (string) $datos['tagline'] : '';
$badge   = isset( $datos['badge'] ) ? (string) $datos['badge'] : '';
?>
<header class="gxbloque gxbloque-masthead">
	<div class="gxbloque__contenedor">
		<?php if ( '' !== $badge ) : ?>
			<span class="gxbloque-masthead__badge"><?php echo esc_html( $badge ); ?></span>
		<?php endif; ?>
		<?php if ( '' !== $tagline ) : ?>
			<h1 class="gxbloque-masthead__tagline"><?php echo esc_html( $tagline ); ?></h1>
		<?php endif; ?>
	</div>
</header>
