# Bloqueos pendientes — Las Versiones

Registro de decisiones que se han tomado autónomamente (con sustitución
genérica equivalente) y que necesitan validación humana o del comité
asesor histórico (doc 16) antes de mergear a producción. Se mantiene
sincronizado con el tracker canónico (doc 17) y con las reglas del
CLAUDE.md raíz: cualquier afirmación histórica concreta no validada se
sustituye en el código por una formulación que preserva la pedagogía
sin afirmar lo que no se puede afirmar.

Cada entrada apunta al fichero del repo donde está la sustitución, lo
que dice el guion canónico, lo que se ha puesto en su lugar, y la
razón. Cuando el comité valide una entrada, basta con buscar las
referencias y revertir la sustitución.

---

## PIO-BELTRAN — autoría de "el libro de Beltrán" y "informe de 1973"

**Tracker doc 17**: pendiente.

**Guion canónico (doc 07)**:
- 1.0.1: "El del centro es Pío Beltrán, arqueólogo" (foto de 1958, Aralar).
- 1.0.3: "Te dejo el libro de Beltrán en tu mesa esta tarde."
- 1.1.2: "Una excavación de 1973" — implícitamente la de Pío Beltrán.
- 1.1.4: "Informe de 1973 (excavación de Pío Beltrán, con sesgos de la época — vocabulario diffusionista, comparaciones forzadas con culturas centroeuropeas)."
- 1.B: "El informe de Beltrán de 1973" + diálogo Andrés/Maren sobre Beltrán.

**Sustituciones aplicadas**:
- 1.0.1 (F2): "El del centro es Pío Beltrán, arqueólogo" → omitida; la foto se describe genéricamente sin afirmar identidad histórica concreta.
- 1.0.3 (F3): "el libro de Beltrán" → "el libro de la sierra".
- 1.1.2 (F4.1): "Una excavación de 1973" → "Una excavación de los años 70" (sin nombrar autor); "Una de 2018" → "Una más reciente" (sin nombrar autor).

**Pendiente** para fases jugables (F6):
- En el catálogo de fuentes de la Brecha 1.1, el "Informe de 1973" + el "Informe de 2018" tendrán que aparecer como fuentes ficticias diegéticas — atribuidas a "un arqueólogo de los años 70" (anónimo) y "un equipo de revisión moderno" (anónimo). El sesgo diffusionista del primer informe se preserva como contenido pedagógico sin afirmar autoría.

**Razón**: Pío Beltrán es nombre real que requiere validación del comité asesor (cuál Beltrán, qué publicaciones, qué reputación historiográfica). Hasta que el comité valide, no se puede afirmar identidad histórica concreta.

---

## EDIFICIO-ARCHIVO — verosimilitud arquitectónica del Archivo en calle Curia

**Tracker doc 17**: pendiente.

**Guion canónico (doc 07)**:
- 1.0.2: "El patio. Los capiteles del s. XII. El brocal del pozo es del XV."

**Sustitución aplicada**:
- 1.0.2 (F3): siglos concretos sustituidos por "Los capiteles tienen muchos siglos. El brocal del pozo, también. Aquí no se tira nada que sirva."

**Razón**: el edificio del Archivo en la calle Curia es ficticio en su forma concreta (verosímil pero no documentado). Afirmar siglos concretos para piezas arquitectónicas inventadas necesita validación del comité.

---

## ARALAR-DATACIONES — fechas C14 concretas para la Brecha 1.1

**Tracker doc 17**: Aralar y sus megalitos están **validados**, pero las dataciones C14 específicas que el guion menciona (4.300 ± 80 a.C. y 3.900 ± 60 a.C.) no están explícitamente en el tracker.

**Guion canónico (doc 07 §1.1.4)**:
- "Informe de 2018: revisión moderna con C14 sobre dos huesos: 4.300 ± 80 a.C. y 3.900 ± 60 a.C."

**Sustitución prevista (F6.2)**:
- Las dataciones se mantendrán como **datos plausibles** (rango neolítico para megalitismo en Aralar es arqueológicamente común) pero redondeadas y con margen de duda explícito. Concretamente: "hacia 4300 a.C." y "hacia 3900 a.C." sin las desviaciones específicas, presentadas como "datos de un informe moderno" sin afirmar laboratorio o autor concreto.

**Razón**: las cifras concretas (incluido el ± de error) sugieren un análisis específico. Hasta que el comité valide qué laboratorio/qué publicación, mejor mantener cifras redondeadas y plausibles.

---

## EIDER — amiga de Maren del instituto

**Tracker doc 17**: Eider no aparece como entrada de validación; es personaje ficticio del juego (no histórico).

**Guion canónico (doc 07 §1.A)**: Eider aparece con Maren en una cafetería del Casco Viejo. Diálogo natural sobre cómo le fue el dolmen.

**Estado**: no es bloqueo histórico. Cuando se implemente 1.A en F8 simplemente se añade `VozPersonaje.eider` al elenco. Apuntado aquí para no olvidarlo.

---

## CAPILLA-SAKANA — anécdota de la primera Brecha de Isaura

**Tracker doc 17**: no está como entrada.

**Guion canónico (doc 07 §1.1.1)**:
- Isaura cuenta: "Una capilla en ruinas en la Sakana. Visigoda, posible. Resultó que era tardorromana."

**Sustitución aplicada**: ninguna — la anécdota es **diegética y ficticia** (no afirma una capilla histórica concreta), y la pedagogía (datación errada que se reabre) es lo que importa. La Sakana es comarca real validable; el resto es ficción del juego.

**Estado**: marcado como verosímil-aceptable, pero si el comité opina que afirmar "capilla visigoda/tardorromana en la Sakana" sin precisar puede inducir a malentendido histórico, se sustituye por una región más vaga. No urgente.

---

## Mecánicas pedagógicas (F6) — decisiones tomadas sin consenso

Estas son decisiones de diseño pedagógico que normalmente pediría
consenso, pero que para no parar el desarrollo se han tomado
autónomamente. Quedan documentadas para revisión:

### Formulación de Preguntas (F6.1, PR.01/PR.02)
- **Criterio algorítmico**: longitud ≥3 palabras + signo de interrogación + al menos una palabra-pregunta de la lista canónica (qué/quién/cómo/cuándo/dónde/por qué/cuál/cuánto + sí/no/acaso). Score 0-3.
- **Limitación**: el guion (doc 07 §1.1.3) describe un sistema P3 con rúbrica de "investigabilidad, especificidad, relevancia, originalidad" — más sofisticado de lo que un algoritmo simple puede hacer sin LLM. La versión inicial usa el criterio algorítmico básico; cuando se conecte al tutor IA podrá hacer la rúbrica P3 real.

### Evaluación de Fuentes (F6.3, HF.01-09)
- **Criterio algorítmico**: cada fuente lleva 6 propiedades canónicas en JSON con respuestas predefinidas; el niño elige y se compara. P1 score por habilidad.
- **Limitación**: el guion describe un sistema más conversacional ("Considera: ¿el informe de 1973 fue producido en el momento del enterramiento, o lo interpreta?"). La versión inicial es de elección múltiple; el feedback conversacional puede llegar después con tutor IA.

### Reconstrucción + AH.03 (F6.4, P4 Brier)
- **Criterio algorítmico**: el niño elige entre afirmaciones precanónicas las que considera sostenidas y declara confianza (Sólido/Probable/Disputado). Brier invertido compara con calibración correcta declarada en el catálogo de la Brecha.
- **Limitación**: el guion permite que la Cronista escriba sus propias afirmaciones. La versión inicial sólo permite elegir entre precanónicas; escritura libre con evaluación llega cuando se conecte al tutor IA.

### Concilio (F6.5)
- **Criterio**: feedback automatizado por personaje basado en lo que el niño hizo. Sin ganar/perder. Tono cercano al guion 1.1.6.
- **Limitación**: el guion 1.1.6 es un diálogo orgánico Isaura-Maren basado en lo que la Cronista hizo. La versión inicial son ramas precanónicas según ranges de scores; el diálogo real con tutor IA llega después.

---

## Doc 11 — paleta visual del juego pendiente de cerrar

`paleta_archivo.dart` es **provisional** — sepia/papel/tinta + ámbar
lacre. Cuando se cierre el doc 11 (guía visual del Archivo), se
revisan colores de personajes, ambientes y UI.
