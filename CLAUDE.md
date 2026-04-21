# Uno Roto — CLAUDE.md

Cerebro persistente del proyecto. Se lee al inicio de cada sesión. Se mantiene corto. Para detalle: `docs/`.

## Qué es Uno Roto

Juego educativo de matemáticas (fracciones, decimales, proporciones) para niños 9-12 años. MVP en Era 2. Narrativa-mecánica fusionada: las matemáticas **son** el gameplay, no su excusa.

Stack objetivo (doc 03):
- **Cliente**: Flutter + Flame, offline-first, Isar local, Android APK.
- **Backend**: WordPress plugin `uno-roto-core` (independiente de Flavor Platform), MySQL, REST API, JWT propio.
- **IA tutor**: Claude API en servidor, solo en momentos concretos, caché agresivo, SafetyFilter.
- **Idiomas**: castellano, euskera, catalán desde día cero.

Licencia: código AGPL-3.0, contenido CC-BY-SA 4.0.

## Principios innegociables (doc 01)

1. **El niño es la medida.** No el mercado, no la moda, no la métrica.
2. Las matemáticas son el mundo, no un peaje.
3. La mesura es el sabor. Nada de euforia ni sonidos de castigo.
4. Open source de verdad, no de marketing.
5. Privacidad por diseño. Sin tracking, sin ads, sin monetización.

## Documentos de diseño

En `docs/`. Al empezar tarea → solo los relevantes (contexto limitado):

- `01-biblia.md` — espíritu del juego
- `02-mapa-habilidades-atomicas.md` — 66 habilidades del MVP
- `03-arquitectura-tecnica.md` — stack, esquemas, API, roadmap 11 fases
- `04-biblia-personajes.md` — voces y arcos
- `05-biblia-worldbuilding.md` — lore profundo
- `06-biblia-narrativa.md` — estructura narrativa global
- `07-guion-arco-1.md` → `10-guion-arco-4.md` — 62 escenas
- `11-guia-visual.md` — paleta, tipografía, formas
- `12-guia-sonora.md` — capas, motivos, efectos
- `13-storyboards.md` — 10 momentos clave plano a plano
- `14-prompt-maestro.md` — este prompt operativo, 11 fases de desarrollo

## Estado actual

Repo existente con estructura real:
```
uno-roto/
├── app/                   # Flutter (prototipo funcional, no vacío)
│   ├── lib/
│   │   ├── datos/         # RepositorioProgreso, CatalogoHabilidades
│   │   ├── dominio/       # Fragmentos, distritos, motor maestría, selector
│   │   ├── nucleo/        # paleta
│   │   └── vista/         # pantallas + CustomPainters
│   ├── assets/data/skills.json
│   └── test/
└── docs/                  # 14 docs canónicos
```

**Ya implementado (pre-canon)**:
- 6 distritos con posiciones, colores, saludos.
- 66 habilidades cargadas, 18 con puzzle implementado.
- Motor de maestría (5 niveles, precisión ponderada, tiempo mediano, decaimiento 21d/14d).
- Selector adaptativo con pesos por nivel + decay + distrito + anti-repetición.
- Familias de puzzle: unitario, espejo, decimal, porcentaje, impropio, proporcional, dual, operación decimal.
- Pantalla caza con spawn timer, combate enfoque sin dictado, pantalla habilidades debug.
- Persistencia shared_preferences con keys `uroto.*`.
- Ciudad con restauración progresiva según esquirlas.
- **Tipografía Cormorant Garamond** en `app/assets/fonts/` (variable + variable italic, OFL desde google/fonts). Registrada en pubspec como familia `CormorantGaramond`. Usada por `VozPersonaje.estiloTextoCuerpo()` para voces de Fragmentos nombrados — la serif que distingue visualmente a Kurz/Eco/Zafrán/Vorax del habla humana (doc 11 §5).
- **Sistema de cinemáticas v0.5** (dominio/): `VozPersonaje`, `PlanoEscena` sealed (PlanoAmbiente + PlanoDialogo + PlanoEleccion + PlanoInteractivo + PlanoCierreAmable), `OpcionEleccion` con flags, `EscenaCinematica` con flagsRequeridos + esCierreAmable. Player con reveal letra-a-letra, opciones con respuesta, widget tutorial jugable, botón de cierre "HASTA MAÑANA", callback alEstablecerFlag, fade 300ms, botón saltar. **Sustitución `{nombre}`** vía `aplicarTokens(texto, nombre)`.
- **Sistema de nombre del jugador**: `PantallaNombre` con TextField + botón continuar. Persistido como `uroto.nombre_jugador`. Token `{nombre}` en escenas se sustituye automáticamente.
- Escenas del Arco 1 implementadas y encadenadas:
  - **1.1 El tejado** (completa, incluye bloque Montaña + elección + `{nombre}, ¿verdad?`).
  - **1.2 La primera ventana** — tutorial FR.01: Sora guía a dividir un Pleno y desfragmentar las mitades con gestos reales.
  - **1.3 El callejón** — mujer desorientada, 4 opciones.
  - **1.4 Irune** — las tres reglas, dirigidas a `{nombre}`.
  - **1.5 Kurz aparece** — primer Fragmento nombrado con voz en itálica (Cormorant pendiente). Cinemática-puente: el combate real está calibrado a derrota pero aún no implementado jugable.
  - **1.6 La derrota** — cierre emocional tras el combate jugable de Kurz. Requiere `combate_kurz_1_completado`.
  - **1.7 Kai visto de lejos** — pausa en punto elevado, Sora presenta a Kai ("va dos rangos por delante"). `esCierreAmable: true`. Se dispara al siguiente login.
  - **1.9 Los Plenos** — latente en catálogo. Requiere `fr_05_competente` (flag que activará el motor de maestría cuando el niño domine FR.05). Intro de Impropios.
  Cadena: 1.1 → 1.2 → 1.3 → 1.4 → 1.5 → 1.6 (cierre) → 1.7 (cierre) → [latente: 1.9 cuando FR.05 competente].
- **Escenas pendientes** (requieren combate jugable o sistema de rangos): 1.8 (variantes entrenamiento), 1.10 (2ª derrota Kurz), 1.11 (cena silenciosa), 1.12 (Kurz vencido), 1.13 (ceremonia Aprendiz II), 1.14 (Canales desde arriba).
- **Arco 2 (doc 08) — completo end-to-end**: 16 escenas implementadas (algunas latentes por maestría FR.09/FR.16). Voces nuevas: Rexán (ámbar #E8B85C), Ari (verde), Zafrán (Dual, no habla — Sora guía en su combate). Cadena: 2.1 Bajar solo → 2.2 Rexán → 2.3 Espejo → 2.4 variantes (rotan como 1.8, 4 versiones) → 2.5 pintada → 2.6 Zafrán mencionado (FR.09 competente) → 2.7 Dual+MCM (FR.16 introducida) → 2.8 Rexán+agua → 2.9 Ari → 2.10 silbido (FR.16 competente) → 2.11 Sora baja → 2.12 noche Zafrán → **combate zafran (jugable)** → 2.13 Zafrán escapa → 2.14 después → 2.15 Rexán espera → 2.16 cierre con HASTA MAÑANA.
- **Combate Zafrán**: `DesafioKurz` refactorizado con campos `nombreFragmento`, `vozQueHabla`, `mostrarOjos`. `DesafioKurz.zafran` usa Sora como vocero (no el propio Fragmento — Zafrán no habla), sin ojos, halo rojo oxidado `PaletaNeon.rojoOxidado`. Preguntas sobre MCM(7,11)=77 + amplificación 5/7→55/77, 3/11→21/77, suma 76/77. ki=5, 10s/pregunta, calibrado a victoria narrativa (Zafrán escapa debilitado).
- **Arco 3 (doc 09) — COMPLETO**: 17 escenas de 18 implementadas (falta 3.7 variantes máquinas). Voces nuevas: Vadic (gris metal). Cadena: 3.1 Naini → 3.2 Mercado → 3.3 Kai propone → **duelo Kai jugable** (`DesafioKurz.duelKai`, halo rosa, sin ojos) → 3.5 Ari consuela → 3.6 Vadic → 3.8 segunda pintada Opaca → **3.9 Eco (escena clave, Cormorant italic, no combate)** → 3.10 Oryn → 3.11 Ari muelle → 3.12 santuario Coleccionistas → 3.13 interrogatorio Naini (primer "gracias" de un maestro) → 3.14 Kai confiesa sobre su padre → 3.15 misión conjunta con Kai → 3.16 Brina (17% trimestral) → 3.17 Montaña se nombra (Algebrista) → 3.18 Irune cierre con HASTA MAÑANA.
- **HUD** ahora soporta Arco 3: `ProgresoArco.arco3` con 18 escenas; `arcoActual` prioriza 3 > 2 > 1.
- **HUD del mapa** ahora elige el arco actual dinámicamente: `ProgresoArco.arcoActual(flagActivo)` — si hay progreso en Arco 2, muestra Arco 2; si no, Arco 1.
- **Conexión motor → flags narrativos**: `MotorMaestria.alSubirNivel` callback se invoca cuando una habilidad sube de nivel estricto. `MotorMaestria.flagDeMaestria(id, nivel)` produce flags estables tipo `fr_05_competente`. `pantalla_caza.dart` engancha el callback al repositorio. La escena 1.9 se desbloquea automáticamente cuando el niño domina FR.05.
- **Combate jugable de Kurz v0.2** (`dominio/desafio_kurz.dart` + `vista/pantalla_combate_kurz.dart`): Fragmento nombrado pintado con esfera radial violeta + ojos, valor flotante grande, frases de Kurz reactivas. Tres desafíos calibrados:
  - **kurz_1**: 3 preguntas, ki=2, 4s/pregunta. Calibrado a derrota (1.5).
  - **kurz_2**: 5 preguntas, ki=3, 6s/pregunta. Probable derrota, posible victoria (1.10).
  - **kurz_3**: 4 preguntas, ki=4, 8s/pregunta. Calibrado a victoria (1.12).
  El orquestador detecta combate pendiente vía `_combateKurzPendiente()` antes de buscar siguiente cinemática. Tras combate marca `combate_<id>_completado` + `victoria_<id>`/`derrota_<id>`.
- **Sistema de rangos** (`dominio/rango_narrativo.dart`): enum RangoNarrativo (Aprendiz I/II/III/Iniciado), cada uno con `flagAlcanzado` estable (`rango_aprendiz_ii_alcanzado`...). Persistencia en repositorio. Dos disparadores:
  - **Por esquirlas**: umbrales 0/30/100/250 — proxy. `pantalla_caza` verifica subida tras cada esquirla ganada.
  - **Narrativos**: `repositorio.forzarRangoMinimo(rango)` sube si el actual es menor y activa flag. Usado tras kurz_3 victoria → garantiza Aprendiz II → desbloquea 1.13 ceremonia.
- **HUD del mapa**: rango visible en el header del mapa, debajo de "UNO ROTO", seguido del progreso del arco ("Arco I · X/14") en tamaño pequeño y tenue.
- **ProgresoArco** (`dominio/progreso_arco.dart`): mapeo de las 14 escenas oficiales del Arco 1 a sus flags equivalentes (1.10 y 1.12 agrupan sus ramas, 1.8 agrupa variantes). `contarVistas(flagActivo)` devuelve cuántas están completas — se muestra en el HUD para que el niño vea dónde está.
- **Variantes de entrenamiento (1.8)** (`dominio/variantes_entrenamiento.dart`): 5 mini-cinemáticas recurrentes (noche despejada, niebla, lluvia ligera, pregunta sobre la Montaña con 4 opciones, buen entrenamiento). Se disparan antes de ir al mapa cuando la 1.7 está vista y el Arco 1 aún no cerró (1.14 no vista). `VariantesEntrenamiento.elegirSiguiente(Set)` devuelve la primera no usada, o null si el pool se agotó (el orquestador resetea y reelige). Persistido en repositorio como `uroto.variantes_entrenamiento_usadas`. Una variante por transición (flag `_varianteYaDisparadaEnEstaTransicion`) para no encadenar.
- Escenas adicionales del Arco 1:
  - **1.11 La cena que no se ve** (cierre amable, requiere 1.7).
  - **1.10pre Kurz vuelve** + **combate kurz_2** + **1.10derrota/1.10victoria** — bloque del 2º combate. Ambas cierres marcan `escena_1_10_resuelta` para encadenar la 1.12.
  - **1.12pre Hoy** + **combate kurz_3** + **1.12victoria/1.12derrota** — bloque del 3er combate. La victoria activa `escena_1_12_vista` que abre la 1.13.
  - **1.13 Las palabras de Irune** (sigue latente porque también requiere `rango_aprendiz_ii_alcanzado`). Termina con `PlanoCierreAmable`.
  - **1.14 Los Canales desde arriba** (latente, requiere 1.13). Cierre del Arco I con HASTA MAÑANA explícito.
- Flags narrativos persistidos como `uroto.flag.<nombre>`.
- Orquestador `main.dart` elige la siguiente escena cuyos `flagsRequeridos` estén activos.
- Widget `WidgetFragmentoTutorial` renderiza un Pleno con pulso lento (esfera radial blanco-azul), dos mitades con CustomPaint de semicírculo, dispara callback al completar la acción.

**Gap frente a doc 03 / prompt maestro**:
- Sin backend WordPress (doc 03 propone `wp-plugin/uno-roto-core`).
- Sin sync, sin auth, sin JWT.
- Sin Isar (usamos shared_preferences).
- Sin Flame (CustomPainter puro).
- Sin Riverpod.
- Sin sistema de cinemáticas (bloqueante para guiones 07-10 y storyboards 13).
- 18/66 habilidades con puzzle concreto.
- Sin tutor IA.
- Sin arte/música final (todo programático/placeholder).

**Fase actual**: ~4-6 del roadmap del doc 03/14 — primer Fragmento jugable + motor + primer distrito funcionales pero sin narrativa scriptada ni sync.

## Backlog priorizado

1. ~~**Sistema de cinemáticas/diálogos**~~ ✅ v0.1 funcional. Pendiente: PlanoEleccion (opciones con flags), carga desde JSON (ahora es Dart-native), más escenas (1.2-1.14 Arco 1).
2. **Fragmentos nombrados** (Kurz, Zafrán, Vorax, Eco) como combates especiales.
3. **Rangos** (Aprendiz I → Fraccionista Mayor) reemplazando contador crudo de esquirlas.
4. **Paleta + tipografía canónicas** doc 11 (Inter + Cormorant Garamond + Cinzel).
5. **Capa sonora** doc 12 (ambient por distrito + motivos).
6. **Pruebas de Ascenso** (Fuego, Sendero, Espejo).
7. **Backend WordPress + sync + auth** cuando el prototipo local esté estable.
8. **Migración a Flame + Isar** según se necesite, no antes.

## Comandos habituales

```bash
# Desde /home/josu/Projects/uno-roto/app/
flutter analyze
flutter test
flutter run -d linux        # desktop debug
flutter build apk --release  # APK Android

# Flutter path (no está en PATH del sistema):
export PATH="$HOME/flutter/bin:$PATH"

# Build Android requiere Java 17 (forzado en app/android/gradle.properties):
# org.gradle.java.home=/usr/lib/jvm/java-17-openjdk-amd64
```

## Decisiones técnicas tomadas

- **Flutter 3.24, Dart 3.5** sin Flame ni Riverpod (prototipo con CustomPainter + StatefulWidget). Migrar cuando haya razón real.
- **shared_preferences 2.2.2** como persistencia inicial. Migrar a Isar en fase de sync.
- **Gradle 8.5 + AGP 8.1 + Kotlin 1.9.20 + Java 17** para compilar en Ubuntu 24.
- **Nombres descriptivos en castellano** para variables/clases/archivos (regla usuario). Técnicos en original (widget, builder, etc).
- **Esquirlas como contador crudo** — temporal. Se sustituye por rangos narrativos.
- **Idiomas**: solo castellano en prototipo. eu/ca cuando haya infraestructura `intl`.

## Reglas de interacción (doc 14)

- **Commits pequeños**: <10 archivos salvo setup inicial.
- **Tests antes del código no visual**: motor adaptativo, sync, API, persistencia.
- **Documentar mientras**: actualizar CLAUDE.md al terminar tarea compleja.
- **Verificar antes de inventar**: APIs Flame/WordPress confirmadas o preguntadas.
- **Respetar tono**: si algo choca con doc 01 → señalar antes de implementar.
- **Nunca cargar los 14 docs a la vez** — solo los de la fase.

## Cosas que NO hacer

- No añadir librerías sin registrarlas en "Decisiones técnicas".
- No generar código que viole AGPL.
- No romper barrera cliente/backend (se comunican solo vía API).
- No meter claves, secrets, endpoints producción en commits.
- No hacer "mejoras" de tono sin justificación contra docs.
- No reemplazar código funcional por abstracciones sin razón.
- No usar `withValues(alpha:)` — la versión de Flutter pide `withOpacity()`.
- No crear agujeros de gamificación (puntos, premios, combos) — doc 01 principio 3.

## Incidentes conocidos (para no repetir)

- **MIUI INSTALL_FAILED_USER_RESTRICTED**: aceptar popup manualmente en Redmi Note 8.
- **shared_preferences_android jlink error**: requiere forzar Java 17 en gradle.properties.
- **Niños testers dicen "es para clase"**: el pivote fue quitar sesiones dictadas y abrir cazadero libre. No volver al modelo "ejercicio-por-ejercicio".
- **pumpAndSettle timeout en tests**: usar `pump(duration)` discretos.
