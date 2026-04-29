# El Cuaderno — Arquitectura técnica

> Documento técnico operativo.
> Versión 0.1 — borrador para Fase 3 (revisión técnica).
> Modelo: doc 03 de Uno Roto, extendido con el perfil P5.
> Leer junto a `nuevo-ser-core-arquitectura.md`, la biblia, el mapa de habilidades, y el documento de acompañamiento.

---

## 1. Qué es este documento

Define **qué se construye, dónde, con qué stack, con qué contratos**. Está dirigido al ingeniero o ingeniera que va a ejecutar la implementación, sin ambigüedad sobre las decisiones técnicas tomadas y con justificaciones concretas para las que se separan del estándar de la Colección.

Este documento **extiende** `nuevo-ser-core-arquitectura.md` con dos cosas nuevas que ningún otro juego de la Colección requiere:

1. **Perfil P5** — modelo compuesto de maestría (precisión + rúbrica + cobertura + proxy).
2. **Servicio de fenología** — cálculo server-side de qué es típico en cada región y estación, para contextualizar Misterios y observaciones.

Lo que no cambia respecto al estándar de la Colección: stack base, offline-first, AGPL-3.0 / CC-BY-SA, multiidioma es/eu/ca, tutor IA vía Claude API en modo Zero Data Retention.

## 2. Stack y decisiones de arquitectura

### 2.1 Stack base (heredado de la Colección)

| Capa | Tecnología | Justificación |
|---|---|---|
| Cliente | Flutter ≥ 3.24 | Misma que Uno Roto y Las Versiones |
| Render UI | Flutter widgets puros, sin Flame | El Cuaderno no es un juego con render custom — es UI |
| Almacenamiento local | Isar Community con cifrado en reposo | Estándar de la Colección |
| Backend | WordPress + plugin `nuevo-ser-core` | Estándar |
| Base de datos | MySQL | Estándar |
| Tutor IA | Claude API en modo ZDR | Estándar |
| Almacén de medios | S3-compatible cifrado (Cloudflare R2 propuesto) | **Decisión específica de El Cuaderno** — ver §10 |
| Mapas y geo | OpenStreetMap raster + tiles offline | **Decisión específica** — ver §7 |

### 2.2 Decisiones específicas y justificaciones

**Sin Flame.** Uno Roto usa Flame para el combate visual de Fragmentos. Las Versiones lo usa para la mesa de trabajo. El Cuaderno no tiene gameplay con animación significativa — toda su UI son listas, tarjetas, formularios y galería de medios. Flutter widgets son suficientes y reducen complejidad.

**Cloudflare R2 para medios.** Las observaciones del niño pueden incluir fotos y dibujos. Almacenarlos es delicado:
- En el dispositivo siempre están (Isar).
- En servidor solo si el niño explícitamente comparte (con cuidador o aula).
- R2 ofrece cifrado en reposo, ausencia de fees de egress, y región europea garantizada.
- Alternativa rechazada: AWS S3 (egress fees, política de privacidad menos clara).

**OpenStreetMap raster con tiles offline.** Sit spot necesita mapa, pero:
- El niño debería poder ver su sit spot **sin red** (campo, monte, zonas sin cobertura).
- Google Maps SDK es propietario, manda telemetría, no compatible con valores de la Colección.
- Mapbox es buena alternativa pero tiene tier gratuito acotado y telemetría.
- **OSM con tiles raster pre-cargados localmente del territorio del niño** es la solución coherente. Más trabajo de implementación, alineado con principios.

**Sin Firebase, sin Sentry sin política, sin Crashlytics.** Misma postura que el resto de la Colección. Si en Fase 4 (piloto) se considera necesaria telemetría de errores para corregir bugs, se documenta política, se pide consentimiento explícito, se anonimiza.

## 3. Modelo de datos

### 3.1 Entidades centrales

```
Observacion
├── id: UUID v4
├── user_id: ref Usuario
├── game_id: 'el-cuaderno' (constante)
├── created_at: TIMESTAMP
├── occurred_at: TIMESTAMP
├── place_name: VARCHAR (texto libre del niño)
├── place_coords: ({lat, lng})? (opcional, fine-grained, NUNCA al servidor)
├── region_code: VARCHAR (coarse-grained, sí va al servidor)
├── weather: JSON? (descriptor opcional)
├── what_seen: TEXT (no vacío)
├── proposed_id: VARCHAR? (identificación propuesta)
├── confidence: ENUM('consenso', 'hipotesis_activa', 'no_segura')
├── photo_local_path: VARCHAR? (path en Isar local)
├── drawing_local_path: VARCHAR? (path en Isar local)
├── photo_blob_id: VARCHAR? (id en R2 si compartida)
├── drawing_blob_id: VARCHAR? (id en R2 si compartida)
├── misterio_id: UUID? (anclaje opcional)
├── sit_spot_id: UUID? (si fue en el sit spot)
├── shared_with: JSON (cuidadores/aulas con permiso explícito)
└── soft_deleted_at: TIMESTAMP?

SitSpot
├── id: UUID v4
├── user_id: ref Usuario (1:1 — el MVP solo permite 1 sit spot por niño)
├── name: VARCHAR (texto del niño)
├── place_coords: ({lat, lng})? (en dispositivo solamente)
├── region_code: VARCHAR
├── created_at: TIMESTAMP
├── last_visit_at: TIMESTAMP?
└── retired_at: TIMESTAMP? (si el niño cambia de sit spot, no se borra)

Misterio
├── id: UUID v4
├── code: VARCHAR (id legible: 'MIST.AVES.MIGRACION_GOLONDRINAS')
├── title_i18n: JSON ({es: ..., eu: ..., ca: ...})
├── description_i18n: JSON
├── status: ENUM('consenso', 'hipotesis_activa', 'abandonado')
├── season: ENUM('otono','invierno','primavera','verano','todo_el_anio')
├── region_filter: JSON? (lista de region_codes donde aplica, null = global)
├── habilidades_relacionadas: JSON (lista de IDs de habilidades atómicas)
└── retired_at: TIMESTAMP?

PaginaCuaderno
├── id: UUID v4
├── user_id: ref Usuario
├── tipo: ENUM('observacion', 'sit_spot', 'misterio', 'estacion', 'libre')
├── ref_id: UUID? (apunta a observacion/sit_spot/misterio según tipo)
├── content: JSON (para tipo='libre' o 'estacion'; null si la página se renderiza desde otra entidad)
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP

EstadoMaestria
├── user_id: ref Usuario
├── habilidad_id: VARCHAR (e.g. 'PRE.01')
├── nivel: INT (0-4)
├── precision_acumulada: FLOAT? (componente de precisión, si aplica)
├── rubrica_media: FLOAT? (componente de rúbrica)
├── cobertura_score: FLOAT? (componente de cobertura)
├── proxy_score: FLOAT? (componente de proxy)
├── ultima_practica: TIMESTAMP
└── ultima_estacion_practica: ENUM
```

### 3.2 Migraciones MySQL

Las tablas siguen el patrón de `wp_ns_*` ya establecido por `nuevo-ser-core` para multi-juego. Migración M003:

```sql
-- M003__el_cuaderno_tablas_especificas.sql

CREATE TABLE wp_ns_observaciones (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid            CHAR(36) UNIQUE NOT NULL,
    user_id         BIGINT UNSIGNED NOT NULL,
    game_id         VARCHAR(64) NOT NULL DEFAULT 'el-cuaderno',
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    occurred_at     TIMESTAMP NOT NULL,
    place_name      VARCHAR(255) NOT NULL,
    region_code     VARCHAR(16) NOT NULL,
    weather_json    JSON,
    what_seen_hash  CHAR(64),  -- hash; NO se almacena el texto
    proposed_id     VARCHAR(255),
    confidence      ENUM('consenso','hipotesis_activa','no_segura') NOT NULL,
    has_photo       TINYINT(1) NOT NULL DEFAULT 0,
    has_drawing     TINYINT(1) NOT NULL DEFAULT 0,
    photo_blob_id   VARCHAR(64),    -- NULL salvo que esté compartida
    drawing_blob_id VARCHAR(64),
    misterio_id     CHAR(36),
    sit_spot_id     CHAR(36),
    shared_with     JSON,
    soft_deleted_at TIMESTAMP NULL,
    INDEX idx_user_game_time (user_id, game_id, occurred_at),
    INDEX idx_region_misterio (region_code, misterio_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE wp_ns_sit_spots (...);
CREATE TABLE wp_ns_misterios_asignados (...);
CREATE TABLE wp_ns_paginas_cuaderno_meta (...);
```

**Importante**: en `wp_ns_observaciones`, el campo `what_seen_hash` es un hash, no el texto. El **texto libre del niño nunca se almacena en servidor por defecto**. El hash sirve para detección de duplicados y para generar resúmenes anonimizados, sin necesidad de tener el contenido.

### 3.3 ¿Qué vive solo en local?

En el dispositivo del niño (Isar cifrado), nunca en servidor:

- Texto libre de las observaciones (`what_seen`)
- Fotos (binario)
- Dibujos (binario)
- Conversaciones con el Tutor (turno actual; se borran al cerrar sesión)
- Coordenadas precisas del sit spot
- Páginas libres del cuaderno (escritura libre, mapas dibujados)
- Mosaicos de estación

Lo que sí se sincroniza al servidor:

- Metadatos de observaciones (sin contenido textual ni binario)
- Estado de habilidades (niveles, scores)
- Vínculos a Misterios y SitSpot
- Resúmenes semanales (después de generarse por el tutor IA)

Esto es lo más distintivo de El Cuaderno respecto a Uno Roto: la separación radical entre datos privados (en local) y metadatos sincronizables (en servidor).

## 4. Perfil P5 — motor adaptativo compuesto

### 4.1 Por qué un perfil nuevo

`nuevo-ser-core` define en su §6 cuatro perfiles de medición:

- **P1**: precisión ponderada (Uno Roto). Para habilidades con respuesta única correcta.
- **P2-P4**: rúbrica de oficio histórico (Las Versiones). Para habilidades de juicio interpretativo.

Ninguno encaja con El Cuaderno. Sus 9 dominios mezclan tipos:

- TAX y CIC son medibles por **precisión** (la limonera o no es).
- OBS y REG son medibles por **rúbrica cualitativa**.
- HAB, REL y TEJ son medibles por **cobertura** (variedad de contextos).
- PRE solo es medible por **proxy** (indicadores indirectos del comportamiento).

Forzar todo en un solo tipo distorsiona la pedagogía. Por eso el perfil P5: **modelo compuesto** que combina los cuatro componentes con pesos por habilidad.

### 4.2 Especificación

```
P5.calcularNivel(usuario, habilidad) -> nivel ∈ [0, 4]

donde:

  componentes = habilidad.componentes_aplicables  // subset of {precision, rubrica, cobertura, proxy}

  scores_normalizados = {
    componente: P5.normalizar(componente, mediciones_brutas[componente])
    for componente in componentes
  }

  pesos = habilidad.pesos  // suman 1.0, definidos por habilidad

  score_compuesto = Σ scores_normalizados[c] · pesos[c]   for c in componentes

  nivel = P5.umbralAdaptativo(habilidad, score_compuesto, historico)
```

Cada componente normaliza a [0, 1]:

- **precision**: media de aciertos ponderada por dificultad.
- **rubrica**: media de evaluaciones del tutor IA muestreadas, en escala 0-3 normalizada.
- **cobertura**: número de contextos distintos en que apareció / contextos esperados.
- **proxy**: combinación de indicadores indirectos específica de cada habilidad (e.g. PRE.01 mira regularidad temporal de visitas).

Los **umbrales** entre niveles 1→2→3→4 son adaptativos:

- Nivel 1 (Introducida): score ≥ 0.30 después de ≥3 sesiones de práctica.
- Nivel 2 (En desarrollo): score ≥ 0.50 después de ≥7 sesiones, distribuidas en ≥2 semanas.
- Nivel 3 (Competente): score ≥ 0.75, retención ≥1 estación.
- Nivel 4 (Maestría): score ≥ 0.90, retención ≥2 estaciones, transferencia (uso en contextos no entrenados).

### 4.3 Implementación: patrón Strategy

Siguiendo la arquitectura de `nuevo-ser-core` §6, P5 implementa la interfaz `MasteryProfile`:

```dart
abstract class MasteryProfile {
  Future<int> computeLevel(String userId, String habilidadId);
  Future<MasteryDelta> recordObservation(String userId, ObservationData data);
  Future<List<String>> nextSkillsToWork(String userId, int budget);
}

class P5CompositeProfile implements MasteryProfile {
  final SkillRegistry registry;
  final ScoreNormalizer normalizer;
  final ThresholdEngine thresholds;
  
  @override
  Future<int> computeLevel(String userId, String habilidadId) async {
    final habilidad = await registry.get(habilidadId);
    final mediciones = await _loadMediciones(userId, habilidadId);
    
    final scoresNormalizados = <String, double>{};
    for (final componente in habilidad.componentesAplicables) {
      scoresNormalizados[componente] = normalizer.normalize(
        componente,
        mediciones[componente]!,
      );
    }
    
    final scoreCompuesto = habilidad.pesos.entries
        .map((e) => e.value * scoresNormalizados[e.key]!)
        .reduce((a, b) => a + b);
    
    return thresholds.computeLevel(habilidad, scoreCompuesto, mediciones.historico);
  }
  
  // ...
}
```

### 4.4 Paridad Dart ↔ PHP

Como el resto de perfiles, P5 tiene implementación dual:

- **Dart** (cliente): cálculo local sobre datos en Isar para mostrar al niño y para decisiones del Tutor.
- **PHP** (servidor): cálculo sobre agregados sincronizados, para resúmenes del cuidador y vista del aula.

Tests de paridad obligatorios: para 100 fixtures de mediciones, ambas implementaciones devuelven el mismo nivel y el mismo score compuesto, con tolerancia de epsilon=1e-6 en flotantes.

### 4.5 Lo que P5 explícitamente NO hace

- **No premia velocidad**. La velocidad es metadato útil para detectar fatiga, pero no entra en el cálculo de nivel.
- **No compara entre niños**. Cada niño se compara solo con su histórico.
- **No oculta el cálculo a desarrolladores y didactas** — la implementación es AGPL y los pesos están en `content/el-cuaderno/skills-mvp.json`.
- **Sí oculta los niveles al niño**. La maestría es observable, no declarada (mapa §2.3).

## 5. Sincronización

### 5.1 Principios

- **Offline-first**. Toda la operación nuclear funciona sin red.
- **Cliente envía agregados, no datos crudos**.
- **Eventual consistency**. Si el niño hace 5 observaciones offline en una salida al monte, se sincronizan cuando vuelva a tener red, idempotentes.
- **Last-write-wins** en los pocos campos donde hay riesgo de conflicto (estado del SitSpot, asignación de Misterios).

### 5.2 Cola de sincronización

Implementación: tabla local `sync_queue` en Isar con entradas:

```dart
class SyncQueueEntry {
  final String id;        // UUID v4 idempotency key
  final String endpoint;  // 'observaciones', 'mastery', 'weekly_aggregates'
  final String operation; // 'create', 'update', 'soft_delete'
  final String payloadJson;
  final DateTime queuedAt;
  final int attempts;
  final DateTime? lastAttemptAt;
  final String? lastError;
  final SyncStatus status; // pending, in_flight, succeeded, failed
}
```

Worker en background con backoff exponencial (1s, 5s, 30s, 5min, 1h, 6h, abandono después de 24h reportable al usuario).

### 5.3 Endpoints REST

Bajo `/wp-json/nuevo-ser/v1/`, conforme a §4 de `nuevo-ser-core-arquitectura.md`. Los específicos de El Cuaderno:

```
POST /el-cuaderno/observaciones
  body: { uuid, occurred_at, place_name, region_code, what_seen_hash,
          proposed_id, confidence, has_photo, has_drawing,
          misterio_id, sit_spot_id }
  retorna: 201 + uuid; 409 si uuid duplicado (idempotente)

POST /el-cuaderno/sit-spot
  body: { uuid, name, region_code }
  retorna: 201 o 200 + uuid (un sit spot por niño en MVP)

GET /el-cuaderno/misterios?region={code}&season={season}
  retorna: lista de Misterios aplicables al contexto

POST /el-cuaderno/mastery/event
  body: { habilidad_id, evento, payload }
  retorna: 201 + nivel actualizado

GET /el-cuaderno/cuidador/{user_id}/resumen-semanal?week={iso_week}
  auth: cuidador con consent verificado
  retorna: párrafo cualitativo del tutor IA, idioma del cuidador

GET /el-cuaderno/aula/{classroom_id}/panorama?week={iso_week}
  auth: profesor con consent verificado
  retorna: agregados k>=5 anonimizados
```

### 5.4 Firma local de agregados

Conforme a `nuevo-ser-core-arquitectura.md` §7.4:

```dart
final aggregate = WeeklyAggregator.compute(
  rawObservations: localObservations,
  rawMastery: localMastery,
);
final signed = aggregate.signWith(localKey);  // HMAC con clave del dispositivo
await syncQueue.push('weekly_aggregates', signed);
```

El servidor verifica HMAC antes de aceptar. Esto previene inyección de datos falsos por atacante con acceso a servidor — necesitaría también acceso al dispositivo.

## 6. Tutor IA

### 6.1 Arquitectura del cliente del Tutor

El paquete `nuevo_ser_tutor` ya existe en el monorepo. El Cuaderno consume su API:

```dart
abstract class TutorClient {
  Future<TutorResponse> ask({
    required String userId,
    required String gameId,    // 'el-cuaderno'
    required String message,
    ObservationData? attachedObservation,
    SkillContext? skillContext,
  });
}
```

### 6.2 Prompt de sistema

Versionado, server-side, no editable por cliente. Plantilla base en PHP, parametrizada por idioma y contexto. Esquema:

```
Eres el Tutor de El Cuaderno. Responde como bióloga competente que enseña a
una aprendiza de {edad} años. Reglas estrictas (siguiendo voces-y-figuras §3):

1. Solo respondes sobre el oficio del juego: identificación, técnicas de campo,
   ciclos biológicos, ecología básica, claves dicotómicas.
2. Si no sabes, dices "no lo sé" sin disimular.
3. No inventas hechos biológicos.
4. No te presentas como amiga. No usas primera persona afectiva.
5. Cuando el conocimiento de campo prevalece sobre conocimiento procesado, lo
   declaras: "yo no he caminado nunca por tu sit spot".
6. Tu tono: seco, cálido, paciente. Como abuela naturalista.
7. Vocabulario prohibido: ¡felicidades!, ¡bien hecho!, qué bonito, qué
   maravilloso, etc. (lista completa en voces-y-figuras §2.3).
8. Si la conversación se alarga sin sustancia, sugieres cierre.

Contexto del niño:
- Idioma: {idioma}
- Edad: {edad}
- Región: {region_code}
- Estación actual: {season}
- Habilidad relacionada con la pregunta: {skill_id} (nivel {nivel})

[ejemplos few-shot de los 5 intercambios canónicos del documento 04]
```

### 6.3 Configuración Claude API

- **Modelo**: Claude Sonnet 4.6 (estándar Colección).
- **Modo**: Zero Data Retention.
- **Max tokens output**: 300 (forzar concisión).
- **Temperature**: 0.3 (consistencia, baja improvisación).
- **Stop sequences**: ninguna explícita; el modelo decide cierre.

### 6.4 Filtros de salida

Tras recibir respuesta del modelo, filtros server-side antes de devolver al cliente:

1. **Lista negra de patrones**: si la respuesta contiene cualquiera del vocabulario prohibido (regex sobre §2.3 de voces-y-figuras), se regenera (max 1 reintento) y si sigue, se sustituye por mensaje canónico de fallback.
2. **Detección de confabulación**: heurística básica — si la respuesta menciona especies, lugares o datos muy específicos sin contexto, se suaviza con un "según conocimiento general; consulta una clave local".
3. **Detección de contenido fuera de oficio**: si la respuesta toca temas religiosos, políticos, de relaciones personales del niño, se sustituye por la línea canónica *"Eso queda fuera de lo que puedo ayudar."*.

### 6.5 Presupuesto y latencia

- **Cuota por niño**: 30 turnos/día, 200 turnos/semana. Si se acerca al límite, el Tutor avisa: *"Hoy hemos hablado mucho. Volvemos mañana."*.
- **Latencia objetivo**: <3 segundos p95 con conexión decente.
- **Caché agresivo** del prompt de sistema (no cambia entre llamadas) y de respuestas a preguntas frecuentes anonimizadas.

### 6.6 No persistencia conversacional

Conforme a voces-y-figuras §3.2: el Tutor no recuerda entre conversaciones. Cada turno es independiente excepto por el contexto del propio turno y la observación adjunta opcional. **No se almacena historial conversacional en servidor**.

## 7. Geolocalización y SitSpot

### 7.1 Privacidad como restricción de diseño

La geolocalización de un niño es de las datos más sensibles posibles. La arquitectura asume **adversario con acceso a servidor** y diseña para que no pueda reconstruir la ubicación precisa del niño.

Reglas:

1. **Coordenadas precisas (lat/lng) NUNCA salen del dispositivo**. Se usan para detectar el SitSpot localmente y para mostrar mapa offline. Punto.
2. **El servidor recibe `region_code`** (NUTS-3 europeo aproximado, o equivalente granular suficiente para fenología pero insuficiente para identificación). Ejemplo: `ES-NA` (Navarra), `ES-NA-PA` (área pamplonesa). No `coords con 4 decimales`.
3. **Sin tracking continuo**. La app no recibe `Location.onLocationChanged`. Solo pide ubicación puntual cuando el niño explícitamente registra una observación o configura su sit spot.
4. **Permiso de ubicación: solo en uso (foreground)**. Nunca en background. Documentado en la solicitud de permiso al usuario en lenguaje claro.
5. **El niño puede declinar geolocalización completamente** y usar texto libre (`place_name`) para todo. La pérdida de funcionalidad: el sistema no detecta automáticamente si está en su SitSpot, pero el niño puede marcarlo a mano.

### 7.2 Sit spot: una entidad privilegiada

El SitSpot es la única entidad geo del juego que se persiste con coordenadas (en local). Cuando el niño registra observaciones, el sistema puede preguntar *"¿estás en El Roble Grande?"* si las coordenadas actuales coinciden con las del SitSpot dentro de un radio de 50m.

Cambiar el SitSpot tiene fricción intencionada: la app pregunta *"¿Quieres jubilar El Roble Grande y elegir un sit spot nuevo? Si lo haces, El Roble Grande seguirá en tu cuaderno como página, pero tu nuevo sit spot empezará desde cero."*. Esto refleja el principio del libro: el sit spot se construye con tiempo.

### 7.3 Mapa offline

Implementación con `flutter_map` + tiles raster OSM pre-descargadas:

- Al configurar SitSpot, se descarga el área de 5km a la redonda en zoom 12-16.
- Almacenamiento estimado: ~30-50 MB por área. Aceptable.
- Fuentes: OpenStreetMap directamente o servicios compatibles que no impongan tracking.

## 8. Servicio de fenología

### 8.1 Por qué hace falta

Los Misterios y los nudges del sistema necesitan saber qué es típico **aquí y ahora**:

- *"Pronto deberían aparecer las primeras cigüeñas en tu zona"* (febrero, latitud ibérica).
- *"En tu región, el almendro suele florecer entre mediados de enero y mediados de febrero"* (mediterráneo).
- *"Los líquenes son más visibles ahora con la humedad"* (otoño en Cantábrico).

Sin esto, el juego es genérico y pierde anclaje al lugar. Con esto, gana especificidad sin requerir contenido por niño.

### 8.2 Diseño del servicio

Microservicio server-side dentro del plugin `nuevo-ser-core`. API:

```
GET /nuevo-ser/v1/fenologia?region={code}&fecha={iso_date}
retorna: {
  estacion: 'otono'|'invierno'|'primavera'|'verano',
  semana_estacional: 1-13,
  marcadores_proximos: [
    { evento: 'llegada_cigueñas', ventana: '2026-02-04..2026-02-22', confianza: 'alta' },
    { evento: 'floracion_almendro', ventana: '2026-01-15..2026-02-20', confianza: 'media' },
    ...
  ],
  sugerencias_misterios: [ ...id_codes ]
}
```

### 8.3 Fuente de datos

Calendario fenológico construido manualmente para regiones cubiertas (inicialmente Iberia peninsular más Baleares y Canarias en versiones posteriores). Datos por región y especie:

```yaml
# content/fenologia/iberia/cigueña_blanca.yaml
especie: Ciconia ciconia
nombre_comun_es: cigüeña blanca
nombre_comun_eu: amiamoko zuri
nombre_comun_ca: cigonya blanca
eventos:
  - evento: llegada_invernantes
    regiones:
      ES-NA: { ventana: '01-25..02-15', confianza: alta }
      ES-AN: { ventana: '12-20..01-15', confianza: alta }
      ES-CT: { ventana: '02-01..02-25', confianza: media }
  - evento: salida_estival
    ...
```

Bajo CC-BY-SA. Curaduría inicial por el equipo, validación por ornitólogos y botánicos del territorio. Esto es trabajo importante y se hace despacio — empezar con 30-40 marcadores fenológicos cubre lo esencial.

### 8.4 Cuando no hay datos

Para regiones sin cobertura fenológica detallada (mucho del mundo en versiones futuras), el servicio devuelve solo estación y semana estacional, sin marcadores. Los Misterios se filtran a los que aplican universalmente.

## 9. Privacidad por diseño

### 9.1 Tres reglas innegociables

Replican y extienden las de `nuevo-ser-core-arquitectura.md` §7.4:

**Regla 1**: Datos crudos en dispositivo. Texto libre, fotos, dibujos, conversaciones — solo Isar local cifrado. Nada en servidor por defecto.

**Regla 2**: Solo agregados firmados al servidor. Cliente computa, firma con HMAC, envía. Servidor verifica firma.

**Regla 3**: Vistas adultas consultan agregados, no datos. Vista del cuidador y vista del aula están construidas exclusivamente sobre tablas de agregados con k≥5 cuando aplica.

### 9.2 LOPDGDD para menores

Para niños <14 años en España (Ley Orgánica 3/2018 art. 8), el consentimiento parental es requisito. Implementación:

- Al crear cuenta, si la edad declarada es <14, se requiere flujo de consentimiento parental.
- Tres métodos aceptables (heredados del estándar Colección): email verificado del cuidador (mínimo), formulario firmado escaneado (medio), aval del centro educativo vinculado (más robusto).
- Hasta que `consent_verified_at` se establece, la cuenta del niño está en estado `pending`. Puede usar la app en modo local (todo en dispositivo) pero sin sincronización a servidor.

### 9.3 Borrado real

Cuando el niño o cuidador solicitan borrado:

1. Marcar cuenta `pending_deletion`.
2. Job asíncrono <24h:
   - DELETE FROM wp_ns_observaciones WHERE user_id = ?
   - DELETE FROM wp_ns_mastery_records WHERE user_id = ?
   - DELETE FROM wp_ns_sit_spots WHERE user_id = ?
   - DELETE FROM wp_ns_paginas_cuaderno_meta WHERE user_id = ?
   - DELETE FROM wp_ns_classroom_members WHERE user_id = ?
   - DELETE FROM wp_ns_caregiver_links WHERE child_user_id = ? OR caregiver_user_id = ?
   - Borrar blobs en R2 con tag de tombstone.
3. Aviso a backups: tag para purgar siguiente ciclo.
4. Email de confirmación al solicitante.
5. El cuaderno local se ofrece exportar a PDF antes del borrado.

### 9.4 Auditabilidad

Código bajo AGPL-3.0. Cualquiera puede auditar que las reglas se cumplen. Tests de integración explícitos para cada regla:

- **Test**: una observación con `what_seen='secreto'` se sincroniza al servidor; verificar que `secret` no aparece en la base de datos del servidor (solo el hash).
- **Test**: una vista del aula con 4 niños vinculados a una habilidad NO devuelve datos para esa habilidad (k<5).
- **Test**: borrado de cuenta deja todas las tablas consultadas para ese user_id vacías.
- **Test**: HMAC inválido en agregado devuelve 401.

## 10. Offline-first y media local

### 10.1 Lo que funciona offline

Sin red:

- Crear, editar, borrar observaciones.
- Hacer fotos, dibujar, escribir.
- Volver al SitSpot y registrar visita.
- Ver el cuaderno completo, todas las páginas.
- Navegar el mapa local pre-descargado.
- Ver Misterios ya cargados.
- Componer mosaicos de estación.

Sin red **no funciona**:

- Tutor IA (las preguntas se encolan; el niño es informado).
- Sincronización de mastery con cuidador/aula.
- Descarga de Misterios nuevos.
- Actualización del calendario fenológico.

### 10.2 Almacenamiento local

Isar Community + Isar `cifrado en reposo` (clave derivada de la cuenta del niño + dispositivo). Esto significa que si alguien roba el dispositivo y lo descifra, **necesita** la cuenta del niño activa para acceder al contenido.

Estimación de uso de espacio:

- Texto y metadatos: ~1-5 MB por año de uso intensivo.
- Fotos (JPEG comprimido a max 1024px): ~200 KB/foto. 200 fotos/año = ~40 MB.
- Dibujos (SVG): <50 KB/dibujo. Despreciable.
- Tiles del mapa: ~30-50 MB (configuración inicial; no crece).

Total realista: **<100 MB por niño tras un año de uso intenso**. Aceptable para cualquier dispositivo.

### 10.3 Compresión y formato de fotos

Las fotos se comprimen al guardar:
- Resolución máxima: 1024px lado mayor.
- Formato: JPEG progresivo, calidad 75.
- EXIF: se conserva fecha/hora, **se elimina geolocalización** (ya está como metadato separado).

### 10.4 Compartir media

Cuando el niño explícitamente comparte una observación con su cuidador o aula:

1. Cliente sube blob (foto/dibujo) a R2 cifrado.
2. Genera `blob_id` y devuelve al cliente.
3. Cliente actualiza `wp_ns_observaciones.photo_blob_id` con consent registrado.
4. R2 conserva el blob hasta que (a) el niño revoca compartir, (b) se borra la cuenta, (c) pasan 90 días sin acceso.

## 11. Internacionalización

### 11.1 Idiomas soportados

MVP: castellano (`es`), euskera (`eu`), catalán (`ca`).

Toda la UI, todas las claves de identificación, todos los Misterios disponibles en los 3 idiomas. Material para profesores y cuidadores idem.

### 11.2 Detalle euskera

Vocabulario especializado de naturaleza en euskera está documentado pero distribuido. Para curaduría se trabaja con:
- Diccionario Elhuyar (técnico-científico).
- Materiales de Aranzadi Zientzia Elkartea.
- Validación por euskaltzaina especializado en biología.

Variaciones dialectales: el sistema usa euskera batua como referencia, con notas a pie cuando un nombre regional es notablemente distinto.

### 11.3 Detalle catalán

Validación con materiales del Institut d'Estudis Catalans, especialmente la sección de ciencias.

### 11.4 Idiomas adicionales

Galego como prioridad post-MVP. Otros idiomas peninsulares y europeos según contratos institucionales.

## 12. Roadmap técnico

| Sprint | Duración | Resultado |
|---|---|---|
| **S1** | 2 sem | Scaffolding (ver `prompt-claude-code`). Tres pantallas con datos sembrados. Sin red. |
| **S2** | 3 sem | Integración con `nuevo-ser-core`. Cuenta. Sincronización básica. Sin Tutor todavía. |
| **S3** | 4 sem | Perfil P5 implementado. Motor adaptativo en local con paridad PHP. |
| **S4** | 3 sem | Tutor IA real. Prompts versionados. Filtros de salida. Tests. |
| **S5** | 4 sem | Geolocalización, SitSpot, mapa offline OSM. |
| **S6** | 3 sem | Servicio de fenología. Calendario inicial Iberia (30-40 marcadores). |
| **S7** | 3 sem | Acompañamiento. Vista del cuidador (resúmenes). Vista del aula (k≥5). |
| **S8** | 3 sem | Polish, accesibilidad WCAG 2.1 AA, i18n completo es/eu/ca, exportar PDF. |
| **S9** | piloto | 12-15 niños, una estación. Iteración. |

**Total estimado**: 25 semanas de un ingeniero sénior dedicado, ~50 semanas part-time. Más el piloto.

## 13. Riesgos técnicos

### 13.1 Calidad del Tutor IA

Riesgo más alto: que el Tutor confabule, modele al niño con afecto simulado, o se desvíe del oficio. **Mitigación**: filtros de salida estrictos, lista negra ampliada, tests de regresión sobre 200+ prompts adversariales antes de cada release.

### 13.2 Coste de tokens del Tutor

Si la cuota actual (30 turnos/día/niño) escala mal con número de usuarios, el coste de Claude API puede ser problemático. **Mitigación**: caché agresivo, budget tracking por niño, posibilidad de fallback a modelo más pequeño (Haiku) para preguntas frecuentes.

### 13.3 Privacidad de geolocalización

El SitSpot con coordenadas precisas en local es delicado. Si un atacante consigue malware en el dispositivo del niño, accede a la ubicación frecuentada. **Mitigación**: cifrado en reposo, alerta clara al cuidador en el flujo de configuración del SitSpot, opción de no usar coordenadas precisas (solo `place_name`).

### 13.4 Calendario fenológico desactualizado por cambio climático

Las ventanas fenológicas están cambiando con el clima. Un calendario rígido envejece mal. **Mitigación**: calendario versionado, actualización anual con asesoría científica, marcado explícito de confianza ("la ventana clásica es X pero los últimos 5 años se ha adelantado").

### 13.5 Paridad Dart/PHP del motor P5

El motor P5 es nuevo. Si Dart y PHP devuelven valores distintos, hay bugs invisibles. **Mitigación**: 100 fixtures de paridad obligatorias en CI, fail si epsilon > 1e-6.

---

*Fin de la Arquitectura técnica v0.1.*

*Documento sometido a revisión técnica conforme al §8 Fase 3 de los criterios de integración.*
