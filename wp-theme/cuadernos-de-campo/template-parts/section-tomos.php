<?php
/**
 * Sección Tomos — Fósiles + Naturaleza como dos tarjetas-tomo.
 *
 * @package cuadernos-de-campo
 */
?>
<section class="section" id="tomos" data-page="02 · los dos tomos">
	<div class="wrap">
		<div class="eyebrow" data-reveal>Tomo I &amp; Tomo II</div>
		<h2 class="section-title" data-reveal>Dos cuadernos, una misma <em>caligrafía</em>.</h2>
		<p class="section-lead" data-reveal>Comparten plataforma técnica, voz y privacidad estructural. Cada uno cubre su dominio sin contaminar al otro.</p>

		<div class="tomos">

			<?php for ( $num = 1; $num <= 2; $num++ ) :
				$prefijo = $num === 1 ? 'cdc_tomo1' : 'cdc_tomo2';
				$clase   = $num === 1 ? 'fosiles' : 'naturaleza';
				$etiqueta = $num === 1 ? 'Tomo I' : 'Tomo II';
				$style_d  = $num === 1 ? '' : 'style="--d:.15s"';
				$chips    = array_filter( array_map( 'trim', explode( '|', (string) cdc_mod( "{$prefijo}_chips", '' ) ) ) );
			?>
			<div class="tomo <?php echo esc_attr( $clase ); ?>" data-reveal <?php echo $style_d; // phpcs:ignore -- inline style por reveal delay ?>>
				<div class="tomo-tape"></div>
				<svg class="paperclip tomo-clip" viewBox="0 0 26 50" aria-hidden="true">
					<path d="M5 8 L5 38 Q5 46 13 46 Q21 46 21 38 L21 12 Q21 6 15 6 Q9 6 9 12 L9 34" fill="none" stroke="#888" stroke-width="2" stroke-linecap="round"/>
				</svg>
				<div class="tomo-card">
					<div class="figure"></div>
					<div class="tag"><?php echo esc_html( $etiqueta ); ?></div>
					<h3><?php echo esc_html( cdc_mod( "{$prefijo}_titulo", '' ) ); ?></h3>
					<p class="sub"><?php echo esc_html( cdc_mod( "{$prefijo}_sub", '' ) ); ?></p>
					<div class="chips">
						<?php foreach ( $chips as $chip ) : ?>
							<span><?php echo esc_html( $chip ); ?></span>
						<?php endforeach; ?>
					</div>
					<a class="open" href="<?php echo esc_url( cdc_mod( "{$prefijo}_url_prototipo", '#' ) ); ?>">Abrir prototipo web <?php echo cdc_icon( 'north_east' ); ?></a>
				</div>
				<div class="ledger">
					<span class="k">versión</span><span><?php echo esc_html( cdc_mod( "{$prefijo}_version", '' ) ); ?></span>
					<span class="k">plataforma</span><span><?php echo esc_html( cdc_mod( "{$prefijo}_plataforma", '' ) ); ?></span>
					<span class="k">privacidad</span><span>coordenadas precisas locales</span>
					<span class="k">color</span><span><?php echo esc_html( cdc_mod( "{$prefijo}_color", '' ) ); ?></span>
				</div>
			</div>
			<?php endfor; ?>

		</div>
	</div>
</section>
