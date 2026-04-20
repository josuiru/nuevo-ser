# Uno Roto — Guion del MVP

## Arco 1 — El Reclutamiento

> Documento creativo.
> Versión 0.1 — Arco 1 de 4.
> Cubre: de Aprendiz I a Aprendiz III. 4-6 semanas de juego real.
> Leer con biblia narrativa (doc 06) y biblia de personajes (doc 04) a mano.

---

## Convenciones

- Diálogo prefijado con personaje en VERSALITAS.
- Acotaciones en *cursiva*.
- Opciones del jugador como `[A]`, `[B]`, `[C]`. Si afectan a la respuesta, se especifica.
- Silencios escritos: `[silencio]` o `[silencio largo]`.
- Plantillas de género: `{nombre}`, `{él/ella}`, `{o/a}`.

## Tabla de escenas

| # | Título | Cuándo | Duración |
|---|--------|--------|----------|
| 1.1 | El tejado | Primer arranque | ~90 s |
| 1.2 | La primera ventana | Tras 1.1 | ~60 s |
| 1.3 | El callejón | Tras 1.2 | ~60 s |
| 1.4 | Irune | Tras 1.3 | ~75 s |
| 1.5 | Kurz aparece | Tras 1ª sesión | ~90 s |
| 1.6 | La derrota | Tras 1.5 | ~75 s |
| 1.7 | Kai visto de lejos | Tras 3-5 sesiones | ~45 s |
| 1.8 | Entrenar con Sora (recurrente) | 4-6 veces | ~60-90 s |
| 1.9 | Los Plenos | Al dominar B2 | ~75 s |
| 1.10 | Segunda derrota de Kurz | Tras 2-3 entrenamientos | ~90 s |
| 1.11 | La cena que no se ve | Tras 1.10 | ~60 s |
| 1.12 | Kurz vencido | Umbral técnico | ~120 s |
| 1.13 | Las palabras de Irune | Tras 1.12 | ~90 s |
| 1.14 | Los Canales desde arriba | Cierre | ~75 s |

Total: ~18 minutos narrativos distribuidos en 4-6 semanas.

---

## 1.1 — El tejado

Activa: primer arranque tras crear perfil + evaluación inicial.
Lugar: Edificio de los Tejados, azotea principal. Noche azul-violeta. Azula abajo.
Personajes: Sora, {nombre}.
Flags: `met_sora`, `seen_rooftops`, `seen_city_azula`.

*Negro. Silencio. Viento. Fundido lento: azotea desde arriba, noche azul-violeta, dos lunas entre neblina. Abajo Azula: luces naranjas y verdes, vapor. Centro de azotea, figura de espaldas. Pelo oscuro, cazadora negra.*

**SORA.** Llegas tarde.
**SORA.** [medio en voz baja] Siempre llegáis tarde.

*Se gira despacio. Ojos más viejos que sus 13 años.*

**SORA.** {nombre}, ¿verdad?
**SORA.** Mm.

*[silencio 2s]. Señala con la barbilla al horizonte: silueta enorme, una montaña oscura.*

**SORA.** Eso es la Montaña. Hoy no.
**SORA.** Vale. Escucha. No te lo voy a decir dos veces.
**SORA.** Esta ciudad tiene Fragmentos. Los Fragmentos se comen cosas que no se ven. Nosotros los cazamos.
**SORA.** Te acabas de alistar. No sabes lo que haces. Tranquilo, nadie lo sabe al principio.
**SORA.** Yo voy a enseñarte.
**SORA.** ¿Vienes a entrenar, o has venido a mirar?

- [A] *"Vengo a entrenar."* → *"Bien."*
- [B] *"No sé muy bien qué hacer."* → *"Ya lo verás. Sígueme."*
- [C] silencio → tras 3s: *"Vale. Sígueme y miras."*

*Aparece flotante: **AZULA — EDIFICIO DE LOS TEJADOS**.*

---

## 1.2 — La primera ventana

Activa: tras 1.1. Azotea contigua con Fragmento Pleno (esfera blanca pulsante).
Personajes: Sora, {nombre}. Habilidad: **FR.01**.
Flags: `first_skill_fr01`, `first_fragment_a_seen`.

**SORA.** Eso.
**SORA.** Eso es un Fragmento. Pequeño. Inofensivo, casi.
**SORA.** Es un Pleno. Vale uno. Un entero. ¿Ves?

*Sobre él, el número **1**.*

**SORA.** Dividirlo es romperlo en partes iguales. Prueba.

*Tutorial gestual: deslizar para dividir en dos → dos mitades **1/2**.*

**SORA.** Bien.
**SORA.** Un medio. Eso es un medio.

*Toca una → se disuelve en partículas. Toca la otra → también.*

**SORA.** Se llama desfragmentar.
**SORA.** No los matas. Los vuelves al sitio del que salieron.
**SORA.** Vamos.

---

## 1.3 — El callejón

Activa: tras 1.2. Callejón trasero, farola amarilla. Transeúnte al fondo.
Habilidades: FR.01, FR.05 mínima. Flags: `seen_street_level`.

*Gato cruza. Mujer mayor parada frente a una puerta, desajustada.*

**SORA.** [voz baja] Mira.
**SORA.** Lleva así un rato. No recuerda por qué ha venido.
**SORA.** Eso pasa cuando hay Fragmentos cerca. No muchos. No fuertes. Pero suficientes.
**SORA.** Por eso los cazamos.

*Mujer se va. Se mueve bien; solo desajustada un poco.*

**SORA.** ¿Preguntas?

- [A] *"¿Se va a poner bien?"* → *"Seguramente. Los Fragmentos de aquí son pequeños. Se le pasa en una hora."*
- [B] *"¿Cuántos Fragmentos hay?"* → *"Muchos. Siempre."*
- [C] *"¿Ella sabe?"* → *"No. Casi nadie sabe."*
- [D] silencio → tras 3s: *"Vamos. Irune te está esperando."*

---

## 1.4 — Irune

Activa: tras 1.3. Sala interior, luz cálida, libros, puerta con placa "ARCHIVO".
Personajes: Sora, {nombre}, Irune.
Flags: `met_irune`, `seen_archive_door`, `introduced_to_order`.

*Irune sentada en sillón desgastado. Pelo blanco, chaqueta gris, marca de plata al cuello.*

**IRUNE.** Llegas. Pasa.
**IRUNE.** [medio para sí] Bien.
**IRUNE.** Soy Irune. Esta es mi casa, y también la tuya ahora, si te lo tomas en serio.
**IRUNE.** Sora te va a enseñar. Es la mejor que tengo ahora mismo. No se lo digas.

*Sora al fondo mira al suelo.*

**IRUNE.** Tres cosas, {nombre}. Escucha.
**IRUNE.** Primera. Aquí nadie sabe más de lo que sabe. Si alguien te dice que lo sabe todo, desconfía. Aunque sea yo.
**IRUNE.** Segunda. Los Fragmentos no son enemigos. Son pedazos de algo que se rompió. Los desfragmentamos. Eso es todo.
**IRUNE.** Tercera. Si te cansas, paras. Si necesitas irte, te vas. Esto no es una cárcel.
**IRUNE.** Vete con ella ya. Yo tengo cosas que hacer.

*Al salir, Sora casi sin girarse:*

**SORA.** Cae bien, Irune. Cuando quiere.

---

## 1.5 — Kurz aparece

Activa: tras primera sesión completa (4-5 combates B2/B3).
Personajes: Sora, {nombre}, **Kurz**. Habilidades: FR.01, FR.05, FR.14.
Flags: `met_kurz`, `first_combat_kurz`.

**SORA.** Mejor.
**SORA.** No tan mal.
**SORA.** Vale. Hoy tienes un regalo.

*Silbido. Del cielo baja Kurz: Fragmento grande humanoide con brazos largos, cabeza redonda. Valor **3/4**. Cruza los brazos. Tiene ojos.*

**KURZ.** [voz telepática] Otro.
**KURZ.** Pequeño.

**SORA.** [voz baja] Es Kurz. Lleva aquí más tiempo que yo. Es un Fragmento nombrado. No se disuelve — se retira y vuelve.
**SORA.** Sirve para poneros a prueba. No es malo.
**SORA.** Pero es mejor que tú. Todavía.

**KURZ.** ¿Empezamos?

*Combate tipo C compuesto, 3/4 en tres cuartos. Calibrado a derrota.*

**KURZ.** Muy lento.
**KURZ.** Otra vez mal.
**KURZ.** Tenías que haberlo visto venir.

*Al ki 0, Kurz se acerca y con calma:*

**KURZ.** Ya está. No pasa nada.

---

## 1.6 — La derrota

Activa: tras 1.5. Misma azotea. Escena post-combate emocional.
Flags: `lost_first_combat`, `narrative_rank_path_open`.

*Negro 1s. Jugador sentado. Kurz se aleja volando. Sora tiende la mano.*

**SORA.** Bien.
**SORA.** En serio. Bien.
**SORA.** La primera vez se pierde. Siempre. Yo también perdí contra Kurz mi primera vez.
**SORA.** Y la segunda.
**SORA.** Y la tercera.

*Primera media sonrisa de Sora en el juego. Cámara se detiene.*

**SORA.** La cuarta gané. Y no se olvida.
**SORA.** Kurz va a volver. Cuando estés listo, vuelves tú a él. Y le ganas.
**SORA.** ¿Lo pillas?

- [A] *"Sí."* → asiente una vez.
- [B] *"¿Y si no puedo?"* → *"Puedes. No hoy. Pero puedes."*
- [C] silencio → tras 3s: *"Vale. Vamos a descansar."*

*Aparece por primera vez el botón **HASTA MAÑANA**. Cierre suave.*

---

## 1.7 — Kai visto de lejos

Activa: sesión 3-4 tras 1.6 (7-10 días). Pausa en punto elevado.
Flags: `seen_kai_first_time`.

*Otro aprendiz entrena en solitario a 30 metros. Se mueve con soltura.*

**SORA.** Ese es Kai.
**SORA.** Lleva cuatro años entrenando.
**SORA.** Es bueno.

*Kai termina, se echa la mochila, pasa cerca. Asiente mínimamente a Sora — saludo profesional. Al jugador lo mira un segundo, sin sonrisa, solo **registrando**. Sigue bajando.*

**SORA.** Él va dos rangos por delante.
**SORA.** Algún día te lo vas a encontrar de verdad.

*Ofrece cantimplora.*

**SORA.** Bebe. Toca otra ronda.

---

## 1.8 — Entrenar con Sora (plantilla recurrente, 4-6 variantes)

Activa: entre 4 y 6 veces durante el arco 1. Contador `training_sessions_with_sora++`.

**A — Noche despejada.**
**SORA.** Arriba. Abajo. Arriba. Abajo.
**SORA.** Céntrate.
**SORA.** Cuando se parte un Fragmento, no pienses en las partes.
**SORA.** Piensa en el **tamaño** de cada parte.
**SORA.** Las partes pequeñas son más fáciles. Siempre.
**SORA.** Otra vez.

**B — Niebla.**
**SORA.** Días así, hay más Fragmentos.
**SORA.** No sé por qué. Irune dice que la niebla les gusta.
**SORA.** Mantente cerca.
*(combate más corto)*
**SORA.** Hoy no más. Mañana.

**C — Lluvia ligera.**
**SORA.** Si te caes, te caes. No pasa nada.
**SORA.** Cae mejor.
*(risa corta, solo sonido)*
**SORA.** Vamos.

**D — Pregunta del jugador (Montaña visible).**
- [A] *"¿Qué hay allí?"* → *"Un Algebrista. O eso dicen."* / *"Fragmentos. Vamos."*
- [B] *"¿Por qué entrenas tanto?"* → *"Porque no quiero llegar tarde."*
- [C] *"¿Tú de dónde eres?"* → *"Otro día."*

**E — Comentario de Sora tras buen entrenamiento.**
**SORA.** Oye.
**SORA.** Aprendes rápido.
**SORA.** No te lo creas mucho.
**SORA.** [bajando las escaleras] Hasta mañana.

---

## 1.9 — Los Plenos

Activa: domina FR.05 en Competente. Azotea nueva al norte.
Habilidades: FR.05, **FR.14**. Flags: `unlocked_fr14_narrative`.

*5 Fragmentos orbitando: 3 medios (1/2) + 2 tercios (1/3).*

**SORA.** Mira.
**SORA.** ¿Cuántos medios ves?

- [A] *"Tres."* → *"Bien."*
- [B] *"Cinco."* → *"No. Cinco son todos. Tres son los medios."* / *"Otra vez."*

**SORA.** Si sumas los tres medios...
**SORA.** ¿Cuánto tienes?

*Interfaz: `1/2 + 1/2 + 1/2 = ?`. Respuesta correcta **3/2**.*

**SORA.** Tres medios. Más de uno entero.

*Los tres medios se fusionan en un Fragmento Impropio **3/2**. Primer Impropio que ve el niño. Se "desborda".*

**SORA.** Cuando pasa de uno, se llama impropio.
**SORA.** Son más grandes. Más trabajo.
**SORA.** Pero aún no. Hoy, solo practica la suma.

---

## 1.10 — Segunda derrota de Kurz

Activa: tras 2-3 entrenamientos post 1.6. Valor **5/6**.
Habilidades: Familia C, FR.14. Flags: `second_combat_kurz`.

**KURZ.** Otra vez.
**KURZ.** A ver.

*Combate. Derrota probable pero posible victoria.*

**Si pierde** (esperado):
**KURZ.** Casi.
**KURZ.** Otra vez la semana que viene.
**SORA.** Has durado más.
**SORA.** Bastante más.
*(le pone la mano en el hombro un instante, la aparta rápido)*

**Si gana** (raro):
**KURZ.** Vaya.
**KURZ.** Tú ya eres otra cosa.
**SORA.** Mm.
**SORA.** Has ganado.
**SORA.** [casi sin querer] No suelen ganar la segunda.
**SORA.** Irune querrá verte.

---

## 1.11 — La cena que no se ve

Activa: tras 1.10. Calle de Azula, plaza pequeña con mesa fuera de bar cerrado pero iluminado.
Flags: `sora_shared_food`, `first_street_scene`.

**SORA.** Come.

*Mastican en silencio. Pareja pasa riéndose. Sora los mira un instante.*

**SORA.** No todo es entrenar.
**SORA.** Aunque lo parezca.

*Silencio cómodo, 1 minuto jugable. Sora termina primero, mira al cielo, dos lunas.*

**SORA.** [para sí] Las dos esta noche.

- [A] *"¿Y cuando no están las dos?"* → *"Eso es otro tema. Come."*
- [B] silencio → al terminar, se levanta. *"Vamos. Duermes mucho mejor si entrenas antes."*

*Deja dinero en la mesa — detalle pequeño.*

---

## 1.12 — Kurz vencido

Activa: Aprendiz II + FR.14 Competente. Umbral técnico del arco.
Azotea atardecer (única escena con luz distinta). Valor Kurz **7/8**. Irune al fondo, primera vez que sale a ver.
Flags: `defeated_kurz`, `rank_aprendiz_ii_confirmed`.

**SORA.** Hoy.
**SORA.** Hoy estás listo.

*Silba. Kurz baja. Azotea tiembla un poco.*

**KURZ.** Ah.
**KURZ.** Te noto distinto.
**KURZ.** Vamos.

*Combate adaptativo 90-150s. Al vencer, Kurz se retira haciéndose pequeño.*

**KURZ.** [desde arriba] Nos veremos cuando seas Iniciado.

*Sora asiente una vez, muy despacio.*

**SORA.** Ya está.
**SORA.** Ya eres algo más que un aprendiz.

*Mira a Irune. Irune asiente de lejos. Entra.*

---

## 1.13 — Las palabras de Irune

Activa: tras 1.12. Misma sala que 1.4, luz más cálida.
Flags: `rank_ceremony_i_to_ii`, `canales_unlocked`.

**IRUNE.** Siéntate.
**IRUNE.** No te voy a felicitar. Sora tampoco. No es nuestro estilo.
**IRUNE.** Pero lo que has hecho es real.
**IRUNE.** La gente habla de rangos como si fueran diplomas. No lo son. Son **responsabilidades**.
**IRUNE.** Ahora eres Aprendiz II. Eso quiere decir que puedes salir del Edificio de los Tejados sin que Sora vaya detrás. Puedes bajar a los otros distritos. Vas a hacerte amigos, enemigos, dudas. Sobre todo dudas.
**IRUNE.** Mañana puedes bajar a los Canales. Si quieres. O no. Tú decides.
**IRUNE.** Y una cosa más.
**IRUNE.** Hace mucho que no ponía una marca de Aprendiz II.

*[silencio — que respire]*

**IRUNE.** Me alegro de que vuelva a haber alguien que la merezca.

*Le pone marca plateada al cuello con cuerda fina. Parecida a la que Sora lleva cosida dentro del cuello.*

**IRUNE.** Bienvenido, Aprendiz II.

*Sora detrás, mira al suelo, se muerde por dentro del labio — casi imperceptible.*

**IRUNE.** Ya puedes irte. Duerme.

---

## 1.14 — Los Canales desde arriba

Activa: sesión inmediatamente posterior a 1.13. Borde de azotea, noche, vista norte hacia los Canales.
Flags: `arc1_closed`, `arc2_opening`.

*Sora sentada en el borde, piernas colgando, sin miedo. Mira al norte. Abajo: Canales con puentes pequeños iluminados, reflejos amarillos. Ciudad dentro de la ciudad.*

**SORA.** Siéntate.
**SORA.** Allí vas a ir mañana.
**SORA.** Los Canales.
**SORA.** Maestro Rexán.
**SORA.** Va a caerte bien. Es el tipo más simpático de la orden. No te fíes del todo — lo usa.
*(risa corta, sin amargura)*
**SORA.** Tiene una cojera. No preguntes por ella.
**SORA.** Algún día te lo contará {él/ella}. O no. Ya verás.
**SORA.** Tienes que ir solo. Yo te esperaré aquí.
**SORA.** Sí. Solo.
**SORA.** No te asustes. Rexán es buena gente. Y tú ya no eres tan nuevo.

*Le ofrece una pequeña brújula de bolsillo. No mágica, solo una brújula.*

**SORA.** Toma. Era mía cuando empecé aquí.
**SORA.** Devuélvemela cuando vuelvas.

*Mira otra vez hacia los Canales. Viento. Fundido lento.*

**FIN DEL ARCO I. EL RECLUTAMIENTO.**
**HASTA MAÑANA.**

---

## Notas técnicas

**Pausa narrativa**: tras cerrar arco 1, no cargar arco 2 en la misma sesión. El cierre amable es cierre real. Se abre los Canales en la **siguiente** sesión.

**Decisiones persistentes**:
- Silencio reiterado ante Sora → en arco 3 comenta *"Hablas poco. Me gusta."*
- Pregunta sobre la Montaña (variante D) → Brina en arco 4: *"Hace tiempo que querías saber esto."*

**Tutor IA activadores del arco 1**:
1. 4+ fallos consecutivos en FR.05 → intervención Sora explicando sin paternalismo, máximo 3 frases.
2. 40s sin interacción en diálogo → línea pre-escrita: *"¿Sigues ahí?"* (no es IA, es static).

**Voces de Fragmentos**: Kurz es el único Fragmento con "voz" del arco. Texto telepático-imaginario, no oral. Fuente visualmente distinta a la de humanos — más abierta, susurrada.

**Pruebas de usuario antes del lanzamiento**:
1. Al final del arco: ¿puede el niño contar con sus palabras qué pasó? ¿Describir a Sora, Irune, Kurz sin prompt?
2. ¿Quiere seguir? Pregunta honesta: *"¿Volverías mañana?"* — afirmativa en ≥4/5 niños.

Si no, iterar antes de arcos 2-4.

---

*Fin del guion — Arco 1 v0.1. Siguiente: Arco 2 — Canales y Zafrán.*
