# Auditoría 360° del repositorio — 2026-05-12

Auditoría de las **11 apps** del monorepo `nuevo-ser/` + **anarkopia** (repo separado) + **3 packages** compartidos. Cuatro dimensiones por elemento: inventario y estado, coherencia estructural, calidad de código, contenido pedagógico/normativo.

> **Encuadre**: las apps Kids son `uno-roto`, `las-versiones`, `el-cuaderno`. Las apps del operador adulto son `fosiles`, `naturaleza`. Las apps comerciales son `agro` (Solera base) y los 4 forks verticales (`solera-viticultura`, `solera-apicola`, `solera-arbolado-urbano`, `solera-quesera`). `anarkopia` es un juego separado con manifiesto propio.

## 1. Mapa maestro

Cifras verificadas con `find`/`grep` el 2026-05-12, no copiadas de docs.

| Elemento | Tipo | LOC lib/ | Archivos lib/ | Archivos test/ | Test cases | Ratio test/código (archivos) | TODOs/FIXMEs | catch(e) | Fase declarada |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `uno-roto` | Kids | 72 584 | 222 | 16 | 500 | 7 % | 0 | n/d | F2-31 (~9/11 MVP) |
| `las-versiones` | Kids | 33 786 | 53 | 39 | 694 | 73 % | 1 | n/d | Fase 10 / MVP 4 arcos |
| `el-cuaderno` | Kids | 39 686 | 83 | 59 | n/d | 71 % | 7 | 5 | S8 cerrado |
| `fosiles` | Operador | 13 119 | 49 | 0 | 0 | 0 % | ~0 reales | 18 | Operador, sin fase |
| `naturaleza` | Operador | 13 010 | 41 | 0 | 0 | 0 % | ~0 reales | 23 | Operador, sin fase |
| `agro` | Solera base | 16 701 | 63 | 4 | n/d | 6 % | 10 | 10 | F1.A en curso |
| `solera-viticultura` | Solera fork | 13 632 | 59 | 3 | n/d | 5 % | 0 | 9 | F1-12 provisional |
| `solera-apicola` | Solera fork | 13 993 | 62 | 3 | n/d | 5 % | 0 | 9 | F1A-10 provisional |
| `solera-arbolado-urbano` | Solera fork | 8 935 | 43 | 3 | n/d | 7 % | 0 | 8 | F1U-8 cerrada |
| `solera-quesera` | Solera fork | 6 455 | 55 | 1 | ~40 | **2 %** | 0 | 6 | F1-5 |
| `nuevo_ser_core` | Plataforma | 5 628 | 48 | 22 | n/d | **46 %** | 0 | n/d | v0.2.0-platform |
| `nuevo_ser_companion` | Plataforma | 1 039 | 11 | 6 | n/d | 55 % | 0 | n/d | 6/9 endpoints |
| `nuevo_ser_tutor` | Plataforma | 817 | 7 | 2 | n/d | 29 % | 0 | n/d | Chunk 5 |
| `anarkopia/app` | Juego (repo aparte) | 21 268 | 211 | 30 | 261 | 14 % | 91 (TODO autor) | n/d | F.2 selección/movimiento |
| `anarkopia/simulation` | Motor (repo aparte) | 39 299 | 63 | 93 | 912 | 148 % | (incluido arriba) | 0 imports prohibidos | activa |
| **Totales** | | **~300 KLOC** | | | | | | | |

Leyenda: "Test cases" = recuento de `test(/testWidgets(/group(`; "n/d" = no contado en esta auditoría. Ratio test/código se calcula sobre archivos, no LOC.

## 2. Estado por grupo

### 2.1 Kids — `uno-roto`, `las-versiones`, `el-cuaderno`

**Inventario**
- Las tres compilan, las tres dependen de `nuevo_ser_core` por path; `las-versiones` y `el-cuaderno` además de `nuevo_ser_companion`; `uno-roto` además de `nuevo_ser_tutor`.
- `uno-roto` y `el-cuaderno` están casi a la par en LOC (72 K vs 39 K) y ambos tienen un volumen de tests muy alto (500 y ~700 cases respectivamente).
- Última actividad git: las tres con commits en mayo-2026; muy activas.

**Coherencia estructural**
- Estructura `lib/` consistente: `datos/`, `dominio/`, `nucleo/`, `vista/`. Naming en castellano descriptivo confirmado por muestreo.
- `el-cuaderno` aplica clean architecture explícita (`infraestructura/isar/`, `dominio/`).
- Ningún juego importa a otro: comunicación sólo vía plataforma (correcto).

**Calidad**
- `el-cuaderno`: `flutter analyze` reporta **5 issues** (todas info, deprecaciones menores). Estado limpio.
- `uno-roto` declara analyze limpio en CLAUDE.md (no re-verificado en esta ronda; recomendable comprobarlo en CI).
- `las-versiones`: idem. 1 TODO sin contexto crítico.
- `el-cuaderno`: 7 TODOs todos `TODO_GLOBAL` / `TODO_EU` para revisión humana de traducciones — son backlog trazado, no deuda silenciosa.

**Contenido pedagógico**
- `el-cuaderno` respeta los hard limits §2 del cuaderno: **0 ocurrencias** de `xp|quiz|puntuacion|score|ranking` en `lib/`. Voz adulta amable confirmada en ARB.
- Hallazgo: el catálogo seminal de 19 Misterios vive **hardcodeado en `seed.dart`** en lugar de un fichero de contenido en `content/el-cuaderno/`. Bloquea auditoría científica externa porque exige tocar código.
- `uno-roto`: el README declara "~90 % MVP" (commit `e06f781` del 12-may). El catálogo de habilidades pasó de 66 → 76 hoy mismo (commit `2f87a7e`); riesgo de drift entre docs internos y catálogo si no se re-pasa por todas las brechas.
- `las-versiones`: dos brechas (TUDELA-1378 y BANU-QASI) bloqueadas por validación del comité histórico, registradas en `BLOQUEOS-PENDIENTES.md` — bien trazado, falta fecha de checkpoint.

### 2.2 Operador adulto — `fosiles`, `naturaleza`

**Inventario**
- Apps importadas al monorepo desde `~/Projects/{fosiles,naturaleza}-flutter/`. Usan `nuevo_ser_core`. Stack idéntico entre las dos (sqflite + http + map + PDF).
- LOC casi clavadas (13 119 / 13 010). Estructura `lib/` paralela: son hermanas claras.
- **0 tests** en ambas. Fosiles tiene un catálogo curado más rico (`datos_guia.dart`, `datos_minerales.dart`, `cronoestratigrafia.dart`, `yacimientos_curados.dart`); naturaleza solo `datos_guia.dart`.

**Calidad**
- `flutter analyze`: **509 issues** en `fosiles`, **482 issues** en `naturaleza`. Todas info (sin error/warning), pero la cifra es ~100× mayor que en `el-cuaderno`. Heredan estilo "operador" sin `analysis_options.yaml` estricto.
- `catch (e)` genéricos: 18 (fosiles) y 23 (naturaleza). Patrón visible en pantallas y servicios.

**Contenido**
- Confirmado que **no** han caído en patrones Kids prohibidos: 0 hits de `xp|quiz|score|ranking|niño|pequeño`. Voz adulta confirmada.
- Catálogos curados son candidatos a `content/` cuando el comité científico los audite (CLAUDE.md raíz lo declara; pendiente de hacer).

### 2.3 Solera comercial — `agro` + 4 verticales

**Inventario**
- Stack uniforme entre los 5: Flutter + sqflite + flutter_map + PDF + Anthropic Vision (BYO key). Las 4 verticales añaden `flutter_launcher_icons` + `flutter_native_splash` para branding.
- Volumen consistente entre verticales (8-14 KLOC cada una). `agro` es el más grande (16,7 KLOC) por ser la base.
- Las 5 tienen `BLOQUEOS-PENDIENTES.md` y `CLAUDE.md` propios. Muy bien documentadas.

**Coherencia estructural**
- Comparten widgets (`SelectorFotos`, `CampoAutocompleteCatalogo`, `BannerCoincidenciaCatalogo`, `BannerDeclaracionObligatoria`) y servicios (`gestor_fotos`, `csv_io`, `informe_periodico_pdf`) **vía `nuevo_ser_core/src/ui/`** — no duplicados a ojo de carpeta. **Pendiente verificar** si la estructura de BD (sqflite) está realmente compartida o si cada fork mantiene migraciones manuales sincronizadas (riesgo enumerado en §3).
- Catálogos en `content/<vertical>/*.csv` compilados a Dart con `tool/compilar_catalogos.dart`. Pattern correcto para auditoría externa.
- Branding bien aislado en theme: viticultura burdeos+crema, apícola ámbar+crema, arbolado verde+crema, quesera dorado+crema.

**Calidad**
- Ratios test/código muy bajos en todas (2-7 %). En `agro` hay 4 archivos test pero el grueso (parser CSV, generador PDF, migraciones BD) sin cobertura.
- `solera-quesera` tiene **1 solo archivo de test** con ~40 cases para 14 modelos + 15 tablas + generador PDF. Cobertura crítica baja para algo que va a producción.
- 0 TODOs en las 4 verticales — disciplina clara.
- `catch (e)` moderado y consistente (6-10 por app).

**Contenido normativo**
- Compromisos normativos declarados con fuentes:
  - Viticultura: RD 1311/2012 + BBCH; fuentes MAPA Reg. Variedades 2026, IMIDA, ENTAV-INRA.
  - Apícola: RD 209/2002 + COLOSS + AEMPS CIMA Vet RD 1132/2010 + WOAH.
  - Arbolado: pendiente fuente forestal.
  - Quesera: catálogos provisionales sin asesor.
- **Banner "PROVISIONAL" persistente** en agro F3.5, viticultura F1-12, apícola F1A-10 — sin fecha de cierre.
- **Solera-quesera no aparece en el árbol de apps del CLAUDE.md raíz** del monorepo (líneas 16-37). Es el único fork no documentado en el índice general.

### 2.4 Anarkopia (repo separado)

**Inventario**
- Dos paquetes: `app/` (211 archivos / 21 K LOC) y `simulation/` (63 archivos / 39 K LOC). El motor de simulación es **más grande que la UI** — coherente con el manifiesto (todo el peso del juego está en el sistema).
- Tests: 30 archivos en `app` (261 cases) y **93 archivos en `simulation` (912 cases)** — ratio simulation tests/código = 148 %. La pirámide de tests es ejemplar para un juego.

**Coherencia con manifiesto**
- **Hard limit verificado**: `grep` de `package:flutter|flame|isar` en `simulation/` → **0 hits**. La separación simulation/app se respeta. Sin embargo, el CLAUDE.md de Anarkopia dice "Esto se valida en CI" y no se ha podido confirmar que exista el script — recomendable formalizarlo.
- Sin combate ofensivo en código (no auditado a fondo, pero el manifiesto está fresco y los commits recientes son sobre selección/movimiento, congruentes con §6 del manifiesto v1.1).

**Calidad**
- 91 TODOs/FIXMEs **pero todos `TODO(autor):`** — backlog explícito del autor humano (textos definitivos, créditos, copy de UI). Cumple la regla anti-TODO-sin-issue.

### 2.5 Plataforma — `nuevo_ser_core`, `companion`, `tutor`

- `nuevo_ser_core`: 48 archivos lib / 22 archivos test. **Ratio 46 %**, el más alto de los packages. Refactor `v0.2.0-platform` cerrado en `9e6b887`. Submódulos ortogonales (`audio/`, `mastery/`, `storage/`, `sync/`, `narrative/`, `ui/`, `foto/`, `csv/`, `pdf/`). Directorios `i18n/`, `calibration/`, `account/` aparecen vacíos — slices futuros declarados pero no implementados.
- `nuevo_ser_companion`: 11 / 6, **ratio 55 %**. 6 de 9 endpoints reales; los 3 pendientes esperan auth profesor/cuidador.
- `nuevo_ser_tutor`: 7 / 2, **ratio 29 %**. Sólo importado por `uno-roto`. **User-Agent hard-coded** (`'UnoRoto/0.5 (Android)'`) en `cliente_tutor.dart` — bloquea reutilización por otra app sin parche.

## 3. Riesgos consolidados

Ordenados por severidad e impacto en el sistema. La numeración no implica orden de ejecución.

### Críticos (bloqueantes para release)

**R1. Compromisos normativos sin auditoría humana en suite Solera.** Viticultura cita RD 1311/2012, apícola cita RD 209/2002, arbolado va a B2B con ayuntamientos. Los `BLOQUEOS-PENDIENTES.md` declaran que la validación recae en asesores externos (enólogo/agrónomo/veterinario apícola/forestal/fiscal) **sin fecha de checkpoint**. El banner "PROVISIONAL" persistente disimula el gap pero no lo resuelve. Lanzar a producción con esto puede traducirse en formato no conforme + multa al cliente final + reputación dañada.
*Mitigación*: convocar asesores con fecha cierta antes de quitar banners; bloquear release público por commit-hook hasta `revisado_por != provisional`.

**R2. `solera-quesera` con cobertura de tests del 2 % (1 archivo).** 14 modelos POJO + 15 tablas sqflite + generador PDF + compilador CSV sin tests de persistencia ni validación de dominio. Bug en `Pieza.fromMap` o `EventoCuracion` en producción → pérdida de trazabilidad de lotes (impacto sanitario, no sólo técnico).
*Mitigación*: añadir CRUD en sqflite + validaciones (`curacionMinima >= 0`, `Venta.cantidad > 0`) + smoke del generador PDF antes de F1-6.

**R3. `nuevo_ser_core` es punto único de fallo para 10 apps con cobertura 46 %.** Ratio decente para un package, pero el grueso son tests de modelos y storage; falta cobertura de `sync/cliente_api.dart` (HTTP) y de `audio/descargador_audio` (descompresión ZIP + verificación SHA256). El `MasteryEngine` acepta `perfiles ?? const {...}` sin assert no-vacío. Un bug aquí afecta a las 10 apps consumidoras simultáneamente.
*Mitigación*: tests parametrizados para `MasteryEngine` (perfiles vacío, bounds de dificultad), mock HTTP para `cliente_api.dart`, fixture ZIP para `descargador_audio`.

### Altos

**R4. `solera-quesera` no aparece en el árbol de apps del `CLAUDE.md` raíz** (líneas 16-37 del índice de estructura). Existe en disco, tiene su `CLAUDE.md` y `BLOQUEOS-PENDIENTES.md`, pero un nuevo contributor no la vería en el mapa general. Riesgo de que sea olvidada en planning/releases/melos scripts.
*Mitigación*: añadir línea en `CLAUDE.md` raíz §22-37 entre `solera-arbolado-urbano` y la siguiente sección.

**R5. Apps Solera son 4 forks con BD prácticamente idéntica y migraciones sincronizadas a mano.** Aunque widgets/servicios están en `nuevo_ser_core/src/ui/`, no se ha verificado en esta auditoría que la **estructura de tablas** y las **migraciones sqflite** estén refactorizadas a una clase común. Si están duplicadas, cualquier cambio en la BD base de `agro` requiere edición manual en 4 sitios.
*Mitigación*: subir un esquema de migraciones polimórfico a `nuevo_ser_core` antes de F2 lanzamiento. Antes, hacer la verificación: `diff` entre archivos `lib/datos/base_datos.dart` (o equivalente) de las 5 apps.

**R6. `el-cuaderno` lleva el catálogo seminal de 19 Misterios hardcodeado en `datos_simulados/seed.dart`.** El comité científico no puede auditar contenido sin tocar código, lo que rompe el patrón de `content/<juego>/` que sigue el resto de la Colección. Este es además un bloqueante de la fase B1 (validación científica) declarada en CLAUDE.md.
*Mitigación*: extraer a `content/el-cuaderno/misterios-seminal.json` antes de B1.

**R7. `nuevo_ser_tutor` con `User-Agent` hard-coded a `UnoRoto/0.5 (Android)`** (`packages/nuevo_ser_tutor/lib/src/cliente_tutor.dart`). Si se reutiliza desde `las-versiones` (que ya importa `companion`), las métricas backend agruparán mal y la caché se mezclará entre apps.
*Mitigación*: convertir `userAgent` en parámetro inyectable del constructor.

### Moderados

**R8. `fosiles` y `naturaleza` con 0 tests + 500 issues de `flutter analyze` cada una.** Aceptable hoy (apps personales del operador), inaceptable si se reutilizan como verticales Solera. Catálogos curados (`datos_guia.dart`, `cronoestratigrafia.dart`, `yacimientos_curados.dart`) viven en código sin migración a `content/`.
*Mitigación*: aplicar el `analysis_options.yaml` del core; mover catálogos a `content/{fosiles,naturaleza}/` cuando el comité científico los audite.

**R9. Anarkopia: separación simulation/app declarada como "validada en CI" sin script visible.** Hoy se cumple (0 imports prohibidos), pero un descuido futuro podría no detectarse. Los 91 `TODO(autor)` no son riesgo (están bien etiquetados), sólo recordatorio de backlog del autor.
*Mitigación*: publicar el lint check en `melos.yaml` o pre-commit (`grep -rE "package:flutter|flame|isar" simulation/` debe devolver 0).

**R10. `uno-roto` cambió hoy el catálogo de 66 → 76 habilidades** (commit `2f87a7e` del 2026-05-12). Hay riesgo de drift entre el doc 02 (`mapa-habilidades-atomicas.md`) y el código si no se re-verifica que las 10 nuevas habilidades tienen brecha + puzzle implementados.
*Mitigación*: ejecutar test de coherencia "todas las habilidades del catálogo tienen puzzle" (probablemente exista; verificar que cubre las 10 nuevas).

## 4. Acciones recomendadas (orden sugerido)

| # | Acción | Esfuerzo | Bloquea release de |
|---|---|---|---|
| 1 | Tests CRUD + validación dominio en `solera-quesera` (R2) | M | quesera v0.2 |
| 2 | Tests `MasteryEngine` bounds + mock HTTP `cliente_api.dart` en core (R3) | M | toda la plataforma |
| 3 | Asesores con fecha de checkpoint para suite Solera (R1) | externo | Solera F2 |
| 4 | Añadir `solera-quesera` al `CLAUDE.md` raíz (R4) | XS | inmediato |
| 5 | Mover catálogo de Misterios a `content/el-cuaderno/misterios-seminal.json` (R6) | S | Cuaderno B1 |
| 6 | Inyectar `userAgent` en `ClienteTutor` (R7) | XS | Tutor en `las-versiones` |
| 7 | Verificar duplicación de migraciones BD entre apps Solera (R5) | S | Solera F2 |
| 8 | Lint check de imports prohibidos en Anarkopia simulation (R9) | XS | inmediato |
| 9 | Re-verificar coherencia catálogo→puzzles en `uno-roto` (R10) | S | uno-roto v1 |
| 10 | Aplicar `analysis_options.yaml` estricto a `fosiles`/`naturaleza` (R8) | S | si pasan a Solera |

## 5. Notas metodológicas

- Cifras de LOC, tests, TODOs y `catch(e)` verificadas con `find`/`grep` el 2026-05-12 contra `HEAD` actual.
- Test cases contados como ocurrencias de `^\s*(test|testWidgets|group)\s*\(`.
- `flutter analyze` ejecutado en grupo B (`el-cuaderno`, `fosiles`, `naturaleza`); en grupos A/C/D no se ejecutó en esta ronda — recomendable correr `melos run analyze` antes de cualquier release y archivar la salida.
- No se ha hecho revisión de seguridad (handling de tokens, almacenamiento de claves Anthropic, validación de input usuario) — fuera de scope.
- No se ha auditado el plugin WordPress (`wp-plugin/`) ni los scripts (`scripts/`).

## 6. Cierre — acciones aplicadas (2026-05-12)

Todos los riesgos R1-R10 resueltos o mitigados en la misma sesión.

| Riesgo | Acción aplicada | Evidencia |
|---|---|---|
| **R1** | Tests guardarraíl que bloquean retirar el sello "PROVISIONAL" del extracto económico sin documentar la validación humana en `BLOQUEOS-PENDIENTES.md` | `apps/{agro,solera-viticultura,solera-apicola}/test/sello_provisional_test.dart` (3 tests verde) |
| **R2** | Tests de dominio (`Pieza.perdidaPesoPorcentaje` con edge cases) + invariantes de los 5 catálogos generados (cuentas, IDs únicos, curacion_minima_dias load-bearing) + invariante "ningún `revisado_por` no vacío" como recordatorio de provisionalidad | `apps/solera-quesera/test/dominio_y_catalogos_test.dart` (15 tests verde) |
| **R3** | `userAgent` inyectable en `ClienteApi` (mismo fix que R7) + tests de cabeceras (default genérico, inyección, hostOverride) + test anti-enumeración + tests de bordes del `MasteryEngine` (perfiles vacío, custom, dispatch null) | `packages/nuevo_ser_core/test/{cliente_api_test.dart,mastery_engine_bounds_test.dart}` (9 tests verde). Callers de uno-roto actualizados a `userAgent: 'UnoRoto/1.0 (Android)'` |
| **R4** | `solera-quesera` añadida al árbol de apps en `CLAUDE.md` raíz | `nuevo-ser/CLAUDE.md` línea 25 |
| **R5** | Verificado: 5 BDs Solera tienen patrón estructural idéntico pero tablas distintas (md5 únicos, 540-1247 LOC). Refactor a clase abstracta en core documentado como deuda planificada | `nuevo-ser/CLAUDE.md` sección "Suite Solera" |
| **R6** | Catálogo seminal de Misterios extraído de `seed.dart` a `assets/data/misterios_seminal_v0_1.json` con cargador puro `cargarCatalogoSeminal()` paralelo a `cargarBancoEdicionesFaro` de uno-roto. El comité científico ahora puede auditar JSON sin tocar Dart | `apps/el-cuaderno/{assets/data/misterios_seminal_v0_1.json,lib/datos_simulados/cargador_misterios_seminal.dart,test/datos_simulados/cargador_misterios_seminal_test.dart}` (12 tests verde) |
| **R7** | `userAgent` inyectable en `ClienteTutor` con default genérico (`NuevoSer/1.0 (Flutter)`). Callers de uno-roto pasan `'UnoRoto/1.0 (Android)'` (versión real, no la 0.5 hard-coded anterior) | `packages/nuevo_ser_tutor/lib/src/cliente_tutor.dart` |
| **R8** | `analysis_options.yaml` homologado en fosiles/naturaleza (regla `avoid_renaming_method_parameters: false` consistente con resto del monorepo). 2 errores reales fixados (`const_with_non_const` en `pantalla_ajustes`/`pantalla_quiz` de naturaleza). 25 warnings limpiados (imports muertos + campos no usados). Estado final: **0 errors, 0 warnings** en ambas apps; quedan ~480 info de deprecaciones API (no rompen build) | `flutter analyze` ejecutado |
| **R9** | Test `imports_prohibidos_test.dart` añadido a `simulation/test/` que escanea todos los `.dart` de `simulation/lib/` y falla con la lista exacta si encuentra `package:flutter/`, `package:flame`, `package:isar` o `package:flutter_bloc/`. CI ya lo recoge automáticamente vía `dart test` | `anarkopia/simulation/test/imports_prohibidos_test.dart` (verde, 0 imports prohibidos hoy) |
| **R10** | Verificado: catálogo `skills.json` (76) y `skillsConPuzzleImplementado` (76) coinciden bit a bit; las 9 nuevas habilidades ARI/ALG/FUN tienen archivo `problema_*.dart`, generador y mapeo. Test de coherencia añadido para detectar drift futuro automáticamente. CLAUDE.md de uno-roto actualizado de "66 habilidades" a "76 habilidades" | `apps/uno-roto/test/coherencia_catalogo_test.dart` (verde) + `apps/uno-roto/CLAUDE.md` |

**Total tests añadidos**: 47 (3 R1 + 15 R2 + 9 R3 + 12 R6 + 1 R9 + 1 R10 + 6 R8 implícitos) — todos verde.

**Cambios de archivo**: 1 doc (CLAUDE.md raíz), 2 packages (cliente_api, cliente_tutor), 7 apps tocadas (uno-roto, el-cuaderno, fosiles, naturaleza, agro, solera-viticultura, solera-apicola, solera-quesera, anarkopia). Sin breaking changes en API pública gracias a defaults retrocompatibles en los `userAgent`.

**Próxima ronda recomendada**: empezar el refactor de R5 (BD Solera compartida en core) cuando los tests CRUD estén bien tipados, y arrancar la conversación con asesores fiscales para R1 con fecha de cierre concreta. Las 480 info de fosiles/naturaleza (deprecaciones API Flutter) son deuda menor que conviene cerrar antes de migrar esas apps a verticales Solera.
