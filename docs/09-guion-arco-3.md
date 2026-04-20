# Uno Roto — Guion del MVP

## Arco 3 — La ciudad entera

> Documento creativo.
> Versión 0.1 — Arco 3 de 4.
> Cubre: de Iniciado II a Iniciado III. Meses 5-9 del juego.
> Leer con biblia narrativa (doc 06), biblia de personajes (doc 04), guiones arcos 1 y 2 (docs 07 y 08).

---

## Resumen del arco

Arco **coral** del MVP. El niño deja de pivotar sobre Sora y Rexán y se expande por la ciudad. Conoce a Naini, Vadic, Oryn y Brina. Se enfrenta a Kai y le gana. Descubre el santuario de los Coleccionistas en el Puerto. Se encuentra con **Eco** — único Fragmento que habla en el MVP.

Pedagógicamente: fracciones complejas, decimales, proporciones, porcentajes. El niño ya no es aprendiz.

Narrativamente: grandes preguntas sembradas. Opacos más visibles. Coleccionistas como problema. Eco planta un acertijo. Naini trata al niño como colega.

## Tabla de escenas

| # | Título | Cuándo | Duración |
|---|--------|--------|----------|
| 3.1 | Naini | Apertura | ~90 s |
| 3.2 | El Mercado de la Luz | Tras 3.1 | ~75 s |
| 3.3 | Kai otra vez | Tras 2-3 sesiones Mercado | ~90 s |
| 3.4 | El duelo | PROP.04 Competente | ~180 s |
| 3.5 | Kai desaparece | Tras 3.4 | ~45 s |
| 3.6 | Vadic | Al entrar Industria | ~75 s |
| 3.7 | Las máquinas desajustadas | Recurrente | ~60 s |
| 3.8 | Segunda pintada | Aleatoria, Industria | ~30 s |
| 3.9 | **Eco** | Inesperada, callejón | ~150 s |
| 3.10 | Oryn | Al entrar al Puerto | ~75 s |
| 3.11 | Ari en el muelle | Tras 3.10 | ~90 s |
| 3.12 | El santuario | Con Ari | ~120 s |
| 3.13 | El interrogatorio de Naini | Tras 3.12 | ~120 s |
| 3.14 | Kai vuelve | Tras 3.13 | ~90 s |
| 3.15 | La misión conjunta | Impuesta por Irune | ~180 s |
| 3.16 | Brina | Al entrar Afueras | ~90 s |
| 3.17 | La Montaña se nombra | Tras Brina | ~75 s |
| 3.18 | Irune al fondo | Cierre | ~90 s |

Total: ~32 minutos narrativos en 16-20 semanas.

---

## 3.1 — Naini

Entrada al Mercado de la Luz. Portón alto iluminado. Explosión de luz, sonido, olor. Flags: `met_naini`, `mercado_unlocked`.

**NAINI.** ¡Qué bueno verte!
**NAINI.** Soy Naini. Maestra del Mercado. Aunque aquí casi todos me llaman Naini a secas.
**NAINI.** Iniciado, ¿eh? Pues venga. Pasa, pasa. Te cuento.

*Fragmentos silvestres flotan entre la gente sin alarma.*

**NAINI.** El Mercado es distinto. Aquí los Fragmentos no son enemigos todo el rato. Son **valor en circulación**. ¿Tú has hecho alguna vez un trueque?

- [A] *"Sí."* → *"Vale. Entonces ya medio entiendes."*
- [B] *"No."* → *"Pues lo vas a hacer hoy."*

**NAINI.** Aquí se cambia una cosa por otra. Un Fragmento por tres. Tres por uno. Porcentajes. Proporciones. Eso es lo que vas a aprender aquí.
**NAINI.** Y también vas a aprender a distinguir un trueque honesto de uno que no lo es.
**NAINI.** Pero eso ya es más adelante. Ven.

---

## 3.2 — El Mercado de la Luz

Puesto grande de frutas. 15 rojas + 10 amarillas. Habilidades: PROP.01, PROP.04.

**NAINI.** Si te digo que te llevas **un tercio** de las rojas y **la mitad** de las amarillas, ¿cuántas te llevas en total?

*(1/3·15=5 rojas, 1/2·10=5 amarillas, total 10.)*

**NAINI.** ¿Y qué porcentaje del total son tus manzanas?

*(10/25 = 40%.)*

*Le pone dos manzanas en la mano. Le guiña a la vendedora.*

**NAINI.** Aquí nadie te enseña nada gratis. Pero todo se aprende.
**NAINI.** Esa es la regla del Mercado. Nada gratis. Pero todo posible.

---

## 3.3 — Kai otra vez

Plaza lateral del Mercado. Kai Iniciado II con más filetes azules en la marca.
Flags: `kai_reappears`, `duel_challenge_open`.

**KAI.** Hombre.
**KAI.** Me dijeron que habías bajado a ver a Naini.
**KAI.** Interesante.

- [A] cordial → *"Vivo. Como ves. Tú también, ¿no?"*
- [B] directo → *"Oye, oye, tranquilo. Solo te saludaba."*
- [C] silencio → tras 3s: *"Vale. Tú mandas."*

**KAI.** Oye. He oído lo de Zafrán.
**KAI.** No todo el mundo sobrevive a su primer Fragmento nombrado.
**KAI.** Yo conmigo el mío... todavía no lo vi.
**KAI.** Bueno. Es lo que hay.
**KAI.** Si un día te aburres de entrenar con señores mayores, podemos combatir.
**KAI.** Tú contra mí. Nada oficial. Solo para ver.

---

## 3.4 — El duelo

Azotea lateral. Ari testigo. Sora no. Sin Fragmentos reales (artificiales de Irune). 3 rondas, gana 2 el que gane.
Habilidades: PROP.04, FR.19, DEC.04.
Flags: `duel_kai_completed`, `defeated_kai_first` (si gana).

*Ronda 1: reacción (favorece Kai). Ronda 2: precisión (favorece al niño si ha entrenado). Ronda 3: Duales (especialidad del arco 2).*

**KAI.** No está mal.
**KAI.** Más rápido.
**KAI.** ¿Eso es todo?

*Si el niño gana:*

*Kai se queda quieto, mira al suelo. Ari se levanta del escalón, gesto físico de reconocimiento.*

**KAI.** [voz baja] Vale.
**KAI.** Ya está.

*Se va sin despedirse.*

*Si el niño pierde (menos probable):*

**KAI.** Buen intento.
**KAI.** Otro día te doy la revancha.
*(palmadita breve, casi amistosa)*

---

## 3.5 — Kai desaparece

Ari se acerca. Ofrece refresco.
Flags: `kai_disappeared`.

**ARI.** Toma.
**ARI.** No te va a hablar en un tiempo.
**ARI.** Es así.
**ARI.** Cuando yo le gané a Elen hace tres meses, estuvo desaparecida dos semanas. Ahora somos colegas.
**ARI.** Déjale espacio.
**ARI.** Tengo que volver con Vadic. Industria. Si bajas alguna vez, me avisas.
**ARI.** Por cierto, has estado bien.

*(Elogio más directo del juego hasta ahora, dicho de pasada. Kai no aparece en 3-4 sesiones.)*

---

## 3.6 — Vadic

Entrada Industria. Galpón ladrillo rojo. Vadic mide con calibre.
Habilidades: DEC.01, MED.01. Flags: `met_vadic`, `industria_unlocked`.

**VADIC.** Un momento.
*(anota, guarda calibre)*
**VADIC.** Vadic.
**VADIC.** ¿Nombre?
**VADIC.** Mm.
**VADIC.** Esto mide **2,34** metros. ¿Cuántos centímetros son?
*(234)*
**VADIC.** Correcto.
**VADIC.** ¿Y en milímetros?
*(2340)*
**VADIC.** Correcto.
**VADIC.** Aprendiz tres, Iniciado II. Bien para trabajar aquí.
**VADIC.** Aquí las cosas se miden bien o no se miden. No hay término medio.

- [A] *"¿Qué hago aquí?"* → *"Lo que yo te diga, cuando yo te lo diga. Pero aprender a medir. Eso siempre."*
- [B] *"¿Cuánto tiempo llevas aquí?"* → *"Veintidós años."* (nada más)
- [C] silencio → tras 2s: *"Vuelve mañana. Tengo trabajo."*

---

## 3.7 — Las máquinas desajustadas

Recurrente, 2-3 variantes.

**A. La máquina que calcula mal.**
Máquina de 30 años con Fragmento dentro. Marca **0,25** l pero medición externa da **0,3** l.
**VADIC.** 0,3. Correcto. La máquina miente por **0,05**.
**VADIC.** Lo que tiene el desajuste. No parece mucho. Multiplícalo por mil mezclas al día.

**B. Convertir unidades.**
Tabla: 3 kg, 0,4 l, 250 g, 1,2 kg, 750 ml. Convertir a una unidad común.
**VADIC.** Correcto.
**VADIC.** Ahora explícame por qué.
*(escucha; asiente)*
**VADIC.** Bien.

**C. El error del aprendiz.**
Confunde m² = 100 cm².
**VADIC.** No. Un metro es cien centímetros. Pero estamos midiendo área. Piénsalo otra vez.
*(si dice 10.000)*
**VADIC.** Ahora. Otra vez.

---

## 3.8 — Una segunda pintada

Callejón en Industria entre galpones. Misma mano que arco 2. Frase: **"La unidad es la medida de la obediencia."**
Flags: `seen_opacos_mark_second`.

**VADIC.** Hay más últimamente.
**VADIC.** Camina.

---

## 3.9 — Eco (escena clave)

Inesperada, una sola vez en el arco. Callejón de Canales o Industria (según distrito más visitado). Mundo baja el volumen. Fragmento flotando, pequeño, doble valor visible: **2/4** y **1/2**.
Habilidades: FR.09, FR.10 como acertijo.
Flags: `met_eco_first`, `eco_riddle_heard`.

**ECO.** Hola.
**ECO.** Otro nuevo.
**ECO.** ¿Vas a desfragmentarme, Aprendiz?

- [A] *"Iniciado."* → *"Ah. Disculpa. Mejor así."*
- [B] *"No sé."* → *"Eso es honesto. Mejor así."*
- [C] silencio → tras 2s: *"Vale. No hablas. Bien."*

*El Fragmento gira despacio sobre sí mismo.*

**ECO.** Tengo una pregunta.
**ECO.** Si tú y yo fuéramos el mismo pedazo de algo mayor, con nombres distintos, ¿seríamos la misma cosa?

*Silencio absoluto. Eco espera sin reloj.*

- [A] *"Sí."* → *"Entonces tú y yo ya somos."* *(desvanece)*
- [B] *"No."* → *"Entonces tú y yo todavía no somos."* *(desvanece)*
- [C] *"No lo sé."* → *"Yo tampoco. Ven a verme otra vez cuando sepas."* *(desvanece)*
- [D] silencio 5s → *"Otra vez será."* *(desvanece)*

*Las partículas suben hacia arriba, no hacia abajo. Mundo vuelve a su volumen.*

*Menciones posteriores:*
- **Sora**: *"¿Dónde lo viste?"* y cambia de tema rápido.
- **Rexán**: *"Ah. Eco."* Pausa larga. *"Cuídate de él."* No explica.
- **Irune**: *"Mm. Hablaremos de él algún día."*

---

## 3.10 — Oryn

Muelle largo del Puerto Silencioso. Faro lejano parpadeando. Mar negro.
Habilidades: FR.18, FR.19. Flags: `met_oryn`, `puerto_unlocked`.

**ORYN.** Hm.
*(pausa muy larga — 8 s)*
**ORYN.** Siéntate si quieres.

*(algo se mueve lejos en el mar, se sumerge)*

**ORYN.** Oryn.
**ORYN.** ¿Nombre?
**ORYN.** Hm.
**ORYN.** Aquí aprendes a multiplicar y a dividir.
**ORYN.** Fracciones. Fracciones entre ellas.
**ORYN.** No es rápido.

*Mirada que dura lo justo para incomodar.*

**ORYN.** ¿Preguntas?

- [A] *"¿Por qué es silencioso el Puerto?"* → *"Trabajamos de noche. Y el mar pide silencio. Algunos piensan que el mar escucha."*
- [B] *"¿Conociste a Rexán?"* → *"Hm. Mucho."* (nada más)
- [C] silencio → *"Vale."* (vuelve al mar)

**ORYN.** Vuelve mañana. Empezamos.

---

## 3.11 — Ari en el muelle

Cafetería nocturna del Puerto. Ari ya ha pedido bebida para los dos.
Flags: `ari_mission_start`.

**ARI.** ¡Eh!
**ARI.** No te esperaba aquí.
**ARI.** Bueno, sí. Todo el mundo acaba pasando por el Puerto tarde o temprano.
**ARI.** Oye. ¿Te puedo pedir una cosa?
**ARI.** Llevo dos semanas viendo algo raro en el muelle 7. No voy a decir más aquí.
**ARI.** No es un Fragmento normal. Creo que es... otra cosa.
**ARI.** Yo sola no voy. ¿Me acompañas mañana por la noche?

- [A] *"Vale."* → *"Gracias, {nombre}. En serio. Aquí mismo mañana, a la misma hora."*
- [B] *"¿No se lo has dicho a Oryn?"* → *"No. No sé cómo reaccionaría. Y además... quiero ver qué es primero."*
- [C] *"¿Y si es peligroso?"* → *"Por eso te lo pido a ti."* *(sonrisa sin humor)*

---

## 3.12 — El santuario

Muelle 7. Almacén viejo con puerta entornada, luz rojiza dentro. Altar improvisado con Fragmento **3/4** enjaulado en caja de cristal con filtros metálicos. Objetos alrededor: espejos antiguos, reloj parado, rosa disecada, frasco con agua turbia. Objetos fuera del altar (silla, mesa) **mal proporcionados**.
Flags: `discovered_collector_shrine`.

**ARI.** [susurro] ¿Ves?
**ARI.** Eso no es un Fragmento cualquiera.
**ARI.** Alguien lo está **usando**.

*(puerta cierra en el almacén, pasos)*

**ARI.** Vámonos.

*(corren, atraviesan muelle 7 en silencio)*

**ARI.** Hay que contárselo.
**ARI.** A alguien. No sé a quién.

- [A] *"A Sora."* → *"Sora... no sé. Ella es de Tejados. Mejor a uno del distrito de aquí."*
- [B] *"A Oryn."* → *"Oryn sabrá. Pero... no sé si es la persona adecuada. Siempre me da la sensación de que sabe más cosas de las que dice."*
- [C] *"A Naini."* → *"Sí. Ella sí. Naini reacciona. Los otros piensan demasiado antes."*

---

## 3.13 — El interrogatorio de Naini

Despacho pequeño al fondo del Mercado. Naini **sin sonrisa** por primera vez.
Flags: `naini_treats_as_peer`, `collector_case_opened`.

**NAINI.** Contádmelo. Paso a paso.

*(escucha sin interrumpir. Toma notas. Hace un círculo.)*

**NAINI.** Vale.
**NAINI.** Esto no es un Fragmento silvestre. Esto es una **infraestructura**.
**NAINI.** Alguien está capturando Fragmentos y manteniéndolos vivos para que **funcionen** en un lugar concreto.
**NAINI.** Se llaman Coleccionistas. Algunos ricos que descubrieron hace décadas que un Fragmento grande, enjaulado, **distorsiona** el espacio a su alrededor. Y si lo pones bien, distorsiona a tu favor.
**NAINI.** Contratos que firmas dentro te favorecen. Reuniones duran lo que te conviene. Gente que visita tu oficina olvida la mitad de lo que iba a decirte.
**NAINI.** Es difícil de probar. Y es muy viejo.
**NAINI.** Ari, esto lo has hecho bien.
**NAINI.** {nombre}, tú también.

*(Primera vez que un maestro mira al niño como **colega**, no como alumno.)*

**NAINI.** Lo voy a llevar al Cónclave. Es nivel Fraccionista Mayor.
**NAINI.** Gracias.

*(Primera vez que un maestro le da las gracias al jugador.)*

**NAINI.** Vosotros dos no habéis estado nunca en ese muelle. ¿De acuerdo?
**NAINI.** Bien. Hala. Id a descansar.

---

## 3.14 — Kai vuelve

Azotea principal. Sora al fondo. Kai sentado contra un respiradero mirando el cielo.
Flags: `kai_returned`, `kai_spoke_again`.

**SORA.** Te está esperando.

**KAI.** Hombre.
**KAI.** Me enteré de lo del muelle 7.
**KAI.** No vas a creerme, pero...
**KAI.** Yo llevaba un mes sospechando algo así en la calle donde vive mi padre.

*(Confesión real. Kai **sin máscara**.)*

**KAI.** No tengo pruebas. Pero... cuando la gente entra a cenar con mi padre, salen distintas.
**KAI.** No lo he hablado con nadie.
**KAI.** Necesito ayuda.

- [A] *"Cuéntame."* → explica: oficina cerrada, gente sale confusa.
- [B] *"¿Por qué me lo cuentas a mí?"* → *"Porque ya no confío en los que llevo años conociendo. Y tú acabas de hacer algo que yo no sabía hacer."*
- [C] silencio, escuchar → tras 5s: *"Gracias por no preguntar nada."*

*(Acuerdo tácito: investigar juntos la casa del padre de Kai. La misión real es pie para v1.5.)*

**KAI.** Mañana te cuento más.
**KAI.** Has estado bien. En el duelo.

*(Sora murmura al fondo, casi para sí:)*

**SORA.** Vaya.

---

## 3.15 — La misión conjunta

Barrio residencial entre Canales e Industria. Fragmento Impropio **9/5** en el portal de una casa. Irune se la impone.
Habilidades: FR.12, FR.17, cooperación.
Flags: `first_coop_with_kai`, `kai_alliance_seed`.

**KAI.** Impropio.
**KAI.** Si lo convertimos en mixto, es **1 y 4/5**.
**KAI.** ¿Lo estabilizas tú o yo?

- [A] *"Yo."* → Kai asiente. El niño estabiliza.
- [B] *"Tú."* → Kai estabiliza. El niño ataca.
- [C] *"Juntos."* → Kai pequeña sonrisa auténtica: *"Vale. Juntos."*

*Combate coordinado. Frases de Kai ya de compañero:*

**KAI.** Bien.
**KAI.** Espera.
**KAI.** Ahora.
**KAI.** Tu turno.

*(Tras el combate:)*

**KAI.** Mañana te paso algo por escrito.
**KAI.** De lo de mi padre.
**KAI.** Por si no te vuelvo a ver en un tiempo.

*(Semilla: Kai sabe que entra en algo más grande.)*

---

## 3.16 — Brina

Afueras. Observatorio antiguo al borde de un campo. Cielo estrellado, dos lunas esta noche.
Habilidades: EST.01, EST.03, PROP.02. Flags: `met_brina`, `afueras_unlocked`.

**BRINA.** Ah, tú.
**BRINA.** Brina. Maestra de las Afueras. Y profesora, pero eso es otra cosa.
**BRINA.** Déjame pensar. Tú eres el que hizo lo de Zafrán con Sora y acaba de descubrir algo en el Puerto con Ari y trabajó ayer con Kai.

*(Resumen de meses en una frase.)*

**BRINA.** Interesante.
**BRINA.** Siéntate.
**BRINA.** Aquí trabajamos con datos. Probabilidades. Tendencias.
**BRINA.** Te voy a enseñar una cosa que te va a parecer aburrida. No lo es.

*(Tabla: fechas y números que suben.)*

**BRINA.** ¿Qué ves?

- [A] *"Los números suben."* → *"Bien. ¿Sabes qué miden?"*
- [B] *"¿Qué son?"* → *"Te lo iba a contar igual."*

**BRINA.** Son Fragmentos. Fragmentos aparecidos en Azula cada mes.
**BRINA.** En los últimos dos años han subido un **17% cada trimestre**.
**BRINA.** Nadie se lo cuenta a los Fraccionistas nuevos. No quieren asustar.
**BRINA.** Pero tú ya eres Iniciado III. Tienes que saber.
**BRINA.** Azula está peor cada año.
**BRINA.** Y no sabemos por qué.

*(Bomba de relojería narrativa.)*

---

## 3.17 — La Montaña se nombra

Mirador al borde de Afueras con vista clara a la Montaña. Luna recortando silueta.
Flags: `algebrist_named_first`.

**BRINA.** Todos acaban mirándola.
**BRINA.** ¿Irune te ha hablado de ella?

*(niega o dice que preguntó a Sora)*

**BRINA.** Mm.
**BRINA.** Ahí arriba vive alguien que todavía cree que puede repararse.

- [A] *"¿Repararse qué?"* → *"El Uno. Lo que se rompió."*
- [B] *"¿Quién vive?"* → *"El Algebrista."*

*(si ninguna opción en 5s, Brina sigue:)*

**BRINA.** El Algebrista.
**BRINA.** Hace décadas que nadie sube. Irune no sube.
**BRINA.** Algunos dicen que ya no vive. Yo creo que sí.
**BRINA.** Algún día vas a querer subir.
**BRINA.** No hoy. No este año. Pero algún día.
**BRINA.** Cuando te toque, alguien te ayudará a ir. Irune, Sora. Alguien.
**BRINA.** Bueno. ¿Has visto el gráfico que te dejé la última vez? Tenía una pregunta sobre él.

*(Primera vez que el nombre **Algebrista** se pronuncia abiertamente.)*

---

## 3.18 — Irune al fondo

Cierre del arco. Sala de Irune con chimenea encendida. Sora al fondo con libro cerrado.
Flags: `arc3_closed`, `arc4_opening`.

*(Irune sirve té.)*

**IRUNE.** Han pasado muchas cosas.
**IRUNE.** Zafrán. El muelle 7. Kai. Eco.

*(La última palabra con tono distinto.)*

**IRUNE.** Sí. Sé lo de Eco.
**IRUNE.** No te preocupes por él. De momento.
**IRUNE.** Has conocido a todos los maestros menos a Oryn bien. Eso te falta.
**IRUNE.** Y cuando lo conozcas, estarás listo.
**IRUNE.** Iniciado III, pronto. Fraccionista, en unos meses.

*(Mira a Sora un momento. Sora no se mueve.)*

**IRUNE.** Cuando seas Fraccionista, ya no hace falta que nadie vaya contigo a ningún sitio.
**IRUNE.** Entonces vas a tener que empezar a decidir tú qué hacer con lo que sabes.
**IRUNE.** Es menos cómodo de lo que parece.

*(Sonrisa pequeña.)*

**IRUNE.** Descansa. Vete con Sora.

*Azotea. Borde. Sora apoyada. El niño a su lado. Ninguno habla. Miran Azula, luces, distritos, Montaña al fondo.*

**FIN DEL ARCO III. LA CIUDAD ENTERA.**
**HASTA MAÑANA.**

---

## Notas técnicas

**Tres pintadas Opacos** (arcos 2, 3, 4):
1. *"El uno era la cárcel"* (2.5)
2. *"La unidad es la medida de la obediencia"* (3.8)
3. *"En la parte está la libertad"* (arco 4, pendiente)

Forman pequeño manifiesto Opaco que jugadores atentos reconstruyen.

**Eco (3.9) implementación**:
- Música ambiente silenciada, capa inaudible entra durante el encuentro.
- Sonido ambiente reducido 70%.
- Fuente de texto visiblemente distinta (serifa delgada vs sans-serif del resto).
- El Fragmento **no puede ser atacado**. Gesto de combate no registra. El niño aprende que Eco es otra cosa.

**Rivalidad con Kai**: si el niño pierde el duelo en 3.4, el arco pivota (variante B a escribir aparte). El guion base asume que gana.

**Los objetos del altar (3.12)** — espejos, reloj parado, rosa disecada, agua turbia — son simbólicos del Lenguaje del Uno. Los Coleccionistas son herederos ignorantes de una rama caída de Restauradores (revelación v1.5).

**La cifra del 17%** es real en el lore. Azula está peor. No se resuelve en el MVP.

**Mención del Algebrista (3.17)**: el momento más importante del arco a largo plazo. La escena debe **respirar**. No intercalar ejercicios inmediatos después.

**Pruebas de usuario**: probar 3.9 (Eco) con niños. Si dicen *"qué raro ha sido eso"* o *"¿qué era eso?"* — perfecto. Si no lo recuerdan tras la sesión — mal calibrado. Debe ser memorable.

**Tutor IA activadores**:
1. Fallos repetidos PROP.04 → Naini con metáfora de manzanas (máx 2 frases).
2. Fallos DEC.06 → Vadic con máquina imaginaria: *"0,3 por 0,4 son décimas de décimas. Centésimas. Doce centésimas. 0,12."*
3. Escena 3.12 **nunca** tutor IA. Narrativa pura.

---

*Fin del guion — Arco 3 v0.1. Siguiente y último: Arco 4 — El ascenso.*
