# El Cuaderno — Guía visual

> Documento de dirección de arte.
> Versión 0.1 — borrador para Fase 3.
> Para diseñadora/o de UI, ilustrador/a botánico/a y equipo de desarrollo.
> Leer junto a la biblia (doc 01), las voces (doc 04), y los flujos de usuario (doc 13).

---

## 0. La estética en una frase

**Cuaderno botánico respetable, hecho con tinta y acuarela, traducido a pantalla con honestidad.** Si el resultado no podría ser una página de cuaderno encuadernado por una naturalista paciente, está mal.

## 1. Tres referencias canónicas

Antes de cualquier decisión visual concreta, mirar estas referencias:

**Beatrix Potter, cuadernos de campo (no los cuentos infantiles).** Sus diarios de Lake District con observaciones y dibujos de hongos, líquenes, plantas. Textura humilde, dibujo torpe-preciso, anotaciones manuscritas con sequedad inglesa. Tono respetuoso del lector.

**Concha Pasamar (especialmente sus libros sobre fauna ibérica).** Acuarela botánica contemporánea, paleta apagada con saturaciones bajas, fondos crema, dibujo fiel sin idealización. Una de las mejores referencias vivas en castellano.

**Joaquín Araújo, cuadernos de campo y obras escritas.** No por la ilustración (es escritor) sino por el **tono**. Voz seca de quien ha caminado mucho monte y no necesita adornar. La estética visual debería sentirse coherente con esa voz.

Tres referencias que **no** servir como modelo:

- Estética Pixar / Disney aplicada a naturaleza.
- Ilustración educativa con personajes antropomorfizados.
- Estilo plano vectorial saturado de apps "modernas" (la app de naturaleza X con ilustraciones brillantes).

## 2. Paleta cromática

### 2.1 Base — modo claro

Paleta deliberadamente apagada, sin saturaciones altas, con valores que se sienten naturales en papel.

| Token CSS | Hex | Uso |
|---|---|---|
| `--color-paper-base` | `#F5F1E8` | Fondo principal (crema cálido) |
| `--color-paper-warm` | `#EDE5D0` | Fondo secundario (cuaderno gastado) |
| `--color-paper-shade` | `#E0D6BC` | Bordes sutiles, separadores |
| `--color-ink-deep` | `#2A2823` | Texto principal (gris muy oscuro, NO negro) |
| `--color-ink-mid` | `#4A4640` | Texto secundario |
| `--color-ink-soft` | `#7A746A` | Texto terciario, metadatos |
| `--color-pencil` | `#A89F8E` | Guías, separadores ligeros |

### 2.2 Acentos — modo claro

Tres colores con función semántica. Saturación baja, bien diferenciados.

| Token | Hex | Uso |
|---|---|---|
| `--color-accent-green` | `#4A6B43` | Verde apagado de musgo. Acento principal positivo |
| `--color-accent-ochre` | `#A56B2C` | Ocre tostado. Acentos cálidos, advertencias suaves |
| `--color-accent-blue` | `#516B7A` | Azul ceniza. Datos, estado "consenso" |
| `--color-accent-rust` | `#8C4A35` | Óxido. Estado "abandonado", correcciones |

### 2.3 Confianza (estados)

Sistema de niveles de confianza visualmente codificado, suave:

| Nivel | Background | Foreground | Notas |
|---|---|---|---|
| `consenso` | `#E5EBE0` | `#2D4422` | Verde muy claro |
| `hipotesis_activa` | `#EBE3D0` | `#5A4012` | Crema más cálido |
| `no_segura` | `#E8E3DC` | `#4A4640` | Casi neutro |

Sin rojo. Sin negro puro. Sin colores estridentes para "incorrecto" (que tampoco existe en el juego).

### 2.4 Modo oscuro

Inversión cuidadosa, no un simple swap.

| Token | Hex |
|---|---|
| `--color-paper-base` | `#1F1D1A` |
| `--color-paper-warm` | `#2A2724` |
| `--color-paper-shade` | `#3A3631` |
| `--color-ink-deep` | `#E8E2D0` |
| `--color-ink-mid` | `#C8C0AC` |
| `--color-ink-soft` | `#8E8676` |
| `--color-pencil` | `#5A5448` |

Los acentos del modo oscuro son los mismos del modo claro pero con luminosidad ajustada para WCAG AA.

### 2.5 Lo que NO entra en la paleta

- Negro puro (`#000`).
- Blanco puro (`#FFF`).
- Cualquier color con saturación >70%.
- Gradientes (excepto el sutilísimo del fondo de papel para textura).
- Neón, fluor, fucsia, turquesa eléctrico, lo que sea.
- Colores de "marca" tipo azul corporativo.

## 3. Tipografía

### 3.1 Jerarquía de fuentes

**Serif** — para textos del Cuaderno y voz del niño. Lo que se siente "escrito".

Propuesta principal: **Lora** (Google Fonts, libre, peso completo). Alternativas: Source Serif Pro, Crimson Text, Fraunces (más expresivo, valorar).

Uso:
- Pregunta del Misterio.
- Texto libre del niño en sus observaciones.
- Citas en mosaicos.
- Saludos personales.
- Microcopia con voz emocional baja.

**Sans-serif** — para datos del sistema. Lo que se siente "legible y discreto".

Propuesta principal: **Inter** (Google Fonts, libre). Alternativas: IBM Plex Sans, Source Sans Pro.

Uso:
- Fechas, horas, ubicaciones.
- Etiquetas de campos de formulario.
- Botones.
- Navegación.
- Estado de niveles de confianza.
- Datos numéricos.

### 3.2 Escala tipográfica

| Token | Tamaño | Uso |
|---|---|---|
| `--text-xs` | 11px | Metadatos secundarios (timestamp, "última visita: hace 4 días") |
| `--text-sm` | 12px | Etiquetas, captions |
| `--text-base` | 13px | Texto de cuerpo en datos sans-serif |
| `--text-md` | 14px | Texto de cuerpo en serif (cuaderno) |
| `--text-lg` | 16px | Texto destacado, citas en cuaderno |
| `--text-xl` | 17px | Cabeceras de sección |
| `--text-2xl` | 22px | Cabeceras de pantalla principal |
| `--text-3xl` | 28px | Solo apertura del juego |

Sin tamaños mayores. Si necesitas algo más grande para énfasis, replantea: probablemente necesitas más espacio en blanco, no más tamaño.

### 3.3 Pesos

Solo dos pesos en cada familia:
- **Regular (400)** — el peso por defecto, casi todo.
- **Medium (500)** — para énfasis muy puntual y para botones.

**Sin negrita (700, 800).** Sin extralight. La sobriedad tipográfica es deliberada.

### 3.4 Interlineado

| Contexto | Line-height |
|---|---|
| Texto serif del cuaderno | 1.6 |
| Sans-serif datos | 1.4 |
| Cabeceras | 1.2 |
| Citas y observaciones | 1.7 |

El cuaderno respira. El espacio en blanco es parte del contenido.

### 3.5 Anchos de línea

Texto de lectura: max 65 caracteres por línea. Texto de cuaderno: max 55. Datos: max 80.

Si en mobile la pantalla obliga a más, padding lateral generoso (mínimo 18px).

## 4. Iconografía

### 4.1 Filosofía

Iconos **lineales**, finos, dibujados como si los hiciera la pluma de un cuaderno. Ningún icono filled. Ningún icono con relleno de color. Ningún icono "moderno" tipo Apple SF Symbols.

Stroke: 1.5px en tamaño base 24px, escalado proporcional.

### 4.2 Set inicial

10-15 iconos. Lista mínima:

- **Cuaderno** (libro abierto simple).
- **Lápiz** (línea diagonal).
- **Cámara** (rectángulo con círculo interior simple).
- **Mapa** (rectángulo con curva sinuosa).
- **Sit spot** (punto con tres puntos concéntricos sutiles).
- **Misterio** (signo de interrogación con la barra superior modificada).
- **Tutor** (silueta de cabeza muy estilizada).
- **Ajustes** (engranaje simple, no detallado).
- **Estación** (cuatro pétalos abstractos).
- **Cuidador** (silueta dual).
- **Aula** (varias siluetas).
- **Reloj** (círculo con dos manecillas).
- **Más** (signo +).
- **Cerrar** (X).
- **Volver** (flecha pequeña).

Cada icono se dibuja a mano por la ilustradora botánica (no se compra de Material Icons o equivalentes — esos son demasiado modernos).

### 4.3 Lo que NO se usa

- Emojis del sistema operativo (😀 🌳 🐦).
- Iconos con color.
- Iconos animados.
- Iconos rellenos.
- Iconos comerciales tipo Apple Human Interface Guidelines.
- Animales antropomorfizados.

## 5. Ilustración botánica

### 5.1 Estilo

Acuarela y tinta. Trazos a pluma para contornos, manchas de color suaves para volumen y textura. Fidelidad anatómica: una limonera dibujada para la app debe ser una limonera reconocible para un entomólogo. **No estilización**, no "estilo cómic", no caricaturización.

Detalle máximo en lo que la clave dicotómica pide identificar (antenas, patas, alas), detalle moderado en el resto.

### 5.2 Lista de ilustraciones del MVP

Aproximada, depende del catálogo final:

- **Aves** (~20 especies del catálogo ibérico común): paloma, gorrión, vencejo, mirlo, estornino, urraca, petirrojo, herrerillo, carbonero, golondrina, cigüeña, pinzón, jilguero, verderón, mosquitero, capirote, lavandera, ánade real, gallineta, tórtola.
- **Mariposas** (~15): blanca de la col, limonera, vanesa atalanta, vanesa de los cardos, pavo real, almirante rojo, macaón, podalirio, cleopatra, sátiro, niñas comunes, azuleja…
- **Árboles** (~12 con cada uno hoja, silueta y corteza): plátano, encina, roble, haya, pino piñonero, pino silvestre, álamo, sauce, almendro, olivo, nogal, higuera.
- **Flores** (~15): malva, llantén, manzanilla, amapola, diente de león, silene, jaramago, vinca, alhelí, hierba doncella, violeta, primavera, narciso, brezo, tomillo.
- **Otros**: 3-4 hongos comunes (con seguridad: ninguno tóxico identificable solo por la app), 2-3 líquenes, 2-3 anfibios, 2-3 reptiles peninsulares no peligrosos.

**Total: ~75-80 ilustraciones de calidad.** Trabajo de ~6-9 meses para un/a ilustrador/a botánico/a profesional. Coste real: 10-25k€ según ilustrador/a.

### 5.3 Encargo a humanos

**Sin IA generativa para ilustración.** Stable Diffusion / Midjourney / DALL-E producen imágenes biológicamente incorrectas: alas de mariposa con venación inventada, patas con número erróneo, especies inexistentes con aspecto de existentes. En un cuaderno botánico esto es inaceptable. Se contrata humano.

Posibles ilustradoras candidatas (para empezar conversaciones, no compromiso):

- Concha Pasamar (Ediciones Modernas, Faktoria K).
- Iban Barrenetxea (también narrativo, pero estilo coherente).
- Daniel Montero Galán.
- Estudios pequeños especializados en ilustración naturalista.
- Aula con SEO/BirdLife o similar puede dar referencias.

### 5.4 Atribución

Cada ilustración mantiene atribución del autor humano. En la pantalla de la especie aparece, en sans-serif pequeño:

> *Ilustración: [nombre]. CC BY-SA 4.0.*

## 6. Layout y composición

### 6.1 Sistema de espaciado

Múltiplos de 4px:

| Token | px |
|---|---|
| `--space-1` | 4 |
| `--space-2` | 8 |
| `--space-3` | 12 |
| `--space-4` | 16 |
| `--space-5` | 20 |
| `--space-6` | 24 |
| `--space-7` | 32 |
| `--space-8` | 40 |
| `--space-10` | 60 |

### 6.2 Padding de pantallas principales

Mínimo 18px lateral en móvil. 24px vertical entre secciones.

### 6.3 Bordes y separadores

Bordes muy sutiles: 0.5px en color `--color-paper-shade`. Si una tarjeta necesita borde, ese.

Sin sombras (`box-shadow`) salvo casos muy puntuales con elevación 1 mínima — sombra sutil 0 1px 2px rgba(0,0,0,0.04).

Sin radius excesivos: 8px máximo en tarjetas, 16px en bottom sheets.

### 6.4 Cabeceras

Sin barra de cabecera siempre visible con logo y notificaciones (estilo apps modernas). En su lugar:

- Pantalla principal del cuaderno: cabecera mínima con nombre del juego en serif y la estación + semana.
- Otras pantallas: solo título de sección y botón de volver.

### 6.5 Bottom navigation

4 pestañas. Iconos lineales, etiqueta de texto siempre visible (no solo icono):

`Cuaderno` · `Mapa` · `Misterios` · `Tutor`

Pestaña activa: texto en `--color-ink-deep`, icono ligeramente más grueso. Inactivas: `--color-ink-soft`.

### 6.6 Floating Action Button

Para registrar observación rápida. Único FAB de la app. Forma circular, fondo `--color-paper-warm`, icono de lápiz en `--color-ink-deep`. Sin sombra grande — solo elevación mínima.

## 7. Fotografía y captura del niño

### 7.1 Tratamiento

Fotos del niño no se procesan. Se guardan como están. **No se aplica filtro estético** (sepia, vintage, etc.). Una foto borrosa de una mariposa en una flor es una foto borrosa — no se mejora artificialmente.

Compresión técnica para almacenamiento: JPEG calidad 75, max 1024px lado mayor. Esto es decisión técnica, no estética.

### 7.2 Marco

En la vista del cuaderno, las fotos del niño aparecen con un margen blanco fino simulando un montaje de cuaderno. Cuatro pixeles de espacio interno blanco crema, después borde sutil. Sin marco de sombra. Sin marca de tiempo sobreimpresa en la foto.

### 7.3 Dibujo

El canvas táctil de dibujo ofrece:
- Lápiz (negro tinta `--color-ink-deep`).
- Goma.
- Color rojo (rust `--color-accent-rust`) para marcar correcciones o rasgos importantes.

Dos colores. Punto. La sencillez es deliberada — no hay paletas, ni grosores, ni capas. Un cuaderno no las tiene.

## 8. Accesibilidad

### 8.1 WCAG 2.1 AA

Todas las decisiones cromáticas se verifican contra contraste:
- Texto principal sobre fondo: mínimo 7:1 (AAA).
- Texto secundario: mínimo 4.5:1 (AA).
- Elementos interactivos: mínimo 3:1 contra background.

Esto se verifica con herramientas tipo WebAIM Contrast Checker en cada combinación de paleta.

### 8.2 Tamaño mínimo

Targets de toque: mínimo 44x44 px (estándar WCAG mobile). Texto mínimo legible: 12px sans-serif, 14px serif.

El usuario puede aumentar tamaño tipográfico desde el sistema operativo y la app respeta el escalado nativo.

### 8.3 Lectores de pantalla

Todas las pantallas con descripción semántica clara. Botones con `accessibilityLabel`. Imágenes ilustrativas con alt text natural (*"Ilustración de una golondrina en vuelo"*, no *"Imagen 1"*).

### 8.4 Daltonismo

La paleta no comunica nada solo por color. Los niveles de confianza tienen también texto distinto, no solo colores distintos. Esto es no negociable.

### 8.5 Modo lectura facilitada

Para niños con dificultades de lectura, **modo de lectura facilitada** opcional:
- Sans-serif en todo (no mezcla serif/sans).
- Tamaño base aumentado.
- Más espacio entre líneas.
- Frases más cortas en la microcopia (versión alternativa de strings preparada).

Activable en Ajustes. No es default.

## 9. Animación

### 9.1 Filosofía

**Mínima**. Casi inexistente. Si una transición no aporta legibilidad o continuidad espacial, se elimina.

### 9.2 Lo que sí

- Cross-fade entre pantallas: 200ms, easing estándar.
- Bottom sheet apareciendo desde abajo: 250ms, ease-out.
- Botón con feedback haptico al toque: estado activo durante 100ms con ligera reducción de opacidad (0.7).

### 9.3 Lo que no

- Bounces, springs, parallax.
- Animaciones de aparición de elementos (fade-in en cascada, slide-in).
- Loaders animados llamativos (spinners, skeleton screens con shimmer).
- Animaciones de celebración (confeti, partículas).
- Animaciones del FAB (rotación, hover effects).

### 9.4 Ausencia como decisión

Si Lucía abre la app con prisa porque tiene que ir al cole, la app **no se interpone** con ninguna animación. Carga, está. Si Lucía cierra, se cierra. Sin "vaya, te vas tan pronto".

## 10. Decisiones de diseño difíciles

### 10.1 Tarjetas vs lista

El cuaderno principal es una columna vertical de **bloques con borde sutil**. No son tarjetas con elevación grande (no es Material Design). No son items de lista plana (no es iOS Settings). Son bloques de cuaderno: con un borde de hilo, un padding generoso, contenido centrado en su lectura.

### 10.2 Barras de progreso

**No las hay**. Salvo en un caso técnico: subida de foto a R2 (cuando la red es lenta), aparece barra de progreso sobria sin animación, solo línea que crece. Sin porcentaje. Sin emoji. Texto: *"subiendo..."*.

### 10.3 Tooltips

**No los hay**. Si algo necesita explicación, se dice en el lugar correspondiente con texto. Si la pantalla está demasiado densa para texto, la pantalla está mal diseñada.

Excepción acotada: tooltip al mantener pulsado un chip de confianza, durante 800ms (ver flujo doc 13 §3.2). Esto es affordance pedagógica, no decoración.

### 10.4 Skeleton screens

**No se usan**. Mientras carga, el espacio queda vacío con texto sobrio "buscando..." en gris. La aparición de contenido es directa, no progresiva por bloques.

### 10.5 Onboarding visual

**No hay** ilustraciones de bienvenida con personajes ni vectores grandes. La pantalla de bienvenida (doc 13 §1.1) es texto centrado y un botón. La sobriedad es parte del mensaje: esto no es Duolingo.

## 11. Lo que NO entra, recopilatorio

- Mascotas, avatares, personajes ficticios.
- Animales antropomorfizados.
- Sonrisas, ojos grandes, caritas.
- Gradientes saturados.
- Glassmorphism, neumorfismo, brutalism, ningún estilo "trendy".
- Iconos rellenos, iconos con color, emojis del sistema.
- Animaciones de logro / fanfarria.
- Confeti, partículas, brillos, sparkles.
- Tipografías display llamativas.
- Cabeceras con logo grande.
- Splash screen con marca.
- Skeleton screens, shimmers.
- Tooltips automáticos.
- Toasts emergentes con sonido.
- Push notifications visuales.
- Stickers, emojis personalizables.

---

## Apéndice — Checklist de revisión visual

Antes de aceptar cualquier pantalla nueva:

```
[ ] ¿Funciona en modo claro Y oscuro?
[ ] ¿Cumple WCAG 2.1 AA en contrastes?
[ ] ¿Funciona en mobile estrecho (<360px) sin truncar texto crítico?
[ ] ¿Funciona con tamaño tipográfico aumentado del sistema?
[ ] ¿Tiene targets de toque ≥44px?
[ ] ¿Es legible sin tooltips?
[ ] ¿Comunica estado sin depender solo del color?
[ ] ¿La microcopia respeta el doc 04?
[ ] ¿Las animaciones son las mínimas?
[ ] ¿La estética es coherente con cuaderno botánico clásico?
[ ] ¿No hay nada que pediría una mascota?
[ ] ¿No hay nada que un equipo de Material Design propondría?
```

Si pasa todo: la pantalla está lista para revisión final.

---

*Fin de Guía Visual v0.1.*
