# Uno Roto — Guion del MVP

## Arco 2 — Canales y Zafrán

> Documento creativo.
> Versión 0.1 — Arco 2 de 4.
> Cubre: de Aprendiz II a Iniciado II. Meses 2-5 del juego del niño.
> Leer con biblia narrativa (doc 06), biblia de personajes (doc 04) y guion del Arco 1 (doc 07) a mano.

---

## Resumen del arco

Es **el arco pedagógicamente crucial** del MVP: de las fracciones equivalentes a la suma con denominadores distintos — el concepto donde más niños se pierden en el currículum real de 10-11 años.

Narrativamente: Leo baja solo a los Canales por primera vez, conoce a Rexán, entrena semanas, oye rumores de Zafrán, lo vislumbra, y finalmente lo enfrenta con Sora como apoyo. No lo derrotan del todo — Zafrán escapa debilitado. Sora se agrieta: el niño ve por primera vez algo de su pasado oculto. Cierre: una noche silenciosa en los Canales.

## Tabla de escenas

| # | Título | Cuándo | Duración |
|---|--------|--------|----------|
| 2.1 | Bajar solo | Inicio | ~90 s |
| 2.2 | Rexán | Tras 2.1 | ~120 s |
| 2.3 | El primer Fragmento Espejo | Sesión tras 2.2 | ~75 s |
| 2.4 | Los puentes (plantilla) | Recurrente, 3-4 variantes | ~60-75 s |
| 2.5 | Una pintada rara | Aleatoria | ~30 s |
| 2.6 | La primera vez que Zafrán se menciona | FR.09 Competente | ~60 s |
| 2.7 | Un Dual en el puente | Inicio FR.16 | ~90 s |
| 2.8 | Rexán y el agua | Tras 3-4 sesiones | ~75 s |
| 2.9 | Ari | Mitad del arco | ~60 s |
| 2.10 | El silbido lejano | Tras dominios de FR.16 | ~45 s |
| 2.11 | Sora vuelve a bajar | Antes del combate | ~90 s |
| 2.12 | La noche de Zafrán | Umbral técnico | ~150 s |
| 2.13 | El combate | Tras 2.12 | ~180-240 s |
| 2.14 | Después | Tras 2.13 | ~90 s |
| 2.15 | Rexán espera | Al volver | ~75 s |
| 2.16 | Los Canales en silencio | Cierre | ~90 s |

Total: ~25 minutos narrativos en 12-16 semanas.

---

## 2.1 — Bajar solo

Activa: primer arranque del arco 2.
Lugar: calle bajando del Edificio de los Tejados hacia los Canales. Niebla baja.
Flags: `canales_entered`, `solo_travel_first`.

**SORA.** Ya.
**SORA.** Vete.
**SORA.** Si te pasa algo, vuelves corriendo. No te hagas el valiente.
**SORA.** Y si tardas mucho, voy yo.

*Jugador baja por calles, ve: pareja en portal, gato dormido, Fragmento tonto que se disuelve solo. Calles se estrechan, luz más amarilla, canales estrechos, puentes de piedra, faroles.*

**BARRIO DE LOS CANALES** *(flotante 2s)*

*Llega a plaza con puente. Al otro lado, hombre mayor con bastón sentado en un saliente, leyendo. Levanta la vista. Sonríe.*

---

## 2.2 — Rexán

Activa: tras 2.1.
Habilidades: **FR.09** introducida.
Flags: `met_rexan`, `canales_rexan_mentor_active`.

*Rexán se levanta, cojea, no lo esconde ni lo señala.*

**REXÁN.** A ver, a ver.

*Primera sonrisa abierta de adulto en el juego.*

**REXÁN.** Tú eres el que Sora manda.

*Tiende la mano.*

**REXÁN.** Rexán. Maestro de los Canales, dicen. Yo me llamo Rexán. Sin más.
**REXÁN.** Tú ya sabes lo que es un Fragmento. Sabes sumar trozos cuando son iguales. Ya eres Aprendiz II. No está mal.
**REXÁN.** Aquí vas a aprender algo distinto.

*Señala el canal. En el agua, dos Fragmentos: **1/2** y **2/4**.*

**REXÁN.** ¿Cuál es más grande?

- [A] *"El segundo."* → *"Mm. ¿Seguro?"*
- [B] *"El primero."* → *"Mm. ¿Seguro?"*
- [C] *"Son iguales."* → asiente: *"Bien, {nombre}. Bien."*

*Si [A] o [B]:*
**REXÁN.** Míralos otra vez. Mira el agua.
*(el reflejo muestra iguales)*

**REXÁN.** Son la misma cosa. Con nombres distintos.
**REXÁN.** Un medio. Dos cuartos. Mismo trozo de mundo.

*Los dos orbitan y se fusionan.*

**REXÁN.** Eso se llama **equivaler**.
**REXÁN.** Toda verdad tiene otra forma igualmente verdadera.
**REXÁN.** Es lo que aprendes aquí. Lo demás viene después.
**REXÁN.** Vamos. Te enseño el barrio.

---

## 2.3 — El primer Fragmento Espejo

Activa: sesión tras 2.2. Callejón junto a canal. Dos Fragmentos Espejo emergen: **3/4** y **6/8**, con halos.
Habilidades: FR.09, FR.11.
Flags: `first_family_d_fragment`.

**REXÁN.** Fragmentos Espejo.
**REXÁN.** Se llaman así porque van en pareja. Uno parece el reflejo del otro.
**REXÁN.** Y casi siempre lo es.
**REXÁN.** Míralos bien, {nombre}. ¿Son equivalentes?

*Mecánica: tocar para ver valor, arrastrar uno sobre otro.*

- [A] Arrastrar 3/4 sobre 6/8 → brillan, giran, se funden. *"Bien. Son el mismo."*
- [B] Toca uno sin emparejar → Rexán: *"Piensa, {nombre}. 3 de 4. 6 de 8. ¿Qué ves?"*

**REXÁN.** Cuando encuentres dos así, los emparejas y se disuelven juntos. Es el gesto más limpio que puedes hacer.
**REXÁN.** A veces no son equivalentes. Entonces tienes que reconocerlo y atacar por separado. No pasa nada.
**REXÁN.** Si los emparejas mal, hacen ruido. Los oyes.
*(le guiña un ojo)*
**REXÁN.** Vas a aprender a oírlos.

---

## 2.4 — Los puentes (plantilla recurrente 3-4 variantes)

**A — Puente pequeño de piedra.**
**REXÁN.** Mira el agua un momento.
**REXÁN.** Cuando un Fragmento se simplifica, es como reconocer tu cara en un reflejo mal iluminado.
**REXÁN.** Parece otra cosa. No lo es.
**REXÁN.** Venga. Otra ronda.

**B — Puente largo con mercadillo nocturno.**
**REXÁN.** Lleva vendiendo aquí desde que yo era joven.
**REXÁN.** Nunca ha cambiado los precios.
*(Rexán compra dos bebidas, paga con monedas antiguas.)*

**C — Puente con vista a la Montaña.**
**REXÁN.** ¿Le has preguntado a Irune por eso alguna vez?

Si niega:
**REXÁN.** Mejor. No es momento.

Si afirma (recuerda arco 1 variante D):
**REXÁN.** Ah. ¿Y qué te dijo?
*Opción*: *"Que hoy no."*
**REXÁN.** Así es Irune. *(risa pequeña)*

**D — Tras un fallo.**
*Rexán se agacha (con esfuerzo, cojera visible). Saca pedacito de pan, lo parte en dos.*
**REXÁN.** ¿Esto es un medio?
*(asiente)*
*Rexán parte una mitad otra vez.*
**REXÁN.** ¿Y esto es...?
*Opción*: *"Un cuarto."*
**REXÁN.** Bien.
**REXÁN.** Si junto dos cuartos, tengo un medio.
**REXÁN.** El camino es al revés, pero el pan sigue siendo el mismo pan.

---

## 2.5 — Una pintada rara

Aleatoria, una vez en el arco. Pared vieja en callejón.
Flags: `seen_opacos_mark_first`.

*Pintada negra reciente con gotas: círculo roto con cuatro líneas hacia fuera. Debajo: **"El uno era la cárcel."***

**REXÁN.** Vámonos, {nombre}.

- [A] *"¿Qué es esto?"* → tras pausa: *"Pintadas. No importantes."*
- [B] *"¿Por qué dice eso?"* → *"Porque algunos piensan así. Vamos."*
- [C] silencio → *"Vamos."*

*Rexán no gira la cabeza hacia la pintada. Su voz no tiene miedo; tiene cansancio.*

---

## 2.6 — La primera vez que Zafrán se menciona

Activa: FR.09 Competente. Terraza de bar cerrado.
Flags: `heard_about_zafran_first`.

**REXÁN.** Oye.
**REXÁN.** ¿Sora te ha hablado de Zafrán alguna vez?
*(niega)*
**REXÁN.** Mm.
**REXÁN.** Bueno. Yo te digo el nombre al menos.
**REXÁN.** Es un Fragmento grande. Muy viejo. Vive por aquí.
**REXÁN.** Ahora mismo no te preocupes de él. No te va a ver. No te tiene que ver.
**REXÁN.** Pero si alguna vez oyes un silbido largo y raro por la noche, de los canales... te vuelves al Edificio de los Tejados. Sin pensarlo. ¿De acuerdo?

- [A] *"¿Por qué?"* → *"Porque sí. Confía en mí una vez y hazme caso."* */ *"Solo una vez."*
- [B] *"Vale."* → *"Bien. Gracias."*

**REXÁN.** ¿Has visto la luna esta noche? Solo una. Qué pena.

---

## 2.7 — Un Dual en el puente

Activa: Iniciado I, inicio de FR.16. Puente grande, niebla leve. Dos Fragmentos conectados por línea de luz: **1/3** y **1/4**.
Habilidades: **FR.16**, **DIV.07** (MCM).
Flags: `first_family_f_fragment`, `dual_fragment_mechanic_learned`.

**REXÁN.** Duales.
**REXÁN.** Esto es lo nuevo. Esto es lo que querías ver.
**REXÁN.** Con los Duales, no puedes atacar a uno solo. Están enganchados.
**REXÁN.** Tienes que **unirlos** primero. Volverlos un solo Fragmento. Y entonces los atacas.
**REXÁN.** Para unirlos, tienen que hablar el mismo idioma. Mismo denominador.
**REXÁN.** Un tercio y un cuarto no hablan el mismo idioma. Mira.

*Primer intento arrastrando: chirrido desagradable, rebotan.*

**REXÁN.** ¿Lo oyes? Así suena cuando los uniones mal.
**REXÁN.** Busca un número que sea múltiplo de los dos. De tres y de cuatro.

*El niño prueba 12 → 1/3 → 4/12, 1/4 → 3/12 → se funden en **7/12**.*

**REXÁN.** Bien.
**REXÁN.** Doce es lo más pequeño que los dos comparten. Se llama **mínimo común múltiplo**. MCM, para ir rápido.
**REXÁN.** Ahora ya es un Fragmento normal. Atácalo.

*Al derrotarlo, Rexán sonríe de medio lado.*

**REXÁN.** Esto es lo más bonito que se aprende aquí.
**REXÁN.** En serio. Cuando esto lo tienes, el resto es juego.

---

## 2.8 — Rexán y el agua

Activa: tras 3-4 sesiones post 2.7. Muelle pequeño al borde de canal ancho. Pies casi tocando el agua.
Flags: `rexan_mentions_oryn`, `rexan_old_injury_referenced`.

*Silencio un minuto. Solo el agua.*

**REXÁN.** Yo me formé en el Puerto, ¿sabes?
**REXÁN.** Oryn me entrenó. Hace muchos años. Él era joven todavía, como Sora ahora.
**REXÁN.** Desde entonces, el agua me gusta.

*Tira piedrita al agua.*

**REXÁN.** Cuando me pasó lo de la pierna, hace ya, volví al Puerto a recuperar. Estuve un año entero viendo el agua desde un muelle como este.
**REXÁN.** Cuando pude caminar otra vez, me preguntaron si quería volver a ser Maestro. Les dije que sí, pero aquí, en los Canales. Porque los canales tienen agua también, y no son el mar.
**REXÁN.** El mar acuerda. Los canales olvidan.
**REXÁN.** Eso no lo entiendes todavía. No importa.

- [A] *"¿Qué te pasó?"* → *"Otro día, {nombre}. Hoy no."* *(sin frustración, sincero)*
- [B] *"¿Sora conoce a Oryn?"* → *"Sora no baja al Puerto. No le gusta el agua."* */ *"Aún."*
- [C] silencio → tira otra piedrita

*Se levanta con dificultad apoyándose en el bastón.*

**REXÁN.** Venga. Antes de que nos durmamos los dos.

---

## 2.9 — Ari

Activa: mitad del arco 2, esquina cerca del Edificio de los Tejados al volver del Barrio. Ari: 12 años, Aprendiz II, discípula de Vadic.
Flags: `met_ari`.

**ARI.** Hola.
**ARI.** ¿Tú también eres nuevo?
**ARI.** Soy Ari. Llegué hace seis meses.

- [A] *"Yo soy {nombre}."* → asiente.
- [B] *"Mm."* → sonríe más amplia: *"Poco hablador, tú. Me gusta."*

**ARI.** Oye. Estoy con el Maestro Vadic. Industria. ¿Tú?

- [A] *"Con Rexán, de Canales."* → *"Ah, Rexán. Me cae bien. Luego te caerá a ti."*
- [B] *"No lo sé todavía."* → *"Vale, vale, no preguntaba por preguntar. Solo curiosidad."*

**ARI.** Bueno. Me tengo que ir. Mis padres no saben que ando por aquí a esta hora.
**ARI.** Nos vemos por los tejados.

*Se gira al correr:*

**ARI.** No te metas con los Espejo los lunes, eh. No sé por qué pero los lunes son raros.

---

## 2.10 — El silbido lejano

Activa: tras varios dominios fluidos de FR.16. Mitad de un entrenamiento con Rexán.
Flags: `heard_zafran_whistle_first`.

*Silbido largo, grave, con quiebro extraño al final. Ni pájaro ni sirena. Dura 3 segundos.*

*Rexán se queda completamente quieto. Deja caer el bastón sin darse cuenta. Lo recoge despacio.*

**REXÁN.** [voz distinta, más baja] Se acabó por hoy.

*Intenta sonreír, no lo consigue del todo.*

**REXÁN.** Vete al Edificio de los Tejados. Ahora. Despacio pero ya. Y no pasas por la calle del mercado nocturno.
**REXÁN.** Dile a Irune que he oído a Zafrán.

*Se va en dirección contraria. La cojera se nota más. Calles silenciosas, puestos cerrando antes, ventanas apagándose al paso del jugador. Al subir:*

**SORA.** Pasa. Irune quiere verte.

---

## 2.11 — Sora vuelve a bajar

Activa: sesión siguiente. Azotea al amanecer. Sora con cazadora gruesa, bolsa pequeña cruzada.
Flags: `sora_descending_together`, `zafran_confrontation_prep`.

**SORA.** Hoy voy contigo.
**SORA.** No al entrenamiento. Al combate.
**SORA.** Rexán no puede. No debe. Así que voy yo.

*Irune aparece en la puerta, no cruza. Asiente a Sora. Desaparece.*

*En el camino Sora habla más que en semanas:*

**SORA.** Zafrán es un Fragmento Dual muy viejo. Enorme. Vive entre los canales, en la zona más profunda del distrito.
**SORA.** No ataca todo el tiempo. A veces está dormido años. Y de vez en cuando sale.
**SORA.** La última vez fue hace dos semanas. Un ruido en el mercado. No fue mucho. Rexán lo contuvo.
**SORA.** La anterior, hace veinte años, le dejó la pierna como la tiene.
**SORA.** Esta no la aguanta solo. Irune no quiere que vaya él. Voy yo.
**SORA.** Y tú.

*Primera mirada sin distancia.*

**SORA.** No porque seas bueno. Porque es tu distrito ahora. Tienes que verlo con tus ojos.
**SORA.** Te quedas atrás. Atacas cuando te digo. No haces nada que no te diga.
**SORA.** ¿Vale?

- [A] *"Vale."* → asiente.
- [B] *"¿Voy a estar bien?"* → *"Mientras me hagas caso, sí."*
- [C] silencio → *"Vale. Vamos."*

---

## 2.12 — La noche de Zafrán

Activa: tras 2.11. Parte más profunda y vieja del Barrio. Plaza circular pequeña con pozo viejo de piedra cubierto con reja oxidada.
Flags: `zafran_seen_full`, `sora_old_wound_visible`.

**SORA.** Aquí.
**SORA.** Sale de ahí.
**SORA.** Cuando salga, será grande. Más que todo lo que has visto.
**SORA.** Va a tener dos valores distintos. Denominadores diferentes. Tú y yo los vamos a fusionar.
**SORA.** Yo uno. Tú otro.
**SORA.** Como en los puentes con Rexán.
**SORA.** Si fallas, no pasa nada. Yo fusiono los dos. Pero va a tardar más. Y va a doler más.
**SORA.** Atrás.

*Reja tiembla. Salta. Emerge **Zafrán**: altura de una casa, dos cuerpos conectados por línea de luz densa. Izquierdo **5/7**, derecho **3/11**. Cuerpo agrietado en patrones viejos.*

*Sonido vibrante hace temblar las piedras. Respiración de Sora se acelera. Rabia, no miedo.*

**SORA.** Hola, Zafrán.
**SORA.** Sí. Me acuerdo.

*Saca pequeña marca vieja, oxidada, del bolsillo. La aprieta.*

**SORA.** [casi para sí] Esta es por Rexán.

*Corte a negro.*

---

## 2.13 — El combate

Habilidades: **FR.16, FR.17, DIV.07**, resistencia sostenida.
Flags: `defeated_zafran_first`, `zafran_escaped`.

*Jugador amplifica 5/7 a 55/77. Sora amplifica 3/11 a 21/77. Fusión → **76/77**. Casi un Uno. Combate de desgaste.*

**SORA.** Amplifica.
**SORA.** Bien.
**SORA.** Otra vez.
**SORA.** Sigue. No pares.
**SORA.** ¡Ahora!

*(Única vez que Sora exclama con signo de exclamación real en todo el arco.)*

*Zafrán solo emite el sonido vibrante, cada vez más débil. A mitad del combate lanza onda de distorsión. Sora no esquiva. Golpe en pierna izquierda. Cae de rodillas.*

*Se levanta. Cojea.*

**SORA.** [voz ronca] Sigue.

*El niño sigue atacando. Zafrán se hace pequeño. Al llegar a ~**1/16**, **escapa** al pozo con chirrido. Reja cae con golpe seco.*

*Silencio. Sora se limpia la cara con el dorso de la mano.*

**SORA.** [muy baja] Se va.
**SORA.** Otra vez.
**SORA.** Pero le hemos hecho daño.

*Algo en su cara más abierto que nunca.*

**SORA.** Lo has hecho bien.
**SORA.** Muy bien, {nombre}.

*(Primera vez que Sora usa "muy" en el juego.)*

---

## 2.14 — Después

Sora sentada en el suelo contra el pozo, mano en rodilla izquierda.
Flags: `sora_vulnerable_moment`.

**SORA.** No es grave.
**SORA.** Solo el golpe. Mañana estará.

*Saca pequeña marca vieja, la mira, la aprieta.*

**SORA.** Esta era de alguien.
**SORA.** De mi maestra. Antes de Irune.

- [A] *"¿Qué le pasó?"* → *"Lo mismo que a Rexán, más o menos."* */ *"Peor."*
- [B] *"¿Fue Zafrán?"* → instante de sorpresa: *"No."* */ *"No. Eso fue otra cosa. Otra ciudad."*
- [C] silencio, quedarse con ella → asiente despacio, cierra los ojos un momento: *"Gracias."*

**SORA.** Ayúdame a levantarme.

*Acepta la mano más tiempo del necesario. Cojea dos o tres pasos. Recupera su ritmo. Silencio en el camino.*

---

## 2.15 — Rexán espera

Al volver, Rexán apoyado en el muro de la entrada con bastón.
Flags: `rexan_gratitude_moment`.

*Sora se queda atrás dando espacio.*

**REXÁN.** A ver. Enséñame.

*El niño muestra la marca de Aprendiz II con un nuevo filete azul (señal de haber sobrevivido a un combate contra un Fragmento nombrado, puesto por Irune off-screen).*

**REXÁN.** Bonita.
**REXÁN.** La mía también la tiene.

*Se abre el cuello: su marca con varios filetes azules, algunos viejos, uno muy desteñido.*

**REXÁN.** Gracias.

*(Palabra inusual en boca de Rexán.)*

**REXÁN.** Sora.
**SORA.** [ronca] Rexán.

*(Intercambio enorme en pocas palabras.)*

**REXÁN.** Sube. Irune quiere verte.
**REXÁN.** Y duerme, {nombre}. Mañana es otro día y hoy ya estuvo.

*Al entrar, Rexán y Sora se quedan fuera juntos, sin hablar. Solo estando.*

---

## 2.16 — Los Canales en silencio

Cierre del arco. Azotea. Borde norte, mirando a los Canales. Niebla disipada, luces quietas reflejadas en el agua.
Flags: `arc2_closed`, `arc3_opening`, `sora_first_personal_word`.

*Sora piernas colgando, como al final del arco 1.*

*Un minuto de silencio.*

**SORA.** Oye.
**SORA.** Cuando era pequeña, en mi ciudad...
**SORA.** ...tenía una ventana que daba a un canal.
**SORA.** Se parece a estos.

*(Primera vez que Sora menciona su ciudad sin cortar.)*

*Mirada breve, vuelve al paisaje.*

**SORA.** No es importante. No sé por qué lo he dicho.

*(Lo es.)*

**SORA.** Mañana, si quieres, puedes bajar al Mercado. Conocer a Naini.
**SORA.** Yo no voy. Ella y yo ya nos conocemos.
**SORA.** Pero tú vas a querer ir. Te va a caer bien.
**SORA.** La ciudad ya es tuya. Todos los distritos.
**SORA.** Bueno. Casi todos. La Montaña no.

*Segunda media sonrisa de Sora.*

**SORA.** Aún.

*Fundido lento.*

**FIN DEL ARCO II. CANALES Y ZAFRÁN.**
**HASTA MAÑANA.**

---

## Notas técnicas

**Dificultad de 2.13**: primer gran combate. Duración esperada 3-4 min. Zafrán **no puede derrotar al niño en el MVP**: si el ki llega a crítico, Sora asume el resto con menor impacto narrativo. Último recurso.

**Cojera de Sora**: persiste exactamente **2 sesiones posteriores** al combate. A la tercera desaparece y no se menciona. Importante para el realismo emocional.

**La marca vieja de Sora**: no se vuelve a ver en MVP. Se referencia en v1.5 cuando Sora cuenta qué fue su ciudad caída. Prop importante para arte.

**Pintada de los Opacos (2.5)**: primera semilla visible del conflicto mayor. En arco 3 aparece otra pintada distinta que Rexán comentará.

**Zafrán no habla**. No palabras ni telepatía. Solo sonido vibrante. Más siniestro, más antiguo.

**Tutor IA — activadores nuevos del arco**:
1. 4+ fallos consecutivos en FR.16 → Rexán en micro-escena, metáfora de jarras: *"Piensa en dos jarras. Una tiene el agua en tercios. La otra en cuartos. Para mezclar, hay que echar todo a una jarra más grande, donde quepa bien medido todo."* Máx 3 frases.
2. Si el niño pide repetir combate vs Zafrán tras 2.13, voz de Irune: *"No vuelve tan pronto, {nombre}. Hay que esperar."*

**Pruebas de usuario**: probar 2.12-2.14 con niños y medir si el combate se siente especial. Si es "otro combate más", está mal calibrado. Debe sentirse importante — música distinta, ritmo distinto, final distinto.

---

*Fin del guion — Arco 2 v0.1. Siguiente: Arco 3 — La ciudad entera.*
