<?php
/**
 * Sección Proceso — pasos numerados.
 *
 * @package cuadernos-de-campo
 */

$pasos = cdc_listar_cpt( 'cdc_paso', 12 );
?>
<section class="section" data-page="06 · cómo se anota">
	<div class="wrap">
		<div class="eyebrow" data-reveal>Procedimiento</div>
		<h2 class="section-title" data-reveal>Anotar un hallazgo, paso a <em>paso</em>.</h2>
		<p class="section-lead" data-reveal>Cinco gestos. Cinco campos. Una huella verificable. Sin formularios largos, sin obligar a sincronizar.</p>

		<div class="process">
			<?php
			$delay = 0;
			foreach ( $pasos as $paso ) :
				$numero = (string) get_post_meta( $paso->ID, 'cdc_paso_numero', true );
				$delay_style = $delay === 0 ? '' : 'style="--d:.' . sprintf( '%02d', $delay ) . 's"';
				$delay += 8;
			?>
				<div class="step" data-reveal <?php echo $delay_style; // phpcs:ignore ?>>
					<div class="n"><?php echo esc_html( $numero ); ?></div>
					<h5><?php echo esc_html( $paso->post_title ); ?></h5>
					<p><?php echo esc_html( wp_strip_all_tags( $paso->post_content ) ); ?></p>
				</div>
			<?php endforeach; ?>
		</div>
	</div>
</section>
