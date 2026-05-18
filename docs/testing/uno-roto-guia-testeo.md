# Guía de testeo — Uno Roto

Juego educativo de matemáticas (fracciones, decimales, proporciones,
divisibilidad, operaciones, medidas, geometría y estadística) para niños
9-12 años. La narrativa y las matemáticas están fusionadas: el niño
recorre una ciudad rota capturando Fragmentos resolviendo puzzles. No
hay ejercicios sueltos: el ejercicio es el juego.

**Versión a testear**: 1.0.0+5 (release `apks-2026-05-18`)
**Descarga**: https://github.com/JosuIru/nuevo-ser/releases/tag/apks-2026-05-18 → `uno-roto-1.0.0+5.apk`
**Dispositivo recomendado**: Android 7+, 2 GB RAM, pantalla ≥ 5". GPS y
cámara no son necesarios. Una sesión sin conexión es perfectamente
válida; el sync al servidor y el tutor IA requieren red, pero todo lo
demás funciona offline.

**Perfil tester ideal**: niño 9-12 años jugando con un adulto observando
al lado, sin intervenir salvo si la app se rompe. Toma notas mientras el
niño juega. Si el adulto es profesor de matemáticas, rellena además el
bloque 17 (perspectiva docente).

---

## Antes de empezar

- [ ] **Instalación**: descarga el APK del enlace de la release. Al
  abrirlo Android pedirá permiso para "instalar apps de fuente
  desconocida"; concédelo solo al navegador o explorador desde el que
  abres el APK.
- [ ] **Permisos**: la app **no** pide ubicación, cámara, micrófono ni
  almacenamiento. Si te pide algo, anótalo como bug.
- [ ] **Sin conexión está bien**: puedes jugar entero sin red. El sync
  con el servidor y el chat con el tutor IA quedan inertes pero el
  juego funciona.
- [ ] **Sesión recomendada**: entre 30 y 60 minutos para cubrir lo
  básico, hasta 90 si el niño se engancha. Si más, divide en varias
  sesiones — Uno Roto no es para maratones.
- [ ] **Espacio libre**: ~80 MB para la app más ~25 MB para el paquete
  sonoro descargable si lo activas.

---

## Bloque 1 — Primer arranque y configuración inicial

- [ ] La app abre sin errores.
- [ ] Aparece la **pantalla de selección de idioma**: tres saludos
  ("Hola. / Kaixo. / Hola.") con tres botones. El niño elige castellano,
  euskera o catalán.
- [ ] Tras elegir idioma aparece la **pantalla de nombre**: un campo
  para teclear el nombre del jugador.
- [ ] El nombre se acepta y queda guardado.
- [ ] Tras introducir el nombre arranca la primera cinemática (Sora en
  el tejado). Ver bloque 4.
- [ ] Cerrar y reabrir la app no vuelve a pedir idioma ni nombre.

**Notas / hallazgos**:


---

## Bloque 2 — Pantalla mapa (HUD principal)

El mapa es el centro de operaciones. Desde ahí el niño accede al
cazadero, al entrenamiento, al cuaderno, al Faro y a las habilidades.

### Cabecera

- [ ] Cabecera con "UNO ROTO" y, debajo, el rango actual (Aprendiz I /
  II / III / Iniciado) seguido del progreso del arco activo
  ("Arco I · X/14" o equivalente).
- [ ] El rango y el arco se actualizan según el niño avanza.

### Distritos en el mapa

- [ ] Aparecen los 6 distritos como puntos en el mapa con sus nombres y
  colores propios.
- [ ] Tocar un distrito abre el cazadero en ese distrito (ver bloque 5).
- [ ] Solo los distritos desbloqueados son accesibles; los bloqueados
  muestran candado o estado equivalente.

### Chips de acción (debajo del mapa)

- [ ] **Cuaderno**: abre la pantalla del cuaderno del niño (ver bloque 14).
- [ ] **Faro**: abre el periódico semanal del lore (ver bloque 13).
  Muestra punto "·" cuando hay edición sin leer.
- [ ] **Entrenar**: abre el selector de dominios (ver bloque 6).

### Restauración progresiva

- [ ] A medida que el niño captura Fragmentos, el escenario del mapa
  cambia visiblemente (la ciudad se va recomponiendo).

**Notas / hallazgos**:


---

## Bloque 3 — Distritos y atmósferas

Cada distrito tiene una atmósfera propia visible en el cazadero
(`pantalla_caza`). En las pantallas de puzzle el fondo es neutro a
propósito.

- [ ] **Tejados** (skyline + ventanas ámbar, el original).
- [ ] **Canales** (agua oscura con reflejos, farolillos amarillo vela,
  puente bajo, niebla baja).
- [ ] **Mercado** (toldos rosa-ámbar a rayas, farolillos cálidos densos,
  vapor vertical de cocinas).
- [ ] **Industria** (chimeneas con humo, naves bajas, tuberías, neón
  teal frío).
- [ ] **Puerto** (mar oscuro en la parte inferior, muelle de madera,
  grúas siluetadas, faro pulsante, niebla densa).
- [ ] **Afueras** (Montaña ampliada con cumbre nevada, observatorio en
  el horizonte, banda de hierba, más estrellas).
- [ ] Las atmósferas se distinguen claramente entre sí y nada parpadea
  ni se solapa raro al moverse.

**Notas / hallazgos**:


---

## Bloque 4 — Cinemáticas y narrativa

Las cinemáticas son la columna narrativa del juego. Hay 4 arcos
implementados (14 + 16 + 18 + 14 escenas).

### Reveal y voces

- [ ] Las cinemáticas aparecen con reveal letra-a-letra (texto que se
  va dibujando).
- [ ] Los Fragmentos nombrados (Kurz, Eco, Zafrán, Vorax) hablan en
  itálica con tipografía serif (Cormorant Garamond), distinta del habla
  humana.
- [ ] El token `{nombre}` se sustituye por el nombre del jugador en
  todas las escenas donde aparece.
- [ ] Botón **SALTAR** funciona y avanza al siguiente plano.
- [ ] Las **opciones de elección** se presentan como botones; tocar uno
  reproduce la respuesta del personaje en pantalla.
- [ ] Algunas elecciones quedan persistidas (p. ej. las tres pruebas de
  4.7); reabrir la app las recuerda.

### Cierres amables

- [ ] Hay escenas marcadas como cierre amable con un botón "HASTA
  MAÑANA" (o "HASTA ENTONCES" en 4.14) que cierra la sesión narrativa.
- [ ] Tras el cierre, al volver a abrir la app el orquestador retoma
  donde quedó.

### Arco 1 (tejados)

- [ ] Escena 1.1 "El tejado" arranca tras introducir el nombre.
- [ ] Escena 1.2 "La primera ventana" enseña el tutorial gestual del
  primer puzzle (FR.01: dividir un Pleno).
- [ ] Tras el primer combate Kurz (kurz_1) llega el bloque emocional
  1.6 "La derrota".
- [ ] Escena 1.7 "Kai visto de lejos" se dispara al siguiente login y
  cierra la sesión.

### Variantes de entrenamiento (Arco 1)

- [ ] Entre escenas oficiales aparecen mini-cinemáticas recurrentes
  (noche despejada / niebla / lluvia / pregunta sobre la Montaña /
  buen entrenamiento).
- [ ] No se repite la misma variante dos veces seguidas dentro de una
  ronda.
- [ ] Hay también una variante 1.8f que presenta el Faro de Azula.

### Arcos 2, 3 y 4

- [ ] Arco 2 (Canales): aparece Rexán (voz ámbar), Ari (verde), Zafrán
  como Dual (Sora habla por él, sin ojos en el combate).
- [ ] Combate Zafrán jugable (MCM 7 y 11, amplificación, suma final).
  Calibrado a victoria narrativa: Zafrán escapa debilitado.
- [ ] Arco 3 (Industria/Mercado): duelo Kai jugable, Eco como escena
  clave (sin combate), santuario Coleccionistas, Vadic, Brina.
- [ ] Arco 4 (Puerto/Afueras): Oryn tutorial multiplicación, ceremonia
  de los 5 maestros, tres pruebas con elección persistida, combate
  Vorax (Impropio → Mixto), Sora revela Kir, cierre con HASTA ENTONCES.

**Notas / hallazgos**:


---

## Bloque 5 — Cazadero (captura de Fragmentos)

El cazadero es la pantalla principal de juego. Aparece al tocar un
distrito en el mapa. Los Fragmentos se spawnan con timer y el niño los
toca para iniciar un puzzle.

### Mecánica básica

- [ ] Los Fragmentos aparecen sobre la atmósfera del distrito con
  apariencia visual propia (esferas radiales, pulsos).
- [ ] Tocar un Fragmento abre **primero la ayuda pedagógica** si es la
  primera vez que el niño se enfrenta a esa familia de puzzle (ver
  bloque 7). A partir de la segunda captura va directo al puzzle.
- [ ] Resolver el puzzle correctamente captura el Fragmento; el niño
  recibe esquirlas en función de los intentos.
- [ ] Resolver mal "escapa" el Fragmento; no se cuentan esquirlas pero
  el motor de maestría sí registra el fallo.
- [ ] Tras capturar aparece un **SnackBar con el desglose**: "+X (de Y
  posibles)" cuando el niño tardó más de un intento, de manera que la
  penalty es visible.

### Spawn y atmósfera

- [ ] Los Fragmentos se spawnan a un ritmo razonable (ni demasiado
  rápido ni desierto).
- [ ] Sora puede dejar caer alguna línea de ambiente puntual.
- [ ] El distrito influye en qué habilidades aparecen más (las
  asociadas a ese distrito).

### Bloque informativo

- [ ] Cuando se sube de nivel en una habilidad, se nota visualmente y se
  activa el flag narrativo correspondiente.
- [ ] Cruzar un umbral de rango (0/30/100/250 esquirlas) sube el rango
  visible en el HUD.

**Notas / hallazgos**:


---

## Bloque 6 — Modo entrenamiento

- [ ] El botón "Entrenar" en el mapa abre un selector con los 8
  dominios: FR, DEC, PROP, DIV, OP, MED, GEO, EST.
- [ ] Tocar un dominio entra al cazadero con la atmósfera tejados (la
  familiar) y la barra superior en violeta indica "ENTRENANDO ·
  {dominio}".
- [ ] Solo aparecen Fragmentos de ese dominio.
- [ ] El selector de habilidades respeta dependencias y decaimiento.
- [ ] Salir vuelve al mapa.

**Notas / hallazgos**:


---

## Bloque 7 — Puzzles (familias)

Uno Roto tiene 66+ habilidades del MVP con puzzles implementados. No
hay que cubrir todas en una sesión, pero sí muestrear al menos una de
cada dominio.

### Acompañamiento común a todas las familias

- [ ] **Primera vez**: al tocar un Fragmento de una familia nueva,
  aparece un modal con título de la habilidad, explicación pedagógica,
  un ejemplo y una línea de "en la vida". Botón EMPEZAR cierra el
  modal y abre el puzzle. Sin temporizador: el niño dispone del tiempo
  que necesite.
- [ ] **Segunda vez en adelante**: tocar un Fragmento de la misma
  familia abre el puzzle directamente, sin modal intermedio.
- [ ] **Micro-tutorial gestual**: en cada familia nueva aparece una
  mano-fantasma (Icons.touch_app) pulsando en la zona donde hay que
  tocar, con un mensaje breve ("Toca el resultado correcto" o "Toca
  Sí/No"). Se autocierra a 3,5 s o al tocar.
- [ ] **Pista escalonada**: si el niño falla 2 veces seguidas, el
  candidato correcto se ilumina con un borde verde tenue durante 1,5 s.
- [ ] **Botón "?" ayuda contextual**: esquina superior derecha. Pulsa
  más visible cuando hay racha de fallos. Abre la explicación
  pedagógica de la familia.
- [ ] **Dialog "¿Necesitas ayuda?"** tras 5 fallos en el mismo puzzle:
  aparece con la explicación pedagógica + dos botones SEGUIR / VOLVER.
  SEGUIR reinicia el contador de intentos (el niño tiene una "segunda
  oportunidad limpia"). VOLVER cuenta como huida, no captura.

### Familias a muestrear (al menos una de cada bloque)

- [ ] **Fracciones (FR)**: Pleno (FR.01), espejo (equivalencia),
  comparación (FR.05/06/07), simplificar (FR.10), amplificar (FR.11),
  lectura ("tres quintos"), comparación con la unidad (<1, =1, >1),
  comparar con 1/2, mixto a impropio, dual (suma/resta/×/÷), fracción
  de una cantidad, razón entre cantidades, ordenar fracciones.
- [ ] **Decimales (DEC)**: lectura ("veinticinco centésimas"),
  comparación (0,35 vs 0,4), ordenar tres, operación, redondeo a la
  décima.
- [ ] **Divisibilidad (DIV)**: criterios básicos {2,3,5,10}, criterios
  avanzados {4,6,9}, múltiplos, divisores (encuentra el intruso),
  primos (sí/no), MCM, MCD.
- [ ] **Proporciones (PROP)**: razón reducida, proporcional, regla de
  tres, porcentaje de una cantidad, qué porcentaje representa A de B,
  aumentos y descuentos, escala.
- [ ] **Operaciones (OP)**: jerarquía sin paréntesis, jerarquía con
  fracciones, operación mixta decimal+fracción.
- [ ] **Medidas (MED)**: longitud (m a cm), masa/capacidad, tiempo
  sexagesimal (h+min), superficies (m² a cm²: factor 100, no 10),
  ángulo (agudo/recto/obtuso/llano).
- [ ] **Geometría (GEO)**: clasificación de polígonos (dibujado),
  perímetro, área rectángulo, área triángulo, círculo (perímetro y
  área), volumen de ortoedro (3D isométrico), simetría axial.
- [ ] **Estadística (EST)**: gráfico de barras (lectura y total),
  gráfico circular (porcentaje de porción).

### Era 3 (avanzada)

- [ ] Las pantallas Era 3 (raíz cuadrada, potencia, ecuación lineal,
  ecuación en ambos lados, Pitágoras, entero con signo, valor absoluto,
  sistema 2×2, relación lineal) reciben la dificultad calibrada del
  cazadero. Un niño avanzado no ve siempre los casos triviales.

**Notas / hallazgos**:


---

## Bloque 8 — Combates contra Fragmentos nombrados

Combates con timer y vida (ki). Cada uno es una cinemática-combate.

### Kurz (Arco 1, tres combates)

- [ ] **kurz_1**: 3 preguntas, ki=2, 4 s por pregunta. Calibrado a
  derrota; el niño puede ganar pero es difícil.
- [ ] **kurz_2**: 5 preguntas, ki=3, 6 s. Probable derrota, victoria
  posible.
- [ ] **kurz_3**: 4 preguntas, ki=4, 8 s. Calibrado a victoria.
- [ ] Kurz aparece como esfera radial violeta con ojos. Frases reactivas
  según el desempeño.
- [ ] Victoria de kurz_3 sube a Aprendiz II automáticamente (desbloquea
  la 1.13 ceremonia).

### Zafrán (Arco 2)

- [ ] Sora habla por Zafrán (silencio del Fragmento). Halo rojo oxidado,
  sin ojos.
- [ ] Preguntas sobre MCM(7,11)=77, amplificación 5/7→55/77, 3/11→21/77,
  suma 76/77.
- [ ] ki=5, 10 s por pregunta. Calibrado a victoria narrativa: Zafrán
  escapa debilitado.

### Kai (Arco 3)

- [ ] Duelo jugable.

### Vorax (Arco 4)

- [ ] Vocero narrador (silencio absoluto en combate). Halo verde.
- [ ] 5 preguntas sobre Impropio → Mixto y descomposición en cuartos
  (11/4 → 2 y 3/4 → cuartos).

### Detección de combate pendiente

- [ ] El orquestador detecta el combate pendiente antes de buscar la
  siguiente cinemática. No se puede saltar un combate por error.

**Notas / hallazgos**:


---

## Bloque 9 — Motor de maestría y rangos

### Niveles de habilidad

- [ ] El motor tiene 5 niveles por habilidad: inexplorada → introducida
  → en desarrollo → competente → maestría.
- [ ] La precisión ponderada y el tiempo mediano influyen en la subida.
- [ ] Las habilidades no practicadas decaen: 21 días para bajar un
  nivel, 14 días en niveles altos.

### Rangos narrativos

- [ ] Hay 4 rangos: Aprendiz I, II, III, Iniciado.
- [ ] Cada uno se desbloquea por dos vías: umbrales de esquirlas
  (0/30/100/250) **o** disparadores narrativos.
- [ ] Subir de rango activa el flag correspondiente y puede desbloquear
  escenas (p. ej. 1.13 requiere `rango_aprendiz_ii_alcanzado`).
- [ ] Si se cruzan dos umbrales en una sola captura (importación de
  progreso, bonus de remonte), todos los flags intermedios se activan,
  no solo el del rango final.

**Notas / hallazgos**:


---

## Bloque 10 — Perfiles

- [ ] Si solo hay un perfil, la app arranca en el flujo normal.
- [ ] Si hay más de uno, arranca en el selector de perfiles.
- [ ] **Crear perfil**: botón en el selector pide un nombre. Si el slug
  colisiona añade sufijo numérico.
- [ ] **Cambiar de perfil**: hay botón en la pantalla de habilidades
  para volver al selector. Al volver, el progreso del nuevo perfil
  arranca limpio (o desde donde lo dejó).
- [ ] **Borrar perfil**: borra solo ese perfil.
- [ ] **Resetear perfil activo**: borra solo el progreso del perfil
  activo y preserva su nombre.
- [ ] El cuaderno, las habilidades y las cinemáticas son por-perfil; el
  idioma y la versión del paquete sonoro son globales (compartidos
  entre perfiles).

**Notas / hallazgos**:


---

## Bloque 11 — Sonido

### Capas y ajustes

- [ ] El servicio sonoro tiene 4 capas: ambient, música, efectos,
  narrativos.
- [ ] Pantalla "Ajustes de sonido" accesible desde habilidades: 4
  sliders (uno por capa) + switch de modo silencio.
- [ ] Las preferencias se guardan por perfil.
- [ ] Mover los sliders cambia el volumen al instante.

### Paquete sonoro descargable

- [ ] Solo los efectos cortos (~150 KB) están empaquetados en el APK;
  ambient + música + narrativos se descargan del servidor.
- [ ] En Ajustes de sonido aparece el botón de **descargar paquete**
  con barra de progreso por fase (descargando / verificando /
  descomprimiendo).
- [ ] Sin conexión, el paquete no se descarga pero la app sigue
  funcionando (sin esos sonidos).
- [ ] Botón **borrar paquete** libera el espacio.
- [ ] Tras borrar, los efectos cortos siguen sonando (vienen en el APK).

### Efectos integrados

- [ ] Suenan efectos en acierto / error / fusión / fragmento disuelto /
  whoosh / tap / ki subiendo.
- [ ] Ambient: tejados (vinilo lo-fi), canales (agua), industria
  (ticking clock), afueras (grillos nocturnos).
- [ ] No suenan "premios" agresivos (es deliberado: principio 3 — nada
  de euforia ni sonidos de castigo).

**Notas / hallazgos**:


---

## Bloque 12 — Tutor IA (Eco)

Requiere token de backend. Sin token, todo el tutor queda inerte (no
da error, simplemente no aparece la oferta).

### Disparo

- [ ] El **DisparadorTutor** vigila fallos consecutivos. Tras 3 fallos
  consecutivos en una habilidad (con cooldown de 10 min entre ofertas)
  se cumple el umbral.
- [ ] Los fallos cuentan tanto cuando un Fragmento se escapa como
  cuando el niño falla varias veces dentro del mismo puzzle (aunque
  acierte al final). El contador de fallos para el tutor sobrevive al
  reset del dialog "¿Necesitas ayuda?" tras 5 fallos, así que la
  oferta refleja lo que de verdad le costó.
- [ ] Cuando un Fragmento se escapa, si el umbral se cumple, aparece
  un dialog cariñoso "¿Hablo con Eco?" con botones sí/no.

### Conversación

- [ ] Aceptar la oferta abre la pantalla de tutor con el contexto del
  Fragmento.
- [ ] Conversación con burbujas, máximo 280 caracteres por mensaje.
- [ ] Mientras la respuesta está en vuelo, aparece una **burbuja
  "pensando" con tres puntos pulsantes**.
- [ ] La respuesta llega en castellano, con voz cariñosa, sin dar la
  solución directa.
- [ ] Mensajes rechazados por el filtro (p. ej. preguntas fuera de
  ámbito) aparecen en color tenue con mensaje claro.

### Filtro y caché

- [ ] El filtro cliente rechaza datos personales (email, números de
  teléfono, inyecciones) antes de salir a red.
- [ ] La caché LRU 200 + TTL 30 días devuelve respuestas idénticas a
  preguntas equivalentes (mayúsculas, espacios extra, etc.) sin volver
  a llamar a la API.

**Notas / hallazgos**:


---

## Bloque 13 — El Faro de Azula

Periódico semanal del lore que se lee dentro del juego.

- [ ] Chip "Faro" en el HUD del mapa (icono periódico, color ámbar).
- [ ] Badge "·" cuando hay edición sin leer, incluido el primer
  arranque.
- [ ] Al abrir por primera vez, la app fija "primera vista" y a partir
  de ahí cada 7 días cambia la edición disponible.
- [ ] La pantalla del Faro es scroll vertical único, tipografía
  Cormorant Garamond, cabecera tipo periódico antiguo con doble línea.
- [ ] Cada edición tiene **portada + crónica + cartas al director +
  acertijo matemático**, separados por `※`.
- [ ] El parser interpreta `**negrita**` y `*cursiva*`.
- [ ] El acertijo se presenta en recuadro destacado con TextField +
  botón ENVIAR.
- [ ] Al enviar la respuesta aparece "Tu respuesta queda anotada en el
  buzón" (el periódico no corrige al niño; la solución llega en la
  edición siguiente).
- [ ] El banco tiene 10 ediciones inicialmente.

**Notas / hallazgos**:


---

## Bloque 14 — Mi Cuaderno y otras pantallas auxiliares

- [ ] **Mi Cuaderno**: pantalla del niño con su progreso narrativo y
  matemático. Se abre desde el HUD del mapa.
- [ ] **Habilidades** (`pantalla_habilidades`): listado de las 66+
  habilidades con su nivel actual. Útil para entender por dónde va el
  niño.
- [ ] **Atlas del distrito**: muestra las habilidades del distrito.
- [ ] **Progreso del distrito**: porcentaje y desglose por habilidad.
- [ ] **Panel del tutor**: si existe acceso al historial del tutor IA,
  abre desde habilidades.
- [ ] **Cuenta**: gestión de la cuenta backend (token, email).
- [ ] **Solicitar reset**: pide reset de la cuenta backend.
- [ ] **Tour educadores**: tour visual de la app pensado para enseñar
  el juego a un adulto. Léelo entero al menos una vez.

**Notas / hallazgos**:


---

## Bloque 15 — Sync con backend

Requiere token y red. Sin uno de los dos, el sync queda inactivo sin
romper nada.

- [ ] La app sincroniza progreso al servidor cada 10 minutos en
  background mientras el cazadero está abierto.
- [ ] Si el servidor devuelve 401 (token caducado o revocado), el timer
  se cancela y el token local se borra. No reintenta para siempre con
  token muerto.
- [ ] Otros errores (red caída, timeout, JSON corrupto) se loguean pero
  no rompen la sesión.
- [ ] Si una sync tarda más de 10 minutos, la siguiente iteración del
  timer salta sin encadenar escrituras.

**Notas / hallazgos**:


---

## Bloque 16 — Pruebas de robustez

Cosas que pueden romper. Prueba todas si puedes.

- [ ] Cerrar y reabrir la app a mitad de un puzzle: ¿conserva o reinicia
  con buen tono?
- [ ] Cerrar la app en medio de una cinemática: ¿retoma donde quedó?
- [ ] Modo avión durante toda la sesión: el juego completo funciona
  salvo tutor y sync.
- [ ] Modo avión durante el sync: el timer no rompe la sesión, los
  cambios quedan pendientes y se suben al volver la red.
- [ ] Modo avión durante la oferta de Eco: no aparece la oferta o se
  marca como "sin conexión" con buen tono, no error pelado.
- [ ] Girar el dispositivo: no rompe el mapa, las cinemáticas, los
  puzzles ni los combates.
- [ ] Tocar muchas veces rápido el mismo Fragmento: solo se abre un
  puzzle.
- [ ] Volver atrás en plena cinemática con el botón sistema (back de
  Android): comportamiento razonable, no cierre seco.
- [ ] Crear varios perfiles y alternarlos a media partida: el progreso
  de uno no contamina al otro.
- [ ] Borrar el perfil activo y volver al selector: la app no crashea.
- [ ] Cerrar la app justo después de subir de nivel una habilidad:
  abrir de nuevo conserva el flag (el `await` en `alSubirNivel` cubre
  esta carrera).
- [ ] Cerrar la app justo después de cambiar idioma: el idioma se
  conserva (no se mueve al prefijo de perfil).
- [ ] Borrar el paquete sonoro y reiniciar: la app sigue funcionando,
  sin sonidos largos pero con efectos cortos.
- [ ] Fallar 5 veces seguidas el mismo puzzle: aparece "¿Necesitas
  ayuda?". SEGUIR reinicia intentos. VOLVER no marca como capturado.
- [ ] Cruzar dos umbrales de rango en una sola captura (poco probable
  en juego normal; comprobar si se diera): se activan todos los flags
  intermedios.

**Notas / hallazgos**:


---

## Bloque 17 — Perspectiva profe de matemáticas

*Esta sección está pensada para perfiles con formación o experiencia
docente en matemáticas (9-12 años). El resto puede saltarla o leerla
por curiosidad.*

### Modelo pedagógico

- [ ] **Fusión narrativa-mecánica**: las matemáticas son el gameplay,
  no el peaje. ¿Funciona el encuadre? ¿El niño percibe que está
  haciendo "deberes" o que está jugando?
- [ ] **Motor de maestría con 5 niveles + decaimiento**: ¿es razonable
  el modelo? ¿Los umbrales de subida (precisión ponderada + tiempo
  mediano) son sensatos?
- [ ] **Decaimiento de 21 / 14 días**: ¿es agresivo de más, agresivo de
  menos, correcto?
- [ ] **Acompañamiento (pista escalonada + ayuda tras 5 fallos +
  micro-tutorial gestual + dialog pedagógico la primera vez)**: ¿qué
  niveles de andamiaje funcionan y cuáles sobran?

### Catálogo de habilidades

- [ ] **Mapa de 66 habilidades en 8 dominios** (FR/DEC/PROP/DIV/OP/MED/
  GEO/EST): para el rango de 9-12 años, ¿está la cobertura completa o
  faltan piezas?
- [ ] **Dependencias entre habilidades** (`coherencia_catalogo_test`):
  ¿el orden en que se introducen es razonable?
- [ ] **Distractores curados** (los textos del CLAUDE.md describen
  errores reales de cada habilidad): ¿los distractores reflejan los
  errores que tú ves en clase?
- [ ] **Brechas cubiertas**: ¿hay alguna habilidad básica del currículo
  que el niño no podría ejercitar aquí?

### Dificultad y progresión

- [ ] **Era 1 vs Era 2 vs Era 3**: la progresión por eras, ¿se nota?
  ¿Hay saltos demasiado bruscos?
- [ ] **Dificultad calibrada por esquirlas** (Era 3): ¿el niño avanzado
  recibe ejercicios suficientemente exigentes?
- [ ] **Anti-repetición + decaimiento + bonus distrito** en el selector
  adaptativo: ¿la mezcla resultante mantiene interés sin agotar
  habilidades?

### Modo entrenamiento

- [ ] El modo entrenamiento permite practicar un dominio completo. ¿Es
  útil para reforzar un tema antes de un examen, por ejemplo? ¿Falta
  algo (selección por habilidad concreta, sesión cronometrada)?

### Tutor IA

- [ ] **No da la solución directa**: ¿el balance entre ayudar y no dar
  la respuesta funciona?
- [ ] **Filtro de entrada** (rechaza emails, inyecciones, fuera de
  ámbito): ¿cubre los casos que esperarías en un aula?
- [ ] **Caché agresivo**: ¿pierde calidez si dos niños distintos
  reciben la misma respuesta byte-idéntica? ¿O es asumible?

### Privacidad y monetización

- [ ] **Sin tracking, sin ads, sin monetización**: ¿es viable mantener
  el principio en producción real (escuelas, familias)?
- [ ] **Open source AGPL + contenido CC-BY-SA**: ¿añade o quita valor
  para un docente que evalúa adopción en el aula?

### Sugerencias estructurales

- [ ] ¿Qué pantallas faltan para que un profe pueda usar esto en clase?
  ¿Panel de seguimiento, exportación de progreso, modo aula?
- [ ] ¿Cómo se debería gestionar el reset del progreso al cambiar de
  curso?
- [ ] ¿Cómo cambiarías la fricción del cazadero (spawn timer, captura)
  si lo usaran en clase 30 minutos?
- [ ] ¿Qué le falta al cuaderno (`Mi Cuaderno`) para que sea útil para
  un seguimiento docente?

**Comentarios libres del profe de matemáticas**:


---

## Feedback general

Espacio libre para lo que no encaje en los bloques anteriores:
funcionalidades que faltan, flujos que mejorarías, comparaciones con
otras apps que conoces, prioridades de qué arreglar primero, momentos
en los que el niño se rio o se aburrió, frases sueltas del niño durante
la sesión, etc.

**Comentarios libres**:


---

## Información del tester

- **Nombre / alias adulto**:
- **Edad del niño / niños**:
- **Curso escolar**:
- **Perfil del adulto** (familia / profe de mates / programador / otro):
- **Dispositivo**:
- **Versión Android**:
- **Idioma elegido en la app** (castellano / euskera / catalán):
- **Fecha del informe**:
- **Tiempo aproximado dedicado al testeo**:
- **¿El niño volvería a jugar mañana?** (sí / no / con peros):
