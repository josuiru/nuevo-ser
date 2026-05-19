# Tema WordPress · Cuadernos de Campo

Landing promocional de las apps **Fósiles** y **Naturaleza** (repo [`JosuIru/cuadernos-de-campo`](https://github.com/JosuIru/cuadernos-de-campo)). Implementa fielmente el design system [`cuadernos-de-campo-design-system`](https://api.anthropic.com/v1/design/h/t9bh2uCy-zJkV2qbFt3fjg), traducido de prototipo HTML/CSS estático a tema WP con campos editables desde `wp-admin`.

## Qué entrega el tema

Una sola página (front-page) con 9 secciones en metáfora de cuaderno:

1. **Hero** — título grande, contadores animados, sello rectangular, ammonite giratorio.
2. **Tomos** — Fósiles + Naturaleza como tarjetas con cinta y clip.
3. **Especímenes** — grid lift-the-flap con 6 fichas (foto, chip de periodo, coordenadas).
4. **Línea del tiempo** — 14 bandas cronoestratigráficas con detalle al click.
5. **Mapa** — península con pines numerados y anotaciones laterales.
6. **Proceso** — 5 pasos numerados.
7. **Características** — 6 field notes con icono Material.
8. **Códigos de campo** — los 5 códigos éticos.
9. **Descargar** — poste de señalización con APKs y prototipos.

Plus: lomo lateral con estratos coloreados (los 14 periodos), bookmark que sigue el scroll, cursor con coordenadas, brújula que apunta al cursor.

## Instalación

1. Copiar el directorio entero `wp-theme/cuadernos-de-campo/` a `wp-content/themes/` del WordPress de destino:
   ```bash
   scp -r wp-theme/cuadernos-de-campo/ usuario@servidor:/ruta/wp-content/themes/
   ```
2. En `wp-admin → Apariencia → Temas` activar **Cuadernos de Campo**.
3. Al activarse, se siembran automáticamente los 6 especímenes, 5 códigos, 4 anotaciones de mapa, 5 pasos y 6 características por defecto. El seed es **idempotente**: si lo reactivas no duplica entradas.

## Qué se edita desde wp-admin

### `Apariencia → Personalizar → Cuadernos de Campo · Landing`

Texto fijo de la página (los bloques con N elementos van en sus propios menús):

- **Cabecera (Hero)** — eyebrow, título grande, lead, contadores (fósiles/formaciones/periodos), URL repo, texto del sello.
- **Tomos** — nombre, subtítulo, chips, versión, plataforma, color, URL prototipo (para Tomo I y Tomo II).
- **Descargas (APK)** — URL y meta (versión · android · peso) para cada APK, aviso al pie.
- **Pie / Colofón** — texto del colofón y las 3 líneas finales.

### Menús laterales (Custom Post Types)

| Menú | Para qué | Cantidad sugerida |
|---|---|---|
| **Especímenes** | Cada ficha del grid "Especímenes de muestra" | 6 (3 fósiles + 3 naturaleza, queda equilibrado) |
| **Periodos geológicos** | Sobrescribir el texto que aparece al hacer click en una banda de la línea del tiempo | 0 a 14 |
| **Anotaciones del mapa** | Pin numerado + texto lateral | 4-6 |
| **Pasos del proceso** | Pasos del bloque "Cómo se anota" | 5 |
| **Características** | Field notes del bloque "Qué hay dentro" | 6 |
| **Códigos de campo** | Los 5 códigos éticos | 5 |

#### Campos por tipo

- **Especímenes**: grupo taxonómico, etiqueta+color del chip (paleta cronoestratigráfica o color libre), código de referencia (F-001, N-103…), localidad, lat/lng, distintivos (uno por línea), dónde encontrarlo, variante visual placeholder, **foto destacada del post** (sustituye al placeholder de color).
- **Periodos geológicos**: ID canónico (uno de los 14 de la ICS), edad (Ma), y como contenido del post el texto largo que aparece al seleccionar.
- **Anotaciones del mapa**: número (1-9), posición horizontal y vertical en %, color del pin (olivo/ocre/terracota), periodo/rango.
- **Pasos del proceso**: número.
- **Características**: nombre del icono Material Symbols (ej. `layers`, `verified`, `straighten`), referencia (§1, §2…).
- **Códigos**: numeral romano (i, ii, iii…).

Todos los CPTs respetan `menu_order` (campo "Atributos de página → Orden") para reordenar.

## Convivencia con el plugin Comunidad

El mismo WordPress puede albergar el plugin `nuevo-ser-core` (que sirve el backend de la comunidad de Fósiles, `/wp-json/nuevo-ser/v1/fosiles/*`). Tema y plugin no comparten dependencias, pero la idea es que **un único WP de producción** sirva tanto la landing pública (este tema) como el panel wp-admin de moderación (el plugin). Ver `wp-plugin/nuevo-ser-core/README.md` para el setup del plugin.

## Voz y guía visual

El tema sigue el manifiesto del paquete de diseño:

- **Castellano peninsular, sin emoji, sin signos de exclamación.** Tratamiento de tú. Frases completas.
- **Material Symbols** (no SVG genéricos, no emoji). Cargados vía CDN de Google Fonts.
- **Inter / Fraunces / JetBrains Mono** (vía Google Fonts). Sustituibles editando `assets/css/tokens.css`.
- **Paleta verbatim** de `apps/fosiles/lib/datos/datos_guia.dart` (14 colores ICS + bosque/olivo/papel/tinta).

## Estructura del tema

```
wp-theme/cuadernos-de-campo/
├── style.css                   ← cabecera obligatoria de WP
├── functions.php               ← bootstrap (enqueue, soporte)
├── front-page.php              ← portada (orquesta los 9 partials)
├── index.php                   ← fallback para blog/páginas
├── header.php                  ← <html>, loader, lomo
├── footer.php                  ← colofón
├── inc/
│   ├── helpers.php             ← cdc_mod(), cdc_icon(), cdc_listar_cpt(), cdc_periodos_canonicos()
│   ├── cpts.php                ← los 6 CPTs + metaboxes
│   ├── customizer.php          ← settings/controls del Customizer
│   └── seed.php                ← contenido por defecto al activar
├── template-parts/
│   ├── section-hero.php
│   ├── section-tomos.php
│   ├── section-especimenes.php
│   ├── section-tiempo.php
│   ├── section-mapa.php
│   ├── section-proceso.php
│   ├── section-caracteristicas.php
│   ├── section-codigo.php
│   └── section-descargar.php
└── assets/
    ├── css/
    │   ├── tokens.css          ← variables (colores, tipografía, espacios)
    │   └── landing.css         ← estilos completos de la landing
    ├── js/
    │   └── landing.js          ← loader, reveal, time-scale, lift-the-flap, count-up
    └── img/
        ├── fosiles-icon.png
        ├── fosiles-icon-foreground.png
        └── naturaleza-logo.png
```

## Reseteo del contenido sembrado

Si quieres regenerar los 6 especímenes / 5 códigos / etc. por defecto:

1. **Vía wp-admin**: borra los posts de cada CPT y los meta `cdc_seed_id` asociados. Luego desactiva el tema y reactívalo.
2. **Vía wp-cli**:
   ```bash
   wp post list --post_type=cdc_especimen --field=ID | xargs wp post delete --force
   # repetir para cada CPT
   wp option update cdc_seed_run 0
   wp theme activate cuadernos-de-campo
   ```

## Licencia

GPL-2.0-or-later (compatible con el repo).
