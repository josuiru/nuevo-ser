# El Cuaderno — Prompt maestro para Claude Code

> Documento técnico operativo.
> Versión 0.1 — primer sprint (bootstrap).
> Para usar como prompt de inicio en Claude Code (terminal o VS Code).
> Genera el scaffolding inicial del juego dentro del monorepo de la Colección Nuevo Ser.

---

## Cómo usar este documento

Copiar el bloque marcado **PROMPT** (sección 4) y pegarlo en una nueva conversación con Claude Code, abierta en la raíz del monorepo `nuevo-ser/`. Antes de ejecutarlo, comprobar que las precondiciones de la sección 2 se cumplen.

El prompt está pensado para una **única sesión larga** que produce el scaffolding completo del primer sprint. No para iteraciones cortas.

---

## 1. Contexto del proyecto

`nuevo-ser/` es un monorepo Flutter que contiene los juegos de la Colección Nuevo Ser. Actualmente en producción:

- `apps/uno-roto/` — juego de matemáticas, MVP en desarrollo.
- `apps/las-versiones/` — juego de historia, esqueleto.
- `packages/nuevo_ser_core/` — plataforma compartida (cuentas, sync, mastery engine, i18n).
- `packages/nuevo_ser_companion/` — acompañamiento (cuaderno, mosaicos, vistas).
- `packages/nuevo_ser_tutor/` — cliente del tutor IA.
- `wp-plugin/nuevo-ser-core/` — backend WordPress (PHP).

Ver `nuevo-ser-core-arquitectura.md` para la arquitectura común.

Lo que vamos a añadir con este prompt: **`apps/el-cuaderno/`** — un nuevo juego cuya materia es el oficio del niño que mira despacio el lugar donde vive (ciencias naturales, ecología, observación de campo). Es el primer juego de la Colección **sin componente narrativo principal**.

Los documentos de diseño de El Cuaderno son:

- `docs/el-cuaderno/01-biblia.md` — biblia maestra.
- `docs/el-cuaderno/04-voces-y-figuras.md` — voces del sistema y del Tutor.
- `docs/el-cuaderno/02-mapa-habilidades-atomicas.md` — pendiente, fase 2.

Se asume que estos documentos están en el repositorio cuando se ejecuta el prompt. Si no, el primer paso de Claude Code es pedirlos.

## 2. Precondiciones técnicas

Antes de ejecutar el prompt, comprobar:

- Flutter ≥ 3.24 instalado.
- Melos instalado globalmente (`dart pub global activate melos`).
- Repositorio `nuevo-ser/` clonado y `melos bootstrap` funcionando.
- Tests existentes pasando (`melos run test`).
- Branch nuevo creado: `feature/el-cuaderno-bootstrap`.

## 3. Alcance del primer sprint (lo que el prompt produce)

El prompt **no** produce un juego jugable. Produce el **scaffolding mínimo coherente con la biblia**:

1. Estructura de carpetas de `apps/el-cuaderno/` siguiendo la convención del monorepo.
2. Modelo de datos local (Isar) para Observaciones, Sit Spot, Misterios, páginas del Cuaderno.
3. Tres pantallas funcionales con datos simulados (no conectadas todavía a backend):
   - Pantalla principal del Cuaderno.
   - Pantalla de Nueva Observación.
   - Pantalla del Tutor (UI vacía, sin LLM aún).
4. Localización (es / eu / ca) con strings iniciales del onboarding.
5. Tests unitarios mínimos del modelo de datos.
6. Tests de widget mínimos para las dos pantallas con contenido.
7. Documentación: `apps/el-cuaderno/README.md` con cómo ejecutarlo.

Lo que el prompt **NO** hace en este sprint:

- No conecta con `nuevo-ser-core` todavía. Eso es Sprint 2.
- No implementa el motor adaptativo. Eso es Sprint 3.
- No conecta con el Tutor IA real. Pantalla con UI mock únicamente.
- No incluye assets de ilustración. Placeholders en gris.
- No incluye el sit spot con geolocalización. Lugar es texto manual por ahora.

## 4. PROMPT

> A partir de aquí, todo el contenido se entrega como prompt a Claude Code. Copiar tal cual.

---

```
Estás trabajando en el monorepo nuevo-ser/ de la Colección Nuevo Ser. Vas a hacer el bootstrap del nuevo juego "El Cuaderno", primer juego no narrativo de la Colección. Este sprint produce únicamente scaffolding y tres pantallas con datos simulados.

LECTURA OBLIGATORIA ANTES DE EMPEZAR

Lee, en este orden, antes de escribir código:

1. coleccion-nuevo-ser-manifiesto.md (raíz del repo)
2. coleccion-nuevo-ser-criterios-de-integracion.md
3. nuevo-ser-core-arquitectura.md
4. docs/el-cuaderno/01-biblia.md
5. docs/el-cuaderno/04-voces-y-figuras.md

Si alguno no existe en el repo, para y dímelo. No improvises los principios — están todos ahí.

Después de leerlos, dime en una frase qué entiendes que es el oficio que enseña este juego, y qué entiendes que es el principio jerárquico número 1 de su biblia. Si no aciertas a identificarlos, no sigas: pregúntame.

PRINCIPIOS QUE NO PUEDES SALTARTE

Aplican a todo lo que escribas en este sprint:

- Privacidad por diseño. Las observaciones del niño se guardan en Isar local cifrado. Nada cruza red en este sprint.
- Sin tracking. Sin telemetría de uso. Sin Firebase Analytics. Sin Sentry hasta que se documente y consienta. Sin nada.
- Sin gamificación tóxica. El UI no incluye XP, niveles visibles, rachas, badges, fanfarria sonora, animaciones de "¡bien hecho!". Si te sale espontáneamente, lo borras.
- i18n nativo. Toda string visible al usuario va por ARB. Cero strings hardcoded en widgets. Tres idiomas: es, eu, ca. En este sprint solo rellenas es; los otros dos quedan con placeholders explícitos "TODO_EU" / "TODO_CA" para que el equipo de localización los traduzca.
- Voz del Cuaderno. Cualquier microcopia que escribas en es debe seguir el documento 04-voces-y-figuras.md §2. Léelo y úsalo. Si una frase no podría salir de "una bióloga con cuarenta años en el monte", la reescribes.
- Sentence case. Nunca Title Case ni MAYÚSCULAS. Ni en código, ni en strings.
- Lenguaje del repo. Castellano para nombres de identificadores cuando sean conceptuales del dominio (Observacion, Misterio, SitSpot, Cuaderno) y para comentarios. Inglés para nombres técnicos genéricos (build, dispose, copyWith).

ESTRUCTURA A CREAR

Crear, dentro de apps/el-cuaderno/, esta estructura:

apps/el-cuaderno/
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
├── lib/
│   ├── main.dart
│   ├── dominio/
│   │   ├── observacion.dart
│   │   ├── sit_spot.dart
│   │   ├── misterio.dart
│   │   ├── pagina_cuaderno.dart
│   │   ├── nivel_confianza.dart
│   │   └── repositorio_local.dart
│   ├── infraestructura/
│   │   └── isar/
│   │       ├── isar_setup.dart
│   │       └── modelos_isar.dart
│   ├── vista/
│   │   ├── tema/
│   │   │   ├── colores.dart
│   │   │   └── tipografia.dart
│   │   ├── pantalla_cuaderno/
│   │   │   ├── pantalla_cuaderno.dart
│   │   │   ├── tarjeta_sit_spot.dart
│   │   │   ├── tarjeta_misterio.dart
│   │   │   └── seccion_ultima_pagina.dart
│   │   ├── pantalla_observacion/
│   │   │   ├── pantalla_observacion.dart
│   │   │   ├── selector_confianza.dart
│   │   │   └── selector_misterio.dart
│   │   └── pantalla_tutor/
│   │       └── pantalla_tutor.dart
│   ├── nucleo/
│   │   └── i18n/
│   │       ├── arb/
│   │       │   ├── intl_es.arb
│   │       │   ├── intl_eu.arb
│   │       │   └── intl_ca.arb
│   │       └── l10n.yaml
│   └── datos_simulados/
│       └── seed.dart
└── test/
    ├── dominio/
    │   ├── observacion_test.dart
    │   └── nivel_confianza_test.dart
    └── vista/
        ├── pantalla_cuaderno_test.dart
        └── pantalla_observacion_test.dart

MODELO DE DOMINIO (lib/dominio/)

NivelConfianza: enum {consenso, hipotesisActiva, abandonado, noSegura}.
Funciones helper: NivelConfianza.fromString, .toLocaleLabel(idioma) que devuelve la etiqueta legible. NUNCA exponer el enum bruto al UI sin pasar por toLocaleLabel.

Observacion: clase inmutable con:
  - id: String (UUID v4)
  - cuandoCreada: DateTime
  - cuandoOcurrio: DateTime (puede diferir si la registra después)
  - dondeNombre: String (texto libre del niño)
  - dondeCoordenadas: ({double lat, double lng})? (opcional, opcional, opcional — en este sprint siempre null)
  - climaResumen: String? (texto corto, opcional)
  - queVio: String (texto libre, no vacío)
  - creesQueEs: String? (identificación propuesta, opcional)
  - confianza: NivelConfianza
  - fotoRutaLocal: String? (path en disco, opcional)
  - dibujoRutaLocal: String? (path en disco, opcional)
  - misterioId: String? (anclaje a un Misterio, opcional)
  - sitSpotId: String? (si se hizo en el sit spot)

Métodos: copyWith, ==, hashCode, toJson/fromJson.

Validación: queVio no puede ser cadena vacía. Si confianza es consenso, creesQueEs no puede ser null. Si es noSegura, creesQueEs puede serlo o no, indistintamente.

SitSpot: clase con:
  - id, nombre, dondeNombre, coordenadas (opcional null), creadoEn, ultimaVisita: DateTime?

Misterio: clase con:
  - id, pregunta, descripcionCorta, estado: NivelConfianza (consenso, hipotesisActiva, abandonado), abierto: bool, observacionesIds: List<String>.
  - El niño no puede modificar el campo estado — es del sistema. Documenta esto claramente en un comentario.

PaginaCuaderno: clase sellada con cuatro variantes:
  - PaginaObservacion(observacionId)
  - PaginaSitSpot(sitSpotId, datosResumen)
  - PaginaMisterio(misterioId)
  - PaginaEstacion(estacion, ano, contenidoMosaico)

RepositorioLocal: interfaz abstracta con métodos:
  - Future<void> guardarObservacion(Observacion)
  - Future<List<Observacion>> obtenerObservaciones({int? limite, String? misterioId, String? sitSpotId})
  - Future<SitSpot?> obtenerSitSpot()
  - Future<void> establecerSitSpot(SitSpot)
  - Future<List<Misterio>> obtenerMisteriosAbiertos()
  - Future<void> anclarObservacionAMisterio(String observacionId, String misterioId)

Implementación con Isar en lib/infraestructura/isar/. Usa Isar Community (no Cloud).

DATOS SIMULADOS (lib/datos_simulados/seed.dart)

Función pública seedDatosDesarrollo(RepositorioLocal repo) que:
- Crea un sit spot llamado "El Roble Grande" con última visita hace 4 días.
- Crea dos Misterios con los exactos textos del documento 01-biblia §5.3 (las setas tras la lluvia, las golondrinas).
- Crea tres observaciones de ejemplo (una para la "última página" del home).
- Idempotente: si ya hay datos, no duplica.

Esta función se llama solo en debug mode, nunca en build de release. Asegúrate de eso con kDebugMode.

PANTALLAS (lib/vista/)

PantallaCuaderno (pantalla_cuaderno.dart):
- Replica fielmente el mockup descrito en la biblia §5.4 y la voz del documento 04. Una columna scroll vertical con: cabecera (nombre del juego + estación + semana), saludo personal, tarjeta del sit spot, sección de Misterios abiertos (max 3), última página.
- Bottom nav con 4 pestañas: Cuaderno, Mapa, Misterios, Tutor. Solo Cuaderno y Tutor llevan a algo en este sprint; Mapa y Misterios navegan a un placeholder con "Próximamente".
- Datos vienen del RepositorioLocal vía un ChangeNotifier o equivalente. NO uses BLoC ni Riverpod en este sprint — vanilla provider o ValueNotifier es suficiente y reduce dependencias.

TarjetaSitSpot, TarjetaMisterio: widgets puros, reciben datos como parámetros, no acceden al repo.

PantallaObservacion (pantalla_observacion.dart):
- Formulario coherente con el mockup descrito en la biblia §5.2.
- Campos: foto/dibujo (placeholder, no operativo en este sprint), descripción libre (TextField multilínea, obligatorio), identificación propuesta (TextField simple, opcional), selector de confianza (tres chips), selector de Misterio (dropdown opcional).
- Botón "Guardar en el cuaderno" abajo, full-width. Deshabilitado si la descripción está vacía.
- Validación visible pero no agresiva. Si falta descripción, indica brevemente "haz una nota antes de guardar" debajo del campo, sin rojo, sin icono de error.

SelectorConfianza: tres chips horizontales. El seleccionado tiene background var(--color-background-info) o equivalente del tema; los otros, secondary. Las etiquetas son "consenso", "hipótesis activa", "no estoy segura". Por defecto está seleccionado "hipótesis activa" porque es el estado natural al registrar algo nuevo.

PantallaTutor (pantalla_tutor.dart):
- En este sprint: pantalla con la frase canónica de presentación ("Soy el Tutor del Cuaderno. Pregúntame lo que necesites.") y un input de texto + botón Enviar. Al enviar, en lugar de llamar a un LLM, devuelve una respuesta canned: "El Tutor todavía no está conectado. Vuelve en unas semanas." Esto es deliberado y debe quedar documentado en el README.

TEMA (lib/vista/tema/)

colores.dart: paleta apagada del cuaderno botánico. Cremas, verdes apagados, ocres, azul ceniza. Define ColorScheme light y dark explícitamente. NADA de saturaciones altas.
tipografia.dart: serif para textos del Cuaderno y voz del niño (deja TODO con la fuente concreta — usa por ahora la system serif default), sans-serif para datos del sistema. Define los tamaños: 11, 12, 13, 14, 16, 17 px. Solo dos pesos: 400 regular, 500 bold. Nunca 600 ni 700.

I18N (lib/nucleo/i18n/)

ARB en es completo. EU y CA con placeholders TODO_EU / TODO_CA en cada string. Configura flutter_localizations. NO uses la librería intl_utils — usa la generación nativa de Flutter (gen_l10n).

TESTS

Mínimos pero reales:

dominio/observacion_test.dart:
- Validación: queVio vacío lanza ArgumentError.
- Validación: confianza consenso con creesQueEs null lanza ArgumentError.
- copyWith preserva campos no especificados.
- toJson/fromJson roundtrip.

dominio/nivel_confianza_test.dart:
- toLocaleLabel devuelve etiqueta correcta en cada idioma para cada valor.

vista/pantalla_cuaderno_test.dart:
- Renderiza con datos sembrados.
- Muestra el sit spot "El Roble Grande".
- Muestra dos tarjetas de Misterio.
- El bottom nav tiene 4 pestañas.
- NO testea estilos exactos. Testea presencia de widgets clave.

vista/pantalla_observacion_test.dart:
- El botón Guardar está deshabilitado al inicio.
- Escribir en queVio lo habilita.
- Tres chips de confianza presentes.
- "hipótesis activa" seleccionado por defecto.

Todos los tests pasan con flutter test desde apps/el-cuaderno/.

PUBSPEC

apps/el-cuaderno/pubspec.yaml:
- Dart SDK >=3.5.0 <4.0.0.
- flutter, flutter_localizations.
- isar y isar_flutter_libs (versión coherente con la del resto del monorepo — léela de nuevo_ser_core).
- uuid.
- path_provider.
- Dev: flutter_test, isar_generator, build_runner.
- NO añadas firebase_*, sentry, http directo, dio. Nada de eso aquí.

README

apps/el-cuaderno/README.md con:
- Qué es El Cuaderno (un párrafo, voz adulta).
- Qué cubre este sprint y qué NO.
- Cómo ejecutar en debug (con datos sembrados).
- Cómo correr los tests.
- Estado del Tutor (canned response, conexión real en sprint posterior).
- Decisiones abiertas remitidas a la biblia §10.

CONVENCIONES DE COMMITS

Un commit por bloque lógico. Mensajes en español, presente, imperativo:
- "añade modelo de dominio Observacion"
- "implementa pantalla del cuaderno con datos sembrados"
- "configura i18n con es completo y placeholders eu/ca"

Al final, un commit "documenta el sprint en README".

LO QUE NO HACES, BAJO NINGUNA CIRCUNSTANCIA, SIN PEDÍRMELO PRIMERO

- No añades dependencias que no figuren arriba.
- No tocas otros apps/*.
- No tocas packages/*.
- No tocas wp-plugin/*.
- No reescribes documentos de docs/.
- No conectas con servicios externos.
- No subes nada al remoto. Yo decidiré cuándo se mergea.

Si en algún momento dudas si una decisión cumple los principios del manifiesto o de la biblia, paras y preguntas. Es preferible una pregunta a una asunción.

Cuando termines, en tu mensaje final lista:
1. Archivos creados.
2. Tests pasados.
3. Cualquier asunción que hayas hecho.
4. Las dos o tres cosas que más te preocupan del scaffolding y por qué.

Empieza ahora por la lectura. Cuando termines de leer los cinco documentos, dime qué entendiste y espera mi luz verde.
```

---

## 5. Notas para quien orquesta el prompt

- **Sesión larga.** Esto puede tardar 90-120 minutos de trabajo de Claude Code. Reserva tiempo y evita interrumpir.
- **Revisa la lectura antes de dar luz verde.** La parte donde Claude Code te resume su entendimiento de los principios es importante. Si lo resume mal — si dice "el oficio es identificar especies" en lugar de "es la postura del que mira despacio" — corrígele antes de seguir, o aborta y vuelve a empezar.
- **Espera a que pregunte.** El prompt está diseñado para que Claude Code pregunte ante dudas. Si avanza sin preguntar en algo ambiguo, le faltó atención al prompt — recuérdaselo.
- **El Tutor canned es deliberado.** No le dejes "ya que estamos" conectar la API real en este sprint. Eso necesita su propio sprint con prompts de sistema versionados, política de retención, presupuesto de tokens y filtros de contenido. No se improvisa.
- **Privacidad antes que ergonomía.** Si Claude Code propone telemetría "para mejorar el producto", refusalo. La Colección no extrae datos.

## 6. Sprints siguientes (referencia, no parte de este prompt)

- **Sprint 2 — Integración con `nuevo-ser-core`.** Modelo de datos Isar local + sync con backend. Auth común. Multi-perfil.
- **Sprint 3 — Mapa de habilidades atómicas y motor adaptativo.** Requiere doc 02 cerrado.
- **Sprint 4 — Tutor IA real.** Prompts de sistema versionados, ZDR, plantillas por idioma.
- **Sprint 5 — Sit spot con geolocalización y mapa local.** Permisos, privacidad, almacenamiento offline de tiles.
- **Sprint 6 — Acompañamiento.** Vista del cuidador, vista del aula, agregados firmados.
- **Sprint 7 — Piloto.** Mínimo 12 niños voluntarios, una estación completa.

Cada sprint posterior se acompañará de su propio prompt maestro al estilo de éste.

---

*Fin del prompt maestro v0.1.*
