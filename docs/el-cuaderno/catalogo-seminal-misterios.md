# El Cuaderno — Catálogo seminal de Misterios

> Documento de contenido.
> Versión 0.1 — primer cargamento de 19 Misterios para arranque del piloto.
> Aplicación práctica del doc 06 (pedagogía de los Misterios) y del doc 14 (prompt maestro de contenido).
> Pendiente de revisión por didacta, naturalista de campo, niño 9-13 con cuidador, y traductores eu/ca.

---

## 0. Notas sobre este catálogo

Estos 19 Misterios son el primer cargamento del catálogo. Distribución por tipo, afecto, escala y tipo de lugar siguiendo lo que el doc 06 §4 y §7 prescribe.

**Distribución alcanzada:**

| Categoría | Esperado | Logrado |
|---|---|---|
| Fenológicos | 5 | 5 (1-5) |
| Sistémicos | 5 | 5 (6-10) |
| Identificación | 4 | 4 (11-14) |
| Cuidado | 2 | 2 (15-16) |
| Paciencia y "no sé" | 2 | 2 (17-18) |
| Dolor honesto | 1 | 1 (19) |

**Por afecto:** asombro 7, curiosidad 5, perplejidad 5, paciencia 2 (incluye dolor: 1 = 5%).

**Por tipo de lugar:** todos los siete tipos del doc 05 §2 representados al menos una vez. Misterios accesibles desde ventana / balcón explícitamente etiquetados.

**Marcadores en el documento:**

- `[DATO A VERIFICAR]` señala datos científicos concretos (fechas, números, nombres de especies) que requieren verificación con fuente externa antes de cierre. La política del doc 14 §4.4: cualquier dato científico generado por Claude debe verificarse antes de aceptar. Yo (Claude) no soy fuente autoritativa.

- `TODO_EU` y `TODO_CA` señalan campos que requieren traducción por hablantes nativos con criterio terminológico naturalista. No invento.

- `[NOTA DE REDACCIÓN]` son comentarios al editor humano sobre dudas o decisiones en la redacción.

---

## Misterio 1 — Cuándo se fueron las golondrinas

```yaml
codigo: MIST.AVES.GOLONDRINAS_OTONO

pregunta_es: "¿Cuándo se fueron las golondrinas de tu barrio?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Cada año las golondrinas vuelan al sur en otoño. Se sabe que se van.
  La fecha exacta cambia según el lugar y el año, y los científicos no
  están seguros del todo de cómo deciden cuándo irse.
  ¿Las has visto este verano cerca de tu casa? ¿Cuándo dejaste de verlas?

tipo: fenologico
escala: mediana
afecto: perplejidad

estado_cientifico: mixto
detalle_estado: |
  Consenso sobre el hecho de la migración. Hipótesis activa sobre el
  mecanismo exacto de decisión.

estacion: [verano_tardio, otono]
ventana_fenologica:
  inicio: "agosto"
  fin: "octubre"
  variabilidad_por_region: alta
  nota: "[DATO A VERIFICAR] ventana exacta por región peninsular con datos de SEO"

regiones: [ES-*]
excepto: []

tipos_lugar:
  optimo: [borde_urbano_rural, rural_agricola, parque_urbano]
  funcional: [urbano_denso, ventana_balcon]
  inapropiado: [bosque_monte_cerrado]

habilidades_activadas:
  - OBS.04
  - REG.01
  - REG.04
  - CIC.01
  - CIC.02
  - HIP.01

dependencias_minimas: []

lo_que_se_sabe: |
  Las golondrinas comunes (Hirundo rustica) crían en Europa y migran al sur
  del Sahara para invernar. La salida ocurre escalonada entre agosto y
  octubre según latitud, condiciones del año, edad del ave y disponibilidad
  de insectos voladores.
  
  Lo que aún no se entiende del todo: cómo cada individuo integra las señales
  que activan la migración (longitud del día, temperatura, escasez de
  alimento, otras pistas posibles).

ilustracion_referenciada: golondrina_comun_aspecto_general

prompts_tutor: |
  - Si te confunde la golondrina con el avión común, mira la garganta:
    la golondrina la tiene roja y el avión la tiene blanca.
  - Si oyes el reclamo de una golondrina sin verla, suena como un
    chirrido corto y rápido.

notas_redaccion: |
  Misterio diseñado para ser perenne anual. Permite serie interanual desde
  el segundo año. Verificar con SEO/BirdLife los rangos exactos por región
  antes de cerrar a producción. Verificar términos exactos en eu (enara) y
  ca (oreneta).
```

---

## Misterio 2 — La primera hoja que cae

```yaml
codigo: MIST.ARBOLES.PRIMERA_HOJA_OTONO

pregunta_es: "¿Cuándo cae la primera hoja del árbol de tu calle?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Los árboles que pierden la hoja en otoño no la pierden todos a la vez.
  Algunos años las hojas caen pronto, otros más tarde. Cada árbol tiene
  su ritmo. Mira el árbol de tu calle un poco cada día. ¿Qué hoja se va
  primero? ¿Qué pasa con el árbol cuando empieza?

tipo: fenologico
escala: microescala
afecto: asombro

estado_cientifico: consenso
detalle_estado: |
  Consenso sobre la abscisión foliar y los disparadores generales
  (acortamiento del día, descenso de temperatura). La fecha exacta es local.

estacion: [otono]
ventana_fenologica:
  inicio: "septiembre tardío"
  fin: "noviembre"

regiones: [ES-*]

tipos_lugar:
  optimo: [urbano_denso, parque_urbano, rural_agricola]
  funcional: [borde_urbano_rural, ventana_balcon]
  inapropiado: []

habilidades_activadas:
  - PRE.01
  - PRE.03
  - OBS.01
  - REG.01
  - REG.04
  - CIC.01

dependencias_minimas: []

lo_que_se_sabe: |
  Los árboles de hoja caduca abscinden las hojas en otoño como respuesta a
  la disminución de la luz y la temperatura. Antes de caer, retiran nutrientes
  útiles (sobre todo nitrógeno) hacia las ramas, y eso produce los colores
  amarillos, rojos y marrones característicos. Cada especie y cada individuo
  responde con su propio ritmo.

prompts_tutor: |
  - Si quieres saber qué especie es tu árbol, mira la forma de la hoja
    y compárala con la clave de árboles de tu zona.
  - Las hojas que caen primero suelen ser las más expuestas al viento o
    las más viejas.

notas_redaccion: |
  Universal. Funciona desde balcón si se ve un árbol caduco. Si vives donde
  no hay árboles caducos (palmera, pino, encina), la app debería sugerir
  Misterio alternativo de cambio en perennes (más sutil pero existe).
```

---

## Misterio 3 — La primera flor

```yaml
codigo: MIST.PLANTAS.PRIMERA_FLOR_ANO

pregunta_es: "¿Cuál es la primera flor del año cerca de tu casa?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Aunque parezca que en invierno no hay flores, casi siempre hay alguna.
  Una almendro temprano. Una mimosa. Una hierba pequeña entre el cemento.
  Mira en cualquier rincón verde cerca de ti. ¿Cuál es la primera que ves
  florecer este año?

tipo: fenologico
escala: mediana
afecto: asombro

estado_cientifico: mixto
detalle_estado: |
  Consenso general sobre los disparadores de floración. La fecha exacta
  para tu zona y este año es local y observación tuya.

estacion: [invierno_tardio, primavera_temprana]
ventana_fenologica:
  inicio: "enero"
  fin: "abril"
  variabilidad_por_region: muy_alta

regiones: [ES-*]

tipos_lugar:
  optimo: [parque_urbano, rural_agricola, bosque_monte, borde_urbano_rural]
  funcional: [urbano_denso, ventana_balcon]
  inapropiado: []

habilidades_activadas:
  - OBS.01
  - REG.01
  - REG.04
  - CIC.01
  - TAX.08

dependencias_minimas: []

lo_que_se_sabe: |
  Las plantas con flores responden a señales ambientales (longitud del día,
  temperatura, humedad) para decidir cuándo florecer. Especies como el
  almendro y la mimosa son tempranas en zonas mediterráneas y atlánticas
  templadas; en zonas frías la floración temprana puede ser de hierbas
  como el tusilago o el narciso silvestre.
  
  [DATO A VERIFICAR] ventanas exactas por región: contrastar con calendarios
  fenológicos de Real Jardín Botánico CSIC.

prompts_tutor: |
  - Si no estás segura de si una flor está abierta del todo, mírala otra vez
    al día siguiente.
  - "Florecer" significa que la flor está abierta y se ve. Una yema cerrada
    todavía no es florecer.

notas_redaccion: |
  Universal y abierto. Funciona en mucho contextos. Si la niña está en zona
  con almendros (mediterráneo, sur), encontrará uno. En atlántica encontrará
  otra cosa (tusilago, mimosa de invierno). En urbano denso, malva o
  caléndula casi siempre.
```

---

## Misterio 4 — El silencio de las cigarras

```yaml
codigo: MIST.INSECTOS.CIGARRAS_FIN

pregunta_es: "¿Cuándo dejaron de cantar las cigarras este verano?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Las cigarras cantan los días calurosos del verano. Su canto es uno de
  los sonidos del verano. Después de un tiempo, dejan de cantar. ¿Cuándo
  dejaste de oírlas este año? Si nunca las oíste, ¿sabes si en tu zona
  hay cigarras?

tipo: fenologico
escala: mediana
afecto: perplejidad

estado_cientifico: mixto
detalle_estado: |
  Consenso sobre el ciclo vital de las cigarras. La fecha exacta de fin
  de canto en cada lugar es observación local.

estacion: [verano_tardio]
ventana_fenologica:
  inicio: "agosto"
  fin: "septiembre"

regiones: [ES-AN, ES-EX, ES-MD, ES-CM, ES-CL, ES-CT, ES-VC, ES-MU, ES-AR]
excepto: [ES-CN, ES-NW_atlantico]
nota_regiones: |
  Cigarras presentes principalmente en mediterráneo y continental cálido.
  En atlántico húmedo (Galicia, Cantábrico) prácticamente no se oyen.
  [DATO A VERIFICAR] distribución exacta de Cicada orni y Tibicen plebejus
  en la península.

tipos_lugar:
  optimo: [rural_agricola, borde_urbano_rural, bosque_monte]
  funcional: [parque_urbano, urbano_denso, ventana_balcon]
  inapropiado: [costa_ribera_norte]

habilidades_activadas:
  - OBS.05_audio
  - REG.01
  - REG.04
  - CIC.01

dependencias_minimas: []

lo_que_se_sabe: |
  Las cigarras adultas viven solo unas semanas en verano. Pasan la mayor
  parte de su vida (varios años) como ninfas bajo tierra alimentándose de
  raíces. Cuando emergen, cantan los machos para atraer a las hembras,
  se reproducen, y mueren. El canto cesa cuando termina la generación
  adulta.

prompts_tutor: |
  - Las cigarras solo cantan cuando hace bastante calor. Si oyes una pero
    el día está fresco, mírala bien — puede ser otro insecto.
  - El canto de cigarra suena continuo, como un zumbido que cambia de
    intensidad. No es como el canto entrecortado de un grillo.

notas_redaccion: |
  Misterio principalmente mediterráneo. En atlántico húmedo, sustituir por
  Misterio sobre grillos o sobre el canto del zorzal. La app debería filtrar
  por región automáticamente.
```

---

## Misterio 5 — El primer petirrojo del otoño

```yaml
codigo: MIST.AVES.PETIRROJO_LLEGADA

pregunta_es: "¿Cuándo viste el primer petirrojo este otoño?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Los petirrojos viven en parques, jardines y bordes de bosque. En invierno
  llegan más petirrojos del norte de Europa a pasar el frío en la península.
  Se ven más en otoño y en invierno. ¿Cuándo viste el primero este año?

tipo: fenologico
escala: mediana
afecto: asombro

estado_cientifico: consenso
detalle_estado: |
  Consenso sobre la migración parcial del petirrojo y la llegada de
  invernantes europeos a Iberia.

estacion: [otono, invierno]
ventana_fenologica:
  inicio: "octubre"
  fin: "diciembre"

regiones: [ES-*]

tipos_lugar:
  optimo: [parque_urbano, borde_urbano_rural, rural_agricola, bosque_monte]
  funcional: [urbano_denso, ventana_balcon]
  inapropiado: []

habilidades_activadas:
  - OBS.01
  - OBS.03
  - REG.01
  - REG.04
  - CIC.01
  - TAX.05

dependencias_minimas: []

lo_que_se_sabe: |
  El petirrojo europeo (Erithacus rubecula) es residente en gran parte de
  Iberia, pero muchos individuos del norte de Europa migran a la península
  para pasar el invierno. Esto multiplica la abundancia en otoño-invierno.
  El petirrojo es territorial — un macho defiende un trozo de jardín o
  parque donde es probable que vuelvas a verlo varias veces.

prompts_tutor: |
  - El petirrojo es pequeño, redondito, con el pecho de color naranja
    rojizo. Tiene la espalda parda y la cola corta.
  - Si ves uno, espera quieta. Suelen dejarse mirar bastante tiempo.

notas_redaccion: |
  Estación: la pregunta presupone que estamos en otoño. La app debe
  presentarlo solo en otoño-invierno; en primavera y verano, el petirrojo
  está más oculto y la pregunta no aplica.
```

---

## Misterio 6 — Las polinizadoras de tu calle

```yaml
codigo: MIST.INSECTOS.POLINIZADORES_CALLE

pregunta_es: "¿Qué insectos visitan las flores de tu calle?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Aunque sea una calle urbana, en primavera y verano hay flores: en macetas,
  en jardincillos, entre el cemento. Esas flores reciben visitas. Mira
  durante 10 minutos una flor cualquiera. ¿Quién viene? ¿Cuántos tipos
  distintos cuentas?

tipo: sistemico
escala: microescala
afecto: curiosidad

estado_cientifico: mixto
detalle_estado: |
  Consenso sobre el papel de los polinizadores. La identidad concreta de
  qué insectos visitan tu calle es observación local.

estacion: [primavera, verano, otono_temprano]
ventana_fenologica:
  inicio: "marzo"
  fin: "octubre"
  pico: "mayo-julio"

regiones: [ES-*]

tipos_lugar:
  optimo: [urbano_denso, parque_urbano, borde_urbano_rural, rural_agricola]
  funcional: [ventana_balcon]
  inapropiado: [bosque_monte_cerrado_invierno]

habilidades_activadas:
  - PRE.02
  - OBS.01
  - OBS.03
  - REG.01
  - REL.01
  - REL.03

dependencias_minimas: []

lo_que_se_sabe: |
  Los polinizadores incluyen abejas (más de 1000 especies en Iberia),
  abejorros, avispas, moscas (especialmente sírfidos), mariposas, polillas
  y algunos escarabajos. Cada flor atrae preferentemente a unos u otros
  según forma, color, olor y horario de apertura.
  
  Las flores de las calles urbanas reciben principalmente abejas domésticas
  (de colmenas cercanas), abejas solitarias pequeñas, abejorros y sírfidos.

prompts_tutor: |
  - Una mosca y un sírfido se parecen pero son distintos. El sírfido suele
    quedarse quieto en el aire (cernido), la mosca no.
  - Una abeja tiene el cuerpo peludo y patas con polen. Una avispa tiene
    el cuerpo más liso y la cintura más estrecha.

notas_redaccion: |
  Misterio típicamente "asombroso" — niños suelen sorprenderse de cuántas
  cosas distintas vienen a una sola flor en 10 minutos. Bueno como
  introducción al pensamiento relacional.
```

---

## Misterio 7 — Los líquenes de un lado y del otro

```yaml
codigo: MIST.LIQUENES.NORTE_SUR

pregunta_es: "¿Por qué hay líquenes en este lado del muro y no en el otro?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Los líquenes son manchas grises, amarillas o anaranjadas que crecen en
  muros, troncos y piedras. Si miras un muro o un tronco, suelen estar
  más en un lado que en otro. ¿Por qué? Mira a tu alrededor antes de
  proponer una hipótesis.

tipo: sistemico
escala: microescala
afecto: asombro

estado_cientifico: consenso
detalle_estado: |
  Consenso sobre la dependencia de los líquenes de la humedad y la luz.

estacion: [todo_el_anio]

regiones: [ES-*]

tipos_lugar:
  optimo: [bosque_monte, rural_agricola, parque_urbano]
  funcional: [urbano_denso, borde_urbano_rural]
  inapropiado: [zonas_alta_contaminacion_aire]

habilidades_activadas:
  - OBS.01
  - OBS.03
  - REL.01
  - REL.05
  - HAB.01
  - HAB.02
  - HIP.01
  - HIP.02

dependencias_minimas: []

lo_que_se_sabe: |
  Los líquenes son la unión simbiótica de un hongo y un alga (a veces más
  organismos). Necesitan humedad para crecer. Por eso suelen aparecer más
  en el lado norte de muros y troncos en el hemisferio norte: ese lado
  recibe menos sol directo y conserva más humedad.
  
  Los líquenes son sensibles a la contaminación del aire — su presencia
  o ausencia da pistas sobre la calidad ambiental local.

prompts_tutor: |
  - Para saber qué lado es el norte sin brújula: el sol nace por el este,
    se pone por el oeste, y al mediodía está al sur. El norte es el
    contrario del sur.
  - Si ves muchos líquenes y de muchos colores, eso suele ser buena señal
    para el aire de tu zona.

notas_redaccion: |
  Universal. Funciona en cualquier lugar con muros o troncos. Misterio
  pedagógico potente: introduce HIP.01 (formular hipótesis) y REL.05
  (simbiosis) con un fenómeno cotidiano y verificable.
```

---

## Misterio 8 — Lo que aparece después de la lluvia

```yaml
codigo: MIST.LLUVIA.QUE_APARECE

pregunta_es: "Después de llover, ¿qué seres vivos aparecen?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Después de una lluvia buena, salen seres vivos que no estaban antes.
  Caracoles, lombrices, ciertos hongos, ciertas plantas. Sal a tu sit spot
  o a un parque cuando pare de llover y mira. ¿Qué encuentras? ¿Por qué
  crees que salen ahora y no antes?

tipo: sistemico
escala: microescala
afecto: asombro

estado_cientifico: consenso
detalle_estado: |
  Consenso sobre la dependencia de muchos seres del ciclo de humedad.

estacion: [primavera, otono]

regiones: [ES-*]

tipos_lugar:
  optimo: [parque_urbano, borde_urbano_rural, rural_agricola, bosque_monte]
  funcional: [urbano_denso]
  inapropiado: [ventana_balcon_solo_interior]

habilidades_activadas:
  - PRE.01
  - OBS.01
  - OBS.05
  - REG.01
  - REL.01
  - HAB.02
  - CIC.04

dependencias_minimas: []

lo_que_se_sabe: |
  Muchos seres vivos están adaptados a salir cuando hay humedad. Los
  caracoles y babosas necesitan humedad para no deshidratarse y se mueven
  poco cuando hace sol. Las lombrices salen a la superficie cuando el
  suelo se encharca. Los hongos crecen rápido cuando hay agua disponible.
  Algunas plantas pequeñas (jaramagos, hierbas anuales) germinan después
  de las primeras lluvias del otoño.

prompts_tutor: |
  - Si vas justo después de llover, muévete despacio. Muchos seres están
    en el suelo y se aplastan fácilmente.
  - Los caracoles y babosas tienen el cuerpo muy delicado. Si los coges,
    déjalos donde estaban después de mirarlos.

notas_redaccion: |
  Bueno como Misterio recurrente: cada lluvia es una oportunidad nueva.
  Funciona casi todo el año salvo en sequía pura. Si la región está en
  sequía severa, la app puede no sugerirlo y proponer otro.
```

---

## Misterio 9 — Las hormigas eligen un árbol y no otro

```yaml
codigo: MIST.HORMIGAS.UN_ARBOL_NO_OTRO

pregunta_es: "¿Por qué hay hormigas en este árbol y no en el de al lado?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  En tu calle o en tu parque, fíjate: dos árboles parecidos, uno tiene
  hormigas subiendo y bajando, el otro no. ¿Por qué? Mira la corteza,
  el suelo, las hojas. Compara los dos durante varios días. Propón
  hipótesis y vuelve a comprobar.

tipo: sistemico
escala: microescala
afecto: perplejidad

estado_cientifico: mixto
detalle_estado: |
  Consenso sobre las razones generales de la presencia de hormigas en
  árboles (alimento, hormigas que cuidan pulgones). La razón concreta
  de tu árbol es local.

estacion: [primavera, verano, otono_temprano]

regiones: [ES-*]

tipos_lugar:
  optimo: [urbano_denso, parque_urbano, borde_urbano_rural, rural_agricola]
  funcional: [bosque_monte]
  inapropiado: [ventana_balcon]

habilidades_activadas:
  - PRE.01
  - PRE.03
  - OBS.01
  - REL.01
  - REL.02
  - HIP.01
  - HIP.02
  - HIP.03

dependencias_minimas: []

lo_que_se_sabe: |
  Las hormigas suben a los árboles principalmente por dos razones: para
  cazar otros insectos, o para "cuidar" pulgones que producen una secreción
  azucarada que ellas comen (mutualismo). Si un árbol tiene pulgones, suele
  tener hormigas.
  
  También influye dónde está el hormiguero principal — las hormigas eligen
  árboles cercanos a su nido. Y la especie del árbol importa: algunos
  producen néctar fuera de las flores que atrae hormigas.

prompts_tutor: |
  - Si ves hormigas en una rama, mira despacio si hay puntitos verdes o
    negros pequeños. Esos son pulgones. Las hormigas los cuidan.
  - Si tu hipótesis no encaja con lo que ves, no es fallo. Cámbiala.

notas_redaccion: |
  Excelente Misterio para HIP. Casi obliga a formular hipótesis y
  contrastar. La pedagogía del "no sé" tiene espacio: a veces ni el Tutor
  va a saber por qué un árbol concreto tiene hormigas y otro no.
```

---

## Misterio 10 — Los que comen abajo y los que comen arriba

```yaml
codigo: MIST.AVES.SUELO_RAMAS

pregunta_es: "¿Qué pájaros comen en el suelo y cuáles en las ramas?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Los pájaros del parque no buscan comida en el mismo sitio. Algunos andan
  por el suelo, otros se mueven por las ramas, otros vuelan a buscar bichos.
  Mira durante un rato. ¿Quién come dónde? ¿Por qué crees que cada uno
  está en un sitio?

tipo: sistemico
escala: mediana
afecto: curiosidad

estado_cientifico: consenso
detalle_estado: |
  Consenso sobre la partición de nichos en aves.

estacion: [todo_el_anio]

regiones: [ES-*]

tipos_lugar:
  optimo: [parque_urbano, borde_urbano_rural, bosque_monte, rural_agricola]
  funcional: [urbano_denso]
  inapropiado: [ventana_balcon]

habilidades_activadas:
  - PRE.01
  - PRE.02
  - OBS.01
  - OBS.03
  - REL.01
  - REL.02
  - HAB.01
  - TAX.05

dependencias_minimas: []

lo_que_se_sabe: |
  Cada especie de pájaro tiene un nicho ecológico — un modo de vida que
  incluye dónde busca alimento. Mirlos, gorriones y palomas suelen comer
  en el suelo. Carboneros, herrerillos y mosquiteros buscan en ramas y
  hojas. Vencejos y golondrinas cazan al vuelo. Esto reduce la competencia
  entre especies por la misma comida.

prompts_tutor: |
  - El mirlo es negro grande, anda dando saltitos por el suelo, busca
    bajo las hojas.
  - El carbonero es pequeño, tiene gorro negro y mejillas blancas, se
    mueve por las ramas.

notas_redaccion: |
  Vincula bien con TAX.05 (reconocer pájaros). Funciona como Misterio
  inicial para niños que aún no distinguen muchas especies — pueden
  empezar simplemente describiendo "el pájaro grande negro del suelo"
  y "el pájaro pequeño con gorro negro de la rama".
```

---

## Misterio 11 — Dos pájaros pequeños y marrones

```yaml
codigo: MIST.AVES.DOS_PEQUENOS_MARRONES

pregunta_es: "Hay dos pájaros pequeños y marrones en tu sit spot. ¿Son la misma especie?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Los pájaros pequeños y marrones son fáciles de confundir. ¿En qué te
  fijarías para saber si son la misma especie o son dos distintas? No te
  pedimos que los identifiques. Te pedimos que pienses en cómo lo sabrías.

tipo: identificacion
escala: microescala
afecto: curiosidad

estado_cientifico: consenso
detalle_estado: |
  Consenso sobre los rasgos que distinguen especies similares.

estacion: [todo_el_anio]

regiones: [ES-*]

tipos_lugar:
  optimo: [parque_urbano, borde_urbano_rural, rural_agricola, bosque_monte]
  funcional: [urbano_denso, ventana_balcon]
  inapropiado: []

habilidades_activadas:
  - OBS.03
  - OBS.07
  - TAX.01
  - TAX.02
  - HIP.06

dependencias_minimas: []

lo_que_se_sabe: |
  Los rasgos clave para distinguir aves similares son: tamaño exacto,
  color y patrón del pecho, color de las patas, forma del pico, dibujo
  de la cabeza, tipo de vuelo, comportamiento (anda, salta, trepa por
  troncos), canto, y dónde lo ves (suelo, rama, agua).
  
  Dos pájaros pequeños y marrones comunes en parques: el gorrión común
  (urbano, gregario, marrón con el pecho gris) y el chochín (más pequeño,
  cola levantada, anda por el suelo bajo arbustos).

prompts_tutor: |
  - No intentes identificarlos primero. Descríbelos primero. Tamaño,
    color, dónde están, qué hacen.
  - Si tienen comportamientos distintos (uno en el suelo, otro en una
    rama), eso ya es una pista grande.

notas_redaccion: |
  Misterio metodológico — la respuesta importante no es "son distintas
  especies", es "para saberlo me fijaría en X, Y, Z". Esto es OBS.03
  puro. Buen Misterio temprano del juego.
```

---

## Misterio 12 — Tres mariposas blancas

```yaml
codigo: MIST.MARIPOSAS.TRES_BLANCAS

pregunta_es: "Tres mariposas blancas pasan por tu jardín. ¿Cómo distinguirlas?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  En primavera y verano, varias mariposas blancas vuelan por jardines y
  prados. Parecen iguales a primera vista, pero no lo son. ¿En qué te
  fijarías para distinguirlas? Mira despacio, no las identifiques rápido.

tipo: identificacion
escala: microescala
afecto: curiosidad

estado_cientifico: consenso

estacion: [primavera, verano, otono_temprano]

regiones: [ES-*]

tipos_lugar:
  optimo: [parque_urbano, borde_urbano_rural, rural_agricola, bosque_monte]
  funcional: [urbano_denso, ventana_balcon]
  inapropiado: []

habilidades_activadas:
  - OBS.03
  - TAX.01
  - TAX.02
  - TAX.07

dependencias_minimas: []

lo_que_se_sabe: |
  Las mariposas blancas más comunes en Iberia son la blanca de la col
  (Pieris brassicae), la blanquita de la col (Pieris rapae) y la cleopatra
  (Gonepteryx cleopatra) — esta última hembra parece blanca en vuelo
  aunque al posarse muestre tonos amarillos. Otras blancas posibles
  incluyen aurora (Anthocharis cardamines) y blanquiverdosa.
  
  Para distinguirlas, fíjate en el tamaño, los puntos y bandas oscuras
  de las alas, la forma del extremo del ala, y el color del envés cuando
  se posan con las alas cerradas.

prompts_tutor: |
  - El truco es esperar a que se pose. En vuelo todas parecen iguales.
  - El envés (cara de abajo) suele ser distinto del anverso (cara de
    arriba). Por eso las mariposas posadas se ven distintas según las
    miras.

notas_redaccion: |
  Misterio metodológico también. Buena pareja con el 11 — ambos enseñan
  el oficio de la observación cuidada antes de la identificación rápida.
  [DATO A VERIFICAR] revisar nombres científicos exactos y vigentes.
```

---

## Misterio 13 — Plátano o no es plátano

```yaml
codigo: MIST.ARBOLES.PLATANO_O_NO

pregunta_es: "El árbol grande de tu calle: ¿es plátano o no es plátano?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  El plátano de sombra es uno de los árboles más comunes de las ciudades.
  Pero hay muchos árboles que se le parecen: arce, falso plátano, sicomoro.
  ¿En qué te fijarías para saber si tu árbol es plátano? Mira la corteza,
  las hojas, los frutos.

tipo: identificacion
escala: microescala
afecto: asombro

estado_cientifico: consenso

estacion: [todo_el_anio]
nota_estacion: |
  En invierno sin hojas: identificable por corteza y silueta. En primavera
  y verano: por hojas. En otoño: por hojas y frutos.

regiones: [ES-*]
nota_regiones: |
  El plátano se planta en casi todas las ciudades españolas como árbol
  ornamental.

tipos_lugar:
  optimo: [urbano_denso, parque_urbano]
  funcional: [borde_urbano_rural, ventana_balcon]
  inapropiado: [bosque_monte_natural]

habilidades_activadas:
  - OBS.01
  - OBS.03
  - TAX.01
  - TAX.03
  - TAX.04

dependencias_minimas: []

lo_que_se_sabe: |
  El plátano de sombra (Platanus x hispanica o Platanus x acerifolia) es un
  híbrido muy común en calles y parques. Lo distingues por:
  
  - Corteza que se cae a placas dejando manchas verdes, amarillas y grises.
  - Hojas grandes con 5 lóbulos puntiagudos.
  - Bolitas colgantes que son sus frutos (varias por rama, no una sola).
  
  Se confunde con el arce (Acer platanoides) que tiene hojas similares
  pero corteza lisa que no se cae a placas. Se confunde también con el
  falso plátano (Acer pseudoplatanus) que tiene hojas más simétricas y
  semillas con alas.

prompts_tutor: |
  - La corteza del plátano es muy característica. Si no se cae a placas,
    probablemente no es plátano.
  - En invierno, las bolitas colgantes que quedan son una buena pista —
    pocos árboles las tienen así.

notas_redaccion: |
  Funciona muy bien en contexto urbano. El plátano es probablemente el
  árbol que más niños españoles tienen cerca. Aprender a identificarlo
  bien es base para identificar otros.
```

---

## Misterio 14 — El pájaro que mueve la cola

```yaml
codigo: MIST.AVES.MUEVE_LA_COLA

pregunta_es: "¿Qué hace ese pájaro pequeño que mueve la cola arriba y abajo?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Cerca del agua, en parques con fuentes, en bordes de río, hay un pájaro
  pequeño que anda por el suelo moviendo la cola arriba y abajo todo el
  rato. ¿Lo has visto? ¿Por qué crees que mueve la cola así? Si no lo has
  visto, mira la próxima vez que pases por agua.

tipo: identificacion
escala: microescala
afecto: asombro

estado_cientifico: hipotesis_activa
detalle_estado: |
  Es una lavandera. Mueve la cola constantemente, eso es consenso. Pero
  por qué exactamente lo hace, los científicos tienen varias hipótesis y
  ninguna es definitiva.

estacion: [todo_el_anio]

regiones: [ES-*]

tipos_lugar:
  optimo: [parque_urbano, borde_urbano_rural, rural_agricola, costa_ribera]
  funcional: [urbano_denso]
  inapropiado: [bosque_monte_seco, ventana_balcon]

habilidades_activadas:
  - OBS.01
  - OBS.03
  - TAX.05
  - REL.01
  - HIP.01
  - HIP.04

dependencias_minimas: []

lo_que_se_sabe: |
  Es una lavandera. La lavandera blanca (Motacilla alba) es la más común
  en parques y zonas urbanas con agua, color blanco y negro. La lavandera
  cascadeña (Motacilla cinerea) tiene parte amarilla y vive cerca de aguas
  rápidas.
  
  El movimiento constante de cola se ha estudiado mucho. Hipótesis
  posibles: comunica que es vigilante a posibles depredadores ("aviso al
  gato: te he visto"), señala dominio territorial, o hace que los insectos
  se muevan y sean más visibles. Probablemente es una mezcla. La ciencia
  no está cerrada en esto.

prompts_tutor: |
  - La lavandera blanca es del tamaño de un gorrión, fácil de ver porque
    anda por el suelo en sitios abiertos.
  - Si oyes un "tsi-tsi" agudo cuando vuela, es probable que sea
    lavandera.

notas_redaccion: |
  Misterio doble: identificación clara (es una lavandera) + hipótesis
  abierta (por qué mueve la cola). Lo segundo es genuinamente abierto en
  ciencia. Excelente para enseñar HIP.04 — sostener "no sé" cuando es
  honesto.
```

---

## Misterio 15 — La flor rara junto al camino

```yaml
codigo: MIST.PLANTAS.FLOR_RARA_CAMINO

pregunta_es: "Hay una flor que solo has visto una vez. ¿Qué pasa si la coges? ¿Y si no?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  En tu sit spot o cerca, ves una flor que no habías visto antes. Solo hay
  una, o muy pocas. Te llama la atención. Piensa: si la coges, ¿qué pasa
  con la flor? ¿Y con la próxima persona que pase por aquí? ¿Y si no la
  coges? No tiene una respuesta única.

tipo: cuidado
escala: microescala
afecto: paciencia

estado_cientifico: mixto
detalle_estado: |
  Consenso sobre la importancia ecológica de la abundancia de flores
  silvestres. La decisión personal es del niño.

estacion: [primavera, verano, otono]

regiones: [ES-*]

tipos_lugar:
  optimo: [borde_urbano_rural, rural_agricola, bosque_monte, costa_ribera]
  funcional: [parque_urbano]
  inapropiado: [urbano_denso, ventana_balcon]

habilidades_activadas:
  - OBS.01
  - REL.04
  - REL.08
  - TEJ.04
  - TEJ.05
  - HIP.01

dependencias_minimas: [OBS.01]

lo_que_se_sabe: |
  Las flores silvestres producen semillas que dispersan plantas nuevas. Si
  coges una flor antes de que se forme y caiga la semilla, esa planta no
  se reproducirá ese año. Si coges muy pocas, no afectas mucho. Si coges
  muchas o todas, sí. Para algunas especies raras, una sola flor puede
  ser importante; para otras abundantes, no es relevante.
  
  En espacios protegidos o reservas naturales hay normativas que prohíben
  recoger plantas. En espacios públicos no protegidos, suele ser legal
  pero la pregunta ética sigue ahí.

prompts_tutor: |
  - Si vas a un sitio protegido (un parque natural, una reserva), suele
    estar prohibido recoger plantas. Pregunta antes de coger nada.
  - Una opción intermedia: dibuja la flor o haz una foto en lugar de
    cogerla.

notas_redaccion: |
  Misterio delicado por el riesgo de moralización. La pregunta NO tiene
  respuesta única. La app NO premia "no la cojas" ni "cógela". Lo
  importante es que el niño piense en las consecuencias. TEJ.05 (pequeño
  acto local) en su forma menos forzada.
```

---

## Misterio 16 — El nido de hormigas en el sendero

```yaml
codigo: MIST.HORMIGAS.NIDO_SENDERO

pregunta_es: "Las hormigas tienen un nido en mitad del sendero. ¿Cómo pasas?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Vas por un sendero o por la acera, y en mitad del camino las hormigas
  han hecho su nido. Hay un montículo y mucho movimiento. ¿Cómo pasas?
  ¿Qué pasa si pisas el nido? ¿Y si lo rodeas?

tipo: cuidado
escala: microescala
afecto: curiosidad

estado_cientifico: consenso

estacion: [primavera, verano]

regiones: [ES-*]

tipos_lugar:
  optimo: [rural_agricola, borde_urbano_rural, bosque_monte]
  funcional: [parque_urbano, urbano_denso]
  inapropiado: [ventana_balcon]

habilidades_activadas:
  - OBS.01
  - REL.01
  - REL.06
  - TEJ.05
  - HAB.04

dependencias_minimas: []

lo_que_se_sabe: |
  Un hormiguero puede tener entre cientos y miles de hormigas según la
  especie. El nido tiene cámaras subterráneas con huevos, larvas y reina.
  Si pisas el montículo, dañas la entrada y matas hormigas; suelen
  reconstruirla en horas o días si el daño es leve.
  
  Si hay paso de personas constante, el hormiguero suele cambiar de sitio
  o desaparecer. En zonas con poco paso, persisten años.

prompts_tutor: |
  - Si rodeas, pierdes 5 segundos. Si pisas, no recuperas las hormigas.
  - Las hormigas no son amenaza para ti casi nunca. Algunas pican, pero
    suelen dejarte si no tocas el nido.

notas_redaccion: |
  Pregunta práctica con respuesta abierta. Sin moralización: si el niño
  decide pisarlo igual, no se le penaliza, pero la pregunta queda planteada.
```

---

## Misterio 17 — La encina vieja

```yaml
codigo: MIST.ARBOLES.ENCINA_VIEJA

pregunta_es: "La encina vieja del parque: ¿de qué año es?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  En muchos parques y campos hay una encina o un árbol grande que parece
  muy viejo. Lleva más años allí que tu abuelo. ¿Cuántos? No es fácil
  saberlo. ¿Cómo lo averiguarías sin cortarlo?

tipo: paciencia
escala: anual
afecto: paciencia

estado_cientifico: consenso

estacion: [todo_el_anio]

regiones: [ES-AN, ES-EX, ES-CL, ES-CM, ES-MD, ES-VC, ES-MU, ES-AR, ES-CT]
excepto: [ES-CN, ES-NW_atlantico_humedo]
nota_regiones: |
  La encina (Quercus ilex) es ibérica mediterránea y submediterránea. En
  zonas atlánticas húmedas hay menos encinas — sustituir por roble o haya
  según contexto.

tipos_lugar:
  optimo: [rural_agricola, borde_urbano_rural, parque_urbano, bosque_monte]
  funcional: []
  inapropiado: [urbano_denso, ventana_balcon, costa_ribera]

habilidades_activadas:
  - PRE.01
  - OBS.01
  - REG.04
  - HIP.01
  - HIP.04
  - TEJ.04

dependencias_minimas: []

lo_que_se_sabe: |
  La edad exacta de un árbol vivo es difícil de saber sin cortarlo. Métodos:
  
  - Medir el perímetro del tronco a 1.30m del suelo y aplicar fórmulas
    aproximadas según la especie. Para encina ibérica, da estimaciones de
    décadas con incertidumbre alta.
  - Buscar fotografías antiguas o registros históricos del lugar.
  - Preguntar a personas mayores que recuerden el árbol cuando eran niños.
  - En casos especiales (árbol caído de muerte natural), contar anillos
    de crecimiento.
  
  Hay encinas en Iberia con cientos de años. Algunas son monumentales y
  están catalogadas. La fecha exacta de la mayoría sigue siendo
  incertidumbre legítima.

prompts_tutor: |
  - Una encina muy gruesa puede tener cientos de años. Una manera de
    saber más: pregunta a alguien mayor del pueblo o del barrio si recuerda
    el árbol.
  - Si quieres seguir el árbol durante años, anota su perímetro cada año.
    Crece despacio, pero verás los cambios.

notas_redaccion: |
  Misterio de paciencia paradigmático. No tiene respuesta cerrada.
  Funciona durante años. Combina HIP.04 (sostener "no sé") con REG.04
  (anclaje temporal a largo plazo).
```

---

## Misterio 18 — El grito raro de la noche

```yaml
codigo: MIST.NOCTURNOS.GRITO_RARO

pregunta_es: "Algunas noches de otoño se oye un grito raro. ¿Qué animal es?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  Si vives donde no hay mucho ruido, algunas noches de otoño y de invierno
  oyes sonidos que no sabes qué son. Un canto, un grito, un ladrido raro.
  ¿Cómo lo describirías? ¿Cuándo lo oyes? ¿De dónde viene?

tipo: paciencia
escala: mediana
afecto: perplejidad

estado_cientifico: consenso

estacion: [otono, invierno]

regiones: [ES-*]

tipos_lugar:
  optimo: [rural_agricola, borde_urbano_rural, bosque_monte]
  funcional: [parque_urbano, ventana_balcon]
  inapropiado: [urbano_denso_con_mucho_ruido]

habilidades_activadas:
  - PRE.01
  - PRE.02
  - OBS.04
  - OBS.05
  - REG.01
  - HIP.01
  - HIP.04

dependencias_minimas: []

lo_que_se_sabe: |
  Sonidos comunes de la noche en otoño/invierno en Iberia rural:
  
  - Lechuza común (Tyto alba): chillido agudo, áspero, breve.
  - Cárabo (Strix aluco): "uh-uh-uh-huuuu", suave.
  - Búho real (Bubo bubo): "uh-uh" muy grave.
  - Mochuelo (Athene noctua): "kiu-kiu" repetitivo.
  - Zorro: ladrido áspero, casi grito.
  - Garduña, jineta y otros mamíferos: gritos cortos, esporádicos.
  - Berreas de ciervo en celo (septiembre-octubre): bramidos largos en
    montes con ciervos.
  
  Identificarlos sin verlos requiere oír varias veces y comparar con
  grabaciones.

prompts_tutor: |
  - Si me lo describes, intento ayudarte a estrechar las posibilidades.
    ¿Era largo o corto? ¿Grave o agudo? ¿Cuántas veces?
  - Si tu sit spot está en zona con ruido, intenta oír desde una ventana
    a una hora tranquila.

notas_redaccion: |
  Misterio que puede quedar sin resolver durante meses o años. El niño
  acumula descripciones, la app sugiere candidatos, pero no fuerza la
  identificación. HIP.04 (sostener "no sé") puro.
```

---

## Misterio 19 — Las polillas de las farolas

```yaml
codigo: MIST.INSECTOS.POLILLAS_FAROLAS

pregunta_es: "¿Hay menos polillas en las farolas de tu calle que hace dos meses?"
pregunta_eu: TODO_EU
pregunta_ca: TODO_CA

descripcion_es: |
  En verano y al principio del otoño, las polillas vuelan alrededor de las
  farolas de noche. Más adelante van quedando menos. ¿Cuándo dejaste de
  ver muchas? ¿Cómo lo sabrías sin contarlas exactamente?

tipo: dolor_honesto
escala: mediana
afecto: perplejidad

estado_cientifico: mixto
detalle_estado: |
  Consenso sobre el ciclo estacional de polillas (varias generaciones al
  año, declive en otoño-invierno por razones biológicas). Hipótesis activa
  y tema científico de actualidad: el declive general de insectos en
  ambientes urbanos durante las últimas décadas.

estacion: [verano, otono]

regiones: [ES-*]

tipos_lugar:
  optimo: [urbano_denso, parque_urbano, borde_urbano_rural, ventana_balcon]
  funcional: [rural_agricola]
  inapropiado: [bosque_monte_sin_iluminacion]

habilidades_activadas:
  - PRE.01
  - PRE.03
  - OBS.01
  - REG.01
  - REG.04
  - CIC.01
  - HIP.01
  - TEJ.02
  - TEJ.03

dependencias_minimas: []

lo_que_se_sabe: |
  Las polillas son insectos nocturnos atraídos por la luz. En otoño, muchas
  especies completan su ciclo y las adultas mueren; en invierno hay muy
  pocas activas. Esto es ciclo natural — no es declive.
  
  Pero, además del ciclo natural, los estudios recientes muestran un declive
  general de insectos voladores en muchas zonas, especialmente en ambientes
  agrícolas e iluminados. Las causas son varias: insecticidas, pérdida de
  hábitat, contaminación lumínica, cambio climático. Las polillas son
  parte de ese declive.
  
  Distinguir variación natural estacional de tendencia a largo plazo
  requiere datos de varios años en el mismo sitio.

prompts_tutor: |
  - Para tener una idea, observa una farola concreta dos noches seguidas
    a la misma hora, y compara cuántas polillas hay.
  - Si tienes datos del año pasado, puedes comparar año con año. Para eso
    es importante anotar siempre en qué farola y a qué hora.

notas_redaccion: |
  Misterio del 5% de "dolor honesto". Se trata sin dramatismo. La pregunta
  abre el tema sin moralizar. La sección "lo que se sabe" reconoce el
  declive sin convertirlo en cruzada. Solo se accede a esta sección si
  el niño la pide explícitamente — el Misterio en sí es pregunta,
  observación, y registro.
  
  Este es de los Misterios más delicados. Conviene revisión específica
  por psicología infantil para que el equilibrio entre honestidad y no
  trauma porn se mantenga.
```

---

## Cierre del catálogo

Estos 19 Misterios son **el primer cargamento** del juego. Cumplen los criterios distributivos del doc 06 §4 y §7. Algunos cuentan más que otros — el 1 (golondrinas) y el 19 (polillas) son los más complejos pedagógicamente; los del 11 al 14 son metodológicos puros; el 17 (encina vieja) y el 18 (grito raro) son los de paciencia.

Para llegar al MVP completo (60-100 Misterios) se necesitan **3-4 lotes más** de redacción siguiendo el doc 14 (prompt maestro de contenido). Distribución sugerida de los siguientes lotes:

- **Lote 2** — 15 Misterios fenológicos por estación (5 por estación, completando el calendario).
- **Lote 3** — 15 Misterios sistémicos en distintos contextos (más rurales, más costeros, más urbanos).
- **Lote 4** — 15 Misterios regionales específicos (mediterráneo seco, atlántico húmedo, alta montaña, urbano metropolitano).
- **Lote 5** — 5-10 Misterios de paciencia y "no sé" adicionales.

Cada lote pasa el ciclo de verificación: didacta de Conocimiento del Medio, naturalista de campo de la región correspondiente, niño de 9-13 con cuidador, traductor eu/ca.

## Lo que falta verificar antes de cierre a producción

Lista para el editor humano:

```
[ ] Verificar todas las marcas [DATO A VERIFICAR] con fuente científica:
    - Fechas exactas de migración de golondrinas por región (SEO/BirdLife)
    - Distribución exacta de cigarras en península (Tibicen plebejus, Cicada)
    - Nombres científicos vigentes de mariposas blancas
    - Calendarios fenológicos del Real Jardín Botánico CSIC

[ ] Completar todas las traducciones TODO_EU y TODO_CA con hablantes
    nativos especializados en terminología naturalista

[ ] Revisión por didacta de Conocimiento del Medio (LOMLOE primaria)

[ ] Revisión por naturalista de campo (cada Misterio con su contexto
    regional)

[ ] Test del niño: leer cada Misterio en voz alta a niño 9-13 con cuidador,
    observar reacciones

[ ] Revisión específica del Misterio 19 (polillas) por psicología infantil
    para equilibrio entre honestidad y eco-ansiedad

[ ] Verificar que cada Misterio supera los 5 tests del doc 06 §9

[ ] Asignar ilustraciones de referencia (de la lista del doc 11 §5.2) o
    encargar nuevas si faltan
```

---

*Fin del Catálogo seminal v0.1.*

*Documento sometido a revisión humana antes de incorporación al sistema.*
