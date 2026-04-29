# El Cuaderno — Propuesta de incorporación a la Colección Nuevo Ser

> Documento de Fase 1 — Aceptación filosófica.
> Versión 0.1 — para presentación al equipo editorial.
> Conforme al §8 de `coleccion-nuevo-ser-criterios-de-integracion.md`.
> Extensión: ~5 páginas.

---

## 1. Identidad básica

| Campo | Valor |
|---|---|
| Nombre provisional | **El Cuaderno** |
| Materia escolar | Conocimiento del Medio Natural (LOMLOE primaria, ciclos 2 y 3); pre-Biología y pre-Ecología |
| Edad objetivo | 9 a 13 años |
| Formato | App móvil (Android, iOS) + componente web para la vista del cuidador y vista del aula |
| Modelo | **No narrativo**. Sin protagonista, sin mundo ficticio, sin arcos. Herramienta de oficio digital |
| Idiomas v1 | Castellano, euskera, catalán |
| Lecturas previas del proponente | Manifiesto de la Colección, Criterios de integración, *Educar para el Nuevo Ser*, *La Tierra que Despierta*, biblias de Uno Roto y Las Versiones |
| Documentos que acompañan a esta propuesta | `el-cuaderno-01-biblia.md` (biblia maestra), `el-cuaderno-04-voces-y-figuras.md` (voces del sistema), `el-cuaderno-prompt-claude-code.md` (prompt de bootstrap técnico) |

## 2. La tesis de la propuesta

La materia escolar de El Cuaderno es lo que en LOMLOE figura como Conocimiento del Medio Natural y lo que coloquialmente se llama "ciencias naturales". El juego deliberadamente no usa la palabra *naturaleza*, porque esa palabra presupone separación entre quien observa y lo observado — y el libro *La Tierra que Despierta* es una argumentación sostenida contra esa premisa.

Esa decisión filosófica genera una decisión de forma: **el juego no debe inventar un mundo de naturaleza al que el niño visita, sino ayudar al niño a habitar el lugar real donde está**. De aquí sale el modelo no narrativo. Una protagonista ficticia que recorre un valle ficticio reproduciría exactamente el patrón que el libro denuncia: convertir lo vivo en algo *otro* que el niño visita en una pantalla, en vez de algo que es, aquí, donde vive.

El juego es por tanto una **herramienta de campo digital con alma pedagógica**: un cuaderno personal, un sit spot real, observaciones del entorno real del niño, Misterios contextualizados a su lugar y su estación, y un Tutor IA limitado por reglas. La materia escolar aparece sin disfraz — el oficio del niño que mira despacio el lugar donde vive — y la "segunda capa" pedagógica que el manifiesto exige (no enseñar solo la materia sino cómo pensar bien dentro de ella) se encarna en tres dispositivos:

1. **Niveles de confianza explícitos**: consenso / hipótesis activa / abandonado.
2. **Separación estructural entre observación e interpretación**: la pantalla obliga a anotar *qué viste* antes de proponer *crees que es*.
3. **Honestidad sostenida del "no sé"**: el sistema honra la indecisión como respuesta legítima del oficio.

## 3. Identidad "narrativa": cómo se sostiene sin narrativa

El §8 del documento de criterios pide describir la "identidad narrativa". El Cuaderno la tiene, pero negativa: su identidad es la **ausencia deliberada de ficción intermediadora**. Esa ausencia se sostiene con tres elementos:

**El cuaderno como objeto.** No es un mundo, no es una historia — es un objeto con voz. Un cuaderno tiene tipografía, tiene ritmo, tiene márgenes, tiene microcopia. Un cuaderno respeta a quien lo usa o no le respeta. La calidad de la presencia del cuaderno hace lo que en otros juegos hace la calidad del mundo ficticio. Detalles operativos en `el-cuaderno-04-voces-y-figuras.md` §2.

**El sit spot como dispositivo de habitación.** El niño elige al inicio un lugar real al que va a volver muchas veces. La app no le obliga: le acompaña en ese compromiso. El sit spot reemplaza estructuralmente la función que en Uno Roto cumple la ciudad de Azula y en Las Versiones cumple Nafarroa: es el "mundo" del juego, pero es real y es del niño. Esto es una traducción operativa directa del concepto del libro (Parte IV, capítulo *Presencia en la Naturaleza*).

**El Tutor como voz de oficio, no de personaje.** Hay diálogo, pero el interlocutor no es un personaje con historia ni con afecto simulado. Es una bióloga competente que responde y se calla. La voz tiene reglas estrictas (`04-voces-y-figuras.md` §3.2) y declara honestamente sus límites — siguiendo el modelo de las "Notas de Claude" del libro.

Una decisión queda abierta para piloto (sección 10.3 de la biblia): si el cuaderno arranca vacío o si arranca con páginas heredadas de una naturalista anterior anónima. La hipótesis del proponente es que la versión heredada sirve mejor al cold start sin convertir el juego en narrativo, pero la decisión se toma con datos de niños reales, no a priori.

## 4. Cumplimiento demostrable de los criterios filosóficos

A continuación, los diez criterios del §2 del documento de criterios, cada uno con una mecánica o decisión de diseño concreta que lo encarna. Conforme al apartado 2 de los criterios, no basta con declarar adhesión: hay que mostrarlo.

### 4.1 Aplicación del Principio 0

*"¿Lo haría así si fuera para mis propios hijos?"*

Tres ejemplos donde el test cambió la propuesta:

- **Cambio del modelo narrativo al no narrativo.** La propuesta inicial era un juego con valle navarro ficticio, protagonista, abuela mentora, vecinos del valle como maestros. Aplicar el test contra el libro produjo: *"yo no querría que mis hijos aprendieran sobre lo vivo a través de una pantalla con un valle inventado mientras existe el valle real donde están"*. El modelo cambió.
- **Eliminación de notificaciones push.** El borrador inicial preveía notificaciones tipo *"hace una semana que no abres el cuaderno"*. Test: *"no quiero que la app le hable a mi hijo cuando él no la ha invitado"*. Se eliminaron todas las notificaciones push. La app espera; cuando el niño vuelve, su sit spot sigue ahí.
- **Decisión sobre el Tutor IA.** Se valoró un Tutor con personalidad cálida y memoria continua. Test: *"yo no quiero que mis hijos confundan una IA con un amigo, ni que una IA construya una "relación" con ellos a base de recordar conversaciones"*. El Tutor quedó sin nombre, sin avatar, sin memoria entre conversaciones, sin afecto simulado.

### 4.2 Resonancia, no adoctrinamiento

El juego trata una materia donde la tentación de adoctrinar es alta: el cambio climático, la biodiversidad en declive, las prácticas humanas dañinas. El juego rechaza explícitamente la postura de cruzada (biblia §9: *"No es un juego ecologista. No hay misión de salvar el planeta"*).

Encarnación concreta: los Misterios pueden incluir el dato de que un fenómeno ha cambiado (*"el año pasado las cigüeñas llegaron el 16 de febrero. Este año el 8"*) y abrir la pregunta *"¿por qué crees que ha cambiado?"*, pero **el juego no responde por el niño**. La voz del Cuaderno no dice *"es por el cambio climático y debemos actuar"*. Si el niño formula esa hipótesis, el sistema la acepta como hipótesis activa. Si formula otra (más calor local, suelta de animales, error de observación), también. El consenso científico está disponible en el Tutor si el niño pregunta, pero no se predica desde la app.

### 4.3 Tratamiento de la incertidumbre

La materia de las ciencias naturales es del **tipo evolutivo** según la rúbrica del §3.2 de los criterios. La biología cambia con la ciencia. El sistema de niveles es por tanto: **consenso actual / hipótesis activa / abandonado**.

Encarnación concreta:

- Cada Misterio lleva su nivel visible.
- Cada identificación que hace el niño lleva su nivel propio (consenso si una clave o el Tutor lo confirman; hipótesis activa por defecto; no estoy segura como tercera opción legítima).
- Hay Misterios deliberadamente abiertos donde la ciencia no tiene consenso. El niño puede pasar meses observando sin "resolverlos". El sistema no oculta una respuesta secreta para compensar.
- El Tutor declara honestamente cuando no sabe (`04-voces-y-figuras.md` §3.4, intercambio 2: *"Cómo lo integran exactamente no está completamente entendido"*).

### 4.4 Sin folklorismo

No hay culturas representadas como estampas porque no hay narrativa. Pero sí hay un punto donde el riesgo aparece: la **localización por territorio**. Un niño de Sevilla aprende sobre encinas y jaras; uno de Donostia, sobre hayas y carbas. Cada localización requiere claves de identificación, ilustraciones y vocabulario adaptados.

Encarnación concreta:

- Las claves de identificación las redactan **biólogas y biólogos del territorio concreto**, no se generan automáticamente de bases de datos genéricas.
- Los nombres comunes locales (incluyendo en euskera y catalán) se documentan con su área geográfica. La app los ofrece sin caer en el "y los antiguos del lugar le decían así, qué bonito".
- Cuando aparece un nombre tradicional, aparece como información del oficio (ejemplo: *"haya · *pago* en euskera occidental, *fago* en aragonés"*), no como decoración pintoresca.

### 4.5 Diversidad sin anuncio

No hay reparto de personajes. Por tanto este criterio se cumple por ausencia. Pero hay tres decisiones donde la diversidad está implícita:

- **El nombre del niño.** El niño elige su nombre o usa el suyo real. La app no asume género, no asume etnia, no asume estructura familiar.
- **La vista del cuidador.** Se llama "cuidador" deliberadamente, no "padre/madre". Acepta uno o más cuidadores; no asume modelo de familia. La vinculación se hace por consentimiento explícito.
- **Las ilustraciones de especies.** Son botánicas y zoológicas. No incluyen humanos. No hay decisiones de representación humana porque no hay humanos representados.

### 4.6 La adolescencia o la infancia son reales

Encarnación concreta: el ritmo del juego respeta que el niño tiene vida fuera. No hay racha que premie sesiones diarias. No hay tiempo de uso "objetivo". El sit spot puede visitarse una vez al mes y eso está bien. Si el niño pasa dos semanas sin abrir la app porque está de campamento, sin acceso a wifi, o porque pasó un examen, no hay penalización ni decay visible. La app espera.

La biblia §6 documenta el pacing: *"Si el niño juega tres días seguidos y luego dos semanas no, no pasa nada. Cuando vuelva, su sit spot sigue ahí."*

### 4.7 Sin moraleja explícita

La voz del Cuaderno tiene vocabulario prohibido (`04-voces-y-figuras.md` §2.3). Está prohibido decir:

- *"La naturaleza es maravillosa"*
- *"Es importante cuidar..."*
- *"Los animales necesitan..."*
- Cualquier juicio estético sobre lo observado.

El test final de cualquier microcopia es: *"¿podría salir esto de alguien que llevara cuarenta años caminando este monte?"*. Las personas que llevan cuarenta años en el monte no moralizan. Observan, registran, dudan, vuelven mañana.

### 4.8 Sin trauma porn

El juego trata, inevitablemente, con el deshilachado del tejido vivo: especies que disminuyen, hábitats que se degradan. Pero no se regodea en el dolor. La encarnación de este criterio es estructural: por cada Misterio doloroso (el de las polillas escasas alrededor de las farolas), hay uno asombroso (el de las setas que aparecen tras la lluvia). El equilibrio entre los cuatro movimientos de la espiral del Trabajo que Reconecta del libro (gratitud, honor del dolor, ver con nuevos ojos, ir adelante) se expresa como **distribución equilibrada de tipos de Misterio**, no como contenido explícito.

La voz del Cuaderno nunca prolonga lo doloroso. Si una observación del niño implica algo perdido (una especie que su abuela observaba en ese mismo lugar y que él ya no ve), la app lo registra con sobriedad y no lo subraya con tipografía emotiva.

### 4.9 Sin paternalismo adulto

El Tutor es la única "voz adulta" del juego. Sus reglas (`04-voces-y-figuras.md` §3) prohíben:

- Presentarse como amigo.
- Usar primera persona afectiva (*"a mí también me encanta..."*).
- Animar (*"¡qué bien que preguntes!"*).
- Resolver por el niño (responde con preguntas que dirigen sin dar la respuesta).
- Pretender saber lo que no sabe.

La voz del Cuaderno (sistema) tampoco infantiliza: registro adulto amable, sin diminutivos, sin apelativos cariñosos, sin emoticonos.

### 4.10 Sin gamificación tóxica

El juego está deliberadamente diseñado contra la gamificación de retención que caracteriza al mercado.

Lo que el juego **no tiene**, por decisión explícita y documentada:

- Sin XP visible.
- Sin niveles desbloqueables.
- Sin rachas.
- Sin notificaciones push para ningún niño (independientemente de la edad — la biblia es más estricta que el manifiesto en este punto).
- Sin recompensas variables tipo casino.
- Sin ranking público entre niños.
- Sin comparación social.
- Sin "logros" coleccionables.
- Sin animaciones de celebración con sonido al completar una observación.
- Sin barras de progreso visibles del Cuaderno.
- Sin contador de días seguidos.
- Sin "amigos" dentro de la app.

Lo que el juego sí tiene como tirón legítimo: el sit spot que se va revelando con las visitas, el cuaderno que se llena con la voz del propio niño, los Misterios que invitan a seguir mirando, el descubrimiento de patrones interanuales. Tirones de oficio, no de psicología conductual.

## 5. Riesgos identificados y honestidad sobre ellos

Tres riesgos que el proponente reconoce abiertamente:

**Riesgo 1 — El cold start.** Los primeros 7-10 días, antes de que el sit spot tenga densidad de visitas y los Misterios estén poblados de observaciones, el juego puede sentirse vacío. Sin narrativa que arrastre, este vacío es más visible que en Uno Roto o Las Versiones. La hipótesis B del cuaderno heredado es la respuesta candidata; hay que validarla en piloto.

**Riesgo 2 — Niños sin acceso fácil al exterior.** El juego presupone un entorno donde el niño puede salir solo o con cuidadores a un parque, jardín, calle arbolada o entorno rural. Niños en contextos urbanos densos sin acceso fácil al exterior pueden tener una experiencia degradada. Mitigaciones posibles: aceptar el patio del cole y el camino a casa como sit spots válidos, integrar especies sinantrópicas (palomas, gorriones, ailanto, hierba de las cunetas) con la misma dignidad que las especies "salvajes". Hay que diseñarlo bien para no convertirlo en un juego solo accesible para clase media con acceso a campo.

**Riesgo 3 — La tentación del "compartir".** Será insistente la presión por integrar con plataformas de ciencia ciudadana (iNaturalist, eBird), por permitir compartir observaciones con compañeros de clase, por tener leaderboards de aulas. Cada una de estas integraciones tiene un caso razonable y todas son violaciones del manifiesto si se introducen sin cuidado extremo. La biblia las deja explícitamente fuera del MVP y como decisión abierta para versiones futuras (§10.5).

## 6. Lo que aún no está y se entrega en fases siguientes

- Mapa de habilidades atómicas (~55 habilidades en 8 dominios) — **Fase 2**.
- Diseño detallado de acompañamiento (vista del cuidador, vista del aula, materiales pedagógicos) — **Fase 2**.
- Diseño técnico de integración con `nuevo-ser-core`, incluido el perfil de medición probablemente híbrido (precisión + rúbrica + cobertura del lugar) — **Fase 3**.
- Política de datos y privacidad específica — **Fase 3**.
- Versión jugable del primer arco para piloto — **Fase 4**.

El alcance del primer sprint técnico (scaffolding) está documentado y listo para ejecución en `el-cuaderno-prompt-claude-code.md`.

## 7. Compromiso de adhesión al manifiesto

El proponente, abajo firmante, declara conforme al §9 del documento de criterios:

1. Haber leído y entendido el manifiesto público de la Colección Nuevo Ser y el documento de criterios de integración.
2. Haber leído el libro *Educar para el Nuevo Ser* y el libro *La Tierra que Despierta*.
3. Haber jugado los juegos existentes de la Colección (Uno Roto en su versión actual de prototipo; Las Versiones en su esqueleto técnico).
4. Estar comprometido con los principios filosóficos, pedagógicos, técnicos, de licencia, de seguridad infantil, de inclusión y accesibilidad declarados en los documentos anteriores.
5. No tener intereses comerciales conflictivos con la Colección. No estar contratado por empresas de adtech orientadas a menores. No tener planes de monetizar el juego mediante publicidad, compras integradas, venta de datos o cualquier otra extracción.
6. Aceptar las revisiones periódicas del juego (cada 12-18 meses) por parte del equipo editorial.
7. Aceptar que la marca "Colección Nuevo Ser" se retire del juego si el juego deja de cumplir criterios, conforme al §8 Fase 5 de los criterios.
8. Asumir el compromiso de mantener el juego funcional durante al menos 5 años desde el lanzamiento, con respaldo del equipo central de la Colección si el equipo proponente no puede.
9. Mantener el código bajo licencia AGPL-3.0 y el contenido bajo CC-BY-SA 4.0 desde el primer commit.
10. Aceptar que esta propuesta puede ser rechazada con razones documentadas, en cuyo caso el proponente queda libre para hacer el juego independientemente sin la marca de la Colección.

Firmado:

> ............................................
>
> [Nombre del proponente]
>
> Fecha: _______________
>
> Lugar: _______________

## 8. Anexos

- **Anexo A — Biblia maestra del juego.** Documento `el-cuaderno-01-biblia.md`.
- **Anexo B — Voces y figuras del juego.** Documento `el-cuaderno-04-voces-y-figuras.md`.
- **Anexo C — Prompt maestro para Claude Code (bootstrap).** Documento `el-cuaderno-prompt-claude-code.md`.
- **Anexo D — Sketches de pantallas.** Pantalla principal del Cuaderno y pantalla de Nueva Observación, disponibles en mockup HTML y en imagen de respaldo.

## 9. Lo que el proponente solicita del equipo editorial

Conforme a §8 Fase 1 de los criterios:

1. **Lectura de los anexos A y B**, que son donde se encarnan las decisiones de diseño en detalle.
2. **Conversación**, una o varias, para afinar las decisiones que la propuesta deja abiertas (sección 10 de la biblia y sección 5 de este documento).
3. **Decisión preliminar**: aceptación condicional, petición de revisión, o rechazo documentado.
4. Si hay aceptación condicional, **continuar a Fase 2** con mapa de habilidades atómicas detallado.

---

*Fin de la propuesta de Fase 1 — versión 0.1.*

*Documento sometido al equipo editorial de la Colección Nuevo Ser conforme al §8 de los criterios de integración v0.1.*
