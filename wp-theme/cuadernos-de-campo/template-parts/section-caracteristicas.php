<?php
/**
 * Sección Características — field notes con icono.
 *
 * @package cuadernos-de-campo
 */

$notas = cdc_listar_cpt( 'cdc_caract', 12 );
?>
<section class="section" data-page="07 · características">
	<div class="wrap">
		<div class="eyebrow" data-reveal>Qué hay dentro</div>
		<h2 class="section-title" data-reveal>Lo que el cuaderno <em>sabe hacer</em>.</h2>

		<div class="field-notes">
			<?php
			$delay = 0;
			foreach ( $notas as $nota ) :
				$icon = (string) get_post_meta( $nota->ID, 'cdc_caract_icon', true );
				$ref  = (string) get_post_meta( $nota->ID, 'cdc_caract_ref', true );
				$delay_style = $delay === 0 ? '' : 'style="--d:.' . sprintf( '%02d', $delay ) . 's"';
				$delay += 6;
			?>
				<div class="note" data-reveal <?php echo $delay_style; // phpcs:ignore ?>>
					<div class="ic"><?php echo $icon ? cdc_icon( $icon ) : ''; ?></div>
					<h5><?php echo esc_html( $nota->post_title ); ?></h5>
					<p><?php echo wp_kses_post( wpautop( $nota->post_content ) ); ?></p>
					<?php if ( '' !== $ref ) : ?>
						<span class="ref"><?php echo esc_html( $ref ); ?></span>
					<?php endif; ?>
				</div>
			<?php endforeach; ?>
		</div>
	</div>
</section>
