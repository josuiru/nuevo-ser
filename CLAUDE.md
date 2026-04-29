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
- **Persistencia JSON de habilidades y estado tutor** ✓ extraída. `RepositorioHabilidades` (en `nuevo_ser_core/storage/`) y `RepositorioEstadoTutor` (en `nuevo_ser_tutor/src/`) montan ambos sobre el `GestorPerfiles` con shape de claves histórico (`<ns>.perfil.<id>.habilidad.<id>`, `<ns>.perfil.<id>.tutor.estado.<id>`), auto-curación de JSON corrupto y aislamiento por perfil activo. Helper `aFechaMysql` también vive en el core. `RepositorioProgreso` baja a 552 LOC (-234 desde el inicio del slice) delegando `cargarEstadoHabilidad`, `guardarEstadoHabilidad`, `cargarEstadoTutor`, `guardarEstadoTutor`, `exportarHabilidadesParaSync`. 9 tests caracterización en core + 5 en tutor.
- **ServicioTutor** ✓ subido a `nuevo_ser_tutor/src/servicio_tutor.dart`. La dependencia `RepositorioProgreso` (juego-específica) se invierte: ahora se le inyecta directamente un `RepositorioEstadoTutor`, lo que hace al servicio agnóstico al juego. `RepositorioProgreso` expone un getter público `estadoTutor` para que las pantallas (`pantalla_caza`, `pantalla_habilidades`, `pantalla_tutor_test`) lo pasen al constructor. Se eliminan los métodos `cargarEstadoTutor`/`guardarEstadoTutor` del repositorio (sin uso restante), el archivo `apps/uno-roto/lib/dominio/tutor/servicio_tutor.dart` y la carpeta `dominio/tutor/`. La suite de comportamiento del servicio (14 tests) migra a `packages/nuevo_ser_tutor/test/servicio_tutor_test.dart`.
- **Preferencias de audio por perfil** ✓ extraídas a `nuevo_ser_core/storage/repositorio_preferencias_audio.dart` (modo silencio + volumen por capa, con clamp 0..100, defaults configurables). `RepositorioProgreso` mantiene los 4 métodos públicos (`cargarAudioModoSilencio`, `guardarAudioModoSilencio`, `cargarAudioVolumenCapa`, `guardarAudioVolumenCapa`) como delegaciones. 7 tests caracterización en core. El catálogo de capas concretas (ambient/musica/efectos/narrativos) sigue siendo del juego.

### Companion v0.1: primer endpoint real

Primer trozo del paquete `nuevo_ser_companion` que sale del estado vacío y se cablea end-to-end:

- **`POST /companion/cuaderno/entries`** — `NS_Companion_Cuaderno::crear_entrada` reemplaza el handler 501 reservado en C7 sólo para esta ruta; las otras 8 siguen como 501. Validación de formato pura (`validar_formato`) + comprobación de existencia de `game_id` contra `ns_games`. Devuelve 201 con `{id, game_id, type, title, content_ref, created_at}` y header `Location`. Plugin WP bumpa a v0.7.0.
- **`GET /companion/cuaderno/entries`** — `NS_Companion_Cuaderno::listar_entradas` añade el segundo endpoint real (las otras 7 siguen 501). Lee `_nino_id` del JWT, valida query con `validar_query_listado` (game_id opcional, limit 1..100 default 20, offset >=0 default 0), comprueba existencia de `game_id` contra `ns_games`, ejecuta SELECT COUNT + SELECT paginado (DESC por created_at, id) y devuelve 200 con `{entries:[...], total, limit, offset}`. `serializar_fila` deserializa `content_meta`/`anchored_to` del LONGTEXT (auto-curación: JSON inválido → null, sin romper la lista entera).
- **`POST /companion/mosaicos`** — `NS_Companion_Mosaicos::crear_mosaico` añade el tercer endpoint real (quedan 6 en 501). Un mosaico es el "trabajo final" de un arco: shape parecido a cuaderno pero con `arc_id` obligatorio (VARCHAR 64), `format` opcional (VARCHAR 32, lowercase con `_`), y `required_anchors`/`fulfilled_anchors` que aceptan **lista u objeto** (PHP `is_array` cubre ambos; `Object?` en Dart). `qualitative_feedback` opcional como string (se guarda crudo en LONGTEXT, no envuelto en JSON). `completed_at` lo pone el servidor (un mosaico que llega aquí está terminado). Devuelve 201 con `{id, game_id, arc_id, format, title, content_ref, completed_at}` y header `Location`. Sharing con aulas/cuidadores no se acepta todavía, igual que cuaderno.
- **`GET /companion/mosaicos`** — `NS_Companion_Mosaicos::listar_mosaicos` añade el cuarto endpoint real (quedan 5 en 501). Lee `_nino_id` del JWT, valida query con `validar_query_listado` (game_id opcional, arc_id opcional max 64, limit 1..100 default 20, offset >=0 default 0). WHERE dinámico para evitar duplicar 4 variantes de SQL (game_id ↔ no game_id × arc_id ↔ no arc_id). ORDER BY completed_at DESC, id DESC. Devuelve 200 con `{entries:[...], total, limit, offset}` — misma envoltura que el listado del cuaderno para que el cliente trabaje con una sola forma de paginación. `serializar_fila` deserializa los 3 LONGTEXT JSON con auto-curación.
- **`POST /classrooms/{code}/join`** — `NS_Companion_Aulas::unirse` (en `class-ns-companion-aulas.php`, primer fichero del subsistema de aulas/cuidadores) añade el quinto endpoint real (quedan 4 en 501). Reusa el JWT del niño. `validar_codigo` puro normaliza a mayúsculas, hace trim y comprueba longitud 4..16 con regex `[A-Z0-9]+`. SELECT del aula por code, 404 si no existe, 409 si está inactiva. Inserción idempotente en `ns_classroom_members`: si el niño ya era miembro devuelve 200 con su `joined_at` histórico; si fue dado de baja se reactiva (active=1) preservando la fecha original. 201 cuando es nuevo, 200 cuando es idempotente. `decodificar_lista_games` filtra el LONGTEXT a `List<String>` con auto-curación.
- **`POST /companion/aggregates/weekly`** — `NS_Companion_Agregados::archivar` (en `class-ns-companion-agregados.php`) añade el sexto endpoint real (quedan 3 en 501). Reusa el JWT del niño. `validar_formato` puro: `game_id` requerido, `iso_week` con regex `\d{4}-W(0[1-9]|[1-4]\d|5[0-3])` (frontera 53), `aggregates` requerido y debe ser objeto. `calcular_hash` puro: SHA-256 hex sobre el JSON con claves ordenadas recursivamente (las listas mantienen orden — su orden sí es semánticamente significativo). Upsert idempotente por `(user_id, game_id, iso_week)`: mismo hash → 200 sin tocar `generated_at` ni `summary_text`; hash distinto → UPDATE borrando `summary_text` (para que el tutor IA regenere); fila nueva → INSERT 201. **Sin LLM**: `summary_text` se almacena vacío hasta el slice de cableado del tutor IA al endpoint.
- **Cliente Dart** `ClienteCompanion` con seis métodos (crear/listar cuaderno, crear/listar mosaicos, unirse aula, archivar agregados). Modelos: `EntradaCuaderno`/`ListadoEntradasCuaderno`, `Mosaico`/`ListadoMosaicos`, `MembresiaAula`, `AgregadoSemanal`. 33 tests con `MockClient`.
- **Smoke PHP** `tests/test_companion_cuaderno.php` (27), `mosaicos.php` (38), `aulas.php` (13), `agregados.php` (15: validación de iso_week incluyendo W00/W54/W53, aggregates ausente/null/string/int/{}, hash determinista por orden de claves, listas sensibles al orden, no-colisión de hash).
- **Pendientes acoplados a auth de profesor/cuidador** (no decidida): `POST /classrooms`, `GET /classrooms/{id}/aggregates` y los 3 de cuidadores. JWT actual sólo lleva `nino_id`. **Pendiente independiente**: cablear el tutor IA al endpoint de agregados para producir `summary_text`/`conversation_prompt` con caché por hash.

Plugin WP en v0.7.0. Tests: 325 (uno-roto) + 55 (nuevo_ser_core) + 22 (nuevo_ser_tutor) + 33 (nuevo_ser_companion) Dart + 7 PHP smoke (filtro_tutor, jwt_tutor, paridad_motor, companion_cuaderno, companion_mosaicos, companion_aulas, companion_agregados). `flutter analyze` limpio en los 5 paquetes.

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
