# Monorepo Colección Nuevo Ser Kids — CLAUDE.md

Cerebro persistente del monorepo. Se lee al inicio de cada sesión. Detalle por juego en `apps/<juego>/CLAUDE.md`.

## Encuadre del programa

Este monorepo aloja los juegos digitales pedagógicos de **Colección Nuevo Ser Kids**, la línea infantil/escolar (juegos para 9-14 años) de la **Colección Nuevo Ser**. La Colección madre es un proyecto editorial y de pensamiento más amplio (editorial de libros, plugins para colectivos y comunidades, herramientas para favorecer alternativas y pensamiento crítico y constructivo): https://coleccion-nuevo-ser.com/.

Cuando los docs de este repo dicen "la Colección" sin más, se refieren a Kids.

## Estructura

```
.
├── apps/
│   ├── uno-roto/         juego de matemáticas 9-12 (Kids, en producción, fase ~8-9 MVP)
│   ├── las-versiones/    juego de pensamiento histórico 10-14 (Kids, Fase 10)
│   ├── el-cuaderno/      cuaderno de campo digital 9-13 (Kids, Bloque B)
│   ├── fosiles/          cuaderno de campo de fósiles (adulto aficionado, operador)
│   ├── naturaleza/       cuaderno de campo de naturaleza (adulto aficionado, operador)
│   ├── agro/             Solera — gestor de fincas (producto comercial)
│   ├── solera-viticultura/   Solera Viticultura (bodegas pequeñas/medias)
│   ├── solera-apicola/       Solera Apícola (apicultores 20-200 colmenas)
│   ├── solera-arbolado-urbano/ Solera Arbolado Urbano (B2B ayuntamientos)
│   ├── solera-quesera/       Solera Quesera (queserías artesanas, F1-5)
│   └── solera-aceitera/      Solera Aceitera (almazaras pequeñas, F1-A1 esqueleto)
│
├── packages/
│   ├── nuevo_ser_core/        plataforma compartida (motor maestría, sync, audio, cinemáticas)
│   ├── nuevo_ser_companion/   acompañamiento (Cuaderno, Mosaicos, dashboards) — v1.5
│   └── nuevo_ser_tutor/       cliente Tutor IA con caché y filtros
│
├── content/              JSON exportables de habilidades/brechas por juego
├── tests/                suites cross-package (paridad Dart/PHP)
├── wp-plugin/            plugin WordPress backend
├── scripts/              scripts dev/sonido
├── melos.yaml            gestión del monorepo
└── pubspec.yaml          workspace raíz (instala Melos)
```

## Estado de la plataforma

**Refactor `nuevo-ser-core`**: cerrado en `v0.2.0-platform` (commit `9e6b887`). Plan de 8 chunks ejecutado. 12 slices post-refactor extraídos (selector habilidades, multi-perfil, persistencia JSON, ServicioTutor, audio — CapaAudio/Descargador/Version/Sugerencia, CuentaBackend, IdiomaApp, AvatarPerfil). Detalle en `packages/nuevo_ser_core/README.md` y `~/.claude/plans/vast-soaring-glacier.md`.

**Las Versiones (Fase 10)**: MVP Arco 1 + Arco 2 jugable end-to-end. 65 habilidades en 7 dominios, 4 perfiles de medición (P1/P4 funcionales en core). Brechas 1.1, 2.1, 2.2, 2.3, 2.4 jugables con 5 fases. Mosaicos M1 (cómic) y M2 (audio-guía). Companion cableado. Detalle exhaustivo en `apps/las-versiones/CLAUDE.md`. Sustituciones diegéticas en `BLOQUEOS-PENDIENTES.md`.

**Companion v0.1**: 6 endpoints reales de 9 (`POST/GET /companion/cuaderno/entries`, `POST/GET /companion/mosaicos`, `POST /classrooms/{code}/join`, `POST /companion/aggregates/weekly`). 3 pendientes por auth profesor/cuidador. Plugin WP v0.9.0. Detalle en `packages/nuevo_ser_companion/README.md`.

## Apps del operador (no Kids)

`apps/fosiles/` y `apps/naturaleza/` son apps **del operador (Josu) para adulto aficionado**, traídas al monorepo desde `~/Projects/{fosiles,naturaleza}-flutter/` para reutilizar plataforma compartida. **No son juegos Kids** y por tanto:

- NO aplica la voz adulta amable de la biblia del cuaderno.
- NO aplican los hard limits §2 del cuaderno (sin XP/quiz/estadísticas).
- SÍ se respeta privacidad estructural al sincronizar al backend.
- NO se fusionan con el cuaderno. Si el cuaderno necesita identificar algo, el adulto lanza esta app.

Catálogos curados (`datos_guia.dart`, `datos_minerales.dart`, `cronoestratigrafia.dart`, `yacimientos_curados.dart`) son candidatos a moverse a `content/` cuando el comité científico los audite.

## Producto comercial — Solera (apps/agro)

`apps/agro/` es **producto comercial general** (no Kids, no operador). Branded como **Solera**: gestor de fincas agrícolas para Iberia. Modelo: planta con identidad persistente. Estado: F0+F1 cerrado, F1.A en curso, F1.B-F4 pendientes. Diferenciador: modo trufas único en mercado + cuaderno MAPA. Detalle en `apps/agro/CLAUDE.md`.

## Suite Solera — verticales especializadas

Cinco forks de Solera por vertical. Comparten widgets (`CampoAutocompleteCatalogo`, `SelectorFotos`, banners) y servicios (`gestor_fotos`, `csv_io`, `informe_periodico_pdf`) en `nuevo_ser_core/src/ui/`. Catálogos en CSVs en `content/<vertical>/` compilados a Dart.

- **`apps/solera-viticultura/`** — bodegas 5-30 ha. Cuaderno PAC móvil (RD 1311/2012) + IA vid. F1-1 a F1-10 cerradas (provisional). Branding burdeos+crema.
- **`apps/solera-apicola/`** — apicultores 20-200 colmenas. Libro REGA + gestión varroa + IA apícola. F1A-1 a F1A-8 cerradas (provisional). Branding ámbar+crema.
- **`apps/solera-arbolado-urbano/`** — B2B ayuntamientos. QR chapa + VTA + multi-operario. F1U-1 a F1U-8 cerradas (provisional). Branding verde+crema.
- **`apps/solera-quesera/`** — queserías artesanas. Cuaderno APPCC + curación + trazabilidad lotes. F1-5 (catálogos provisionales). Branding dorado+crema.
- **`apps/solera-aceitera/`** — almazaras pequeñas y medianas (100-2000 hl/campaña). Cuaderno PAC olivar (RD 1311/2012) + libro de movimientos del aceite (RD 760/2021 + AICA) + DOP olivar + IA visual plagas olivar + cierre fiscal REAGP. **F1-A1 esqueleto cerrado**, F1-A2 modelos+BD pendiente. Branding verde oliva+crema.

Detalle de cada una en su `CLAUDE.md` + `BLOQUEOS-PENDIENTES.md`.

**Contabilidad**: planificado por vertical (agro/viticultura/apícola como gastos REAGP, arbolado como facturación B2B Facturae). Bloqueado por asesor fiscal humano.

**Deuda técnica conocida — refactor BD compartida (auditoría 2026-05-12 R5)**: las 5 apps Solera (`agro` + 4 verticales) tienen `lib/datos/base_datos.dart` con **patrón estructural idéntico** (singleton lazy, openDatabase con `_v<N>.db`, migraciones aditivas en `_aplicarMigraciones`) pero **tablas distintas** (cepas/colmenas/árboles/piezas/cultivos). Cada cambio en el patrón base obliga a editar 5 archivos sincronizados a mano. Refactor planificado: extraer una clase `BaseDatosSolera` abstracta a `nuevo_ser_core/src/datos/` con plantilla del singleton + framework de migraciones, y dejar a cada vertical solo el bloque "esquema y migraciones". Bloqueado por: necesidad de tests CRUD que cubran el contrato antes de mover el patrón. Ver `docs/auditoria-2026-05-12.md` riesgo R5.

## Decisiones cerradas

- **Persistencia local**: shared_preferences con prefijo `uroto.*` y `uroto.perfil.<id>.*` para Uno Roto. Juegos nuevos: `nuevoser.<juego>.*`. Migración a Isar diferida a v1.5.
- **Tablas BD**: prefijo `wp_ns_*` + `game_id`. Renombrado semántico diferido a v1.5.
- **Endpoints**: `/nuevo-ser/v1/*` canónico; `/uno-roto/v1/*` alias deprecado hasta v1.5.
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
- `apps/las-versiones/CLAUDE.md` — encuadre, mapa de habilidades, hard limits, decisiones, estado actual.
- `apps/agro/CLAUDE.md` — Solera: encuadre, posicionamiento, modelo de datos, roadmap por fases.
