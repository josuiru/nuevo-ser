# El Descifrador — Bloqueos pendientes

> Actualizado: 2026-05-13.
> Sigue el patrón de `apps/agro/BLOQUEOS-PENDIENTES.md`.
> Detalle exhaustivo en `~/Projects/games/el-descifrador-paquete-documental-v0.1/el-descifrador-07-decisiones-humanas-pendientes.md`.

---

## Críticos para producción técnica

### B1. Validación arquitectónica por equipo técnico

- **Categoría**: técnica.
- **Bloquea**: implementación más allá del esqueleto.
- **Quién**: autor responsable + persona técnica de la Colección.
- **Estado**: pendiente.
- **Nota**: el doc 16 esboza adaptación del motor adaptativo a perfil P6, integración con `nuevo-ser-core`, `nuevo_ser_tutor`, sync opcional, plataformas. Requiere validación humana antes de implementar componentes concretos.

### B2. Adaptación del perfil P6 del motor de maestría

- **Categoría**: técnica.
- **Bloquea**: motor adaptativo del juego.
- **Quién**: equipo técnico de `nuevo_ser_core`.
- **Estado**: pendiente.
- **Nota**: el motor compartido tiene P1 (Uno Roto), P4 (Las Versiones), P5 (El Cuaderno). P6 ejercita habilidades del mapa del doc 04 (4 dominios × 8-10 habilidades).

### B3. Sandboxing del tutor IA

- **Categoría**: técnica + ética.
- **Bloquea**: integración del maestro de oficina (Antón/Aitziber) con `nuevo_ser_tutor`.
- **Quién**: equipo técnico.
- **Estado**: pendiente.
- **Nota**: el prompt del maestro debe asegurar que no habla fuera del oficio del juego (sin moralina, sin retención, sin temas no-corpus).

---

## Críticos para corpus

### B4. Comité de asesoría lingüística — cuatro cooficiales primero

- **Categoría**: lingüística.
- **Bloquea**: producción del corpus seminal completo.
- **Quién**: autor responsable identifica asesores; asesores firman compromiso editorial.
- **Estado**: pendiente. Decisión 2026-05-13 confirma orden (cooficiales primero).
- **Asesores necesarios mínimo v1.0**:
  - Castellano (didáctica ESO 1-2): pendiente.
  - Euskara (euskaltegi profesional): pendiente. **Especialmente delicado** — tradición pedagógica propia.
  - Catalán (didáctica secundaria): pendiente.
  - Gallego (didáctica secundaria): pendiente.
  - Después L2: portugués europeo, francés, italiano, inglés, alemán, latín, árabe magrebí.

### B5. Producción del corpus seminal completo (50-80 piezas)

- **Categoría**: editorial.
- **Bloquea**: piloto (Fase 4).
- **Quién**: autor responsable + colaboradores externos remunerados (modelo mixto, decisión 2026-05-13).
- **Estado**: 10 piezas de muestra en `catalogo-seminal-muestra.md` (v0.1 del paquete). Faltan 40-70 más.
- **Nota**: cada pieza debe cumplir reglas del doc 10. Asesoría lingüística obligatoria por pieza antes de inclusión.

### B6. Política de fuentes históricas reales

- **Categoría**: editorial + ética.
- **Bloquea**: corpus con pretensión histórica.
- **Quién**: autor responsable + asesor histórico.
- **Estado**: pendiente.
- **Nota**: manifiesto madre 3.10 prohíbe poner palabras en boca de personas reales. Si el corpus quiere incluir piezas históricas reales, decidir cómo se citan y atribuyen.

---

## Importantes para piloto

### B7. Identificación de 2-3 centros piloto

- **Categoría**: editorial / institucional.
- **Bloquea**: Fase 4 (10-20 niños).
- **Quién**: autor responsable + equipo de difusión.
- **Estado**: pendiente.
- **Nota**: alcance del piloto decidido 2026-05-13 (10-20 niños en 2-3 centros). Falta identificar centros concretos y carta de invitación.

### B8. Selección de ilustrador

- **Categoría**: producción.
- **Bloquea**: producción visual real (iconografía, sellos, mobiliario, ilustración marginal).
- **Quién**: autor responsable.
- **Estado**: pendiente.
- **Nota**: estética definida en doc 11 (trazo a línea peninsular, paleta papel/tinta/sepia/madera, acentos por personaje). Falta mano humana que la ejecute.

### B9. Selección de compositor musical

- **Categoría**: producción.
- **Bloquea**: las cinco piezas musicales puntuales (doc 12 §3).
- **Quién**: autor responsable.
- **Estado**: pendiente.
- **Nota**: música acústica peninsular tradicional, modal, breve. Sin biblioteca stock.

### B10. Auth de profesor / cuidador

- **Categoría**: técnica + editorial.
- **Bloquea**: vista de aula en *El Descifrador*.
- **Quién**: equipo técnico de la Colección.
- **Estado**: pendiente como **bloqueante general de la Colección** — afecta a todos los juegos Kids. Ver `~/.claude/projects/-home-josu-Projects-games-nuevo-ser/memory/project_auth_profesor_pendiente.md`.
- **Nota**: el juego puede arrancar sin vista de profesor (solo cuidador + niño). La aula se añade cuando se resuelva la decisión global.

---

## Diferibles a v1.1+

### B11. Lenguas raras del repertorio

- Occitano, asturleonés, aragonés, papiamento, ladino, catalán antiguo, latín fragmentario.
- Inclinación documental (doc 05 §3.2): v1.1+. El v1.0 cierra con cuatro cooficiales + cinco L2 principales + árabe.

### B12. Atmósfera meteorológica

- Doc 11 §8. Integración con servicio meteorológico para reflejar el día real en la oficina. Requiere dependencia externa. Diferible.

### B13. Web (Flutter web) y otras plataformas

- v1.0 cierra con tableta + escritorio Linux + móvil grande (decisión 2026-05-13).
- Web, macOS, Windows: diferible a v1.1+ según demanda.

---

## Resueltos — 2026-05-13

Doce decisiones cerradas por autor responsable. Ver `el-descifrador-07-decisiones-humanas-pendientes.md` §"Resueltas — 2026-05-13".

## Cierres provisionales por Claude — 2026-05-13

Diez decisiones de scope cerradas provisionalmente por el asistente Claude por delegación expresa del autor responsable. **Plenamente reversibles** por el autor o cualquier asesor profesional cuando vea las piezas concretas. Ver `el-descifrador-07-decisiones-humanas-pendientes.md` §"Cierres provisionales por Claude — 2026-05-13".

Las decisiones que **NO** se pueden cerrar provisionalmente (siguen siendo bloqueante humano real) están listadas en el mismo doc 07 §"Sigue siendo bloqueante humano real".

## Activos en cartas-y-encargos

Para desbloquear los humanos reales, se han redactado **tres cartas/briefs** que el autor responsable manda cuando esté listo:

- `cartas-y-encargos/01-carta-asesores-lingüísticos.md` — invitación a las cuatro cooficiales primero.
- `cartas-y-encargos/02-carta-centros-piloto.md` — invitación a 2-3 centros para Fase 4.
- `cartas-y-encargos/03-brief-escritores-corpus.md` — encargo a escritores externos del corpus.

Cada una contiene notas al autor para personalizar antes de enviar.

## Material editorial avanzado provisionalmente

- Catálogo seminal pieza 01-10 (`catalogo-seminal-muestra.md`): validado contra principios documentales, **pendiente de validación lingüística humana por pieza**.
- Catálogo seminal pieza 11-20 (`catalogo-seminal-piezas-11-20.md`): añadido el 2026-05-13 por asistencia editorial de Claude. **Riesgo lingüístico variable por pieza** — italiano/alemán/latín/euskara pleno tienen riesgo alto. **Pendiente de validación lingüística humana antes de cualquier inclusión a v1.0**.
