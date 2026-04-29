# El Cuaderno — Mapa de Habilidades Atómicas

> Documento pedagógico-técnico.
> Versión 0.1 — borrador para Fase 2 (aceptación pedagógica).
> Complementa la biblia (`el-cuaderno-01-biblia.md`).
> Modelo: doc 02 de Uno Roto y de Las Versiones.

---

## 1. Qué es este documento y para qué sirve

La biblia define **cómo se siente** El Cuaderno. Este documento define **qué mide y qué enseña**.

Cada componente del oficio del juego — observar, registrar, identificar, relacionar, hipotetizar — se descompone aquí en **habilidades atómicas**: unidades pedagógicas suficientemente pequeñas como para medirse de forma fiable, suficientemente significativas como para tener sentido didáctico propio. El sistema de maestría del juego opera sobre estas habilidades: son las que se mueven con la práctica, las que el Tutor IA trabaja cuando el niño se atasca, las que se agregan en la vista del aula.

En total, el MVP define **59 habilidades atómicas** organizadas en **9 dominios**. Cada una tiene un identificador único, criterios cuantificables o cualitativos de maestría, dependencias con otras habilidades, contexto de práctica y mapeo al currículum oficial (LOMLOE en el caso español, ciclos 2 y 3 de primaria).

El documento termina con un apéndice JSON que el motor de la plataforma puede consumir directamente para generar el modelo de datos del motor adaptativo.

**Esta versión 0.1 es borrador**. Está pensada para que la asesoría didáctica de Fase 2 itere sobre ella — no para entregarla cerrada al equipo técnico. Las habilidades marcadas con `[?]` son donde el proponente pide validación experta antes de cerrar.

## 2. Principios pedagógicos

### 2.1 Atomicidad real

Una habilidad atómica tiene **sentido por sí misma** y su dominio **no implica** automáticamente el dominio de otra. *"Distinguir un mirlo de un estornino"* y *"distinguir un mirlo de un mirlo capiblanco"* son dos habilidades distintas, pese a parecer cercanas: el segundo requiere atención a un detalle (la banda blanca del cuello) que el primero no.

### 2.2 Dependencias explícitas

Cada habilidad declara de qué otras habilidades depende. El sistema no presenta una habilidad al niño hasta que las dependencias están al menos en nivel "Competente". Ejemplo: *"identificar pájaros por canto"* (TAX.07) depende de *"distinguir cantos diferentes sin nombrarlos"* (OBS.04).

### 2.3 Maestría observable, no declarada

Una habilidad se considera dominada cuando el niño la **demuestra** repetidamente en contextos distintos. La maestría no se declara con un quiz: emerge del trabajo sostenido del niño. Para algunas habilidades hay precisión medible (identificación correcta contra clave); para otras hay rúbrica cualitativa (calidad de la observación); para otras hay cobertura (¿cuántas veces ha sostenido la duda en lugar de cerrarla precipitadamente?).

### 2.4 Comprensión por encima de ejecución

Las habilidades se miden en contextos que requieren **uso integrado**, no recall mecánico. *"Saber que las golondrinas migran"* no cuenta como habilidad. *"Notar que las golondrinas se han ido y registrar la fecha"* sí.

### 2.5 No linealidad controlada

Las habilidades forman un **grafo dirigido acíclico**, no una secuencia lineal. Un niño puede empezar a trabajar HIP.01 (formular pregunta) tras dominar OBS.01 + REG.01, sin necesidad de pasar por TAX. Hay múltiples caminos válidos.

### 2.6 Honestidad sobre la incertidumbre como habilidad

Esta es la diferencia más importante respecto a Uno Roto. En matemáticas, "lo correcto" tiene una definición clara. En el oficio de El Cuaderno, **sostener el "no sé"** es una habilidad legítima del oficio (HIP.04), tan importante como llegar a una respuesta. La medición lo refleja: un niño que marca confianza honestamente acumula maestría en HIP.04, aunque no llegue a "consensos" en TAX.

### 2.7 La práctica encarnada cuenta

Algunas habilidades del dominio PRE (Presencia) no se pueden medir digitalmente — la app no sabe si el niño realmente se sentó cinco minutos en silencio. Estas habilidades se miden por **proxies indirectos** (regularidad de las visitas al sit spot, calidad de las observaciones que produce, distribución temporal de las sesiones) y se anotan con humildad: el sistema declara que el indicador es indirecto.

## 3. Anatomía de una habilidad atómica

Cada habilidad declara:

```
id:                  Identificador único (DOM.NN)
nombre:              Nombre legible
dominio:             Uno de los 9 dominios
descripcion:         Qué es la habilidad (1-2 frases)
ejemplo:             Caso concreto
dependencias:        IDs de habilidades prerrequisito
contextos:           Tipos de actividad donde se ejercita
edad_introduccion:   Edad típica de presentación
edad_competente:     Edad típica de competencia
tipo_evaluacion:     precision | rubrica | cobertura | proxy | mixto
criterios_maestria:  Métricas concretas (varían según tipo)
mapeo_lomloe:        Saberes básicos LOMLOE asociados
notas_didacticas:    Para profesores y didactas
```

## 4. Niveles de maestría

Cada habilidad tiene, para cada niño, un estado en uno de estos cinco niveles:

| Nivel | Nombre | Significado |
|---|---|---|
| 0 | Inexplorada | El niño aún no se ha encontrado con esta habilidad |
| 1 | Introducida | Ha tenido contacto, primeros intentos |
| 2 | En desarrollo | Practica con éxito variable |
| 3 | Competente | La aplica con fiabilidad en contextos conocidos |
| 4 | Maestría | La aplica de forma flexible en contextos nuevos, con retención >2 estaciones |

### 4.1 Decaimiento

A diferencia de Uno Roto (donde el decaimiento es de semanas), en El Cuaderno el decaimiento es de **estaciones**: muchas habilidades del oficio son fenológicas y solo se pueden practicar en cierta época. Por tanto:

- **Maestría → Competente** si la habilidad no se ha podido ejercer en su estación natural durante un año completo.
- **Competente → En desarrollo** si pasan dos estaciones naturales sin práctica.
- **Suelo: En desarrollo**. No baja más una vez alcanzado.

Esto refleja que la pérdida real de habilidad de campo es lenta y rara, no aguda.

### 4.2 Cómo se evalúa

Cuatro tipos de evaluación según la habilidad:

- **Precisión**: para habilidades con respuesta verificable (TAX, algunas de CIC). Métrica: % de identificaciones correctas contra clave o tutor.
- **Rúbrica**: para habilidades con calidad cualitativa (OBS, REG). Métrica: rúbrica de 0-3 aplicada por el tutor IA con muestreo, validada por el equipo educativo.
- **Cobertura**: para habilidades de exposición (HAB, REL). Métrica: variedad de contextos donde la habilidad ha aparecido.
- **Proxy**: para habilidades incognoscibles directamente (PRE). Métrica: indicadores indirectos declarados explícitamente.

### 4.3 Velocidad relativa

Tiempo medio del niño para completar una observación, comparado solo con su propio histórico. **Nunca con otros niños**. La velocidad no es criterio de maestría — es metadato útil para el tutor (detectar fatiga, cambios de patrón) pero no entra en el cálculo de niveles.

## 5. Los nueve dominios

| ID | Nombre | Habilidades | Foco |
|---|---|---|---|
| **PRE** | Presencia | 4 | Habitar el lugar |
| **OBS** | Observación | 7 | Mirar y escuchar antes de interpretar |
| **REG** | Registro | 6 | Convertir observación en cuaderno |
| **TAX** | Identificación | 10 | Distinguir y clasificar |
| **REL** | Relaciones | 8 | Ver el tejido vivo |
| **CIC** | Ciclos | 7 | Notar el tiempo de la vida |
| **HAB** | Hábitats | 6 | Entender dónde y por qué |
| **HIP** | Hipótesis | 6 | Pensar como el oficio piensa |
| **TEJ** | Tejido roto y tejido vivo | 5 | Ver lo que falla y lo que persiste |

**Total: 59 habilidades**.

---

## 6. PRE — Presencia (4 habilidades)

Habilidades de habitación del lugar. Son las más difíciles de medir y las más fundamentales del oficio según el libro *La Tierra que Despierta*. Se evalúan por proxy.

### PRE.01 — Volver al sit spot regularmente

```
descripcion: El niño regresa a su sit spot con periodicidad sostenida,
             sin que la app le presione.
ejemplo:     Va al Roble Grande una vez por semana durante dos meses,
             a horas distintas, en distintas condiciones.
dependencias: ninguna
contextos:    Sit spot
edad_intro:   9
edad_compt:   10
tipo_eval:    proxy
criterios:    Visitas/mes ≥ 2 durante ≥ 3 meses; varianza horaria > 2h;
              cobertura de al menos 2 estaciones distintas.
mapeo_lomloe: CMNAT.4.B.1 (relación entorno-bienestar)
notas:        Esta es la habilidad fundacional del juego. La biblia §5.1
              le dedica sección propia. Para el cuidador es lo más visible:
              "Lucía vuelve al Roble por su cuenta".
```

### PRE.02 — Permanecer en silencio

```
descripcion: El niño es capaz de estar en su sit spot sin necesidad de
             producir nada en pantalla durante un periodo significativo.
ejemplo:     Pasa 8 minutos sin tocar la app y luego registra una sola
             observación de calidad alta.
dependencias: PRE.01
contextos:    Sit spot
edad_intro:   9
edad_compt:   11
tipo_eval:    proxy
criterios:    Sesiones donde tiempo en pantalla es <30% del tiempo total
              de visita; observaciones por sesión bajas pero rúbrica alta.
mapeo_lomloe: CMNAT.4.B.1
notas:        Indicador difícil. La hipótesis es que tiempo-pantalla bajo
              + rúbrica REG alta = presencia real. A validar en piloto.
```

### PRE.03 — Notar lo que cambia entre visitas

```
descripcion: El niño identifica diferencias entre visitas sucesivas al
             mismo lugar y las registra.
ejemplo:     "Hoy hay menos hojas que la semana pasada en la rama baja
             del roble. Y oigo un pájaro nuevo."
dependencias: PRE.01, OBS.01, REG.01
contextos:    Sit spot
edad_intro:   10
edad_compt:   11
tipo_eval:    rubrica
criterios:    >3 observaciones del tipo "comparado con la última visita..."
              en 2 estaciones consecutivas.
mapeo_lomloe: CMNAT.5.A.2 (cambios estacionales)
notas:        Es la primera "ganancia visible" del sit spot. Marca el
              momento en que el niño entiende para qué servía volver.
```

### PRE.04 — Reconocer la propia presencia como parte del lugar

```
descripcion: El niño expresa, en sus registros, que se considera parte
             del lugar en lugar de visitante de él.
ejemplo:     "Hoy el petirrojo se ha acercado a un metro mío. Antes huía."
             O en cuaderno libre: "este es mi sitio".
dependencias: PRE.01, PRE.03
contextos:    Sit spot, registros libres
edad_intro:   10
edad_compt:   12
tipo_eval:    rubrica + proxy
criterios:    Aparición de marcadores lingüísticos de pertenencia ("mi sitio",
              "los animales me", "vuelvo a casa") en al menos 3 entradas
              independientes; el sistema NO presiona ni enseña esos marcadores.
mapeo_lomloe: CMNAT.6.B.3
notas:        Habilidad la más difícil de medir y la más cercana al "recordar"
              del libro. Riesgo: medirlo puede convertirlo en performance. La
              evaluación es ligera y opcional.
```

---

## 7. OBS — Observación (7 habilidades)

Habilidades de mirar, escuchar, oler antes de interpretar. La separación entre observación y interpretación es estructural en la app.

### OBS.01 — Describir lo visto sin nombrarlo

```
descripcion: El niño puede describir un ser vivo con detalle sin asignarle
             un nombre, aceptando que la descripción es valiosa por sí.
ejemplo:     "Una mariposa amarilla con manchas oscuras, las alas rotas
             en la punta, en una flor azul."
dependencias: ninguna
contextos:    Cualquier observación
edad_intro:   9
edad_compt:   10
tipo_eval:    rubrica
criterios:    Rúbrica 0-3: 0=sin descripción, 1=salta a nombre, 2=descripción
              breve, 3=descripción rica (color, tamaño, contexto, comportamiento).
              Maestría: ≥75% observaciones en rúbrica 3 durante 2 meses.
mapeo_lomloe: CMNAT.4.A.1
notas:        Es la habilidad cuya práctica obliga estructuralmente la
              pantalla de Nueva Observación (campo "qué viste" antes que
              "crees que es"). El sistema la enseña por diseño.
```

### OBS.02 — Distinguir observación de interpretación

```
descripcion: El niño separa lo que vio de lo que cree que es.
ejemplo:     Sabe que "vi una limonera" no es lo mismo que "vi una mariposa
             amarilla con manchas oscuras y creo que es una limonera". 
             Cuando se equivoca de identificación, no contamina la observación.
dependencias: OBS.01
contextos:    Cualquier observación
edad_intro:   9
edad_compt:   11
tipo_eval:    rubrica
criterios:    Rúbrica de coherencia entre los campos "qué viste" y "crees
              que es" en sus observaciones, evaluada por tutor con muestreo.
              Maestría: las identificaciones erróneas no se "leen hacia atrás"
              modificando la descripción visual.
mapeo_lomloe: CMNAT.5.A.1
notas:        Habilidad pedagógica fundamental. Es el "no contaminar" de la
              ciencia de campo.
```

### OBS.03 — Atender al detalle relevante

```
descripcion: El niño se fija, ante el ser vivo o fenómeno, en los rasgos
             que la identificación y comprensión requieren.
ejemplo:     Ante un pájaro pequeño y marrón, se fija en pecho, cola y patas
             —no solo en color general.
dependencias: OBS.01
contextos:    Identificación, sit spot
edad_intro:   10
edad_compt:   12
tipo_eval:    rubrica
criterios:    En descripciones, presencia de los 3-4 rasgos que la clave
             del grupo taxonómico priorizaría.
mapeo_lomloe: CMNAT.5.A.1
notas:        Crece con TAX. Sin claves, la atención es difusa. Con claves,
              se dirige.
```

### OBS.04 — Distinguir cantos diferentes sin nombrarlos `[?]`

```
descripcion: El niño nota que dos cantos de pájaro son distintos antes de
             saber a qué especie corresponde cada uno.
ejemplo:     "Aquí canta uno tipo flauta, allí uno tipo silbido corto."
dependencias: ninguna
contextos:    Sit spot, paseos
edad_intro:   9
edad_compt:   11
tipo_eval:    rubrica
criterios:    Registros donde el niño consigna sonidos sin asignar especie,
              con descripción comparativa.
mapeo_lomloe: CMNAT.4.A.2
notas:        [?] Validar con didacta: ¿es razonable esperar esta habilidad
              en niño de 9-11 sin formación previa? Hipótesis del proponente:
              sí, si la app facilita el registro auditivo (botón "registrar
              sonido sin identificar").
```

### OBS.05 — Notar olores del entorno
*(ficha completa pendiente; descripción: capacidad de identificar olores naturales relevantes — tierra mojada, hojas en descomposición, flores específicas — y registrarlos.)*

### OBS.06 — Notar el cielo, el viento, la luz
*(ficha completa pendiente; descripción: registrar condiciones meteorológicas y de luz como contexto de la observación, no como tema separado.)*

### OBS.07 — Volver a mirar
*(ficha completa pendiente; descripción: cuando algo no encaja, volver a mirar antes de concluir; criterio: % de observaciones donde el niño ha hecho ≥2 visualizaciones del objeto antes del registro.)*

---

## 8. REG — Registro (6 habilidades)

Convertir observación en cuaderno. La calidad del registro determina la utilidad futura del cuaderno.

### REG.01 — Anotar lo esencial

```
descripcion: El niño produce una nota de observación que incluye qué, dónde,
             cuándo, y al menos un detalle distintivo.
ejemplo:     "Mariposa amarilla, 17:48, El Roble, en flor azul."
dependencias: OBS.01
contextos:    Cualquier observación
edad_intro:   9
edad_compt:   10
tipo_eval:    rubrica
criterios:    Rúbrica 0-3 sobre la completitud mínima. Maestría: ≥85%
              observaciones cumplen los 4 elementos.
mapeo_lomloe: CMNAT.4.B.2
notas:        El sistema fuerza estructuralmente esta habilidad — la pantalla
              de Nueva Observación tiene esos campos. La habilidad medida es
              la calidad del relleno, no su existencia.
```

### REG.02 — Dibujar de memoria reciente

```
descripcion: El niño produce un boceto rápido de algo que acaba de ver,
             aceptando que su dibujo es imperfecto y útil.
ejemplo:     Dibujo torpe de una hoja con manchas, suficiente para volver
             a reconocerla.
dependencias: OBS.03
contextos:    Sit spot, paseos
edad_intro:   9
edad_compt:   12
tipo_eval:    rubrica + cobertura
criterios:    ≥1 dibujo cada 2 estaciones; rúbrica de utilidad (0-3) media ≥2.
mapeo_lomloe: CMNAT.5.B.2 + transversal con Educación artística
notas:        El dibujo no se evalúa por calidad estética. Se evalúa por
              utilidad: ¿permite volver a reconocer lo que dibujó?
```

### REG.03 — Mapear el lugar
*(ficha completa pendiente; mapas simples del sit spot, del recorrido, del barrio.)*

### REG.04 — Anclar al tiempo y al lugar
*(ficha completa pendiente; precisión espacial y temporal de los registros más allá de "Roble Grande, hoy".)*

### REG.05 — Releer el cuaderno propio
*(ficha completa pendiente; cobertura: ¿el niño abre páginas viejas voluntariamente?)*

### REG.06 — Componer un mosaico de estación
*(ficha completa pendiente; habilidad culminante; producir la página de estación al cierre de cada trimestre.)*

---

## 9. TAX — Identificación (10 habilidades)

Distinguir y clasificar. Es donde la maestría es más medible (precisión contra clave) y por tanto donde el riesgo de gamificación tóxica es más alto. La biblia bloquea explícitamente cualquier coleccionismo.

### TAX.01 — Usar una clave dicotómica simple

```
descripcion: El niño sigue una clave de 4-6 pasos para llegar a una
             identificación, contestando cada pregunta con un sí/no.
ejemplo:     ¿Tiene plumas? Sí. ¿Más pequeño que tu mano? Sí. ¿Pecho rojo?
             Sí. → petirrojo.
dependencias: OBS.03
contextos:    Cualquier observación con identificación
edad_intro:   9
edad_compt:   11
tipo_eval:    precision
criterios:    Aciertos sobre identificaciones consultando clave: ≥80% en 20
              identificaciones consecutivas.
mapeo_lomloe: CMNAT.5.A.3 (clasificación)
notas:        El Tutor le ayuda a usar claves cuando se atasca, pero no le da
              la respuesta.
```

### TAX.02 — Distinguir especies parecidas
*(ficha pendiente; subtipos: aves passeriformes, mariposas blancas, plantas con flores amarillas. Edad competente 11-12.)*

### TAX.03 — Reconocer árboles del lugar por hoja
*(ficha pendiente; mínimo 6-8 árboles del territorio del niño.)*

### TAX.04 — Reconocer árboles del lugar por silueta o corteza
*(ficha pendiente; sigue a TAX.03.)*

### TAX.05 — Reconocer 5-10 pájaros locales por aspecto
*(ficha pendiente; localización-dependiente.)*

### TAX.06 — Reconocer 3-5 pájaros locales por canto
*(ficha pendiente; depende de OBS.04.)*

### TAX.07 — Reconocer mariposas comunes del lugar
*(ficha pendiente.)*

### TAX.08 — Reconocer flores silvestres por mes
*(ficha pendiente; integra con CIC.)*

### TAX.09 — Aceptar la identificación como hipótesis
```
descripcion: El niño marca con honestidad el nivel de confianza de cada
             identificación, y NO marca consenso cuando solo tiene su
             intuición.
ejemplo:     "Creo que es una limonera, hipótesis activa" en lugar de
             "es una limonera".
dependencias: TAX.01, HIP.04
contextos:    Cualquier identificación
edad_intro:   9
edad_compt:   11
tipo_eval:    rubrica + proxy
criterios:    Distribución de niveles de confianza coherente con la dificultad
              real de cada identificación. Validación cruzada con tutor.
mapeo_lomloe: CMNAT.5.A.4 (incertidumbre en ciencia)
notas:        Habilidad clave del oficio. Si no se cultiva, todo el sistema
              se cae.
```

### TAX.10 — No identificar es respuesta válida
*(ficha pendiente; habilidad de la humildad de campo.)*

---

## 10. REL — Relaciones (8 habilidades)

Ver el tejido vivo. Encarnación operativa del pensamiento relacional del libro.

### REL.01 — Notar quién está con quién

```
descripcion: El niño registra qué seres vivos aparecen juntos en su lugar,
             sin interpretar todavía la relación.
ejemplo:     "Las hormigas pequeñas siempre están en este árbol, no en el
             de al lado. ¿Por qué?"
dependencias: PRE.03, OBS.01
contextos:    Sit spot, observaciones
edad_intro:   10
edad_compt:   11
tipo_eval:    cobertura
criterios:    ≥5 observaciones con co-ocurrencia explícita registrada en
              2 estaciones distintas.
mapeo_lomloe: CMNAT.5.B.1 (ecosistemas)
notas:        Es la entrada al pensamiento relacional. Va antes que entender
              la relación.
```

### REL.02 — Identificar relación de alimentación
*(ficha pendiente; "X come a Y", "Z polinizada por W". Edad competente 11.)*

### REL.03 — Identificar polinización
*(ficha pendiente; subtipo de REL.02 con peso propio por su importancia ecológica.)*

### REL.04 — Identificar dispersión de semillas
*(ficha pendiente.)*

### REL.05 — Identificar simbiosis simple
*(ficha pendiente; líquenes como ejemplo arquetípico.)*

### REL.06 — Notar competencia entre seres
*(ficha pendiente.)*

### REL.07 — Construir red trófica de mi sit spot
*(ficha pendiente; habilidad culminante; el niño compone una red de quien come a quien en su lugar a partir de sus observaciones, sin que la app le dé la red prefabricada.)*

### REL.08 — Una pieza afecta a las otras
```
descripcion: El niño formula que un cambio en un ser vivo afecta a otros del
             tejido, sin necesariamente predecir cuáles.
ejemplo:     "Si no hay flores azules, ¿qué pasa con las mariposas amarillas?"
dependencias: REL.01, REL.07
contextos:    Misterios, registros libres
edad_intro:   11
edad_compt:   13
tipo_eval:    rubrica
criterios:    Aparición de razonamientos en cadena en al menos 3 observaciones
              o entradas libres por estación.
mapeo_lomloe: CMNAT.6.B.1
notas:        Encarnación pedagógica directa del pensamiento relacional del
              libro. La habilidad NO requiere predecir las consecuencias —
              requiere notar que las hay.
```

---

## 11. CIC — Ciclos (7 habilidades)

Notar el tiempo de la vida. Solo se practica plenamente con un año completo de juego.

### CIC.01 — Notar cambios estacionales en mi lugar
```
descripcion: El niño registra los marcadores estacionales de su sit spot.
ejemplo:     Primera hoja amarilla del roble; primer canto de cuco; primer
             día con escarcha.
dependencias: PRE.03
contextos:    Sit spot
edad_intro:   9
edad_compt:   11
tipo_eval:    cobertura
criterios:    ≥1 marcador por estación durante 2 estaciones consecutivas.
mapeo_lomloe: CMNAT.4.A.2
notas:        La fenología es la materia central de este dominio. Crece sola
              con la práctica del sit spot.
```

### CIC.02 — Predecir lo que vendrá pronto
```
descripcion: El niño formula expectativas sobre próximos eventos del año
             basándose en sus observaciones del año anterior.
ejemplo:     "El año pasado las cigüeñas llegaron el 16 de febrero. Espero
             que lleguen pronto." (Y registra cuándo llegan realmente.)
dependencias: CIC.01, REG.05
contextos:    Sit spot, registros libres
edad_intro:   10
edad_compt:   12
tipo_eval:    cobertura + rubrica
criterios:    ≥2 predicciones explícitas por estación, con registro del
              cumplimiento.
mapeo_lomloe: CMNAT.5.A.2, CMNAT.5.A.4
notas:        Solo emerge a partir del segundo año de juego. Es la "recompensa"
              estructural de la persistencia.
```

### CIC.03 a CIC.07
*(fichas pendientes: ciclo del agua local; ciclo de la materia orgánica observable; ciclos lunares y mareas si aplica; ciclo vital de un ser vivo seguido durante meses; ciclos antrópicos del barrio (siegas, podas, recogidas).)*

---

## 12. HAB — Hábitats (6 habilidades)

Entender dónde y por qué.

### HAB.01 — Notar microhábitats

```
descripcion: El niño distingue zonas distintas dentro de su lugar (umbría
             vs solana, suelo seco vs charca, tronco viejo vs tronco joven)
             y nota qué seres vivos prefieren cada una.
ejemplo:     "Los musgos crecen en el lado norte del tronco. Los líquenes
             en el sur."
dependencias: OBS.03, REL.01
contextos:    Sit spot
edad_intro:   10
edad_compt:   12
tipo_eval:    rubrica
criterios:    ≥3 microhábitats reconocidos en su sit spot con asociaciones
              registradas.
mapeo_lomloe: CMNAT.5.B.1
notas:        Habilidad accesible incluso en sit spots urbanos pobres.
```

### HAB.02 a HAB.06
*(fichas pendientes: gradientes (humedad, luz, temperatura); bordes y transiciones; hábitats antrópicos vs naturales; especies sinantrópicas; hábitats raros del territorio.)*

---

## 13. HIP — Hipótesis (6 habilidades)

Pensar como el oficio piensa. Es donde se cultiva la postura intelectual del libro.

### HIP.01 — Formular pregunta a partir de observación

```
descripcion: El niño convierte una observación en pregunta abierta.
ejemplo:     Observación: "Hoy hay menos mariposas que la semana pasada."
             Pregunta: "¿Por qué hay menos? ¿Es por el frío, por la lluvia,
             porque ya no hay flores?"
dependencias: OBS.01, REG.01
contextos:    Misterios, registros libres
edad_intro:   10
edad_compt:   12
tipo_eval:    cobertura + rubrica
criterios:    ≥1 pregunta nueva propia anclada a observación por mes.
mapeo_lomloe: CMNAT.5.A.4
notas:        Sin esto, los Misterios se quedan en lectura pasiva. Con esto,
              el niño empieza a generar Misterios propios.
```

### HIP.02 — Proponer hipótesis múltiples
*(ficha pendiente; "puede ser por A, B o C" en lugar de cerrar en una.)*

### HIP.03 — Elegir cómo contrastar
*(ficha pendiente; "para saberlo, podría observar X, Y o Z".)*

### HIP.04 — Sostener "no lo sé" sin cerrar precipitadamente

```
descripcion: El niño es capaz de mantener una pregunta abierta durante
             semanas o meses sin convertir su intuición provisional en
             respuesta cerrada.
ejemplo:     Mantiene un Misterio en estado "hipótesis activa" durante 3
             estaciones, acumulando evidencia, sin marcarlo como consenso
             hasta que la evidencia lo justifica.
dependencias: HIP.01
contextos:    Misterios
edad_intro:   10
edad_compt:   13
tipo_eval:    proxy
criterios:    Tiempo medio de Misterios en hipótesis activa coherente con
              la dificultad real (NO premiar cerrar rápido; NO premiar
              prolongar indefinidamente).
mapeo_lomloe: CMNAT.5.A.4
notas:        Habilidad central del oficio según el libro. La rúbrica de
              maestría es delicada — fácil de medir mal.
```

### HIP.05 — Cambiar de opinión ante nueva evidencia
*(ficha pendiente; criterio: ¿el niño marca "abandonado" en alguna hipótesis suya cuando aparece evidencia que la refuta?)*

### HIP.06 — Distinguir mi confianza del consenso científico
*(ficha pendiente; criterio: el niño consulta al tutor "¿qué sabe la ciencia de esto?" como paso separado de "¿qué creo yo?".)*

---

## 14. TEJ — Tejido roto y tejido vivo (5 habilidades)

Ver lo que falla y lo que persiste. Equivalente del dominio "Conservación" pero replanteado para evitar moralización (criterio §2.7).

### TEJ.01 — Notar especies sinantrópicas

```
descripcion: El niño reconoce que algunas especies viven con humanos
             (palomas, gorriones, ratas, ailanto, hierbas de cunetas)
             y las trata como ciudadanas legítimas del tejido, no como
             "menos naturales".
ejemplo:     Registra una paloma con la misma seriedad que un mirlo.
dependencias: TAX.05
contextos:    Cualquier observación
edad_intro:   9
edad_compt:   11
tipo_eval:    cobertura
criterios:    Distribución de especies registradas que NO discrimina contra
              sinantrópicas; rúbrica de la voz del cuaderno frente a ellas.
mapeo_lomloe: CMNAT.5.B.3
notas:        Habilidad importante para niños urbanos. Sin ella, el oficio
              se convierte en privilegio rural.
```

### TEJ.02 — Notar lo que falta
*(ficha pendiente; criterio: ¿el niño registra ausencias, no solo presencias? "Este año no hay golondrinas en la plaza.")*

### TEJ.03 — Notar variación natural vs cambio sostenido
*(ficha pendiente; criterio difícil: distinguir un mal año de una tendencia. Edad competente 12-13.)*

### TEJ.04 — Honrar lo que sigue vivo
*(ficha pendiente; criterio cualitativo: aparición de gratitud explícita o implícita en el cuaderno frente a lo que persiste. Difícil de medir sin moralizar.)*

### TEJ.05 — Pequeño acto local
*(ficha pendiente y la más delicada del documento. Posible: el niño actúa sobre algo en su lugar — no recoger una flor rara, dejar que algo crezca, contar a alguien lo que ha visto. La acción NO se gamifica. Validar con didacta si esta habilidad debe existir o se desliza hacia la cruzada ecologista que la biblia prohíbe.)*

---

## 15. Mapeo a rangos de uso

El motor adaptativo presenta habilidades al niño en función de:

- **Dependencias cumplidas** (todas las prerrequisito en ≥ Competente).
- **Estación adecuada** (no presentar CIC.01 si el niño juega en febrero y la habilidad requiere observación de primavera).
- **Lugar adecuado** (no presentar TAX.05 sobre aves marinas a un niño del interior peninsular).
- **Saturación** (no más de 8 habilidades en estado "En desarrollo" simultáneo, para no sobrecargar).

## 16. Mapeo LOMLOE

Mapeo entre habilidades atómicas y bloques de saberes básicos del Real Decreto 157/2022 (LOMLOE primaria), área de Conocimiento del Medio Natural, Social y Cultural:

| Bloque LOMLOE | Habilidades atómicas asociadas |
|---|---|
| **A. Cultura científica** (4º) | OBS.01, OBS.02, OBS.04, REG.01, REG.02, CIC.01 |
| **A. Cultura científica** (5º) | TAX.01, TAX.09, HIP.01, OBS.03 |
| **A. Cultura científica** (6º) | TAX.02, HIP.02, HIP.04, REL.07, CIC.02 |
| **B. Tecnología y digitalización** (5º-6º) | REG.04, REG.05 (uso del cuaderno digital con criterio) |
| **C. Sociedades y territorios** (no aplica directamente) | — |

Mapeos para currículos de Euskadi (Heziberri 2030) y Catalunya pendientes de revisión por didacta local.

## 17. Modelo matemático de maestría — perfil P5 propuesto

El motor adaptativo `nuevo-ser-core` tiene perfiles de medición P1 (Uno Roto, precisión ponderada) y P2-P4 (Las Versiones). Para El Cuaderno se propone un quinto perfil **P5 — perfil compuesto** que combina:

- **Componente de precisión** (peso 0.3): aciertos en TAX y CIC contra clave/calendario.
- **Componente de rúbrica** (peso 0.4): calidad cualitativa en OBS y REG, evaluada por tutor con muestreo, validada por equipo educativo.
- **Componente de cobertura** (peso 0.2): variedad de contextos en HAB, REL, TEJ.
- **Componente de proxy** (peso 0.1): indicadores indirectos en PRE.

Cada habilidad declara qué componente(s) usa. El motor agrega y produce el nivel 0-4.

```
nivel(habilidad, niño) = f(componentes_aplicables, criterios_específicos)
```

Implementación detallada pendiente para Fase 3 (revisión técnica). Lo que hay que validar en Fase 2: que el modelo es coherente con la pedagogía declarada y que ningún componente puede gamificarse para subir de nivel sin oficio real.

## 18. Tutor IA y habilidades atómicas

El Tutor IA (`04-voces-y-figuras.md` §3) tiene visibilidad parcial del estado de habilidades del niño. Sabe:

- Qué habilidades están en juego activo.
- Qué dependencias falta cubrir.
- Qué Misterios el niño está siguiendo.

No sabe:

- El estado emocional o cognitivo del niño.
- Su historial detallado.
- Su comparación con otros niños.

Con esa información, el Tutor:

- **Adapta la profundidad** de su respuesta al nivel actual del niño en la habilidad relevante.
- **Sugiere claves** apropiadas a su capacidad (no claves expertas a un nivel 1).
- **Detecta atascos** y propone caminos alternativos cuando una habilidad se estanca.

El Tutor **nunca** dice al niño en qué nivel está. La maestría es observable, no declarada (§2.3).

---

## Apéndice A — Lista completa de IDs

```
PRE.01 — Volver al sit spot regularmente
PRE.02 — Permanecer en silencio
PRE.03 — Notar lo que cambia entre visitas
PRE.04 — Reconocer la propia presencia como parte del lugar

OBS.01 — Describir lo visto sin nombrarlo
OBS.02 — Distinguir observación de interpretación
OBS.03 — Atender al detalle relevante
OBS.04 — Distinguir cantos diferentes sin nombrarlos
OBS.05 — Notar olores del entorno
OBS.06 — Notar el cielo, el viento, la luz
OBS.07 — Volver a mirar

REG.01 — Anotar lo esencial
REG.02 — Dibujar de memoria reciente
REG.03 — Mapear el lugar
REG.04 — Anclar al tiempo y al lugar
REG.05 — Releer el cuaderno propio
REG.06 — Componer un mosaico de estación

TAX.01 — Usar una clave dicotómica simple
TAX.02 — Distinguir especies parecidas
TAX.03 — Reconocer árboles del lugar por hoja
TAX.04 — Reconocer árboles por silueta o corteza
TAX.05 — Reconocer 5-10 pájaros locales por aspecto
TAX.06 — Reconocer 3-5 pájaros locales por canto
TAX.07 — Reconocer mariposas comunes del lugar
TAX.08 — Reconocer flores silvestres por mes
TAX.09 — Aceptar la identificación como hipótesis
TAX.10 — No identificar es respuesta válida

REL.01 — Notar quién está con quién
REL.02 — Identificar relación de alimentación
REL.03 — Identificar polinización
REL.04 — Identificar dispersión de semillas
REL.05 — Identificar simbiosis simple
REL.06 — Notar competencia entre seres
REL.07 — Construir red trófica de mi sit spot
REL.08 — Una pieza afecta a las otras

CIC.01 — Notar cambios estacionales en mi lugar
CIC.02 — Predecir lo que vendrá pronto
CIC.03 — Ciclo del agua local
CIC.04 — Ciclo de la materia orgánica observable
CIC.05 — Ciclos lunares y mareas (cuando aplique)
CIC.06 — Ciclo vital de un ser vivo seguido
CIC.07 — Ciclos antrópicos del barrio

HAB.01 — Notar microhábitats
HAB.02 — Notar gradientes ambientales
HAB.03 — Bordes y transiciones
HAB.04 — Hábitats antrópicos vs naturales
HAB.05 — Especies sinantrópicas en su hábitat
HAB.06 — Hábitats raros del territorio

HIP.01 — Formular pregunta a partir de observación
HIP.02 — Proponer hipótesis múltiples
HIP.03 — Elegir cómo contrastar
HIP.04 — Sostener "no lo sé" sin cerrar precipitadamente
HIP.05 — Cambiar de opinión ante nueva evidencia
HIP.06 — Distinguir mi confianza del consenso científico

TEJ.01 — Notar especies sinantrópicas
TEJ.02 — Notar lo que falta
TEJ.03 — Notar variación natural vs cambio sostenido
TEJ.04 — Honrar lo que sigue vivo
TEJ.05 — Pequeño acto local [validación pendiente]
```

**Total: 59 habilidades.**

Apéndice B (JSON maestro consumible por el motor adaptativo) y Apéndice C (rúbricas detalladas para el tutor IA y para evaluadores humanos) pendientes para Fase 2 cerrada.

---

*Fin del Mapa de Habilidades Atómicas v0.1.*

*Documento sometido a revisión didáctica conforme al §8 Fase 2 de los criterios de integración.*
