# El Cuaderno

Herramienta de campo digital con alma pedagógica para 9-13 años. Tercer juego de la línea **Colección Nuevo Ser Kids**, hermano epistémico de Uno Roto y Las Versiones. Primer juego no narrativo de la línea: sin protagonista, sin mundo ficticio, sin arcos. La protagonista es la niña real, su lugar es el suyo real.

Materia: Conocimiento del Medio Natural (LOMLOE primaria, ciclos 2 y 3) — pre-Biología y pre-Ecología.

Anclaje filosófico: *La Tierra que Despierta*. La palabra *naturaleza* presupone separación entre quien observa y lo observado; el juego se niega a inventar un valle ficticio donde la niña hace de naturalista, y en su lugar amplifica la atención del niño hacia el lugar real donde está.

Documentación canónica: `../../docs/el-cuaderno/`. Cerebro persistente del proyecto: `CLAUDE.md` de este directorio.

Licencia: código AGPL-3.0, contenido CC-BY-SA 4.0.

## Sprint 1 — qué cubre este código

Bootstrap mínimo del juego, conforme al `prompt-claude-code.md` del paquete documental. Lo que SÍ hay:

- Modelo de dominio (`lib/dominio/`): `NivelConfianza`, `Observacion`, `SitSpot`, `Misterio`, `PaginaCuaderno`, `RepositorioLocal` (interfaz).
- Persistencia local en Isar (`lib/infraestructura/isar/`): modelos anotados, setup con `path_provider`, implementación del repositorio.
- Tres pantallas funcionales (`lib/vista/`):
  - `pantalla_cuaderno/` — pantalla principal con scroll vertical: cabecera + saludo + tarjeta del sit spot + Misterios abiertos + última página. Bottom nav con 4 pestañas.
  - `pantalla_observacion/` — formulario para registrar una observación, con separación estructural entre *qué viste* y *crees que es*, selector de confianza (3 chips, *hipótesis activa* por defecto), selector de Misterio.
  - `pantalla_tutor/` — saludo canónico + input + respuesta canned. **El Tutor todavía no está conectado a Claude API**; eso es Sprint 4.
- Tema (`lib/vista/tema/`): paleta apagada de cuaderno botánico (cremas, verdes apagados, ocres, azul ceniza). Tipografía serif para textos del cuaderno y voz, sans-serif para datos del sistema.
- i18n con `gen_l10n` nativo de Flutter (`lib/nucleo/i18n/`): castellano completo desde el día cero; euskera y catalán con placeholders `TODO_EU` / `TODO_CA` por string para que el equipo de localización los traduzca.
- Datos sembrados (`lib/datos_simulados/seed.dart`) idempotentes: el sit spot "El Roble Grande", dos Misterios literales del catálogo (las setas tras la lluvia, las golondrinas), tres observaciones de ejemplo. Solo se siembra en `kDebugMode`.
- Tests mínimos pero reales: dominio (validaciones, `copyWith`, `toJson` / `fromJson` roundtrip, `toLocaleLabel` por idioma), widget (presencia de elementos clave, estado del botón Guardar, chips de confianza con `hipótesis activa` seleccionado por defecto).

## Lo que NO hay todavía

Todo esto pertenece a sprints posteriores y está documentado en `docs/el-cuaderno/03-arquitectura-tecnica.md` §12:

- **Conexión con `nuevo_ser_core`** (cuenta, sincronización, multi-perfil) — Sprint 2.
- **Motor adaptativo P5 compuesto** (precisión + rúbrica + cobertura + proxy) — Sprint 3.
- **Tutor IA real** con prompts versionados, ZDR, lista negra, cuota — Sprint 4. Hoy es respuesta canned.
- **Geolocalización + sit spot con coordenadas + mapa offline OSM** — Sprint 5. Hoy el lugar es texto manual.
- **Servicio de fenología** (calendario regional para contextualizar Misterios) — Sprint 6.
- **Acompañamiento** (vista del cuidador, vista del aula con k≥5) — Sprint 7.
- **Polish, accesibilidad WCAG 2.1 AA, exportar PDF** — Sprint 8.
- **Piloto** con 12-15 niños voluntarios durante una estación completa — Sprint 9.

Tampoco hay arte ni música finales — los placeholders son grises programáticos. El doc 11 (guía visual) prescribe acuarela y tinta encargadas a ilustradoras humanas; eso vive en producción de arte, no en código.

## Cómo ejecutar

Requisitos: Flutter 3.24+, Dart 3.5+. Si Flutter no está en `PATH`:

```bash
export PATH="$HOME/flutter/bin:$PATH"
```

Desde la raíz del monorepo (`/home/josu/Projects/games/nuevo-ser/`):

```bash
melos bootstrap                                              # resuelve dependencias en todos los paquetes
( cd apps/el-cuaderno && \
  dart run build_runner build --delete-conflicting-outputs \  # genera modelos Isar
  && flutter run -d linux )                                   # arranca en debug; los datos sembrados aparecen automáticamente
```

O por paquete:

```bash
( cd apps/el-cuaderno && flutter pub get )
( cd apps/el-cuaderno && dart run build_runner build --delete-conflicting-outputs )
( cd apps/el-cuaderno && flutter run -d linux )
```

## Cómo correr los tests

```bash
( cd apps/el-cuaderno && flutter test )
```

O desde la raíz:

```bash
melos run test
```

## Voz y tono

Cualquier microcopia nueva pasa por el test del doc 04 §2.3:

> ¿podría salir esto de alguien que llevara cuarenta años caminando este monte?

Si la respuesta es *no*, se reescribe. El vocabulario prohibido y los cinco intercambios canónicos del Tutor están en `docs/el-cuaderno/04-voces-y-figuras.md`.

## Decisiones abiertas

Documentadas en la biblia §10. No se cierran en código antes del piloto:

1. **Nombre definitivo del juego.** *El Cuaderno* es provisional.
2. **Edad mínima.** Hoy 9; si el sit spot funciona en niños de 8, se baja.
3. **Figura de la abuela / cuaderno heredado.** Versión A (vacío) vs Versión B (heredado) — decisión por evidencia de piloto.
4. **Mecanismo de cold start** los primeros 7-10 días.
5. **Compartición opcional con instituciones de ciencia ciudadana** (iNaturalist, eBird), con consentimiento explícito.
