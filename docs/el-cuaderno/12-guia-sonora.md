# El Cuaderno — Guía sonora

> Documento de dirección sonora.
> Versión 0.1 — borrador para Fase 3.
> Para responsable de audio (si lo hay) y equipo de desarrollo.
> Leer junto a la biblia (doc 01) y la guía visual (doc 11).

---

## 0. La guía sonora en una frase

**El Cuaderno suena al silencio del lugar donde el niño está, salvo cuando el oficio pide específicamente sonido — y entonces el sonido es el del mundo, no el de la app.** Si la app suena, está mal.

Este documento es deliberadamente breve. Un juego sobre observación de naturaleza no necesita banda sonora. El silencio es el contenido.

## 1. Filosofía

El sonido en aplicaciones modernas suele cumplir dos funciones: feedback (ding al guardar) y ambientación (música emocional). El Cuaderno **rechaza ambas**.

**Por qué no feedback sonoro.** Los sonidos de feedback gamifican. El "ding" de "has guardado" es indistinguible del "ding" de Duolingo cuando aciertas. El cerebro lo asocia con recompensa, y la recompensa con repetición compulsiva. Esto es lo opuesto del oficio paciente que el juego cultiva.

**Por qué no música ambiente.** La música ambiente impone tono emocional al niño. El niño abre la app con ganas, con tristeza, con curiosidad — y la música decide qué siente. Eso es manipulación afectiva. Además, si la niña abre la app **estando** en su sit spot, la música de la app **anula** el sonido real del lugar, que es lo único que importa.

La consecuencia operativa: la app es silenciosa por defecto. Las únicas excepciones son funcionales y opcionales, y se documentan abajo.

## 2. Lo único que suena

Tres categorías de sonido, todas ellas opcionales o contextuales. Ninguna es de "feedback de UI" en el sentido estándar.

### 2.1 Cantos de pájaros — banco de identificación auditiva

La única excepción importante. Para identificar pájaros por canto (habilidad TAX.06), el niño puede consultar un banco de grabaciones auditivas. Acceso desde la pantalla del Tutor o desde una clave dicotómica auditiva.

Cuando el niño pide *"escuchar el canto del petirrojo"*, suena el canto. Tres segundos. Reproducible si lo pide otra vez. **Iniciado por el niño, nunca automático.**

**Especificaciones:**

- Grabaciones de calidad de campo, no estudio sintético.
- Banco abierto: Xeno-canto (xeno-canto.org) bajo licencias compatibles (CC, dominio público) o grabaciones encargadas específicamente al juego.
- **Atribución obligatoria** del autor de la grabación visible al niño cuando suena.
- Cobertura inicial: ~30 especies del catálogo ibérico común.
- Sin compresión que distorsione la identificación.

### 2.2 Sonido del lápiz — opt-in

Cuando el niño escribe en un campo de texto del cuaderno, opcionalmente puede sonar el rasgar de un lápiz sobre papel. Sutil. **Desactivable**. Por defecto activado solo si el niño tiene auriculares conectados y el sistema operativo declara que el dispositivo está en silencio (no llama, no notificaciones).

Esta es una concesión a la atmósfera del cuaderno físico. Funciona solo si es muy bien hecho — sonido de lápiz real, sin loop perceptible, volumen muy bajo. Si no se puede ejecutar bien, **se quita**.

### 2.3 Confirmación de toque

**No** sonido. Vibración haptica corta (15ms, intensidad baja) al confirmar acciones del usuario:

- Guardar observación.
- Enviar pregunta al Tutor.
- Confirmar configuración del sit spot.

Sin sonido. Solo haptic. **Desactivable**.

## 3. Lo que NO suena

Lista explícita para evitar regresiones futuras:

- **No hay** música de fondo.
- **No hay** sonido al abrir la app.
- **No hay** sonido al cerrar la app.
- **No hay** sonido de "logro completado".
- **No hay** sonido al cambiar pestaña.
- **No hay** sonido de notificación dentro de la app.
- **No hay** sonido al recibir resumen semanal (la app no recibe nada que requiera sonido — el resumen va al cuidador, no al niño).
- **No hay** voces narradas (ni del Tutor, ni del cuaderno, ni de la abuela). Todo es texto leído por el niño o, si tiene activada accesibilidad, por el TTS del sistema.
- **No hay** sonidos ambientales del juego (pájaros de fondo, viento, agua corriendo). El niño escuchará pájaros reales si está fuera. Si está dentro, escuchará silencio o lo que sea de su casa.

## 4. Voces y narración

### 4.1 Sin voz humana del juego

La app **no tiene voces grabadas**. El Tutor no habla. La voz del Cuaderno no narra. Los Misterios no se leen en voz alta.

Razones:
- La voz humana imprime carácter (edad, sexo, acento, calidez) que estandariza la experiencia y excluye a quien no se siente representado.
- La voz humana hace al Tutor sentir como persona, traicionando el doc 04 §3.
- La voz humana cuesta mucho de mantener en tres idiomas con calidad coherente.

### 4.2 TTS del sistema operativo

Para accesibilidad (lectores de pantalla, niños con dificultades de lectura), la app deja que el TTS nativo del sistema operativo lea los textos. Esto:
- Respeta las preferencias del usuario.
- No imprime carácter del juego.
- Funciona en cualquier idioma soportado por el SO.

La app debe estructurar correctamente la accesibilidad semántica para que el TTS lea bien (etiquetas accesibles, orden de lectura, pausas naturales). Esto es trabajo técnico, no creativo.

## 5. Caso especial — el sonido del mundo real

El juego pide al niño que **escuche su entorno** en muchas habilidades (OBS.04 distinguir cantos, OBS.06 notar el viento, PRE.02 estar en silencio).

Esta es la auténtica banda sonora del juego: el silencio del cuarto donde Lucía está leyendo el cuaderno antes de salir, el ruido del autobús camino al sit spot, el gorrión que canta en el alero, la lluvia contra la ventana, el silencio del bosque.

La app **debe respetar ese sonido real**. Eso significa:

- Cualquier sonido de la app respeta el modo silencio del sistema.
- El volumen por defecto es bajo (40% del medio).
- Si Lucía está en una sesión de "Solo estar" (Flujo 4), la app entra en modo de máxima discreción: ningún sonido, ninguna vibración, ninguna notificación visual emergente.

## 6. Funcionalidad de grabación auditiva del propio niño

### 6.1 Grabar lo que se oye

Una habilidad atómica clave (OBS.04, distinguir cantos diferentes sin nombrarlos) se beneficia de poder **grabar** lo que se oye y volver a escucharlo después.

La pantalla de Nueva Observación permite, opcionalmente, grabar 10 segundos de audio. Botón con icono de micrófono en línea con foto y dibujo. Trabajo: graba, guarda en local (Isar), reproducible desde la observación. Privado por defecto, igual que foto y dibujo.

### 6.2 Comparar con el banco

Una vez Lucía ha grabado un canto, puede ir a la sección del Tutor o de Identificación auditiva y comparar su grabación con el banco. La app no identifica automáticamente — Lucía escucha y decide.

(Una clasificación automática vía ML estaría tecnológicamente al alcance, pero el oficio que el juego enseña pasa por que **Lucía** distinga, no por que un modelo le diga la respuesta. Por tanto: no automatizar.)

## 7. Decisiones abiertas

### 7.1 ¿Banco de cantos extendido a otros sonidos?

Anuros (ranas, sapos), insectos cantadores (cigarras, grillos), lluvia para identificar tipos. Pendiente decidir. Probable: sí, pero post-MVP.

### 7.2 ¿Sonido del lápiz, sí o no?

Decisión técnica que depende de poder ejecutarlo bien. En piloto se prueba con / sin y se decide. Si distrae más que añade, fuera.

### 7.3 ¿Música opcional para días de Archivo?

Algunos niños trabajan mejor con música suave de fondo. Tentación de ofrecer "modo concentración" con música ambiente en el día de Archivo. Decisión actual: **no**. La app no provee música. Si el niño quiere música, abre Spotify o pone un disco. La app sonando música cruzaría la línea hacia productivity-app.

---

## Apéndice — Checklist de revisión sonora

Antes de aprobar cualquier sonido nuevo en la app:

```
[ ] ¿Es estrictamente funcional o decorativo?
    Si decorativo, fuera.
[ ] ¿Lo inicia el niño explícitamente o lo dispara la app?
    Si lo dispara la app sin acción del niño, fuera.
[ ] ¿Es desactivable?
    Si no, fuera.
[ ] ¿Respeta el modo silencio del sistema operativo?
    Si no, fuera.
[ ] ¿Imprime carácter humano (voz, género, edad)?
    Si sí, reconsiderar.
[ ] ¿Sería confundible con un sonido de Duolingo o equivalente?
    Si sí, fuera.
[ ] ¿Aporta al oficio del juego o solo a la sensación de "app moderna"?
    Si solo lo segundo, fuera.
```

Filtro brutal. Por defecto: silencio.

---

*Fin de Guía Sonora v0.1.*
