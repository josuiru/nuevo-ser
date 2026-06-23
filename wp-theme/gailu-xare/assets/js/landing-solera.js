/* landing-solera.js — interacciones de la landing del ecosistema Solera.
 *
 * Sólo cambio de tabs en la sección "detalle por app". Cada tarjeta
 * de la rejilla de apps puede llevar `data-app="<id>"` que activa la
 * pestaña correspondiente al hacer clic (y deja al href #detalle
 * hacer el scroll).
 */

(function () {
	const host = document.getElementById('detalle-host');
	if (!host) return;

	const tabs = host.querySelectorAll('.detalle-tab');
	const panels = host.querySelectorAll('.detalle-panel');

	function activar(idTab) {
		tabs.forEach((tab) => {
			tab.setAttribute('aria-selected', tab.dataset.tab === idTab ? 'true' : 'false');
		});
		panels.forEach((panel) => {
			panel.hidden = panel.dataset.panel !== idTab;
		});
	}

	tabs.forEach((tab) => {
		tab.addEventListener('click', () => activar(tab.dataset.tab));
		tab.addEventListener('keydown', (evento) => {
			if (evento.key !== 'ArrowLeft' && evento.key !== 'ArrowRight') return;
			evento.preventDefault();
			const todas = Array.from(tabs);
			const indiceActual = todas.indexOf(tab);
			const siguiente = evento.key === 'ArrowRight'
				? (indiceActual + 1) % todas.length
				: (indiceActual - 1 + todas.length) % todas.length;
			todas[siguiente].focus();
			activar(todas[siguiente].dataset.tab);
		});
	});

	// Saltar a tab desde el grid de apps: el href #detalle hace el
	// scroll, nosotros sólo programamos la pestaña.
	document.querySelectorAll('[data-app]').forEach((tarjeta) => {
		tarjeta.addEventListener('click', () => {
			const idDestino = tarjeta.dataset.app;
			if (!idDestino) return;
			setTimeout(() => activar(idDestino), 50);
		});
	});
})();
