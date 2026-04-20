# Uno Roto — Guion del MVP

## Arco 4 — El ascenso

> Documento creativo.
> Versión 0.1 — Arco 4 de 4 (cierre del MVP).
> Cubre: de Iniciado III a Fraccionista. Meses 9-12 del juego.
> Leer con biblia narrativa (doc 06), biblia de personajes (doc 04), guiones arcos 1, 2 y 3 (docs 07, 08, 09).

---

## Resumen del arco

El más corto de los cuatro pero **el más denso emocionalmente**. Tramo final hacia Fraccionista: consolidación con Oryn, Prueba de Ascenso (el niño elige entre tres), ceremonia, cierre del MVP.

El peso está en dos momentos:
- **La Prueba de Espejo** (si se elige): el aprendiz virtual se parece sospechosamente a alguien del pasado de Sora. Sora no dice nada durante. Después, una palabra que no había dicho.
- **El cierre**: la Montaña deja de ser horizonte lejano para convertirse en destino real. Sora promete acompañar *"cuando llegue el momento"*.

Pedagógicamente: consolidación con umbrales de Maestría en varias habilidades. Técnicamente cierra el MVP. Abre la puerta a Era 3.

## Tabla de escenas

| # | Título | Cuándo | Duración |
|---|--------|--------|----------|
| 4.1 | El Puerto otra vez | Apertura | ~90 s |
| 4.2 | El agua recuerda | Tras 2-3 sesiones Oryn | ~90 s |
| 4.3 | La bolsa | Tras 4.2 | ~60 s |
| 4.4 | Tercera pintada | Aleatoria, Afueras | ~30 s |
| 4.5 | Eco otra vez, casi | Tras 3-4 sesiones | ~45 s |
| 4.6 | Irune: la invitación | Umbral técnico | ~90 s |
| 4.7 | Las tres pruebas | Tras 4.6 | ~75 s |
| 4.8 | Sora antes | Tras elección | ~90 s |
| 4.9a | Prueba de Fuego | Si elige Fuego | ~180 s |
| 4.9b | Prueba de Sendero | Si elige Sendero | ~240 s |
| 4.9c | Prueba de Espejo | Si elige Espejo | ~240 s |
| 4.10 | La ceremonia | Tras la prueba | ~150 s |
| 4.11 | Rexán y el té | Tras ceremonia | ~75 s |
| 4.12 | Kai, lejos | Breve | ~45 s |
| 4.13 | Sora en el borde | Cierre | ~120 s |
| 4.14 | La Montaña | Último plano | ~60 s |

Total: ~25 minutos narrativos. Denso pero corto.

---

## 4.1 — El Puerto otra vez

Sin Ari esta vez. Muelle largo, más niebla.
Habilidades: FR.19, FR.20. Flags: `oryn_training_deep_start`.

**ORYN.** Hoy empezamos.
**ORYN.** Iniciado III. Sí.
**ORYN.** Aquí vas a aprender una cosa que parece magia. Multiplicar dos fracciones entre sí.
**ORYN.** Dos tercios por tres cuartos.
**ORYN.** El resultado es más pequeño que los dos.
**ORYN.** Parece mentira. No lo es.

*Cobertizo al final del muelle. Tablón viejo con cuerdas con nudos que representan fracciones — dispositivo de entrenamiento casero.*

**ORYN.** Esto lo hice yo. Hace años.
**ORYN.** Cuando multiplicas una fracción por otra, tomas **una parte de una parte**.
**ORYN.** Si te quedas con la mitad de tres cuartos, ¿cuánto tienes?

*Mecánica nueva: **pellizco** (distinto del de fusión aditiva). Resultado 3/8.*

**ORYN.** Tres octavos.
**ORYN.** Menos que un medio. Menos que tres cuartos. Pero es la mitad de ese tres cuartos.
**ORYN.** Esto hay que verlo muchas veces para que no parezca raro.

---

## 4.2 — El agua recuerda

Muelle largo. Madrugada, cielo aclarando despacio. Oryn mira el mar tres minutos reales. Jugador **obligado a estar ahí**.
Flags: `oryn_said_water_remembers`.

**ORYN.** Hm.
**ORYN.** {nombre}. Una cosa.
**ORYN.** El agua recuerda.

*(silencio de 4 segundos — frase respirando)*

**ORYN.** Esa es una de las dos veces en que te lo voy a decir.
**ORYN.** Si alguna vez estás perdido, vuelve aquí. No te digo por qué.
**ORYN.** Solo vuelve.

- [A] *"Vale."* → asiente.
- [B] silencio → tras 5s, asiente igual.

**ORYN.** Mañana más. Descansa.

---

## 4.3 — La bolsa

Oryn abre por fin la bolsa impermeable que nunca abre delante de nadie. Saca una concha plana pulida con agujero natural y hilo fino.
Flags: `oryn_gave_token`.

**ORYN.** Oye.

*Tiende la concha.*

**ORYN.** Toma.
**ORYN.** No vale nada. Pero la llevo mucho tiempo.
**ORYN.** Ahora la llevas tú.

*Cierra la bolsa. Entra al cobertizo. Cierra la puerta.*

*La concha es objeto inventariable. Sora la reconocerá en sesión posterior: *"Ah. Te la ha dado."* Sin explicar más.*

---

## 4.4 — Una tercera pintada

Muro exterior al borde de Afueras. Misma mano. Frase nueva: **"En la parte está la libertad."**

Debajo, pintura distinta más reciente tachando: **"La parte sola no libra a nadie."**

Las dos frases coexisten. Si las tres pintadas vistas (flags 1, 2, 3), se guarda `opacos_manifest_complete` que abrirá misión en v1.5.
Flags: `seen_opacos_mark_third`.

---

## 4.5 — Eco otra vez, casi

Callejón similar a 3.9. Mundo baja el volumen. **Sin Fragmento**. Sin voz. Solo silencio.

*15 segundos de silencio jugable — el niño tiene que estar quieto ahí.*

*Después, sin explicación, el sonido vuelve. El juego **no confirma** nada. Pero el niño ha sentido que Eco estaba a punto de aparecer y no lo hizo.*
Flags: `echo_absence_felt`.

---

## 4.6 — Irune la invitación

Sala de Irune con plato de pastas pequeñas (detalle inusual — nunca las había sacado) y dos tazas de té.
Flags: `ascension_offer_received`.

**IRUNE.** Toma.
**IRUNE.** Bien.
**IRUNE.** Te he llamado porque ha llegado el momento.
**IRUNE.** Estás listo para la Prueba.
**IRUNE.** No significa que **sepas** todo lo que tienes que saber. Significa que **ya puedes demostrar** lo que sabes.
**IRUNE.** La diferencia es fina. Es real.
**IRUNE.** Puedes decir que no. Puedes esperar unos meses. No te voy a presionar.
**IRUNE.** Pero si dices que sí, te explico las tres formas.

- [A] *"Sí."* → *"Bien. Escucha."*
- [B] *"¿Qué tres formas?"* → *"Siéntate y te las explico."*
- [C] *"Déjame pensarlo."* → *"Claro. Toma otra pasta. Cuando lo hayas decidido, me dices."* (pausa; puede volver después)

---

## 4.7 — Las tres pruebas

Flags: `ascension_trials_explained`.

**IRUNE.** Tres Pruebas. Tú eliges una.
**IRUNE.** Primera. Prueba de Fuego. Combate contra un Fragmento representativo de tu rango. Sin ayudas, sin Sora. Tú solo.
**IRUNE.** Es la más rápida. Tres minutos, cuatro. Intensa.
**IRUNE.** Para los que tienen confianza en su cuerpo.
**IRUNE.** Segunda. Prueba de Sendero. Serie larga de Fragmentos, todos los tipos, con margen de error limitado. Mide tu fluidez.
**IRUNE.** Es la más lenta. Veinte minutos. Meditativa.
**IRUNE.** Para los que tienen paciencia.
**IRUNE.** Tercera. Prueba de Espejo.

*(la voz de Irune cambia un punto)*

**IRUNE.** Tienes que enseñar a alguien más joven que tú. Un Fraccionista que está donde tú estabas hace un año.
**IRUNE.** Te enfrentas a sus fallos. Le ayudas a resolverlos. Le haces preguntas, no le das respuestas.
**IRUNE.** Mide si **entiendes** lo que has aprendido. Si puedes explicarlo a otro.
**IRUNE.** Es la más difícil.
**IRUNE.** Y la más importante, para muchos.
**IRUNE.** Las tres valen lo mismo. Ninguna es superior a las otras.
**IRUNE.** Elige.

- [FUEGO] → asiente.
- [SENDERO] → asiente.
- [ESPEJO] → asiente.

*(Sin preferencia visible.)*

**IRUNE.** Bien.
**IRUNE.** Mañana. Aquí. Después de cenar.

---

## 4.8 — Sora antes

Azotea. Sora de pie con brazos cruzados. Sabe que viene.
Flags: `sora_before_trial`.

**SORA.** ¿Cuál?

**Si Fuego:**
**SORA.** Clásica. Bien.
**SORA.** Solo una cosa. No vayas rápido. No es una carrera. La velocidad se entiende mal.
**SORA.** Respira en los cambios. Descomponer es también parar.

**Si Sendero:**
**SORA.** Mm.
**SORA.** Paciente. Bien.
**SORA.** Es la que hice yo.
**SORA.** Si te cansas a mitad, no te pares del todo. Cambia de ritmo. Descansa mientras sigues.

**Si Espejo:**
**SORA.** [silencio de 2 s] Mm.
**SORA.** Vale.
**SORA.** Esa es la más personal.
**SORA.** Ten cuidado con lo que le dices al otro. A veces se te escapan cosas que no sabías que pensabas.
**SORA.** Y a veces... el otro se parece a alguien que no esperas.

*(silencio — Sora nunca ha sido tan explícita)*

**SORA.** Suerte, {nombre}.
**SORA.** Cenamos. Luego entras.

*Si eligió Espejo, Sora **no cena con él** — tiene encargo de Irune. Volverá justo al final de la Prueba.*

---

## 4.9a — Prueba de Fuego

Azotea. Seis maestros + Sora + Kai + Ari testigos. Fragmento: **Vorax** recuperado para la prueba. Valor **11/4**.
Habilidades: combate libre integrador.
Flags: `trial_fire_completed`, `defeated_vorax_first`.

**IRUNE.** Prueba de Fuego.
**IRUNE.** Vorax.

*Vorax baja. Distorsiona tiempo alrededor. Sonido bajo de presencia. Sin palabras.*

**IRUNE.** Cuando quieras.

*Combate largo. Convertir 11/4 → mixto 2 y 3/4, eliminar el 2, descomponer 3/4 en cuartos, eliminar cada cuarto mientras Vorax intenta recuperar la forma impropia. **Silencio absoluto**. Maestros observan sin intervenir.*

*(Soledad con testigos. Emocionalmente distinto a combates anteriores.)*

*Vorax se retira hacia arriba como Zafrán.*

**IRUNE.** Bien.

---

## 4.9b — Prueba de Sendero

Recorrido por la ciudad en una noche: Canales, Industria, Mercado, Afueras. Maestros aparecen brevemente al inicio. Luego el jugador va solo.
Flags: `trial_path_completed`.

**IRUNE.** Prueba de Sendero.
**IRUNE.** Esta noche vas a recorrer la ciudad. Cuatro distritos. Una prueba en cada uno.
**IRUNE.** En cada distrito te espera un Fragmento distinto, diseñado por el maestro correspondiente.
**IRUNE.** Nadie te va a acompañar. Nadie te va a ayudar.
**IRUNE.** Si fallas más de **dos veces** en total, la Prueba se suspende y la repites en unos meses.
**IRUNE.** Si la superas, tienes que volver aquí antes del amanecer.
**IRUNE.** Empiezas en los Canales.

*En cada distrito, Fragmento del maestro correspondiente. Entre pruebas, calles vacías, comercios cerrados, viento. Nadie le habla.*

*Al completar los cuatro, vuelve al Edificio de los Tejados.*

**IRUNE.** Bien.

---

## 4.9c — Prueba de Espejo

Sala de Irune cerrada. Luz tenue. Dos sillas frente a frente. Irune fuera. **Niko** (aprendiz generado por IA) sentado enfrente. Nombre generado variable; parecido sutil a alguien del pasado de Sora (peinado, gesto de pasarse la mano por el pelo, nombre terminado en vocal similar).
Habilidades: pedagogía de FR.16 y PROP.04.
Flags: `trial_mirror_completed`, `mirror_aprendiz_met`.

**NIKO.** Hola.
**NIKO.** Tengo que aprender contigo.
**NIKO.** Irune me ha dicho que me vas a ayudar.

**Ejercicio 1:** 2/3 + 1/5 = ? Niko puso 3/8 (suma de num/den). Pide ayuda.

**NIKO.** No entiendo por qué.

- [A] *"La respuesta es 13/15. Te la apuntas y vamos a otra."* → *"Vale, gracias."* (no aprende — **fallo pedagógico**)
- [B] *"Déjame preguntarte algo primero. Si sumas un tercio y un quinto, ¿es más o menos que medio?"* → piensa: *"Más. Porque un tercio ya es casi medio."* (empieza bien)
- [C] *"Has sumado los números de arriba. Has sumado los de abajo. Pero los de abajo no son números iguales. ¿Los trozos son iguales?"* → *"No."* / *"¡Ah!"* (**muy buena**)
- [D] *"¿Has intentado con denominador común?"* → *"No sé."* (intermedia)

*Niko resuelve por su cuenta.*

**NIKO.** ¡13/15! ¿Así está bien?

**Ejercicio 2:** 35% de 80 = ?

**NIKO.** Sé que es algo así como... ¿30? Pero no sé cómo pensarlo.

*El niño lo guía: 10% de 80 = 8; 35% = 3·10% + mitad de 10% = 24 + 4 = 28. O camino equivalente.*

*Durante el ejercicio, Niko hace el gesto: **se pasa la mano por el pelo hacia atrás dos veces**. Sora hace exactamente ese gesto cuando se concentra. El niño lo registra sin procesar conscientemente.*

**NIKO.** Gracias.
**NIKO.** Irune me dijo que si alguien te explicaba esto bien, lo ibas a recordar siempre.
**NIKO.** Tú me lo explicaste bien.

*Irune entra.*

**IRUNE.** Se acabó.

*Niko se va por una puerta que el niño no había visto.*

**NIKO.** Hasta mañana.

**IRUNE.** Bien.

*A media voz antes del corte:*

**IRUNE.** Sora te espera fuera.

---

## 4.10 — La ceremonia

Azotea, amanecer empezando. Todos los maestros en semicírculo. Sora entre ellos pero un paso atrás. Kai y Ari junto a la escalera. 4-5 Fraccionistas adultos testigos formales.
Flags: `rank_fraccionista`, `ceremony_completed`.

**IRUNE.** Repite conmigo.
**IRUNE.** Prometo buscar el Uno que fue.
*(repite)*
**IRUNE.** Prometo proteger el mundo que queda.
*(repite)*
**IRUNE.** Prometo no pretender nunca que sé más de lo que sé.
*(repite)*

**IRUNE.** Bien.

*Saca marca nueva — más grande, plata más clara, símbolo de la orden en relieve. Le cambia la marca del cuello.*

**IRUNE.** Bienvenido, Fraccionista.
**IRUNE.** Hace mucho que no ponía una de estas.

*(Eco de la escena 1.13.)*

*Cada maestro un paso adelante y dice su palabra antigua de bienvenida:*

**REXÁN.** [sonriendo] Bien.
**NAINI.** Bien.
**VADIC.** [asintiendo] Bien.
**ORYN.** [voz baja] Bien.
**BRINA.** [sonriendo] Bien.

*Cinco "bien" con cinco voces distintas. Hermoso sin necesitar más.*

**IRUNE.** Sora.

*Sora da un paso adelante. Frente al jugador.*

*(silencio de 3 segundos — tenso)*

**SORA.** Gracias.
**SORA.** En serio. Gracias.

*(La palabra dicha dos veces. Enorme para Sora.)*

*Se aparta al borde del semicírculo.*

**IRUNE.** Por hoy está.

---

## 4.11 — Rexán y el té

Esquina apartada de la azotea. Dos vasos pequeños humeantes.
Flags: `rexan_closure`.

**REXÁN.** Bébelo caliente.
**REXÁN.** A ver, a ver.
**REXÁN.** Te ha tocado llevarme en este año.
**REXÁN.** Has sido muy buen aprendiz.
**REXÁN.** Ya no eres mi aprendiz. Ahora eres mi colega.
**REXÁN.** Si alguna vez quieres bajar a los Canales solo para hablar, me avisas.
**REXÁN.** Yo estaré.

*Saca una pequeña marca desteñida, vieja.*

**REXÁN.** Era la primera marca de Fraccionista que me pusieron.
**REXÁN.** Ya tengo otras con más filetes azules.
**REXÁN.** Pero esta es la primera.
**REXÁN.** Cuida la tuya, {nombre}.

---

## 4.12 — Kai, lejos

Otra parte de la azotea. Kai apoyado en respiradero, solo.
Flags: `kai_final_nod`.

**KAI.** Hombre.
**KAI.** Fraccionista.
**KAI.** Va delante, mira.

*(Se señala. Sigue siendo Iniciado III. El niño ahora un rango por encima.)*

**KAI.** Vale.
**KAI.** Yo lo soy en unos meses. Si no me distraigo.
**KAI.** Oye.
**KAI.** Lo de mi padre sigue en pie. Cuando me recuperes como colega, hablamos.

*(sonrisa pequeña, auténtica)*

**KAI.** Enhorabuena, {nombre}.

*(Asiente **una sola vez** con la cabeza. Forma máxima de reconocimiento.)*

*(Primera vez que dice "enhorabuena".)*

---

## 4.13 — Sora en el borde

Todos se han ido. Sora sentada en el borde norte, piernas colgando. Alba ya avanza. Ciudad con luz limpia por primera vez. Distritos distinguibles. Montaña al fondo.
Flags: `sora_mvp_closure`, `mountain_promise_made`.

**SORA.** Bueno.
**SORA.** Lo has hecho.
**SORA.** Te voy a decir una cosa y luego no la digo más.
**SORA.** Yo llegué a Azula hace dos años. Sola.
**SORA.** Mi ciudad se llamaba **Kir**. Estaba al norte, al borde del mar.

*(Primera vez que nombra su ciudad. "Kir" aparece en pantalla 2s con tipografía ligeramente distinta.)*

**SORA.** La perdimos.
**SORA.** Yo tenía once años cuando pasó.

*(silencio muy largo)*

**SORA.** No entré aquí porque quisiera salvar el mundo.
**SORA.** Entré porque no quería que pasara otra vez.
**SORA.** Eso es todo. Pregúntame otro día si quieres más.
**SORA.** No creo que lo hagas.

*(media sonrisa)*

**SORA.** Tú no preguntas. Me gustó desde el principio.

*Gesto hacia la Montaña.*

**SORA.** Brina te habló de ella.
**SORA.** Ahí sube el que sea Fraccionista Mayor.
**SORA.** Yo tardaré. Tú tardarás más aún, porque empezaste más tarde.
**SORA.** Pero cuando llegue el momento, subimos juntos.
**SORA.** Te lo prometo.
**SORA.** No te prometo que la pelea valga la pena.
**SORA.** Te prometo que te acompaño.

*Saca la brújula vieja (si el niño se la devolvió).*

**SORA.** Quédatela.
**SORA.** Ya no la necesito yo.

*(Le cierra los dedos sobre ella.)*

---

## 4.14 — La Montaña (último plano)

Amanecer completo. La Montaña iluminada con nitidez por primera vez. Rocas, laderas, cumbre nevada, sendero tenue en un flanco. Cámara zoom lento. Niño y Sora como siluetas pequeñas de espaldas.
Flags: `mvp_completed`, `era_3_seed_planted`.

*15 segundos jugables de silencio. Viento. Amanecer.*

*Fundido a blanco.*

**FIN DEL ARCO IV. EL ASCENSO.**

*(2s negro absoluto)*

**URO UNO ROTO**

**FIN DEL MVP.**

*(3s)*

**HASTA ENTONCES.**

*Al pulsar, mapa con todos los distritos desbloqueados para exploración libre. Fragmentos cazables a discreción. Diálogos secundarios con maestros. Historia principal terminada.*

---

## Notas técnicas

**La elección de Prueba** persiste y afecta al tono del cierre. Las otras dos pueden hacerse en sesiones posteriores como contenido adicional, solo la elegida primero cuenta para la ceremonia.

**La IA de Niko en 4.9c**:
- Solo habla de los dos ejercicios y de detalles vagos de su formación.
- Nunca pregunta info personal al niño.
- Parecido con el pasado de Sora en 3 rasgos visuales sutiles: peinado, gesto de pasarse la mano por el pelo, nombre acabado en vocal similar.
- Si el niño da respuestas directas sin enseñar, Irune comenta después: *"Has resuelto. No has enseñado. Se cuenta, pero no como Espejo."* Flag `trial_mirror_weak_pass`.

**El gesto de Niko**: aparece 2 veces. Visible pero no enfatizado. Sin subrayado textual.

**Escena 4.13**: momento más importante del MVP. Música casi imperceptible. Timing respetado. Cámara fija. Plano a dos con fondo de ciudad y Montaña.

**El nombre "Kir"**: aparece 2 segundos en pantalla con tipografía ligeramente distinta. Debe ser recordable. En v1.5 la historia de Kir se desarrolla.

**"HASTA ENTONCES"** sustituye al habitual "HASTA MAÑANA". Deliberado.

**Post-MVP acceso libre**: todos los distritos, entrenamientos recurrentes con maestros, combates libres, repeticiones de Prueba de Espejo con distintos aprendices. Sin historia principal nueva hasta v1.5.

**Pruebas de usuario**:
1. ¿Recuerdan "Kir" y la promesa de la Montaña tras 4.13? Si no, nombre presentado demasiado rápido.
2. ¿Quieren volver al día siguiente a pesar del cierre? Si no, el MVP ha cerrado demasiado definitivamente.

**Tutor IA arco 4**:
- Sendero: si falla el primer Fragmento, se suspende. No se "facilita".
- Espejo: el tutor IA **es** Niko, con reglas estrictas.
- Post-ceremonia: respuestas de maestros generadas en su voz ante preguntas libres.

---

## Cierre del MVP completo

El jugador ha:
- Ascendido de Aprendiz I a Fraccionista.
- Conocido a los siete adultos principales.
- Enfrentado a Kurz, Zafrán y Vorax.
- Descubierto el santuario de los Coleccionistas.
- Encontrado las tres pintadas de los Opacos.
- Hablado (o casi) con Eco.
- Rivalidad con Kai → amistad.
- Amistad con Ari.
- Primera mención del Algebrista.
- Oído el nombre de Kir.
- Recibido la promesa de la Montaña.

Cubiertas pedagógicamente las 66 habilidades atómicas con umbrales de Maestría en casi todas.

Semillas plantadas para v1.5 y Era 3:
- Conflicto con Coleccionistas en la casa del padre de Kai.
- Historia completa de Kir y el pasado de Sora.
- Identidad del Algebrista y su correspondencia con Brina.
- Significado de Eco y los Fragmentos que hablan.
- Crecimiento de los Opacos.
- Razón del 17% trimestral en Azula.
- Muerte de la madre de Kai.

Todo queda abierto. Todo queda prometido.

---

*Fin del guion — Arco 4 v0.1.*
*Fin del guion completo del MVP.*
