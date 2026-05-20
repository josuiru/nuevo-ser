<?php
/**
 * Pie del tema Gailu Xare.
 *
 * @package gailu-xare
 */
?>
</main>

<footer class="gxare-pie">
	<div class="gxare-pie__inner">
		<p><?php echo wp_kses_post( gxare_mod( 'gxare_pie_credito', '' ) ); ?></p>
		<p class="gxare-pie__legal">Cada proyecto tiene su propia licencia. Ver el repo enlazado.</p>
	</div>
</footer>

<?php wp_footer(); ?>
</body>
</html>
