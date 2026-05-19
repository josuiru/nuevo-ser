<?php
/**
 * Sección Hero — cabecera con título grande, contadores, sello.
 *
 * @package cuadernos-de-campo
 */
?>
<section class="section hero" data-page="01 · portada" style="padding: 88px 64px 120px">
	<div class="ribbon-bookmark" aria-hidden="true"></div>
	<div class="wrap">

		<header class="hero-header">
			<div class="hero-brand">
				<span class="dot"></span>
				<span class="mono"><?php echo esc_html( cdc_mod( 'cdc_hero_brand_version', '' ) ); ?></span>
			</div>
			<nav class="hero-actions">
				<a class="btn btn-ghost" href="#tomos">Las apps <?php echo cdc_icon( 'arrow_downward' ); ?></a>
				<a class="btn btn-tape" href="<?php echo esc_url( cdc_mod( 'cdc_hero_repo_url', '#' ) ); ?>" target="_blank" rel="noopener">
					<?php echo cdc_icon( 'code' ); ?>Repositorio
				</a>
				<a class="btn btn-fill" href="#descargar">
					<?php echo cdc_icon( 'android' ); ?>Descargar
				</a>
			</nav>
		</header>

		<div class="eyebrow"><?php echo esc_html( cdc_mod( 'cdc_hero_eyebrow', '' ) ); ?></div>
		<h1 class="hero-title ink-title" data-reveal style="font-size: 107px;"><?php echo esc_html( cdc_mod( 'cdc_hero_titulo', '' ) ); ?></h1>
		<p class="hero-lead" data-reveal style="--d:.15s">
			<?php echo esc_html( cdc_mod( 'cdc_hero_lead', '' ) ); ?>
		</p>

		<div class="hero-actions" data-reveal style="--d:.25s">
			<a class="btn btn-fill invite" href="#tomos"><?php echo cdc_icon( 'menu_book' ); ?>Conocer los tomos</a>
			<a class="btn btn-ghost" href="#tiempo"><?php echo cdc_icon( 'timeline' ); ?>Línea del tiempo</a>
		</div>

		<div class="hero-meta" data-reveal style="--d:.4s">
			<div><b><span class="count" data-target="<?php echo esc_attr( cdc_mod( 'cdc_hero_count_fosiles', '0' ) ); ?>">0</span></b>fósiles catalogados</div>
			<div><b><span class="count" data-target="<?php echo esc_attr( cdc_mod( 'cdc_hero_count_formaciones', '0' ) ); ?>">0</span></b>formaciones ibéricas</div>
			<div><b><span class="count" data-target="<?php echo esc_attr( cdc_mod( 'cdc_hero_count_periodos', '0' ) ); ?>">0</span></b>periodos cronoestratigráficos</div>
			<div><b>IGME</b>GEODE 50 · MAGNA 50 · Edades 1M</div>
		</div>

		<div class="stamp" aria-hidden="true">
			<div class="stamp-inner"></div>
			<div class="stamp-text">
				<svg width="150" height="150" viewBox="0 0 150 150">
					<defs>
						<path id="circle" d="M 75 75 m -58 0 a 58 58 0 1 1 116 0 a 58 58 0 1 1 -116 0"/>
					</defs>
					<text>
						<textPath href="#circle" startOffset="0"><?php echo esc_html( cdc_mod( 'cdc_hero_stamp_texto', '' ) ); ?></textPath>
					</text>
				</svg>
			</div>
			<div class="center">Vº Bº<br><span style="font-size: 11px; font-style: normal; font-family: var(--tipo-mono); letter-spacing: 0.12em;"><?php echo esc_html( cdc_mod( 'cdc_hero_stamp_iniciales', '' ) ); ?></span></div>
		</div>

		<div class="hero-figure" aria-hidden="true"></div>
	</div>
</section>
