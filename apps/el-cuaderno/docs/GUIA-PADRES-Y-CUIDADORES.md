# El Cuaderno — guía para padres, madres y cuidadores

Este documento es para la persona adulta que acompaña a la niña o niño que usa El Cuaderno. Está pensado para leerse una vez, antes de instalar la app, y consultarse de vuelta cuando haga falta.

Si la persona que vas a acompañar es alumna en un aula y este cuaderno se usa en clase, hay un apartado específico al final.

---

## Qué es El Cuaderno

Una herramienta de campo digital con alma pedagógica para 9-13 años. La materia es Conocimiento del Medio Natural — pre-Biología y pre-Ecología en lenguaje LOMLOE. La forma es un cuaderno de campo: el niño anota lo que ve fuera, vuelve al mismo sitio (su *sit spot*), formula sus propias preguntas, y a veces el cuaderno le propone un Misterio contextualizado a su lugar y a la estación.

Es el tercer juego de la línea **Colección Nuevo Ser Kids**, junto con Uno Roto (matemáticas) y Las Versiones (pensamiento histórico).

A diferencia de los otros dos, **El Cuaderno no es narrativo**. No hay personaje, no hay mundo ficticio, no hay arcos. La protagonista es la niña real, su lugar es el suyo real. Esto está hecho a propósito: la palabra *naturaleza* presupone separación entre quien observa y lo observado, y inventar un valle de fantasía donde la niña hace de naturalista refuerza esa separación. Aquí no.

---

## Lo que El Cuaderno NO es

Es importante decirlo de entrada porque es la trampa más común al comparar con apps escolares al uso:

- **No es una app de gamificación.** No tiene puntos, niveles, rachas, badges, animaciones de "¡bien hecho!", barras de progreso, contador de días seguidos, ranking, ni "logros". Esto no es una omisión por falta de tiempo; es un rechazo expreso. La biblia del proyecto (§2) lo declara como hard limit no negociable.
- **No envía notificaciones push.** No va a hacer sonar el móvil para que la niña entre. Entra cuando le apetece y se queda fuera cuando no.
- **No corrige al niño.** No hay "respuesta correcta" en lo que escribe. Lo que ve está bien por ser visto. Lo que cree es suyo. Si una identificación es errónea, no aparece un cartel rojo — sólo hay tres niveles de confianza honestos (*consenso*, *hipótesis activa*, *no segura*) y al volver al sitio aprenderá a corregirse.
- **No vende datos, no muestra publicidad, no rastrea uso.** La aplicación es código abierto (AGPL-3.0) y los contenidos son CC-BY-SA 4.0. No hay modelo de negocio basado en extracción.

---

## Lo que El Cuaderno SÍ pretende

Cinco oficios pequeños, en orden:

1. **Observar antes de interpretar.** Distinguir *qué viste* de *crees que es*.
2. **Registrar para recordar.** Escribir, dibujar, fotografiar.
3. **Identificar con humildad.** Niveles de confianza explícitos.
4. **Hipotetizar y contrastar.** Volver al lugar, formular preguntas propias, mirar otra vez.
5. **Habitar un lugar.** El sit spot — un sitio real al que se vuelve regularmente.

El ritmo es deliberadamente lento. La señal de que el cuaderno está funcionando no es que la niña abra la app cinco veces al día — es que mire cinco minutos más al árbol del parque.

---

## Para qué edad

Pensado para 9-13 años (LOMLOE primaria, ciclos 2 y 3). En el piloto se cerrará si la edad mínima debería bajar a 8 o subir a 10 — depende de cómo respondan las niñas reales al sit spot, que es el corazón pedagógico.

Antes de los 9 años, lo más probable es que el ritmo lento aburra y que la lecto-escritura todavía no esté lo bastante automatizada para que el cuaderno sea cómodo. Después de los 13, el formato suele saberles a poco.

---

## Privacidad — qué se queda en el dispositivo y qué viaja

Esto es un hard limit no negociable de la biblia §2.1: **el cuaderno es del niño**. Operativamente significa:

**Sólo se guarda en el dispositivo, nunca cruza red:**

- El texto libre que la niña escribe en sus observaciones.
- Las fotos que toma o ancla desde la galería.
- Los dibujos del lienzo.
- Las coordenadas precisas (si las ha anclado).
- El nombre del sit spot y su descripción.
- Las preguntas que formula.
- Las respuestas que escribe al cerrar un Misterio.
- El nombre que ha elegido.

**Sólo viaja al servidor, y sólo si tú activas la sincronización opt-in:**

- Metadatos sin texto libre — un *hash* de la observación (no el texto), el código de región a nivel provincial (no la posición exacta), un agregado semanal con conteos por tipo de observación, sin contenido.
- Si el Tutor está activado, las preguntas del niño al Tutor viajan al servidor para procesarlas con un modelo de lenguaje. La biblia limita esto con cuota diaria, ZDR (zero data retention en Anthropic), filtro de lista negra y sin memoria entre conversaciones. Aún así, si no quieres que pase, el Tutor se puede dejar sin token y la app responde con un mensaje canónico genérico.

**Lo que tú, la persona adulta, puedes ver:**

- Un párrafo cualitativo en castellano resumiendo la semana de la niña, sin texto literal de sus observaciones.
- Una pregunta sugerida para la cena ("hoy podrías preguntarle si vio algún pájaro nuevo") — generada server-side para que sea fácil empezar conversación sin invadir el cuaderno.

**Lo que tú, la persona adulta, no puedes ver — ni con tu cuenta ni de ninguna otra manera:**

- El texto literal de las observaciones de la niña.
- Las fotos.
- Los dibujos.
- Las coordenadas.
- Las preguntas que formula.
- Las conversaciones con el Tutor.

Esto es deliberado. La niña necesita un espacio mental propio donde no haya sensación de auditoría.

---

## Cómo acompañar

### El sit spot es lo más importante

Lo que más cambia el funcionamiento del cuaderno es que la niña tenga un sit spot que use de verdad. No tiene por qué ser un lugar bonito ni "natural" en sentido ortodoxo: un patio interior con un par de macetas y una hilera de hormigas vale; un balcón con vistas a un descampado vale; el banco del parque que ella eligió porque sí, vale.

Lo que no funciona: que el sit spot lo elijas tú. Si ella no se ha apropiado de él, no volverá.

Si tu hija o hijo todavía no encuentra ningún sitio, no tiene prisa. La presentación del cuaderno deja explícito que se puede dejar para después. Volverá a la idea cuando tenga el suyo.

### El ritmo

Una observación al día es mucho. Una observación a la semana es buen ritmo. Hay semanas con cero observaciones — eso también está bien. El cuaderno no acumula presión por inactividad: si pasan diez días sin abrirlo, la siguiente vez que se abra todo está donde se quedó, sin reproches.

La biblia (§2.7) lo dice así: *cierre amable y ritmo respetuoso. Sin rachas, sin push, sin recompensas variables.*

### La pregunta para la cena

Si activas la sincronización del resumen semanal en Ajustes, recibirás cada semana un párrafo corto con la pregunta sugerida. Está pensada para que la cena sea más fácil — no para auditar. *"¿Has visto que las golondrinas siguen aquí o ya están bajando?"* es mejor que *"¿qué tal el cuaderno?"*

Si la niña no quiere hablar del cuaderno, no insistas. La pregunta es una llave; si no abre, tampoco pasa nada.

### Lo que no hay que hacer

- **No leas su cuaderno por encima de su hombro.** Esto rompe el principio 1 de la biblia. Si quieres saber cómo va, pregúntale; ella te enseñará lo que quiera enseñar.
- **No le pidas que te demuestre lo que ha aprendido.** Un cuaderno de campo no es deberes. La señal es que mire cinco minutos más al árbol del parque, no que te cite por orden taxonómico las aves de la zona.
- **No la corrijas si identifica mal.** Si dice que el petirrojo es un mirlo joven, anota su hipótesis. La próxima vez que vea uno, comparará. La identificación correcta sin proceso vale poco; el proceso vale mucho.
- **No la felicites efusivamente cuando anota.** El refuerzo positivo permanente convierte el oficio en performance. Mejor hacer una pregunta concreta sobre lo que vio.

---

## Cómo se instala y se arranca

### Para usuarios

La app se distribuye como APK firmado para Android. Cuando exista (B12 del plan: firma release + canal de distribución pendientes de decisión humana), las instrucciones específicas estarán en la web del proyecto.

Hoy, en piloto cerrado, la app se instala desde un APK debug que el equipo entrega a las familias voluntarias del Sprint 9.

### Primer arranque

1. **Idioma.** Castellano, euskera o catalán. Esta decisión se queda fija para el dispositivo (se puede cambiar en Ajustes).
2. **Nombre.** El nombre que la niña quiera que el cuaderno le diga. No tiene que ser su nombre real, no se sube al servidor, sirve sólo para el saludo del home y como cabecera del PDF si exporta.
3. **Presentación del sit spot.** Tres párrafos breves explicando qué es. Dos botones: *"ya pienso en uno"* y *"todavía no"*. Las dos opciones son legítimas — el cuaderno funciona sin sit spot, sólo que con menos profundidad.

### Configurar tu cuenta de adulto (opcional)

En Ajustes, bloque *"Cuenta del adulto"*, puedes iniciar sesión con un email y contraseña que se crean por web (no en la app — esto es por la regulación LOPDGDD para menores). Una vez vinculada:

- Puedes pulsar *"compartir resumen con el adulto"* para subir el agregado semanal y recibir el resumen + la pregunta para la cena.
- El Tutor IA se activa (mientras no haya cuenta vinculada, el Tutor responde con un mensaje canónico genérico).

Si decides no crear cuenta, la app funciona en local sin pérdida del oficio. Pierdes la pregunta para la cena y el Tutor real, nada más.

### El mapa

En Ajustes hay un interruptor *"mapa online"* que viene apagado de fábrica. Mientras esté apagado, la pestaña Mapa muestra un mensaje explicativo y no pide nada a internet. Cuando lo enciendes, la niña ve su sit spot y sus observaciones marcadas sobre un mapa de OpenStreetMap.

OpenStreetMap es un servicio externo. Cada vez que se mira el mapa, su servidor recibe la zona del mundo que se está mirando (no las coordenadas exactas del cuaderno — el mapa centra en la zona, no señala el punto). Si esto te incomoda, déjalo apagado: la niña tendrá la app sin mapa hasta que B5 (la decisión humana sobre tiles offline) se cierre y los mapas funcionen sin pedir nada al exterior.

---

## El Tutor

Es un asistente conversacional limitado por reglas que la niña puede consultar cuando no entiende algo o quiere pensar en voz alta. Está construido sobre un modelo de lenguaje (Anthropic Claude), pero no es un asistente generalista.

Limitaciones explícitas (biblia §6 + doc 04):

- **ZDR** — Anthropic no entrena con las conversaciones ni las retiene.
- **Sin memoria entre conversaciones.** Cada apertura del Tutor empieza limpia.
- **Lista negra de temas.** Hay temas (sexualidad explícita, violencia, drogas, autolesión, datos personales, identidad religiosa) que el Tutor no continúa. Si la niña los menciona, redirige amable y al cabo de pocos turnos cierra la conversación con voz amable.
- **Cuota de 30 turnos al día.** Cuando se llega, el Tutor responde *"hablamos mañana"* con voz amable. Esto es un bumper deliberado contra el efecto adictivo de los chatbots.
- **No da respuestas hechas.** El Tutor está prompted para devolver la pregunta al lugar — *"¿lo has mirado?"*, *"¿con qué se parece?"* — no para hacer de Wikipedia.

Si descubres en el resumen semanal que la conversación con el Tutor ha tomado un giro que te preocupa, pídele a la niña que te enseñe esa conversación. Tú no puedes leerla por defecto; ella sí puede compartirla contigo voluntariamente.

---

## Borrar todo

En Ajustes, *"borrar mi cuaderno"*. Pide doble confirmación + escribir una palabra clave (*"borrar"*) para evitar accidentes. Tras pulsarla:

- Se borran todas las observaciones, fotos, dibujos, sit spots (activos y jubilados), Misterios cerrados, preguntas formuladas, respuestas, agregados, histórico de resúmenes y opt-ins.
- Se conservan: el idioma elegido y el nombre del perfil. Son los datos del dispositivo, no del cuaderno.

La operación es irreversible. Si lo que querías era pasarle el dispositivo a otro niño, este flujo es lo correcto — la app queda como recién instalada.

Si lo que querías era cerrar tu cuenta de adulto sin tocar el cuaderno de la niña, eso se hace desde el bloque *"Cuenta del adulto"* con *"cerrar sesión"*.

---

## Si vas a un aula

Cuando este cuaderno se usa en clase, la persona docente accede a un panel agregado a través del bloque *"Acceder como profesor"* en Ajustes. Lo que ve:

- Recuento agregado de la actividad de su aula.
- Distribución por dominios (presencia, observación, registro, identificación, relaciones, ciclos, hábitats, hipótesis, tejido).
- **Nunca el contenido literal de las observaciones de ningún niño.**

El umbral mínimo es **k≥5** — si en un dominio o en un grupo hay menos de 5 alumnas con datos, ese dato se oculta para que no sea posible deducir el comportamiento de una niña concreta. Esto está en biblia §2.5.

Esta parte del producto está aún pendiente de cerrar la policy escolar definitiva con LOPDGDD para menores en aulas.

---

## Reportar problemas y dar feedback

Esto está en piloto cerrado. Si participas en el piloto, el equipo te ha facilitado un canal directo. Si no, este cuaderno todavía no es público.

Cuando la app se publique:

- Reportes de bug: el repositorio público en GitHub, sección *Issues*.
- Feedback pedagógico: a través del formulario que aparecerá en la web de la Colección.
- En todos los casos, **nunca compartas observaciones, fotos o dibujos del cuaderno de la niña por el canal de bugs**. Reporta en abstracto: "el botón X no responde cuando…", "después de hacer Y aparece el error Z".

---

## Decisiones que aún no están cerradas

La biblia §10 deja explícitamente abiertas algunas decisiones que sólo se cerrarán con evidencia del piloto:

- **El nombre.** *El Cuaderno* es provisional. Si en el piloto se ve que "cuaderno" se confunde con cosas escolares, cambiará.
- **Edad mínima.** 9 años de partida; podría bajar o subir.
- **Figura de la abuela.** Hay una pregunta abierta sobre si el cuaderno aparece como *cuaderno vacío* o como *cuaderno heredado* (de una bióloga ficticia o real). Se decide en piloto.
- **Compartir con instituciones de ciencia ciudadana.** iNaturalist, eBird, GBIF — la decisión es opt-in con consentimiento explícito, pero no está implementado en MVP.

---

## Licencia y código abierto

- **Código** (la aplicación): AGPL-3.0. Es código libre y abierto. Se puede auditar, modificar y redistribuir bajo los términos de la licencia.
- **Contenido** (textos, ilustraciones, catálogo de Misterios cuando lo cierre el comité científico): CC-BY-SA 4.0.

Esta decisión es deliberada. La biblia §9 no negocia este punto: *open source desde el primer commit*.

---

## Una última cosa

Esto es un cuaderno, no una solución. Lo importante no pasa dentro del aparato — pasa fuera, cuando la niña mira el árbol del parque cinco minutos más de los que miraría sin él.

Si dentro de seis meses la niña sigue saliendo a mirar y entrando al cuaderno menos veces que cuando empezó, el cuaderno está funcionando. Si entra al cuaderno cinco veces al día y nunca sale, hemos fracasado.

Gracias por acompañarla.
