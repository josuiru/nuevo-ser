# El Cuaderno — CLAUDE.md

Cerebro persistente del proyecto. Se lee al inicio de cada sesión. Se mantiene corto. Para detalle: docs canónicos en `docs/el-cuaderno/` (copiados al repo desde `~/Projects/games/el-cuaderno-paquete-documental-v0.1/` en S0).

## Encuadre del programa

El Cuaderno es uno de los juegos de la línea **Colección Nuevo Ser Kids** (juegos digitales pedagógicos infantiles/escolares). Hermano epistémico de Uno Roto (matemáticas) y Las Versiones (historia): los dos primeros enseñan oficio dentro de un mundo ficticio; el Cuaderno es el primer juego **no narrativo** — sin protagonista, sin mundo ficticio, sin arcos. La protagonista es la niña real, su lugar es el suyo real.

## Qué es El Cuaderno

Herramienta de campo digital con alma pedagógica para 9-13 años. Materia: Conocimiento del Medio Natural (LOMLOE primaria, ciclos 2 y 3) — pre-Biología y pre-Ecología. Forma: cuaderno personal + sit spot real + Misterios contextualizados al lugar y la estación + Tutor IA limitado por reglas.

Razón de la forma no narrativa: la palabra *naturaleza* presupone separación entre quien observa y lo observado. Inventar un valle ficticio donde la niña hace de naturalista refuerza esa separación. El Cuaderno, en cambio, **amplifica la atención del niño hacia el lugar real donde está**. Anclaje filosófico directo a *La Tierra que Despierta*.

Licencia: código AGPL-3.0, contenido CC-BY-SA 4.0.

## Principios jerárquicos (biblia §2)

Si dos entran en conflicto, gana el anterior:

1. **El cuaderno es del niño.** Privacidad por diseño, no negociable.
2. **Recordar antes que aprender.** Pedagogía del recuerdo, no de la transmisión.
3. **El lugar es el lugar real del niño.** No hay mundo ficticio.
4. **Nunca humillar al niño.** No hay "incorrecto", no hay rojo.
5. **Respeto por la edad.** Voz adulta amable, sin diminutivos.
6. **Maestría observable, no declarada.** Niveles ocultos al niño.
7. **Cierre amable y ritmo respetuoso.** Sin rachas, sin push, sin recompensas variables.
8. **Offline-first.** El campo no tiene wifi.
9. **Sin extracción.** Sin ads, sin tracking, sin venta de datos.
10. **Multiidioma desde el día cero.** es / eu / ca en v1.

## Mecánica central — observar despacio el lugar

Cinco componentes del oficio (biblia §3):

1. **Observar antes de interpretar** — separar *qué viste* de *crees que es* (estructural en la pantalla).
2. **Registrar para recordar** — escribir, dibujar, fotografiar.
3. **Identificar con humildad** — niveles de confianza explícitos: consenso / hipótesis activa / no segura.
4. **Hipotetizar y contrastar** — pregunta sostenida, vuelta al lugar, evidencia.
5. **Habitar un lugar** — sit spot, regreso regular, ciclo del lugar.

## Habilidades atómicas (doc 02)

**59 habilidades en 9 dominios**:

| Cód | Dominio | N | Notas |
|-----|---------|---|-------|
| **PRE** | Presencia | 4 | Habitar el lugar |
| **OBS** | Observación | 7 | Mirar y escuchar antes de interpretar |
| **REG** | Registro | 6 | Convertir observación en cuaderno |
| **TAX** | Identificación | 10 | Distinguir y clasificar |
| **REL** | Relaciones | 8 | Ver el tejido vivo |
| **CIC** | Ciclos | 7 | Notar el tiempo de la vida |
| **HAB** | Hábitats | 6 | Entender dónde y por qué |
| **HIP** | Hipótesis | 6 | Pensar como el oficio piensa |
| **TEJ** | Tejido roto y tejido vivo | 5 | Ver lo que falla y lo que persiste |

**Perfil de medición** — el motor adaptativo de `nuevo_ser_core` lo despacha:
- **P5 — Compuesto** (nuevo, pendiente de implementar): mezcla precisión + rúbrica + cobertura + proxy con pesos por habilidad. Doc 03 §4.

Ningún perfil del core actual encaja porque los dominios mezclan tipos de medición (TAX/CIC por precisión, OBS/REG por rúbrica, HAB/REL/TEJ por cobertura, PRE solo por proxy).

## Hard limits (no negociables)

- **Privacidad estructural**: texto libre / fotos / dibujos / coordenadas precisas viven SOLO en Isar local cifrado. Al servidor solo van metadatos (hash de `what_seen`, `region_code` NUTS-3, agregados firmados con HMAC).
- **Sin gamificación tóxica**: sin XP, sin niveles desbloqueables, sin rachas, sin notificaciones push, sin recompensas variables, sin ranking, sin "logros", sin animaciones de celebración con sonido, sin barras de progreso del cuaderno, sin contador de días, sin amigos en la app.
- **Voz adulta amable**: vocabulario prohibido extenso (doc 04 §2.3). Test final: *"¿podría salir esto de alguien que llevara cuarenta años caminando este monte?"*.
- **Tutor IA con barreras**: ZDR + sin memoria entre conversaciones + lista negra + cuota 30 turnos/día.
- **Vista del aula k≥5** obligatorio. Vista del cuidador: solo párrafo cualitativo + pregunta para la cena, NUNCA acceso al cuaderno.
- **Open source desde el primer commit** (AGPL-3.0).

## Validaciones humanas requeridas

Cuando el código toque alguna de estas áreas, el PR queda **pendiente de validación humana**:
- Catálogo de Misterios (datos `[A VERIFICAR]` con SEO/BirdLife, RJB-CSIC, naturalistas locales).
- Claves de identificación regionales (biólogas/biólogos del territorio).
- Traducciones eu/ca por hablantes nativos con criterio terminológico naturalista.
- Calendario fenológico (ornitólogos/botánicos del territorio).
- Detección emocional / caso 1 doc 15 §8 (asesoría psicológica infantil).
- Voz del Tutor (test contra prompts adversariales antes de cada release).
- Datos del niño / autenticación / LOPDGDD para menores.

## Documentos de diseño

En `docs/el-cuaderno/` del repo. Al empezar tarea → solo los relevantes:

- `01-biblia.md` — espíritu del juego, principios jerárquicos, mecánicas.
- `02-mapa-habilidades-atomicas.md` — 59 habilidades del MVP en 9 dominios + mapeo LOMLOE.
- `03-arquitectura-tecnica.md` — stack, perfil P5, sincronización, privacidad por diseño, roadmap S1-S9.
- `04-voces-y-figuras.md` — voz del Cuaderno y del Tutor, vocabulario prohibido, intercambios canónicos, decisión abuela.
- `05-pedagogia-del-lugar.md` — cómo tratar el lugar real del niño sin folclorismo.
- `06-pedagogia-misterios.md` — anatomía de un Misterio bueno y de uno malo.
- `11-guia-visual.md` — paleta, tipografía, iconografía, ilustración botánica.
- `12-guia-sonora.md` — el silencio es el contenido.
- `13-flujos-de-usuario.md` — diez recorridos típicos paso a paso, microcopia exacta.
- `14-prompt-maestro-contenido.md` — tres prompts para escalar producción de contenido.
- `15-acompanamiento.md` — vista del cuidador, vista del aula, materiales pedagógicos.
- `catalogo-seminal-misterios.md` — 19 Misterios redactados al detalle.
- `prompt-claude-code.md` — prompt operativo para el Sprint 1 (bootstrap).

## Estado actual

**S0 → S8 completos**, S9 (piloto) bloqueado por validaciones humanas (memoria `project_el_cuaderno_decisiones_humanas_pendientes`).

**S0 completo** (rama `feature/el-cuaderno-bootstrap`):
- 15 docs del paquete documental copiados a `docs/el-cuaderno/` (renombrados sin prefijo `el-cuaderno-` para encajar con el patrón que el `prompt-claude-code.md` espera).
- Esta `CLAUDE.md` redactada.
- Sin entrada explícita en `melos.yaml` porque ya usa `apps/*` glob — basta con que exista `pubspec.yaml`.

**S1 completo** — bootstrap del scaffolding cableado a Isar + dominio + UI.

**S2 completo** — backend WP (`NS_El_Cuaderno`: observaciones, sit-spot, misterios) + cliente Dart con frontera de privacidad (`what_seen_hash`, no lat/lng) + cola de sync con reglas de recuperabilidad (4xx irrecuperable salvo 401/408/429, 5xx reintenta). M003 con tablas `ns_observations`, `ns_sit_spots`, `ns_mysteries_catalog`. Renombrado feature companion `cuaderno` → `bitacora` para evitar colisión.

**S3 completo** — Perfil P5 compuesto en `nuevo_ser_core` con paridad bit a bit Dart/PHP (12 casos en fixture compartida `packages/nuevo_ser_core/test/fixtures/perfil_p5.json`).

**S4 completo** — Tutor IA real cableado a Anthropic con prompt versionado server-side (`NS_Prompt_Cuaderno::VERSION = 'cuaderno-v1-2026-04-30'`), filtro lista negra del doc 04, regeneración con un retry, fallback canónico tras dos fallos, mensaje de cuota agotada. Cuota stub pendiente de M004. UI cableada: `PantallaTutor` recibe `EnviarPreguntaTutor?` opcional desde `main.dart`; sin token cae al canned response del S1, con token llama al cliente real y atrapa `CuotaTutorAgotada`. Bloque debug-only en Ajustes (`_BloqueTutorDebug`) permite pegar/borrar JWT a mano para probar end-to-end mientras no haya pantalla de login (memoria ítem 11) — visible sólo si `kDebugMode` desde `main.dart`.

**S5 completo (alcance mínimo)** — `dominio/geolocalizacion_privacy_first.dart`: contrato `ServicioGeolocalizacion`, enum `PermisoGeo` con 4 estados, `distanciaMetros` Haversine con WGS-84, `estaEnSitSpot` con radio 50 m, `normalizarRegion` con bounding boxes piloto (ES-NA-PA, ES-NA, ES-BI, ES-MD, ES-BCN) y fallback `'ES'`. `ClienteElCuaderno` deriva `region_code` automáticamente. **Pendiente humano**: añadir plugin `geolocator` real + `flutter_map` + permisos Android/iOS (ítem 15-16 memoria) y MBTiles regional descargable bajo demanda.

**S6 completo (alcance mínimo)** — `dominio/fenologia.dart` con cortes astronómicos del hemisferio norte (20 mar / 21 jun / 22 sep / 21 dic). `ClienteElCuaderno.listarMisteriosParaAhora` deriva `region` y `season` desde coords + fecha sin que las coords crucen red. **Pendiente humano**: calendario fenológico Iberia curado por ornitólogos/botánicos (ítem 12 memoria).

**S7 completo (alcance acotado por bloqueante)** — `dominio/agregado_semanal.dart` calcula localmente `iso_week`, counts y reparto por misterio/confianza (sólo metadatos, nunca texto libre). `preguntaParaLaCenaOffline` genera la pregunta del cuidador con plantillas hardcoded en castellano (5 ramas) — fallback offline antes de que llegue el resumen del LLM vía `/companion/aggregates/weekly`. **Sync con companion cableado**: `datos/sincronizador_agregados.dart` (SincronizadorAgregadosCuaderno con sealed `ResultadoSync` — `SyncSinToken`/`SyncExito`/`SyncError`) lee token, computa el agregado local y lo sube al endpoint. Botón opt-in "Compartir resumen con el adulto" en `PantallaCuidador`: lo dispara la persona adulta presente — sin push, sin sync automático en background. Cuando el LLM server-side genera `summaryText`/`conversationPrompt`, sustituyen al fallback offline; si fallan, el aviso lo dice y la pregunta offline sigue valiendo. **Pendiente humano**: vista del aula k≥5 bloqueada por auth de profesor (ítem 11 memoria).

**S8 completo (alcance acotado)** — `ExportadorCuaderno.aJson/deJson` round-trip versionado del cuaderno completo. `RepositorioLocal.borrarTodoLoLocal` orquesta el borrado completo en memoria e Isar con `ResultadoBorrado` para feedback honesto. **Pendiente humano**: paquete `pdf` + tipografía/paleta (ítem 13 memoria) y auditoría WCAG 2.1 AA sobre tema definitivo (ítem 14 memoria).

**S9 (piloto)** — bloqueado por la lista completa de la memoria `project_el_cuaderno_decisiones_humanas_pendientes`. La urgencia más alta:
- ítem 1: asesoría didáctica del mapa de habilidades.
- ítem 2: asesoría psicológica del caso 1 doc 15 §8.
- ítem 5: política LOPDGDD para menores (bloquea sync real).
- ítem 6: verificación científica de los `[DATO A VERIFICAR]` del catálogo seminal.
- ítem 7: traducciones eu/ca por hablantes nativos.
- ítem 8: captación de 12-15 familias voluntarias.
- ítem 10: encargo a ilustradora botánica (NO IA generativa, biblia §8.1).
- ítem 11: auth de profesor/cuidador.

Tests: 153 verde en el-cuaderno (Dart) + smoke PHP `test_el_cuaderno.php` y `test_tutor_cuaderno.php` verde + paridad P5 12/12.

**S1 (referencia histórica)** — bootstrap del scaffolding según el prompt operativo del paquete documental:

```
apps/el-cuaderno/
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
├── lib/
│   ├── main.dart
│   ├── dominio/                            # Observacion, SitSpot, Misterio, PaginaCuaderno, NivelConfianza, RepositorioLocal
│   ├── infraestructura/isar/               # modelos Isar + setup + impl repositorio
│   ├── vista/
│   │   ├── tema/                           # colores + tipografia
│   │   ├── pantalla_cuaderno/              # home + tarjetas
│   │   ├── pantalla_observacion/           # form + selectores
│   │   └── pantalla_tutor/                 # canned response
│   ├── nucleo/i18n/                        # gen_l10n nativo + ARBs
│   └── datos_simulados/                    # seed.dart (kDebugMode)
└── test/
    ├── dominio/
    └── vista/
```

## Decisiones técnicas tomadas (S0)

- **Stack distinto al resto del monorepo**: Isar Community con cifrado en reposo (no shared_preferences), prescrito por doc 03 §2. Es el primer paquete del monorepo que usa Isar — adopción acotada al juego, no asciende al core en S1.
- **Sin Flame** ni Riverpod: Flutter widgets puros + ChangeNotifier/ValueNotifier. El Cuaderno no tiene gameplay con animación significativa — toda su UI son listas, tarjetas, formularios.
- **Identificadores provisionales `el-cuaderno`**: directorio `apps/el-cuaderno/`, `game_id='el-cuaderno'`, prefs/Isar namespace `nuevoser.elcuaderno.*`, endpoints `/nuevo-ser/v1/el-cuaderno/*`. Biblia §10.1 deja explícito que el nombre se cierra en piloto; cualquier alternativa hoy es igualmente provisional.
- **Colisión nominal con feature `cuaderno` del companion**: pendiente de resolver renombrando la feature companion a `bitacora` antes de S2 (cuando integremos con companion). En S1 no muerde porque no se toca companion.
- **Nombres descriptivos en castellano** para variables/clases/archivos. Términos técnicos (widget, builder, dispose, copyWith) en original.
- **i18n con `gen_l10n` nativo de Flutter** (no `intl_utils`). ARB castellano completo desde el día cero; eu/ca con placeholders `TODO_EU` / `TODO_CA` por string para que el equipo de localización los traduzca.
- **Sentence case** siempre. Nunca Title Case ni MAYÚSCULAS.

## Reglas de interacción

- **Nunca cargar los 15 docs a la vez** — solo los de la fase. Los más usados en S1: 01 (biblia), 04 (voces), 13 (flujos), prompt-claude-code.
- **Voz del Cuaderno antes que ergonomía**. Cualquier microcopia nueva debe pasar el test de §2.3 doc 04. Si una frase no podría salir de "una bióloga con cuarenta años en el monte", se reescribe.
- **Privacidad antes que ergonomía**. Si una decisión choca con el principio 1 o el 9 de la biblia, se elige privacidad y se sobrelleva la fricción.
- **Tests antes del código no visual**: dominio (validaciones, json roundtrip), motor (cuando se aborde P5).
- **Cuestionar antes de inventar**: si el operador pide algo que parece violar un hard limit, te niegas y citas el documento.
- **Commits pequeños**: <10 archivos salvo setup inicial.
- **Co-autoría con Claude**: trailer en cada commit.

## Cosas que NO hacer

- No añadir librerías sin discutirlo. Las del bootstrap original están listadas en el prompt §"PUBSPEC" y son cerradas: flutter, flutter_localizations, isar, isar_flutter_libs, uuid, path_provider. Dev: flutter_test, isar_generator, build_runner. NADA de firebase, sentry, dio. **Añadidas tras decisión explícita en S2-D**: `http`, `crypto`, `shared_preferences`, `nuevo_ser_core` (path).
- No añadir librerías para PDF (`pdf`), mapa (`flutter_map`), geolocalización (`geolocator`) sin que cierre primero la decisión humana (memoria `project_el_cuaderno_decisiones_humanas_pendientes` ítems 13-16).
- No tocar `apps/uno-roto/`, `apps/las-versiones/`, `packages/*`, `wp-plugin/*` desde aquí.
- No reescribir los docs de `docs/el-cuaderno/`. Son copia desde el paquete documental fuente.
- No introducir XP, niveles visibles, rachas, badges, fanfarria, animaciones de "¡bien hecho!". Si te sale espontáneamente, lo borras.
- No subir nada al remoto sin permiso explícito del operador.

## Comandos habituales

```bash
# Desde apps/el-cuaderno/ del monorepo:
flutter pub get
dart run build_runner build --delete-conflicting-outputs    # genera modelos Isar
flutter analyze
flutter test
flutter run -d linux

# Flutter path (no está en PATH del sistema):
export PATH="$HOME/flutter/bin:$PATH"
```
