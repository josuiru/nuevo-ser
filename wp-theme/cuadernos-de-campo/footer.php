<?php
/**
 * Pie HTML del tema Cuadernos de Campo.
 *
 * @package cuadernos-de-campo
 */
?>
		</main>
	</div>

	<footer class="footer">
		<div class="footer-inner">
			<div>
				<h6>Colofón</h6>
				<p><?php echo wp_kses_post( cdc_mod( 'cdc_pie_colofon', '' ) ); ?></p>
			</div>
			<div>
				<h6>Repositorios</h6>
				<ul>
					<li><a href="https://github.com/JosuIru/cuadernos-de-campo" target="_blank" rel="noopener">cuadernos-de-campo</a></li>
					<li><a href="https://github.com/JosuIru/nuevo-ser" target="_blank" rel="noopener">nuevo-ser (plataforma)</a></li>
					<li><a href="https://github.com/JosuIru" target="_blank" rel="noopener">JosuIru en GitHub</a></li>
				</ul>
			</div>
			<div>
				<h6>Apps</h6>
				<ul>
					<li><a href="<?php echo esc_url( cdc_mod( 'cdc_descarga_fosiles_url', '#' ) ); ?>" target="_blank" rel="noopener">Fósiles · APK</a></li>
					<li><a href="<?php echo esc_url( cdc_mod( 'cdc_descarga_naturaleza_url', '#' ) ); ?>" target="_blank" rel="noopener">Naturaleza · APK</a></li>
				</ul>
			</div>
		</div>
		<div class="colofon">
			<span><?php echo esc_html( cdc_mod( 'cdc_pie_linea_carto', '' ) ); ?></span>
			<span><?php echo esc_html( cdc_mod( 'cdc_pie_linea_tipo', '' ) ); ?></span>
			<span><?php echo esc_html( cdc_mod( 'cdc_pie_linea_coord', '' ) ); ?></span>
		</div>
	</footer>

	<?php wp_footer(); ?>
</body>
</html>
