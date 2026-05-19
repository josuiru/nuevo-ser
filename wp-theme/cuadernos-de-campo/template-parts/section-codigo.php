<?php
/**
 * Sección Código de campo — los 5 códigos éticos.
 *
 * @package cuadernos-de-campo
 */

$codigos = cdc_listar_cpt( 'cdc_codigo', 12 );
?>
<section class="section" data-page="08 · código de campo">
	<div class="wrap">
		<div class="eyebrow" data-reveal>Reglas del cuaderno</div>
		<h2 class="section-title" data-reveal>Códigos para que tu <em>afición sume</em>.</h2>
		<p class="section-lead" data-reveal>Estos códigos vienen literalmente impresos en la pantalla de Inicio de las dos apps. Léelos antes de salir.</p>

		<div class="code" data-reveal>
			<?php foreach ( $codigos as $cod ) :
				$numero = (string) get_post_meta( $cod->ID, 'cdc_codigo_numero', true );
			?>
				<div class="code-row">
					<div class="n"><?php echo esc_html( $numero ); ?></div>
					<div>
						<h5><?php echo esc_html( $cod->post_title ); ?></h5>
						<p><?php echo esc_html( wp_strip_all_tags( $cod->post_content ) ); ?></p>
					</div>
				</div>
			<?php endforeach; ?>
		</div>
	</div>
</section>
