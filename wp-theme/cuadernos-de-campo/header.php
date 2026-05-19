<?php
/**
 * Cabecera HTML del tema Cuadernos de Campo.
 *
 * @package cuadernos-de-campo
 */
?><!doctype html>
<html <?php language_attributes(); ?>>
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" href="<?php echo esc_url( cdc_asset( 'img/fosiles-icon.png' ) ); ?>">
	<?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>

	<div id="loader" aria-hidden="true">
		<div class="loader-spiral"></div>
		<div class="loader-text">Abriendo cuaderno…</div>
	</div>

	<div class="book">

		<aside class="spine" aria-hidden="true">
			<div class="spine-label">Cuadernos de Campo</div>
			<div class="spine-strata">
				<?php foreach ( cdc_periodos_canonicos() as $p ) : ?>
					<div class="layer" style="background: var(--era-<?php echo esc_attr( $p['id'] ); ?>);">
						<span class="lbl"><?php echo esc_html( $p['name'] ); ?></span>
					</div>
				<?php endforeach; ?>
				<div class="spine-bookmark"></div>
			</div>
			<div class="spine-foot">pág. <span class="pag">01</span></div>
		</aside>

		<main class="page">
