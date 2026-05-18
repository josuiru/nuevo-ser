# Guía de testeo — El Cuaderno

Cuaderno de campo digital para niñas y niños de 9 a 13 años. Es uno de los
juegos de la línea Kids de la Colección Nuevo Ser. A diferencia de Uno Roto
y Las Versiones, **no es narrativo**: no hay protagonista ni mundo ficticio.
La protagonista es la persona real que lo usa; el lugar es su lugar real
(parque, patio, paseo del río). Sirve para anotar lo que vive cerca:
plantas, pájaros, insectos, huellas, charcos, hongos. Soporta sit spot
(lugar de regreso), observaciones con foto/dibujo/coords opcionales,
catálogo de Misterios contextualizados al lugar y la estación, preguntas
formuladas por la propia niña, Tutor IA con barreras, vista del cuidador,
exportación PDF y multi-idioma (es / eu / ca).

**Versión a testear**: 0.0.1 (release `apks-2026-05-18`)
**Descarga**: https://github.com/JosuIru/nuevo-ser/releases/tag/apks-2026-05-18
→ `el-cuaderno-0.0.1.apk`
**Dispositivo recomendado**: Android 7+, GPS, cámara. Conexión no
imprescindible (offline-first); sólo hace falta red para el Tutor IA, el
mapa online y la sincronización del cuidador.

**Aclaración de nombre**: en este monorepo conviven dos cosas que se llaman
parecido. Estás testeando **el juego El Cuaderno** (la app que se instala
en el móvil del niño). Hay otra cosa llamada *Bitácora* en el companion
del adulto que no se testea aquí. Si en algún sitio ves "cuaderno" sin más,
es el juego.

---

## Antes de empezar

- [ ] **Perfil ideal**: niño o niña de 9-13 años acompañado de un adulto
  para los pasos de cuenta y el feedback, **o** un adulto solo simulando
  el flujo del niño (vale para detectar bugs aunque no para feedback
  pedagógico).
- [ ] **Sitio**: si puedes, prueba al menos una sesión fuera de casa (un
  parque, un paseo, el patio) — el corazón de la app es observar despacio
  un lugar real. Una sesión sólo en interior se pierde la mitad del valor.
- [ ] **Permisos**: la app pide cámara, almacenamiento y, sólo si activas
  el bloque opt-in correspondiente, ubicación. Acepta todos para poder
  testear todo. Si una pantalla pide algo que no esperas, anótalo.
- [ ] **Privacidad estructural**: la app está diseñada para que el texto
  libre, las fotos, los dibujos y las coordenadas NO salgan a internet.
  Si en algún momento ves que algo de eso viaja a un servidor sin que tú
  hayas pulsado el botón correspondiente, **es un bug crítico**.
- [ ] **Borrar todo**: en Ajustes hay un flujo para borrar el cuaderno
  entero. Úsalo al final si quieres dejar el dispositivo como antes;
  no antes, porque pierdes los datos de prueba.

---

## Bloque 1 — Primera apertura y onboarding

- [ ] La app abre sin errores tras instalarla.
- [ ] Aparece una pantalla trilingüe pidiendo elegir idioma con saludos
  "Hola / Kaixo / Hola" y la pregunta "¿En qué idioma quieres usar el
  cuaderno?".
- [ ] Elegir un idioma cualquiera persiste y la app sigue en ese idioma
  al reabrir.
- [ ] Tras el idioma, se pide nombre del perfil ("¿cómo te llamas?").
- [ ] El nombre puede llevar tildes, ñ, dos palabras, mayúsculas. Se
  respeta tal cual.
- [ ] Tras el nombre aparece la **pantalla de presentación del sit spot**
  con tres párrafos explicando qué es (un banco del parque, una piedra
  junto al río, etc.).
- [ ] La pantalla del sit spot ofrece dos botones sin urgencia: "ya pienso
  en uno" y "todavía no". Ambos llevan al home; **ninguno fuerza** a
  crear sit spot.
- [ ] La pantalla del sit spot solo aparece una vez en la vida del
  cuaderno (al reabrir la app NO vuelve a salir).
- [ ] Hay un enlace discreto a la política de privacidad / términos
  (marcada como BORRADOR) accesible desde la configuración inicial.

**Notas / hallazgos**:


---

## Bloque 2 — Pantalla principal (home / pestaña Cuaderno)

- [ ] El home se abre con un saludo personalizado al nombre que pusiste
  ("Hola, Lucía." o "Hola." si lo dejaste vacío).
- [ ] Bajo el saludo aparece a veces una **nota fenológica** (un tip
  breve en serif gris sobre la estación, p. ej. "Hay más cantos al
  amanecer..."). Puede no aparecer según fecha/zona — es esperable.
- [ ] Hay una **tarjeta del sit spot**:
  - Si no hay sit spot, dice algo tipo "Cuando estés en algún sitio al
    aire libre que te guste, puedes hacerlo tu sit spot" y es **pulsable**.
  - Si hay sit spot, muestra nombre + dónde + "última visita hace N días".
- [ ] Hay una sección **"Última página"** que destaca la observación más
  reciente. Si no hay observaciones, esta sección no se monta o muestra
  un texto vacío amable.
- [ ] La sección "Última página" es **pulsable** y abre el detalle de la
  observación.
- [ ] Hay un enlace discreto **"ver todas tus páginas"** que abre la lista
  completa.
- [ ] Hay un bloque de **Misterios** (top 3) con tarjetas pulsables.
- [ ] Hay un **bottom navigation bar** con cuatro o cinco pestañas:
  Cuaderno / Misterios / Mapa / Tutor / Ajustes (orden y exacto pueden
  variar — anota el orden que veas).
- [ ] Hay un **FAB (botón flotante "+")** que cambia según la pestaña: en
  Cuaderno es "anotar"; en Misterios es "formular pregunta".

**Notas / hallazgos**:


---

## Bloque 3 — Sit spot

### Crear sit spot

- [ ] Pulsar la tarjeta-invitación abre el formulario "Crear sit spot".
- [ ] Campo "nombre" obligatorio (p. ej. "el banco del río").
- [ ] Campo "dónde" opcional (p. ej. "junto al cole").
- [ ] Hay un **bloque opt-in para anclar mi posición** con AlertDialog
  previo en voz adulta amable ("la posición se queda en este cuaderno y
  no sale a internet, no la ve el adulto").
- [ ] Aceptar el opt-in pide permiso de ubicación al sistema.
- [ ] Si deniegas, sale un aviso amable y se puede guardar el sit spot
  sin coordenadas.
- [ ] Si lo concedes y hay GPS, las coords se anclan al guardar.
- [ ] Tras guardar, la tarjeta del home pasa al estado "activo" con
  nombre + dónde.

### Tarjeta del sit spot activo

- [ ] Pulsar la tarjeta activa abre la **página del sit spot** con
  cabecera (nombre + dónde + "activo desde DD/MM/YYYY") y listado de
  observaciones ancladas.
- [ ] Hay un botón principal **"anotar observación aquí"** que abre el
  formulario con el sit spot preseleccionado.
- [ ] Hay un menú de tres puntos (overflow) con la opción **"jubilar
  este sit spot"**.

### Jubilar sit spot

- [ ] Pulsar "jubilar" lanza confirmación amable explicando que la
  página seguirá guardada pero no podrá registrar más observaciones.
- [ ] Tras confirmar, la tarjeta del home vuelve a estado invitación.
- [ ] En Ajustes aparece un nuevo bloque **"Sit spots de antes"** que
  solo se monta si has jubilado alguno.
- [ ] Pulsar un sit spot jubilado abre su página de lectura con
  "estuvo activo del DD/MM/YYYY al DD/MM/YYYY" y la lista de
  observaciones que tuvo.

**Notas / hallazgos**:


---

## Bloque 4 — Nueva observación

- [ ] FAB "anotar" en pestaña Cuaderno abre el formulario "Nueva
  observación".
- [ ] Campo **"qué viste"** obligatorio (texto libre).
- [ ] Campo **"crees que es"** opcional (la identificación).
- [ ] Selector de **nivel de confianza**: consenso / hipótesis activa /
  no segura. No hay "incorrecto", no hay rojo.
- [ ] Campo **"dónde"** obligatorio (texto libre, "el parque del río").
- [ ] **Foto**: botón abre cámara o galería; la foto se ve en miniatura.
- [ ] **Dibujo**: botón abre el lienzo espartano (una tinta negra, gesto
  pan, "borrar y empezar otra vez", "guardar"). En esta versión hay
  selector básico de ancho de trazo y deshacer del último trazo. No
  hay paleta, no hay presión, no hay deshacer multi-paso — es esperable.
- [ ] **Anclar posición**: bloque opt-in con AlertDialog previo, mismo
  patrón que el sit spot.
- [ ] **Selector de Misterio** opcional: lista los Misterios abiertos
  filtrados por estación y región.
- [ ] **Chip de sugerencia**: si escribes algo como "una golondrina" en
  "qué viste" y existe un Misterio sobre golondrinas en contexto,
  aparece un chip "esto suena al Misterio: ..." con botones "no" y
  "anclar".
- [ ] Pulsar "no" oculta el chip y no insiste con el mismo Misterio.
- [ ] Pulsar "anclar" selecciona el Misterio en el selector.
- [ ] Si hay sit spot activo, la observación se ancla automáticamente
  al sit spot al guardar.
- [ ] Guardar añade la observación al cuaderno y vuelve al home con la
  última página actualizada.
- [ ] La pantalla NO muestra animaciones de celebración, ni sonidos de
  "¡bien hecho!", ni XP, ni puntos.

**Notas / hallazgos**:


---

## Bloque 5 — Detalle de la observación (releer)

- [ ] Pulsar la "última página" del home abre el detalle.
- [ ] El detalle muestra cabecera (DD/MM/YYYY + dónde), foto en caja
  220 pt si la hay, dibujo en caja 220 pt si lo hay, "qué viste",
  "crees que es" + confianza, "tiempo" si hay clima registrado.
- [ ] Si la observación tiene anclajes (Misterio, sit spot, posición),
  aparece la sección "anclajes".
- [ ] Si tiene coords ancladas, aparece el aviso "posición anclada
  (sólo en este cuaderno, no sale a internet)".
- [ ] Si el Misterio al que estaba anclada ya no existe en el catálogo
  abierto, el bloque del Misterio se omite (no muestra "—" ni texto
  fantasma).
- [ ] Si la observación NO está anclada a ningún Misterio pero el "qué
  viste" matchea con uno, aparece el **chip de sugerencia** con la
  misma mecánica que en el formulario.
- [ ] Si el Misterio sugerido no aplica en esta estación, aparece bajo
  él un aviso tipo "vuelve en otoño" o "vuelve en verano".
- [ ] AppBar con menú overflow con dos opciones: "editar este registro"
  y "borrar este registro".

### Editar

- [ ] "Editar" abre `PantallaEditarObservacion` acotada: se pueden
  modificar **qué viste**, **crees que es**, **confianza**, **dónde** y
  **clima resumen**.
- [ ] Foto, dibujo, coordenadas y anclajes (Misterio, sit spot) **NO**
  son editables — es esperable. Para cambiarlos hay que borrar y crear
  de nuevo. Hay un aviso en la cabecera del editor que lo explica.
- [ ] Guardar persiste y vuelve al detalle con los datos nuevos.

### Borrar

- [ ] "Borrar" pide confirmación con voz adulta amable ("Vas a borrar
  esta página del cuaderno. La foto y el dibujo, si los tenía, también
  se borrarán. No se puede deshacer.").
- [ ] Tras confirmar, la observación desaparece de la lista, del home y
  de la página del Misterio o sit spot a la que estuviera anclada.

**Notas / hallazgos**:


---

## Bloque 6 — Lista de todas las páginas

- [ ] El enlace "ver todas tus páginas" del home abre la lista completa.
- [ ] Hay un campo de búsqueda arriba.
- [ ] La búsqueda es **case-insensitive** (escribir "pajaro" o "PAJARO"
  funciona igual).
- [ ] La búsqueda es **accent-insensitive** ("pajaro" encuentra "pájaro";
  "n" encuentra "ñ").
- [ ] Las tarjetas son pulsables y abren el detalle.
- [ ] Estado vacío diferenciado:
  - Cuaderno vacío: "Aún no has anotado nada".
  - Búsqueda sin resultados: "Ninguna página guarda eso. Prueba con
    otra palabra."

**Notas / hallazgos**:


---

## Bloque 7 — Misterios

### Pestaña Misterios

- [ ] La pestaña Misterios del bottom nav lista, **primero**, "Tus
  preguntas" (las del niño, ver bloque siguiente).
- [ ] Después, "Misterios del cuaderno" con todos los abiertos
  filtrados por estación y región (no sólo el top 3 que veías en el
  home).
- [ ] Si un Misterio acaba de entrar en su ventana fenológica, su
  tarjeta lleva el prefijo "estos días · " en el footer.
- [ ] Cada tarjeta muestra el contador de evidencias anotadas
  ("1 evidencia anotada", "3 evidencias anotadas", o "todavía no has
  anotado nada").
- [ ] Estado vacío diferenciado:
  - Catálogo vacío: "Aún no tienes Misterios abiertos...".
  - Catálogo no vacío pero filtrado por contexto: "Hoy no hay
    Misterios para tu lugar y esta estación. Vuelve a mirar al
    cambiar el tiempo."
- [ ] Hay una sección "Ya cerrados" al final, **solo** si hay alguno
  cerrado por el niño.

### Página del Misterio

- [ ] Pulsar una tarjeta abre la página del Misterio: cabecera con la
  pregunta (serif) + descripción + estado (consenso / hipótesis activa
  / no segura).
- [ ] Botón principal **"anotar evidencia para este misterio"** abre el
  formulario con el Misterio preseleccionado.
- [ ] Listado de las observaciones ya ancladas a este Misterio.
- [ ] Si hay ≥1 evidencia, aparece el botón secundario **"ya tengo mi
  respuesta sobre este Misterio"** que abre `PantallaCerrarMisterio`.
- [ ] Sin evidencias, el botón de cierre NO aparece (es esperable).

### Cerrar y reabrir

- [ ] `PantallaCerrarMisterio` tiene TextField multilínea con copy
  amable ("No hay respuesta correcta — esto no se corrige ni se nota;
  sólo se guarda en tu cuaderno.").
- [ ] Guardar deja el Misterio en estado cerrado: aparece bloque "Tu
  respuesta" con texto + "cerrado el DD/MM/YYYY", los botones de
  evidencia y cierre se ocultan, y el Misterio sale del listado de
  abiertos.
- [ ] Hay un TextButton discreto **"reabrir este Misterio"** con
  confirmación que avisa "Si lo reabres, tu respuesta se borra...".
- [ ] Reabrir: la respuesta desaparece, el Misterio vuelve al listado
  de abiertos y los botones reaparecen.

**Notas / hallazgos**:


---

## Bloque 8 — Mis preguntas (preguntas del niño)

- [ ] FAB en la pestaña Misterios cambia a **"formular pregunta"**.
- [ ] Abre `PantallaFormularPregunta` con TextField multilínea.
- [ ] Botón discreto **"necesito ideas"** abre un bottom sheet con 5
  esqueletos genéricos ("¿siempre que hay X aparece Y?", "¿qué pasa
  con Z cuando llueve?", etc.). El niño elige si quiere usar uno o
  escribe libre.
- [ ] Guardar añade la pregunta a "Tus preguntas" en la pestaña
  Misterios.
- [ ] Pulsar una pregunta abre su página, similar a la del Misterio:
  pregunta + botón "anotar evidencia para esta pregunta" + listado.
- [ ] Anotar evidencia desde ahí ancla la observación automáticamente.
- [ ] Con ≥1 evidencia aparece "ya tengo mi respuesta" con el mismo
  flujo de cierre/reabrir.
- [ ] La pregunta cerrada muestra el bloque "Tu respuesta" + fecha.
- [ ] Menú overflow del AppBar de la página permite **borrar la
  pregunta** (con confirmación).

**Notas / hallazgos**:


---

## Bloque 9 — Mapa

La pestaña Mapa está cableada como **fallback de experto** (los tiles
finales serán MBTiles offline; hoy son OSM online detrás de opt-in).

- [ ] La primera vez que entras, la pestaña dice "el mapa está apagado"
  con un botón "abrir Ajustes".
- [ ] En Ajustes hay un bloque con un switch para activar el mapa
  online y un copy que explica que al activarlo el servidor de OSM
  verá qué zona del mundo se está mirando.
- [ ] Tras activar el switch y volver a la pestaña, el mapa se recompone
  inmediatamente (no hace falta reiniciar).
- [ ] Si no hay sit spot anclado, el mapa muestra una invitación
  "ancla tu lugar" + botón "configurar sit spot".
- [ ] Si hay sit spot con coordenadas, el mapa carga centrado en el
  sit spot con un marker verde bosque para el sit spot y markers gris
  ceniza para las observaciones con `dondeCoordenadas`.
- [ ] Pulsar el marker del sit spot abre la página del sit spot.
- [ ] Pulsar el marker de una observación abre su detalle.

**Notas / hallazgos**:


---

## Bloque 10 — Tutor IA

El Tutor está limitado por reglas: ZDR + sin memoria entre conversaciones
+ lista negra + cuota 30 turnos/día. Necesita JWT del backend.

- [ ] Sin cuenta vinculada, la pantalla del Tutor sigue siendo usable
  con respuestas canned (modo S1). En debug-only hay un bloque para
  pegar JWT a mano y probar.
- [ ] El Tutor NO contesta sobre temas fuera de la lista (validar:
  "¿qué hora es?", "cuéntame un chiste" o similar deberían rebotar
  con voz amable).
- [ ] El Tutor no recuerda la conversación entre sesiones.
- [ ] Si se agota la cuota, el mensaje es claro y amable.

**Notas / hallazgos**:


---

## Bloque 11 — Cuidador (vista del adulto)

- [ ] En Ajustes hay un bloque **"Acceder como cuidador"** o similar.
- [ ] La pantalla del cuidador NO muestra el cuaderno del niño en
  ningún sitio (lo verifica que la promesa de privacidad estructural
  se cumple).
- [ ] Hay un botón opt-in **"Compartir resumen con el adulto"** que
  dispara la sincronización del agregado semanal.
- [ ] Aparece un bloque con **métricas agregadas** (counts, reparto
  por Misterio/confianza — sólo metadatos, nunca texto libre).
- [ ] Aparece una **"pregunta para la cena"**: o bien la genera el
  LLM server-side, o bien cae a la plantilla offline en castellano.
- [ ] Hay un bloque **"Resúmenes anteriores"** que muestra hasta tres
  resúmenes pasados con etiqueta "Semana N de YYYY". Sólo aparece si
  hay al menos uno archivado.
- [ ] El resumen actual ya visible NO se duplica en el histórico.

**Notas / hallazgos**:


---

## Bloque 12 — Profesor (vista del aula)

Bloque B7 cableado como fallback pendiente de policy escolar.

- [ ] En Ajustes hay un bloque **"Acceder como profesor"** separado del
  bloque de cuenta del adulto-cuidador.
- [ ] El login pide email + contraseña + rol.
- [ ] Tras autenticar, la pantalla del aula muestra: formulario para
  crear primera aula → dashboard con cabecera, código del aula,
  member/reporting count y agregados por juego.
- [ ] El mensaje k≥5 aparece sin culpar al profesor ("hace falta que al
  menos 5 niños hayan reportado para mostrar agregados").
- [ ] Cerrar sesión vuelve al login.
- [ ] Reabrir la app entra directo al dashboard si la sesión persistía.

**Notas / hallazgos**:


---

## Bloque 13 — Ajustes

- [ ] Bloque **idioma** permite cambiar entre es / eu / ca. La app se
  reconstruye con los nuevos textos.
- [ ] En eu y ca: la cobertura es casi total como **fallback de
  experto** (pendiente de hablantes nativas). Si encuentras algún
  string en castellano dentro de eu o ca, anótalo como bug menor.
- [ ] **Acerca de** con versión, créditos y compromisos.
- [ ] **Política de privacidad y términos** marcada como BORRADOR.
- [ ] **Bloque login adulto** (email + contraseña + autofill) con copy
  que dice claramente que el registro NO se hace en la app sino por
  web.
- [ ] **Acceder como profesor** (ver bloque 12).
- [ ] **Mapa online** (ver bloque 9).
- [ ] **Sit spots de antes** (sólo si hay jubilados).
- [ ] **Imprimir plantilla en blanco**: abre `PantallaImprimirPlantilla`
  para generar una plantilla en blanco en PDF.
- [ ] **Exportar mi cuaderno**: genera el PDF con cabecera (nombre del
  niño, sit spot, Misterios abiertos) + observaciones, con foto y
  dibujo embebidos en caja 220×165 pt si los tiene.
- [ ] **Borrar mi cuaderno**: doble confirmación + palabra clave. Tras
  ejecutarlo, vacía Isar, borra los medios del subdirectorio, purga
  el histórico de resúmenes, resetea el opt-in del mapa y resetea
  el flag de la presentación del sit spot. El idioma y el perfil se
  conservan.
- [ ] El snackbar final reporta contadores honestos
  ("N observaciones · M misterios · K sit spots · L medios").

**Notas / hallazgos**:


---

## Bloque 14 — Multi-idioma (es / eu / ca)

- [ ] Cambiar a euskera desde Ajustes: el home, los Misterios, el
  flujo de observación y los textos del sit spot pasan a eu.
- [ ] Cambiar a catalán: igual.
- [ ] Volver a castellano: igual.
- [ ] Los 19 Misterios del seed tienen traducción provisional en eu+ca.
- [ ] Algún string puntual en castellano dentro de eu o ca → anotar.

**Notas / hallazgos**:


---

## Bloque 15 — Pruebas de robustez

- [ ] Anotar observación sin foto ni dibujo.
- [ ] Anotar observación con foto pero sin dibujo.
- [ ] Anotar observación con dibujo pero sin foto.
- [ ] Anotar observación sin GPS (sin activar el opt-in).
- [ ] Anotar observación con 0 caracteres en "crees que es" → confianza
  "consenso" debería rechazarse (consenso exige identificación).
- [ ] Crear sit spot, anotar 3 observaciones, jubilarlo: la página
  jubilada conserva las observaciones.
- [ ] Crear sit spot nuevo tras jubilar el primero, anotar: las
  observaciones del nuevo no se mezclan con las del jubilado.
- [ ] Cerrar el Misterio, reabrirlo: las observaciones que tenía
  siguen ahí.
- [ ] Formular pregunta, anotar 2 evidencias, cerrar con respuesta,
  borrar la pregunta entera: las observaciones se desanclan pero NO
  se borran (las páginas del cuaderno se conservan).
- [ ] Modo avión: app sigue funcionando para todo el flujo local
  (anotar, ver páginas, sit spot, Misterios). Sólo el Tutor IA, el
  mapa online y el sync del cuidador requieren red.
- [ ] Cerrar y reabrir la app: el estado, las páginas y el sit spot
  se conservan.
- [ ] Girar el dispositivo: ninguna pantalla se rompe.
- [ ] Hacer "borrar mi cuaderno" y reabrir: la app vuelve a un estado
  como recién instalado **excepto** idioma y nombre del perfil (que
  se conservan deliberadamente, son la cuenta del dispositivo).
- [ ] Buscar en la lista de páginas con texto raro (emoji, signos,
  cadena vacía): no debe crashear.

**Notas / hallazgos**:


---

## Bloque 16 — Perspectiva naturalista / biólogo divulgador

*Esta sección está pensada para perfiles con formación en biología,
ornitología, botánica, educación ambiental o divulgación naturalista
para infancia. El resto de testers puede saltarla o leerla por
curiosidad.*

### Catálogo de Misterios

El catálogo seminal trae **19 Misterios** literales del documento de
diseño, marcados como pendientes de validación científica (B1) y con
datos `[A VERIFICAR]` por contrastar con SEO/BirdLife, RJB-CSIC y
naturalistas locales.

- [ ] Para los Misterios que conozcas (golondrinas, primera flor,
  cigarras, líquenes, hormigas, mariposas blancas, polillas en farola,
  encina vieja, lluvia y bichos, etc.), ¿la pregunta está bien
  formulada? ¿Es **observable** por un niño de 9-13 en su lugar real,
  o exige material/conocimiento que no tendrá?
- [ ] ¿La descripción corta acota lo suficiente sin imponer la
  respuesta?
- [ ] ¿El estado declarado (consenso / hipótesis activa / no segura)
  es el que tú declararías?
- [ ] Las **ventanas fenológicas** (lista de estaciones aplicables):
  ¿son razonables para Iberia? ¿Hay Misterios marcados como "todo el
  año" que en realidad sí son estacionales y al revés?
- [ ] El **filtrado por región** (prefijos NUTS, p. ej. cigarras solo
  en zonas mediterráneas): ¿la cobertura de regiones es razonable?
  ¿Falta algún Misterio importante para tu zona?
- [ ] La **ventana caliente** ("estos días · ") usa un margen ±21 días
  sobre la transición de estación. ¿Es un buen indicador pedagógico
  o se enciende demasiado pronto / demasiado tarde?

### Sugeridor de Misterio por keyword

El sugeridor matchea el texto que escribe el niño en "qué viste" contra
una tabla de palabras clave por id de Misterio (stems en castellano,
case- y accent-insensitive).

- [ ] Para los Misterios que conozcas, ¿qué palabras escribiría un
  niño de 10 años al verlos en el campo? Prueba unas cuantas:
  "golondrina", "pájaros blancos", "hormigas en el árbol", "polilla
  en la farola", "flor amarilla en febrero", "líquenes en la
  piedra"... ¿el chip sugiere el Misterio correcto?
- [ ] ¿Hay falsos positivos evidentes (un texto neutro que dispara
  un Misterio incorrecto)?
- [ ] ¿Hay falsos negativos evidentes (un texto que claramente apunta
  a un Misterio pero el chip no aparece)?
- [ ] ¿Las palabras clave están sesgadas hacia el castellano? En
  euskera o catalán el sugeridor probablemente no funcione todavía —
  ¿es esperable o es bloqueante?

### Pedagogía del lugar

La biblia §3 organiza el oficio en cinco componentes (observar antes de
interpretar, registrar para recordar, identificar con humildad,
hipotetizar y contrastar, habitar un lugar). La app intenta
**estructuralmente** que el niño separe *qué vi* de *creo que es* y
declare confianza.

- [ ] ¿La separación "qué viste" vs "crees que es" se entiende a la
  primera para un niño de 9-13? ¿Hay forma mejor de pedirla?
- [ ] Los tres niveles de confianza (**consenso / hipótesis activa /
  no segura**): ¿son las categorías correctas? ¿Se entiende sin que
  el adulto explique?
- [ ] **El sit spot** como corazón pedagógico ("habitar un lugar"):
  ¿la presentación en tres párrafos transmite la idea o resulta
  excesivamente abstracta para esta edad?
- [ ] **Voz adulta amable** (sin diminutivos, sin "¡súper bien!",
  sin "campeón"): ¿pasa el test de la biblia "¿podría salir esto de
  alguien que llevara cuarenta años caminando este monte?"? Marca
  cualquier microcopia que claramente no pase.
- [ ] La promesa de **no humillar** (sin "incorrecto", sin rojo, sin
  XP, sin rachas): ¿se respeta a lo largo de toda la app, o hay
  alguna pantalla en la que se cuela una métrica que el niño podría
  leer como nota?

### Calendario fenológico y notas del día

Hoy se cubren 3 NUTS-3 con afirmaciones temporales específicas
(ES-NA-PA Pamplona, ES-BI Bilbao, ES-MD Madrid), 5 autonómicas con
afirmaciones genéricas (ES-CT, ES-AN, ES-AS, ES-GA, ES-CN) y fallback
país. Marcado pendiente de calendario curado por
ornitólogos/botánicos.

- [ ] Para tu zona, ¿las notas del día que ves bajo el saludo son
  acertadas en mes/estación? ¿Hay algo evidentemente fuera de sitio?
- [ ] ¿Qué afirmaciones temporales fiables crees que faltan?
- [ ] ¿Es razonable cargar afirmaciones específicas (cantos de
  cuervas, eclosiones, floraciones) sin riesgo de fechar mal?

### Identificación y guías

Hoy no hay claves de identificación regionales cableadas (es bloqueo
B1). La app sólo pide a la niña que registre *qué vi* y *qué creo que
es*, sin contrastar contra un catálogo.

- [ ] ¿Es razonable la decisión de NO incluir claves de identificación
  en esta versión, o crees que sin ellas el oficio se queda corto?
- [ ] Si añadiéramos claves regionales en una iteración futura,
  ¿desde qué grupo empezarías (aves comunes urbanas, mariposas
  diurnas, árboles, hongos, líquenes)? ¿Qué fuentes públicas crees
  que es éticamente correcto integrar?
- [ ] ¿Tiene sentido pedirle al niño nivel de confianza explícito sin
  una clave que lo respalde, o eso le aboca a poner siempre "no
  segura"?

### Privacidad y datos sensibles

- [ ] **Privacidad estructural**: el texto, las fotos y las coords
  viven sólo en local. Sólo cruzan red metadatos (hash de "qué viste",
  region_code NUTS-3, agregados firmados con HMAC). ¿Es suficiente
  para el caso de uso "niño que observa especies vulnerables (nidos,
  orquídeas raras)"?
- [ ] ¿Cómo crees que se debería gestionar el caso de que un niño
  encuentre algo de interés conservacionista (un ejemplar fuera de
  rango, una especie protegida)? La app hoy no tiene flujo para
  notificarlo a una entidad — ¿es correcta esa decisión o falta?
- [ ] El **mapa online** sólo se enciende detrás de opt-in del adulto.
  ¿La advertencia es suficiente? ¿Debería ser más explícita?

### Tutor IA

El Tutor está limitado por ZDR + lista negra + cuota.

- [ ] Si tienes acceso a un JWT y puedes probarlo, ¿la voz responde
  como cabría esperar de una bióloga divulgadora con criterio?
- [ ] ¿Hay temas que crees que el Tutor debería rebotar y no lo hace,
  o viceversa?
- [ ] ¿La cuota de 30 turnos/día es razonable para esta edad?

### Sugerencias estructurales

- [ ] ¿Qué falta en una "página del cuaderno" en términos de datos
  pedagógicamente útiles? (sonido grabado, tiempo de observación,
  intensidad de luz, sustrato, etc.)
- [ ] ¿Tiene sentido el **sit spot único activo** o sería mejor varios
  simultáneos (parque, ventana, paseo del río)?
- [ ] ¿El **chip de sugerencia** es buena pedagogía o resta autonomía
  al niño? ¿Debería ser más sutil o más explícito?
- [ ] ¿Las **preguntas formuladas por el niño** funcionan como
  contraparte simétrica a los Misterios del adulto, o se solapan?
- [ ] El **caso de aula**: vista del profesor sólo con agregados
  k≥5 — ¿es bastante para una sesión de trabajo en clase?

**Comentarios libres del naturalista**:


---

## Feedback general

Espacio libre para lo que no encaje en los bloques anteriores: voz que
choca, flujos que mejorarías, microcopia que reescribirías, prioridades
de qué arreglar primero, ideas para encargos pendientes (ilustradora
botánica, compositor de la guía sonora si la hubiera).

**Comentarios libres**:


---

## Información del tester

- **Nombre / alias**:
- **Perfil** (niña/niño 9-13 / adulto cuidador / educador / naturalista
  o biólogo / programador / otro):
- **Dispositivo**:
- **Versión Android**:
- **Idioma de la sesión** (es / eu / ca):
- **Lugar de testeo** (interior / parque / monte / patio / otro):
- **Fecha del informe**:
- **Tiempo aproximado dedicado al testeo**:
