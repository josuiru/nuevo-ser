# El Cuaderno — Flujos de usuario

> Documento operativo de diseño de interacción.
> Versión 0.1 — borrador para Fase 3.
> Sustituye al doc 13 (storyboards) de los otros juegos de la Colección — El Cuaderno no tiene narrativa que storyboardear.
> Leer con la biblia (doc 01), las voces (doc 04), el mapa de habilidades (doc 02) y la arquitectura técnica (doc 03).

---

## 0. Qué documenta esto

Diez recorridos típicos de uso de la app, paso a paso, con cada pantalla, cada campo, cada decisión de microcopia significativa. Es el documento que el equipo de desarrollo lee para implementar UI sin tener que reinventar decisiones.

Cada flujo está pensado desde la perspectiva de **una niña de 10 años llamada Lucía** que vive en un piso del extrarradio de Pamplona. Ese contexto importa: si los flujos funcionan para Lucía (que no tiene jardín ni acceso fácil a campo), funcionan para la mayoría.

Al final del documento, sección 11, hay decisiones transversales que aplican a todos los flujos.

---

## 1. Flujo 1 — Primera apertura (onboarding)

**Objetivo**: que Lucía termine la primera sesión con la app instalada, su nombre puesto, y la sensación de que esto no es una app educativa más. **Sin sit spot configurado todavía** — eso es el flujo siguiente y se hace en otro momento, idealmente fuera de casa.

**Duración objetivo**: 90-120 segundos.

### 1.1 Pantalla de bienvenida

Fondo crema con textura sutil de papel. Centrado, en serif:

> *El Cuaderno*

Debajo, en sans-serif tamaño 13:

> *Una herramienta para anotar lo que ves vivo cerca de ti.*

Botón único abajo: **Empezar**.

Sin animaciones de bienvenida. Sin pantalla de splash con logo de la Colección. Sin "marca registrada". Si Lucía pulsa Empezar, va directa a la siguiente pantalla.

### 1.2 Edad y nombre

Dos campos, una sola pantalla.

> *¿Cuántos años tienes?*

Selector numérico de 7 a 17. (Edades fuera de rango están permitidas pero generan flujo distinto: <9 muestra mensaje de que la app está pensada para 9 en adelante y pregunta si quiere seguir; ≥14 omite el flujo de consentimiento parental.)

> *¿Cómo quieres que te llame?*

Campo de texto libre. Sin validación dura. Si Lucía pone "Lúa" o "Pingüi", se respeta. Si lo deja vacío, la app muestra: *"Si lo prefieres, no pongas nombre. Te llamaré 'tú'."* y permite seguir sin nombre.

Botón: **Continuar**.

### 1.3 Idioma

Detección automática del idioma del sistema. Si es es / eu / ca, lo asume. Si es otro, ofrece elegir entre los tres y advierte:

> *De momento el Cuaderno solo habla castellano, euskera y catalán. Lo siento.*

Una sola pantalla, tres botones grandes.

### 1.4 Consentimiento parental (solo si edad <14)

Pantalla con texto serif breve:

> *Si tienes menos de 14 años, antes de seguir alguien que te cuida — tu padre, tu madre, alguien adulto de tu casa — tiene que dar permiso. Es así por una ley que protege a los niños en España.*
>
> *No te preocupes. Es rápido.*

Tres opciones:

- **Pedirle ahora que escriba aquí su email** (flujo: Lucía pasa el móvil a alguien adulto, ese alguien escribe email; se manda enlace de confirmación; Lucía puede usar la app en modo local mientras tanto).
- **Pedirle más tarde** (la app guarda lo que Lucía hace en local pero no sincroniza con servidor hasta que el consentimiento llegue).
- **Soy mi propio cuidador** (solo aparece si la edad declarada es ≥14; ver flujo separado).

### 1.5 Cierre del onboarding

Pantalla final:

> *Listo, [nombre].*
>
> *El Cuaderno es tuyo. Puedes empezar a anotar lo que veas — un pájaro, una hoja, una flor, una piedra. Lo que sea. La próxima vez que abras la app, podrás elegir un sit spot — un sitio al que vas a poder volver muchas veces. Pero eso lo haremos cuando estés fuera, no ahora.*

Botón: **Abrir el cuaderno**. La pantalla se desvanece y Lucía aparece en la pantalla principal del Cuaderno (vacía pero ya con su nombre).

### 1.6 Lo que NO se hace en este flujo

- No se pide foto de perfil.
- No se pide ubicación todavía.
- No se piden permisos del sistema (cámara, micrófono, ubicación) hasta que se necesiten.
- No hay tutorial guiado tipo "ahora pulsa aquí, ahora aquí".
- No hay encuestas de "qué te gusta", "qué quieres aprender".
- No se le piden datos a la persona adulta más allá del email para consentimiento.

---

## 2. Flujo 2 — Configurar el sit spot

**Objetivo**: que Lucía elija su lugar de regreso con conciencia de qué está eligiendo. **No se debe forzar en la primera sesión** — el sistema espera a que Lucía esté en un lugar al aire libre que le guste.

**Duración objetivo**: 60-90 segundos cuando Lucía decida activarlo.

### 2.1 Disparador

En la pantalla principal, durante los primeros 7 días sin sit spot configurado, aparece una tarjeta discreta que dice:

> *Cuando estés en algún sitio al aire libre que te guste — un parque, un árbol, una esquina — puedes hacerlo tu sit spot. Toca aquí cuando estés.*

No hay notificación push. No hay urgencia. Si Lucía pasa 10 días sin tocarlo, la tarjeta se queda; no se mueve, no parpadea.

### 2.2 Pantalla de elegir sit spot

Cuando Lucía toca la tarjeta:

> *Un sit spot es un lugar al que vas a poder volver muchas veces. Cuanto más vuelvas, más cosas verás.*
>
> *Mira a tu alrededor. ¿Hay algún sitio al que crees que vas a poder volver?*

Botones:
- **Sí, estoy en él**.
- **Aún no**.

Si "Aún no", vuelve a la pantalla principal sin más comentarios.

Si "Sí, estoy en él", continúa.

### 2.3 Permiso de ubicación

> *Si me das permiso para saber dónde estás ahora mismo, puedo guardar tu sit spot exactamente. Si prefieres no, puedes ponerle nombre y describirlo, sin coordenadas.*
>
> *Las coordenadas se guardan solo en este móvil. Nunca salen de aquí.*

Dos botones: **Dar permiso** y **Solo nombre**.

Si Dar permiso → solicitud nativa del sistema operativo, "solo en uso" (foreground). Si el sistema deniega, se cae al modo "Solo nombre" sin reproches.

### 2.4 Nombrar el sit spot

> *¿Cómo se llama tu sit spot?*
>
> *No tiene que ser un nombre real. Puedes ponerle el que quieras.*

Campo de texto libre. Sin validación. *"El Roble Grande"*, *"Mi banco"*, *"Donde fui con el abuelo"*, *"Aquí"*. Cualquier cosa vale.

Si la geolocalización está activa, debajo aparece un mini-mapa centrado en la ubicación actual con un punto. Lucía puede arrastrar el punto si la coordenada precisa no es la que quiere (a veces el GPS marca la calle de al lado del banco, no el banco).

Si no hay geolocalización, en lugar del mapa aparece un campo opcional:

> *¿Quieres añadir alguna seña para acordarte de dónde está?*

(Texto libre, opcional. Ejemplos: *"al final del parque, junto al pino más alto"*.)

### 2.5 Confirmación

> *El Roble Grande es tu sit spot.*
>
> *No tienes que volver todos los días. Vuelve cuando quieras. Lo importante es que puedas volver.*

Botón: **Listo**.

Vuelve a la pantalla principal, donde ahora el sit spot aparece como tarjeta destacada (ver Flujo 4).

### 2.6 Cambiar de sit spot

Si en el futuro Lucía quiere cambiar — porque se muda, porque el árbol lo cortaron, porque ha encontrado un sitio mejor — puede ir a Ajustes → Sit spot → **Jubilar y elegir nuevo**.

La app pregunta dos veces:

> *¿Quieres jubilar El Roble Grande y elegir un sit spot nuevo?*
>
> *Si lo haces, El Roble Grande seguirá en tu cuaderno como página, con todo lo que has anotado de él. Pero tu nuevo sit spot empezará desde cero. ¿Sigues queriendo?*

Si confirma, el SitSpot anterior pasa a `retired_at = ahora`, sigue accesible como página de cuaderno, y Lucía vuelve al flujo 2.2 para elegir uno nuevo.

---

## 3. Flujo 3 — Registrar una observación rápida en el campo

**Objetivo**: que Lucía pueda ver algo, registrarlo, y volver a lo que estaba haciendo en menos de **30 segundos** si tiene prisa.

**Duración objetivo**: 20-30s en modo rápido, 90-180s en modo cuidadoso.

### 3.1 Disparador

Tres caminos para abrir registro de observación:

(a) Desde la pantalla principal, botón flotante (FAB) con icono de lápiz pequeño en la esquina inferior derecha.
(b) Desde la tarjeta del sit spot, si está dentro de su radio de 50m, botón rápido **Anotar aquí**.
(c) Desde la pestaña de Misterios, abriendo un Misterio concreto, botón **Anotar para este Misterio** (preselecciona el ancla).

### 3.2 Pantalla de Nueva Observación

(Esta pantalla está mockeada en sección 5.2 de la biblia y replicada visualmente en propuesta — esta sección documenta los detalles operativos.)

Campos en orden vertical:

**1. Cabecera fija con metadatos automáticos**:

> *Hoy · 17:48 · soleado · El Roble Grande*

- Hora: hora actual del sistema.
- Tiempo (soleado/nublado/lluvia/nieve): autodetectado vía API meteorológica si hay red, o seleccionable manualmente con un tap si no.
- Lugar: nombre del SitSpot si Lucía está dentro del radio; o nombre del lugar más cercano que conozca (si Lucía ha guardado lugares); o "lugar nuevo" con campo de texto libre.

Toda la cabecera es editable con un tap si los datos automáticos están mal.

**2. Foto / dibujo (placeholder grande, opcional)**:

Caja gris de 110px de alto. Dos opciones lado a lado:
- **foto** → abre cámara nativa, foto rápida, vuelve.
- **dibujo** → abre canvas táctil sencillo (lápiz, goma, dos colores: tinta y rojo).

Lucía puede saltarse esto. La caja queda gris.

**3. Qué viste (obligatorio)**:

Campo de texto multilínea con placeholder en cursiva itálica:

> *describe lo que has visto, sin nombrarlo si no estás segura*

Tipografía serif. Sin límite de caracteres explícito (límite duro 2000 caracteres por seguridad técnica, no se muestra al usuario).

**4. Crees que es (opcional)**:

Campo de texto simple. Placeholder:

> *si quieres, propón un nombre*

Debajo, si Lucía escribe algo en este campo, aparecen los tres chips de confianza:

- **consenso** (con tooltip al mantener pulsado: *"lo has confirmado con una clave o con el Tutor"*)
- **hipótesis activa** (preseleccionado por defecto)
- **no estoy segura** (con tooltip: *"no pasa nada, anótalo así"*)

Si Lucía no escribe nada en "crees que es", los chips no aparecen.

**5. Va con un Misterio (opcional)**:

Si el sistema detecta que la observación encaja con un Misterio abierto de Lucía (por lugar, por estación, por tipo), aparece sugerencia automática:

> *va con un misterio: Las polinizadoras del roble · cambiar*

Lucía puede tocar **cambiar** para elegir otro o ninguno.

**6. Botón Guardar**:

Full-width, abajo. Texto: **Guardar en el cuaderno**.

Estado deshabilitado si "qué viste" está vacío. Texto bajo el botón en gris medio:

> *haz una nota antes de guardar*

(Sin rojo, sin icono de error, sin "campo obligatorio".)

### 3.3 Modo rápido — observación pendiente

Si Lucía tiene prisa, puede salir de la pantalla con foto + cabecera + sin nada más. La observación queda guardada como **pendiente** en su cuaderno (visible en pantalla principal en sección discreta) y la app le ofrece, sin presión, completarla cuando vuelva:

> *Tienes 1 observación a medias. ¿Quieres terminarla?*

Si Lucía deja una observación pendiente más de 7 días, la app no la borra ni la presiona. La nota sigue ahí mientras ella quiera.

### 3.4 Confirmación tras guardar

Pantalla principal con la observación nueva apareciendo en la sección "última página". Sin animación de fanfarria. Sin sonido. Sin "¡Bien hecho!". Solo aparece. Como aparecería en un cuaderno físico cuando cierras el lápiz.

---

## 4. Flujo 4 — Sesión típica en el sit spot

**Objetivo**: que la visita al sit spot **no se sienta como una sesión de app** sino como una visita real al lugar, con la app como herramienta accesoria.

**Duración objetivo**: variable (5 a 60 minutos en mundo real, de los cuales tiempo en pantalla idealmente <30%).

### 4.1 Disparador

Lucía abre la app estando físicamente en el SitSpot (geolocalización detecta que está dentro del radio de 50m). La pantalla principal cambia ligeramente:

- La tarjeta del sit spot aparece arriba del todo, ligeramente expandida.
- Mensaje breve: *"Estás en El Roble Grande."*
- Botón principal: **Anotar aquí**.
- Botón secundario: **Solo estar**.

### 4.2 "Solo estar"

Si Lucía toca **Solo estar**, la app entra en un modo minimalista:

Pantalla casi vacía. Solo:

> *El Roble Grande.*
>
> *No hace falta hacer nada.*

Y abajo en gris:

> *Si quieres anotar algo, vuelve atrás.*

La app NO mide cuánto tiempo está en este modo (esto es importante — si lo midiera, generaría performance). El modo simplemente está disponible. Cuando Lucía cierra la app, no pasa nada. Si vuelve más tarde, no hay registro de "has estado X minutos en silencio".

### 4.3 Sesión típica con anotaciones

Lucía toca **Anotar aquí**. La pantalla de Nueva Observación se abre con SitSpot ya rellenado.

Tras guardar la primera observación, vuelve a la pantalla principal — donde el sit spot sigue arriba — y puede seguir.

Si Lucía hace tres observaciones en una visita, la app **no celebra**. No dice *"¡Tres observaciones!"*. Las tres entradas aparecen en su sección, y ya está.

### 4.4 Salir del sit spot

Cuando Lucía se aleja del radio (geolocalización detecta salida), la app actualiza silenciosamente el `last_visit_at` del SitSpot. La próxima vez que abra la app desde otro sitio, la tarjeta del sit spot dirá *"Última visita: hoy"*.

Sin notificación. Sin pop-up de "¡Has terminado tu visita!".

### 4.5 Después de muchas visitas

Cuando Lucía ha visitado el sit spot ≥10 veces en ≥2 estaciones distintas, en la tarjeta del sit spot aparece un nuevo elemento:

> *El Roble Grande.*
> *Última visita: hace 3 días.*
> **▸ Ver lo que sabes de este sitio**

Si toca, va a una página automática del cuaderno (PaginaCuaderno tipo `sit_spot`) que muestra:

- Especies que ha visto allí, agrupadas por tipo.
- Marcadores estacionales que ha registrado (primera hoja amarilla, primera escarcha, etc.).
- Frecuencia de visitas por estación.
- Pequeño mapa con el punto del sit spot.

Esta página se va llenando sola con cada visita. Es la "recompensa estructural" del sit spot — sin gamificarla. La página existe sea cual sea la cantidad de datos. Cuando hay pocos, dice cosas honestas como:

> *Has visitado El Roble Grande 3 veces. Has registrado 5 especies. Cuando vuelvas más, esta página tendrá más cosas.*

---

## 5. Flujo 5 — Día de Archivo

**Objetivo**: ofrecer un día de revisión sin producción, cada 2-3 semanas. Sin obligación.

**Duración objetivo**: variable, pero la app no espera nada concreto.

### 5.1 Disparador

Cada 14-21 días (con jitter aleatorio para que no caiga siempre el mismo día de la semana), la app sugiere un día de Archivo. La sugerencia aparece **solo si Lucía abre la app** ese día — no como notificación push:

> *Hoy podría ser un día de Archivo. Una pausa para mirar atrás, releer lo que has anotado, ordenar páginas. Sin tener que producir nada nuevo.*
>
> *Si te apetece, puedes empezar. Si no, también está bien.*

Botones: **Empezar** y **Otro día**.

Si "Otro día", la sugerencia se va y vuelve a aparecer en 7-10 días.

### 5.2 Pantalla de Archivo

Si Lucía toca Empezar, entra en una vista distinta:

**Cabecera**:

> *Día de Archivo · domingo 8 de noviembre*

**Tres bloques verticales**, cada uno con tarjetas de las observaciones / páginas más recientes o más relevantes:

1. **Lo que has visto este otoño** — listado de observaciones de la estación actual, en orden cronológico inverso.
2. **Páginas que no has releído hace tiempo** — observaciones, mosaicos o páginas libres con tiempo desde último acceso > 30 días.
3. **Misterios abiertos** — los que tiene activos, con su estado actual.

Cada tarjeta es expandible. Lucía puede tocar y leer la observación completa, ver la foto, repasar.

### 5.3 Acciones disponibles (sin obligación)

En cualquier observación abierta, Lucía puede:

- **Añadir una nota nueva** ligada a la observación antigua (texto libre, sin estructura impuesta). Esto crea una página nueva en su cuaderno tipo `libre` con referencia cruzada.
- **Cambiar el nivel de confianza** si ahora sabe más. *"Esto que marqué hipótesis activa, ahora con la clave está claro: es petirrojo."*
- **Cerrar un Misterio** si ha llegado a una conclusión propia coherente con el consenso, o si quiere abandonarlo honestamente.

Y nada más. No hay quiz, no hay test, no hay "comprobación de aprendizaje".

### 5.4 Cierre del día de Archivo

Cuando Lucía sale de la pantalla de Archivo (cierra la app, va a otra sección), no hay resumen. No hay "Has revisado X páginas". Solo se cierra.

---

## 6. Flujo 6 — Conversación con el Tutor

**Objetivo**: que Lucía pueda preguntar al Tutor cosas concretas del oficio, recibir ayuda útil, y cerrar la conversación sin sensación de relación afectiva con la IA.

**Duración objetivo**: 1-5 turnos. La app desincentiva conversaciones largas.

### 6.1 Acceso

Pestaña **Tutor** en el bottom nav. Toca y entra.

### 6.2 Pantalla del Tutor

Vacía la primera vez. Solo el saludo canónico:

> *Soy el Tutor del Cuaderno. Pregúntame lo que necesites.*

Sin avatar. Sin animación. Sin "está escribiendo...".

Abajo: campo de texto y botón **Enviar**.

### 6.3 Adjuntar observación

Junto al campo de texto, un icono pequeño tipo clip permite **adjuntar una observación del cuaderno**. Si Lucía lo toca, se abre selector de sus observaciones recientes.

Si adjunta una, el Tutor recibe el contexto de la observación (qué viste, identificación propuesta, lugar, fecha). Esto le permite responder con conocimiento de causa: *"viendo lo que describes, el detalle de las antenas blancas es importante..."*.

### 6.4 Conversación

Turnos visibles arriba, en burbujas. Las del Tutor son sin fondo (texto plano). Las de Lucía con fondo gris muy ligero. Sin colores, sin iconos.

Tras cada respuesta del Tutor, el campo de texto vuelve a estar disponible para seguir.

Si Lucía hace una pregunta fuera de oficio (relaciones personales, política, religión, existencial), el Tutor responde con su línea canónica:

> *Eso queda fuera de lo que puedo ayudar. Es buena pregunta para alguien de tu casa.*

Y nada más. No vuelve al tema espontáneamente.

### 6.5 Sugerencia de cierre

Si la conversación llega a 8 turnos en una sesión, el Tutor empieza a sugerir cierre:

> *Llevamos un rato hablando. Esto que tienes ya te sirve. Vuelve al cuaderno cuando estés.*

Si la conversación llega a 15 turnos, el Tutor cierra:

> *Volvamos otro día. Lo que has aprendido hoy úsalo en el campo. Cuando vuelvas, te respondo lo siguiente.*

Y deja de responder hasta el día siguiente. (Esto no es castigo: es respeto al ritmo del oficio y prevención de relación parasocial.)

### 6.6 Sin memoria entre sesiones

Cuando Lucía sale de la pantalla del Tutor y vuelve más tarde, la conversación anterior ha **desaparecido**. La pantalla está vacía otra vez con el saludo canónico.

Si Lucía pregunta *"¿te acuerdas de lo que hablamos ayer del petirrojo?"*, el Tutor responde con honestidad:

> *No tengo memoria de conversaciones anteriores. Si necesitas, vuelve a contarme lo que viste o adjunta la observación de tu cuaderno.*

Esto es fundamental por dos razones documentadas en doc 04: privacidad (no almacenamos historial) y prevención de simulación de relación (sin memoria, no hay "amistad").

### 6.7 Sin Tutor

Si Lucía no tiene red (sit spot en zona sin cobertura), el Tutor está deshabilitado:

> *Necesito conexión para responderte. Si quieres, escribe tu pregunta y yo te respondo cuando vuelvas a tener red.*

Las preguntas se encolan. Lucía puede seguir escribiendo. Cuando recupera red, las preguntas se procesan en orden y aparecen las respuestas.

---

## 7. Flujo 7 — Cierre de estación y Mosaico

**Objetivo**: ofrecer cierre de cada estación con un Mosaico libre. Sin obligar. Sin evaluar.

**Duración objetivo**: 10-30 minutos si Lucía lo hace en serio.

### 7.1 Disparador

Hacia el final de cada estación astronómica, la app detecta el cambio inminente y, en la pantalla principal, aparece una sección nueva por dos semanas:

> *El otoño está acabando.*
>
> *Si quieres, puedes hacer una página de cierre — un Mosaico — con lo más significativo que hayas visto este otoño. Sin reglas. Sin evaluación. Solo lo que tú elijas.*

Botón: **Hacer un Mosaico**.

Si Lucía lo ignora durante las dos semanas, la sección desaparece silenciosamente al cambio de estación. Sin reproches. La estación siguiente arranca normal.

### 7.2 Pantalla de creación de Mosaico

Lienzo libre. Simple. Lucía tiene:

- **Texto** — bloques de texto con la voz del cuaderno (serif, márgenes anchos).
- **Imágenes** — puede arrastrar fotos de sus observaciones a la página.
- **Dibujos** — canvas táctil para dibujar nuevo o pegar dibujos existentes.
- **Mapa** — opcional, mini-mapa del territorio donde estuvo más activa.
- **Citas** — bloques especiales que cogen literalmente texto de sus propias observaciones (en serif, indentado, con la fecha al lado).

Sin plantilla rígida. Sin "hueco para foto, hueco para texto". El lienzo es libre.

### 7.3 Sugerencias suaves

Si Lucía abre el Mosaico y se queda en blanco más de 30s, aparece sugerencia discreta:

> *Si quieres una pista: puedes empezar eligiendo una observación que te haya gustado mucho.*

Y un botón pequeño: **Ver mis observaciones del otoño**. La sugerencia desaparece al primer toque o a los 60s. No vuelve.

### 7.4 Guardar Mosaico

Botón **Guardar en el cuaderno**.

Tras guardar:

> *El Mosaico de Otoño está en tu cuaderno. Volverás a él cuando quieras.*

Y vuelve a pantalla principal.

### 7.5 Mosaicos en la vista del cuaderno

Los Mosaicos aparecen en la pantalla principal del cuaderno como tipo de página especial, con borde sutil distinto y la palabra "Mosaico" en cabecera. Al final del año, cuatro Mosaicos forman una vista temporal del año del niño.

---

## 8. Flujo 8 — Vincular un cuidador

**Objetivo**: que Lucía y su madre puedan vincular cuentas con consentimiento doble, sin que la madre acceda al cuaderno completo.

**Duración objetivo**: ~3 minutos en total.

### 8.1 Iniciado por la niña

Lucía va a Ajustes → Compartir → Cuidadores.

> *Si quieres, alguien de tu casa puede recibir un resumen semanal de cómo va tu cuaderno. No verá lo que escribes ni tus dibujos. Solo un párrafo cualitativo cada semana.*
>
> *Tienes que decidirlo tú. Puedes deshacerlo cuando quieras.*

Botón: **Invitar a alguien**.

### 8.2 Pantalla de invitación

Lucía elige cómo invitar:

- **Por email**.
- **Mostrar código en pantalla** (genera código corto de 6 letras; la persona adulta lo introduce desde su propia app o web).

Si email: campo para escribir el email del cuidador.

Confirmación:

> *Voy a mandar un mensaje a [email] explicando lo que va a ver. Tendrá que confirmar que está de acuerdo. Hasta entonces, no verá nada.*

### 8.3 Confirmación del cuidador

La madre recibe email con explicación clara:

> *Lucía te ha invitado a ver el resumen semanal de su trabajo en El Cuaderno, una herramienta de observación de naturaleza para niños.*
>
> *Si aceptas, recibirás cada lunes un párrafo breve sobre qué ha estado trabajando esa semana, junto con una pregunta sugerida para conversar con ella. No verás sus observaciones individuales, ni sus dibujos, ni sus conversaciones con el Tutor. La privacidad de su cuaderno es estructural — está pensada así.*

Enlace de confirmación. Cuando la madre lo pulsa, va a una página web mínima donde:

- Verifica el email.
- Lee la lista exacta de lo que sí verá y lo que no.
- Da consentimiento explícito.

Tras confirmación, el sistema vincula las cuentas.

### 8.4 Aviso a la niña

Lucía recibe en su pantalla principal:

> *Tu madre ha aceptado. A partir del lunes, recibirá un resumen tuyo cada semana.*

### 8.5 Revocar vinculación

En cualquier momento, Lucía puede ir a Ajustes → Compartir → Cuidadores → tocar a su madre → **Quitar acceso**.

Confirmación simple:

> *Si quitas el acceso de tu madre, dejará de recibir resúmenes. Puedes volver a darle acceso cuando quieras.*

Sin justificación pedida. Sin segundo paso. Lucía decide.

---

## 9. Flujo 9 — Vista del cuidador (web)

**Objetivo**: que la madre pueda leer el resumen semanal con tres clics como mucho, en cualquier dispositivo, sin necesidad de instalar app.

**Duración objetivo**: 60 segundos para leer el resumen.

### 9.1 Acceso

Web sencilla en el dominio de la Colección. La madre se loguea con su email + contraseña (estándar) o con magic link.

### 9.2 Pantalla principal

Solo una cosa visible:

> *Resumen semanal de Lucía*
>
> *Semana del 1 al 7 de noviembre*

Y debajo, el párrafo cualitativo generado por el Tutor (ver doc 15 §2):

> *Esta semana Lucía ha vuelto al Roble Grande tres veces. Sigue investigando si hay menos mariposas que el mes pasado. Ha decidido marcar como hipótesis activa que el frío temprano las ha adelantado.*

Y debajo, separado:

> *Pregunta para la cena: ¿le has contado alguna observación tuya sobre los insectos cuando eras pequeño?*

Eso es todo lo que ve esta semana.

### 9.3 Resúmenes anteriores

Botón pequeño abajo: **Ver semanas anteriores**. Lleva a lista cronológica de los resúmenes recibidos. La madre puede releer, comparar, ver evolución.

Sin gráficos. Sin métricas. Sin "porcentaje de progreso". Sin "habilidades alcanzadas".

### 9.4 Configuración

Pestaña Ajustes:

- Idioma de los resúmenes (es / eu / ca).
- Frecuencia (semanal por defecto; opción "menos frecuente" cada 2 semanas o mensual; sin opción "más frecuente").
- Hora de entrega (lunes mañana por defecto; ajustable).
- **Quitar mi acceso** (revoca la vinculación desde el lado del cuidador).

### 9.5 Lo que NO ve nunca

Reiterado explícitamente en el footer de cada página:

> *No tienes acceso al cuaderno de Lucía, ni a sus observaciones individuales, ni a sus dibujos, ni a sus conversaciones con el Tutor. Esto es estructural — está pensado así.*

Si la madre pregunta a soporte si puede ver más, la respuesta es no. Sin excepciones.

---

## 10. Flujo 10 — Vista del aula (profesor)

**Objetivo**: que un profesor de Conocimiento del Medio pueda ver patrones agregados de su clase y diseñar actividad coherente, **sin acceso a niños individuales** (k≥5 obligatorio).

**Duración objetivo**: 5-10 minutos para revisar el panorama semanal.

### 10.1 Acceso

Web profesional en el dominio de la Colección. Login con cuenta institucional (si el centro está vinculado) o cuenta personal del profesor verificada.

### 10.2 Pantalla principal

Cabecera:

> *6º A — Colegio público X*
> *15 niños vinculados de 22 totales*

Tarjetas en cuadrícula:

**Tarjeta 1 — Habilidades en juego este mes**:
Pequeño gráfico de barras (no comparativo entre niños) con los 9 dominios y, para cada uno, % aproximado de la clase que está practicando algo de ese dominio.

**Tarjeta 2 — Donde la clase está más dispersa**:

> *La clase está más dispersa en OBS.02 (separar observación de interpretación). Algunos niños lo dominan; a otros les cuesta. Sería útil trabajarlo en aula.*

Texto generado por sistema con regla simple sobre la varianza de scores.

**Tarjeta 3 — Misterios más trabajados**:
Lista de los 3-5 Misterios que más niños de la clase tienen activos. Útil para conversación de aula:

> *5 niños de la clase están investigando "¿De dónde salen las setas tras la lluvia?". Podrías proponer una salida al patio para mirar juntos.*

**Tarjeta 4 — Marcadores fenológicos colectivos**:

> *Esta semana, la clase ha registrado: primera hoja amarilla del cole (5 niños); primer petirrojo del otoño (3 niños).*

**Tarjeta 5 — Materiales pedagógicos sugeridos**:
Enlaces a las actividades de aula propuestas para esa estación, alineadas con LOMLOE.

### 10.3 Lo que NO ve

Si el profesor toca cualquier dato y intenta ir a "qué niño concreto", **no hay drilldown**. La interfaz no lo permite estructuralmente. Mensaje persistente en footer:

> *Esta vista solo muestra agregados. No tienes acceso a niños individuales. La privacidad de cada cuaderno es estructural.*

Si una habilidad la trabajan menos de 5 niños, no aparece como dato — aparece como:

> *Esta habilidad la están trabajando menos de 5 niños. No mostramos el dato para proteger su intimidad.*

### 10.4 Materiales pedagógicos

Pestaña separada con:

- Actividades de campo trimestrales adaptadas a la región del centro.
- Claves de identificación imprimibles (PDF).
- Sugerencias de evaluación (proyectos, no exámenes).
- Guía corta sobre cómo hablar de la app en aula sin convertirla en deberes.

---

## 11. Decisiones transversales

Aplican a todos los flujos. Si hay duda en cualquier pantalla, estas reglas mandan.

### 11.1 Sin notificaciones push

El sistema **nunca** manda notificación push para:

- Pedir que vuelva a la app.
- Recordar que hace X días que no entra.
- Anunciar Misterios nuevos.
- Anunciar cambio de estación.
- Promocionar features.

Únicas notificaciones permitidas (todas opt-in):

- Email semanal del cuidador (al cuidador, no al niño).
- Confirmaciones transaccionales puntuales (consentimiento parental, vinculación de aula, borrado de cuenta).

### 11.2 Sin modales bloqueantes

La app no usa modales que bloqueen la pantalla salvo para confirmar acciones destructivas (jubilar sit spot, borrar cuenta, revocar vinculación). Cualquier información que pueda ser bottom sheet, es bottom sheet.

### 11.3 Sin feedback haptico salvo confirmación

Se usa vibración corta solo para confirmar acciones del usuario (guardar observación, enviar pregunta al Tutor). Nunca para llamar la atención hacia algo del sistema.

### 11.4 Sin sonidos del sistema

Salvo el sonido del lápiz al escribir (sutil, opcional, desactivable por defecto), la app es silenciosa. No hay "ding" al guardar. No hay música. No hay sonido al cambiar pestaña.

### 11.5 Modo oscuro

Soportado y respetado del sistema. Paleta de modo oscuro: fondos gris carbón muy oscuro (no negro puro), textos crema, mismos verdes y ocres apagados. Ver guía visual (doc 11) cuando esté.

### 11.6 Tipografías

- **Serif** (Lora o Fraunces, decisión final en doc 11): textos del cuaderno, voces (sistema, niño), citas, título de páginas.
- **Sans-serif** (Inter o IBM Plex Sans): metadatos del sistema (fecha, hora, ubicación), botones, navegación, formularios.

### 11.7 Animaciones

Mínimas. Transiciones de 200ms entre pantallas, fade simple. Nada de bounce, spring, parallax. Si Lucía abre rápido y cierra rápido, no hay nada que se interponga.

### 11.8 Errores

Nunca usar palabras como "Error", "Falló", "Inválido". Microcopia de errores siempre orientada a solución, en frase positiva:

- Mal: *"Error: campo requerido."*
- Bien: *"Haz una nota antes de guardar."*

### 11.9 Carga lenta

Indicadores de carga deliberadamente sobrios. Texto en gris medio:

> *Buscando...*

Sin spinners animados llamativos. Sin "cargando..." con puntos suspensivos parpadeantes.

Si una operación tarda más de 5s, mostrar mensaje:

> *Esto está tardando. Puedes seguir con otra cosa, no se va a perder.*

### 11.10 Vacío como estado válido

Pantallas vacías no se llenan con ilustración decorativa ni con CTA llamativos. Texto sobrio:

> *Aún no has anotado nada en este sitio. Cuando lo hagas, aparecerá aquí.*

Y ya está.

---

## 12. Lo que NO hay en estos flujos

Recopilatorio de cosas que un equipo de UI/UX podría introducir por defecto y que aquí están explícitamente fuera:

- Tutorial guiado interactivo (tooltips encadenados).
- Achievements / logros / badges.
- Barra de progreso del cuaderno.
- Avatar / personalización visual del perfil.
- Personalización de tema (más allá del modo oscuro del sistema).
- Sonido de fondo seleccionable.
- Stickers / emojis del sistema.
- Compartir en redes sociales.
- Comparación entre niños.
- "Sugerencias de qué estudiar".
- "Recordatorios inteligentes" basados en machine learning.
- Onboarding largo con varias pantallas explicativas.
- Splash screen con marca.

---

*Fin de Flujos de Usuario v0.1.*
