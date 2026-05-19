<?php
/**
 * Sección Descargar — poste de señalización con APKs y prototipos.
 *
 * @package cuadernos-de-campo
 */
?>
<section class="section descargar-section" id="descargar" data-page="09 · descargas">
	<div class="wrap">
		<div class="eyebrow" data-reveal>Próximas páginas</div>
		<h2 class="section-title" data-reveal>Descarga el cuaderno y <em>sal al campo</em>.</h2>
		<p class="section-lead" data-reveal>APK directa para Android. Sin tracking, sin publicidad. El código fuente vive en GitHub bajo el operador.</p>

		<div class="signpost" data-reveal>
			<div class="signpost-ground" aria-hidden="true">
				<span class="rock r1"></span>
				<span class="rock r2"></span>
				<span class="rock r3"></span>
				<span class="grass g1"></span>
				<span class="grass g2"></span>
				<span class="grass g3"></span>
				<span class="grass g4"></span>
			</div>
			<div class="signpost-pole" aria-hidden="true">
				<span class="pole-cap"></span>
				<span class="pole-grain g1"></span>
				<span class="pole-grain g2"></span>
				<span class="pole-grain g3"></span>
			</div>

			<a class="sign sign-right s1" href="<?php echo esc_url( cdc_mod( 'cdc_descarga_fosiles_url', '#' ) ); ?>" target="_blank" rel="noopener">
				<span class="nail nail-1"></span>
				<span class="nail nail-2"></span>
				<span class="sign-meta">
					<span class="sign-tag">Tomo I · APK</span>
					<b><?php echo esc_html( cdc_mod( 'cdc_tomo1_titulo', 'Fósiles' ) ); ?></b>
					<small><?php echo esc_html( cdc_mod( 'cdc_descarga_fosiles_meta', '' ) ); ?></small>
				</span>
				<span class="sign-icon material-symbols-outlined">android</span>
			</a>

			<a class="sign sign-left s2" href="<?php echo esc_url( cdc_mod( 'cdc_descarga_naturaleza_url', '#' ) ); ?>" target="_blank" rel="noopener">
				<span class="nail nail-1"></span>
				<span class="nail nail-2"></span>
				<span class="sign-icon material-symbols-outlined">android</span>
				<span class="sign-meta">
					<span class="sign-tag">Tomo II · APK</span>
					<b><?php echo esc_html( cdc_mod( 'cdc_tomo2_titulo', 'Naturaleza' ) ); ?></b>
					<small><?php echo esc_html( cdc_mod( 'cdc_descarga_naturaleza_meta', '' ) ); ?></small>
				</span>
			</a>

			<a class="sign sign-right s3" href="<?php echo esc_url( cdc_mod( 'cdc_tomo1_url_prototipo', '#' ) ); ?>">
				<span class="nail nail-1"></span>
				<span class="nail nail-2"></span>
				<span class="sign-meta">
					<span class="sign-tag">prototipo web</span>
					<b><?php echo esc_html( cdc_mod( 'cdc_tomo1_titulo', 'Fósiles' ) ); ?> · navegador</b>
					<small>recreación interactiva</small>
				</span>
				<span class="sign-icon material-symbols-outlined">computer</span>
			</a>

			<a class="sign sign-left s4" href="<?php echo esc_url( cdc_mod( 'cdc_tomo2_url_prototipo', '#' ) ); ?>">
				<span class="nail nail-1"></span>
				<span class="nail nail-2"></span>
				<span class="sign-icon material-symbols-outlined">computer</span>
				<span class="sign-meta">
					<span class="sign-tag">prototipo web</span>
					<b><?php echo esc_html( cdc_mod( 'cdc_tomo2_titulo', 'Naturaleza' ) ); ?> · navegador</b>
					<small>recreación interactiva</small>
				</span>
			</a>

			<div class="sign-coord" aria-hidden="true">
				<small><?php echo esc_html( cdc_mod( 'cdc_descarga_coord', '' ) ); ?></small>
			</div>
		</div>

		<div class="notice">
			<?php echo esc_html( cdc_mod( 'cdc_descarga_aviso', '' ) ); ?>
		</div>
	</div>
</section>
