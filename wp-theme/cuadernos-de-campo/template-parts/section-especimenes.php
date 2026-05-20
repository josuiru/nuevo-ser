<?php
/**
 * Sección Especímenes — grid lift-the-flap con los 6 ejemplos.
 *
 * Lee desde el CPT `cdc_especimen`. Si no hay ninguno publicado,
 * la sección queda vacía pero la SVG decorativa de hojas y sticky note
 * se mantienen para que el operador entienda dónde van.
 *
 * @package cuadernos-de-campo
 */

$especimenes = cdc_listar_cpt( 'cdc_especimen', 6 );
?>
<section class="section" data-page="03 · láminas pegadas" style="position: relative;">
	<div class="wrap" style="position: relative;">

		<svg class="pressed leaf-1" viewBox="0 0 120 200" aria-hidden="true">
			<path d="M60 10 C 90 50, 105 110, 60 190 C 15 110, 30 50, 60 10 Z" fill="#8AA66B" opacity="0.55"/>
			<path d="M60 14 L60 186" stroke="#5e7d3a" stroke-width="1.4" fill="none" opacity="0.55"/>
			<path d="M60 50 Q 38 55 30 80 M60 80 Q 38 88 32 110 M60 110 Q 40 118 36 138 M60 50 Q 82 55 90 80 M60 80 Q 82 88 88 110 M60 110 Q 80 118 84 138" stroke="#5e7d3a" stroke-width="0.9" fill="none" opacity="0.5"/>
		</svg>
		<svg class="pressed leaf-2" viewBox="0 0 120 200" aria-hidden="true">
			<path d="M60 10 C 92 60, 100 130, 60 190 C 20 130, 28 60, 60 10 Z" fill="#C99A3B" opacity="0.42"/>
			<path d="M60 14 L60 186" stroke="#7e5c20" stroke-width="1.2" fill="none" opacity="0.55"/>
		</svg>

		<div class="sticky" style="top: 86px; right: -8px; --rot: 5deg;">
			toca para<br>levantar la lámina ↓
		</div>

		<div class="annot-arrow" style="top: 270px; left: -30px; transform: rotate(-6deg);">
			<span style="display: block; margin-left: 10px;">favorita</span>
			<svg width="120" height="80" viewBox="0 0 120 80" aria-hidden="true">
				<path d="M10 14 C 40 30, 70 30, 100 60" stroke="#B05E3B" stroke-width="2" fill="none" stroke-linecap="round"/>
				<path d="M92 50 L 104 62 L 88 62" stroke="#B05E3B" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
			</svg>
		</div>

		<div class="eyebrow" data-reveal>Lo que reposa en sus páginas</div>
		<h2 class="section-title" data-reveal>Especímenes <em>de muestra</em>.</h2>
		<p class="section-lead" data-reveal>Una selección de lo que registran las apps: piezas reales del catálogo, anotadas como en cuaderno. <b style="font-family: var(--tipo-manuscrita); color: var(--terracota); font-weight:600; font-size: 17px;">— levanta cada lámina para leer la ficha</b></p>

		<div class="specimen-grid">

			<?php
			$delay = 0;
			foreach ( $especimenes as $sp ) :
				$chip_color = (string) get_post_meta( $sp->ID, 'cdc_chip_color', true );
				$chip_libre = (string) get_post_meta( $sp->ID, 'cdc_chip_color_libre', true );
				$chip_style = '';
				if ( 'libre' === $chip_color && '' !== $chip_libre ) {
					$chip_style = sprintf( 'background: %s;', esc_attr( $chip_libre ) );
				} elseif ( '' !== $chip_color && 'libre' !== $chip_color ) {
					$chip_style = sprintf( 'background: var(--%s);', esc_attr( $chip_color ) );
				}
				$chip_label   = (string) get_post_meta( $sp->ID, 'cdc_chip_label', true );
				$codigo_ref   = (string) get_post_meta( $sp->ID, 'cdc_codigo_ref', true );
				$localidad    = (string) get_post_meta( $sp->ID, 'cdc_localidad', true );
				$grupo        = (string) get_post_meta( $sp->ID, 'cdc_grupo', true );
				$distintivos  = preg_split( "/\r?\n/", (string) get_post_meta( $sp->ID, 'cdc_distintivos', true ) );
				$distintivos  = array_filter( array_map( 'trim', (array) $distintivos ) );
				$donde        = (string) get_post_meta( $sp->ID, 'cdc_donde', true );
				$lat          = (string) get_post_meta( $sp->ID, 'cdc_coord_lat', true );
				$lng          = (string) get_post_meta( $sp->ID, 'cdc_coord_lng', true );
				$clase_visual = (string) get_post_meta( $sp->ID, 'cdc_clase_visual', true );
				// Prioridad de la foto: 1) foto destacada del post 2) Wikipedia.
				// Para Wikipedia, busca el meta `cdc_wiki_titulo` (override
				// manual desde wp-admin) y si no, usa el post_title.
				$tiene_foto = has_post_thumbnail( $sp->ID );
				$foto_url   = '';
				if ( $tiene_foto ) {
					$foto_url = get_the_post_thumbnail_url( $sp->ID, 'large' );
				} elseif ( function_exists( 'cdc_wikipedia_thumb' ) ) {
					$titulo_wiki = (string) get_post_meta( $sp->ID, 'cdc_wiki_titulo', true );
					if ( '' === $titulo_wiki ) {
						$titulo_wiki = $sp->post_title;
					}
					$foto_url = cdc_wikipedia_thumb( $titulo_wiki );
				}
				$photo_style = $foto_url
					? sprintf( 'background: url(%s) center/cover no-repeat;', esc_url( $foto_url ) )
					: '';
				$delay_style  = $delay === 0 ? '' : 'style="--d:.' . sprintf( '%02d', $delay ) . 's"';
				$delay += 8;
			?>
			<div class="flap-cell" data-reveal <?php echo $delay_style; // phpcs:ignore ?>>
				<div class="flap-back">
					<div class="bk-head">
						<div class="bk-name"><?php echo esc_html( $sp->post_title ); ?></div>
						<div class="bk-grp"><?php echo esc_html( $grupo ); ?></div>
					</div>
					<?php if ( ! empty( $distintivos ) ) : ?>
					<div class="bk-meta"><b>Distintivos</b><ul>
						<?php foreach ( $distintivos as $d ) : ?>
							<li><?php echo esc_html( $d ); ?></li>
						<?php endforeach; ?>
					</ul></div>
					<?php endif; ?>
					<?php if ( '' !== $donde ) : ?>
						<div class="bk-where"><?php echo esc_html( $donde ); ?></div>
					<?php endif; ?>
					<?php if ( '' !== $codigo_ref ) : ?>
						<div class="bk-coord"><?php echo esc_html( $codigo_ref ); ?>
							<?php if ( '' !== $lat && '' !== $lng ) : ?>
								· <?php echo esc_html( $lat ); ?>° N · <?php echo esc_html( $lng ); ?>° W
							<?php endif; ?>
						</div>
					<?php endif; ?>
					<?php if ( ! $tiene_foto && '' !== $foto_url ) :
						$titulo_wiki = (string) get_post_meta( $sp->ID, 'cdc_wiki_titulo', true );
						if ( '' === $titulo_wiki ) {
							$titulo_wiki = $sp->post_title;
						}
					?>
						<div class="bk-credito">
							Foto: <a href="<?php echo esc_url( 'https://es.wikipedia.org/wiki/' . rawurlencode( $titulo_wiki ) ); ?>" target="_blank" rel="noopener">Wikipedia</a>
						</div>
					<?php endif; ?>
				</div>
				<div class="specimen <?php echo esc_attr( $clase_visual ); ?>">
					<div class="tape t1"></div><div class="tape t2"></div><div class="tape t3"></div>
					<div class="photo-wrap"><span class="pcc-bl"></span><span class="pcc-br"></span>
					<div class="photo" style="<?php echo esc_attr( $photo_style ); ?>"><span class="corner"><?php echo esc_html( $codigo_ref . ( $localidad ? ' · ' . $localidad : '' ) ); ?></span></div></div>
					<div class="label"><?php echo esc_html( $sp->post_title ); ?></div>
					<div class="meta">
						<?php if ( '' !== $chip_label ) : ?>
							<span class="chip" style="<?php echo esc_attr( $chip_style ); ?>"><?php echo esc_html( $chip_label ); ?></span>
						<?php endif; ?>
						<?php if ( '' !== $lat && '' !== $lng ) : ?>
							<span><?php echo esc_html( $lat ); ?>° · <?php echo esc_html( $lng ); ?>°</span>
						<?php endif; ?>
					</div>
					<div class="lift-hint"><?php echo cdc_icon( 'arrow_upward' ); ?>levantar</div>
				</div>
			</div>
			<?php endforeach; ?>

		</div>
	</div>
</section>
