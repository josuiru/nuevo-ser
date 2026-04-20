# Uno Roto — Arquitectura técnica

> Documento técnico maestro.
> Versión 0.1 — MVP Era 2.
> Estado: borrador vivo. Cada decisión se revisa contra los principios de la biblia §2.

---

## 0. Resumen ejecutivo

- **Cliente**: Flutter (Android, iOS, Web) — un solo código base.
- **Backend**: WordPress headless (REST + JWT) — para contenido autorable, cuentas y dashboards.
- **Persistencia local**: SQLite vía Drift — offline-first estricto.
- **Estado**: Riverpod — por su soporte de testing, scoping por pantalla y composición de providers.
- **Tutor IA**: proxy propio delgado (Cloudflare Worker o similar) entre cliente y API de Anthropic.
- **i18n**: `.arb` en cliente para UI; WordPress localiza el contenido con parámetro `locale`.
- **Despliegue**: Play Store, App Store, web PWA (dashboards padres/maestros).
- **Licencia**: AGPL-3.0 para el cliente, GPL-2 para el backend (compatible con WP).

Cada decisión justificada en las secciones siguientes.

---

## 1. Por qué Flutter + WordPress (justificación)

### 1.1 Flutter (cliente)

**Elegido** frente a alternativas:

| Opción | Pros | Contras | Veredicto |
|--------|------|---------|-----------|
| **Flutter** | Un código iOS+Android+Web. Animación 60fps consistente. Ecosistema maduro 2025. Offline-first trivial. | Peso APK (~15-20 MB). Curva de aprendizaje Dart. | ✅ |
| React Native | Equipo JS más abundante. | Rendimiento animación inconsistente. Gestión offline más frágil. | ❌ |
| Nativo (Kotlin+Swift) | Mejor rendimiento. | Dos código bases. Coste 2× para un bien común. | ❌ |
| Unity / Godot | Mejor para juegos 3D. | Ecosistema de forms/navegación pobre (y tenemos dashboards). Peso. | ❌ |

**Razón decisiva**: el juego es **2D con animaciones vectoriales** (SVG + transformaciones), no un motor 3D. Flutter con `CustomPainter` + `flutter_animate` cubre todo el combate sin motor de juego externo. El niño en Lagos o Lima a menudo tiene dispositivos modestos: un APK ligero importa más que un motor AAA.

### 1.2 WordPress headless (backend)

Decisión inusual. Justificación:

1. **Autoría de contenido por maestros reales** (roadmap v2.5). WP Admin es la interfaz de autoría CMS mejor testada del mundo.
2. **Multilingüe**: WPML o Polylang resuelven localización de contenido con UI probada.
3. **Coste operativo bajo**: hosting WordPress es commodity, federable por municipios/colegios (sección 11).
4. **Plugins existentes**: ACF (campos personalizados para Fragmentos), Gravity Forms (encuestas a padres), BuddyBoss (comunidad futura).
5. **Compatible con GPL / código abierto**.

**Alternativas descartadas**:
- Supabase / Firebase: vendor lock-in, no autorable por no-técnicos.
- Strapi: autoría decente pero ecosistema multilingüe menos maduro.
- Django + Wagtail: excelente pero exige equipo técnico permanente; WP puede mantenerlo un voluntario no-dev.

**Riesgo reconocido**: WordPress arrastra deuda de seguridad histórica. Mitigación: endurecimiento (ver §9), solo endpoints REST expuestos, wp-admin detrás de IP allowlist en instancias institucionales.

---

## 2. Arquitectura de alto nivel

```
┌───────────────────────────────────────────────────────────┐
│                     CLIENTE FLUTTER                        │
│  ┌──────────┐  ┌────────────┐  ┌─────────────────────┐    │
│  │   UI     │←→│  Riverpod  │←→│   Capa de dominio   │    │
│  │ (widgets)│  │  (estado)  │  │ (modelos, lógica)   │    │
│  └──────────┘  └────────────┘  └──────────┬──────────┘    │
│                                            ↓              │
│       ┌────────────────────────────────────────────┐      │
│       │  Capa de persistencia (Drift/SQLite local) │      │
│       └────────────────────────────────────────────┘      │
│                           ↓                               │
│       ┌────────────────────────────────────────────┐      │
│       │   Sync engine (cola bidireccional)         │      │
│       └────────────────────────────────────────────┘      │
└───────────────────────────┬───────────────────────────────┘
                            │  (HTTPS, JSON, JWT)
                            │   — solo cuando hay red —
          ┌─────────────────┼───────────────────┐
          ↓                 ↓                   ↓
┌──────────────────┐ ┌────────────────┐ ┌──────────────────┐
│  WordPress API   │ │  Tutor-proxy   │ │  Telemetría      │
│  (contenido,     │ │  (Cloudflare   │ │  (Plausible,     │
│   cuentas,       │ │   Worker →     │ │   self-hosted)   │
│   progreso)      │ │   Anthropic)   │ │                  │
└──────────────────┘ └────────────────┘ └──────────────────┘
```

**Principio rector**: el juego es 100% jugable sin red. La red es **enriquecimiento**, nunca requisito.

---

## 3. Cliente Flutter — estructura del proyecto

```
app/
├── lib/
│   ├── main.dart
│   ├── app.dart                   # MaterialApp, router, theming
│   │
│   ├── core/                      # utilidades transversales
│   │   ├── i18n/                  # ARB + delegates
│   │   ├── theme/                 # paleta, tipografía
│   │   ├── router/                # go_router
│   │   └── errors/
│   │
│   ├── data/                      # capa de datos
│   │   ├── local/                 # Drift schema, DAOs
│   │   ├── remote/                # clientes HTTP
│   │   ├── sync/                  # motor de sincronización
│   │   └── repositories/          # fachadas sobre local+remote
│   │
│   ├── domain/                    # modelos y lógica pura
│   │   ├── fragmento/
│   │   ├── habilidad/
│   │   ├── maestria/              # cálculo de mastery
│   │   ├── combate/               # reglas del combate
│   │   ├── progresion/            # rangos, pruebas
│   │   └── jugador/
│   │
│   ├── features/                  # UI por feature
│   │   ├── combate/
│   │   ├── distrito/
│   │   ├── dialogo/
│   │   ├── prueba_ascenso/
│   │   ├── tutor_ia/
│   │   ├── dashboard_padres/
│   │   └── ajustes/
│   │
│   └── motor_pedagogico/          # selección de siguiente actividad
│       ├── selector.dart
│       └── curva_olvido.dart
│
├── test/                          # unit tests
├── integration_test/              # flujos completos
├── assets/
│   ├── i18n/                      # ES, EU, CA
│   ├── ilustraciones/             # SVG vectoriales
│   └── audio/                     # lo-fi loops, efectos
└── pubspec.yaml
```

### 3.1 Dependencias clave (pubspec)

- `flutter_riverpod` — estado.
- `go_router` — navegación declarativa.
- `drift` + `sqlite3_flutter_libs` — BD local.
- `freezed` + `json_serializable` — modelos inmutables.
- `dio` — HTTP.
- `flutter_secure_storage` — JWT cifrado.
- `flutter_animate` + `rive` — animaciones de combate.
- `flame` (opcional) — si el combate requiere loop de render propio (decisión en §7.3).
- `connectivity_plus` — detección de red.
- `workmanager` — sincronización en background.
- `flutter_tts` — lectura en voz alta (accesibilidad).

Versiones concretas en `pubspec.yaml` (Flutter stable ≥ 3.24, Dart ≥ 3.5).

---

## 4. Modelo de datos

### 4.1 Esquema local (Drift)

**Tablas principales**:

```
jugador
  id (PK)
  nombre_mostrado
  edad                             # opcional, para ajustar curvas
  locale                           # es, eu, ca
  rango_actual
  creado_en, actualizado_en

habilidad_maestria
  jugador_id (FK)
  habilidad_id                     # ej. "E03" → mapa §2 del doc pedagógico
  mastery                          # 0.0 - 1.0
  ultima_practica                  # timestamp
  precision_20                     # media últimos 20 intentos
  mediana_velocidad_ms
  sesiones_en_umbral
  PK(jugador_id, habilidad_id)

sesion
  id (PK)
  jugador_id (FK)
  inicio, fin
  combates_jugados
  fatiga_detectada (bool)

intento
  id (PK)
  sesion_id (FK)
  habilidad_id
  fragmento_tipo                   # "B3", "F_dual", etc.
  dificultad (L1|L2|L3)
  acierto (bool)
  duracion_ms
  timestamp

fragmento_cache                    # contenido sincronizado desde WP
  id (PK)
  tipo                             # A, B, C, D, ...
  valor                            # "1/3", "0.25", "25%"
  locale
  payload_json                     # todo el resto (aspecto, comportamiento)
  version
  sincronizado_en

mision_cache
  id (PK)
  distrito_id
  locale
  payload_json
  rango_minimo
  version

dialogo_cache
  id (PK)
  personaje_id
  trigger                          # qué dispara este diálogo
  locale
  texto
  version

sync_cola
  id (PK)
  tipo                             # "intento", "sesion", "ajuste"
  payload_json
  intentos
  siguiente_intento_en
```

### 4.2 Principios del modelo

1. **Todo cacheado localmente**. El niño abre el juego en modo avión y funciona.
2. **Progreso es local canónico**. El servidor es réplica; el cliente manda en conflictos de progreso (biblia §2.3 — nunca mentir al niño sobre su nivel real).
3. **Contenido es remoto canónico**. Los Fragmentos y misiones vienen del servidor; el cliente los cachea por versión.
4. **Intentos se acumulan** hasta que haya red. Nunca se pierden.

### 4.3 Esquema remoto (WordPress)

Custom post types:

- `fragmento` — campos ACF: tipo, valor, aspecto_svg, comportamiento_json, distritos[], rango_minimo, familia.
- `mision` — campos: distrito, rango_minimo, estructura_json, diálogos_asociados[].
- `dialogo` — campos: personaje, trigger, texto (multilingüe).
- `tecnica` — campos: maestro, efecto_json, animacion.
- `personaje` — campos: rol, arco_narrativo, avatar_svg.

Taxonomías:

- `distrito` — Tejados, Canales, Mercado, Industria, Puerto, Afueras.
- `familia` — A, B, C, D, E, F, G, H, I, J.

Multilingüe vía **Polylang** (más ligero que WPML, GPL nativo). Cada CPT tiene traducciones vinculadas.

### 4.4 Endpoints REST (custom namespace)

```
/wp-json/uroto/v1/
  GET  /manifest?locale=es               # versiones de cada paquete
  GET  /fragmentos?since=<v>&locale=es
  GET  /misiones?since=<v>&locale=es
  GET  /dialogos?since=<v>&locale=es
  GET  /tecnicas?since=<v>&locale=es
  POST /progreso                         # batch de intentos y actualizaciones
  GET  /progreso/:jugador_id             # para dashboard padres
```

Autenticación: JWT (`jwt-authentication-for-wp-rest-api`), refresh tokens en `flutter_secure_storage`.

Cuentas anónimas: el cliente puede operar sin cuenta (solo local). Si el adulto crea cuenta, se genera JWT y se vincula el progreso local al usuario remoto por primera vez.

---

## 5. Motor de maestría (mastery engine)

Se ejecuta **en el cliente**. No hay round-trip por respuesta.

### 5.1 Actualización por intento

Pseudocódigo:

```dart
void registrarIntento({
  required String habilidadId,
  required bool acierto,
  required int duracionMs,
  required Dificultad dificultad,
}) {
  final actual = repo.obtener(habilidadId);

  // 1. Actualizar precisión (ventana móvil de 20)
  final precision = _actualizarVentanaPrecision(actual, acierto, dificultad);

  // 2. Actualizar mediana de velocidad (móvil)
  final velocidad = _actualizarMedianaVelocidad(actual, duracionMs);

  // 3. Consistencia (cuántas sesiones distintas con umbral)
  final sesiones = _recalcularSesiones(actual, precision);

  // 4. Retención (descuento por días sin practicar)
  final retencion = _factorRetencion(actual.ultimaPractica);

  // 5. Mastery combinado
  final mastery = _combinar(
    precision: precision,
    velocidad: velocidad,
    sesiones: sesiones,
    retencion: retencion,
  );

  repo.guardar(habilidadId, mastery, ahora);
}
```

### 5.2 Fórmula de combinación

Ponderación inicial (ajustable con datos):

```
mastery = 0.45 * precision
        + 0.25 * velocidad_normalizada
        + 0.20 * consistencia
        + 0.10 * retencion
```

- `precision` ∈ [0,1]: acierto ponderado por dificultad de las instancias.
- `velocidad_normalizada` ∈ [0,1]: `clamp(1 − (mediana_actual / mediana_personal_objetivo), 0, 1)`.
- `consistencia` ∈ [0,1]: `min(sesiones_en_umbral / 3, 1)`.
- `retencion` ∈ [0,1]: `exp(−días_sin_practica / τ_hab)` del doc pedagógico.

### 5.3 Desbloqueo de rango

Un rango se desbloquea cuando:

```
todas_habilidades_requeridas.every((h) => mastery[h] >= 0.8)
|| (
  habilidades_bajo_umbral.length <= 2
  && habilidades_bajo_umbral.every((h) => mastery[h] >= 0.7)
  && resto.every((h) => mastery[h] >= 0.8)
)
```

Margen de tolerancia del doc pedagógico §"Tabla de rangos".

### 5.4 Por qué cliente-side

- **Offline**: el ascenso debe funcionar sin red.
- **Latencia**: la reacción visual (barras que suben, Sora comentando) debe ser instantánea.
- **Privacidad**: minimiza datos enviados. Solo se suben agregados.

Servidor recalcula por su cuenta al recibir intentos (para dashboards). En caso de discrepancia, **gana el cliente** (principio: no mentir al niño).

---

## 6. Motor pedagógico — selector de siguiente actividad

Algoritmo adaptativo simple, ubicado en `motor_pedagogico/`.

### 6.1 Objetivo

Dada la sesión actual, elegir **la siguiente habilidad a ejercitar** que maximiza:

1. Aprendizaje efectivo (zona próxima de desarrollo).
2. Variedad (no repetir la misma 5 veces seguidas).
3. Refresco de habilidades decayentes.

### 6.2 Heurística inicial (v0.1)

Cada tick de "qué tocar":

```
candidatas = habilidades_desbloqueadas(jugador)
            .donde(prerequisitas_dominadas)

puntuar(h) =
    urgencia_olvido(h)          # alta si mastery cae por retención
  + progresion_activa(h)        # alta si mastery ∈ [0.3, 0.8]
  − fatiga_reciente(h)          # baja si se acaba de repetir
  + peso_mision_activa(h)       # si el distrito actual la privilegia

siguiente = argmax(candidatas, puntuar)
```

Sencillo deliberadamente. La biblia avisa contra la sobre-ingeniería pedagógica inicial. Se refina con datos reales de niños (sección 12).

### 6.3 Detección de atasco

Si `intentos_recientes(h).precision < 0.4` durante ≥ 6 intentos, el motor:

1. Marca la habilidad como "atascada".
2. Baja la dificultad (L2 → L1).
3. Si persiste, dispara **intervención del tutor IA** (§8) o un NPC pre-scriptado.

### 6.4 Detección de fatiga

Cuando en una sesión:
- precisión global cae > 20% respecto al inicio de sesión, **o**
- mediana de velocidad aumenta > 50%, **o**
- duración de sesión > 20 minutos,

el juego propone descansar. **Nunca obliga**. Sora o el NPC dice: *"Hoy estás ya un poco cansado, ¿mañana seguimos?"*.

---

## 7. Motor de combate

### 7.1 Arquitectura

Pantalla de combate = widget Flutter con **dos capas**:

1. **Capa de simulación** (pura, Dart): estado del combate, reglas, reloj interno. 60 ticks/s.
2. **Capa de render** (Flutter): widgets + `CustomPainter` para el Fragmento y efectos. Se suscribe al estado vía Riverpod.

Separación estricta para testear la capa de simulación sin framework.

### 7.2 Estado del combate

```dart
class CombateEstado {
  final Fragmento fragmento;
  final int ki;
  final List<AccionEnCurso> accionesEnCurso;
  final Duration tiempoTranscurrido;
  final List<IntentoCombate> intentos;
  final EstadoResolucion resolucion;  // enCurso | escapado | resuelto
}
```

Transiciones por `Accion`:

```
AccionCortar(direccion, denominador) → nuevoEstado
AccionAtacar(parte)                  → nuevoEstado
AccionFusionar(a, b, denCom)         → nuevoEstado
AccionDescomponer(fragmento)         → nuevoEstado
AccionEquivaler(nuevaForma)          → nuevoEstado
AccionConvertir(tipoObjetivo)        → nuevoEstado
AccionTecnica(tecnicaId)             → nuevoEstado
AccionMeditar(ms)                    → nuevoEstado
```

Cada acción:
- Valida matemáticamente (cortar 1/3 en 4 no es válido → feedback suave).
- Registra intento (éxito/fallo, tiempo).
- Emite efecto visual.

### 7.3 ¿Flame o Flutter puro?

**Decisión inicial**: Flutter puro con `CustomPainter` + `AnimationController`. Motivos:

- Los combates son cortos (30s – 5min), no loop continuo.
- Queremos integración natural con Riverpod y go_router.
- Menos dependencias = APK más ligero.

**Reevaluar si**: el rendimiento con ≥ 20 Fragmentos simultáneos en pantalla baja de 60fps en gama media. En ese caso, migrar la escena de combate a Flame.

### 7.4 Gesto de cortar

Prototipo crítico. Implementación:

- `GestureDetector` con `onPanStart/onPanUpdate/onPanEnd`.
- La trayectoria del dedo se muestrea y se ajusta (fit) a la **recta / curva** más cercana.
- Si el gesto produce **n trazos equidistantes** sobre el Fragmento → corte en n partes.
- El Fragmento tiene reglas de aceptación: un Tercio solo acepta cortes que pasen por su centro y dividan en 3 sectores iguales (±15° de tolerancia).

Tolerancia gestual **generosa** al principio (niño de 10 con pantalla de 5"). Se aprieta con el progreso.

---

## 8. Tutor IA — integración con Anthropic

### 8.1 Arquitectura

```
App Flutter ─── HTTPS ───▶ Tutor Proxy (Cloudflare Worker)
                                │
                                ├─ rate limiting por jugador
                                ├─ filtro de contenido
                                ├─ presupuesto diario
                                └─ logging anonimizado
                                        │
                                        ▼
                                Anthropic API (Claude)
```

**Nunca** se llama a Anthropic directamente desde el cliente. Razones:

- Clave API no puede viajar en el binario.
- Control de presupuesto (coste por jugador/día tope duro).
- Filtrado y moderación centralizados.
- Logging para mejorar.

### 8.2 Modelos

Por defecto **Claude Haiku 4.5** (`claude-haiku-4-5-20251001`) para:
- Respuestas de atasco (explicaciones breves).
- Prueba de espejo (diálogo con el Fraccionista virtual).

Escalar a **Claude Sonnet 4.6** solo si un niño pide una explicación larga y el modelo Haiku no cubre. Haiku cubrirá el 95% de casos.

### 8.3 Prompt caching

Usar prompt caching de Anthropic para:
- Contexto del personaje (Sora, maestros) — cache TTL 1h.
- Estado pedagógico del niño (rango, habilidades dominadas) — cache corta.

Rebaja coste ~70% en uso repetido.

### 8.4 Offline

Sin conexión, el NPC usa respuestas pre-escritas del paquete de diálogos sincronizado. El niño no percibe diferencia salvo una leve pérdida de personalización.

### 8.5 Presupuesto

Objetivo: **≤ 0,02 €/jugador/mes** de media en costes de API. Se logra porque el tutor IA solo se activa en momentos concretos (biblia §14.3).

Límite duro por jugador: 30 llamadas/día. Si se excede, el NPC usa respuestas pre-escritas el resto del día.

---

## 9. Privacidad, seguridad, COPPA/GDPR

### 9.1 Principios técnicos

- Cuenta local por defecto. Cuenta online es **opt-in explícito** de un adulto.
- Nombre de usuario puede ser ficticio. No se pide edad exacta, solo rango de edad.
- Sin publicidad, sin SDK de tracking, sin analytics de terceros.
- Cifrado: TLS 1.3 en tránsito; SQLite cifrado opcional (SQLCipher) cuando hay cuenta online.
- JWT con expiración corta (15 min) + refresh token (30 días, revocable).

### 9.2 Endurecimiento WordPress

- wp-admin detrás de IP allowlist en instancias institucionales.
- Plugins firmados, desactualizados automáticamente aislados.
- Wordfence o Patchstack como capa mínima.
- Sin usuarios registrables públicamente (solo invitación).
- Cabeceras seguras (CSP, HSTS, Permissions-Policy).

### 9.3 Datos retenidos

| Dato | Dónde | Retención |
|------|-------|-----------|
| Progreso matemático | Cliente + opcional servidor | Indefinida hasta que el adulto la borre |
| Intentos detallados | Cliente 90 días; servidor agregado | Detalle no sale del dispositivo salvo agregados |
| Conversaciones con tutor IA | Ninguna retención del contenido; solo métricas anónimas | — |
| Identificadores | Solo UUID opaco del dispositivo | Borrable |

### 9.4 Derechos GDPR

Endpoints del dashboard de padres:
- Exportar todos los datos del niño (JSON).
- Borrar la cuenta y todos los datos asociados (hard delete, 30 días de gracia).

---

## 10. i18n — arquitectura de localización

### 10.1 Capas separadas

1. **UI estructural** (botones, menús, etiquetas): archivos `.arb` en Flutter (`flutter_localizations` + `intl`).
2. **Contenido narrativo** (diálogos, descripciones de Fragmentos, nombres de técnicas): WordPress + Polylang, llegando al cliente con `?locale=eu` en el endpoint.
3. **Contenido matemático** (números, símbolos): universal, sin traducción, pero con **formato local** (coma decimal en ES/EU/CA vs punto en EN).

### 10.2 Locales del MVP

- `es` — castellano (base).
- `eu` — euskera.
- `ca` — catalán.

Fallback: si falta traducción, cae a `es`. Se loguea para priorizar.

### 10.3 Flujo de autor

1. Maestro/traductor escribe diálogo en `es` en WordPress.
2. Polylang crea traducción vinculada en `eu` y `ca`.
3. Cliente sincroniza paquete según locale activo.

### 10.4 Textos matemáticos delicados

"Un cuarto" vs "un quart" vs "laurden bat" — el juego usa la fracción escrita (`1/4`) como representación universal y la forma léxica solo en narrativa. Evita falsos amigos.

### 10.5 TTS (lectura en voz alta)

`flutter_tts` usa la voz del sistema del locale activo. Si el sistema no tiene voz en euskera (común), cae a castellano y se marca en ajustes con aviso honesto.

---

## 11. Despliegue y operación

### 11.1 Entornos

- **dev**: WordPress local (Docker), app en emulador/dispositivo.
- **staging**: WP en VPS (2 €/mes), app en canal interno (TestFlight / Play Internal).
- **producción**: WP en VPS mayor o en nodo institucional; app en stores.

### 11.2 CI/CD

GitHub Actions (o Forgejo Actions si vamos 100% FOSS):
- Lint + tests en PR.
- Build AAB/IPA en tags `v*`.
- Deploy WP vía `wp-cli` a staging automático, a prod con aprobación manual.

### 11.3 Federación futura

Cada municipio/colegio puede desplegar su propio nodo WP con su contenido y maestros. El cliente Flutter lee la URL del nodo de un setting (configurable por código QR al instalar).

El nodo central (primera autoridad) sirve el contenido canónico; los nodos hijos pueden añadir contenido local (misiones específicas del colegio, personajes locales).

---

## 12. Validación pedagógica

La arquitectura habilita, pero no sustituye, la validación con niños reales.

**Hitos**:

1. **Test de gesto** (mes 1, prototipo de combate aislado): 5-10 niños, observar si el corte "se siente". Criterio: el niño sonríe al cortar bien.
2. **Test de sesión completa** (mes 3, vertical slice Tejados): 15 niños, 3 sesiones de 15 min distribuidas. Medir retorno espontáneo a sesión 2.
3. **Test de progresión** (mes 6, MVP): 30 niños, 4 semanas. Medir ascensos de rango, habilidades dominadas, y crucialmente **tasa de abandono**.

Datos de validación son propiedad del proyecto y se publican en abierto (agregados, nunca individuales) para mejorar el ecosistema educativo hispanohablante.

---

## 13. Open source y licencias

- Cliente Flutter: **AGPL-3.0**. Cualquier fork desplegado como servicio debe liberar sus cambios.
- Backend WordPress (configuración y plugins propios): **GPL-2** (compatible con WP).
- Contenido (diálogos, ilustraciones, música): **CC-BY-SA 4.0**.
- Nombre "Uno Roto": marca registrada para proteger identidad, uso libre bajo condiciones (fork educativo sin ánimo de lucro: sí; producto comercial con el mismo nombre: no).

Repositorio público desde el día cero. Contribuciones bienvenidas con CLA ligero (para permitir relicenciar en el futuro si hace falta).

---

## 14. Decisiones pendientes

Listadas explícitamente para revisión:

1. **Motor de render del combate**: Flutter puro vs Flame. Resolver tras prototipo de gesto.
2. **Hosting canónico del nodo central**: VPS autoalojado vs cooperativa de hosting (p.ej. Communia, OVH asso). Decisión tras primera financiación.
3. **Proveedor de IA de reserva**: ¿fallback a un modelo local (llama.cpp on-device) si la API de Anthropic no está disponible? Evaluar factibilidad en gama media.
4. **Telemetría**: Plausible self-hosted vs nada. El mínimo ético es cero — confirmar si los dashboards pueden vivir solo con agregados enviados voluntariamente.
5. **Formato de autoría de Fragmentos**: ACF directo vs DSL propio en YAML. Probable: YAML importable a ACF vía wp-cli.

---

## 15. Siguiente paso técnico

1. **Crear el repo** `uno-roto/` con estructura base (Flutter project + `/backend/wordpress/` + `/docs/`).
2. **Prototipo del combate** (4-6 semanas de un dev solo): solo Familia B2-B5, sin narrativa, sin sync, sin backend. Objetivo único: validar el gesto de cortar.
3. **Test con 5-10 niños** antes de construir nada más.

Si el prototipo aprueba: arrancar arquitectura completa. Si suspende: rediseñar el gesto antes de escribir una línea de arquitectura de producción.

*Fin de arquitectura v0.1.*
