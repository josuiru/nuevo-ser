# El Cuaderno — Decisiones provisionales pendientes de revisión humana

Este documento es el registro vivo de las **16 decisiones humanas que el código no puede resolver**. Se mantiene en sincronía con la memoria persistente `project_el_cuaderno_decisiones_humanas_pendientes` y con el estado del código hoy.

Cada ítem se clasifica en uno de tres grupos:

- **Grupo 1 — No tocar sin experto**: el riesgo de tomar decisión propia (legal, pedagógico, científico, lingüístico, emocional) supera el beneficio de avanzar. Se apunta la pregunta concreta para el experto.
- **Grupo 2 — Decisión provisional pragmática**: el código toma una decisión sostenible hoy y deja la nota de revisión para cuando llegue la respuesta definitiva.
- **Grupo 3 — Operativo, no técnico**: trabajo del operador o del piloto, no se cierra escribiendo código.

**Estado actual** (2026-05-07): el-cuaderno cubre todo el flujo del niño y del cuidador, está completamente i18n-ready (~125 claves en es/eu/ca), 610 tests verde, `flutter analyze` limpio. El piloto **interno con la familia del operador** se puede arrancar. El piloto **público** sigue bloqueado por los ítems del grupo 1.

---

## Grupo 1 — No tocar sin experto

### #1 — Asesoría didáctica del mapa de habilidades

- **Fase de proceso**: Fase 2 oficial.
- **Estado del código**: 59 habilidades atómicas en 9 dominios (PRE/OBS/REG/TAX/REL/CIC/HAB/HIP/TEJ) están definidas en `docs/el-cuaderno/02-mapa-habilidades-atomicas.md`. Algunas marcadas `[?]`.
- **Asunción provisional**: ninguna. Las habilidades `[?]` no se ejercitan en piloto interno; sólo entran en piloto público tras revisión.
- **Pregunta concreta para el experto**: ¿Las habilidades marcadas `[?]` son atomicas y observables? ¿El orden pedagógico dentro de cada dominio refleja un currículum espiral coherente con LOMLOE primaria ciclos 2 y 3?
- **Qué cambia con la respuesta**: ajuste fino de pesos del perfil P5 compuesto en `nuevo_ser_core` y orden pedagógico del catálogo de Misterios.

### #2 — Asesoría psicológica infantil sobre el caso 1 doc 15 §8

- **Fase de proceso**: Fase 2 oficial. Bloquea S7 del lado del cuidador.
- **Estado del código**: `dominio/agregado_semanal.dart` y `pantalla_cuidador.dart` exponen métricas y la pregunta para la cena, pero **no detectan angustia**. El copy del pre-permiso de geolocalización (`PantallaCrearSitSpot._mostrarPrePermisoUbicacion`, `PantallaObservacion._mostrarPrePermisoUbicacion`) sigue marcado `VOZ-ADULTA-PROVISIONAL` en CLAUDE.md.
- **Asunción provisional**: el sistema **no intenta detectar angustia** automáticamente. Si el adulto-cuidador ve algo preocupante en el resumen, decide en persona qué hacer. El copy del pre-permiso describe lo que pasa con la posición, sin frases que un experto pudiera juzgar emocionalmente arriesgadas.
- **Pregunta concreta para el experto**: ¿Tiene sentido pedagógico-emocional añadir alguna detección de angustia, o el silencio es el contenido (biblia §2.7)? Si sí, ¿qué señales y qué umbrales? ¿El copy del pre-permiso de geo es seguro o puede crear ansiedad ("posición / no la ve el adulto / es opcional")?
- **Qué cambia con la respuesta**: posible nuevo módulo `dominio/deteccion_emocional.dart` o reescritura del copy del pre-permiso. Hoy ese copy vive en `app_es.arb` claves `crearSitSpotPrePermisoMensaje` y `observacionPrePermisoMensaje`.

### #4 — Validación técnica de la arquitectura por ingeniero sénior

- **Fase de proceso**: Fase 3 oficial.
- **Estado del código**: el-cuaderno usa Isar 3 Community (sin cifrado en reposo nativo), shared_preferences con namespace, `nuevo_ser_core` para motor adaptativo P5 + storage por perfil. Sincronización HTTP con `nuevo_ser_companion` cliente + WP plugin servidor.
- **Asunción provisional**: la arquitectura es la documentada en `docs/el-cuaderno/03-arquitectura-tecnica.md`. Cualquier cambio mayor (Riverpod, sealed pattern para sync, persistencia en Isar v4 con cifrado) se difiere hasta la validación.
- **Pregunta concreta para el experto**: ¿El perfil P5 compuesto (precisión + rúbrica + cobertura + proxy con pesos por habilidad) es robusto frente a sesgos de muestreo? ¿La frontera de privacidad estructural (texto libre + coords + fotos + dibujos en Isar local; sólo metadatos hash al servidor) es estanca?
- **Qué cambia con la respuesta**: posible refactor del motor en `packages/nuevo_ser_core` o de la cola de sync.

### #5 — Política de privacidad LOPDGDD para menores

- **Fase de proceso**: Fase 3 oficial. Bloquea sincronización real al servidor.
- **Estado del código**: hay una política provisional en `docs/el-cuaderno/legal/` marcada como **BORRADOR pendiente de revisión legal LOPDGDD (B3)**. La pantalla de configuración inicial enlaza a un AlertDialog que muestra el resumen amable.
- **Asunción provisional**: el texto del AlertDialog (`configuracionInicialPoliticaTitulo` + cuerpo en `pantalla_configuracion_inicial.dart`) explica al niño qué se guarda dónde, sin afirmaciones legales vinculantes. El BORRADOR completo vive como documento separado para que el adulto lo revise, no como contrato firmado.
- **Pregunta concreta para el experto**: ¿La política BORRADOR cumple LOPDGDD para menores de 14 años? ¿Necesita consentimiento del adulto explícito antes del primer arranque? ¿La frontera de privacidad estructural (sin texto libre cruzando red, sólo hashes y NUTS-3) es suficiente para considerar que no hay tratamiento de datos personales del menor?
- **Qué cambia con la respuesta**: posible flujo de consentimiento del adulto antes del onboarding del niño, ajuste del copy en `app_es.arb` y publicación de la política definitiva.

### #6 — Verificación científica de los `[DATO A VERIFICAR]` del catálogo seminal

- **Fase de proceso**: Fase 4 (piloto).
- **Estado del código**: 19 Misterios seminales viven en `lib/datos/seed_misterios.dart` (tomados literales de `docs/el-cuaderno/catalogo-seminal-misterios.md`). Cada uno con campos `seasons`, `regions`, descripción y pregunta canónica. Algunos llevan `[A VERIFICAR]` en su descripción larga.
- **Asunción provisional**: los Misterios se muestran al niño con la información disponible. La función pedagógica del Misterio (preguntar abierta, anclar evidencia, declarar la propia respuesta) **no requiere certeza científica absoluta** — el niño no memoriza datos del catálogo, **observa y anota**. La voz del cuaderno (biblia §2.5 humildad) ya admite "no estoy seguro" como nivel de confianza válido.
- **Pregunta concreta para los expertos** (SEO/BirdLife, RJB-CSIC, naturalistas regionales): de los 19 Misterios, ¿cuáles tienen errores factuales en la descripción larga? ¿Qué Misterios añadirías o quitarías para una primera ronda regional (ES-NA-PA, ES-BI, ES-MD)?
- **Qué cambia con la respuesta**: edición de `catalogo-seminal-misterios.md` y `seed_misterios.dart`. El comité científico puede modificarlos sin tocar código cliente porque el seed es fácil de regenerar.

### #7 — Traducciones a euskera y catalán por hablantes nativos

- **Fase de proceso**: Fase 4 (piloto).
- **Estado del código** (actualizado 2026-05-07): `app_eu.arb` y `app_ca.arb` tienen ~330 claves cada uno tras múltiples oleadas l10n. **Cobertura ~100% de superficies visibles** del cuaderno: navegación, saludos, sit spot completo (presentación + crear + activo + jubilados + página), observación, Misterios (catálogo + UI), preguntas del niño, mapa + opt-in, Tutor (UI + Ajustes), Ajustes (acceder profesor + cuidador + tutor debug + idioma + sit spots jubilados + mapa + borrar todo + acerca de completo), Aula del profesor, login profesor, agregado semanal, lienzo (tooltips + Semantics labels de ancho/herramienta/color), PDF imprimible (vía nueva value class `EtiquetasPlantillaPdf`), pantalla "acerca de" entera (~150 strings pedagógicos en `acerca*`). Catálogo de Misterios seminales tiene traducciones provisionales para los 19/19 mediante `MisterioTexto` map por locale en `_traduccionesProvisionales` del seed. **No traducidas por diseño**: pantalla trilingüe de elección de idioma (Hola/Kaixo/Hola, ¿En qué idioma...?), nombres nativos de los idiomas. **Cuerpo del diálogo de privacidad** ya viaja por ARB (`configuracionInicialPoliticaCuerpo`) con traducción provisional eu/ca — sustituible sin tocar código cuando entre la versión definitiva LOPDGDD (B3).
- **Calidad**: catalán sólido (operador + Claude); euskera estructural pero **no nativo** — gramática y vocabulario común correctos, pero terminología naturalista (sit spot, hipótesis activa, líquenes, plátano de sombra, especie, consenso) requiere validación nativa.
- **Pregunta concreta para los expertos** (Elhuyar, Aranzadi, IEC):
  1. Validar el vocabulario naturalista en eu/ca de los 19 Misterios seminales (`_traduccionesProvisionales` en `lib/datos_simulados/seed.dart`).
  2. Revisar el tono general de la UI (`app_eu.arb`, `app_ca.arb`) buscando expresiones que un niño bilingüe note como "no encajan".
  3. Cerrar las strings que se conservan en castellano puro (claves sin traducción nativa) cuando lo justifique pedagógicamente.
- **Qué cambia con la respuesta**: sustituir las strings provisionales en los ARBs y en `_traduccionesProvisionales`. Cero código cambia.

---

## Grupo 2 — Decisión provisional pragmática

### #3 — Decisión de nombre definitivo del juego

- **Estado actual**: el juego se llama **"El Cuaderno"** en todos los textos visibles, identificadores de paquete (`apps/el-cuaderno/`), `game_id='el-cuaderno'`, namespace de prefs (`nuevoser.elcuaderno.*`) y endpoints (`/nuevo-ser/v1/el-cuaderno/*`).
- **Decisión provisional**: mantener "El Cuaderno" hasta el cierre del piloto público. Las alternativas de biblia §10.1 (*Aún*, *La Casa*, *Bitácora*) se evalúan **por evidencia del piloto**, no por preferencia a priori.
- **Coste de cambiar más tarde**: bajo en código (rename mecánico) pero alto en cola de sync, claves de prefs migradas, builds firmados. Marcado en CLAUDE.md como decisión que se cierra en piloto.
- **Apuntado para revisión**: cierre piloto público.

### #10 — Encargo a ilustradora botánica humana profesional

- **Estado del código**: icono launcher + splash placeholder en paleta del cuaderno (hoja monocroma verde bosque #49583B sobre crema #F5EFE2). `flutter_launcher_icons` y `flutter_native_splash` cableados desde `pubspec.yaml`.
- **Decisión provisional**: el icono y el splash son **placeholder vivo** marcado en CLAUDE.md y aquí. El usuario instala la app sabiendo que el arte definitivo no ha llegado. Biblia §8.1 prohíbe IA generativa para **ilustraciones del catálogo de Misterios**, así que **NUNCA** se sustituye el placeholder con imágenes generadas — sólo con encargo humano cuando llegue.
- **Coste estimado**: ~75-80 ilustraciones, 10-25k€ (presupuesto del operador, no del código).
- **Apuntado para revisión**: cuando llegue el encargo, sustituir assets en `assets/launcher/` y `assets/splash/`. **El lienzo del niño NO depende de este encargo** — su paleta y herramientas se cierran en el ítem dedicado al lienzo de abajo.

### #B6 — Lienzo de dibujo del niño (DECISIÓN CERRADA 2026-05)

- **Estado anterior**: la biblia §8.1 prescribía "una sola tinta" para el lienzo del niño, citando carbón/tinta sobre papel. La versión MVP (A4) era espartana: trazo único negro, sin colores, sin herramientas. Versión enriquecida B6 añadió `AnchoTrazo` (3 grosores) y undo del último trazo.
- **Decisión cerrada por el operador 2026-05**: la prescripción "NUNCA IA generativa, hecho a mano" de biblia §8.1 se refiere a las **ilustraciones del catálogo editorial** (que sí esperan encargo humano #10). Para el lienzo del niño, la decisión la cierra el operador con criterio de **cuaderno de campo naturalista**, porque el niño dibuja con el dedo (siempre hecho a mano por definición).
- **Razón pedagógica**: el naturalista profesional (John Muir Laws *Laws Guide to Nature Drawing*, Roger Tory Peterson, Anita Albus) lleva paleta limitada de tonos terrosos en su mochila — **el color es diagnóstico**: un mirlo y un escribano cerillo se diferencian por color, no por silueta. Forzar al niño al monocromo le quita una herramienta central de identificación y se aleja del oficio que el cuaderno enseña (biblia §3.3 identificar con humildad).
- **Cierre**:
  - **Paleta**: 5 tonos terrosos no saturados, `enum ColorTrazo`. Tinta `#2A2A2A`, sanguina `#8B3A3A`, sepia `#5C4033`, ocre `#B8860B`, verde botánico `#3A5F3A`. Ningún rosa, azul eléctrico ni fluorescente.
  - **Anchos**: 3 grosores, `enum AnchoTrazo` (fino 1.5 px, medio 3 px, grueso 6 px).
  - **Herramientas**: 4, `enum Herramienta`. Plumilla (opacidad 1.0), lapicero (opacidad 0.5), carboncillo (opacidad 0.7 + ancho ×1.5), goma (toca trazo lo retira; reversible con undo).
  - **Lo que se mantiene**: hecho a mano (sin IA generativa), sin pinceles ricos digitales, sin efectos, sin gradientes, sin rellenos, sin capas, sin texto. Sigue siendo cuaderno, no editor.
  - **Bug fix asociado**: `_PintorLienzo.shouldRepaint` ahora compara firmas hash del estado capturadas en construcción del painter, no la lista mutable directa que era la misma referencia en ambos lados del setState. Reportado en piloto interno como "le doy con el dedo y no se pinta nada".
- **Modificación de la biblia**: el doc-string de `PantallaLienzoDibujo` documenta esta decisión en su lugar canónico. La biblia §8.1 del paquete documental v0.1 vive fuera del repo del juego; cuando se actualice, debe pasar de "una sola tinta" a "paleta limitada del cuaderno de campo (5 tonos terrosos), sin saturaciones digitales, sin pinceles ricos, sin efectos. Para ilustraciones del catálogo editorial, encargo humano (NUNCA IA generativa)".
- **Apuntado para revisión**: ninguna pregunta pendiente para experto externo. Si el piloto público con familias muestra que el niño no usa una herramienta concreta (carboncillo, lapicero) o que pide más, se itera con evidencia real, no con asunción a priori.

### #11 — Auth de profesor/cuidador (B7)

- **Estado del código**: `nuevo_ser_companion` exporta `ClienteAuthAdulto` con `iniciarSesion(email, password, rol)`. `el-cuaderno` cabla `PantallaLoginProfesor` y `PantallaAulaProfesor` con persistencia de token en `nuevoser.elcuaderno.token_profesor`. JWT del backend distingue rol del adulto. Las pantallas son **fallback de experto pendiente de policy escolar definitiva**.
- **Decisión provisional**: el flujo del profesor funciona end-to-end contra el backend. Permite a un profesor crear aula, repartir code y ver agregados k≥5 sin culpar. El cuidador (rol distinto) **todavía no tiene UI propia** — bloqueado por #2 (asesoría psicológica).
- **Pregunta pendiente**: ¿Qué autoridad legal valida que el adulto-profesor o adulto-cuidador realmente es esa figura del niño? Esto es policy escolar/familiar, no técnica.
- **Apuntado para revisión**: cuando se decida la policy, posible cambio de claims del JWT y de la pantalla del cuidador.

### #12 — Calendario fenológico Iberia curado

- **Estado del código**: `dominio/fenologia.dart` con `NotasFenologicasIberia.para()` en dos capas: (1) **3 NUTS-3 piloto** (ES-NA-PA, ES-BI, ES-MD) con afirmaciones temporales específicas validadas por experto del operador, (2) **5 autonómicas** (ES-CT, ES-AN, ES-AS, ES-GA, ES-CN) con afirmaciones genéricas conservadoras (geografía/clima obvios) que no requieren calendario territorial.
- **Decisión provisional**: el sistema **degrada con elegancia** — fuera de las regiones piloto cae a la capa autonómica si existe, y a fallback país si no. El niño en una región sin calendario curado lee notas genéricas, no inventadas.
- **Pregunta pendiente para ornitólogos/botánicos**: extender la capa NUTS-3 a 30-40 marcadores por región piloto. Aportar fuentes (SEO/BirdLife regional, Atlas botánico de la región).
- **Apuntado para revisión**: ampliación del catálogo en `dominio/fenologia.dart` cuando lleguen las notas curadas. La estructura de datos ya soporta cualquier volumen.

### #13 — Tipografía y paleta de impresión

- **Estado del código**: `ExportadorCuadernoPdf` cableado con `pdf ^3.11.1` + `printing ^5.13.0`. Usa **Times Roman provisional** + paleta provisional. Marcado en CLAUDE.md como pendiente de tipografía/paleta definitiva (B4 + auditoría WCAG, B9).
- **Decisión provisional**: el PDF es legible y portable hoy. La portada lleva nombre del niño, sit spot, Misterios abiertos y observaciones con sus medios incrustados. **No hay decisiones tipográficas con identidad** — Times Roman es un fallback neutro, no una elección.
- **Apuntado para revisión**: cuando la ilustradora cierre paleta y tipografía (parte de #10), sustituir fuentes embebidas y colores en `lib/datos/exportador_pdf.dart`.

### #14 — Auditoría WCAG 2.1 AA

- **Estado del código**: ningún test automatizado de accesibilidad. Tema visual usa la paleta provisional botánica (#49583B sobre #F5EFE2). El lienzo y los formularios están en serif/sans del cuaderno con tamaños 11/12/13/14/17.
- **Decisión provisional**: depende del cierre de #13 (tipografía/paleta definitivas). Mientras, el operador hace **smoke manual** con el TalkBack de Android en cada release: navegación por gestos, lectura de labels, contraste a ojo.
- **Pregunta pendiente para auditor accesibilidad**: contraste de la paleta definitiva, tamaños mínimos para 9-13 años, semantics labels para iconos del bottom nav y del menú overflow, captions/alt-text para ilustraciones botánicas (cuando lleguen).
- **Apuntado para revisión**: ronda de auditoría WCAG 2.1 AA tras cierre de #10 y #13.

### #15 — Permisos `geolocator` Android/iOS

- **Estado del código**: `geolocator ^10.1.0` en `pubspec.yaml`. `AndroidManifest.xml` declara `ACCESS_COARSE_LOCATION` + `ACCESS_FINE_LOCATION` foreground only — **no background**. `Info.plist` (iOS) **no existe** porque el-cuaderno todavía no construye para iOS.
- **Decisión provisional**: Android está cerrado. iOS se abre el día que el operador decida construir para iOS, momento en el que se añade `Info.plist` con `NSLocationWhenInUseUsageDescription` con el copy explicativo del doc 13. El contrato `dominio/geolocalizacion_privacy_first.dart` ya está listo para recibir la implementación nativa.
- **Apuntado para revisión**: añadir `apps/el-cuaderno/ios/` con plataforma cuando el operador valide TestFlight como canal de distribución.

### #16 — `flutter_map` + tiles offline (MBTiles regional)

- **Estado del código**: `flutter_map ^7.0.2` + `latlong2 ^0.9.1` cableados con tiles **OSM online** detrás del opt-in del adulto (`RepositorioMapaOnlineOptIn`). El bloque de Ajustes deja explícito que activar el mapa implica enviar peticiones al servidor de OSM. Marker del sit spot y de observaciones con coordenadas.
- **Decisión provisional**: el mapa **funciona online tras consentimiento explícito del adulto**. La biblia §2.8 (offline-first) y §2.9 (sin extracción) se respetan porque el niño nunca dispara peticiones sin que un adulto haya pulsado el switch.
- **Pregunta pendiente para el operador**: ¿Qué proveedor de tiles para el modo offline? Opciones a evaluar:
  1. **MBTiles regionales servidos desde el propio backend** (necesita pipeline de generación, ~50-200 MB por región).
  2. **OpenMapTiles + servidor propio** (más control, más coste de infraestructura).
  3. **Stadia Maps / Mapbox tier gratuito** (cuotas estrictas, posible problema de privacidad).
- **Apuntado para revisión**: cuando se decida proveedor, añadir `RepositorioMapaOfflineDescargado` y un panel de descarga regional bajo demanda en Ajustes.

---

## Grupo 3 — Operativo, no técnico

### #8 — Captación de 12-15 familias voluntarias para piloto

- Trabajo del operador. No se cierra escribiendo código.
- Se sugiere que las familias voluntarias firmen consentimiento informado (depende de #5 LOPDGDD) antes de instalar el APK firmado (depende de B12).

### #9 — Decisión sobre Versión A (cuaderno vacío) vs B (cuaderno heredado) del cold start

- Se decide al cierre del piloto, comparando engagement, pegada pedagógica y voz del niño en ambas versiones.
- Mientras, el código soporta sólo la **Versión A** (cuaderno vacío). La Versión B requiere un seed personalizado por familia que no es trivial sin más datos del piloto.

---

## Decisión técnica adicional fuera de los 16 ítems

### Cifrado en reposo de Isar (Bloque B documentado en `infraestructura/isar/isar_setup.dart`)

- **Estado**: Isar 3 Community **no soporta** `encryptionKey`. La biblia §2.1 prescribe que texto libre, fotos, dibujos y coordenadas precisas vivan **cifrados en reposo**.
- **Decisión provisional**: para piloto interno (familia del operador) se acepta el riesgo — el dispositivo del niño está en casa y bajo supervisión adulta. El comentario en `infraestructura/isar/isar_setup.dart` documenta las cuatro opciones para piloto público:
  1. Migrar a **Isar v4** cuando esté estable.
  2. Migrar a **sqflite_sqlcipher**.
  3. Cifrar campos a mano con `crypto` de Dart antes de persistir.
  4. Licencia **Isar Pro** (de pago).
- **Apuntado para revisión**: decisión del operador antes de piloto público.

---

## Cómo se mantiene este documento

- **Por sesión**: cuando el código toque uno de estos ítems, actualizar el bloque correspondiente con (a) qué se hizo, (b) qué pregunta queda abierta. Mantener sincronía con la memoria persistente `project_el_cuaderno_decisiones_humanas_pendientes`.
- **Por fase**: al cierre de cada fase del proceso de Colección (Fase 2, 3, 4), revisar la lista entera y marcar lo cerrado.
- **Antes de piloto público**: ningún ítem del **Grupo 1** puede quedar abierto. Los del **Grupo 2** pueden quedar abiertos si la decisión provisional es defendible y está documentada; los del **Grupo 3** dependen del operador.
