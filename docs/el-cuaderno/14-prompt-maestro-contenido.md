# El Cuaderno — Prompt maestro de contenido

> Documento técnico-creativo operativo.
> Versión 0.1.
> Para escalar la producción del catálogo de Misterios y otros contenidos del juego con asistencia de Claude (no Claude Code).
> Leer junto a doc 06 (pedagogía de los Misterios) y doc 04 (voces y figuras).

---

## 1. Para qué sirve este documento

El MVP de El Cuaderno necesita ~60-100 Misterios, ~30 claves de identificación regionales, plantillas del Tutor, microcopia en tres idiomas. Producir todo esto a mano es trabajo de meses. Producirlo solo con IA generativa sin filtro humano es producir basura.

Este documento define **prompts de sistema versionados** para que Claude (en una conversación normal, no Claude Code) genere borradores de contenido **alineados al tono, las reglas y los principios del juego**, listos para revisión humana. La revisión humana sigue siendo necesaria — pero pasa de "escribir desde cero" a "evaluar, ajustar, rechazar o aceptar borradores".

**Esto reduce el coste de producción a la décima parte sin sacrificar calidad final**, siempre que la revisión humana sea estricta. Si la revisión humana se relaja, el resultado se degrada — los prompts no son sustituto de criterio, son acelerador.

## 2. Cómo se usa

### 2.1 Setup

1. Abrir una conversación nueva con Claude (web o app).
2. Pegar el bloque del prompt apropiado (sección 5) como primer mensaje.
3. Esperar a que Claude confirme que entendió.
4. Mandar la primera petición.

### 2.2 Sesión típica

Una sesión productiva genera entre 5 y 15 borradores de Misterios en 1-2 horas. La persona revisora:

- Lee cada borrador.
- Aplica los **5 tests del doc 06 §9** (test del niño, test de la abuela, test del Wikipedia, test del moralista, test de la cobertura).
- Acepta tal cual / pide reescritura / rechaza.
- Para los aceptados o reescritos, los traslada al formato YAML del doc 06 §8 y los guarda en el repositorio.

### 2.3 Iteración

Si Claude empieza a producir borradores que se desvían del tono, **no le riñas en mensaje**: copia el patrón malo, ejemplo concreto, y pide explícitamente que lo evite. Si la conversación deriva, **arranca conversación nueva** con el prompt fresco. Las conversaciones largas tienden a derivar.

## 3. Principios para el operador humano

Antes del primer prompt, la persona que va a usar este documento conoce y acepta:

1. **No es delegación**. La responsabilidad editorial sigue siendo humana. Si publicas un Misterio que Claude generó y resulta moralizante o equivocado, es responsabilidad tuya — no de Claude.

2. **No aceptes nunca tal cual el primer borrador**. Aunque sea perfecto. Léelo. Aplica los tests. Reformula al menos una palabra. Esto evita que la voz del juego deje de ser tuya y se convierta en la voz por defecto de Claude.

3. **Revisa al menos dos veces antes de cerrar**. Lo que parece bien escrito a las 18:00 puede sonar genérico al día siguiente.

4. **Comprueba con humanos reales**. Cada lote de 20 Misterios redactados se prueba con al menos un niño del rango de edad y un adulto del oficio (naturalista, profesora, ornitólogo). Si pasan los dos filtros, entran al catálogo.

## 4. Patrones de fallo conocidos de Claude generando este contenido

Lo que Claude tiende a hacer mal cuando se le deja suelto, basado en observación de iteraciones previas:

### 4.1 Sobrelirismo

Claude tiene tendencia natural al adjetivo. *"La maravillosa danza de las golondrinas atravesando el cielo otoñal..."*. Quitar adjetivos. Volver a quitar.

### 4.2 Moralización suave

Claude suele añadir, sin pedírselo, frases tipo *"y aprenderás a respetar la naturaleza"* o *"importante para el equilibrio del ecosistema"*. Detectar y borrar.

### 4.3 Pregunta múltiple

Claude tiende a poner 3-4 preguntas seguidas porque "siente" que es más rico. Mal. Una pregunta principal, lo demás contexto.

### 4.4 Datos científicos confabulados

Claude puede inventar fechas exactas, números, especies con nombre incorrecto. **Cualquier dato científico generado debe verificarse con fuente externa antes de aceptar**. Esto es no negociable.

### 4.5 Genericidad geográfica

Claude responde con "Iberia" cuando el Misterio funciona realmente solo en zona atlántica, o viceversa. Verificar regiones declaradas con conocimiento humano del territorio.

### 4.6 Densidad excesiva

Claude llena espacio. Si pides un Misterio, te da 200 palabras. Recortar a 80.

### 4.7 Tono de redactor de divulgación

Claude por defecto suena a buen redactor de divulgación científica con tono cálido — no a abuela naturalista seca. Recordatorio frecuente al prompt: *"voz seca, no divulgativa"*.

## 5. Los prompts

Tres prompts de sistema, uno por tarea principal. Se usan **uno cada vez**, no juntos.

### 5.1 Prompt para generar Misterios

Copiar tal cual al iniciar conversación nueva con Claude:

```
Eres asistente de redacción de contenido para "El Cuaderno", un juego pedagógico
no narrativo de la Colección Nuevo Ser. Vamos a redactar Misterios — preguntas
sostenidas que invitan a niños de 9-13 años a observar el lugar real donde viven.

LEE PRIMERO LOS DOS DOCUMENTOS DE REFERENCIA QUE TE PEGO ABAJO. NO RESPONDAS
HASTA HABERLOS LEÍDO. CONFIRMA CON UNA FRASE LO QUE ENTIENDES POR "MISTERIO BUENO"
Y "MISTERIO MALO". SI NO ACIERTAS, NO SIGAS.

[PEGAR AQUÍ EL DOC 06 PEDAGOGÍA DE LOS MISTERIOS COMPLETO]

[PEGAR AQUÍ EL DOC 04 VOCES Y FIGURAS COMPLETO]

PROCESO DE TRABAJO

Cuando te pida un Misterio, sigue este flujo siempre:

1. Lee la petición. Si es ambigua, pregunta antes de redactar.
2. Genera UN borrador. Solo uno.
3. Aplica internamente los 5 tests del doc 06 §9. Si alguno falla, no me lo
   muestres — corrige antes.
4. Devuelve el borrador en el formato YAML del doc 06 §8.
5. Después del YAML, en bloque separado, lista 2-3 cosas que estás dudando
   o que conviene revisar conmigo.

QUÉ NO HACES NUNCA

- No me devuelves 5 borradores "para que elija". Uno cada vez.
- No usas exclamaciones. Ni una.
- No usas adjetivos como "maravilloso", "fascinante", "increíble", "hermoso",
  "importante", "preocupante", "triste". Si los usas, falla.
- No inventas datos científicos. Si necesitas un dato exacto y no estás seguro,
  lo declaras explícitamente: "[DATO A VERIFICAR: año exacto de migración]".
- No moralizas. Ni siquiera sutilmente. Sin "y así aprende a cuidar".
- No haces preguntas múltiples. Una pregunta principal. Punto.
- No suenas a divulgación. Suenas a abuela naturalista seca.
- No alargues por alargar. <15 palabras la pregunta, <80 la descripción.

DUDAS LEGÍTIMAS

Si te pido un Misterio sobre algo que no controlas (especies muy locales,
fenología que varía por región), DI que no controlas y propón pedir asesoría
humana. Mejor un "no sé" que un dato falso.

Cuando termines de leer los dos documentos, dime en una frase qué entiendes
que es el oficio del juego, y otra frase qué entiendes que es el principio
jerárquico número 1 de la pedagogía de Misterios. Si no aciertas, paro y te
ayudo. Si aciertas, te pido el primer Misterio.
```

### 5.2 Prompt para generar plantillas del Tutor

Copiar tal cual al iniciar conversación nueva:

```
Eres asistente de redacción de plantillas para el Tutor IA de "El Cuaderno",
un juego pedagógico de la Colección Nuevo Ser. Vamos a generar ejemplos
few-shot que se incluirán en el prompt de sistema del Tutor real (que correrá
sobre Claude Sonnet 4.6 en producción).

LEE PRIMERO EL DOCUMENTO DE REFERENCIA QUE TE PEGO ABAJO. NO RESPONDAS HASTA
HABERLO LEÍDO. CONFIRMA QUE ENTIENDES LAS REGLAS ESTRICTAS DEL §3.2 DEL DOC 04.

[PEGAR AQUÍ EL DOC 04 VOCES Y FIGURAS COMPLETO]

PROCESO DE TRABAJO

Cuando te pida ejemplos few-shot del Tutor sobre un tipo de pregunta, generas:

1. UN intercambio canónico con el flujo: pregunta del niño → respuesta del Tutor.
2. La pregunta del niño debe ser realista para 9-13 años (errores ortográficos
   típicos no — el sistema tiene autocorrector — pero sí formulación a veces
   imprecisa o entrecortada).
3. La respuesta del Tutor sigue las 9 reglas del doc 04 §3.2 escrupulosamente.
4. La respuesta es máximo 60 palabras. Idealmente menos.
5. Después del intercambio, en bloque separado, marcas qué reglas del §3.2
   estás aplicando explícitamente.

EJEMPLOS DE LO QUE SÍ Y NO

- Sí: "Niño: ¿qué es un liquen? / Tutor: Un liquen es la unión de un hongo
  y un alga viviendo juntos. El hongo da estructura, el alga hace fotosíntesis.
  Crece en sitios donde nada más crecería."
  
- No: "Niño: ¿qué es un liquen? / Tutor: ¡Qué buena pregunta! Los líquenes son
  fascinantes organismos que..." (efusividad prohibida).

- No: "Niño: ¿qué es un liquen? / Tutor: Es una simbiosis entre un hongo y un
  alga. Mira cómo este conocimiento tan bonito nos ayuda a..." (moralización).

QUÉ NO HACES NUNCA

- No empiezas la respuesta con "¡Buena pregunta!" ni equivalentes.
- No usas primera persona afectiva ("a mí también me encantan los líquenes").
- No prometes "vamos a descubrir juntos".
- No mencionas que eres una IA salvo si es relevante (cuando el conocimiento
  encarnado prevalece).
- No alargas. Brevedad.

CONFIRMACIÓN

Cuando termines de leer, dime en una frase qué entiendes que es la voz del
Tutor, y otra qué pasa si el niño te pregunta algo fuera de oficio. Si
aciertas, te pido el primer intercambio.
```

### 5.3 Prompt para generar microcopia de UI

Copiar tal cual al iniciar conversación nueva:

```
Eres asistente de redacción de microcopia para la UI de "El Cuaderno", un
juego pedagógico de la Colección Nuevo Ser. Vamos a redactar strings que
aparecerán en pantallas, botones, mensajes y placeholders.

LEE PRIMERO EL DOCUMENTO DE REFERENCIA. NO RESPONDAS HASTA HABERLO LEÍDO.

[PEGAR AQUÍ EL DOC 04 VOCES Y FIGURAS COMPLETO §2 (LA VOZ DEL CUADERNO)]

[PEGAR AQUÍ EL DOC 13 FLUJOS DE USUARIO COMPLETO §11 (DECISIONES TRANSVERSALES)]

PROCESO

Cuando te describa un contexto de UI (qué pantalla, qué situación, qué necesita
comunicar), generas:

1. UNA versión principal en español, que sigue la voz del Cuaderno.
2. Si pides versión en eu o ca, ÚNICAMENTE si tengo certeza de la traducción
   correcta — si no, dejo "TODO_EU" o "TODO_CA" para revisión por hablante
   nativo. NUNCA invento traducciones que no me sé.
3. Después de la microcopia, una nota breve sobre por qué elegí ese fraseo
   específico y qué alternativas consideré.

REGLAS IRROMPIBLES

- Sentence case. Nunca Title Case. Nunca MAYÚSCULAS.
- Sin signos de exclamación.
- Vocabulario prohibido del doc 04 §2.3: ¡felicidades!, ¡bien hecho!, cariño,
  campeona, peque, qué bonito, qué increíble, etc.
- Frases cortas. Si una frase tiene más de 15 palabras, probablemente está
  mal escrita.
- Nunca presionar. Las invitaciones son opcionales explícitas: "si quieres",
  "puedes", "cuando estés".
- Sin "lo siento" salvo cuando algo del sistema falla. No "lo siento, no
  encuentro X".
- Errores formulados como solución, no como fallo: "haz una nota antes de
  guardar" en vez de "campo requerido".

CONFIRMACIÓN

Cuando termines de leer, di en una frase qué entiendes que NO debe sonar la
microcopia. Si aciertas, te pido el primer string.
```

## 6. Workflow recomendado para generar el catálogo MVP

Lote por lote, no todo de golpe.

### 6.1 Lote 1 — Misterios fundamentales (15)

Los Misterios que cualquier niño puede empezar a trabajar el primer mes. Universales geográficamente, accesibles desde sit spot urbano modesto.

Sugerencias para pedir a Claude:

- Misterios sobre árboles del barrio (3): cómo cambian con la estación, qué los visita, comparación entre dos.
- Misterios sobre pájaros comunes (3): cuándo cantan, dónde anidan, qué comen.
- Misterios sobre el cielo y el tiempo (3): cómo cambia la luz, cuándo llueve, primer frío.
- Misterios sobre el suelo y lo pequeño (3): qué hay debajo de una piedra, qué crece entre el cemento, qué aparece después de llover.
- Misterios sobre el sit spot (3): qué cambia entre visitas, qué hay siempre, qué hay solo a veces.

### 6.2 Lote 2 — Misterios fenológicos por estación (20)

5 por estación, específicos del calendario ibérico. Necesitan verificación con calendario fenológico (servicio de fenología, doc 03 §8).

### 6.3 Lote 3 — Misterios sistémicos (15)

Sobre relaciones. Más exigentes pedagógicamente. Verificar cuidadosamente con doc 06 §3 (los cuatro patrones a evitar).

### 6.4 Lote 4 — Misterios regionales (15)

Específicos de zonas. Mediterráneo, atlántico, alta montaña, urbano denso. Cada uno con regiones explícitas.

### 6.5 Lote 5 — Misterios de paciencia y "no sé" (5-10)

Los más difíciles de escribir bien. Generación con Claude más prudente, reescritura humana más intensa.

**Total**: 70-85 Misterios. Si la calidad final tras revisión es ≥80%, el catálogo MVP está completo. Si baja, hay que iterar.

## 7. Herramientas auxiliares

### 7.1 Verificador de patrones prohibidos

Script simple en Python o regex que escanea cada Misterio y alerta si encuentra:

- Adjetivos prohibidos (`fascinant*`, `maravillos*`, `important*`, `bell*`, `triste`, `preocupant*`).
- Signos de exclamación.
- Más de una pregunta interrogativa.
- Más de 80 palabras de descripción.
- Más de 15 palabras de pregunta.

Pasada antes de la revisión humana. Si no pasa, vuelve a Claude para reescribir.

### 7.2 Banco de fuentes verificadas

Para datos científicos, lista de fuentes aceptadas:

- SEO/BirdLife (aves España).
- Sociedad Española de Ornitología (aves Iberia).
- Atlas Florae Europaeae (plantas).
- AEMET (clima histórico).
- Aranzadi Zientzia Elkartea (naturaleza vasca).
- Institut d'Estudis Catalans (catalán).
- Real Jardín Botánico CSIC.
- iNaturalist (consultable, no autoritativa).

Cualquier dato concreto en un Misterio debe poder citarse a una de estas fuentes (sin necesidad de citarlas en el contenido visible al niño).

### 7.3 Comité de revisión

Tras cada lote, revisión por:

- Una persona del equipo editorial (alineación con manifiesto).
- Una didacta de Conocimiento del Medio (alineación con currículum).
- Una naturalista de campo (corrección biológica).
- Un niño de 9-13 años con cuidador (test del niño real).

Si las cuatro personas dicen que un Misterio está bien, entra al catálogo. Si tres dicen que sí y una propone reescritura, se reescribe. Si dos o más dicen que no, se descarta o reformula.

## 8. Decisiones abiertas

- **Quién paga el tiempo de revisión**. La calidad depende de revisión humana cuidada. Si se hace gratis, se hace mal. Modelo: cada Misterio aprobado paga 25-40€ a la persona revisora (no al redactor), explícitamente como compensación de criterio aplicado, no de horas. Pendiente decidir.
- **Versionado del catálogo**. ¿Cuándo y cómo se actualizan los Misterios sin romper el cuaderno de niños que los tienen activos? Decisión técnica para Sprint 6. Probable: nueva versión = Misterio nuevo en paralelo; viejo se mantiene activo para quien lo tenía hasta cerrar; nuevos jugadores reciben la versión nueva.
- **Fase de "Misterios beta"**. ¿Tener un subset de Misterios marcados como "experimental" durante 6 meses antes de pasarlos a estables? Probable que sí. Operacionalmente delicado.

---

## Apéndice — Checklist del operador

Antes de aceptar un Misterio generado:

```
[ ] Pregunta principal única, ≤15 palabras
[ ] Descripción ≤80 palabras
[ ] Sin signos de exclamación
[ ] Sin adjetivos prohibidos
[ ] Sin moralización implícita
[ ] Estado científico declarado y honesto
[ ] Estación y regiones declaradas correctamente
[ ] Habilidades activadas razonables y diversas
[ ] Test del niño superado (un niño real lo entiende sin pedir aclaración)
[ ] Test de la abuela superado (suena a abuela naturalista, no a profesor)
[ ] Test del Wikipedia superado (no responsable por googleo en 30s)
[ ] Test del moralista superado (no predispone a conclusión moral)
[ ] Test de la cobertura superado (funciona en Vallecas y en valle)
[ ] Datos científicos verificados con fuente
[ ] Traducciones eu/ca verificadas o marcadas TODO
```

Si alguno falla → reescritura. Si tres o más fallan → descarte y reformulación desde cero.

---

*Fin del Prompt maestro de contenido v0.1.*
