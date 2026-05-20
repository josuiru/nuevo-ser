/* Gailu Xare — sutil scroll-reveal. Sin trabajo pesado en JS. */

(function () {
	const io = new IntersectionObserver((entries) => {
		entries.forEach(e => {
			if (e.isIntersecting) {
				e.target.classList.add('in');
				io.unobserve(e.target);
			}
		});
	}, { threshold: 0.1 });
	document.querySelectorAll('.gxare-proyecto, .gxare-descarga').forEach(el => io.observe(el));

	// Offset del topbar sticky (≈76px) + algo de aire.
	const TOPBAR_OFFSET = 90;

	// Smooth scroll para los enlaces de ancla dentro de la misma página.
	document.querySelectorAll('a[href^="#"]').forEach(a => {
		a.addEventListener('click', (e) => {
			const id = a.getAttribute('href');
			if (id && id.length > 1) {
				const target = document.querySelector(id);
				if (target) {
					e.preventDefault();
					window.scrollTo({ top: target.offsetTop - TOPBAR_OFFSET, behavior: 'smooth' });
				}
			}
		});
	});

	// Ajuste al cargar la página si llegamos con hash en la URL
	// (p. ej. desde una página interior clicando "Proyectos" del
	// topbar, que navega a `/#proyectos`). El browser hace scroll
	// nativo al ancla SIN respetar scroll-padding-top en este caso,
	// dejando el target oculto bajo el topbar sticky. Lo
	// re-ajustamos en `load` para que aparezca debajo del topbar.
	function ajustarHash() {
		if (!location.hash || location.hash.length < 2) return;
		const target = document.querySelector(location.hash);
		if (!target) return;
		// Pequeño delay para que el browser termine su scroll inicial,
		// y luego sobreescribimos con offset correcto.
		requestAnimationFrame(() => {
			window.scrollTo({
				top: target.getBoundingClientRect().top + window.scrollY - TOPBAR_OFFSET,
				behavior: 'instant',
			});
		});
	}
	if (document.readyState === 'complete') ajustarHash();
	else window.addEventListener('load', ajustarHash);
	// También al cambio de hash (back/forward dentro de la home).
	window.addEventListener('hashchange', ajustarHash);
})();
