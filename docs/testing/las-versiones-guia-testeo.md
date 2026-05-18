# Guía de testeo — Las Versiones

Juego educativo de **pensamiento histórico** para 10-14 años. La
protagonista, **Maren**, 13 años, ingresa al Archivo de Iruña como
Aspirante a Cronista y aprende el oficio: formular preguntas, evaluar
fuentes, anclar afirmaciones en evidencia y declarar niveles de
confianza con honestidad. Cubre la historia de Nafarroa a lo largo de
cuatro arcos narrativos, desde la prehistoria hasta el umbral de la
Conquista de 1512.

**Versión a testear**: 0.0.1 (release `apks-2026-05-18`)
**Descarga**: https://github.com/JosuIru/nuevo-ser/releases/tag/apks-2026-05-18 → `las-versiones-0.0.1.apk`
**Dispositivo recomendado**: Android 7+ con al menos 2 GB de RAM. La
app no requiere GPS, ni cámara, ni conexión continua a internet — la
sincronización del Mosaico con el companion es opt-in y silenciosa.
**Perfil tester ideal**: un niño o niña de 10-14 jugando, con un adulto
observando cómo lee, dónde se atasca y qué entiende; o un profesor o
profesora de historia o ciencias sociales. Hay una sección final
específica para perfil docente o académico.

---

## Antes de empezar

- [ ] **Sesión sin prisa**: una sesión de juego completa por una Brecha
  (las 5 fases más cinemáticas alrededor) lleva entre 30 y 60 minutos.
  Recorrer un arco completo, varias horas. Mejor varias sesiones
  cortas que una maratón.
- [ ] **Permisos**: la app no pide permisos sensibles (sin GPS, sin
  cámara, sin almacenamiento). Sólo internet, opt-in al hacer login
  del adulto.
- [ ] **Idioma**: en la primera pantalla se ofrece castellano / euskera
  / català. **El contenido narrativo largo de hoy está en castellano**
  — la traducción humana revisada de euskera y catalán aún no está
  cableada (los menús sí cambian; las cinemáticas no). Elige castellano
  para testear el grueso del contenido.
- [ ] **No es un juego "de ganar"**: Las Versiones no premia tener
  razón. Premia haber juzgado bien con lo disponible. Si te ves
  intentando "acertar", desacelera: la pregunta interesante es si el
  juego te ayuda a *pensar*, no si te deja "pasar de nivel".

---

## Bloque 1 — Primer arranque y configuración inicial

- [ ] La app abre sin errores en el primer arranque.
- [ ] Aparece la **PantallaConfiguracionInicial** con el selector de
  idioma trilingüe (Castellano / Euskara / Català).
- [ ] Elegir un idioma pasa a la primera cinemática del juego (1.0.1
  *El Archivo de Iruña*).
- [ ] Cerrar y volver a abrir la app: arranca exactamente donde se
  dejó, sin volver a pedir idioma.

**Notas / hallazgos**:


---

## Bloque 2 — Cinemáticas: navegación y comprensión

Las cinemáticas son diapositivas con plano de ambiente, retrato de
quien habla, texto del diálogo y tap para avanzar.

- [ ] El tap en el cuerpo de pantalla avanza al siguiente plano.
- [ ] Durante un **PlanoAmbiente** (descripción del lugar sin diálogo),
  el tap salta el temporizador y avanza inmediatamente — no hace falta
  esperar los segundos enteros.
- [ ] En un **PlanoDialogo** se muestra avatar del personaje + nombre
  en versalitas + texto. El nombre y el avatar son consistentes con
  quien habla.
- [ ] Cuatro personajes principales (Maren, Isaura, Aitor, Karim)
  tienen **retrato ilustrado en acuarela**. El resto del elenco (~13
  personajes) tiene **avatar procedural** (círculo con inicial y
  color).
- [ ] El fondo de la escena es coherente con el lugar: la mayoría de
  ubicaciones reales (Aralar, Roncesvalles, Leyre, Tudela, San Cernin,
  Plaza Castillo, Estella, Selva de Irati, Calle Mayor Pamplona, etc.)
  llevan **foto atmosférica** con veladura sepia. Las ubicaciones sin
  foto cubrible llevan **motivo procedural** (estanterías, lámpara,
  paisaje, interior coche, etc.).
- [ ] En las escenas dentro de un coche (`coche_isaura`, `coche_aitor`,
  `coche_marina`) se ve una ventanilla lateral con perspectiva de
  copiloto sugiriendo movimiento (motivo procedural específico).
- [ ] Hay **planos de elección** donde Maren ofrece dos o tres
  opciones de respuesta. Tocar una opción avanza.
- [ ] El texto se lee bien sobre el fondo (la veladura oscura del
  tercio inferior preserva legibilidad incluso con foto de fondo).
- [ ] El **engranaje superior derecho** está siempre disponible
  durante cinemáticas — abrir el menú no rompe el progreso.
- [ ] Salir de la cinemática y volver: la cinemática reanuda en el
  plano donde se dejó.

**Notas / hallazgos**:


---

## Bloque 3 — Una Brecha entera: las cinco fases

Cuando una cinemática deja a Maren ante una Brecha, se abre la
`PantallaBrecha` con cabecera + indicador de fases + cuerpo. La
primera Brecha del juego es la 1.1 (Aralar, dolmen). Para testear el
ciclo completo, recorre una entera de principio a fin.

### Fase 1 — Formulación de preguntas

- [ ] Aparece una pantalla con intro corta + botón **"?"** de ayuda
  arriba a la derecha.
- [ ] El diálogo de ayuda explica los cuatro tipos de pregunta:
  **DATO**, **CAUSA**, **QUIÉN MIRA**, **CÓMO LO SABEMOS**, con
  ejemplos concretos para 10-14.
- [ ] El campo de texto permite escribir una pregunta. Hay que
  elegir el tipo antes de validarla.
- [ ] El sistema valida la calidad de la pregunta y la acepta o pide
  reformular (PR.01 / PR.02 del motor de habilidades).
- [ ] Se pueden formular varias preguntas antes de pasar a la
  siguiente fase.

### Fase 2 — Recolección de fuentes

- [ ] Aparece un catálogo de fuentes diegéticas (5 a 7 según Brecha):
  textos, objetos, testimonios, evidencia arqueológica, mapas.
- [ ] Cada fuente tiene `tipoVisible` (primaria / secundaria) y
  descripción.
- [ ] Marcar una fuente como recogida la añade a la Mesa de Trabajo.

### Fase 3 — Evaluación (Mesa de Trabajo)

- [ ] Para cada fuente recogida se pide clasificar tipo (primaria /
  secundaria) y sesgo (oficialista / invisibilizador / difusionista /
  presentista, o ausencia de sesgo).
- [ ] El botón **"?"** de ayuda explica los cuatro sesgos con
  vocabulario para 10-14 + un ejemplo por sesgo.
- [ ] La evaluación se persiste por par (Brecha, fuente).

### Fase 4 — Reconstrucción

- [ ] Aparecen las afirmaciones canónicas de la Brecha (entre 4 y 9
  según Brecha).
- [ ] Para cada afirmación, el jugador declara nivel de confianza:
  **SÓLIDO** / **PROBABLE** / **DISPUTADO**.
- [ ] El botón **"?"** explica los tres niveles con ejemplos.
- [ ] Cada afirmación puede anclarse a evidencia (las fuentes
  recogidas).
- [ ] El juego exige declarar al menos N afirmaciones para pasar al
  Concilio (N depende de la Brecha — desde 3 en Brechas pequeñas hasta
  7 en la 3.6 sobre el incendio de la judería de Tudela).

### Fase 5 — El Concilio

- [ ] La revisora (Isaura, Karim, Aitor, Joana o Begoña según Brecha)
  da feedback sobre la calibración de Maren.
- [ ] El **feedback se basa en honestidad de calibración (Brier
  invertido del perfil P4)**, no en "acertar". Probar que declarar
  alguna afirmación con sobre-confianza (todo SÓLIDO) recibe feedback
  distinto que declarar con calibración cuidadosa.
- [ ] La Brecha cierra y aparece el flag de completada — la siguiente
  cinemática se desbloquea.

**Notas / hallazgos**:


---

## Bloque 4 — Arco 1 entero (Aralar, prehistoria, Brechas 1.1 a 1.4)

El Arco 1 es el más estable y testeado del juego — referencia base.
Desde la configuración inicial hasta el cierre 1.Z se recorre
end-to-end. Las cuatro Brechas:

- [ ] **Brecha 1.1** *El dolmen de Aralar* — 5 fases jugables.
- [ ] **Brecha 1.2** — segunda Brecha del arco, jugable.
- [ ] **Brecha 1.3** — tercera Brecha del arco, jugable.
- [ ] **Brecha 1.4** — cuarta Brecha del arco; cierre con el gran
  Concilio (1.4.3) y la cinemática Aprendiz I (1.4.4) que asciende a
  Maren de Aspirante a Aprendiz I.
- [ ] Entre Brechas aparecen **cinemáticas latentes** 1.A (Eider en
  cafetería), 1.B (Andrés y el informe antiguo), 1.B.1, 1.C (Marina) —
  son escenas íntimas no-Archivo que cultivan el resto del mundo.
- [ ] **Mosaico v2** del Arco 1: cómic mudo de 8 viñetas, cada una con
  selector de código de confianza. Mínimo 6 marcadas para entregar.
- [ ] Cinemática **1.M1.entrega** (Andrés + Marina reciben el Mosaico).
- [ ] **Cinemática 1.Z** cierre del Arco 1.

**Notas / hallazgos**:


---

## Bloque 5 — Arco 2 entero (Pompelo, Wamba, silencio vascón)

El Arco 2 (*La forja del reino* — no, esa es del Arco 3; este es
"Pompelo bajo Iruña" + Calagurris + domus + Wamba) tiene 34
cinemáticas + 4 Brechas jugables + Mosaico M2 audio-guía + cierre 2.Z.

- [ ] **Estación 2.1** *Pompelo bajo Iruña* — apertura 2.0.1 + 6
  cinemáticas + Brecha 2.1 (ara funeraria de Aelio Attiano, doble
  inscripción s. I / s. III, error gramatical del lapicida,
  reutilización en muralla bajoimperial).
- [ ] **Brecha 2.1 jugable**: 4 fuentes (ara primaria, publicación
  Velaza 2014 secundaria, tablillas hospitalarias de Arre primarias,
  muralla bajoimperial primaria) + 10 afirmaciones con calibración
  doble (hecho / causa) + mínimo 7.
- [ ] **Cinemáticas latentes 2.A** (Quintiliano + Marina y los
  descansos).
- [ ] **Estación 2.2** *Quintiliano de Calagurris* — 6 cinemáticas +
  Brecha 2.2 (4 fuentes, 7 afirmaciones, mínimo 5). HF.10 detección
  de omisiones hace su debut jugable.
- [ ] **Latente 2.B.1** (cuaderno de Isaura).
- [ ] **Estación 2.3** *Domus de los mosaicos* — 6 cinemáticas +
  Brecha 2.3 (familia Cornelia ficticia diegética, 4 fuentes, 8
  afirmaciones, mínimo 6). Matiz **"Sólido (la ausencia)"** sobre las
  personas esclavizadas no nombradas.
- [ ] **Latente 2.C.1** (Eider y el cambio).
- [ ] **Estación 2.4** *Wamba contra los vascones* — 8 cinemáticas +
  Brecha 2.4 (Wamba + Julián de Toledo + yacimiento vascón del norte
  deliberadamente sin nombre histórico; 4 fuentes, 9 afirmaciones,
  mínimo 7). Matiz **"Sólido (la ausencia)"** sobre el silencio vascón
  como dato + **"Sólido como declaración metodológica"** sobre el
  techo estructural de la reconstrucción.
- [ ] **Concilio dividido** de la 2.4 con cinco voces revisoras
  (Karim, Aitor, Joana, Begoña, Isaura) que cierra sin consenso y
  registra el desacuerdo.
- [ ] Cinemática **Aprendiz II** (cierre 2.0.1 simétrico en el patio
  del Archivo).
- [ ] **Mosaico M2 audio-guía**: 8 fragmentos pre-escritos con
  selector de código de confianza por fragmento. Mínimo 6 para
  entregar. Distinto formato del M1 (cómic).
- [ ] Cinemática **M2.entrega** (Andrés con auriculares en el ático,
  *"has dicho 'no sabemos' tres veces. Y 'probablemente' cuatro" /
  "está perfecto"*).
- [ ] **Cierre 2.Z** (cocina con Antonio + Maren grabando con el
  móvil + cuarto de Maren escuchando la grabación).

**Notas / hallazgos**:


---

## Bloque 6 — Arco 3 entero (San Cernin, Banu Qasi, Roncesvalles, Tudela 1378)

El Arco 3 (*La forja del reino*) tiene 6 Estaciones, de las cuales 5
son jugables (la 3.2 Banu Qasi sigue narrativa-sin-Brecha-jugable a la
espera de validación del comité). 48 cinemáticas + 5 Brechas jugables
+ Mosaico M3 ficha de museo + cierre 3.Z.

- [ ] **Apertura 3.0.1** (despacho de Isaura, anuncio del calendario
  del arco) + **3.0.2** (Eider en plaza Castillo, *"Otra vez fuera"*).
- [ ] **Estación 3.1** *San Cernin y las tres lenguas* — 5
  cinemáticas + Brecha 3.1 jugable (5 fuentes incluido Fuero de
  Pamplona-San Cernin de 1129, 7 afirmaciones, mínimo 5). HF.07
  plurilingüismo extendido a tres lenguas (latín, romance navarro,
  occitano gascón) + euskera oral como inferencia indirecta Probable.
- [ ] **Latente 3.A.1** (Marina y los puentes).
- [ ] **Estación 3.2** *Tudela y los Banu Qasi* — 9 cinemáticas
  narrativas incluido **el primer encuentro con Tasio** en la
  cafetería del casco viejo. **No tiene Brecha jugable todavía**
  (bloqueada por validación BANU-QASI). El silencio de Maren al final
  de 3.2.8 (no escribe en el Cuaderno) es deliberado.
- [ ] **Latente 3.B.1** (*¿Te trató bien?* — Isaura confiesa *"lo sigo
  queriendo"*).
- [ ] **Estación 3.3** *Leyre y la leyenda del abad Virila* — 6
  cinemáticas + Brecha 3.3 (5 fuentes, 6 afirmaciones, mínimo 4).
  PH.10 *"la leyenda como fuente de su propia época, no de la que
  cuenta"* hace su debut narrativo.
- [ ] **Latente 3.C.1** (Naia pregunta sobre las películas y las
  leyendas).
- [ ] **Estación 3.4** *Roncesvalles* — 7 cinemáticas + Brecha 3.4 (5
  fuentes, 8 afirmaciones, mínimo 5). PH.10 ampliado a propaganda
  cruzada (*Chanson de Roland* h. 1100 reescribe identidades).
- [ ] **Latente 3.D.1** (*Eider se va* — *"Estoy cansada de tener una
  mejor amiga que tiene una vida que yo no entiendo"*).
- [ ] **Estación 3.5** *Estella en su esplendor* — Brecha de respiro
  (4 fuentes, 6 afirmaciones, mínimo 4, sin Disputadas). Lección del
  oficio sostenible.
- [ ] **Estación 3.6** *El incendio de la judería de Tudela 1378* —
  10 cinemáticas + Brecha 3.6 (7 fuentes, 9 afirmaciones, mínimo 7).
  El material más sensible del MVP — varios puntos pendientes de
  validación del comité asesor. Si juegas esta Brecha, lee primero la
  zona "fragilidad" más abajo en este documento.
- [ ] **Mosaico M3 ficha de museo**: cartela de 6 líneas
  (procedencia, datación, lengua, función original, reutilización, lo
  que la piedra dice). Mínimo 5 marcadas para entregar. Formato
  distinto del M1 y M2.
- [ ] Cinemática **M3.entrega** (Andrés en el ático).
- [ ] **Cierre 3.Z Aprendiz III** (Maren e Isaura en el patio, *"No
  hay decidir bien o mal. Hay decidir con honestidad. Lo que sea con
  honestidad será bien"*).

**Notas / hallazgos**:


---

## Bloque 7 — Arco 4 entero (Olite, Estella, Tudela, Conquista 1512)

El Arco 4 (*Una corte brillante en su crepúsculo*) cierra el MVP. 27
cinemáticas + 2 Brechas jugables + Mosaico M4 doble cartela + cierre
4.Z + ceremonia de graduación a Cronista.

- [ ] **Apertura 4.0.1** + **Estación 4.1** *Olite* — primera
  **Brecha de Aprendiz III avanzado**: Maren elige el sujeto (Joana
  de Roncal entre las cuentas de palacio) en lugar de recibirlo. 4
  fuentes + 8 afirmaciones + mínimo 6.
- [ ] **Día de Archivo grande 4.A** (cartas de Catalina de Foix
  sobre la antesala de 1512, reproducidas literalmente del doc 10).
- [ ] **Estación 4.B** *Tres comunidades en Estella* — Brecha sobre
  **La pared medianera de Estella 1394** (pleito por pared medianera
  + responsa rabínicos). 4 fuentes + 8 afirmaciones + mínimo 6. *Caso
  pequeño como ventana a la cotidianidad* hace su debut pedagógico
  explícito.
- [ ] **Cuatro días-Archivo** 4.C / 4.D / 4.E / 4.F.
- [ ] **Día de Archivo grande 4.G** (segundo encuentro con Tasio en
  Tudela).
- [ ] **Mosaico M4 doble cartela paralela** — fragmento cerámico
  campaniforme del primer dolmen de Aralar + ara funeraria romana de
  Pompelo. Dos cartelas de 6 líneas cada una. Mínimo 10 de 12 líneas
  marcadas para entregar.
- [ ] **Víspera + ceremonia de graduación a Cronista** + **cierre
  4.Z** (patio vacío del Archivo, Maren sola tras la ceremonia).

**Notas / hallazgos**:


---

## Bloque 8 — Menú principal (engranaje)

Engranaje superior derecho disponible desde **cualquier pantalla**
(esqueleto, cinemática, Brecha, Mosaico).

### MI ARCHIVO

- [ ] **Cuaderno**: lista las entradas registradas del Cuaderno de
  Maren a lo largo del juego. Cada entrada está identificada por
  cinemática que la disparó.
- [ ] **Avances**: barra de progreso `LinearProgressIndicator` ámbar
  por arco (CERRADO / EN MARCHA / SIN ABRIR) + contadores X/Y de
  Brechas completadas, entradas del Cuaderno, Mosaicos entregados. La
  pantalla cierra con el aforismo *"Las Versiones no premia tener
  razón. Premia haber juzgado bien con lo disponible."*
- [ ] **Resúmenes**: lista los Mosaicos entregados o pendientes con
  contador "X de 8/12 piezas marcadas" y chip de nivel por pieza.

### MI CUENTA

- [ ] **Cambiar perfil**: abre `PantallaPerfiles` con lista de
  perfiles, FAB ámbar para crear nuevo, papelera por fila (oculta
  cuando queda uno solo), tap para activar. Crear un segundo perfil
  (p. ej. "ander") y verificar que su progreso es **aislado** del
  perfil principal.
- [ ] **Iniciar sesión** (adulto acompañante): pide email + contraseña.
  En éxito el botón pasa a "SESIÓN INICIADA"; tras esto el Mosaico se
  sincroniza con el companion en segundo plano sin bloquear nada. En
  fallo de red o credenciales muestra mensaje en castellano sin caer.
- [ ] **Cerrar sesión**: desvincula este Archivo del adulto. **El
  progreso, los Mosaicos y el Cuaderno se preservan en local.**
- [ ] **Idioma**: diálogo Castellano / Euskara / Català con el activo
  resaltado. Disclaimer honesto: *"El contenido narrativo largo de hoy
  está en castellano."* Cambiar a euskera y verificar: menús cambian,
  cinemáticas no.

### AYUDA Y AJUSTES

- [ ] **Instrucciones**: pantalla scrollable con tres secciones (DE
  QUÉ TRATA / CÓMO SE JUEGA / PARA TUTORES Y MAESTROS). El parser
  entiende `**negrita**` y `*cursiva*`.
- [ ] **Audio**: switch global de **modo silencio** + cuatro sliders
  de volumen por capa (Ambiente / Música / Efectos / Narrativos). El
  modo silencio deshabilita los sliders sin perder valores. Las
  preferencias son **por perfil**. Disclaimer: *"Las Versiones todavía
  no tiene sonidos asignados a todas las escenas."*
- [ ] **Créditos**: lista de 18 fotos atmosféricas con autor +
  licencia + para qué sirve cada una en el juego (CC0 / CC-BY /
  CC-BY-SA). Atribución legal completa.
- [ ] **Resetear Archivo**: doble confirmación. Borra todas las
  claves del namespace `nuevoser.lasversiones.*` del perfil activo y
  vuelve a la `PantallaConfiguracionInicial`. **Verificar**: las
  claves de otros namespaces del dispositivo (p. ej. `uroto.*` si
  coexisten) NO se tocan.
- [ ] **Salir**: cierra la app limpiamente. El progreso queda
  guardado.

**Notas / hallazgos**:


---

## Bloque 9 — Cuaderno de la Cronista

Espacio personal de Maren, **no se evalúa**, no atomiza habilidades.

- [ ] El Cuaderno se rellena automáticamente al cerrar ciertas
  cinemáticas (las que disparan voz del Cuaderno).
- [ ] La pantalla "Cuaderno" desde el menú lista las entradas
  registradas. Cada entrada tiene el texto de la voz del Cuaderno
  esa noche.
- [ ] Una entrada concreta: **en 3.2.8** (final de la Estación Tudela
  / primer Tasio), Maren **no escribe** — el silencio es el dato. El
  Cuaderno NO debería registrar entrada en esa noche.

**Notas / hallazgos**:


---

## Bloque 10 — Multi-perfil

- [ ] Tras F2-26 la app es multi-perfil. El perfil "principal" se
  crea automáticamente al primer arranque.
- [ ] Crear un segundo perfil "ander" desde el menú.
- [ ] Cambiar a "ander" y verificar que arranca **vacío** (vuelta a
  configuración inicial; no ve el progreso del principal).
- [ ] Volver a "principal" y verificar que el progreso sigue intacto.
- [ ] Borrar "ander". El activo no cambia.
- [ ] **Migración silenciosa**: si actualizas desde una instalación
  previa (anterior a F2-26), el progreso debería migrar
  automáticamente al perfil "principal" sin pérdida.
- [ ] **Tres claves son globales del dispositivo y NO se separan por
  perfil**: idioma de la app, token de sesión del adulto, email de la
  cuenta. Comprobar que cambiar de perfil no obliga a re-loginear ni
  re-elegir idioma.

**Notas / hallazgos**:


---

## Bloque 11 — Cinemáticas y persistencia entre arranques

- [ ] En medio de cualquier cinemática, cerrar la app por completo
  (no sólo background — swipe del task switcher). Volver a abrir:
  reanuda en la misma cinemática y mismo plano.
- [ ] En medio de una Brecha, cerrar la app. Volver a abrir: reanuda
  en la misma Brecha y misma fase. Las respuestas previas (preguntas
  formuladas, fuentes recogidas, evaluaciones, afirmaciones declaradas)
  se preservan.
- [ ] En medio del Mosaico, cerrar la app. Volver a abrir: las marcas
  ya hechas siguen ahí.

**Notas / hallazgos**:


---

## Bloque 12 — Companion (sincronización opt-in)

Sin login (Bloque 8) el companion no se toca — todo es local. Con
login:

- [ ] Tras entregar un Mosaico (M1, M2, M3 o M4), la app intenta un
  `POST /companion/mosaicos` en segundo plano sin bloquear la
  siguiente cinemática.
- [ ] Si la sincronización falla (sin red, timeout, error 5xx), el
  juego sigue funcionando localmente sin avisar — el Mosaico se
  preserva en local.
- [ ] No hay reintento automático (de momento, decisión de diseño).
- [ ] La URL base del companion es **provisional**
  (`https://nuevoser.example.org`) hasta que cierre la decisión del
  dominio definitivo — anotar en bug si la sincronización no llega a
  ningún sitio real, no es bug aún.

**Notas / hallazgos**:


---

## Bloque 13 — Pruebas de robustez

Probar cosas que pueden romper:

- [ ] Recorrer una Brecha entera saltando todas las preguntas
  opcionales (las mínimas requeridas).
- [ ] Recorrer una Brecha declarando **todo SÓLIDO** (sobre-confianza
  máxima) y observar el feedback del Concilio.
- [ ] Recorrer una Brecha declarando **todo DISPUTADO** (infra-
  confianza máxima) y observar el feedback.
- [ ] Tap rápido en cinemáticas largas (varios planos por segundo).
  La app no se cierra y no se salta planos sin avanzar.
- [ ] Modo avión: el juego completo (excepto el login del adulto y
  la sincronización del Mosaico) sigue funcionando.
- [ ] Girar el dispositivo durante una cinemática o Brecha: el
  contenido no se rompe.
- [ ] Resetear el Archivo desde el menú y verificar que vuelve a la
  primera pantalla (configuración inicial).
- [ ] Cambiar de perfil en medio de una Brecha: el juego vuelve a la
  pantalla apropiada del nuevo perfil.
- [ ] Dejar la app abierta en una cinemática durante 10+ minutos. Al
  volver, sigue donde estaba.

**Notas / hallazgos**:


---

## Bloque 14 — Sustituciones diegéticas y zonas frágiles

Las Versiones tiene varias sustituciones diegéticas activas: contenido
histórico que se ha sustituido por formulación genérica equivalente
hasta que el comité asesor histórico valide. Si juegas estas zonas y
notas algo raro pedagógicamente o "menos preciso de lo que esperarías",
puede ser una sustitución intencional. Lista para no confundir
sustitución con bug:

- [ ] **Arco 1**: PIO-BELTRAN (el "libro de Beltrán" del informe de
  1973 → "el libro de la sierra" + "informe antiguo del dolmen" sin
  autor nombrado), EDIFICIO-ARCHIVO (capiteles s. XII / brocal s. XV
  → "muchos siglos"), ARALAR-DATACIONES (4.300 ± 80 a.C. + 3.900 ±
  60 a.C. → "hacia 4300 a.C." + "hacia 3900 a.C." sin desviaciones
  específicas), grabados→manos en 1.Z. Las 5 fuentes de la Brecha 1.1
  son **explícitamente ficticias y diegéticas**.
- [ ] **Arco 2 Brecha 2.1**: el ara funeraria de Aelio Attiano sí
  está validada (publicación Velaza 2014 referenciada). Las dos caras
  + el error gramatical del lapicida + la reutilización en muralla
  son material trazable real.
- [ ] **Arco 2 Brecha 2.2** (Calagurris): Quintiliano + Institutio
  Oratoria + Vitorio Marcelo + Vespasiano son trazables; el dossier
  arqueológico genérico del Museo de la Romanización de Calahorra y
  la arqueóloga local sin nombre histórico son sustituciones leves.
- [ ] **Arco 2 Brecha 2.3** (domus de los mosaicos): la familia
  Cornelia es **explícitamente ficticia diegética**, modelo literario
  basado en yacimientos hispanorromanos conocidos (Mérida, Itálica,
  Empúries, Bilbilis).
- [ ] **Arco 2 Brecha 2.4** (Wamba): Wamba + 673 d.C. + Julián de
  Toledo + Historia Wambae regis son trazables. El **yacimiento
  vascón del norte** se deja **deliberadamente sin nombre histórico**
  hasta validación del comité.
- [ ] **Arco 3 Estación 3.2** (Banu Qasi): la **Brecha jugable está
  bloqueada por validación BANU-QASI**. Sólo hay narrativa.
- [ ] **Arco 3 Brecha 3.6** (incendio judería de Tudela 1378): la
  más sensible del MVP. 10 puntos pendientes de validación masiva del
  comité (cifras de víctimas, identificación nominal del Concejo,
  carta del superviviente, testimonio inquisitorial, excavación
  arqueológica del s. XX, correspondencia de Carlos II, nombres
  parciales de víctimas, casos comparativos peninsulares,
  reconstrucciones de Isaura/Tasio internas al universo, pieza del
  M3). Si juegas esta Brecha, **considera todo lo concreto como
  provisional**.
- [ ] **Arco 4** (de F2-32): tres puntos sensibles registrados —
  REFORMULACION-1512 (el comité provisional propone reformular el
  final con Estaciones 4.4 La conquista + 4.5 La guerra + 4.6 Amaiur;
  la implementación actual sigue doc 10 v0.1), JOANA-DE-RONCAL (la
  persona concreta es ficticia diegética), PARED-MEDIANERA-1394 (el
  pleito concreto y nombres son ficticios diegéticos; estructura del
  género documental real preservada).
- [ ] **Paleta visual** (`paleta_archivo.dart`): tonos sepia/papel/
  tinta + acento ámbar lacre son **provisionales** hasta cerrar
  contra doc 11.
- [ ] **Tonos de los códigos de confianza** en los Mosaicos (azul
  Sólido / ámbar Probable / rojo claro Disputado): provisionales
  hasta cierre de paleta.
- [ ] **Avatares ilustrados**: sólo 4 de 17 personajes (Maren,
  Isaura, Aitor, Karim) tienen retrato; el resto está procedural.
  Anotar si algún personaje crítico para tu sesión queda demasiado
  abstracto sin retrato.

**Notas / hallazgos** (lo anotado aquí ayuda al equipo a saber qué
zonas el tester percibió como sustitución):


---

## Bloque 15 — Perspectiva profe de historia / pensamiento crítico

*Esta sección está pensada para perfiles con formación en historia,
ciencias sociales, didáctica de la historia o pensamiento crítico. El
resto de testers puede saltarla o leerla por curiosidad.*

### Rigor histórico

- [ ] **Material trazable preservado**: los hechos, fechas, nombres
  y atribuciones históricas concretas del juego se citan tal como
  figuran en la historiografía estándar (p. ej. Wamba + 673 d.C. +
  Julián de Toledo; ara de Aelio Attiano publicada por
  García-Barberena/Unzu/Velaza en *Epigraphica* 76 (2014); Fuero de
  Pamplona-San Cernin de 1129 + Alfonso I el Batallador; *Chanson de
  Roland* h. 1100 + primera Cruzada predicada en 1095; abad Virila
  atestiguado en listas del s. IX/principios del X; Banu Qasi +
  Ibn Hayyán *Muqtabis* + *Crónica de Alfonso III*). ¿Hay alguna
  atribución, fecha o nombre **incorrectos** o **anacronicos**?
- [ ] **Sustituciones diegéticas declaradas** (ver Bloque 14): ¿son
  aceptables como decisión pedagógica? ¿Hay alguna que te resulta
  demasiado evasiva (preferirías que el juego afirme lo no validado)
  o demasiado conservadora (sustituye algo que sí está bien
  establecido)?
- [ ] **Calibración de las afirmaciones canónicas**: en cada Brecha
  hay 4-9 afirmaciones con nivel canónico (Sólido / Probable /
  Disputado). ¿Estás de acuerdo con la calibración propuesta? ¿Hay
  afirmaciones que tú declararías en otro nivel?

### Pedagogía de la "versión" frente a la "verdad única"

- [ ] El juego enseña que **la pregunta interesante no es "¿qué pasó?"
  sino "¿cómo lo sabemos?"** y que el oficio del Cronista premia
  haber juzgado bien con lo disponible, **no tener razón**. ¿La
  mecánica del juego (cinco fases + calibración Brier en el Concilio)
  encarna esa pedagogía o se queda en discurso?
- [ ] **Los tres niveles SÓLIDO / PROBABLE / DISPUTADO** se ofrecen
  al niño como herramientas para declarar confianza honesta. ¿La
  granularidad es suficiente? ¿Sobra o falta alguno? (El equipo
  decidió deliberadamente que matices como *"Sólido (la ausencia)"* o
  *"Sólido como declaración metodológica"* vivieran en el texto de
  cada afirmación, no como niveles nuevos del enum.)
- [ ] El feedback del **Concilio** se basa en calibración (Brier
  invertido) y no en acierto. ¿El feedback es legible para un niño
  de 10-14? ¿Le ayuda a corregir sobre-confianza / infra-confianza?

### Tratamiento de zonas sensibles

- [ ] **Silencio vascón** (Estación 2.4): el juego afirma *"el
  silencio es el dato. No es ausencia de dato."* ¿Es una formulación
  legítima del problema epistémico de la asimetría documental?
  ¿Riesgo de identitarismo si se lee mal?
- [ ] **Incendio de la judería de Tudela 1378** (Estación 3.6,
  material más sensible del MVP): el juego presenta dos versiones
  publicadas previas (Isaura 2017 prudencia metodológica + Tasio/
  Resolutiva 2021 identificación nominal) y le pide a Maren producir
  una **tercera versión propia** que articula el silencio de tres
  semanas en las actas posteriores. ¿La estructura "tres versiones"
  es pedagógicamente adecuada para 10-14 con material antijudío
  medieval? ¿Algún ajuste recomendable antes de exposición pública?
- [ ] **Propaganda cruzada en la Chanson de Roland** (Estación 3.4):
  *"propaganda cruzada respirada, no manipulación deliberada"*.
  ¿Distinción manejable para 10-14?
- [ ] **Esclavitud romana en la domus** (Estación 2.3): la afirmación
  *"Sólido (la ausencia)"* sobre las personas esclavizadas no
  nombradas. ¿Tratamiento apropiado?
- [ ] **Conquista de 1512** (final del Arco 4): la implementación
  actual sigue doc 10 v0.1; el comité provisional propone reformular
  con Estaciones 4.4 La conquista + 4.5 La guerra + 4.6 Amaiur +
  defensa metodológica frente a Karim en un nuevo Concilio de
  graduación. ¿Qué piensas del cierre actual? ¿Te parece adecuada la
  reformulación propuesta?

### Habilidades atómicas (doc 02)

- [ ] **65 habilidades en 7 dominios**: PR Formulación de Preguntas
  (5) + HF Análisis de Fuentes (12) + CC Cronología y Causalidad
  (10) + GH Geografía Histórica (8) + PH Perspectiva Histórica (10)
  + AH Argumentación Histórica (8) + CF Contenido Factual LOMLOE
  (12). ¿Hay habilidades clave para 10-14 que falten? ¿Sobra alguna?
  ¿La proporción entre dominios es razonable?
- [ ] **AH.03 calibración epistémica** (declaración de niveles de
  confianza con honestidad) es la única habilidad asignada al perfil
  P4 (Brier invertido) y se declara *"corazón pedagógico del juego"*.
  ¿Estás de acuerdo con esa centralidad? ¿Hay otra habilidad que
  competiría por ser el corazón?
- [ ] **PR.01-PR.05 (Formulación de Preguntas)**: cinco habilidades
  introducidas en v0.2 del doc 01 con la idea de que *"el oficio
  empieza con preguntas, no con respuestas"*. ¿La idea cuaja?
- [ ] **HF.10 (detección de omisiones)**: debut jugable en la Brecha
  2.2 (Quintiliano omite Calagurris). ¿Está bien pedagógicamente
  encarnada?

### Tutor IA y barreras

- [ ] El juego documenta un **Tutor IA con barreras** (ZDR + barrera
  anti-alucinación histórica — no genera contenido factual no
  validado por el comité asesor). En la versión 0.0.1 **el Tutor IA
  todavía no está jugable** — sólo el motor está en core. Si lo ves
  asomar, anótalo.

### Recursos externos y bibliografía

- [ ] Las atribuciones bibliográficas concretas que el juego cita
  (Velaza 2014 *Epigraphica* 76; *Vita Karoli* de Eginardo; *Annales
  Regni Francorum*; CIL II 2958-2960 de las tablillas hospitalarias
  de Arre; *Muqtabis* de Ibn Hayyán; *Crónica de Alfonso III*;
  *Historia Wambae regis* de Julián de Toledo; *Institutio Oratoria*
  de Quintiliano): ¿están bien citadas? ¿Falta alguna ineludible?
- [ ] El juego es **AGPL-3.0 (código) + CC-BY-SA 4.0 (contenido)**.
  ¿Las licencias se ajustan a un material pedagógico de este perfil?

**Comentarios libres del docente / académico**:


---

## Feedback general

Espacio libre para lo que no encaja en los bloques anteriores:
funcionalidades que faltan, flujos que mejorarías, comparaciones con
otros juegos o materiales que conoces (manuales escolares de historia,
juegos serios sobre historia, simuladores de investigación
histórica), prioridades de qué arreglar primero, qué te emocionó, qué
te aburrió, dónde se te atascó tu sobrina o tu alumno.

**Comentarios libres**:


---

## Información del tester

- **Nombre / alias**:
- **Perfil** (niño 10-14 / adulto observador / docente / historiador /
  programador / otro):
- **Edad** (si es relevante para la sesión):
- **Dispositivo**:
- **Versión Android**:
- **Idioma elegido**:
- **Fecha del informe**:
- **Tiempo aproximado dedicado al testeo**:
- **Hasta dónde llegaste** (qué Arco / Brecha / Mosaico):
