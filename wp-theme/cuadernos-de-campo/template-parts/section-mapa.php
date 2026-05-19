<?php
/**
 * Sección Mapa — pines numerados + anotaciones laterales.
 *
 * Lee del CPT `cdc_mapa`. Los pines se posicionan con porcentajes
 * sobre la map-card.
 *
 * @package cuadernos-de-campo
 */

$pins = cdc_listar_cpt( 'cdc_mapa', 12 );
?>
<section class="section" data-page="05 · mapa cartografiado">
	<div class="wrap">
		<div class="eyebrow" data-reveal>Cobertura</div>
		<h2 class="section-title" data-reveal>La península, <em>estratificada</em>.</h2>
		<p class="section-lead" data-reveal>Cobertura cartográfica nacional con las capas oficiales del IGME. Mosaicos WMS de GEODE 50, MAGNA 50, edades y litologías; teselas en caché tras la primera visita.</p>

		<div class="map-block">
			<div class="map-card" data-reveal>
				<?php foreach ( $pins as $pin ) :
					$numero = (string) get_post_meta( $pin->ID, 'cdc_pin_numero', true );
					$left   = (string) get_post_meta( $pin->ID, 'cdc_pin_left', true );
					$top    = (string) get_post_meta( $pin->ID, 'cdc_pin_top', true );
					$color  = (string) get_post_meta( $pin->ID, 'cdc_pin_color', true );
					if ( ! in_array( $color, array( 'olive', 'ochre', 'terra' ), true ) ) {
						$color = 'olive';
					}
				?>
					<button class="map-pin <?php echo esc_attr( $color ); ?>" style="left: <?php echo esc_attr( $left ); ?>%; top: <?php echo esc_attr( $top ); ?>%;"><span><?php echo esc_html( $numero ); ?></span></button>
				<?php endforeach; ?>

				<div class="compass" aria-hidden="true">
					<div class="compass-needle"></div>
				</div>
				<div class="scale" aria-hidden="true">
					<span class="bar"></span><span>100 km</span>
				</div>
			</div>

			<aside class="map-annotations">
				<?php
				$delay = 0;
				foreach ( $pins as $pin ) :
					$numero = (string) get_post_meta( $pin->ID, 'cdc_pin_numero', true );
					$dt     = (string) get_post_meta( $pin->ID, 'cdc_pin_dt', true );
					$delay_style = $delay === 0 ? '' : 'style="--d:.' . sprintf( '%02d', $delay ) . 's"';
					$delay += 8;
				?>
					<div class="ann" data-reveal <?php echo $delay_style; // phpcs:ignore ?>>
						<div class="nm"><?php echo esc_html( $numero . ' · ' . $pin->post_title ); ?></div>
						<div class="dt"><?php echo esc_html( $dt ); ?></div>
						<p><?php echo esc_html( wp_strip_all_tags( $pin->post_content ) ); ?></p>
					</div>
				<?php endforeach; ?>
			</aside>
		</div>
	</div>
</section>
