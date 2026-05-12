# Solera Aceitera — CLAUDE.md

Cerebro persistente del proyecto. Se lee al inicio de cada sesión.

## Encuadre

Sexto fork de la **Suite Solera** dentro del monorepo. Producto comercial dirigido a **almazaras pequeñas y medianas** (1-15 empleados, 100-2000 hl/campaña) en España. Hermana técnica de `apps/agro` (Solera generalista), `apps/solera-viticultura`, `apps/solera-apicola`, `apps/solera-arbolado-urbano` y `apps/solera-quesera`.

Modelo de negocio: suscripción **€15-30/mes por almazara** + opción cooperativa B2B con licencia anual cuando hay >50 socios. Comprador identificable: el maestro almazarero o el técnico responsable de una cooperativa pequeña/mediana que hoy lleva el cuaderno de campo PAC en papel + Excel del aceite + libro de movimientos del aceite que reclama la Junta de Andalucía / DGOOPP MAPA. El sector está infradigitalizado fuera de las grandes cooperativas (Dcoop, Olipe…) y ahí está la competencia (Olibu, Agroptima vertical aceite), pero ninguno cubre el ciclo completo "olivar → almazara → libro fiscal REAGP" en una sola herramienta.

## Posicionamiento — diferenciadores

1. **Cuaderno de Explotación PAC olivar**: PDF inspeccionable que cumple RD 1311/2012 (productos fitosanitarios) y los requisitos del cuaderno PAC olivar de campaña — recepción, tratamientos, riegos, podas, abonados, recolección. Adiós al estrés pre-inspección por OCA / OAPN. **F1-A4.**
2. **Libro de movimientos del aceite (almazara)**: cuaderno digital que cumple el seguimiento exigido por el RD 760/2021 + RD 1334/1999 + AICA — partidas de aceituna molturadas, rendimientos, lotes de aceite obtenidos, mermas, salidas a granel o envasado. **F1-A5.**
3. **Verticalización por DOP olivar**: activas el perfil de tu Denominación de Origen Protegida del aceite (Sierra de Cazorla, Sierra Mágina, Priego de Córdoba, Estepa, Baena, Les Garrigues, Siurana, Mallorca, Empordà…) y la app valida los requisitos del pliego (variedades autorizadas, zona geográfica, métodos de extracción, acidez máxima). **F1-A6.**
4. **IA visual Claude para plagas y enfermedades del olivar**: mosca del olivo (*Bactrocera oleae*), prays (*Prays oleae*), repilo (*Spilocaea oleaginea*), verticilosis, tuberculosis, cochinilla, glifodes… Mismo patrón que la IA de plagas en viticultura/apícola. **F1-A7.**
5. **Catálogos curados por asesor agrónomo olivarero** en CSVs editables (variedades de aceitunas, plagas y enfermedades, productos fitosanitarios autorizados MAPA olivar, DOPs vigentes). **F1-A6.**
6. **Cierre fiscal REAGP** consistente con agro/viticultura/apícola: extracto económico anual con la separación característica del olivar (venta de aceituna vs venta de aceite — IVA al 12 % REAGP en venta de aceituna a almazara, IVA al 4 % o 10 % según destino del aceite; envasado vs granel cambia el tratamiento). **F1-A9.**
7. **Offline real** (sólo va a la nube cuando hay sync — pensado para el monte y para almazaras pequeñas con conectividad pobre durante la campaña).

## Stack

Heredado de la suite Solera. Consume `nuevo_ser_core` por path local para `GestorFotos`, `csv_io`, `informe_periodico_pdf`, `CampoAutocompleteCatalogo`, `SelectorFotos`, `BannerCoincidenciaCatalogo`, `BannerDeclaracionObligatoria`.

## Estructura

```
lib/
├── datos/                 (pendiente F1-A2) base_datos.dart,
│                          catalogos_generados/
├── modelos/               (pendiente F1-A2) Olivar, Parcela, Olivo,
│                          Campania, Recoleccion, PartidaAceituna,
│                          Molturacion, LoteAceite, Movimiento, Venta,
│                          Tratamiento, Incidencia, Analitica, Titular
├── pantallas/             (pendiente F1-A3) pantalla_hoy (dashboard),
│                          pantalla_mapa (parcelas), pantalla_lista_parcelas,
│                          pantalla_ficha_parcela, pantalla_campania,
│                          pantalla_molturacion, pantalla_libro_aceite,
│                          pantalla_cuaderno_pac, pantalla_ajustes
├── servicios/             (pendiente F1-A5) generador_libro_aceite_pdf,
│                          generador_cuaderno_pac_pdf,
│                          cliente_anthropic, backup_servicio
├── estado/                (pendiente) olivar_activo
├── utiles/                (pendiente) permisos_gps
└── main.dart              esqueleto F1-A1

content/aceitera/          (pendiente F1-A6) CSVs editables por asesor agrónomo
tool/compilar_catalogos.dart (pendiente F1-A6)
```

## Modelo de datos planificado (sqflite v1)

Forkeado del patrón de viticultura con renombrados y dos eventos extra (recepción y molturación, propios de la almazara):

- `olivares` — single-row (un olivar por dispositivo en v0.1). Datos del titular, SIGPAC genérico, certificaciones (ecológico, integrada, DOP).
- `parcelas` (era `vinedos`) — sector del olivar con polígono SIGPAC, superficie, variedad mayoritaria, marco de plantación, edad media, sistema de riego (secano / superficial / goteo).
- `olivos` (era `cepas`) — pie individual con identificador interno opcional, variedad, edad, estado (productivo / en formación / arrancado / sustituido). En aceitera la granularidad por pie sólo tiene sentido en olivar superintensivo o en olivos monumentales catalogados — la mayoría de las explotaciones trabajan a nivel de parcela.
- `campanias` (era `cosechas`) — campaña olivarera (1-oct a 31-mar habitualmente). Año comercial + producción total + rendimiento medio + observaciones meteorológicas.
- `recolecciones` — parte diario de aceituna recolectada: parcela, kg estimados, tipo de aceituna (verde / envero / negra), método (vibrador, manual, paraguas, peine), cuadrilla, fotos.
- `partidas_aceituna` — recepción en almazara (puede venir de finca propia o de socio cooperativista): kg netos en báscula, % aceituna defectuosa por catador, número albarán, lote padre.
- `molturaciones` — molturación de una o varias partidas: fecha, batidora, decanter, kg molturados, rendimiento (% aceite obtenido), aceite resultante en kg, lote de aceite generado, alperujo generado.
- `lotes_aceite` — **entidad central** del libro de movimientos: identificador único (campaña + secuencia), kg netos, acidez, peróxidos, K232/K270, panel test si aplica, categoría (virgen extra / virgen / lampante), DOP si aplica, ubicación física (depósito X, bodega Y).
- `movimientos` — entradas y salidas de cada lote: traslado entre depósitos, mezclas, envasado (kg envasado + nº de envases), venta a granel, autoconsumo. El libro de movimientos del aceite es esto.
- `ventas` — salida comercial: cliente, líneas (lotes a granel o envases), factura, IVA aplicado, destino (España / UE / extra UE — el aceite es de los pocos productos REAGP que distinguen claramente entre los tres).
- `tratamientos` — fitosanitarios aplicados en parcela: producto, sustancia activa, dosis, plaga objetivo, fecha, técnico aplicador, número de carnet.
- `incidencias` — defectos en olivar (sequía severa, helada, plaga grave, viento de levante), defectos en almazara (parada por avería, lote con sobrefermentación).
- `analiticas` — controles del aceite: acidez, peróxidos, K232/K270, panel test sensorial, polifenoles, color, humedad.
- `titulares` — datos del titular de la explotación / razón social de la almazara (NIF, RGSEAA si envasa, número AICA, dirección, datos bancarios para REAGP).

## Roadmap

| Fase | Estado | Entregable |
|---|---|---|
| **F1-A1 Esqueleto** | **✅ (esta sesión)** | apps/solera-aceitera/ creado, pubspec con stack completo, branding verde oliva `#5C6B3A` + crema `#F5EFE2`, dependencia del core, CLAUDE.md y BLOQUEOS-PENDIENTES, main.dart placeholder, estructura de carpetas lib/{datos,modelos,pantallas,servicios,estado,utiles}/ vacías |
| F1-A2 Modelos + BD | **✅** | 14 modelos POJO (Titular, Olivar, Parcela, Olivo, Campania, Recoleccion, PartidaAceituna, Molturacion, LoteAceite, Movimiento, Venta, Tratamiento, Incidencia, Analitica) + sqflite v1 con 14 tablas, FK (CASCADE/SET NULL/RESTRICT según semántica), índices por FK y por fecha, migraciones aditivas. `BaseDatosSoleraAceitera` singleton con CRUD básico (insertar* + listar* + obtener*) que F1-A3 consume sin más. 26 tests POJO verde incluyendo round-trip, defaults, lógica derivada (`Molturacion.partidasUsadasIds` tolerante a JSON corrupto, `Campania.estaAbierta`) y casos límite (origenEsSocio, ámbito incidencia, parámetros analíticos nullables) |
| F1-A3 Pantallas básicas | **✅** | Navegación principal con NavigationBar + IndexedStack de 6 pestañas (Hoy, Mapa, Parcelas, Lotes, Libro, Ajustes) + onboarding al primer arranque. Pantallas: PantallaOnboarding (titular + olivar, persiste en SharedPreferences `aceitera.onboarding_visto`), PantallaHoy (dashboard campaña activa + últimos lotes + conteos), PantallaMapa (flutter_map OSM con marcadores de parcelas que tienen coords; F1-A8 añade captura GPS), PantallaListaParcelas (buscador multi-campo, FAB nueva), PantallaFichaParcela (datos + timeline recolecciones + tratamientos, FAB registrar evento), PantallaNuevaParcela (formulario completo), PantallaListaLotes (categoría coloreada, FAB nueva partida), PantallaFichaLote (datos analíticos + libro de movimientos del lote + analíticas históricas), PantallaNuevaPartida (recepción aceituna en almazara, propia o socio externo; al guardar ofrece pasar a molturación), PantallaNuevaMolturacion (crea lote + movimiento entrada_molturacion automáticamente), PantallaNuevaRecoleccion + PantallaNuevoTratamiento (eventos por parcela), PantallaLibroAceite (vista cronológica del libro AICA), PantallaAjustes (titular + olivar + gestión campañas + botón nueva campaña). Sin catálogos curados (text input libre hasta F1-A6) ni captura GPS (F1-A8). `flutter analyze` limpio. |
| F1-A4 Cuaderno PAC PDF | pendiente | `generador_cuaderno_pac_pdf.dart` con secciones reglamentarias (recepción, tratamientos, riegos, podas, abonados, recolección, materia activa, número albarán, técnico) conforme RD 1311/2012. **Caveat**: formato a validar con técnico OCA real |
| F1-A5 Libro de movimientos del aceite PDF | pendiente | `generador_libro_aceite_pdf.dart` con entradas/salidas/mezclas/envasados por lote, compatible con seguimiento AICA + RD 760/2021. **Caveat**: validar con auditor AICA real |
| F1-A6 Catálogos provisionales | pendiente | 5 CSVs en `content/aceitera/`: `variedades_olivo.csv` (40 + variedades autorizadas — picual, hojiblanca, arbequina, cornicabra, manzanilla cacereña, empeltre, etc.), `plagas_olivo.csv` (~25 plagas + enfermedades canónicas), `fitosanitarios_olivar.csv` (sustancias activas vigentes en Registro Fitosanitario MAPA olivar), `do_aceite.csv` (29 DOP vigentes), `calendario_olivar.csv` (ventanas habituales por zona productiva). `catalogosCompletamenteRevisados=false` hasta validación agrónomo |
| F1-A7 IA Claude Vision | pendiente | BYO key Claude Haiku 4.5 con dos modos (`identificarVariedad` para hoja/aceituna en duda y `diagnosticarPlaga` para foto de daño), prompt curado olivar peninsular con lista canónica de plagas y enfermedades, banner rojo automático para plagas de declaración obligatoria (Xylella en olivar — síndrome de decaimiento rápido del olivo), matching fuzzy contra catálogo, hard limit "NO recomienda productos comerciales por marca — sólo sustancia activa + manejo cultural" |
| F1-A8 Branding + refactor al core | pendiente | Logo cabecera (aceituna + rama estilizada sobre verde oliva), iconos lanzador Android adaptive + splash screen sobre fondo crema. Reutilizar widgets compartidos del core (ya extraídos por el resto de Solera) sin duplicar |
| F1-A9 Libro ingresos/gastos | pendiente | Mismo patrón F3.5/F1-12 del resto de Solera con la particularidad olivar: venta de aceituna vs venta de aceite (IVA distinto en REAGP — 12 % la aceituna a almazara, 4 % o 10 % el aceite envasado según destino, granel a otro envasador con regla específica), gasto en jornales, gasoil agrícola REAGP, abonos, fitosanitarios, cuota DOP, analíticas. **Provisional hasta asesor fiscal** |
| F1-A10 Catálogos pre-curados con fuente pública | pendiente | Revisión de los 5 CSVs con `revisado_por=fuente_pública` (MAPA Registro de Variedades de Olivo, IFAPA Catálogo de Variedades, Boletines de Estaciones de Aviso Fitosanitario CCAA, Registro Fitosanitario MAPA 2026, BOE DOPs olivar). Activar Xylella + Verticilium dahliae con `declaracion_oficial=si`. Generador Cuaderno PAC verificado conforme RD 285/2021 vigente. CUE digital (RD 34/2025, vigor 2027) anotado para F1.1 |
| F2 Lanzamiento | pendiente | Stores, web, primeros suscriptores, plan piloto con cooperativa pequeña |

## Hard limits

- **No recomendar productos fitosanitarios comerciales por marca**. En catálogo van **sustancias activas** + **tipos de tratamiento** (heredado de viticultura/apícola/arbolado). El maestro almazarero o el técnico de OCA conocen las marcas comerciales vigentes y firman el responsable de aplicación.
- **No inventar datos del Registro de Variedades MAPA / IFAPA**. Si no está confirmado, placeholder "v2".
- **Compliance fiscal y AICA es load-bearing**. El libro de movimientos del aceite debe ajustarse al RD 760/2021 + requisitos AICA vigentes. Validar con auditor real antes de release público.
- **El cuaderno PAC generado no es vinculante** hasta que un técnico OCA / asesor APAE firme la portada. La app facilita el registro y produce un PDF — la responsabilidad de la veracidad sigue siendo del titular.
- **Cero PlantNet, cero imágenes Commons en BD pre-cargada**. Caché de fotos = del cliente. Activos ilustrativos = stock comercial pagado o generación propia.

## Reglas de interacción

- **Voz adulta directa**, profesional. No Kids.
- **Nombres descriptivos en castellano** (regla del monorepo). Términos técnicos en su forma oficial: SIGPAC, REAGP, AICA, DOP, RFEAOO, K232/K270, polifenoles, alperujo, batido en frío, decanter.
- **Tests antes del código no visual**: motor, persistencia, parsing CSV, generación PDF.
- **Antes de meter información agronómica o fiscal nueva**: verificar fuente o consultar con asesor. Sin fuente → placeholder "v2".

## Decisiones humanas pendientes

Ver `BLOQUEOS-PENDIENTES.md`.

- Validación del catálogo de variedades + plagas + DOPs por **asesor agrónomo olivarero** (formación IFAPA o equivalente, idealmente con experiencia en cooperativa).
- Formato exacto del Cuaderno de Explotación PAC olivar y del Libro de Movimientos del Aceite — conforme RD 1311/2012, RD 285/2021, RD 760/2021 y normativa AICA vigente — validar con técnico OCA real.
- Logo y branding visual definitivo (verde oliva oscuro + crema, evitar colisión con verde-hoja del arbolado).
- `applicationId` final (`com.josu.solera_aceitera` provisional).
- **F1-A9 Libro ingresos/gastos — asesor fiscal humano** antes de quitar provisional. El olivar tiene reglas REAGP peculiares (aceituna a almazara, aceite a envasador, aceite a destino final) que conviene cerrar con un fiscalista agroalimentario.
- Decidir si la app cubre también **subproductos de la almazara** (alperujo a extractora, orujo graso, hueso de aceituna como biomasa) o se queda en aceite virgen + virgen extra.
- Decisión de monetización para cooperativas: suscripción por almazara, por socio cooperativista, o licencia anual a la cooperativa con n socios incluidos.
