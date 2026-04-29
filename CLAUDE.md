# Monorepo Colección Nuevo Ser Kids — CLAUDE.md

Cerebro persistente del monorepo. Se lee al inicio de cada sesión. Detalle por juego en `apps/<juego>/CLAUDE.md`.

## Encuadre del programa

Este monorepo aloja los juegos digitales pedagógicos de **Colección Nuevo Ser Kids**, la línea infantil/escolar (juegos para 9-14 años) de la **Colección Nuevo Ser**. La Colección madre es un proyecto editorial y de pensamiento más amplio (editorial de libros, plugins para colectivos y comunidades, herramientas para favorecer alternativas y pensamiento crítico y constructivo): https://coleccion-nuevo-ser.com/.

Cuando los docs de este repo dicen "la Colección" sin más, se refieren a Kids.

## Estructura

```
.
├── apps/
│   ├── uno-roto/         juego de matemáticas 9-12 (en producción, fase ~8-9 MVP)
│   └── las-versiones/    juego de pensamiento histórico 10-14 (esqueleto, Fase 10)
│
├── packages/
│   ├── nuevo_ser_core/        plataforma compartida (motor maestría, sync, audio, cinemáticas)
│   ├── nuevo_ser_companion/   acompañamiento (Cuaderno, Mosaicos, dashboards) — v1.5
│   └── nuevo_ser_tutor/       cliente Tutor IA con caché y filtros
│
├── content/              JSON exportables de habilidades/brechas por juego
├── tests/                suites cross-package (paridad Dart/PHP)
├── wp-plugin/            plugin WordPress backend (rename a nuevo-ser-core en C2)
├── scripts/              scripts dev/sonido
├── melos.yaml            gestión del monorepo
└── pubspec.yaml          workspace raíz (instala Melos)
```

## Estado del refactor `nuevo-ser-core`

Estamos en la rama `refactor/nuevo-ser-core`. Plan de 9 chunks (ver `~/.claude/plans/vast-soaring-glacier.md`):

- **C1** — esqueleto monorepo Melos + `git mv` de `app/` a `apps/uno-roto/`. Cero cambios de lógica. ← actual.
- **C2** — rename plugin WP `uno-roto-core` → `nuevo-ser-core` + namespace PHP.
- **C3** — endpoints duales `/uno-roto/v1/*` ↔ `/nuevo-ser/v1/*`.
- **C4** — migración M001: prefijo `wp_uroto_*` → `wp_ns_*` + columna `game_id`.
- **C5** — extracción real a `packages/nuevo_ser_core/`.
- **C6** — motor adaptativo con `MasteryProfile` + stubs P2-P4.
- **C7** — tablas acompañamiento + endpoints 501.
- **C8** — tests regresión + paridad Dart/PHP + tag `v0.2.0-platform`.

## Decisiones cerradas

- **Persistencia local**: shared_preferences con prefijo `uroto.*` y `uroto.perfil.<id>.*` para Uno Roto. Juegos nuevos: `nuevoser.<juego>.*`. Migración a Isar **diferida a v1.5**.
- **Tablas BD**: solo prefijo `wp_uroto_*` → `wp_ns_*` y añadir `game_id`. Renombrado semántico (`progreso` → `mastery_records`) **diferido a v1.5**.
- **Endpoints**: `/uno-roto/v1/*` se mantiene como alias deprecado hasta v1.5; `/nuevo-ser/v1/*` es canónico.
- **Workspace tool**: Melos ^6.0.0 (Dart 3.5).

## Comandos habituales

```bash
# Desde la raíz del monorepo:
dart pub get                                  # instala Melos local
dart pub global activate melos                # alternativa: instala Melos global
melos bootstrap                               # resuelve dependencias en todos los paquetes
melos run analyze                             # flutter analyze por paquete
melos run test                                # flutter test por paquete con test/

# Por paquete:
( cd apps/uno-roto && flutter run -d linux )
( cd apps/uno-roto && flutter test )
( cd apps/uno-roto && flutter build apk --debug )
```

```bash
# Flutter no está en PATH del sistema:
export PATH="$HOME/flutter/bin:$PATH"

# Build Android requiere Java 17 (forzado en apps/uno-roto/android/gradle.properties).
```

## Reglas de interacción

- **Nombres descriptivos en castellano** para variables/clases/archivos. Términos técnicos (widget, builder…) en original.
- **Commits pequeños**: <10 archivos salvo setup inicial.
- **Tests antes del código no visual**: motor, sync, API, persistencia.
- **Verificar antes de inventar**: APIs Flutter/Melos/WordPress confirmadas o preguntadas.
- **Respetar tono**: si algo choca con `coleccion-nuevo-ser/coleccion/01-manifiesto.md` → señalar antes de implementar.

## Detalle por juego

Cada app mantiene su propio cerebro persistente:

- `apps/uno-roto/CLAUDE.md` — estado actual del juego en producción (fase, mecánicas implementadas, gap frente a doc 03, backlog).
- `apps/las-versiones/CLAUDE.md` — pendiente (se crea al arrancar Fase 10).
