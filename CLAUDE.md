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
- **Sistema de cinemáticas v0.5** (dominio/): `VozPersonaje`, `PlanoEscena` sealed (PlanoAmbiente + PlanoDialogo + PlanoEleccion + PlanoInteractivo + PlanoCierreAmable), `OpcionEleccion` con flags, `EscenaCinematica` con flagsRequeridos + esCierreAmable. Player con reveal letra-a-letra, opciones con respuesta, widget tutorial jugable, botón de cierre "HASTA MAÑANA", callback alEstablecerFlag, fade 300ms, botón saltar. **Sustitución `{nombre}`** vía `aplicarTokens(texto, nombre)`.
- **Sistema de nombre del jugador**: `PantallaNombre` con TextField + botón continuar. Persistido como `uroto.nombre_jugador`. Token `{nombre}` en escenas se sustituye automáticamente.
- Escenas del Arco 1 implementadas y encadenadas:
  - **1.1 El tejado** (completa, incluye bloque Montaña + elección + `{nombre}, ¿verdad?`).
  - **1.2 La primera ventana** — tutorial FR.01: Sora guía a dividir un Pleno y desfragmentar las mitades con gestos reales.
  - **1.3 El callejón** — mujer desorientada, 4 opciones.
  - **1.4 Irune** — las tres reglas, dirigidas a `{nombre}`.
  - **1.5 Kurz aparece** — primer Fragmento nombrado con voz en itálica (Cormorant pendiente). Cinemática-puente: el combate real está calibrado a derrota pero aún no implementado jugable.
  - **1.6 La derrota** — cierre emocional: mano tendida, "La cuarta gané", tres opciones de respuesta, botón HASTA MAÑANA. Primer `esCierreAmable: true`.
  - **1.7 Kai visto de lejos** — pausa en punto elevado, Sora presenta a Kai ("va dos rangos por delante"). `esCierreAmable: true`. Se dispara al siguiente login.
  - **1.9 Los Plenos** — latente en catálogo. Requiere `fr_05_competente` (flag que activará el motor de maestría cuando el niño domine FR.05). Intro de Impropios.
  Cadena: 1.1 → 1.2 → 1.3 → 1.4 → 1.5 → 1.6 (cierre) → 1.7 (cierre) → [latente: 1.9 cuando FR.05 competente].
- **Escenas pendientes** (requieren combate jugable o sistema de rangos): 1.8 (variantes entrenamiento), 1.10 (2ª derrota Kurz), 1.11 (cena silenciosa), 1.12 (Kurz vencido), 1.13 (ceremonia Aprendiz II), 1.14 (Canales desde arriba).
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
