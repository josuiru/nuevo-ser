# Solera Zunbeltz — BLOQUEOS PENDIENTES

Decisiones que requieren a una persona (equipo de Zunbeltz Elkartea, asesor técnico/veterinario, asesor fiscal, técnico OCA, CPAEN/NNPEK) antes de poder cerrar a producción. Nada aquí se inventa: se marca PROVISIONAL y se espera firma.

## A. Para llevar a la primera reunión (que ellas aporten)

1. **Alcance del piloto**: ¿arrancamos por el **módulo de gestión de fincas + puntos en mapa + tareas de mantenimiento** (FZ-3, lo más demostrable y sin compliance) y dejamos el cuaderno ganadero y la Capa B para después? Recomendación: sí.
2. **Una capa o dos**: ¿vertical ganadera autónoma + módulo ETA encima (recomendado), o app monolítica "Zunbeltz"?
3. **Quién es el cliente/titular del producto**: Zunbeltz Elkartea, Mancomunidad de Andía, o se diseña genérico para la **red estatal de ETAs** desde el día uno. Define el modelo B2B y la licencia.
4. **Inventario real de infraestructuras**: qué puntos existen hoy en Zunbeltz y La Planilla (abrevaderos, mangas, cierres, refugios, cuadras, almacenes, balsas, cargaderos…). El mapa del MVP se siembra con datos reales, no de ejemplo.
5. **Catálogo de tareas de mantenimiento** habituales y su periodicidad (tensar alambrada, desbroce, revisión de bebederos, tejados, instalación eléctrica…). Y **quién** las ejecuta: ¿los testadores como contraprestación?, ¿operario de la Mancomunidad?, ¿empresa externa?
6. **Roles y permisos**: ¿qué ve y qué puede hacer cada rol (testador / mentor / coordinador / asesor)? En especial, **datos sensibles** del emprendedor (evaluación de viabilidad y competencias) — RGPD: ¿lo ve el coordinador?, ¿sólo el mentor?
7. **Proceso real de acompañamiento y evaluación**: qué hitos, qué competencias y con qué criterios se evalúa la viabilidad de un proyecto. Esto es **conocimiento de Zunbeltz**, no se modela sin ellas. (Es lo que la Capa B enchufa al motor de maestría del core.)
8. **Banco de tierras / relevo**: ¿lo gestiona la app o ya tienen otra vía? ¿Qué datos de cedentes/demandantes son públicos y cuáles no?
9. **La Venta de Zunbeltz**: ¿quieren trazabilidad lote→producto→venta directa dentro de la app, o queda fuera del alcance?

## A-bis. Euskera (revisión nativa — antes de la reunión si da tiempo)

9-bis. **Revisión nativa del euskera de la presentación**. El texto eu de `presentacion/index.html` es un borrador propio (batua) y, aunque cuidado, debe pasar por una persona euskaldun — idealmente del propio equipo de Zunbeltz, lo que además lo convierte en co-diseño. Puntos a confirmar con ellas: terminología agroganadera oficial (¿"Nekazaritza Saiakuntza Gunea" o la forma que ellas usan?, "manga de manejo", "larre-saila"…), euskera batua vs. variante navarra/local, y respeto de nombres propios. **No dar el euskera por bueno sin esa revisión.**
9-ter. **Bilingüismo de toda la app** (no solo la presentación): decidir alcance (es+eu mínimo; ¿se contempla algún tercer caso?) y si los PDF oficiales se emiten bilingües. Ver decisión "Lenguas" en `CLAUDE.md`.

## B. Compliance ganadero (asesor veterinario + técnico OCA + decreto foral Navarra)

10. **Formato vigente del libro de explotación ganadera** y de las **guías de movimiento pecuario / DST** conforme a normativa estatal + decreto foral de Navarra. Validar antes de cada release.
11. **SITRAN / RIIA**: alcance de la integración (¿sólo registro local exportable, o conexión digital?).
12. **Certificación ecológica CPAEN/NNPEK**: qué trazabilidad exige el consejo regulador navarro para ganadería ecológica extensiva.
13. **Catálogos** (`razas_bovino_ovino`, `medicamentos_veterinarios` con plazos de supresión, `patologias_extensivo` con declaración obligatoria, `tipos_pasto_carga`, `calendario_ganadero`): validación por veterinario asesor + descarga del registro de medicamentos vigente. Hard limit: sustancias activas, nunca marcas.

## C. Backend y plataforma (decisión compartida con F4 de agro)

14. **Stack de backend multi-rol**: ¿plugin WordPress Kids reutilizado vs backend Solera independiente? Auth con roles (testador/mentor/coordinador/asesor). Es el primer cliente real del backend Solera y obliga a resolver también el **auth de profesor/cuidador** del companion.
15. **Monetización B2B**: licencia anual a la entidad gestora vs modelo por ETA en la red. Financiación pública de Zunbeltz lo descarta como SaaS individual.
16. **`applicationId` y branding visual definitivo** (logo, splash, paleta extendida más allá de monte+crema+ocre).

## D. Fiscal (asesor fiscal humano — patrón heredado del resto de Solera)

17. **Libro ingresos/gastos + extracto** (FZ-8): régimen REAGP ganadero, IVA de venta de terneros/corderos y venta directa, prima PAC/ecorégimen como bloque aparte. Banner PROVISIONAL hasta firma. Coherente con la memoria del repo: *contabilidad por vertical, gateada por el contexto fiscal español*.

---

**Principio rector**: esta app se **co-diseña** con Zunbeltz Elkartea. La propuesta (CLAUDE.md + presentación) es un punto de partida sólido para que ellas lo discutan y aporten, no un diseño cerrado.
