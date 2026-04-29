# Las Versiones — CLAUDE.md

Cerebro persistente del proyecto. Se lee al inicio de cada sesión. Se mantiene corto. Para detalle: docs canónicos en `~/Projects/games/coleccion-nuevo-ser-paquete-documental-v0.2/coleccion-nuevo-ser/las-versiones/`.

## Encuadre del programa

Las Versiones es uno de los juegos de la línea **Colección Nuevo Ser Kids** (juegos digitales pedagógicos infantiles/escolares). Hermano epistémico de Uno Roto: si Uno Roto enseña a confiar en la precisión, Las Versiones enseña a **convivir con la incertidumbre sin caer en relativismo**.

## Qué es Las Versiones

Juego educativo de **pensamiento histórico** para 10-14 años. La protagonista es **Maren**, 13 años, que ingresa al **Archivo de Iruña** como Aspirante a Cronista. A lo largo de un curso escolar (cuatro arcos narrativos) aprende el oficio: formular preguntas, evaluar fuentes, anclar afirmaciones en evidencia, declarar niveles de confianza con honestidad.

El juego cubre la historia de Nafarroa atravesada por diez capas históricas — desde la prehistoria hasta el umbral de la Conquista de 1512. **MVP cubre las ocho primeras capas**.

Stack objetivo (doc 14 §3.1): Flutter + Flame + Isar + Riverpod + flutter_localizations. **Arrancamos minimalista**: shared_preferences + StatefulWidget + CustomPainter, mismo patrón que Uno Roto al principio. Migración a Flame/Isar/Riverpod cuando haya razón real (típicamente: una Brecha que pida renderizado de juego de verdad).

Licencia: código AGPL-3.0, contenido CC-BY-SA 4.0.

## Mecánica central — investigar una Brecha

Cinco fases (equivalente funcional a "cortar un Fragmento" en Uno Roto):

1. **Formulación de preguntas** — la Cronista propone, el sistema evalúa calidad. *Novedad de v0.2 del doc 01: el oficio empieza con preguntas, no con respuestas.*
2. **Recolección** — visita el lugar y recoge fuentes (textos, objetos, testimonios, evidencia arqueológica, mapas, cartas).
3. **Evaluación** — Mesa de Trabajo. Cada fuente con criterios explícitos: ¿quién?, ¿cuándo?, ¿para qué público?, ¿qué intereses?, ¿qué se omite?, ¿corrobora o contradice?
4. **Reconstrucción** — narración estructurada que ancla cada afirmación a evidencia con tres niveles visibles: **Sólido** / **Probable** / **Disputado**.
5. **El Concilio** — presenta versión ante mentora y rivales. NO premia tener razón: premia haber juzgado bien con lo disponible.

**Espacios paralelos no-atomizados** (doc 15): Cuaderno de la Cronista (suyo, no se evalúa) + Mosaicos de fin de arco (entrega creativa integradora). Cultivan imaginación y creatividad transversalmente, no se atomizan deliberadamente.

## Habilidades atómicas (doc 02)

**65 habilidades en 7 dominios**:

| Cód | Dominio | N | Notas |
|-----|---------|---|-------|
| **PR** | Formulación de Preguntas | 5 | Novedad v0.2. Antes de toda investigación |
| **HF** | Análisis de Fuentes | 12 | Corazón del oficio |
| **CC** | Cronología y Causalidad | 10 | Esqueleto temporal |
| **GH** | Geografía Histórica | 8 | Esqueleto espacial |
| **PH** | Perspectiva Histórica | 10 | Antídoto al presentismo |
| **AH** | Argumentación Histórica | 8 | Donde todo confluye |
| **CF** | Contenido Factual LOMLOE | 12 | Andamiaje de hechos |

**Cuatro perfiles de medición** — el motor adaptativo de `nuevo_ser_core` los despacha:
- **P1 — Identificación**: precisión ponderada (≈Uno Roto). Funcional ya en core.
- **P2 — Detección F1**: sensibilidad/especificidad. Stub en core, pendiente.
- **P3 — Construcción**: rúbrica compuesta `w_a·anclaje + w_c·calibración + w_p·completud + w_f·ausencia_falacias`. Stub en core.
- **P4 — Calibración epistémica**: Brier invertido. **Única para AH.03** (declaración de niveles de confianza). **Corazón pedagógico del juego.** Stub en core.

Asignación: HF.01-04, CC.01-03, GH.01-04/06-08, CF.01-12, PR.02 → P1. HF.06-09, HF.11-12, CC.05-06, PH.01, PH.04-05, PH.10, AH.04-05, PR.03 → P2. CC.04, CC.07-10, GH.05, PH.02-03, PH.06-09, AH.01-02, AH.06-08, PR.01/04/05 → P3. AH.03 → P4.

## Hard limits (doc 14 §4)

No negociables, idénticos al estándar de la Colección:
- Cero datos identificables del niño por defecto.
- Cero tracking de terceros, cero publicidad, cero compras integradas, cero dark patterns.
- Tutor IA con barreras: ZDR + barrera anti-alucinación histórica (no genera contenido factual no validado por el comité asesor).
- Open source desde el primer commit (AGPL-3.0).
- Sin código que pueda llegar a producción sin validación pedagógica + histórica + accesibilidad + privacidad.

## Validaciones humanas requeridas (doc 14 §10)

Cuando el código toque alguna de estas áreas, el PR queda **pendiente de validación humana** además del code review:
- Contenido de Brechas (preguntas, fuentes, niveles de confianza).
- Material histórico concreto (fechas, nombres, atribuciones, descripciones de hechos, fragmentos en latín/árabe/hebreo/occitano gascón).
- Sistema de evaluación de habilidades.
- Accesibilidad WCAG 2.1 AA.
- Datos del niño / autenticación.

## Documentos de diseño

En `~/Projects/games/coleccion-nuevo-ser-paquete-documental-v0.2/coleccion-nuevo-ser/las-versiones/`. Al empezar tarea → solo los relevantes:

- `01-biblia.md` — espíritu del juego (v0.2, Maren provisional pero ya cerrada en doc 14).
- `02-mapa-habilidades-atomicas.md` — 65 habilidades del MVP.
- `04-biblia-personajes.md` — voces y arcos.
- `05-biblia-worldbuilding.md` — Iruña + 10 capas históricas.
- `06-biblia-narrativa.md` — estructura narrativa global.
- `07-guion-arco-1.md` → `10-guion-arco-4.md` — guiones de arcos.
- `11-guia-visual.md` — paleta, tipografía, formas (la `paleta_archivo.dart` actual es **provisional** — pendiente de cerrar).
- `12-guia-sonora.md` — capas, motivos, efectos.
- `14-prompt-maestro-claude-code.md` — este prompt operativo, hard limits, flujos.
- `15-acompanamiento-y-curso.md` — Cuaderno y Mosaicos en detalle.
- `16-comite-asesor-historico.md` + `16a-...adenda-1...md` — quién valida qué.
- `17-validacion-provisional-tracker.md` — qué está validado y por quién.

## Estado actual

**Fase 10 del roadmap, primer commit del esqueleto.** Cableado a la plataforma `nuevo_ser_core`:

```
apps/las-versiones/
├── CLAUDE.md
├── pubspec.yaml          # nuevo_ser_core por path + shared_preferences + intl
└── lib/
    ├── main.dart         # arranque + Orquestador mínimo + selector de idioma cableado a RepositorioIdiomaApp
    ├── nucleo/
    │   └── paleta_archivo.dart      # paleta provisional sepia/tinta/ámbar — pendiente de cerrar contra doc 11
    └── vista/
        ├── pantalla_configuracion_inicial.dart  # selector trilingüe es/eu/ca
        └── pantalla_esqueleto.dart  # provisional "el Archivo abre pronto"
```

**Validación de la plataforma extraída**: el primer commit del juego usa directamente `RepositorioIdiomaApp` del core con la clave `nuevoser.lasversiones.idioma_app`. La extracción de C5/C6 funciona como prometía — el repositorio es portable entre juegos sin tocar el código del core.

**Pendiente** (orden tentativo, sin compromiso de fechas):
1. Cablear `RepositorioCuentaBackend` cuando haya backend al que hablar.
2. Decidir si Las Versiones tiene multi-perfil desde el inicio (`GestorPerfiles`) o llega después.
3. Arrancar la primera Brecha del Arco 1 — necesita doc 07 leído y comité asesor consultado.
4. Sistema de cinemáticas — probablemente extraerlo a `nuevo_ser_core/narrative/` cuando lo abordemos, ya que va a ser el primer caso de uso real para esa extracción (uno-roto lo tiene cableado a `voz_personaje` específica del juego, ver README de core §"Deuda de extracción pendiente").

## Decisiones técnicas tomadas

- **Stack inicial minimalista**: shared_preferences + StatefulWidget + CustomPainter (cuando haga falta). Flame/Isar/Riverpod **se pospondrán hasta tener razón real** — coherente con uno-roto y con el principio "mover sólo lo genuinamente reutilizable hoy" del README de `nuevo_ser_core`. El doc 14 §3.1 prescribe el stack canónico; la divergencia se documenta aquí.
- **Namespace prefs**: `nuevoser.lasversiones.*` (CLAUDE.md raíz prescribe este patrón para juegos nuevos).
- **Idiomas día cero**: castellano + euskera + catalán. Por ahora sin generación gen-l10n — los textos de las dos pantallas viven hardcoded en los tres idiomas. Cuando llegue la primera UI con dialogo narrativo se introducen los ARBs.
- **Paleta provisional `paleta_archivo.dart`**: tonos sepia/papel/tinta + acento ámbar lacre. **Pendiente** de cerrar contra doc 11 cuando se aborde fase visual.
- **Nombres descriptivos en castellano** para variables/clases/archivos. Términos técnicos (widget, builder…) en original. Misma regla que uno-roto y la del CLAUDE.md raíz.

## Reglas de interacción

- **Nunca cargar los 14+ docs a la vez** — solo los de la fase.
- **Tests antes del código no visual**: motor adaptativo (cuando se extiendan P2/P3/P4), evaluación de fuentes, sistema de niveles de confianza.
- **Antes de incorporar contenido histórico concreto**: verificar que esté en el tracker de validación (doc 17). Si no, pedir validación al comité asesor (doc 16) **antes** de mergear.
- **Cuestionar antes de inventar**: si el operador pide algo que parece violar un hard limit, te niegas y citas el documento.
- **Commits pequeños**: <10 archivos salvo setup inicial.
- **Co-autoría con Claude**: trailer en cada commit (`Co-Authored-By: Claude ...`).

## Cosas que NO hacer

- No añadir librerías sin discutirlo (doc 14 §12).
- No romper barrera cliente/backend.
- No meter claves, secrets, endpoints producción en commits.
- No "mejorar" tono sin justificación contra docs.
- No tocar código de uno-roto desde aquí. La comunicación entre juegos pasa por la plataforma.
- No reproducir contenido histórico sin validación del comité asesor.

## Comandos habituales

```bash
# Desde apps/las-versiones/ del monorepo:
flutter analyze
flutter test
flutter run -d linux        # desktop debug
flutter build apk --release

# Flutter path (no está en PATH del sistema):
export PATH="$HOME/flutter/bin:$PATH"
```
