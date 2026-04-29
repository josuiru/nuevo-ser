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

**Cerrado** en `main` con tag `v0.2.0-platform` (commit `9e6b887`). Plan de 8 chunks ejecutado (ver `~/.claude/plans/vast-soaring-glacier.md`):

- **C1** ✓ esqueleto monorepo Melos + `git mv` de `app/` → `apps/uno-roto/`.
- **C2** ✓ rename plugin WP `uno-roto-core` → `nuevo-ser-core`, prefijo `NS_*`.
- **C3** ✓ endpoints duales `/uno-roto/v1/*` (alias deprecado) ↔ `/nuevo-ser/v1/*` (canónico).
- **C4** ✓ migración M001: prefijo `wp_uroto_*` → `wp_ns_*`, columna `game_id`, tabla `ns_games`.
- **C5** ✓ extracción inicial a `packages/nuevo_ser_core` (habilidad, ClienteApi) y `packages/nuevo_ser_tutor` (cache_tutor, cliente_tutor, filtro, disparador). Resto pendiente — README de cada package documenta la deuda.
- **C6** ✓ motor adaptativo Strategy: `MasteryEngine` + `P1Precision` + stubs `P2`/`P3`/`P4`. `MotorMaestria` de uno-roto reducido a facade.
- **C7** ✓ 6 tablas de acompañamiento (`ns_classrooms`, `ns_classroom_members`, `ns_caregiver_links`, `ns_cuaderno_entries`, `ns_mosaicos`, `ns_weekly_summaries`) + 9 endpoints `501 Problem Details` (RFC 7807) reservando la superficie de companion. Solo en namespace canónico.
- **C8** ✓ paridad Dart/PHP del motor: espejo `NS_Mastery_Engine` + fixture compartida (`packages/nuevo_ser_core/test/fixtures/motor_p1.json`) consumida por test Dart y test PHP.

### Avance post-refactor (deuda C5/C6)

Continuando la extracción anunciada en los READMEs de los paquetes, en slices pequeños con tests caracterización antes del movimiento:

- **Selector adaptativo de habilidades** ✓ extraído a `packages/nuevo_ser_core/lib/src/mastery/selector_habilidades.dart` con API genérica (candidatas + contextoBonusId + aplicarBonusContexto). El archivo de uno-roto queda como wrapper fino que mantiene la API pública (`Distrito` + `dominioFiltrado`) y delega el algoritmo. 12 tests caracterización en el core (pesos por nivel, decay, bonus contexto, anti-repetición, dependencias, determinismo).
- **Gestión multi-perfil** ✓ extraída a `packages/nuevo_ser_core/lib/src/storage/gestor_perfiles.dart`. Encapsula identificación del perfil activo, listado, creación/borrado, slugify (con tildes y ñ → ASCII), migración silenciosa de claves legadas (`<ns>.X` → `<ns>.perfil.principal.X`) y whitelist de claves globales no migrables. Parametrizado por `namespace` para que cada juego use el suyo (`uroto`, `lasversiones`…). `PerfilInfo` también vive en el core; `RepositorioProgreso` lo re-exporta para no romper imports existentes. 17 tests caracterización en el core. `RepositorioProgreso` queda en 619 LOC (de 786) delegando los 6 métodos públicos de perfiles + la migración al gestor.

Plugin WP en v0.6.0. Tests: 339 (uno-roto) + 39 (nuevo_ser_core) Dart + 3 PHP smoke. `flutter analyze` limpio en los 5 paquetes.

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
