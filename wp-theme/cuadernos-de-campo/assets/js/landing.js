/* Cuadernos de Campo — sitio promocional · interacciones */

(function () {
  // ── Loader fade-out ──────────────────────────────────────────────
  window.addEventListener('load', () => {
    requestAnimationFrame(() => {
      const l = document.getElementById('loader');
      if (l) setTimeout(() => l.classList.add('hidden'), 350);
    });
  });

  // ── Reveal on scroll ─────────────────────────────────────────────
  const io = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        e.target.classList.add('in');
        io.unobserve(e.target);
      }
    });
  }, { threshold: 0.12 });
  document.querySelectorAll('[data-reveal]').forEach(el => io.observe(el));

  // ── Spine bookmark · siguiendo la sección activa ─────────────────
  const sections = Array.from(document.querySelectorAll('.section'));
  const spineStrata = document.querySelector('.spine-strata');
  const bookmark = document.querySelector('.spine-bookmark');
  const pageStamp = document.querySelector('.spine-foot .pag');

  function updateBookmark() {
    if (!spineStrata || !bookmark) return;
    const total = document.documentElement.scrollHeight - window.innerHeight;
    const ratio = Math.max(0, Math.min(1, window.scrollY / total));
    const h = spineStrata.getBoundingClientRect().height;
    bookmark.style.top = (ratio * h) + 'px';

    let current = sections[0];
    for (const s of sections) {
      if (s.getBoundingClientRect().top < 120) current = s;
    }
    if (current && pageStamp) pageStamp.textContent = current.dataset.page || '—';
  }
  window.addEventListener('scroll', updateBookmark, { passive: true });
  window.addEventListener('resize', updateBookmark);
  updateBookmark();

  // ── Cursor coord readout ─────────────────────────────────────────
  const coord = document.createElement('div');
  coord.className = 'cursor-coord';
  document.body.appendChild(coord);
  let hideTimer = 0;
  window.addEventListener('mousemove', (e) => {
    const lat = (43.5 - (e.clientY / window.innerHeight) * 7.2).toFixed(3);
    const lng = (-9 + (e.clientX / window.innerWidth) * 12).toFixed(3);
    coord.textContent = `${lat}° N · ${lng}° E`;
    coord.style.left = (e.clientX + 14) + 'px';
    coord.style.top  = (e.clientY + 14) + 'px';
    coord.classList.add('shown');
    clearTimeout(hideTimer);
    hideTimer = setTimeout(() => coord.classList.remove('shown'), 1400);
  });

  // ── Time-scale interactivity ────────────────────────────────────
  // La descripción de cada periodo se inyecta desde PHP en
  // window.CDC_PERIODOS = { [id]: { name, age, text } }
  // así el operador puede editar el texto desde wp-admin.
  const segs = document.querySelectorAll('.timescale .seg');
  const detailEl = document.querySelector('.timescale-detail .body');
  const metaEl   = document.querySelector('.timescale-detail .meta');

  function selectPeriod(id) {
    segs.forEach(s => s.classList.toggle('active', s.dataset.id === id));
    const info = (window.CDC_PERIODOS || {})[id];
    if (!info) return;
    if (metaEl)   metaEl.innerHTML   = `<b>${info.name}</b>${info.age}`;
    if (detailEl) detailEl.textContent = info.text;
  }
  segs.forEach(s => s.addEventListener('click', () => selectPeriod(s.dataset.id)));
  // Periodo inicial: el primero marcado como .active en el HTML, o jurásico por defecto.
  const inicialActivo = document.querySelector('.timescale .seg.active');
  if (inicialActivo) selectPeriod(inicialActivo.dataset.id);
  else if (segs.length) selectPeriod('jurasico');

  // ── Lift-the-flap · click en la celda entera ─────────────────────
  // El listener va en `.flap-cell` (no en `.specimen`) porque al
  // lifted la lámina rota fuera del plano y los clicks siguientes
  // aterrizan sobre el flap-back, dejando la tarjeta atascada en
  // estado abierto. Con el listener en la celda, el toggle funciona
  // en cualquiera de los dos estados.
  document.querySelectorAll('.flap-cell').forEach(cell => {
    if (!cell.querySelector('.specimen')) return;
    cell.style.cursor = 'pointer';
    cell.addEventListener('click', () => cell.classList.toggle('lifted'));
  });

  // ── Hero title · ink reveal letra a letra ────────────────────────
  document.querySelectorAll('.ink-title').forEach(el => {
    const text = el.textContent;
    el.textContent = '';
    let i = 0;
    [...text].forEach(ch => {
      const span = document.createElement('span');
      if (ch === ' ') { span.className = 'ch sp'; span.innerHTML = '&nbsp;'; }
      else { span.className = 'ch'; span.textContent = ch; span.style.setProperty('--i', i++); }
      el.appendChild(span);
    });
  });

  // ── Count-up stats ───────────────────────────────────────────────
  const counters = document.querySelectorAll('.count');
  const cio = new IntersectionObserver(es => {
    es.forEach(e => {
      if (!e.isIntersecting) return;
      const el = e.target;
      const target = parseInt(el.dataset.target, 10);
      const dur = 1400;
      const start = performance.now();
      function tick(t) {
        const p = Math.min(1, (t - start) / dur);
        const ease = 1 - Math.pow(1 - p, 3);
        el.textContent = Math.round(target * ease).toLocaleString('es-ES');
        if (p < 1) requestAnimationFrame(tick);
      }
      requestAnimationFrame(tick);
      cio.unobserve(el);
    });
  }, { threshold: 0.4 });
  counters.forEach(c => cio.observe(c));

  // ── Reveal-on-scroll para bloques compuestos ─────────────────────
  document.querySelectorAll('.specimen, .timescale, .map-card, .process, .field-notes').forEach(el => {
    const o = new IntersectionObserver(es => {
      es.forEach(e => { if (e.isIntersecting) { el.classList.add('in'); o.disconnect(); } });
    }, { threshold: 0.18 });
    o.observe(el);
  });

  // ── Brújula del mapa · sigue al cursor ───────────────────────────
  const needle = document.querySelector('.compass-needle');
  if (needle) {
    const compass = needle.parentElement;
    window.addEventListener('mousemove', (e) => {
      const r = compass.getBoundingClientRect();
      const cx = r.left + r.width / 2;
      const cy = r.top + r.height / 2;
      const dx = e.clientX - cx, dy = e.clientY - cy;
      const dist = Math.hypot(dx, dy);
      if (dist < 40) return;
      const deg = Math.atan2(dy, dx) * 180 / Math.PI + 90;
      needle.style.setProperty('--cursor-rot', `${deg}deg`);
    });
  }

  // ── Ripple click en time bands ───────────────────────────────────
  document.querySelectorAll('.timescale .seg').forEach(s => {
    s.addEventListener('click', (e) => {
      const r = s.getBoundingClientRect();
      s.style.setProperty('--rx', `${e.clientX - r.left}px`);
      s.style.setProperty('--ry', `${e.clientY - r.top}px`);
      s.classList.remove('tap'); void s.offsetWidth; s.classList.add('tap');
    });
  });
})();
