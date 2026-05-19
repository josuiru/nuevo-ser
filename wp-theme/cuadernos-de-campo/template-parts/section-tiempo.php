<?php
/**
 * Sección Línea del Tiempo — 14 bandas de periodos geológicos.
 *
 * Los textos de cada periodo se sirven al JS desde
 * `cdc_periodos_map()`, que combina los canónicos con cualquier
 * sobrescritura desde el CPT `cdc_periodo`.
 *
 * @package cuadernos-de-campo
 */

$periodos       = cdc_periodos_canonicos();
$activo_inicial = 'jurasico';
?>
<section class="section" id="tiempo" data-page="04 · línea del tiempo">
	<div class="wrap">
		<div class="eyebrow" data-reveal>Cronoestratigrafía · ICS v2023</div>
		<h2 class="section-title" data-reveal>4 567 millones de años, <em>una sola página</em>.</h2>
		<p class="section-lead" data-reveal>Cada banda es un periodo geológico de la escala internacional. Toca para ver qué se anota en él. Los colores vienen verbatim de <code style="font-family: var(--tipo-mono); color: var(--tinta-2);">datos_guia.dart</code>.</p>

		<div class="timescale" data-reveal>
			<div class="ribbon">
				<?php foreach ( $periodos as $p ) :
					$nombre_corto = $p['id'] === 'cretacico-inferior' ? 'Cret. Inf.'
						: ( $p['id'] === 'cretacico-superior' ? 'Cret. Sup.'
						: ( $p['id'] === 'paleoceno-eoceno' ? 'Pal–Eoc.'
						: ( $p['id'] === 'oligoceno-mioceno' ? 'Olig–Mio.'
						: ( strlen( $p['name'] ) > 9 ? substr( $p['name'], 0, 8 ) . '.' : $p['name'] ) ) ) );
					// Algunos periodos tienen color oscuro → texto blanco.
					$necesita_blanco = in_array( $p['id'], array( 'ordovicico', 'devonico', 'permico', 'triasico', 'jurasico' ), true );
					$text_color = $necesita_blanco ? 'color:#fff;' : '';
					$flex_style = isset( $p['flex'] ) && $p['flex'] !== 1.0 ? sprintf( ' flex: %.1f;', $p['flex'] ) : '';
					$activo = $p['id'] === $activo_inicial ? ' active' : '';
				?>
					<div class="seg<?php echo esc_attr( $activo ); ?>" data-id="<?php echo esc_attr( $p['id'] ); ?>"
						style="background: var(--era-<?php echo esc_attr( $p['id'] ); ?>);<?php echo esc_attr( $text_color . $flex_style ); ?>">
						<b><?php echo esc_html( $nombre_corto ); ?></b>
						<span class="age"<?php echo $necesita_blanco ? ' style="color:#fff"' : ''; ?>><?php echo esc_html( str_replace( ' Ma', '', $p['age'] ) ); ?></span>
					</div>
				<?php endforeach; ?>
			</div>
			<div class="timescale-axis">
				<span>4 567 Ma · origen</span>
				<span>Ma →</span>
				<span>hoy</span>
			</div>
		</div>

		<div class="timescale-detail">
			<div class="meta"><b>Jurásico</b>201 – 145 Ma</div>
			<div class="body">Hildoceras, Harpoceras, belemnites, Gryphaea. Las margas toarcienses de la Cuenca Vasco-Cantábrica son el yacimiento más prolífico de Iberia.</div>
		</div>
	</div>
</section>
