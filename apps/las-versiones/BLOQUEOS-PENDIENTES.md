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
- 1.B (F8.1): "El informe de Beltrán de 1973" → "El informe antiguo del dolmen"; "¿Qué te parece Beltrán?" → "¿Qué te parece el informe?". La línea pedagógicamente clave de Maren ("tiene cosas raras, pero también tiene cosas que no las tendríamos sin él") se preserva intacta — articula la postura del oficio frente a fuentes con sesgo sin requerir que el "él" sea Beltrán.

**Pendiente** para fases jugables (F6):
- En el catálogo de fuentes de la Brecha 1.1, el "Informe de 1973" + el "Informe de 2018" tendrán que aparecer como fuentes ficticias diegéticas — atribuidas a "un arqueólogo de los años 70" (anónimo) y "un equipo de revisión moderno" (anónimo). El sesgo diffusionista del primer informe se preserva como contenido pedagógico sin afirmar autoría.

**Aplicado en F6.2** (catálogo `Brecha.fuentes` de la 1.1):
- Las 5 fuentes son explícitamente ficticias y diegéticas. Sus `tipoVisible` y `descripcion` no afirman autoría real, ni dataciones C14 con desviaciones específicas (ver entrada ARALAR-DATACIONES), ni publicaciones identificables. La pedagogía (sesgo difusionista del informe antiguo, contraste con revisión moderna, fuente lingüística por topónimo, fuente material primaria) se preserva.

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

**Aplicado en F8.1 (cinemática 1.A)**: el guion canónico dice en boca de Maren "las dos dataciones" al contarle a Eider lo del dolmen. Sustituido por "las dos fechas que no terminan de cuadrar" — léxico adolescente más natural que tampoco afirma laboratorio o autor del C14. La sensación de incertidumbre que la frase quiere transmitir se preserva.

---

## EIDER — amiga de Maren del instituto

**Tracker doc 17**: Eider no aparece como entrada de validación; es personaje ficticio del juego (no histórico).

**Guion canónico (doc 07 §1.A)**: Eider aparece con Maren en una cafetería del Casco Viejo. Diálogo natural sobre cómo le fue el dolmen.

**Estado**: implementada en F8.1 — `VozPersonaje.eider` añadida al elenco con tinta tenue (entorno íntimo no-institucional, igual que el resto de la familia). Cinemática 1.A "La merienda con Eider" en `EscenasArco1.laMeriendaConEider`. No es bloqueo histórico — Eider es ficticia y diegética.

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

## Mosaico Arco 1 v2 — pregunta abierta y formulación de las viñetas (F8.7)

**Tracker doc 17**: pendiente de revisión humana.

**Guion canónico (doc 07 §M1, v0.1)**: el doc fue escrito asumiendo que el Arco 1 era sólo Aralar, así que la pregunta abierta del Mosaico es "¿Cómo era de verdad un día cualquiera en Aralar hace 6.000 años?" y los **5 anclajes obligatorios** (al menos 3 de 5) son todos del dolmen: dataciones C14 + análisis de polen + cerámica campaniforme + herramientas líticas + paisaje. Formato: cómic mudo de **8 viñetas**, cada una con código de color por confianza (azul Sólido / ámbar Probable / rojo claro Disputado).

**Estado**: implementado en F8.7 con generalización del v0.1 al arco ampliado del v0.2 (cuatro Estaciones).
- **Pregunta abierta sustituida**: "¿Cómo era de verdad un día cualquiera en Aralar hace 6.000 años?" → "¿Cómo se hace el oficio del cronista — qué he aprendido en este primer arco?". La nueva formulación cubre las cuatro Brechas (no sólo Aralar) y mantiene la apertura del original. La pregunta pedagógica sigue siendo la misma — qué se aprende del oficio en el arco — pero sin atar al lugar concreto que era el único cuando se redactó el v0.1.
- **8 viñetas pre-descritas**, 2 por Estación, cada una anclada a fuentes ya catalogadas en `CatalogoBrechas`:
  - 1.1 — `aralar_dolmen_visita` (anclajes: huesos in situ, lítico, informe antiguo, informe moderno) + `aralar_paisaje_y_toponimo` (anclajes: informe moderno, topónimo local).
  - 1.2 — `cromlech_banquete` (anclajes: cerámica fragmentaria, C14 única, lítico escaso) + `cromlech_dialogo_con_sira` (sin anclaje arqueológico — viñeta pedagógica de relación con un par).
  - 1.3 — `cueva_grabados_parietales` (anclajes: grabados in situ, comparativa otras cuevas) + `cueva_covacho_habitacion` (anclajes: covacho con carbones, informe excavación).
  - 1.4 — `irulegi_casa_y_enlosado` (anclajes: casa con escaleras, enlosado colapsado, cerámica mixta, armas) + `irulegi_la_mano` (anclajes: pieza, cartela museo dos lecturas, monográfico FLV 136).
- **Mínimo de viñetas marcadas para entregar**: 6 de 8. Equivale a la regla del v0.1 ("3 de 5 anclajes obligatorios") aplicada al nuevo conjunto: la Cronista puede dejar 2 viñetas sin marcar (típicamente las de la Estación que sintió menos suya) y aún así entregar.
- **Color de los códigos**: azul Sólido (`Color(0xFF7AAFD8)`), ámbar Probable (`PaletaArchivo.ambarLacre`), rojo claro Disputado (`Color(0xFFD08A82)`). Los tonos exactos quedan provisionales hasta cerrar la paleta del juego (doc 11) — anotados en la entrada existente DOC-11-PALETA.

**Pendiente de revisión humana**:
- ¿La sustitución de la pregunta abierta es aceptable? La nueva formulación es deliberadamente meta ("¿qué he aprendido del oficio?") en lugar de reconstructiva ("¿cómo era ese día?"). El guion v0.1 prefería la segunda — más imaginativa, más concreta. Posible alternativa: dejar que la Cronista elija una de las cuatro Estaciones como "el día" sobre el que reconstruye. Eso preservaría el espíritu del v0.1 dentro de un arco más amplio.
- ¿Las dos viñetas por Estación son las acertadas? Otras combinaciones posibles: en la 1.2 podría entrar la voz del Cuaderno con la "C14 sola" en lugar del diálogo con Sira; en la 1.4 la Mano podría ir sola y la otra ser una viñeta del Concilio.
- La viñeta `cromlech_dialogo_con_sira` no tiene anclaje arqueológico (es relacional). ¿Debe contar o no para el mínimo de marcadas? Hoy cuenta — la regla pide marcar 6 sin distinguir el tipo. Si el comité prefiere "al menos N de las que tienen anclaje", la regla cambia.
- Color de los niveles de confianza — provisional hasta cerrar doc 11.

---

## Mosaico Arco 1 — disparador del flag (cerrado en F8.6 y F8.7)

**Tracker doc 17**: el Mosaico es categoría no-atomizada (doc 15 §3) — los prompts actuales son provisionales y deberá revisarlos quien valide el material pedagógico cuando entren más Brechas al arco.

**Estado actual (tras F8.6)**:
- El catálogo del Arco 1 tiene las cuatro Brechas implementadas (1.1, 1.2, 1.3, 1.4). El disparador del Mosaico (`arco_1_completado`) se ha movido a su sitio canónico — se activa al cerrar la cinemática 1.4.4 ("Aprendiz I"), que es el cierre real del arco según el doc 07 §M1 ("Activa: tras 1.4, en los días siguientes").
- Los tres prompts del Mosaico (`que_te_llevas`, `que_te_queda`, `que_cambiarias`) **siguen hablando en singular del "dolmen"** — esto es contenido pendiente de F8.7. El doc 07 v0.2 §M1 prescribe un formato distinto: 8 viñetas con código de confianza (Sólido/Probable/Disputado) más feedback escrito a piezas seleccionadas, sustituyendo los 3 prompts de texto. Hasta que F8.7 reescriba la pantalla del Mosaico, los prompts singulares del "dolmen" siguen activos.

**Pendiente para F8.7**: reescritura completa de `pantalla_mosaico_arco_1.dart` al formato v0.2 — 8 viñetas con código de confianza por viñeta + feedback breve por viñeta seleccionada. Los `MosaicoArco1.flagDeArcoCompletado` y `flagDeMosaicoEntregado` se mantienen (sólo cambia el contenido visual y el repositorio de respuestas).

---

## Brecha 1.2 (crómlech) + cinemática 1.2.fin con Sira — fuentes diegéticas y cierre canónico (F8.4)

**Tracker doc 17**: pendiente de revisión humana.

**Guion canónico (doc 07 §1.2)**: Aralar segunda visita. Esta vez con **Sira Goizueta** (Aprendiz II Constructora, 15 años) en lugar de Isaura. Crómlech vecino, restos de banquete funerario sin enterramiento óseo claro, material muy fragmentado, una sola C14 disponible. Lección epistémica: cronología relativa sin datación absoluta sólida — **Probable** se vuelve protagonista. Conflicto entre Maren y Sira (Sira más rápida y menos cauta, Maren la frena). Concilio con Aitor como revisor — aprueba la versión cauta. Cierre: caminata de regreso con la línea "tenías razón / no siempre la tendré / ya, pero hoy sí" + voz del Cuaderno esa noche.

**Estado**: implementada en `CatalogoBrechas.brecha12` (5 fuentes diegéticas + 6 afirmaciones canónicas) + cinemática `EscenasArco1.cierreCromlechConSira` (1.2.fin). El flujo del orquestador queda:
- `1.B` ahora activa `cromlech_aralar_alcanzado` (antes activaba `arco_1_completado` directo, lo que adelantaba el Mosaico — corregido en F8.4).
- La Brecha 1.2 se dispara automáticamente, recorre las 5 fases jugables, cierra con `brecha_1_2_completada`.
- La 1.2.fin se reproduce como cinemática post-Brecha (mismo patrón que 1.1.7 tras la 1.1).
- La 1.B.1 latente, anclada a `brecha_1_2_completada`, se dispara después automáticamente.

**Sin sustituciones diegéticas en el contenido jugable**: las 5 fuentes catalogadas son explícitamente ficticias y diegéticas (cerámica fragmentaria, una sola C14, material lítico mínimo, informe comparativo, topónimo del círculo). No afirman C14 con cifra concreta, no atribuyen autoría real, no nombran publicaciones identificables.

**Pendiente de revisión humana**: voz de Sira (la línea "ya, pero hoy sí" debe encajar con el tono adolescente fijado en doc 04 — Sira como par de Maren, no como autoridad), el equilibrio de las 6 afirmaciones canónicas (¿demasiadas Probables? ¿la Disputada del C14 absoluto está bien calibrada?), y la decisión de no implementar cinemática introductoria 1.2.0 (Maren conociendo a Sira en el coche o en el campo). El doc 07 no detalla esa entrada — la Brecha arranca directamente cuando el orquestador la abre.

---

## Cinemática 1.4.4 "Aprendiz I" — sustituciones revertidas en F8.6

**Tracker doc 17**: pendiente de revisión humana.

**Guion canónico (doc 07 §1.4.4)**: cierre del Arco 1 en el patio del Archivo. Maren e Isaura solas tras el gran Concilio de la Estación 4. Validación amable, mención de los gestos de Begoña, anuncio del Arco 2 (Pompaelo). Aparece flotante "APRENDIZ I" — Maren asciende de rango.

**Estado**: implementada en `EscenasArco1.aprendizI`. Tras F8.6, la precondición pasa de `{brecha_1_4_completada}` a `{escena_1_4_3_vista}` — la Brecha 1.4 cierra antes que la cinemática 1.4.3 (gran Concilio), y la 1.4.4 se encadena tras la 1.4.3.

**Sustituciones revertidas en F8.6** (Brecha 1.4 ya implementada):
- "Reformularías sobre la violencia romana" — recupera su forma canónica. El doc 07 §1.4.3 (gran Concilio) articula explícitamente la matización (Karim pregunta a Maren si está minimizando la violencia romana, Maren reformula), así que la frase de Isaura tiene ahora su anclaje narrativo dentro del juego.
- "Otra Brecha sin haber visto la Mano y haber tenido que defenderte sobre ella" — recupera su forma canónica. El jugador ha trabajado la Mano en la fase jugable de la Brecha 1.4 y la ha defendido en el Concilio.

**Sustitución residual**:
- "El capitel del s. XII y el brocal del pozo" → "el capitel y el brocal del pozo" (entrada EDIFICIO-ARCHIVO, simétrica a la sustitución ya aplicada en 1.0.2). Sigue activa hasta que el comité valide los siglos.

**Pompaelo y la transición vascón → romano** se preservan en su forma canónica — Pompaelo está validada como entrada (ya aparece en 1.0.2) y la frase de Isaura ("lo que pudo haber sido un asentamiento vascón previo") declara explícitamente la incertidumbre, encajando con el oficio.

**Pendiente de revisión humana**: confirmación de que el patrón pedagógico de Begoña (sólo sonríe cuando el aprendiz reconoce sus límites o se compromete a reformular) se mantiene legible.

---

## Brecha 1.4 (yacimiento de Irulegi y la Mano) + 3 cinemáticas internas (F8.6)

**Tracker doc 17**: pendiente de revisión humana. La capa Irulegi/Mano está validada explícitamente en el header v0.2 del doc 07 (entrada YACIMIENTO-CELTIBERICO/VASCON) como yacimiento principal de la Estación 1.4 — Irulegi (Aranguren), datación de abandono ~70 a.C. en el contexto de las guerras sertorianas, Mano de Irulegi como pieza central. La Custodia (Viana) queda como mención narrativa para futuras Brechas, no aparece aquí.

**Guion canónico (doc 07 §1.4)**: 5-6 semanas tras inicio del juego. Maren visita el monte Irulegi con Isaura (1.4.1) — el arqueólogo del yacimiento la recibe, le explica las casas vascónicas tardías con escaleras de piedra, le anuncia el Concilio entero del día siguiente. Isaura le menciona la Mano (que verán por la tarde en el Museo de Navarra) y, con cuidado, la presencia de un perinatal cercano. La 1.4.2 cubre el día completo de trabajo: yacimiento por la mañana (casa con escaleras, enlosado romano colapsado, cerámica mixta, armas del ataque, huesos animales), Museo de Navarra por la tarde (la Mano + cartela con dos lecturas distintas + paneles de contexto). Voz larga del Cuaderno articulando la postura epistémica ante el debate académico abierto. Fase jugable de la Brecha 1.4 (recolección + evaluación + reconstrucción + concilio algorítmico). 1.4.3 reproduce el diálogo concreto del gran Concilio — preguntas de Aitor (afirmación 5), Joana (afirmaciones 8 y 9), Begoña (contacto vs romanización), Karim (sobrepeso simbólico de la Mano + violencia romana). Cierre con Begoña pronunciando "Aprendiz I". Marina aplaude sin protocolo. Maren sonríe.

**Estado**: implementada en `CatalogoBrechas.brecha14` (7 fuentes diegéticas + 9 afirmaciones canónicas — 5 Sólidas + 2 Probables + 2 Disputadas) + 3 cinemáticas en `EscenasArco1` (`viajeAYacimientoIrulegi`, `materialCongelado`, `granConcilio`). El flujo del orquestador queda:
- 1.4.1 se encadena con `escena_1_3_7_vista` (apunte largo del Cuaderno tras el primer Concilio formal de la 1.3).
- 1.4.2 se encadena con 1.4.1 y al cerrarla activa `material_irulegi_recogido`, que el catálogo reconoce como disparador de la fase jugable de la Brecha 1.4.
- Tras `brecha_1_4_completada`, el orquestador encadena 1.4.3 (gran Concilio narrativo) — la fase F6.5 jugable ya dio el feedback algorítmico; la 1.4.3 añade el contenido específico que el algoritmo no genera.
- Tras `escena_1_4_3_vista`, el orquestador encadena 1.4.4 (patio del Archivo, "Aprendiz I"), que activa `arco_1_completado` y dispara el Mosaico de fin de arco.

**Sin sustituciones diegéticas en el contenido jugable de la Brecha**: las 7 fuentes son ficticias y diegéticas en su descripción (no afirman C14 con cifra concreta ni autoría real para el material excavado), pero referencian la Mano de Irulegi por su nombre canónico — está validada en doc 17. La cartela del Museo de Navarra y el monográfico de **Fontes Linguae Vasconum 136 (2023)** son referencias **reales y trazables** — información pública verificable, no se diegetizan. Las 9 afirmaciones canónicas reproducen literalmente la calibración del doc 07 §1.4.3 (5 Sólidas + 2 Probables + 2 Disputadas).

**Sin sustituciones en el diálogo de la 1.4.3**: el Concilio reproduce literalmente el guion canónico. La voz de Joana (Anclada — distingue Disputado de "no establecido") y la de Karim (Reformista — pilla a Maren dos veces, sobre la Mano y sobre la violencia romana) se fijan aquí por primera vez con material narrativo largo. La frase pedagógica clave de Maren sobre la relación lengua vascónica/euskera ("Yo declaro Probable la relación porque es plausible. Pero declaro Disputada como afirmación metodológica porque el oficio honesto no me permite afirmarla con la rotundidad que algunas voces dentro y fuera del debate quieren") se reproduce intacta — es el corazón pedagógico del Arco 1.

**Decisión sobre el arqueólogo del yacimiento**: el guion canónico decide explícitamente no nombrar al arqueólogo en pantalla, sólo "el arqueólogo". La voz `VozPersonaje.arqueologo` lleva el `nombreVisible: 'Arqueólogo'` siguiendo la decisión.

**Pendiente de revisión humana**:
- Voces de Joana y Karim — primera aparición con material narrativo largo. ¿El tono encaja con la Bíblia de Personajes (doc 04, hoy aún sin entradas detalladas para ellos)?
- ¿La calibración de la afirmación 6 (la Mano como objeto apotropaico colgado en dintel) está bien como Probable? El doc 07 v0.2 propone Probable porque la función protectora se infiere por contexto de hallazgo + paralelos mediterráneos; el comité podría argumentar Sólido si los paralelos son robustos, o Disputado si el comité prefiere reservar el juicio.
- Tono de la voz del Cuaderno en la 1.4.2 — primera vez que el Cuaderno articula explícitamente la postura epistémica ("voy a tener que sostener la incertidumbre") en primera persona larga.
- Presencia narrativa del perinatal en la 1.4.1 — Isaura lo menciona "para que sepas" y el guion canónico cierra con "la Brecha no se centra en él". ¿La forma como Maren "se queda quieta" un segundo y dice "Vale" es suficiente respeto pedagógico? ¿O necesita un tratamiento más extenso en alguna entrada del Cuaderno?
- ¿La frase de Karim sobre el sobrepeso simbólico de la Mano ("ha sido mucho más que pieza arqueológica desde 2022") encaja con la prudencia del juego sobre afirmaciones políticas? El monográfico de Fontes Linguae Vasconum es público; el sobrepeso simbólico es observable.

---

## Brecha 1.3 (cueva del Pirineo) + 7 cinemáticas internas — sustituciones diegéticas (F8.5)

**Tracker doc 17**: pendiente de revisión humana. La capa Cueva-Pirineo está validada como entrada general en el doc 17 (datación canónica ~13.000 años, Magdaleniense), pero los nombres concretos del doc 07 v0.2 NO lo están: Alkerdi I (literaria), Berroberria, Barandiarán, Isturitz, Lezia, Lexotoa.

**Guion canónico (doc 07 §1.3)**: Maren visita una cueva paleolítica con Isaura tras tres semanas dentro del oficio. Cinco cinemáticas concatenadas (viaje al Pirineo → boca de la cueva → covacho de habitación → sala con grabados parietales → vuelta y silencio) que abren la fase jugable de la Brecha 1.3, seguidas de dos cinemáticas post-Brecha (primer Concilio formal con revisores académicos + apunte largo en el Cuaderno). Lección epistémica: cómo declarar **disputada** la afirmación clave (significado del arte parietal) sin caer en relativismo, y cómo formular "no podemos determinar con la evidencia disponible" frente a "no se sabe".

**Estado**: implementada en `CatalogoBrechas.brecha13` (5 fuentes diegéticas + 7 afirmaciones canónicas) + 7 cinemáticas en `EscenasArco1` (`viajeAlPirineo`, `laBocaDeLaCueva`, `dentroDeLaCueva`, `laPared`, `vueltaYSilencio`, `elPrimerConcilioFormal`, `elApunteLargo`). El flujo del orquestador queda:
- 1.B.1 (latente desde F8.2) ahora se dispara automáticamente al cerrar la Brecha 1.2 — su `flagDeSalida` (`escena_1_b1_vista`) actúa como precondición de 1.3.1.
- 1.3.1-1.3.5 se encadenan por `flagDeSalida` y al cerrar 1.3.5 se activa `cueva_pirineo_visitada`, que el catálogo reconoce como disparador de la fase jugable de la Brecha 1.3.
- Tras `brecha_1_3_completada`, el orquestador encadena 1.3.6 (Concilio formal) y 1.3.7 (apunte largo), y luego la 1.C (latente desde F8.2).

**Sustituciones diegéticas aplicadas**:
- **Yacimiento concreto**: el doc 07 v0.2 caracteriza la cueva como "Alkerdi I literaria, modelo verosímil basado en lo real". El código no nombra ningún yacimiento real — la cueva queda diegética. Los nombres del v0.2 (Alkerdi, Berroberria, Isturitz, Lezia, Lexotoa) no aparecen en código.
- **Investigador**: "Barandiarán" (nombre real con peso historiográfico) sustituido por "equipos académicos de varias generaciones" / "un equipo académico de prehistoria". La pedagogía (informes con vocabulario hoy revisado, reinterpretación posible a la luz de campañas más recientes) se preserva.
- **Datación C14 específica**: el guion 1.3 v0.2 menciona dataciones concretas. Sustituidas por "Magdaleniense Inferior o Medio (~13.000 años antes del presente)" — rango canónico ya validado en doc 17 para la capa, sin laboratorio ni publicación específica.
- **Significado del arte parietal**: la afirmación canónica clave (`significado_arte_parietal`) se formula como **Disputada** con el texto "Podemos determinar con la evidencia disponible el significado del arte parietal magdaleniense" — formulación deliberadamente ambigua que el jugador debe rechazar ("no podemos") al asignarle nivel Disputado. Lección pedagógica del doc 07.

**Sin afirmar contenido sobre vivencias o creencias** de las personas paleolíticas (prohibición del CLAUDE.md): la sala con grabados se describe en términos materiales (luz natural no llega, técnica de grabado, paralelismos estilísticos), las afirmaciones canónicas no asumen función simbólica concreta, y la afirmación `autores_grabados_y_covacho` (¿son las mismas personas que habitaron el covacho contiguo?) está calificada como **Disputada**, no afirmando identidad.

**Pendiente de revisión humana**: 
- ¿La afirmación `luz_artificial` debe ser **Probable** o **Sólida**? (Hoy es Probable porque inferimos la lámpara/antorcha por ausencia de luz natural; el comité puede argumentar que la inferencia es lo bastante directa para Sólido.)
- ¿La afirmación `losas_sellaron_posteriormente` está bien calibrada como **Probable**? (Hoy lo es porque "técnica y desgaste" sugieren posterioridad sin confirmarla; ¿es suficiente o debería ser Disputada?)
- Tono de Joana en la 1.3.6 — primera revisora académica de Maren, voz aún no fijada en doc 04 (apuntada en Bíblia de Personajes pero sin entrada propia).
- ¿Aitor encaja como guía del Concilio formal en 1.3.6? El doc 07 v0.2 lo nombra; voz pendiente de fijar.

**Cuando el comité valide los nombres**: revertir Barandiarán + nombrar el yacimiento concreto si se valida + opcionalmente añadir cifra de C14 con su laboratorio si el comité aporta referencia.

---

## Cinemática 1.Z del cierre del arco — pendiente hasta cerrar formato del Mosaico

**Tracker doc 17**: pendiente.

**Guion canónico (doc 07 §1.Z)**: la noche de la entrega del Mosaico. Maren en su mesa con el cuaderno. Voz interna que cierra el arco: ha entregado el Mosaico, Andrés le ha dicho que la mayoría no se atreve a marcar roja la viñeta del banquete, Marina dice que ya es del club, ha aprendido cosas, mañana descansa, el lunes empieza el Arco 2.

**Estado**: NO implementada. La cinemática hace referencias específicas a contenido que aún no encaja con lo implementado:
- "La viñeta del banquete" implica un formato de Mosaico tipo cómic con viñetas marcables, distinto de los 3 prompts de texto del Mosaico actual (provisional).
- "Manos pintadas hace catorce mil años" referencia la Estación 1.3 que el header v0.2 del doc 07 reescribe a fauna magdaleniense, no manos en negativo.
- "Marina dice que ya soy del club" referencia interacción con Marina en el Concilio de la 1.4 que no está implementada.

**Razón**: implementar 1.Z hoy obligaría a sustituir tantos elementos que la cinemática perdería identidad. Mejor esperar a que (a) el formato del Mosaico se cierre, (b) la Estación 1.3 esté implementada con su contenido validado v0.2, y (c) la Estación 1.4 esté implementada con el rol de Marina en el Concilio. Cuando esos tres frentes cierren, 1.Z se puede escribir sin sustituciones.

---

## Cinemáticas latentes 1.B.1 y 1.C — ancladas a Brechas no implementadas (F8.2)

**Tracker doc 17**: pendiente de revisión humana.

**Guion canónico (doc 07)**:
- 1.B.1 "Conversación con el padre" — cocina familiar, ~10-12 días tras cerrar la Estación 2. Antonio le devuelve a Maren su propia frase ("el oficio cuenta las cosas como pasaron") corregida ("no es como pasaron"); Maren llega sola a "como pueden haber pasado, con la mejor honestidad posible".
- 1.C "Naia pregunta" — cena familiar tras la Estación 3. Naia pregunta a Maren si los huesos viejos le dan miedo. Maren contesta "porque eran personas".

**Estado**: implementadas en `EscenasArco1` con `flagsRequeridos: {brecha_1_2_completada}` y `{brecha_1_3_completada}` respectivamente. Como las Brechas 1.2 y 1.3 no están todavía en el catálogo del juego, **el orquestador no las disparará** — quedan latentes en el catálogo, listas para activarse automáticamente cuando entren las Brechas correspondientes. Mismo patrón que mantuvo la 1.1.7 mientras la Brecha 1.1 era esqueleto.

**Sin sustituciones diegéticas aplicadas**: las dos cinemáticas no nombran fechas, lugares, autores ni dataciones específicas — el contenido del guion canónico se preserva tal cual.

**Pendiente de revisión humana**: confirmación de que el tono de Maren articulando la postura epistémica del oficio en 1.B.1 ("como pueden haber pasado, con la mejor honestidad posible") encaja con la voz fijada en doc 04, y de que la respuesta humanizadora a Naia en 1.C ("eran personas") no entra en colisión con la prohibición de afirmaciones sobre vivencias o creencias de poblaciones prehistóricas — la frase humaniza al sujeto histórico sin afirmar nada sobre cómo se sentían respecto a su muerte.

---

## Cinemáticas 1.A y 1.B — sustituciones diegéticas aplicadas (F8.1)

**Tracker doc 17**: pendiente de revisión humana.

**Guion canónico (doc 07)**:
- 1.A "La merienda con Eider" — cafetería del Casco Viejo, ~3 días después del cierre de la Estación 1. Diálogo natural sobre cómo le fue el dolmen. Eider es personaje ficticio del juego.
- 1.B "El ático" — Maren sube al ático del Archivo a buscar un informe; Andrés le hace una pregunta clave sobre cómo trata fuentes con sesgo. Activa `arco_1_completado` al cerrar (se mueve a 1.4.4 cuando entren las Estaciones 1.2-1.4 al catálogo).

**Estado**: implementadas con sustituciones diegéticas que preservan la pedagogía sin afirmar contenido histórico no validado. Las dos cinemáticas se reproducen en orden tras la 1.1.7 y antes del Mosaico, siguiendo el flujo del doc 07.

**Sustituciones aplicadas (registradas también en las entradas PIO-BELTRAN y ARALAR-DATACIONES)**:
- 1.A: "las dos dataciones" → "las dos fechas que no terminan de cuadrar" (no afirmar laboratorio o autor C14).
- 1.B: "el informe de Beltrán de 1973" → "el informe antiguo del dolmen"; "¿qué te parece Beltrán?" → "¿qué te parece el informe?" (no afirmar autoría hasta validación del comité).

**Pendiente de revisión humana**: voz de Eider (adolescente bilbaína-pamplonica del entorno de Maren — ¿el tono encaja con cómo se quiere retratar a esa generación en la Colección?), tono de Andrés en su pregunta a Maren (¿la pregunta debe sonar a "examen" o a "conversación entre colegas"?), y confirmación de que el reconocimiento mínimo de Andrés ("vas bien") encaja con la voz fijada en doc 04. Si el comité valida el apellido Beltrán + las dataciones, el contenido del 1.B + 1.A se puede revertir al canónico sin tocar la estructura.

---

## Doc 11 — paleta visual del juego pendiente de cerrar

`paleta_archivo.dart` es **provisional** — sepia/papel/tinta + ámbar
lacre. Cuando se cierre el doc 11 (guía visual del Archivo), se
revisan colores de personajes, ambientes y UI.
