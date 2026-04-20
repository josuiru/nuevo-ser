# Uno Roto — Guía Sonora

> Documento creativo-técnico.
> Versión 0.1 — MVP Era 2.
> Complementa biblias (docs 01, 04, 06), guiones (docs 07-10), guía visual (doc 11).

---

## Identidad sonora en una frase

**Lo-fi urbano nocturno con tensión latente: beats bajos, sintetizadores suaves, texturas analógicas vivas, sin eufemismos tristes, sin épica heroica, y silencios largos que hablan.**

Tres descriptores: **contenido, crepuscular, texturado**.

Momento de referencia para toda la banda: cuando Sora dice *"llegas tarde"* en 1.1. Tres segundos de viento y una voz seca. Nada más. **Esa es la frecuencia emocional del juego.**

## Principios sonoros

1. **El silencio es un instrumento.** Una escena solo lleva música cuando añade algo que el silencio no puede.
2. **Ruido ambiente permanente.** El mundo nunca se apaga del todo. Viento, agua, ciudad lejana.
3. **Poca épica, mucha intimidad.** No hay temas heroicos ni fanfarrias. Al derrotar a Zafrán no suena cadencia triunfal — suena el agua.
4. **Texturas analógicas.** La música tiene polvo, hiss, vinilos. Lo-fi + ambient analógico + sidechaining sutil.
5. **Motivos, no temas.** Motivos de 2-4 compases recurrentes, reconocibles sin darse cuenta. No hay temas largos tipo *Zelda*.
6. **Sin voz cantada.** Ninguna canción con letra. Multiidioma + tono introspectivo.
7. **Diálogos sin voz actuada.** Presupuesto + los silencios narrativos funcionan mejor sin voz fija.
8. **Feedback mínimo pero preciso.** Acciones → sonidos discretos, nunca estridentes. **No hay sonidos de castigo**. El error suena más corto y bajo que el acierto. El juego es asimétrico a favor del niño.

## Arquitectura de cuatro capas

| Capa | Contenido | Volumen |
|------|-----------|---------|
| **1** Ambient del mundo | Viento, ruido rosa, agua, murmullos | ≤ -20 LUFS. Casi nunca se apaga del todo |
| **2** Música contextual | Distrito, combate, momentos narrativos | -14 a -12 LUFS |
| **3** Interacción | Taps, gestos, ataques, fusiones | Variable, <30 ms latencia |
| **4** Efectos narrativos | Silbido de Zafrán, voz de Eco, mundo bajando de volumen | Atenúa todas las demás |

Prioridad si hay conflicto: 4 > 3 > 2 > 1.

## Música por distrito

| Distrito | BPM | Tonalidad | Mood | Referencias |
|----------|-----|-----------|------|-------------|
| Tejados | 68-72 | Mi menor modal | Contemplativo, abierto, tiempo detenido | Bonobo, Nujabes, Sakamoto, Nosaj Thing |
| Canales | ~55 libre | Re menor | Melancólico, húmedo, un barrio que recuerda | Hauschka, The Books, Max Richter, Morricone |
| Mercado | 85-95 | Sol mayor con toques frigios | Cálido, vivo, bolsillo de alegría | Buena Vista, C. Tangana, Bebo Valdés, Ibeyi, Chihiro |
| Industria | ~62-68 | Do# modal | Estructurado, reverberante, casi inhumano | Alva Noto + Sakamoto, Tim Hecker, Blade Runner 2049 |
| Puerto | sin tempo | Fa menor | Profundo, solitario, acuático | Deathprod, Biosphere, Chris Watson, Eno |
| Afueras | 72-78 | La mayor con suspensiones | Abierto, respirable, esperanza sin forzar | Ólafur Arnalds, Nils Frahm, Mogwai quietos, Mark Hollis |
| **Montaña** | — | — | **No tiene música propia** en MVP. Solo un **motivo** de 3 notas de cuerda apagada. 5 apariciones concretas. | — |

### Las 5 apariciones del motivo de la Montaña
1. Escena 1.1 — cuando Sora la señala.
2. Escena 1.14 — cierre del Arco 1 viendo los Canales.
3. Escena 3.16 — Brina habla sin nombrarla.
4. Escena 3.17 — Brina la nombra directamente.
5. Escena 4.14 — última del MVP, amanecer. **Aquí se extiende por primera vez en una frase completa de 8 compases en fa mayor.**

La semilla musical más importante del proyecto.

## Música de combate

- **Ritmo firme pero no acelerado.** El niño tiene tiempo de pensar.
- **Progresión suave**, sin clímax hollywoodiano.
- **Sin silencio total durante el combate.** Si el niño para, la música sigue esperándole.
- **Fin del combate**: desvanecimiento en 1-2 s, no acorde triunfal.

Tres niveles:

| Nivel | Contra | BPM | Tonalidad |
|-------|--------|-----|-----------|
| 1 — Cotidiano | Silvestres, A-E básicos | 85-95 | Mi menor |
| 2 — Desafiante | C, D, E, F con denominadores difíciles | 95 | Re menor |
| 3 — Nombrado Kurz | Kurz | 92 | Sol mixolidio (toque travieso — Kurz es tutor) |
| 3 — Nombrado Zafrán | Zafrán | 60 | Re menor (contrabajo en arco, violín que entra y sale) |
| 3 — Nombrado Vorax | Vorax | variable | Do# modal (tictacs desajustados como ritmo, desincronización) |

**Regla crítica**: el acierto no vuelve la música triunfal. El fallo no la ensombrece. Estable siempre. **No condicionar al niño a buscar la aprobación sonora del juego.**

## Música narrativa puntual

### Tema de Sora (motivo)
3 acordes lentos en piano eléctrico + drone grave. 8 segundos. Aparece 3 veces:
1. 1.1 — primeros segundos mientras está de espaldas.
2. 2.14 — saca la marca vieja del bolsillo.
3. 4.13 — *"Mi ciudad se llamaba Kir"*. **La tercera vez se extiende**: dos acordes nuevos que resuelven hacia mayor. **La resolución es el regalo narrativo.**

### Tema de Kai (acorde solo)
Mi menor tensional. 3 segundos. 3 apariciones, siempre cuando Kai está afectado:
1. 1.7 — pasa cerca, mira al jugador una sola vez.
2. 3.5 — se va tras perder el duelo.
3. 3.14 — confiesa lo de su padre.

Casi imperceptible. Pero está.

### Tema de Eco (no-música)
**El mundo bajando de volumen.** Filtro pasa-bajos progresivo sobre capa 1. 2-3s entrada, se mantiene, 2-3s salida.

Acompañamiento:
- Drone agudo casi imperceptible (como tinnitus elegante).
- Durante pausas largas, coro apenas audible sin letra. Un único acorde suspendido.

**En 4.5** (Eco casi aparece y no lo hace): solo bajón + drone. **Sin coro. La ausencia es el mensaje.**

### Tema de ceremonia (1.13 y 4.10)
Solo piano. Modalidad modal suspendida. Progresión lenta con silencios largos entre frases. **Muy austero**. Piano se pausa entre frases ceremoniales de Irune.

Inspiración: Erik Satie *Gnossienne No. 1*, Henry Purcell *When I Am Laid in Earth* (contención aristocrática). **Nunca entra en épica.**

### Amanecer final (4.13 + 4.14)
Última pieza del MVP. 4 minutos atravesando las dos escenas. Piano ceremonial transformado + cuerdas lentas. Durante la confesión de Sora, mínima. Cuando amanece sobre la Montaña, las cuerdas crecen ligeramente **pero nunca a volumen alto**. Incluye la única aparición del motivo de la Montaña extendido.

Termina justo antes del fundido a blanco. Deja 3 segundos de silencio absoluto con solo viento antes de los rótulos.

## Efectos sonoros (capa 3)

### Acciones del jugador
- **Tap**: gota entrando en agua (pequeño clic musical).
- **Cortar**: susurro fino, hoja cortando el aire.
- **Arrastrar Fragmento**: drone grave sostenido, se apaga al soltar.
- **Fusionar (F)**: dos notas graves que se acercan hasta unirse.
- **Equivaler (D)**: armonía perfecta de dos notas, círculo cerrado.
- **Descomponer (C)**: varios percusivos suaves.
- **Atacar**: impacto suave + desvanecimiento.
- **Meditar**: drone continuo creciente, respiración musical.

### Feedback acierto/error
- **Acierto**: cristal rompiéndose suavemente. Musical. Nunca triunfal. Mismo sonido sin importar dificultad.
- **Error**: más corto y más bajo. Un "tump" grave. **No suena mal.** No humilla.

Volumen del error **menor** que el del acierto.

### Combate
- **Ki subiendo**: armónico creciente.
- **Ki crítico**: ambient un punto más grave. Imperceptible consciente. El niño lo siente.
- **Fragmento disolviéndose**: notas altas dispersándose, 0.8-1.2 s.
- **Técnica especial**: firma sonora por técnica (4-6 en el MVP).
- **Fragmento nombrado apareciendo**: nota grave muy larga + sub-bass físico en cascos.

### UI
- **Abrir menú**: whoosh suave.
- **Cambiar**: pequeño clic.
- **Confirmar**: tono armónico amable.
- **Cancelar**: tono medio neutro.
- **Transición**: fade cruzado, nunca corte abrupto.

**Ningún sonido suena a "app educativa".**

### Ambient por distrito (aleatorios baja frecuencia)
- Tejados: viento, pájaro nocturno lejano, campana de iglesia muy lejana cada 10-15 min.
- Canales: goteo, chapoteo, aldabón cerrándose, graznido esporádico.
- Mercado: conversaciones ininteligibles (como aire), monedas, risas distantes.
- Industria: cambio de ritmo de máquina, vapor, puerta metálica lejana, pitido aislado.
- Puerto: olas, crujidos de madera, gaviota, boya, pulso del faro.
- Afueras: grillos, viento en hierba, búho, campana del observatorio muy rara (1/hora).

## Momentos sonoros únicos

### Mujer desorientada (1.3)
Ambient se vuelve un grado más **lento** cuando la mujer se queda parada. <3s, se recupera.

### Silbido de Zafrán (2.10, 2.12, 2.13)
**Sonido único** del MVP.
- 2.5s duración.
- Silbido agudo → baja en tono → se quiebra al final como sonido vocal.
- Textura grave, antigua, inhumana.
- 180-220 Hz fundamental. Sub-bass **muy fuerte**.

Apariciones:
1. 2.10 — muy lejano, casi al borde de lo audible. Rexán reacciona antes.
2. 2.12 — más cercano, más fuerte, con sub-bass sostenido.
3. 2.13 — durante combate. **Pierde su fuerza misteriosa**: ya es un enemigo conocido. Parte del crecimiento del niño.

### Voz de Kurz y Eco
- **Kurz**: dos notas altas moduladas como si hablara. Cada frase trae su melodía de 2 notas. Tenue, casi amigable.
- **Eco**: nota grave con reverb extremadamente largo (varios segundos), empieza antes del texto y continúa después. Voz que viene de lejos.

### Mundo baja de volumen (3.9, 4.5)
Ya descrito en §Tema de Eco arriba.

### Cierre de cada arco
Fórmula sonora:
1. Música de la escena se atenúa 10s.
2. Fundido a negro + silencio absoluto 2s.
3. Un solo acorde de piano suave bajo el texto.
4. Silencio 2s más.
5. Aparición del botón "HASTA MAÑANA" con suspiro musical breve.

**Excepción**: fin del arco 4 (fin del MVP) extiende el punto 3 al motivo completo de la Montaña en cuerdas. Única vez con música propia desarrollada en este momento.

### Primera sonrisa de Sora (1.6)
Al decir *"La cuarta gané"*, entra durante 3 segundos **solo el motivo de Sora** por primera vez. El niño no lo reconocerá todavía. Pero está.

### Cena que no se ve (1.11)
**Sin música.** Solo ambient: conversación lejana, perro muy lejos, coche raro pasando, platillo de bar cerrando. **Tiempo robado al mundo**.

### Concha de Oryn (4.3)
Cuando abre la bolsa, **1 segundo de silencio absoluto** (incluido ambient) antes del sonido del gesto. Pausa narrativa sonora. Marca el momento.

### "Mi ciudad se llamaba Kir" (4.13)
Todos los sonidos se **atenúan un punto** durante 2-3s. No se apagan. Subrayado sonoro mínimo para enfatizar la palabra **Kir**.

## Tutor IA

Cuando interviene:
- Ambient y música **atenúan** 3 dB.
- **Whoosh suave** de 400 ms entrada.
- Texto del tutor con el sonido de frase del personaje (Sora, Rexán...).
- Al cerrar, otro whoosh y vuelta a nivel normal.

Consistencia: el niño reconoce que algo distinto ocurre, y el tutor se siente **parte del mundo**, no un parche.

## Accesibilidad sonora

- **Subtítulos de sonidos significativos**: *"[Música suave de piano empezando]"*, *"[Silbido grave y largo en la distancia]"*, *"[El mundo se vuelve silencioso]"*.
- **Control por capas**: Música / Efectos / Ambient / Narrativos independientes 0-100%.
- **Modo sin sonido**: juego **completamente jugable** sin sonido. Todas las señales tienen equivalente visual.
- **Sensibilidad sensorial**: capa 4 al 50%, silbido de Zafrán más corto sin sub-bass, combate más suave, rampas más largas. No cambia el sabor — solo suaviza las puntas.

## Tabla técnica de producción

| Pieza | BPM | Tonalidad | Duración | Formato |
|-------|-----|-----------|----------|---------|
| Loop Tejados | 68 | Mi menor modal | 3:00 | Seamless |
| Loop Canales | ~55 libre | Re menor | 3:30 | Seamless |
| Loop Mercado | 90 | Sol mayor | 2:45 | Seamless |
| Loop Industria | ~65 libre | Do# | 3:30 | Seamless |
| Loop Puerto | sin tempo | Fa menor | 4:00 | Drone |
| Loop Afueras | 75 | La mayor | 3:15 | Seamless |
| Combate nivel 1 | 90 | Mi menor | 2:00 | Loop |
| Combate nivel 2 | 95 | Re menor | 2:30 | Loop |
| Combate Kurz | 92 | Sol mixolidio | 2:00 | Loop |
| Combate Zafrán | 60 | Re menor | 3:00 | Linear |
| Combate Vorax | variable | Do# modal | 3:30 | Linear |
| Tema Sora (motivo) | 60 | Sol menor | 0:08 | Sample |
| Tema Kai (acorde) | — | Mi menor tensional | 0:03 | Sample |
| Motivo Montaña | 70 | Fa mayor | 0:06 | Sample |
| Ceremonia | 50 | Mi menor modal | 2:00 | Linear |
| Amanecer final | variable | Fa mayor | 4:00 | Linear |

Entrega: **WAV 44.1kHz 16-bit** para Flame/Flutter. Loops con punto de bucle perfectamente alineado sin clicks. Capas ambientales en archivos separados.

## Prompts abreviados para IA musical

Evitar en prompts: "epic", "powerful", "big", "heroic", "dramatic swells".

Incluir: BPM, tonalidad, duración, "no vocals" explícito, referencias a compositores, adjetivos precisos ("contemplative", "restrained", "intimate", "sparse").

- **Tejados**: Lo-fi chillhop 68 BPM, Rhodes in E minor modal, granular pad, sub bass every 30s, tape hiss, 3:00 seamless, Bonobo meets Nujabes meets Sakamoto, no vocals.
- **Canales**: Ambient no tempo, bowed contrabass in D minor, very long reverb pad, water textures, distant muted accordion, 3:30 loop, melancholic foggy alleyway, Max Richter meets Hauschka, no vocals.
- **Mercado**: Mediterranean world fusion 90 BPM, muted hand percussion, nylon guitar fingerpicking, accordion, 2:45 seamless, G major with phrygian, bustling but not hectic night market, Buena Vista meets Spirited Away, no vocals.
- **Industria**: Ambient industrial, drones and metal textures, modular synth with long reverb, distant off-beat clock ticks, C# modal, 3:30 seamless, abandoned factory at night, Alva Noto + Sakamoto + Tim Hecker, no vocals.
- **Puerto**: Minimalist ambient drone, no tempo, F minor sustained pad, hydrophone textures, lighthouse pulse every 8s, piano note once per minute, 4:00 loop, lonely harbor, Deathprod meets Biosphere, no vocals.
- **Afueras**: Ambient folk 75 BPM, fingerpicked guitar in A major, solo violin with reverb, crickets and wind, 3:15 seamless, open grassy field under stars, Ólafur Arnalds meets Nils Frahm, no vocals.
- **Combate cotidiano**: Lo-fi hip hop 90 BPM, soft sidechained kick, deep bass, gentle hats, minimal melodic in E minor, 2:00 loop, doesn't demand attention, Nujabes Aruarian Dance but stripped down, no vocals.
- **Combate Zafrán**: 60 BPM, D minor, slow bowed contrabass melancholy, sparse ritual percussion, violin in and out, rising tension without breaking into epic, 3:00 linear (presencia, confrontación, retirada), Max Richter meets Hildur Gudnadottir, no vocals.
- **Motivo Sora**: Solo Rhodes, 60 BPM, three G minor chords spread wide, low drone, 8 seconds, intimate, Studio Ghibli meets Nils Frahm, no percussion.
- **Ceremonia**: Solo piano 50 BPM, E minor modal suspended, spacious with silence between phrases, austere not triumphant, 2:00, Erik Satie Gnossienne meets Purcell restraint, no other instruments, no percussion.
- **Amanecer final**: Cinematic ambient, sparse piano in F major slowly building to warm strings at minute 2, three-note motif appearing in full phrase at climax, 4:00 linear, emotional but restrained, Ólafur Arnalds meets Sakamoto meets Max Richter, no vocals, no percussion.

## Checklist sonora pre-integración

- ¿Capa 1 ambient adecuada al distrito?
- ¿Música (capa 2) respeta el tono de la escena?
- ¿Silencios intencionados donde deben estar?
- ¿Efectos (capa 3) correctos y no intrusivos?
- ¿Sin sonidos de castigo?
- ¿Acierto equivalente a error sin reforzar ansiedad?
- ¿Volúmenes relativos cumplen la jerarquía?
- ¿Subtítulos para sonidos significativos?
- ¿Escena jugable sin sonido?
- ¿Modo sensorial reducido funciona?
- ¿Loudness targets LUFS por capa?

---

*Fin de la guía sonora v0.1.*

*Nota al compositor: si te sumas al proyecto, empieza por biblia narrativa (doc 06) y guiones (docs 07-10) antes que esta guía. El sonido de Uno Roto emerge de sus personajes y momentos. Si entiendes a Sora ya sabes cómo suena su motivo. Si entiendes la escena 4.13 ya sabes que ahí casi no debe haber música. La técnica es menos importante que la comprensión del mundo.*
