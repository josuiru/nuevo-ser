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

## Arco 2 — narrativa lineal completa: Estación 2.1 + latentes 2.A + Estación 2.2 + latente 2.B.1 + Estación 2.3 + latente 2.C.1 + Estación 2.4 + entrega Mosaico M2 + cierre 2.Z (F2-1 a F2-8)

**Tracker doc 17**: pendiente.

**Estado**: implementadas las 34 cinemáticas que cubren la apertura del Arco 2 (2.0.1), las cuatro Estaciones enteras (2.1 Pompaelo, 2.2 Calagurris, 2.3 domus de los mosaicos, 2.4 Wamba contra los vascones), las tres cinemáticas latentes post-Estación que cosen el arco emocionalmente (2.A.1 + 2.A.2 tras Pompaelo, 2.B.1 tras Calagurris, 2.C.1 tras la domus), la cinemática de entrega del Mosaico M2 (M2.entrega, doc 08 §M2: ático del Archivo, Andrés escucha la audio-guía de 90s con auriculares y la valida con la observación pedagógica clave — *"has dicho 'no sabemos' tres veces. Y 'probablemente' cuatro" / "está perfecto"*) y las dos cinemáticas del cierre del Arco 2 (2.Z.1 *Antonio y Wamba* en la cocina de casa con el paralelo entre los moriscos del Quijote y el silencio vascón + el aforismo del padre *"los oficios que tienes claros desde el principio suelen ser los que se acaban antes"* + la frase truncada *"Maren / Mmm. Olvídalo. Sigamos cocinando"*; 2.Z.2 *La grabación* en el cuarto de Maren — Maren había grabado a su padre en la cocina sin decírselo, escucha la grabación entera, la guarda con honestidad declarada para mañana, articula tres pensamientos del Cuaderno y apunta el silencio del padre como pregunta abierta *"como Isaura"*; cierre simbólico del arco con ARCO 2 — CERRADO + anuncio del Arco 3 *La forja del reino*). La línea epistémica clave del arco se fija en 2.4.5 (cocina del Archivo, conversación con Karim): **"el silencio vascón es el dato. No es ausencia de dato. Es dato. Es información sobre cómo funcionaba la maquinaria de la fuente"**. La Estación 2.4 se diferencia de las tres anteriores en que la asimetría documental es deliberadamente extrema: una sola perspectiva, la del productor visigodo (Julián de Toledo). El Concilio dividido (2.4.7) reproduce las cinco voces revisoras del Arco 2 — Karim Reformista, Aitor Constructor, Joana, Begoña, Isaura — con desacuerdo explícito sobre la calibración de la afirmación 8. La narrativa lineal del Arco 2 está completa; quedan pendientes la pantalla jugable del Mosaico M2 (formato audio-guía, distinto del M1 cómic) y las cuatro Brechas jugables 2.1/2.2/2.3/2.4 (requieren refactor previo de `FaseBrecha`).

El orquestador encadena Arco 1 → Arco 2 cruzando `arco_1_cerrado_por_la_cronista` (1.Z) y dentro del Arco 2 las 34 cinemáticas se encadenan por `flagsRequeridos`/`flagDeSalida`. La 2.4.1 requiere `escena_2_c_1_vista` (que la 2.C.1 activa); la 2.4.8 cierra activando `aprendiz_dos_alcanzado`, `arco_2_estacion_4_cerrada` y (provisional) `mosaico_arco_2_entregado`. La M2.entrega requiere `mosaico_arco_2_entregado` y activa `escena_m2_entrega_vista`. La 2.Z.1 requiere `escena_m2_entrega_vista` y activa `escena_2_z_1_vista`. La 2.Z.2 requiere `escena_2_z_1_vista` y activa `arco_2_cerrado_por_la_cronista` — hito que el Arco 3 requerirá como precondición. Tras cerrar la 2.Z.2 el orquestador cae al esqueleto porque las cinemáticas del Arco 3 todavía no están implementadas.

**Pendiente para próximas iteraciones**:
- Pantalla jugable del Mosaico M2 ("audio-guía de Pompaelo") — formato distinto al M1 según doc 08 §M2 (audio en lugar de cómic). Posible refactor del modelo `Mosaico` a una abstracción que admita varios formatos. Cuando entre, el flag `mosaico_arco_2_entregado` se mueve del cierre de la 2.4.8 al `_alEntregarMosaicoArco2` del orquestador (entrada F2-8 propia más abajo con detalle del cambio).
- Catálogo de Brechas del Arco 2 (`CatalogoBrechas` añade brecha21 + brecha22 + brecha23 + brecha24 jugables) — requiere refactor previo de `FaseBrecha` para admitir distintos números de afirmaciones por Brecha (entrada propia más abajo).
- Validación humana del comité asesor sobre el contenido histórico concreto del Arco 2 — sustituciones diegéticas residuales en secciones siguientes.

**Sin sustituciones diegéticas en 2.B.1 ni 2.C.1**: el cuaderno marrón de Isaura es ficticio del juego; en 2.C.1 la plaza del Castillo es lugar real validable de Iruña y la cinemática no nombra fechas, dataciones ni personajes históricos. Eider sigue siendo personaje ficticio del juego (validación humana sobre su voz registrada en la entrada EIDER existente).

---

## Mosaico M2 — disparador provisional + cierre 2.Z aplicado (F2-8)

**Tracker doc 17**: pendiente.

**Estado**: la cinemática de entrega del Mosaico M2 (`EscenasArco2.entregaDelMosaicoM2`, doc 08 §M2) y las dos del cierre del Arco 2 (`antonioYWamba` 2.Z.1 + `laGrabacion` 2.Z.2, doc 08 §2.Z.1–2.Z.2) están implementadas y encadenadas por flags. La pantalla jugable del Mosaico M2 (audio-guía de 90s con anclajes obligatorios y declaración verbal de niveles de confianza) **no** está implementada hoy.

**Disparador provisional aplicado**:
- La cinemática `aprendizDosLogrado` (2.4.8) activa al cerrar, además de `aprendiz_dos_alcanzado` y `arco_2_estacion_4_cerrada`, también `mosaico_arco_2_entregado`. Eso permite que la `M2.entrega` y, encadenadas, las dos del cierre 2.Z sean alcanzables hoy sin que exista la pantalla M2 jugable.
- Cuando entre la pantalla M2 jugable, el flag `mosaico_arco_2_entregado` se elimina del cierre de la 2.4.8 y se mueve al `_alEntregarMosaicoArco2` del orquestador (paralelo al `_alEntregarMosaicoArco1` que ya existe para el M1). Cambio trivial, ~3 líneas tocadas.
- Mismo patrón provisional que se aplicó en el Arco 1 con `arco_1_completado` cuando sólo la Brecha 1.1 estaba implementada.

**Sin sustituciones diegéticas en M2.entrega**: el diálogo se reproduce literalmente del doc 08 §M2 (Andrés observa que Maren ha dicho "no sabemos" tres veces y "probablemente" cuatro, cierra con "está perfecto"). El reconocimiento por gesto pequeño es simétrico al 1.M1.entrega del Arco 1 — pertenecer al oficio se mide en los silencios del aprendiz.

**Sin sustituciones diegéticas en 2.Z.1 ni 2.Z.2**: la conversación cocina con Antonio reproduce literalmente el doc 08 §2.Z.1, incluido el paralelo entre los moriscos del Quijote y el silencio vascón ("Cervantes habla mucho de moriscos. Pero los moriscos no aparecen escribiendo") + el aforismo del padre ("los oficios que tienes claros desde el principio suelen ser los que se acaban antes") + la frase truncada ("Maren / Mmm. Olvídalo. Sigamos cocinando") que la 2.Z.2 va a interrogar como pregunta abierta. La 2.Z.2 reproduce literalmente la voz íntima del Cuaderno con los cuatro pensamientos canónicos (grabar al padre sin permiso con declaración para mañana, oírse hablando con el padre como par, recordar el aforismo de los oficios, apuntar el silencio del padre como pregunta abierta usando explícitamente el modelo de Isaura). Cierre formal con ARCO 2 — CERRADO + anuncio del Arco 3 *La forja del reino*.

**Pendiente de revisión humana**:
- Tono de Antonio en 2.Z.1 — primera vez que el padre articula material narrativo largo desde la 1.B.1 y desde 2.A.2 (donde Antonio pasa el libro de Quintiliano). El paralelo Quijote/silencio vascón es propuesta intelectual fuerte que el doc 04 deja como abierta para Antonio. ¿Encaja con la voz fijada o requiere ajuste?
- Decisión narrativa de Maren en 2.Z.2 (grabar a su padre sin decírselo) — gesto cercano al límite ético que el juego articula explícitamente: Maren reconoce que "no es bonito hacerlo" y declara que "mañana se lo cuenta". ¿La forma encaja con el oficio que el juego enseña? Se ha mantenido literal del doc 08 v0.1 porque el material pedagógico clave es justo cómo Maren convive con la incomodidad ética declarándola, en lugar de evitarla. El comité podría proponer suavizarlo.
- Línea final del cierre del arco — "Continuará en Arco 3 — La forja del reino". Reproduce el subtítulo del Arco 3 del doc 08 v0.1, pendiente de confirmar con doc 09 cuando se aborde.

---

## Estación 2.4 (Wamba contra los vascones) — yacimiento sin nombre + nueve afirmaciones canónicas (F2-7)

**Tracker doc 17**: pendiente.

**Material trazable** (sin sustitución, ya en el tracker general o en publicaciones de referencia abierta):
- **Wamba** (rey visigodo) y **Julián de Toledo** (autor de la *Historia Wambae regis*) son figuras históricas reales y trazables. La fecha 673 d.C. para la campaña narrada por Julián está en bibliografía estándar.
- **La asimetría documental sobre el lado vascón** del periodo 5-7 d.C. es hecho historiográfico bien documentado: no hay fuentes producidas por las comunidades vascónicas para este periodo concreto. La pedagogía de la Estación se construye sobre esta ausencia documentada, no sobre una afirmación histórica novedosa.

**Sustitución diegética aplicada**:
- **2.4.3 — yacimiento vascón del norte sin nombre histórico en pantalla**. El doc 08 v0.2 §2.4.3 sugiere visitar un yacimiento vascónico real concreto. La cinemática se construye en un yacimiento del norte de Nafarroa **sin nombrarlo**: descripción genérica de poblamiento del periodo, ausencia de cerámica con inscripciones, sin paneles museográficos, ladera mirando al norte. La pedagogía (el silencio del lugar habla del silencio documental) se preserva sin afirmar yacimiento concreto hasta validación del comité asesor sobre cuál usar. Ambiente nuevo: `AmbienteArchivo.yacimientoVasconNorte`.

**Material diegético deliberadamente articulado**:
- **Las 9 afirmaciones canónicas de la Brecha 2.4** (declaradas en 2.4.6, *Reconstrucción honesta*) están calibradas con el mismo rigor que las 8 de la 2.3.5, y dos de ellas son experimentales:
  - **Afirmación 7** ("No se conservan fuentes producidas por los vascones de este periodo, contemporáneas o anteriores") declarada como **"Sólido (la ausencia)"** — paralela a la afirmación 6 de la Brecha 2.3 (la ausencia documental de las personas esclavizadas en la domus). La forma de calificación marca el aprendizaje del juego: la ausencia documentada **es** dato sólido, no incertidumbre.
  - **Afirmación 9** ("La reconstrucción del lado vascón tiene un techo metodológico determinado por la asimetría de las fuentes") declarada como **"Sólido como declaración metodológica"** — el aprendiz declara explícitamente el límite de su propia reconstrucción, marcando AH.03 (declaración de niveles de confianza) en su forma más madura del Arco 2.

**Voces nuevas del Concilio dividido (2.4.7)**:
- **Joana** aparece con material narrativo largo por primera vez en el juego. Su voz Anclada (doc 04) se fija aquí: pide más matices ("Sólido tirando a Probable alto" para la afirmación 8, defiende el "(la ausencia)" de la 7), no compite con Maren, busca reforzar la calibración. La voz Anclada de Joana se vio fugazmente en la 1.4.3 del Arco 1; aquí se consolida.
- **Begoña** aparece en el Concilio del Arco 2 por primera vez. Voz neutra, pide claridad sobre la afirmación 8 (¿"esta ausencia documental no es accidente" requiere matización para evitar argumento conspirativo?), recibe respuesta precisa de Maren.
- **Karim Reformista** marca su carácter explícito por primera vez con palabra de Cronista superior ("la afirmación 7 es la más importante de la Brecha. La ausencia es dato. Punto"). Coherente con el rasgo Reformista del doc 04 articulado en 2.4.5.
- **Aitor Constructor** vuelve a hacer su trabajo de presión: pide rebajar la afirmación 8 a Disputada porque "no es accidente" suena interpretativo. Maren no cede pero matiza la formulación. El desacuerdo se cierra sin consenso, registrado en el Concilio.

**Pendiente de revisión humana**:
- ¿La elección de **no nombrar el yacimiento concreto** del norte (sustitución diegética en 2.4.3) es la correcta, o el comité asesor prefiere anclar la Estación a un yacimiento real documentado (con bibliografía y limitaciones explícitas)? La elección actual es coherente con el espíritu de la Estación (el silencio del lugar es el dato), pero pierde la trazabilidad arqueológica que sí preserva el resto del Arco 2.
- ¿La calibración de la **afirmación 8** ("esta ausencia documental no es accidente: refleja la dirección desigual del poder narrativo") está bien como **Sólido**? El Concilio interno del juego ya tensiona la pregunta (Joana propone Sólido tirando a Probable alto, Aitor propone Disputada). Se ha mantenido como Sólido porque la asimetría del poder narrativo de la Antigüedad Tardía frente a las poblaciones vascónicas está bien establecida en historiografía estándar, pero el comité podría preferir Probable o Sólido (limitado a la generalización metodológica). La forma "no es accidente" es deliberadamente directa para enseñar a no rebajar afirmaciones bien fundadas por timidez.
- **Tono de Karim Reformista** en 2.4.5 cuando le dice a Maren "el silencio vascón es el dato" — primera articulación pedagógica explícita de Karim en posición casi tutorial (hasta ahora ha funcionado más como revisor de Concilio). ¿Encaja con la voz fijada en doc 04? El Reformismo se hace explícito en la frase de cierre ("¿Eso es Reformismo? — Eso es honestidad. El Reformismo es nombrar de dónde viene la ausencia").
- **Voz de Joana** consolidada — primera vez con material narrativo largo. ¿Encaja con la entrada de Joana en doc 04 o requiere ajuste?
- **Voz de Begoña** estrenada en el Concilio del Arco 2 — primera aparición jugable larga (apuntes previos cortos en doc 04). ¿Encaja con su perfil de Cronista superior cauta?
- **Línea de cierre de Maren en 2.4.7** ante el desacuerdo ("acepto el desacuerdo. La afirmación queda como Sólido en mi reconstrucción y Disputada en la lectura de Aitor") — primera vez que el aprendiz declara explícitamente que dos calibraciones distintas pueden coexistir como lectura del Concilio. El doc 14 §6.5 prescribe que el Concilio NO premia tener razón sino haber juzgado bien con lo disponible; la formulación encaja, pero el comité podría afinarla.
- **Continuidad pedagógica con la Estación 2.3**: la afirmación 7 de 2.4 ("la ausencia es dato") es paralela funcional a la afirmación 6 de 2.3 (la ausencia documental de las personas esclavizadas). ¿La repetición consciente del recurso pedagógico es la elección correcta o el comité prefiere variación? La repetición se ha hecho deliberadamente para consolidar el aprendizaje cruzado de Estaciones distintas con el mismo recurso epistémico.

**Sin sustituciones en el resto de la Estación**: 2.4.1 (encargo en el despacho de Isaura), 2.4.2 (lectura crítica de Julián de Toledo en la biblioteca del Archivo), 2.4.4 (frustración interna en la mesa de trabajo), 2.4.6 (declaración de las 9 afirmaciones), 2.4.7 (Concilio), 2.4.8 (Aprendiz II en el patio del Archivo) no nombran yacimientos concretos, dataciones específicas ni publicaciones identificables más allá de Wamba + Julián + el año 673.

---

## Estación 2.3 (domus de los mosaicos) — material diegético + sustitución por edificio del Archivo (F2-5)

**Tracker doc 17**: pendiente.

**Material diegético de la Brecha 2.3** (registro):
- **La domus subterránea** bajo el casco viejo de Iruña accesible vía galería técnica desde el sótano del Archivo es ficticia diegética del juego. Pamplona/Pompaelo tiene domus romanas documentadas en yacimientos urbanos parciales, pero la conexión galería ↔ Archivo es invención narrativa. El mosaico geométrico del s. II y la habitación durante doscientos años son verosímiles para domus hispanorromanas.
- **La familia Cornelia** (un Cornelio magistrado local con praenomen perdido, esposa con nombre incompleto, hijos no documentados, dos personas esclavizadas mencionadas como número en las cuentas) es **explícitamente ficticia diegética**. Cornelius es gentilicio común romano usado deliberadamente como dispositivo pedagógico, no como afirmación histórica sobre una familia concreta de Pompaelo.
- **Las 8 afirmaciones canónicas** reproducen la calibración del doc 08 §2.3.5 sin sustitución. La afirmación 6 (la ausencia documentada de las personas esclavizadas) calificada como **Sólido (la ausencia)** es el corazón pedagógico de la Estación.
- **"Las grietas también hablan"** — frase del pasillo de los Reformistas, ficticia del juego. Funciona como dispositivo narrativo que articula la dicotomía Tasio/Karim sobre cómo se interpreta la frase.

**Sustitución diegética aplicada**:
- 2.3.3 (la crisis): "el capitel del s. XII" → "el capitel del patio" (sin afirmar siglo). Misma sustitución que se aplica en 1.0.2 y 1.4.4, registrada en la entrada EDIFICIO-ARCHIVO de este mismo documento. La pedagogía (Maren mira algo del patio mientras procesa la crisis) se preserva sin afirmar dato arquitectónico no validado.

**Pendiente de revisión humana**:
- ¿La caracterización de la domus como ficticia diegética accesible "vía galería técnica desde el Archivo" funciona, o el comité asesor prefiere anclar la Estación a una domus real documentada (con su yacimiento, su bibliografía y sus limitaciones)? La elección actual es deliberada porque permite controlar las fuentes catalogadas con propósito pedagógico (la asimetría entre el propietario y los esclavos es matemáticamente clara), pero pierde la trazabilidad arqueológica.
- Tono de Maren en 2.3.3 (la crisis) — primera vez que la Cronista articula rabia explícita en pantalla. La frase "soy cómplice" es fuerte. ¿Encaja con la voz fijada en doc 04? Para el oficio del juego es importante que el aprendiz pueda sentir incomodidad ética en algunos casos sin que eso se trate como "fallo de profesionalidad".
- Tono de la lección de Isaura en 2.3.4 — la dicotomía neutralidad/comprensión es el mensaje pedagógico más explícito que el juego hace hasta ahora. ¿La articulación es lo bastante cuidadosa para que un aprendiz de 11-12 años la lea sin malentendido (interpretarla como permiso para juzgar todo lo histórico desde el siglo XXI)? La condición "tu valoración está fuera, la de ellos está dentro" se incluye explícitamente para acotar.
- Voz de Karim en 2.3.6 con la frase de pasillo — "la afirmación 6 es de las que me hacen tener esperanza con esta institución" es declaración política (crítica institucional desde dentro) que el juego pone en boca de un Cronista superior. ¿El comité valida esa formulación? Es coherente con el carácter Reformista de Karim (doc 04) pero merece confirmación.

**Sin sustituciones diegéticas en 2.A.1 ni 2.A.2**: Quintiliano de Calagurris y la edición de Cousin (Jean Cousin, *Quintilien — Institution oratoire*, Les Belles Lettres) son referencias reales y trazables que pasan el filtro del comité sin revisión. Marina sólo nombra términos ya validados ("inscripción", "huesos", "polen", "Aralar", "Calahorra"). La frase pedagógica clave de Antonio ("habla menos de sí mismo de lo que parece") es comentario crítico genérico, no afirmación histórica.

---

## Estación 2.2 (Calagurris) — referencias trazables y datos pendientes de validación fina (F2-3)

**Tracker doc 17**: pendiente.

**Estado**: la Estación 2.2 se implementa preservando el contenido del doc 08 §2.2.1–2.2.6 sin sustituciones globales — la pedagogía sobre fuentes textuales, omisiones y peso interpretativo cabe en información histórica establecida sobre Quintiliano de Calagurris. La voz `VozPersonaje.arqueologa` (femenina, etiqueta funcional "Arqueóloga", tinta tenue) se añade simétrica al `arqueologo` masculino del yacimiento de Irulegi — el doc 08 decide explícitamente no nombrar a la arqueóloga local de Calahorra.

**Datos preservados sin sustitución (verificables)**:
- **Quintiliano de Calagurris** (Marco Fabio Quintiliano, ~35–~100 d.C.) — biografía histórica establecida.
- **Calagurris fue navarra hasta 1076** — fecha histórica establecida (muerte de Sancho IV de Pamplona "el de Peñalén" tras la conjura de Peñalén; tras su asesinato Calahorra pasa a la Corona de Castilla bajo Alfonso VI). Pío Beltrán en su día y la historiografía riojana posterior fijan la fecha. Maren la repite con la cabeza y luego la siente — articula la pedagogía del oficio (saber un dato vs sentirlo).
- **Pasajes A-D de la *Institutio Oratoria***: I prooemium 6, II llegada a Roma, IV prefacio (dedicatoria a Vitorio Marcelo), VI prefacio (lamento por la muerte del hijo). Los cuatro pasajes son reales y bien establecidos en la edición crítica. **Vitorio Marcelo** (Victorius Marcellus, dedicatario del Libro IV) es histórico.
- **Estatua moderna en el museo de Calahorra** + sala dedicada — el museo de la Romanización en Calahorra existe; describir la sala como dedicada a Quintiliano con estatua moderna y placa es verosímil-aceptable sin afirmar contenido específico de la museografía.

**Pendiente de revisión humana**:
- ¿La fecha 1076 debe revertirse a "siglo XI" si el comité prefiere conservadurismo, o se mantiene? El doc 08 la usa como dispositivo pedagógico y la fecha está bien establecida; mantenerla sirve la pedagogía mejor. Si el comité aporta matiz historiográfico (por ejemplo, "1076 marca el cambio formal pero la transición de pertenencia identitaria fue más gradual"), se incorpora como matiz de la frase de Isaura sin tocar el dato.
- Voz de la arqueóloga de Calahorra — primera aparición con material narrativo largo. ¿El tono de "voz de territorio" (cercana, técnica pero accesible, sin protocolo del Archivo) encaja con la Bíblia de Personajes?
- Mecánica HF.10 (detección de omisiones) — debutará jugable cuando se aborde el refactor de `FaseBrecha` para Brecha 2.2 jugable (mismo bloqueo que Brecha 2.1: el modelo de 3 afirmaciones canónicas con calibración fija no encaja con 7 afirmaciones que mezclan evidencia directa e indirecta). Hoy la pedagogía se enseña narrativamente.
- Frase de Isaura "lo que fue navarro fue navarro de verdad. Lo que es riojano hoy es riojano de verdad. Las dos cosas son ciertas" — la formulación es deliberadamente no-confrontativa con identidades territoriales actuales. ¿Encaja con la postura editorial de la Colección sobre identidades sucesivas? Probable Sí, pero merece confirmación humana.

---

## Estación 2.1 — sustituciones diegéticas e inscripción ficticia (F2-1)

**Tracker doc 17**: pendiente.

**Guion canónico (doc 08 §2.1)**: la primera Brecha del Arco 2 ocurre en una galería técnica bajo la calle Curia de Iruña — restos de Pompaelo romana parcialmente excavados, plataforma con luces dirigidas, una inscripción honorífica encontrada en superficie reutilizada como pavimento. Karim Belkacem (epigrafista del Archivo, doc 08 §2.1.2, 47 años) enseña a Maren las convenciones epigráficas (líneas en mayúsculas latinas, abreviaturas IMP/CAES/AVG, fórmulas honoríficas, dedicantes individuales vs colectivos, datación por nomenclatura imperial) y la postura epistémica clave: una inscripción NO es un documento neutral, es propaganda — el productor pagó para que se viera lo que se ve.

**Estado**: implementada como cadena de 6 cinemáticas (2.1.1–2.1.6) que cubren narrativamente la pedagogía sin pantalla de Reconstrucción jugable. La Brecha 2.1 jugable real (con Mesa de Trabajo + declaración de afirmaciones con niveles de confianza sobre la inscripción) queda **pendiente** — requiere refactor del modelo `FaseBrecha` o variante específica para inscripciones (ver sección siguiente).

**Sustituciones diegéticas aplicadas en el contenido**:
- **Inscripción romana**: la inscripción que Karim enseña es **ficticia y diegética**. El bloque de texto en la cinemática 2.1.2 (`PlanoAmbiente` con la inscripción literal) es modelo literario verosímil basado en formularios honoríficos romanos genéricos, sin reproducir literalmente ninguna inscripción real catalogada en CIL II o en Hispania Epigraphica. Las abreviaturas (IMP CAES AVG, DD PP, dedicación a un princeps) son convenciones epigráficas estándar — pedagógicas, no afirmaciones de hallazgo histórico.
- **Princeps homenajeado**: el guion canónico menciona "PRINCIPS-OPTIMVS-TRAJANO" como ejemplo de fórmula honorífica reconocible (Trajano fue el primer emperador conocido como *optimus princeps*). Sustituido por una formulación genérica que mantiene la convención sin afirmar que la inscripción ficticia honra a un emperador concreto. Si el comité valida la elección de Trajano (apropiada cronológicamente para Pompaelo en el siglo II), se revierte.
- **Pompaelo bajo la calle Curia**: validado como entrada (ya aparece en 1.0.2). La galería técnica subterránea es ficticia pero arqueológicamente verosímil (Pamplona tiene yacimientos romanos parcialmente musealizados). No se afirma una visita pública concreta.
- **Referencia bibliográfica PIR (Prosopographia Imperii Romani)**: Karim la cita por su nombre canónico — herramienta epigráfica real, pública y trazable. No se inventa entrada ni cita concreta dentro del PIR.

**Pendiente de revisión humana**:
- ¿La inscripción ficticia es lo bastante verosímil para sostener la pedagogía sin inducir a malentendido (un aprendiz creyendo que es real)? Posible mitigación: añadir voz del Cuaderno aclarando que es ejemplo de Karim, no inscripción real catalogada.
- Tono de Karim — primera aparición con material narrativo largo. ¿La voz de Cronista revisor/mentor encaja con la Bíblia de Personajes (doc 04, hoy con entrada inicial para Karim como epigrafista)?
- Decisión sobre el princeps homenajeado en la inscripción ficticia. Si se quiere fijar Trajano (canónicamente apropiado), revertir la sustitución; si se prefiere ambigüedad, mantener.

**Cuando el comité valide**: se puede cambiar la inscripción ficticia por una real catalogada (con su CIL/HEp y bibliografía), o mantener la ficticia con etiqueta narrativa explícita.

---

## Karim Belkacem — color de voz pendiente de migrar a `tintaTenue`

**Tracker doc 17**: no aplica (decisión visual del juego, no contenido histórico).

**Estado**: la voz `VozPersonaje.karim` en `voz_personaje.dart` lleva hoy `colorNombre: PaletaArchivo.textoPrincipal`. Karim es **Cronista del Archivo** (epigrafista revisor, doc 08 §2.1.2), no aspirante — alinearlo con el resto de Cronistas no-mentores (Andrés `tintaTenue`) sería lo coherente con la convención de la paleta provisional: ámbar para mentores institucionales (Isaura, Begoña, Aitor, Joana), tinta tenue para Cronistas técnicos cercanos (Andrés, Karim cuando se migre), texto principal para los aspirantes (Maren, Tasio, Sira) y voces íntimas familiares (Iratxe, Antonio, Naia, Eider en `tintaTenue` por el otro motivo: entorno no-institucional).

**Por qué no se cambia ahora**: el cambio rompería el test caracterización `los tres aspirantes (Maren, Tasio, Karim) llevan tinta principal` en `voz_personaje_test.dart`, que aún asume el modelo viejo donde Karim era aspirante. Hay que migrar en un slice dedicado: actualizar el test (sacar Karim del grupo de aspirantes, añadirlo a un nuevo grupo de Cronistas técnicos), cambiar el color, regenerar la entrada del Cuaderno si menciona el color.

**Pendiente**: slice corto de migración, no urgente. Hasta entonces, la docstring de `karim` ya documenta la inconsistencia.

---

## Pantalla de Reconstrucción jugable — preparada para Arco 2 (F2-9)

**Tracker doc 17**: no aplica (decisión técnica del motor de juego).

**Estado**: la pantalla `FaseReconstruccion` (`fase_reconstruccion.dart`) ya admite Brechas con cualquier número de afirmaciones canónicas — itera sobre `widget.brecha.afirmacionesCanonicas.length` y no hardcodea 3. El refactor F2-9 retira el `static const _minimoAfirmacionesDeclaradas = 3` interno y lo sustituye por `widget.brecha.minimoAfirmacionesParaConcilio` (campo nuevo del modelo `Brecha` con default 3). Cada Brecha decide su mínimo: las del Arco 1 (1.1–1.4, 4 afirmaciones canónicas cada una) usan el default 3; las del Arco 2 con catálogos más amplios podrán pedir 5+ (2.1: 6 afirmaciones; 2.2: 7; 2.3: 8; 2.4: 9). Test caracterización añadido: una Brecha con `minimoAfirmacionesParaConcilio=5` mantiene el CTA "AL CONCILIO" bloqueado hasta declarar 5 (no las 3 del default).

**Sobre los matices de Sólido del Arco 2**:
- Las afirmaciones de la 2.3 ("Sólido (la ausencia)" para la afirmación 6 sobre las personas esclavizadas no nombradas) y de la 2.4 ("Sólido (la ausencia)" para la afirmación 7 + "Sólido como declaración metodológica" para la afirmación 9 sobre el techo de la reconstrucción) **no requieren niveles nuevos del enum** `NivelConfianza`. El matiz vive en el `texto` de la `AfirmacionCanonica` — el jugador declara `NivelConfianza.solido` que es la calibración correcta, y el matiz pedagógico ("la ausencia es información", "esto es declaración metodológica del techo") es contenido textual que la pantalla muestra sin que el motor Brier lo interprete. La calibración Brier sigue siendo 3-clase (Sólido/Probable/Disputado), preservando la paridad Dart/PHP del core.

**Pendiente para Brechas jugables del Arco 2**:
- Catálogos `brecha21`, `brecha22`, `brecha23`, `brecha24` en `CatalogoBrechas` con sus fuentes diegéticas + afirmaciones canónicas calibradas contra el doc 08 — sustituciones diegéticas explícitas para el material no validado por el comité.
- Cada catálogo declarará su `minimoAfirmacionesParaConcilio` apropiado (probablemente 4 para 2.1 con 6 afirmaciones, 5 para 2.2 con 7, 5 para 2.3 con 8, 6 para 2.4 con 9).
- Hoy la pedagogía de las cuatro Estaciones del Arco 2 se enseña narrativamente en sus cinemáticas — cubre el contenido sin la mecánica jugable.

---

## Mosaico Arco 1 v2 — sincronización con `/companion/mosaicos` (P2)

**Tracker doc 17**: no aplica (acoplamiento técnico, no contenido histórico).

**Estado**: cableado. `lib/datos/sincronizador_mosaico.dart` instancia el endpoint `POST /companion/mosaicos` del companion. El orquestador (`_alEntregarMosaicoArco1`) llama al sincronizador en segundo plano tras la entrega local — sin bloquear la cinemática 1.M1.entrega que entra justo después. Si no hay token JWT, devuelve `SyncMosaicoSinToken` sin tocar red; si hay token y el backend responde 201, devuelve `SyncMosaicoExito`; los errores HTTP/timeout/socket caen en `SyncMosaicoError`.

El payload incluye:
- `game_id = 'las-versiones'` (sembrado en `ns_games` por `class-ns-esquema.php` — plugin WP v0.9.0).
- `arc_id = MosaicoArco1.idArco`.
- `format = 'comic_8_vinetas_confianza'`.
- `required_anchors`: ids de las 7 viñetas con anclaje obligatorio (todas excepto `cromlech_dialogo_con_sira` que es relacional).
- `fulfilled_anchors`: ids de las viñetas marcadas, ordenados alfabéticamente.
- `content_meta`: mapa `idVineta → 'solido'|'probable'|'disputado'`.

**Pendiente humano**:
- Cuando llegue la pantalla de login (memoria ítem 11 de El Cuaderno — auth de profesor/cuidador no decidida), las Versiones podrá guardar el token JWT y la sincronización deja de ser silenciosa. Hoy `_urlBaseBackend = 'https://nuevoser.example.org'` en `main.dart` es provisional — cambia con la decisión del dominio definitivo.
- Tests cubren los caminos críticos (sin token, 201, 500, timeout, socket, payload vacío) pero no hay piloto end-to-end contra un Local WP — bloqueado por la auth.

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

## Cinemática 1.Z del cierre del arco — implementada en F8.8

**Tracker doc 17**: pendiente de revisión humana.

**Guion canónico (doc 07 §1.Z)**: la noche de la entrega del Mosaico. Maren en su mesa con el cuaderno, ventana al castaño con hojas amarillas (noviembre). Voz interna que cierra el arco: ha entregado el Mosaico, Andrés le ha dicho que la mayoría no se atreve a marcar roja la viñeta del banquete, Marina dice que ya es del club, ha aprendido cosas, Eider le dijo que tiene cara rara últimamente, el lunes empieza el Arco 2 (Pompaelo, debajo de la calle Curia, foro romano). "No sé qué voy a encontrar. Pero tengo ganas." Maren cierra el cuaderno, apaga la luz. Aparece "ARCO 1 — CERRADO". Continuará en Arco 2.

**Estado**: implementada en `EscenasArco1.cierreDelArco`. Se dispara automáticamente tras la cinemática 1.M1.entrega (Andrés + Marina). Al cerrarla activa `arco_1_cerrado_por_la_cronista`.

**Sustitución diegética aplicada (única)**:
- "He visto manos pintadas hace catorce mil años" → "He visto grabados en la roca de hace trece mil años — bisontes, un ciervo, un caballo". El v0.1 del guion asumía una Estación 1.3 con manos en negativo del Auriñaciense; el v0.2 reescribe la 1.3 a fauna magdaleniense grabada (~13.000 años, validado en doc 17 para la capa Cueva-Pirineo). La sustitución alinea la voz del Cuaderno con lo que Maren ha visto en el juego implementado.

**Sin más sustituciones**: las referencias a la viñeta del banquete (la del crómlech vecino, calibrada como Probable o Disputada en la Brecha 1.2 — la afirmación 4 `banquete_ritual` está calificada como Disputada en el catálogo, encajando con el "no se atreve" de Andrés), a Marina ("ya soy del club" — coherente con el aplauso fuera de protocolo en la 1.4.3), a Pompaelo bajo la calle Curia (validado en 1.0.2), y a Eider (personaje ficticio del entorno cotidiano, doc 04) se preservan literalmente.

**Pendiente de revisión humana**:
- Tono de la voz íntima del Cuaderno cerrando el arco — primera vez que el Cuaderno articula explícitamente la postura "no sé qué voy a encontrar pero tengo ganas". ¿Encaja con el oficio que el juego enseña? Funciona en clave pedagógica (curiosidad sin certeza), pero el comité podría leerlo como demasiado ligero.
- Línea final "Continuará en Arco 2 — La llegada de las palabras" — reproduce el subtítulo del Arco 2 del doc 07 v0.1, pendiente de confirmar con doc 08 cuando se aborde.

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
