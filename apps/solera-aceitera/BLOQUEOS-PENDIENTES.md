# Solera Aceitera — Bloqueos pendientes

Decisiones humanas que bloquean fases concretas del roadmap. Cada bloqueo
declara la fase afectada, qué pieza queda colgada y qué interlocutor
humano hace falta para resolverlo.

## F1-A6 — Catálogos provisionales sin validar (BLOQUEA F1-A10)

**Estado**: pendiente arrancar (F1-A1 cierra el esqueleto en esta sesión;
F1-A2…F1-A5 son ejecutables sin asesor; F1-A6 produce los CSVs
provisionales que F1-A10 valida).

**Bloqueante**: **asesor agrónomo olivarero**. Idealmente un técnico
IFAPA o equivalente con experiencia en cooperativa. Hace falta para:

- Validar el catálogo de variedades de olivo (picual, hojiblanca,
  arbequina, cornicabra, manzanilla cacereña, empeltre, picudo, lechín
  de Sevilla, gordal sevillana, blanqueta, farga, morrut, sevillenca,
  villalonga, manzanilla de Jaén, royal de Cazorla, etc.) — fuente
  inicial: MAPA Registro de Variedades de Olivo + IFAPA Catálogo de
  Variedades.
- Validar el catálogo de plagas y enfermedades del olivar (mosca,
  prays, repilo, verticilosis, tuberculosis, cochinilla, glifodes,
  algodoncillo, taladrillo, antracnosis…) — fuente inicial: Boletines
  de Estaciones de Aviso Fitosanitario de las CCAA olivareras.
- Validar el catálogo de DOPs olivar vigentes (29 DOPs según BOE +
  Reglamentos UE de protección de denominaciones).
- Validar el calendario fenológico por zona productiva (Jaén / Córdoba
  / Sevilla / Lleida / Tarragona / Badajoz / Toledo / Mallorca / sur de
  Portugal frontera).

**Mientras tanto**: los CSVs llevan `revisado_por=` vacío y el flag
`catalogosCompletamenteRevisados=false`. La app muestra banner amarillo
"datos provisionales" en cualquier autocomplete que dependa de catálogo.

## F1-A4 + F1-A5 — Formato cuaderno PAC + libro de movimientos del aceite

**Estado**: F1-A4 y F1-A5 ejecutables en paralelo después de F1-A2 (la
BD ya tiene las tablas necesarias).

**Bloqueante**: **técnico OCA / auditor AICA** para validar que el PDF
generado pasa una inspección real.

- Cuaderno PAC olivar conforme RD 1311/2012 + RD 285/2021 vigente
  (CUE digital de RD 34/2025 entra en vigor 2027 — el PDF clásico
  sigue siendo aceptado hasta entonces).
- Libro de movimientos del aceite conforme RD 760/2021 + requisitos
  de la Agencia de Información y Control Alimentarios (AICA).

**Mientras tanto**: el PDF lleva sello "PROVISIONAL — pendiente de
validación por asesor técnico" en cabecera. El test `sello_provisional_test.dart`
(equivalente al de viticultura/apícola/agro, riesgo R1 de la auditoría
2026-05-12) impide retirarlo silenciosamente.

## F1-A9 — Libro ingresos/gastos REAGP olivar

**Estado**: planificado tras F1-A8.

**Bloqueante**: **asesor fiscal agroalimentario humano**. El olivar
tiene una casuística REAGP más compleja que las otras Solera:

- Venta de aceituna a almazara: 12 % REAGP en compensación.
- Venta de aceite envasado al consumidor final: 4 % IVA / 10 % IVA
  según categoría (alimentario básico vs gourmet).
- Venta de aceite a granel a otro envasador / refinador: tratamiento
  específico distinto del aceite envasado.
- Cuota DOP, analíticas, alperujo a extractora — categorización
  contable.

**Mientras tanto**: la pantalla queda escondida del flujo principal o
con banner "PROVISIONAL" persistente. Mismo patrón que las otras Solera.

## F1-A7 — Caveat IA Vision

**Estado**: planificado tras F1-A6.

**Bloqueante**: validación del catálogo F1-A6 por el asesor agrónomo.
Hasta entonces, todo diagnóstico de la IA se marca como "provisional —
contraste con técnico antes de aplicar tratamiento".

## F1-A8 — Branding visual definitivo

**Estado**: planificado tras F1-A7.

**Bloqueante**: ilustrador / diseñador. Hace falta:

- Logo (aceituna + rama estilizada, o variante minimalista).
- Iconos Android adaptive (foreground transparente sobre fondo crema).
- Splash screen Android 12+.

**Mientras tanto**: el pubspec apunta a `assets/icono-logo-aceitera.png`
que es **placeholder** — sustituir cuando entre el activo definitivo y
regenerar con `dart run flutter_launcher_icons` + `dart run flutter_native_splash:create`.

## F2 — Lanzamiento y modelo de monetización

**Estado**: bloqueado hasta que las fases F1-A2 a F1-A10 cierren.

**Bloqueantes humanos**:

- Decisión de monetización para cooperativas (suscripción por almazara
  vs. licencia anual a la cooperativa con n socios incluidos).
- `applicationId` final (`com.josu.solera_aceitera` provisional).
- Cooperativa pequeña piloto (50-200 socios) que acepte usar la app
  durante una campaña entera con feedback estructurado.
- Decisión scope: ¿la app cubre subproductos (alperujo, orujo graso,
  hueso de aceituna) o se queda sólo en aceite virgen + virgen extra?
