# Tema · Gailu Xare

Tema WordPress que convierte el sitio en el **portfolio público de Josu Iru / Gailu Labs** + hub de descargas. Requiere el plugin [`gailu-xare-portfolio`](../../wp-plugin/gailu-xare-portfolio/).

## Qué entrega

Una sola página (front-page) con 4 secciones lineales:

1. **Hero** — antetítulo, título grande, lead, CTAs a "Ver proyectos" y "Descargar".
2. **Proyectos** — grid responsive de tarjetas (`[gxare_proyectos]`).
3. **Descargas** — listado de APKs / ZIPs (`[gxare_descargas]`).
4. **Sobre** — texto editable explicando qué es Gailu Xare.

Topbar pegajosa con nombre del operador y menú interno. Footer en verde bosque con créditos.

## Paleta y tipografía

Hereda los tokens de [`cuadernos-de-campo`](../cuadernos-de-campo/): papel + bosque + olivo + tinta. Tipografía Inter / Fraunces / JetBrains Mono vía Google Fonts. Aspecto sobrio editorial, sin emojis ni decoración exagerada — el contenido (los proyectos) es el protagonista.

## Personalización desde wp-admin

`Apariencia → Personalizar → Gailu Xare · Portfolio`:

- **Cabecera (Hero)**: antetítulo, título, lead.
- **Sobre Gailu Xare**: título y cuerpo (admite HTML simple).
- **Sección de Descargas**: título y lead de la sección.
- **Pie**: crédito final (admite HTML).

Los proyectos y descargas se editan en sus propios menús: `Gailu · Proyectos` y `Gailu · Descargas` (los crea el plugin).

## Convivencia con otros temas / plugins

- El tema **no encola ningún CSS de Flavor** ni interfiere con flavor-platform/news-hub/landing si están instalados.
- Si el plugin `gailu-xare-portfolio` no está activo, aparece un aviso en wp-admin y los shortcodes quedan como texto literal — se ve y se entiende que falta algo.

## Instalación

1. Copiar `wp-theme/gailu-xare/` a `wp-content/themes/`.
2. Activar el plugin `gailu-xare-portfolio` primero.
3. `wp-admin → Apariencia → Temas → Activar Gailu Xare`.
4. Visitar la portada del sitio: ya hay 11 proyectos y 4 descargas sembradas.

## Estructura

```
wp-theme/gailu-xare/
├── style.css                ← cabecera obligatoria
├── functions.php            ← enqueue + customizer + soporte
├── front-page.php           ← orquesta hero + secciones
├── index.php                ← fallback (entradas / páginas)
├── header.php               ← topbar
├── footer.php               ← créditos
└── assets/
    ├── css/
    │   ├── tokens.css       ← variables (heredado de cuadernos-de-campo)
    │   └── portfolio.css    ← estilos propios del portfolio
    └── js/
        └── portfolio.js     ← scroll-reveal + smooth scroll
```

## Licencia

GPL-2.0-or-later.
