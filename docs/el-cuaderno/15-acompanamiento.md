# El Cuaderno — Acompañamiento y curso

> Documento pedagógico-operativo.
> Versión 0.1 — borrador para Fase 2.
> Modelo: doc 15 de Las Versiones, adaptado al modelo no narrativo.
> Leer con la biblia (`el-cuaderno-01-biblia.md`) y el mapa de habilidades (`el-cuaderno-02-mapa-habilidades-atomicas.md`).

---

## 0. Qué es este documento

Define **cómo viven los adultos junto al niño que juega a El Cuaderno**. Tres figuras adultas tienen visibilidad limitada y bien definida: el cuidador (familia), el profesor (aula), y la persona del equipo de la Colección (mantenimiento).

Este documento define las tres vistas, los materiales pedagógicos, el pacing del año, y lo que **no** se les permite a los adultos. La privacidad del niño es estructural — no es una configuración que se pueda cambiar.

## 1. Principios del acompañamiento

Cuatro principios jerárquicos:

1. **El cuaderno del niño es del niño.** Ningún adulto lee el contenido directo del cuaderno (entradas, dibujos, fotos, identificaciones, reflexiones libres). Los adultos ven **agregados cualitativos** generados por el sistema, no datos crudos.

2. **El acompañamiento es ofrecimiento, no vigilancia.** Lo que el adulto ve sirve para acompañar, no para evaluar ni para corregir. La voz de los informes adultos NO produce métricas de juicio sobre el niño.

3. **k-anonimato real en el aula.** Profesores ven datos agregados solo si hay al menos 5 niños del aula trabajando esa habilidad. Por debajo de k=5, no hay dato. Esto bloquea estructuralmente la identificación individual.

4. **El consentimiento es del niño y del cuidador.** Para niños menores de 14 años (LOPDGDD art. 8), la vinculación con cuidadores y aula requiere consentimiento parental verificado. Para niños de 14+, el consentimiento es del propio niño. La vinculación es revocable en cualquier momento.

## 2. Vista del cuidador

### 2.1 Qué ve el cuidador

Cada semana, un párrafo cualitativo generado por el tutor IA a partir de agregados anonimizados del trabajo del niño durante los últimos 7 días. Sin métricas numéricas. Sin tablas. Sin gráficos. Sin notas. Sin nombres exactos de identificaciones que el niño ha hecho. Sin acceso al cuaderno personal.

Estructura del párrafo semanal:

1. **Una o dos frases sobre lo que el niño está trabajando**. *"Esta semana Lucía ha trabajado el Misterio de las polinizadoras del Roble Grande. Ha hecho 5 observaciones, dos en su sit spot."*
2. **Una frase sobre algo que está madurando en su oficio**. *"Ha empezado a notar cómo cambia el comportamiento de los pájaros con la temperatura."*
3. **Una pregunta concreta para llevar a la mesa de la cena**. *"¿Le has preguntado cómo es su sit spot? Llévala si puedes."*

Ejemplos completos del tipo de texto:

> *Esta semana Lucía ha vuelto al Roble Grande tres veces. Sigue investigando si hay menos mariposas que el mes pasado. Ha decidido marcar como hipótesis activa que el frío temprano las ha adelantado. Pregunta para la cena: ¿le has contado alguna observación tuya sobre los insectos cuando eras pequeño?*

> *Esta semana Lucía ha jugado poco. Es normal — los niños no juegan a un ritmo constante. Sus dos observaciones del miércoles son cuidadosas. Pregunta para la cena: ¿qué tal ha ido el cole esta semana?*

> *Lucía ha cerrado un Misterio esta semana. Ha llegado por su cuenta a la conclusión de que las setas que aparecieron tras la lluvia eran del mismo grupo que las que vio en otoño. Pregunta para la cena: ¿quieres que te enseñe la página del Misterio que ha hecho?*

### 2.2 Qué NO ve el cuidador

- Las observaciones individuales (texto libre, fotos, dibujos).
- El historial detallado de uso (a qué hora abre la app, cuántos minutos pasa).
- Los nombres específicos de las identificaciones del niño (excepto si el sistema decide mencionar uno como ejemplo en el párrafo).
- Las páginas del cuaderno libres (boceto, mapa, pregunta abierta).
- Las conversaciones del niño con el Tutor IA.
- El estado de las habilidades atómicas en niveles concretos.
- Comparaciones con otros niños de ningún tipo.

Si el cuidador quiere ver el cuaderno del niño, **se lo pide al niño**. No hay puerta trasera.

### 2.3 Cómo se genera el párrafo

Tras cada semana ISO, el sistema:

1. Agrega los datos del niño en local (en su dispositivo).
2. Firma el agregado con clave derivada de la cuenta del niño.
3. Envía agregado firmado al servidor (no datos crudos).
4. El servidor llama al tutor IA con un prompt plantilla controlado por la plataforma (versión PHP, server-side, nunca cliente).
5. El tutor genera el párrafo en el idioma del cuidador.
6. Se cachea. Si los datos no cambian, no se regenera.

El prompt plantilla del tutor incluye:

```
Eres el sistema de acompañamiento de la Colección Nuevo Ser. Genera UN PÁRRAFO
BREVE (máximo 3 frases) en {idioma} describiendo cualitativamente la actividad
de la última semana de un niño/a llamado/a {nombre} en El Cuaderno.

Reglas:
- Sin métricas numéricas (no cuentes "5 observaciones" salvo que sea relevante).
- Sin comparaciones con otros niños.
- Sin tono de evaluación.
- Sin moralización ni elogios efusivos.
- Tono adulto amable, seco, paciente.
- Sigue el vocabulario prohibido del documento 04-voces-y-figuras.

Después, en LÍNEA SEPARADA, una pregunta breve para llevar a la mesa de la cena.

Datos:
{agregados anonimizados de la semana}

NO uses datos de niños distintos al objetivo. NO inventes detalles que no
estén en los datos. Si los datos son escasos, sé honesto: "esta semana ha
jugado poco, lo cual es normal".
```

### 2.4 Frecuencia

Una vez por semana. Idealmente lunes por la mañana, para que el cuidador lo lea con calma. El cuidador puede consultar resúmenes anteriores. No se mandan más que esto. **Ninguna notificación push en ningún caso**.

### 2.5 Lo que el cuidador puede hacer (acción)

- Leer el párrafo semanal.
- Hablar con el niño sobre lo que el niño quiera compartir.
- Acompañarle al sit spot si el niño le invita.
- Activar a otras personas reales del entorno (un guarda forestal, un naturalista local, un familiar que sepa de plantas) — la app sugiere esto en los materiales del cuidador.
- Desvincularse en cualquier momento.

Lo que el cuidador **no puede** hacer:

- Acceder al cuaderno del niño sin permiso del niño.
- Configurar la app del niño (cambiar el sit spot, ajustar los Misterios, cambiar el idioma del Tutor).
- Ver datos de otros niños del aula.
- Compartir el párrafo semanal con terceros sin consentimiento.

### 2.6 Versión accesible

El párrafo semanal cumple WCAG 2.1 AA. Disponible también en lectura facilitada (frases más cortas, vocabulario más sencillo). Audio opcional generado con voz neutra del sistema, no voz "humana cálida" simulada — es lectura, no narración emocional.

## 3. Vista del aula

### 3.1 Qué ve el profesor

Si un aula tiene al menos 5 niños vinculados (consentimiento parental verificado para los <14, consentimiento propio para los ≥14), el profesor ve:

**Panorama de la clase**, actualizado semanalmente:

- Distribución de niveles de maestría por dominio (PRE, OBS, REG, TAX, REL, CIC, HAB, HIP, TEJ).
- Habilidades donde la clase está más dispersa (señal de que el contenido es difícil o el contexto del centro afecta).
- Misterios más trabajados por la clase y estado agregado.
- Marcadores fenológicos colectivos (la primera mariposa registrada por la clase, la primera escarcha, la primera cigüeña).

**Panorama de patrones (no de individuos)**:

- *"La mayoría de la clase sostiene bien la incertidumbre en hipótesis activas."*
- *"A la clase le cuesta separar observación de interpretación. Sería útil trabajarlo en el aula."*
- *"5 niños han registrado la misma especie no identificada — podría ser una buena pregunta colectiva."*

### 3.2 Qué NO ve el profesor

- Datos individuales de ningún niño.
- Observaciones, dibujos, fotos, conversaciones con el Tutor.
- Comparaciones de un niño con otro o con el promedio.
- Identificación de "los que más participan" o "los que menos".
- Historial de uso (cuándo entran, cuánto tiempo pasan).

Si una habilidad la trabajan menos de 5 niños del aula, **no aparece en la vista**. El profesor recibe la advertencia: *"Esta habilidad la están trabajando menos de 5 niños — el dato no se muestra para proteger su intimidad."*

### 3.3 Materiales pedagógicos para el profesor

El sistema acompaña la vista del aula con **materiales que extienden el juego al aula**, no que lo reemplazan. Se actualizan trimestralmente.

Tipos de materiales:

**Sugerencias de actividad de campo**, alineadas con la estación y el currículo:

- *"Esta primavera, sugerimos una salida al patio del cole con cuaderno físico. Los niños registran 3 observaciones libres y luego comparan en el aula. Tiempo: 45 minutos. Vincula con OBS.01 y REG.01."*
- *"En noviembre, podéis trabajar la fenología de los árboles del cole. Cada niño elige uno y lo observa una vez por semana durante 4 semanas. Vincula con CIC.01."*

**Claves de identificación adaptadas al territorio del centro**:

- Si el centro está en País Vasco: claves para 12 árboles del bosque atlántico, 10 pájaros comunes de la zona, mariposas del verano cantábrico.
- Si está en zona mediterránea: claves para el bosque mediterráneo, garriga, fauna asociada.
- Disponibles en formato imprimible PDF, en es / eu / ca cuando aplica.

**Sugerencias de integración curricular** con el bloque LOMLOE de Conocimiento del Medio:

- Mapeo entre habilidades atómicas trabajadas y saberes básicos del currículum oficial.
- Sugerencias de evaluación coherente con el oficio (no exámenes tipo test sobre el juego — proyectos donde el cuaderno digital se complementa con cuaderno físico, presentación oral al aula, mosaico de aula).

**Guía de la voz del Cuaderno**:

- Documento corto para el profesor sobre cómo hablar de la app en clase sin convertirla en deberes.
- Casos típicos de "cómo responder cuando un niño dice X".
- Lo que el profesor NO debe hacer (puntuar el cuaderno, comparar niños, pedir que enseñen el cuaderno al aula sin consentimiento).

### 3.4 Modos de aula

**Modo aula opt-in**. Un centro puede activar el modo aula con su licencia de uso (gratuita; ver §6 sobre sostenibilidad). Esto permite la vinculación profesor-niños del aula. Los niños y sus cuidadores pueden negarse a vincularse — el niño sigue jugando, simplemente no aparece en los agregados de aula.

**Modo aula off** es el default. La gran mayoría de niños usarán la app sin vincularse a un aula.

### 3.5 Casos especiales

- **Centro rural pequeño**. Si el aula tiene menos de 5 niños vinculados, no se cumple k=5 y la vista del aula no muestra agregados. Esto es por diseño. La alternativa: agregar varios cursos del centro hasta cumplir k=5.
- **Centro con perfil pedagógico alternativo** (Waldorf, Montessori, escuela libre). El sistema funciona igual. Los materiales pedagógicos están alineados con LOMLOE pero no exigen seguir el ritmo prescrito.
- **Educación en casa**. Las familias que practican homeschooling pueden usar el modo familia (cuidador) sin necesidad de aula. Los materiales para profesores están abiertos para que los usen quienes quieran.

## 4. Pacing del año del juego

### 4.1 Estructura por estaciones reales

El año del juego no es un calendario fijo: la app detecta latitud y fecha y marca la estación que toca. Para latitudes peninsulares ibéricas:

- **Otoño**: aprox. 21 sept – 21 dic. Foco: caída de hojas, llegada de aves invernantes, hongos, fructificaciones.
- **Invierno**: aprox. 21 dic – 21 mar. Foco: estructura del paisaje sin hojas, aves residentes, bandos invernales, primeras flores.
- **Primavera**: aprox. 21 mar – 21 jun. Foco: explosión floral, llegada de aves migradoras, insectos polinizadores, ciclos reproductivos.
- **Verano**: aprox. 21 jun – 21 sept. Foco: fauna activa, fructificaciones tempranas, observación nocturna posible.

Para hemisferio sur (no MVP, futuro): inversión de las estaciones.

Cada estación dura entre 2 y 4 meses **calendarios** pero el ritmo del juego dentro de ella es del niño. No hay obligación de hacer X observaciones por semana.

### 4.2 Ritmo dentro de la estación

Tres tipos de día:

**Días tranquilos** (mayoría). El niño usa la app cuando quiere y solo si quiere. Registra observaciones, vuelve al sit spot, abre el cuaderno. La app no le pide nada.

**Días de Archivo** (una vez cada 2-3 semanas, sugeridos). La app sugiere — sin obligar — un día para revisar lo registrado en las semanas anteriores, releer páginas viejas, organizar notas. **No para producir**. Es día de mirar atrás. Si el niño no entra, no pasa nada.

**Cierre de estación** (al final de cada una). La app ofrece componer una **Página de Estación**: un mosaico libre con lo más significativo del trimestre. Texto, dibujo, fotos, mapa, lo que el niño quiera. No se evalúa. Se queda en su cuaderno. Es la "celebración" estructural — sin fanfarria, solo una invitación.

### 4.3 Sin gamificación temporal

El juego no tiene ningún elemento de gamificación basado en tiempo:

- Sin rachas obligatorias.
- Sin penalización por inactividad.
- Sin notificaciones push para volver.
- Sin contadores visibles del tipo "llevas 12 días sin entrar".
- Sin "habilidades que se enfrían" visibles al niño (el decaimiento es interno, no se le muestra como amenaza).

### 4.4 Mosaicos al cierre de bloques mayores

Además del cierre de estación, hay dos mosaicos opcionales mayores:

**Cierre de año completo** (12 meses tras el primer registro). Mosaico libre con la trayectoria del año. Comparación entre estación y estación. Misterios cerrados. La app no lo exige; lo ofrece.

**Cierre de juego** (cuando el niño cumple 14 años o decide salir). Mosaico de despedida. El cuaderno completo se exporta a PDF para el niño. La cuenta se elimina o pasa a la versión adulta de la Colección si decide seguir.

## 5. Privacidad y seguridad infantil

### 5.1 Datos almacenados

**En el dispositivo del niño** (Isar local cifrado):
- Observaciones (texto, fotos, dibujos).
- Conversaciones con el Tutor (no persistentes; se borran al terminar la sesión salvo nota explícita del niño).
- Estado del cuaderno completo.
- Configuraciones personales.

**En el servidor** (`nuevo-ser-core` backend):
- Cuenta del niño (identificador, idioma, fecha de nacimiento, consentimiento parental si aplica).
- Estado de habilidades atómicas (niveles 0-4 por habilidad).
- Vínculos con cuidadores y aulas, con consentimiento.
- Resúmenes semanales generados por tutor IA y cacheados.
- Marcadores fenológicos compartidos voluntariamente con el aula (anonimizados).

**Lo que NO se almacena en servidor**:
- Contenido directo del cuaderno (texto libre, fotos, dibujos).
- Conversaciones detalladas con el Tutor.
- Datos de geolocalización precisa (solo región amplia para detectar territorio y estación).

### 5.2 Borrado real

El niño o su cuidador pueden solicitar borrado completo en cualquier momento. El sistema:

1. Marca la cuenta como `pending_deletion`.
2. En menos de 24h, ejecuta cascada SQL eliminando registros en todas las tablas.
3. Borra blobs en almacén de medios.
4. Notifica a los backups: tag de tombstone para purgar en el siguiente ciclo.
5. Confirma al solicitante por email.

El cuaderno local queda en el dispositivo del niño hasta que él lo borre. Si lo quiere conservar fuera de la app, exporta a PDF.

### 5.3 Sin compartir con terceros

Los datos del niño:
- No se venden.
- No se comparten con plataformas de ciencia ciudadana (iNaturalist, eBird) — esa decisión queda explícitamente abierta para futuras versiones, **siempre con consentimiento explícito del niño y cuidador, opt-in claro, control granular**.
- No alimentan datasets para entrenamiento de IA.
- No se mandan a ninguna red social.

### 5.4 Sin trackeo invasivo

- Sin Firebase Analytics.
- Sin Sentry sin política documentada y consentimiento.
- Sin píxeles publicitarios.
- Sin terceros silenciosos en la cadena de carga de la app.

Auditoría externa: el código es AGPL-3.0 y cualquiera puede revisar que esto se cumple.

## 6. Sostenibilidad

### 6.1 Gratuidad para usuarios particulares

El juego es gratuito y completo para cualquier niño y su familia. Sin freemium. Sin "versión completa" detrás de muro de pago. Sin compras integradas.

### 6.2 Modelo de financiación

- **Donaciones documentadas y públicas** de particulares y fundaciones.
- **Contratos de mantenimiento** con centros educativos que adopten el modo aula institucionalmente. Esto cubre soporte técnico, formación a profesorado, adaptaciones curriculares específicas. La adopción del juego sin contrato sigue siendo gratuita.
- **Adaptaciones territoriales financiadas** por organismos locales que quieran que el juego cubra su territorio con detalle (claves, ilustraciones, idiomas adicionales).

Estos ingresos cubren mantenimiento y nuevas versiones. **No afectan al contenido del juego ni a la experiencia de los niños**. Esta separación es estructural y se documenta públicamente.

### 6.3 Compromiso de continuidad

5 años mínimos desde el lanzamiento, con respaldo del equipo central de la Colección si el equipo proponente no puede mantenerlo. Si en algún momento el proyecto debe cerrar, el código y el contenido quedan abiertos para que otros continúen.

## 7. Lo que el equipo de la Colección puede ver

El equipo de mantenimiento de `nuevo-ser-core` necesita visibilidad mínima para operar la plataforma. Lo que ve:

- Métricas de uso agregadas por país y estación (sin datos individuales).
- Estado de salud de los servicios (latencia, errores, disponibilidad).
- Bugs reportados por usuarios.
- Composición de los Misterios más trabajados (para mantener relevancia).

Lo que **no ve**:

- Cuadernos individuales.
- Datos de niños concretos.
- Conversaciones con el Tutor.
- Información identificativa más allá de la necesaria para autenticación.

## 8. Casos de conflicto

Tres situaciones donde el equipo editorial debe decidir si y cómo intervenir:

**Caso 1 — Niño en aparente angustia**. Si las observaciones del niño en pasajes libres del cuaderno sugieren angustia significativa (señales de bullying, ideación negativa, soledad extrema), ¿qué hace el sistema?

Decisión actual (a validar con asesoría psicológica): el sistema **no monitoriza** activamente el contenido del cuaderno por privacidad. Si el cuidador detecta señales en el comportamiento del niño y pregunta a la app, el equipo puede generar (con consentimiento del cuidador) un resumen cualitativo. Pero la app no actúa por iniciativa propia. Esta decisión se reevalúa en piloto.

**Caso 2 — Profesor que pide datos individuales**. Decisión: nunca. Aunque sea para "ayudar al niño". La privacidad estructural es no negociable.

**Caso 3 — Padre o madre separados con conflicto sobre el niño**. Decisión: cada cuidador con consentimiento parental verificado tiene acceso al resumen del niño. El sistema no media en disputas familiares. Si hay orden judicial específica, se cumple, pero no se generan datos a la carta.

## 9. Decisiones abiertas

Pendientes para Fase 2 cerrada con asesoría:

1. **Caso 1 ampliado**: políticas de detección de angustia. Validar con psicología infantil.
2. **Compartir con ciencia ciudadana** (opt-in detallado). Validar con didactas y con asociaciones de naturalistas.
3. **Frecuencia del párrafo del cuidador**. Semanal puede ser excesivo o insuficiente — validar en piloto.
4. **Materiales para profesores en lectoescritura facilitada** para alumnos con DEA específica. Validar con didactas de educación inclusiva.

---

*Fin del documento de Acompañamiento v0.1.*

*Documento sometido a revisión didáctica conforme al §8 Fase 2 de los criterios de integración.*
