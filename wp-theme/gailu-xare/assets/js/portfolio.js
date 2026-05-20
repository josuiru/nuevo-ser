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

	// Smooth scroll para los enlaces del menú
	document.querySelectorAll('a[href^="#"]').forEach(a => {
		a.addEventListener('click', (e) => {
			const id = a.getAttribute('href');
			if (id && id.length > 1) {
				const target = document.querySelector(id);
				if (target) {
					e.preventDefault();
					window.scrollTo({ top: target.offsetTop - 80, behavior: 'smooth' });
				}
			}
		});
	});
})();
