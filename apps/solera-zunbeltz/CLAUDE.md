# Solera Zunbeltz — CLAUDE.md

Cerebro persistente del proyecto. Se lee al inicio de cada sesión.

> **Estado**: **FZ-1 → FZ-3 implementados** (2026-06-21). La reunión inicial con Zunbeltz Elkartea se pospuso; la persona de contacto dejó el puesto. Zunbeltz mantiene el interés y prepara una **solicitud de subvención** (~7.770 € IVA incl.) para la que se les entregó **factura proforma** (`comercial/factura-proforma.html`) y **presentación v0.2** (`presentacion/index.html`, ahora con financiación por fases atada a subvenciones reales: TEDER/LEADER, innovación PEPAC Navarra, RETA).
>
> Construido (single-device, offline, bilingüe es/eu): esqueleto Flutter+Melos con i18n y branding monte+crema+ocre (FZ-1); modelos `Finca`/`PuntoInfraestructura`/`TareaMantenimiento` + BD sqflite con tests (FZ-2); **módulo de gestión de fincas demoable** — mapa de las 2 fincas con puntos por GPS, ficha con tareas, tablero filtrable y parte PDF (FZ-3). 15 tests verdes, analyze limpio, build Linux OK. **El euskera de los ARB es borrador pendiente de revisión nativa**; los datos de fincas son un seed de ejemplo (los reales se cargan con Zunbeltz). Co-diseño con el equipo sigue pendiente para el resto de fases.

## Encuadre

Sexto fork de la **Suite Solera** dentro del monorepo, pero el **más distinto de todos**. Las cinco Solera anteriores asumen *una explotación, un titular* (o un ayuntamiento en arbolado). Zunbeltz rompe ese supuesto: es un **Espacio Test Agrario** — una incubadora de proyectos agroganaderos.

**Qué es Zunbeltz** (fuentes públicas, ver `presentacion/`): primer espacio test agroganadero de Navarra, impulsado por el Gobierno de Navarra + Mancomunidad de Andía + municipios (Abárzuza, Lezaun, Guesálaz, Yerri, Salinas) + financiación UE, gestionado por la **Asociación Zunbeltz Elkartea**. El Gobierno de Navarra ha cedido a la Mancomunidad las fincas de **Zunbeltz (231 ha, ~34 ha pascícolas)** y **La Planilla (197 ha, ~3,9 ha pastos)** con autorización de uso a 10 años. En ellas se practica **ganadería ecológica en extensivo** (bovino + ovino) y se ofrece a personas emprendedoras un entorno seguro para **testar un proyecto agrario durante un periodo acotado**, con **acompañamiento y formación** de ganaderos expertos, para evaluar su viabilidad y sus competencias de cara a una futura instalación. Incluye además un **banco de tierras / relevo generacional** (cedentes que se jubilan ↔ nuevas generaciones) y venta directa de producto en **La Venta de Zunbeltz**. Valores declarados: colaboración, economía circular, conservación de recursos y valores naturales.

**Por qué importa al monorepo**: Zunbeltz es el punto donde se tocan **las dos mitades del repo**. Un testador "aprendiendo a ser ganadero ecológico extensivo" bajo tutela es, estructuralmente, lo mismo que un aprendiz Kids progresando por un mapa de **maestría** acompañado por el **Companion** — sólo que el dominio es ganado real y la evaluación es de viabilidad económica real. La Capa A reutiliza la Suite Solera; la Capa B reutiliza el motor de maestría + acompañamiento de `nuevo_ser_core` / `nuevo_ser_companion`.

## Diana / cliente

Producto **B2B institucional**, no SaaS individual (Zunbeltz está financiado con fondo público). El comprador es la **entidad gestora** (Zunbeltz Elkartea / Mancomunidad de Andía). El alcance comercial real no es Zunbeltz solo, sino la **red estatal de Espacios Test Agrarios** (espaciostestagrarios.org): el producto vendible es una **plataforma replicable para ETAs**, donde Zunbeltz es el piloto y cada nuevo espacio instancia la misma app con sus fincas, sus mentores y la(s) vertical(es) productiva(s) que correspondan — reutilizando las verticales Solera ya construidas. **El ETA es el contenedor multi-tenant que orquesta las verticales.**

## La idea en una frase: dos capas

- **Capa A — El cuaderno del testador** (`Solera Ganadería Extensiva Ecológica`): vertical Solera nueva, hermana de apícola, pero con **bovino + ovino en extensivo** y certificación ecológica. Entidad de identidad persistente = el **animal** (crotal/DIB) agrupado en **lote/rebaño**.
- **Capa B — El panel del acompañamiento** (`Espacio Test`): el cuaderno del coordinador (Zunbeltz Elkartea) y del ganadero-mentor: gestión de fincas e infraestructuras compartidas, convocatorias, cesión de recursos, plan de acompañamiento, evaluación de viabilidad, banco de tierras.

Recomendación de arquitectura: **vertical ganadera autónoma + módulo ETA encima**, no app monolítica. La vertical ganadera tiene mercado propio (cualquier ganadero extensivo ecológico); el ETA la orquesta para varios testadores. (Decisión humana pendiente — ver BLOQUEOS.)

## Módulo destacado para la reunión — Gestión de fincas e infraestructuras compartidas

Petición explícita del equipo de cara a la reunión: *"un espacio para la administración y gestión de las fincas, con posibilidad de marcar los distintos puntos en el mapa y asignar tareas de mantenimiento"*. Es además el entregable **más demostrable y menos bloqueado por compliance** — por eso se adelanta en el roadmap (FZ-3).

- **Puntos de interés / infraestructuras** sobre el mapa de las dos fincas: abrevaderos, mangas de manejo, cierres/alambradas, refugios y cabañas, cuadras, almacenes, balsas y puntos de agua, comederos, cargaderos, parcelas de pasto. Cada punto = entidad con tipo, ubicación GPS, estado y fotos.
- **Tareas de mantenimiento asignables** ancladas a un punto (o a una parcela): título, descripción, **responsable** (testador, mentor, operario, externo o sin asignar), prioridad, fecha objetivo, **estado** (pendiente / en curso / hecha / bloqueada), fotos antes/después y coste opcional (enchufa con el libro económico).
- Vista de **mapa** (clustering OSM, FAB para colocar punto con GPS) + vista de **lista/tablero de tareas** filtrable por finca, estado y responsable. Parte de mantenimiento exportable a PDF (reusa `informe_periodico_pdf` del core).
- Es la pieza que justifica de raíz el **multi-tenant**: dos testadores que comparten abrevadero y manga necesitan ver y coordinar las mismas tareas.

## Roles (multi-tenant — necesario antes que en el resto de Solera)

- **Testador / emprendedor** — lleva su proyecto, su rebaño cedido, su cuaderno; ve y crea tareas de las fincas/infraestructuras que usa.
- **Mentor / ganadero experto** — acompaña a 1-N testadores, registra tutorías, valida hitos, asigna tareas.
- **Coordinador (Zunbeltz Elkartea / Mancomunidad)** — gestiona convocatorias, cesiones de recursos, evaluación global, mantenimiento de las fincas.
- **Asesor técnico / veterinario** — invitado puntual, firma sanitario/PDF.

Esto fuerza resolver dos bloqueos ya conocidos del repo: el **auth de profesor/cuidador** del companion (JWT actual sólo lleva `nino_id`) y la **decisión F4 de backend Solera** (stack/auth/monetización). Zunbeltz es la primera app del monorepo que **necesita** backend multi-rol desde fase media, no como extra.

## Stack

Heredado de la Suite Solera (ver pubspec de las hermanas). Consume `nuevo_ser_core` por path local para `GestorFotos`, `csv_io`, `informe_periodico_pdf`, `CampoAutocompleteCatalogo<T>`, `SelectorFotos`, banners de declaración obligatoria. `flutter_map` + `flutter_map_marker_cluster` + `geolocator` para el mapa de fincas. Sin Flame, sin Riverpod, sin Isar.

Añadidos previsibles respecto a las hermanas:
- **Backend multi-rol** (FZ-9) — primer cliente real del backend Solera; comparte la decisión de stack con F4 de agro.
- Reutilización del **motor de maestría + Companion** del core para la Capa B (acompañamiento + evaluación de competencias) — único caso en Solera.

## Estructura prevista

```
apps/solera-zunbeltz/
├── lib/
│   ├── datos/        base_datos.dart (sobre BaseDatosSolera del core), catalogos_generados/
│   ├── modelos/      Capa A: Animal, Lote, ExplotacionRega, ParcelaPasto, Pesaje,
│   │                          Parto, TratamientoSanitario, MovimientoPecuario,
│   │                          IncidenciaGanadera, Saca, PastoreoRotacional
│   │                 Fincas/infra: Finca, PuntoInfraestructura, TareaMantenimiento
│   │                 Capa B: Convocatoria, ProyectoCandidato, Testador, Cesion,
│   │                          HitoAcompanamiento, Tutoria, EvaluacionViabilidad,
│   │                          FichaBancoTierras
│   ├── pantallas/    mapa_fincas, lista_puntos, ficha_punto, nueva_tarea, tablero_tareas,
│   │                 lista_animales, ficha_animal, nuevo_evento, libro_explotacion,
│   │                 (Capa B) panel_coordinador, convocatorias, cesiones, acompanamiento,
│   │                 evaluacion, banco_tierras, ajustes
│   ├── servicios/    cliente_anthropic, generador_libro_explotacion,
│   │                 generador_parte_mantenimiento
│   ├── estado/       finca_activa, rol_activo, clave_anthropic
│   └── main.dart
├── content/ganaderia-extensiva/   CSVs editables por asesor (FZ-5)
├── tool/compilar_catalogos.dart
├── presentacion/index.html        ← pitch autónomo para la reunión
├── CLAUDE.md
└── BLOQUEOS-PENDIENTES.md
```

## Modelo de datos (sqflite) — resumen

Patrón Solera (singleton + migraciones aditivas no destructivas; candidato a estrenar el refactor `BaseDatosSolera` del core).

**Fincas / infraestructuras (FZ-2/3, el módulo destacado):**
- `fincas` — Zunbeltz y La Planilla (y futuras de otros ETAs). Centroide + nombre + superficie + recintos SIGPAC.
- `puntos_infraestructura` — **entidad de mapa**: tipo (abrevadero/manga/cierre/refugio/cuadra/almacén/balsa/comedero/cargadero/parcela), lat/long, estado, fotos, finca_id.
- `tareas_mantenimiento` — título, descripción, `punto_id` (o `parcela_id`) opcional, responsable_id, prioridad, fecha_objetivo, estado (pendiente/en_curso/hecha/bloqueada), fotos antes/después, coste_centimos opcional.

**Cuaderno ganadero (FZ-4, Capa A):**
- `explotaciones_rega` · `parcelas_pasto` (SIGPAC + carga ganadera admisible) · `lotes` · `animales` (entidad central: crotal/DIB/REIA, sexo, fecha nacimiento, madre, estado).
- Eventos hijos FK ON DELETE CASCADE: `pesajes`, `partos`, `tratamientos_sanitarios` (medicamento, lote, **plazo de supresión**, receta), `movimientos_pecuarios` (origen/destino, **guía de movimiento/DST**, trashumancia a puerto), `incidencias` (mortalidad, **depredación**, aborto, cojera), `saca` (matadero/vida), `pastoreo_rotacional`.
- `track` + `track_puntos` + buffer anti-crash — heredado; recorridos de pastoreo / localizar rebaño en monte.

**Espacio Test (FZ-10, Capa B):**
- `convocatorias`, `proyectos_candidatos`, `testadores`, `cesiones` (parcelas/infra/cabezas en comodato durante el periodo de prueba), `hitos_acompanamiento`, `tutorias`, `evaluaciones_viabilidad`, `fichas_banco_tierras`.

## Compliance (load-bearing, como REGA en apícola)

- **Libro de explotación ganadera** (censo, tratamientos, movimientos) → PDF firmable.
- **Identificación y movimientos**: crotal/DIB bovino, REIA ovino, **SITRAN/RIIA**, guías de movimiento pecuario / DST.
- **Cuaderno PAC + ecorregímenes** de pastos/pastoreo extensivo (RD 1311/2012 + normativa PAC vigente).
- **Certificación ecológica**: en Navarra el consejo es **CPAEN/NNPEK** — registro y trazabilidad ecológica como categoría propia.
- **Bienestar animal** + plazos de supresión de medicamentos.

Todo se entrega con sello **PROVISIONAL** hasta validación humana (veterinario + técnico OCA + Zunbeltz Elkartea + CPAEN). Patrón idéntico al de las hermanas.

## Catálogos (CSV → Dart, FZ-5) — todos PROVISIONAL hasta validación

`razas_bovino_ovino.csv` (prioridad autóctonas: Pirenaica, Betizu, Latxa cara negra/rubia, Sasi Ardi…) · `medicamentos_veterinarios.csv` (**sustancias activas + plazo de supresión, nunca marcas** — hard limit heredado de varroa) · `patologias_extensivo.csv` (banner rojo automático para **declaración obligatoria**: tuberculosis, brucelosis, lengua azul…) · `tipos_pasto_carga.csv` · `calendario_ganadero.csv` (cubriciones, partos, esquileo, desparasitación, subida/bajada de puerto por zona).

## Lenguas — bilingüe es/eu desde el día uno (decisión cerrada)

Zunbeltz es un proyecto euskaldun (Mancomunidad de Andía, zona vascófona de Navarra; el propio nombre es euskera). **Castellano y euskera son ambos de primera clase desde el principio**, no traducción añadida después. Esto afecta a:

- **UI de la app**: toda cadena en es + eu. Convendría montar el i18n (p. ej. `flutter_localizations` + ARB `es`/`eu`) en FZ-1, antes de acumular pantallas. Selector de idioma + respeto del idioma del dispositivo.
- **Catálogos** (`razas`, `patologias`, `calendario`…): columnas/campos nombre_es + nombre_eu en los CSV.
- **PDF oficiales**: en Navarra el papeleo puede emitirse bilingüe; los generadores (libro de explotación, parte de mantenimiento) contemplan plantilla es/eu.
- **Presentación** (`presentacion/index.html`): ya bilingüe con selector ES/EU (textos y mapa interactivo). El euskera es un **borrador a falta de revisión nativa** — ver BLOQUEOS.
- Paralelo útil en el monorepo: **El Descifrador** ya asume las cuatro cooficiales como contenido nuclear; aquí es es+eu mínimo. Reaprovechar criterio y, si encaja, infraestructura de idioma.

Referencia: el patrón puede extenderse a otros ETAs en zonas con lengua cooficial (catalán, gallego) cuando la plataforma se replique.

## Hard limits (heredados de la Suite Solera)

- **No recomendar medicamentos zoosanitarios comerciales por marca**. Sólo sustancias activas + manejo + derivación al veterinario asesor.
- **No inventar datos sanitarios/agronómicos**. Sin fuente clara y verificable → placeholder "v2" / sello PROVISIONAL.
- **Compliance es load-bearing**. El formato del libro de explotación y de las guías cambia con normativa estatal + decreto foral de Navarra; validar formato vigente antes de cada release.
- **Sanidad es nivel veterinario**. La app NO sustituye al veterinario; lleva la trazabilidad documental.
- **Datos sensibles del emprendedor**: la evaluación de competencias/viabilidad es información personal delicada (RGPD). Decidir con Zunbeltz quién la ve (mentor sí; ¿coordinador?; el resto de testadores no).
- **Cero PlantNet, cero imágenes Commons en BD pre-cargada**. Caché de fotos = del cliente; activos ilustrativos = stock pagado o generación propia.

## Roadmap propuesto

| Fase | Estado | Entregable |
|---|---|---|
| **FZ-0 Propuesta** | 🟡 en curso | CLAUDE.md + BLOQUEOS + `presentacion/index.html` para la reunión con Zunbeltz Elkartea. **Recoger su aportación antes de escribir código.** |
| **FZ-1 Esqueleto** | ✅ hecho | `apps/solera-zunbeltz/` Flutter+Melos, branding (monte + crema + ocre), dependencia del core, i18n es/eu, smoke test |
| **FZ-2 Modelos + BD fincas/infra** | ✅ hecho | Finca, PuntoInfraestructura, TareaMantenimiento sobre patrón Solera (BaseDatosSolera aún sin extraer del core). Tests POJO + BD (ffi) |
| **FZ-3 Gestión de fincas** ⭐ | ✅ hecho | **El módulo destacado**: mapa de las 2 fincas con puntos de infraestructura (alta con GPS), tablero de tareas de mantenimiento asignables con estado, parte PDF. Single-device. *Demoable y de valor inmediato para Zunbeltz.* |
| **FZ-4 Cuaderno ganadero** | pendiente | Animal/Lote/Parcela + eventos (pesaje/parto/tratamiento/movimiento/incidencia/saca), timeline ficha animal |
| **FZ-5 Catálogos provisionales** | pendiente | 5 CSVs ganaderos + compilador + autocomplete + banners declaración obligatoria |
| **FZ-6 Libro de explotación ganadera** | pendiente | PDF censo/tratamientos/movimientos conforme + trazabilidad ecológica CPAEN (provisional) |
| **FZ-7 IA Claude Vision ganadera** | pendiente | Diagnóstico por foto (podal, mamitis, ectoparásitos, condición corporal), hard limit medicamentos |
| **FZ-8 Económico/fiscal** | pendiente | Libro ingresos/gastos REAGP ganadero + extracto (provisional, asesor fiscal); categoría venta directa La Venta + prima PAC/ecorégimen |
| **FZ-9 Backend multi-rol** ⚠️ | **decisión humana** | Auth testador/mentor/coordinador, sync, cesiones. Comparte stack con F4 de agro y auth del companion |
| **FZ-10 Capa Espacio Test** | pendiente | Convocatorias, cesión de recursos, plan de acompañamiento (motor maestría del core), evaluación de viabilidad, dashboard coordinador |
| **FZ-11 Banco de tierras + La Venta** | pendiente | Relevo generacional (cedentes↔demandantes) + trazabilidad lote→producto→venta directa |

## Reglas de interacción

- **Voz adulta directa**, profesional. No Kids. Trato de **"vosotras"** al equipo de Zunbeltz Elkartea en materiales de presentación.
- **Nombres descriptivos en castellano** (regla del monorepo). Términos técnicos y oficiales en su forma: REGA, SITRAN, DIB, REIA, CPAEN/NNPEK, ecorégimen. Topónimos y razas en euskera respetados (Latxa, Betizu, Sasi Ardi).
- **Tests antes del código no visual**: motor, sync, persistencia, parsing.
- **Verificar antes de inventar**: datos sanitarios/normativos confirmados con fuente o consultados al asesor; sin fuente → PROVISIONAL.
- **Antes de fijar nada institucional** (modelo de datos del acompañamiento, qué se evalúa, qué ve cada rol): pasa por Zunbeltz Elkartea. Esta app se co-diseña, no se impone.

## Decisiones humanas pendientes

Ver `BLOQUEOS-PENDIENTES.md`.
