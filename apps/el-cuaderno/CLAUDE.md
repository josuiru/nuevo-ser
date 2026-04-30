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

**S0 → S8 + Bloque A (A1-A10) completos**, S9 (piloto) bloqueado por validaciones humanas (memoria `project_el_cuaderno_decisiones_humanas_pendientes`).

**Bloque A — del "código completo" al "instalable y probable"** (plan `~/.claude/plans/bubbly-gathering-pretzel.md`):

- **A1** — plataformas Android (Java 17, Gradle 8.5, AGP 8.1.0, Kotlin 1.9.20, compileSdk 35) + Linux generadas con `flutter create --platforms=android,linux`. Patrón heredado de `apps/uno-roto/`. APK debug compila.
- **A2** — onboarding multi-perfil: tras elegir idioma, segundo paso "¿cómo te llamas?" persiste el nombre como nombre del perfil activo en `GestorPerfiles` con namespace `nuevoser.elcuaderno.perfil.*`. `RepositorioPerfilCuaderno` fino sobre el gestor del core.
- **A3** — foto vía `image_picker ^1.1.2`. `SelectorImagen` (abstract) + `SelectorImagenImagePicker` con cámara y galería; `AlmacenadorMedios` con `proveedorDirRaiz` inyectable mueve el `XFile` a `medios/<obs-id>_<tipo>.<ext>` bajo el directorio de documentos privado de la app. `Observacion.fotoRutaLocal` guarda la ruta relativa, nunca cruza red. Permisos `CAMERA` + `READ_MEDIA_IMAGES` en `AndroidManifest.xml`.
- **A4** — lienzo de dibujo espartano (`PantallaLienzoDibujo` con `CustomPainter` y `RepaintBoundary.toImage(pixelRatio: 2)`): una sola tinta negra gruesa (PaletaCuaderno.tinta), gesto pan, "borrar y empezar otra vez" + "guardar". Sin paleta, sin presión, sin deshacer multi-paso. UX rica queda para B6 (decisión de la ilustradora).
- **A5** — `ExportadorCuaderno.version = 2` con manifiesto opcional de medios (`InfoMedioExportado: {ruta_relativa, existe, tamano_bytes}`) por cada ruta única apuntada por las observaciones; `aJson` async con `resolverMedio?` opcional; `deJson` lee v1 (compat sin manifiesto) y v2; `versionesSoportadas = [1, 2]`. `main.dart` cabla `_resolverMedioParaExport` con `AlmacenadorMedios.resolverAbsoluta` + `dart:io` para sondear `existe` y `length`. Las rutas siguen siendo relativas al directorio de documentos del perfil — no base64; portar el cuaderno a otro dispositivo es un export-zip futuro.
- **A6** — pantalla de login del adulto. `ClienteAuthCuaderno` fino (POST /wp-json/nuevo-ser/v1/login) devuelve `ResultadoLogin` sealed (`LoginExito` / `LoginCredencialesIncorrectas` / `LoginSinPerfilDeNino` / `LoginErrorRed`). `BloqueLoginAdulto` en Ajustes (visible siempre, no debug-only) con email+password+autofill, persiste token+email en `RepositorioCuentaBackend` y notifica `alCambiarToken` para que el `FutureBuilder` del Tutor recompute. **Registro NO se hace in-app** — el adulto crea la cuenta primero por web (LOPDGDD ítem 5 memoria); aquí sólo se vincula. `_BloqueTutorDebug` se conserva tras `kDebugMode` para casos sin cuenta real.
- **A7** — iconos launcher + splash placeholder con paleta del cuaderno (hoja monocroma verde bosque #49583B sobre crema #F5EFE2). `flutter_launcher_icons ^0.14.1` + `flutter_native_splash ^2.4.1` cableados desde `pubspec.yaml` con assets en `assets/launcher/` y `assets/splash/`. **Sustituir por icono final de la ilustradora botánica (B4 del plan, biblia §8.1: hecho a mano, NUNCA IA generativa).**
- **A8** — catálogo de Misterios completo: el seed pasa de 7 a **19 misterios** literales del `docs/el-cuaderno/catalogo-seminal-misterios.md` (5 marcados `abierto: true`). El comité científico (B1) los puede modificar luego sin tocar el cliente.
- **A9** — README con instrucciones para construir APK debug, instalar en dispositivo, smoke manual del flujo completo y smoke contra WordPress local. Cierre del Bloque A.
- **A10** — política de privacidad y términos en `docs/el-cuaderno/legal/` marcados como **BORRADOR pendiente de revisión legal LOPDGDD (B3)**. Enlazados desde `pantalla_configuracion_inicial.dart` con un `_EnlacePolitica` discreto + AlertDialog.

**Bloque B — fallbacks de experto** (avance progresivo, marcados como pendientes de revisión humana en código y commits):

- **B5 (parcial)** — `geolocator ^10.1.0` cableado vía `ServicioGeolocalizacionPlugin` que implementa el contrato `dominio/geolocalizacion_privacy_first.dart`. Workaround en `android/build.gradle` para propagar `flutter.compileSdkVersion` a subproyectos (excepto `:app`) tras downgrade desde 11.x. **Consumido por `PantallaObservacion` y `PantallaCrearSitSpot` con bloque opt-in "anclar mi posición"**: pre-permiso AlertDialog con voz adulta amable provisional ("la posición se queda en este cuaderno y no sale a internet, no la ve el adulto"), después llama a `permiso()` + `pedirPermiso()` + `coordenadasActuales()`, persiste en `Observacion.dondeCoordenadas` o `SitSpot.coordenadas` (Isar local — la frontera de privacidad de `cliente_el_cuaderno.dart` ya impide que crucen red). Avisos amables específicos para denegado/denegado permanente/GPS sin lectura. `confirmarPrePermisoGeoOverride` para tests con fakes en línea. Pre-permiso marcado **VOZ-ADULTA-PROVISIONAL pendiente de asesoría psicológica B8**. MBTiles + `flutter_map` quedan pendientes.
- **Sit spot in-app** — hasta este punto el sit spot sólo existía vía seed de debug; no había forma para el niño de crearlo desde la app, lo que dejaba el corazón pedagógico (biblia §3.5 "habitar un lugar") inaccesible. Ahora la tarjeta de invitación del home (estado "todavía no tienes sit spot") es pulsable y abre `PantallaCrearSitSpot` con campo nombre obligatorio + campo dondeNombre opcional + bloque opt-in para anclar coordenadas si el servicio de geo está cableado. Tras pulsar "guardar sit spot", `establecerSitSpot()` lo persiste en Isar y la pantalla principal recarga el estado. Mismo patrón de inyección que las pantallas existentes — closures opcionales para tests aislados.
- **Jubilar sit spot in-app** — doc 13 §2.6: el niño puede cerrar el ciclo del sit spot. La tarjeta activa expone un menú overflow (`PopupMenuButton`) discreto con la opción "jubilar este sit spot"; al pulsarlo, AlertDialog amable explica que la página seguirá guardada pero no podrá registrar más observaciones. Tras confirmar, `establecerSitSpot()` recibe el actual con `retiradoEn = now` y la pantalla recarga, volviendo a la tarjeta de invitación pulsable. Bug fix de paso: `RepositorioMemoria.obtenerSitSpot()` ahora filtra por `retiradoEn == null`, alineándolo con `RepositorioIsar` (la inconsistencia hacía pasar el flujo en producción pero los tests con repo en memoria veían el sit spot jubilado como si siguiera activo).
- **Sit spots jubilados accesibles** — la confirmación de jubilación promete "la página seguirá guardada en el cuaderno". Ahora hay UI que cumple esa promesa: nuevo `obtenerSitSpotsJubilados()` en el contrato del repo (`RepositorioIsar` filtra por `retiradoEn != null` orden desc; `RepositorioMemoria` mueve in-place al jubilar y ordena igual), `PantallaSitSpotsJubilados` lectura pura con cabecera, dondeNombre y "estuvo activo del DD/MM/AAAA al DD/MM/AAAA", y bloque "Sit spots de antes" en Ajustes que sólo aparece si la lista no está vacía (FutureBuilder discreto). El niño puede volver a sus páginas de antes sin que le distraigan del sit spot activo.
- **Observaciones del sit spot jubilado en su página** — cada tarjeta del listado muestra el contador "N observaciones guardadas" y es pulsable para abrir `PantallaPaginaSitSpotJubilado`: cabecera con metadatos del sit spot + listado de observaciones (lectura pura, fecha + queVio + creesQueEs/confianza). El repo se inyecta como opcional para que los tests aislados puedan instanciar el listado sin simular navegación.
- **Última visita al sit spot** — `SitSpot.ultimaVisita` se actualiza automáticamente al guardar una observación contra el sit spot activo. La tarjeta del home formatea como "hace N días"; antes el seed sembraba un valor estático que nunca cambiaba.
- **Limpieza de medios huérfanos al borrar todo** — el flujo "borrar mi cuaderno" prometía vaciar el cuaderno, pero hasta este punto sólo borraba Isar; las fotos y dibujos seguían en el subdirectorio `medios/` del directorio de documentos del perfil aunque la observación que los apuntaba ya no existiera. Nuevo `AlmacenadorMedios.borrarTodo()` purga el subdirectorio entero (idempotente: si no existe devuelve 0; tras una llamada exitosa la siguiente también devuelve 0). `PantallaAjustes` acepta el `AlmacenadorMedios?` opcional y, si llega no-null, lo invoca tras `borrarTodoLoLocal()`. El snackbar de cierre añade el contador honesto al feedback ("3 observaciones · 1 misterios · 1 sitSpots · 4 medios"). En tests sin filesystem se omite la inyección y el flujo sigue tal cual.
- **Onboarding pedagógico del sit spot** — la biblia §3.5 marca el sit spot como corazón pedagógico ("habitar un lugar"), pero hasta este punto el niño aterrizaba en home con la palabra "sit spot" en una tarjeta-invitación sin contexto previo. Nueva `PantallaPresentacionSitSpot` se intercala como cuarto camino del orquestador (tras idioma + nombre, antes de home), una sola vez en la vida del cuaderno: presenta el concepto en tres párrafos en voz adulta amable ("un banco del parque, una piedra junto al río…", "lo importante no es que sea bonito; es que puedas volver", "cuando lo encuentres, le pones nombre"). Doble botón sin urgencia: **"ya pienso en uno"** (intención de habitar) y **"todavía no"** (sin penalización ni rachas; biblia §2.7 ritmo respetuoso). Ambos marcan `nuevoser.elcuaderno.presentacion_sit_spot.vista=true` vía `RepositorioPresentacionSitSpot` y caen al home — la diferencia hoy es informativa, abierta a auto-abrir el formulario de crear en el futuro si la asesoría didáctica B1 lo recomienda. Persistencia global por dispositivo (no por-perfil; documentado en el repo para migrar al patrón `<ns>.perfil.<id>.<sufijo>` cuando entre soporte multi-perfil real).
- **B6** — lienzo enriquecido con enum `AnchoTrazo`, undo del último trazo, barra de muestras de ancho. Marcado como "fallback de experto pendiente de ilustradora botánica (B4)" — paletas, presión, ricas dependencias visuales se diferirán al encargo de la ilustradora.
- **B9 (parcial)** — `pdf ^3.11.1` + `printing ^5.13.0` cableados vía `ExportadorCuadernoPdf.aBytes()`: portada con nombre del niño, sit spot, Misterios abiertos, observaciones. Times Roman, paleta provisional. Marcado pendiente de WCAG 2.1 AA + tipografía/paleta definitiva (B4 + auditoría accesibilidad).
- **B11 (parcial)** — `dominio/fenologia.dart` extendido con `estacionesEnTransicion()` (margen ±15 días sobre cortes astronómicos) y `NotasFenologicasIberia.para()` con dos capas: (1) NUTS-3 con afirmaciones temporales específicas (ES-NA-PA, ES-BI, ES-MD) — más vulnerables a fechas mal puestas; (2) autonómicas con afirmaciones genéricas (ES-CT, ES-AN, ES-AS, ES-GA, ES-CN) que se limitan a geografía/climatología/biología obvia (encinas aguantan calor, alisios refrescan en Canarias, gradiente costa↔Pirineo en Cataluña) sin fechas ni especies-clave que requieran calendario territorial. La búsqueda jerárquica NUTS-3 → NUTS-2 → ES significa que ES-CT-T (Tarragona) ahora cae a ES-CT, no al fallback país. Todo marcado pendiente de calendario curado por ornitólogos/botánicos.
- **B2 (parcial)** — strings visibles principales traducidos en `app_eu.arb` y `app_ca.arb`: tituloApp (Koadernoa/El Quadern), navs, saludos, observación, niveles de confianza, Tutor, Ajustes. El resto sigue con prefijo `TODO_` para que las traductoras nativas lo cierren con criterio terminológico naturalista.
- **B7 (cliente + UI)** — paquete `nuevo_ser_companion` añade `ClienteAuthAdulto` (POST /auth/login con shape `{email, password, rol}`), `crearAula` (POST /classrooms) y `obtenerAgregadosAula` (GET /classrooms/{id}/aggregates). Modelos `RolAdulto`, `ResultadoLoginAdulto` (sealed), `AulaCreada`, `AgregadosAula`. `el-cuaderno` cabla dos pantallas nuevas: `PantallaLoginProfesor` (independiente del bloque del adulto-cuidador) y `PantallaAulaProfesor` (formulario de creación de primera aula → dashboard con cabecera, code, member/reporting count y agregados por juego; mensaje k≥5 sin culpar; botón "cerrar sesión" en AppBar). Acceso desde Ajustes vía bloque "Acceder como profesor". Persistencia: `nuevoser.elcuaderno.token_profesor`, `nuevoser.elcuaderno.email_profesor`, `nuevoser.elcuaderno.profesor.aula_activa`. Sesión persiste; reabrir la app entra directo al dashboard. Marcado como **fallback de experto pendiente de policy escolar definitiva** (LOPDGDD para menores en aulas + cómo se vincula `nino_id` ↔ `classroom_id` por el lado del niño).

Tests: 277 verde en el-cuaderno (Dart) + 51 en `nuevo_ser_companion` + smoke PHP verde + paridad P5 12/12 + paridad calibración Brier verde. APK debug compila.

**Bloque B — pendiente de decisiones humanas**, no bloquea piloto interno (familias del operador) pero sí piloto público:
B1 validación científica catálogo · B2 traducciones eu/ca (parcial: strings principales hechos como fallback de experto) · B3 LOPDGDD + política privacidad real · B4 ilustradora botánica · B5 `geolocator` + `flutter_map` + MBTiles (parcial: geolocator + bloque opt-in en PantallaObservacion; copy de pre-permiso provisional pendiente de B8; flutter_map + MBTiles pendientes) · B6 UX rica del dibujo (parcial: AnchoTrazo + undo) · B7 auth profesor + vista aula (cliente + UI hechos como fallback; policy escolar pendiente) · B8 asesoría psicológica caso 1 doc 15 (bloquea cierre del copy de pre-permiso de geo) · B9 WCAG 2.1 AA + paquete `pdf` (parcial: pdf cableado) · B10 captación 12-15 familias · B11 calendario fenológico curado (parcial: 3 NUTS-3 con afirmaciones específicas + 5 autonómicas con afirmaciones genéricas conservadoras) · B12 firma release Android + canal distribución.

**S0 completo** (rama `feature/el-cuaderno-bootstrap`):
- 15 docs del paquete documental copiados a `docs/el-cuaderno/` (renombrados sin prefijo `el-cuaderno-` para encajar con el patrón que el `prompt-claude-code.md` espera).
- Esta `CLAUDE.md` redactada.
- Sin entrada explícita en `melos.yaml` porque ya usa `apps/*` glob — basta con que exista `pubspec.yaml`.

**S1 completo** — bootstrap del scaffolding cableado a Isar + dominio + UI.

**S2 completo** — backend WP (`NS_El_Cuaderno`: observaciones, sit-spot, misterios) + cliente Dart con frontera de privacidad (`what_seen_hash`, no lat/lng) + cola de sync con reglas de recuperabilidad (4xx irrecuperable salvo 401/408/429, 5xx reintenta). M003 con tablas `ns_observations`, `ns_sit_spots`, `ns_mysteries_catalog`. Renombrado feature companion `cuaderno` → `bitacora` para evitar colisión. **Cola cableada en main**: `_OrquestadorJuego` instancia `ClienteElCuaderno` + `ColaSyncObservaciones`; cada observación nueva pasa por `marcarPendiente` y el bloque opt-in "Sincronizar mis observaciones" en Ajustes invoca `intentarEnviar` cuando el adulto pulsa. Sin auto-sync, sin push.

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
