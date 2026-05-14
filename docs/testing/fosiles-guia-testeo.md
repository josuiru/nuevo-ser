# Guía de testeo — Fósiles

Cuaderno de campo paleontológico para aficionados adultos. Anota hallazgos
georreferenciados con foto, edad, formación geológica y orientación del
estrato. Soporta certificación cripto-firmada (entre amigos y por
autoridades como un instituto geológico), tracks GPS, mapas geológicos
del IGME, guía de fósiles y minerales, y chat con IA paleontológica.

**Versión a testear**: 1.0.2 (release `apks-2026-05-14`)
**Dispositivo recomendado**: Android 8+, 3 GB RAM, GPS, cámara, conexión a
internet al menos parcial (los mapas geológicos requieren red la primera vez).

---

## Antes de empezar

- [ ] **Permisos**: la app pide ubicación, cámara, almacenamiento, notificaciones.
  Acepta todos.
- [ ] **Datos de prueba**: si arrancas con la app vacía, anota tu primer
  hallazgo de prueba en algún sitio cercano para tener algo con que probar
  el resto.
- [ ] **Backup automático**: la app hace backup en `Documents/backup_fosiles/`.
  Antes de testear cosas peligrosas (borrar, restaurar) verifica que hay
  backup reciente.

---

## Bloque 1 — Primer arranque y pantalla de inicio

- [ ] La app abre sin errores.
- [ ] Se muestra la pantalla "Inicio" con cabecera, tarjetas de acción
  rápida (Explorar mapa, Meteorología, Chat IA) y una guía ética.
- [ ] El botón "Explorar mapa" lleva al mapa.
- [ ] El botón "Meteorología" abre la pantalla de meteo.
- [ ] El botón "Chat IA" abre el chat (puede pedir API key — ver bloque 14).
- [ ] Hay sección "Cómo usar Fósiles" con pasos numerados.
- [ ] El scroll funciona bien y nada se corta.

**Notas / hallazgos**:


---

## Bloque 2 — Mapa: capas y navegación

El mapa es el corazón de la app. Hay muchas capas activables.

### Capa base

- [ ] El mapa OSM (calle) se carga correctamente.
- [ ] El popup "Capa base" del header permite cambiar a otras capas.
- [ ] Cambiar de capa base no rompe el mapa.

### Capas geológicas (WMS del IGME)

- [ ] El popup "Capa geológica" muestra varias opciones (MAGNA, GEODE, etc.).
- [ ] Activar una capa geológica la pinta sobre el mapa con transparencia.
- [ ] Apagarla la quita limpiamente.
- [ ] Al cambiar de zoom el mapa geológico se mantiene legible.

### Hillshade (relieve)

- [ ] El icono `landscape` activa/desactiva el relieve.
- [ ] El relieve no rompe la capa base ni la geológica.

### LIG (Lugares de Interés Geológico)

- [ ] El icono estrella activa la capa LIG sobre el mapa.

### Yacimientos curados

- [ ] El icono museo muestra los yacimientos curados en el mapa.
- [ ] Tocar un yacimiento abre su ficha (museo, periodo, edad, formación).

### Cuevas (OSM)

- [ ] El chip de "Cuevas" activa la capa.
- [ ] Aviso de "Acércate más (zoom ≥ 10) para cargar cuevas" si estás
  alejado.
- [ ] Al activarse con zoom suficiente, carga cuevas de la vista.
- [ ] Si te mueves a otra zona NO consultada antes, recarga.
- [ ] Si vuelves a una zona ya consultada, NO debería recargar (cache por
  celdas). Lo notarás porque el indicador de "cargando" no parpadea.

### Monumentos arqueológicos (OSM)

- [ ] El chip de "Megalitos" activa la capa.
- [ ] Aviso de "Acércate más (zoom ≥ 9)".
- [ ] Mismo comportamiento de cache por celdas que cuevas.

### Heatmap

- [ ] El icono `local_fire_department` alterna entre vista de puntos y
  mapa de calor.
- [ ] El heatmap muestra correctamente las zonas con más hallazgos.

### Chips de filtro por periodo

- [ ] Si tienes hallazgos, aparecen chips con el conteo por periodo (Cretácico,
  Jurásico, etc.).
- [ ] Tocar un chip filtra los markers visibles.
- [ ] "Todos" vuelve a mostrar todo.

### Rendimiento

- [ ] Mover/zoomear el mapa con todas las capas activas es **fluido** (sin
  congelaciones >0.5 s).
- [ ] La app no se cierra al hacer pan/zoom rápido.
- [ ] La capa estratigráfica no parpadea al moverse.

**Notas / hallazgos**:


---

## Bloque 3 — Modos del mapa

Hay tres modos: Ver / Marcar punto / Explorar geología.

### Modo Ver (por defecto)

- [ ] Tocar un punto del mapa no hace nada.
- [ ] Tocar un marker abre su ficha.

### Modo Marcar punto

- [ ] Botón "Marcar hallazgo aquí" desde el menú.
- [ ] Aparece un mensaje "👆 Toca el mapa para marcar el hallazgo".
- [ ] Al tocar el mapa abre "Nuevo hallazgo" con coordenadas predefinidas.
- [ ] Cancelar vuelve al modo Ver.

### Modo Explorar geología (asistente)

- [ ] Botón "Asistente geológico" o icono similar lo activa.
- [ ] Aparece un marcador central que sigue al mapa al panear.
- [ ] Al cargar la posición del centro consulta el IGME y muestra:
  formación, edad, litología.
- [ ] El panel inferior muestra la información geológica del centro.
- [ ] Al cerrar la información de un punto, el modo **sigue activo** (no se
  desactiva por accidente).

### Pulsación larga: distancia y rumbo

- [ ] Pulsar largo sobre el mapa muestra distancia y rumbo desde el último
  punto.

**Notas / hallazgos**:


---

## Bloque 4 — Nuevo hallazgo

- [ ] Botón `+` en la barra inferior abre el formulario.
- [ ] El formulario incluye: foto, nombre, especie, edad, formación,
  strike/dip, descripción, lat/lon.
- [ ] **GPS**: el botón captura coords y altitud.
- [ ] **Foto**: el botón "Cámara" abre la cámara, hace foto y la añade.
- [ ] La foto se ve en miniatura tras hacerse.
- [ ] Se pueden añadir varias fotos por hallazgo.
- [ ] **Anotar foto**: tocar una miniatura abre el editor de anotaciones
  (trazos en colores). Guardar conserva los trazos.
- [ ] **Strike/Dip**: el modal de orientación de estrato funciona y guarda
  los valores.
- [ ] **Identificar con IA**: pide API key Anthropic (si no tienes, salta
  este paso pero anótalo).
- [ ] Guardar el hallazgo lo añade a la lista y al mapa.
- [ ] El hallazgo guardado tiene firma criptográfica (visible en la ficha).

**Notas / hallazgos**:


---

## Bloque 5 — Ficha del hallazgo

- [ ] Tocar un marker del mapa abre la ficha en sheet.
- [ ] Se ven todas las fotos en carousel (PageView).
- [ ] Datos: especie, edad, formación, coordenadas, fecha.
- [ ] Si tiene strike/dip, se muestran.
- [ ] **Badge de firma**: aparece un icono indicando estado de firma:
  - Verde "Tuyo verificado" si es tuyo y la firma es válida.
  - Azul "Verificado de [autor]" si es de otro y la firma es válida.
  - Gris "Sin firma" si es de antes del sistema de firmas.
  - Rojo "Firma rota" si la firma no valida.
- [ ] **Cadena de certificaciones**: si tiene certificaciones de autoridad,
  aparece sello dorado ◆ y lista de eslabones.
- [ ] Botón "Editar" funciona.
- [ ] Botón "Borrar" pide confirmación y borra.
- [ ] Botón "Compartir .fos-card" exporta un archivo y abre share intent.

**Notas / hallazgos**:


---

## Bloque 6 — Lista de hallazgos

- [ ] La lista muestra todos los hallazgos con miniatura, nombre, fecha.
- [ ] **Pestaña "Mías"** muestra los hallazgos propios.
- [ ] **Pestaña "Compartidas conmigo"** aparece SOLO si has importado algún
  .fos-card de otra persona.
- [ ] Las miniaturas cargan rápido (no se ven a tamaño completo de cámara).
- [ ] Tocar un hallazgo abre su ficha.
- [ ] La búsqueda filtra por nombre/especie.

**Notas / hallazgos**:


---

## Bloque 7 — Compartir y certificación

### Compartir .fos-card

- [ ] Desde la ficha → "Compartir" se genera un .fos-card.
- [ ] El archivo se puede mandar por WhatsApp / email / Drive.
- [ ] Hay opción de "coordenadas precisas" vs "difuminadas" (para anti-saqueo
  en hallazgos sensibles).

### Importar .fos-card

- [ ] Pedirle a alguien con la app que te mande uno, o usar uno tuyo
  exportado.
- [ ] Abrir el .fos-card desde el explorador de archivos abre la app y
  muestra "Importar hallazgo".
- [ ] Se ve la información del hallazgo y la huella del remitente.
- [ ] **Modo no experto**: opción "Importar como amigo".
- [ ] **Modo experto** (ver bloque 8): aparecen 3 opciones: Certificar /
  Acuse de recibo / Descartar.
- [ ] Tras importar, el hallazgo aparece en la pestaña "Compartidas conmigo".

### Modo Experto

Para activarlo se necesita un código off-band (sin servidor).

- [ ] En Ajustes → "Modo Experto" se pide un código.
- [ ] Generar un código de prueba propio (opción en la pantalla).
- [ ] Introducir el código y rellenar nombre + colegiación + origen.
- [ ] Tras activar, se puede certificar un .fos-card importado.
- [ ] La certificación añade un eslabón a la cadena de hashes.
- [ ] Reexportar el .fos-card lleva la cadena de firmas completa.
- [ ] **Verificación**: importar un .fos-card certificado verifica la
  cadena entera.

**Notas / hallazgos**:


---

## Bloque 8 — Estadísticas

- [ ] Pantalla de estadísticas accesible desde el menú.
- [ ] Muestra: número total, conteo por periodo, top especies, top
  formaciones, primer y último hallazgo.
- [ ] Los gráficos de barras son legibles.
- [ ] La pantalla carga rápido aunque haya muchos hallazgos.

**Notas / hallazgos**:


---

## Bloque 9 — Guía (fósiles y minerales)

- [ ] Pantalla "Guía" muestra dos pestañas: Fósiles / Minerales.
- [ ] La pestaña Fósiles agrupa por periodo geológico.
- [ ] La pestaña Minerales agrupa por clase Strunz.
- [ ] Buscar filtra por nombre / grupo / descripción.
- [ ] Cada item carga su miniatura de Wikipedia (puede tardar la primera
  vez).
- [ ] Tocar un item abre su detalle con descripción, lugar habitual,
  imagen.
- [ ] **Línea del tiempo**: accesible desde el menú, muestra los periodos
  en bloque con miniaturas de fósiles horizontales.
- [ ] **Quiz**: accesible desde el menú, plantea preguntas sobre fósiles.

**Notas / hallazgos**:


---

## Bloque 10 — Tracks GPS

- [ ] Botón de grabación en el mapa inicia un track.
- [ ] Mientras graba, la app muestra un track rojo en el mapa.
- [ ] Salir de la app y volver: la grabación continúa (background).
- [ ] Detener guarda el track con duración, distancia, número de puntos.
- [ ] Pantalla "Tracks guardados" lista los tracks.
- [ ] Tocar un track abre un sheet con mapa del recorrido + datos.
- [ ] **Exportar GPX** comparte un fichero válido.
- [ ] **Importar GPX** desde un fichero externo añade el track.
- [ ] **Informe PDF de salida** genera un PDF con el track + hallazgos
  que se hicieron durante el track.

**Notas / hallazgos**:


---

## Bloque 11 — Mapas offline

- [ ] Pantalla "Mapas offline" accesible desde el menú.
- [ ] Selección de bbox y zoom.
- [ ] Descarga las teselas con barra de progreso.
- [ ] Tras descargar, en modo avión los mapas se ven igual.
- [ ] Borrar caché libera espacio.

**Notas / hallazgos**:


---

## Bloque 12 — Meteorología

- [ ] Pantalla de meteo desde Inicio.
- [ ] Carga previsión a varios días para una localización.
- [ ] Se puede cambiar de localización buscando lugares.
- [ ] Botón "Mi ubicación" usa GPS.

**Notas / hallazgos**:


---

## Bloque 13 — Chat IA

Requiere API key de Anthropic o DeepSeek (config en Ajustes).

- [ ] Pantalla de chat se abre.
- [ ] Si no hay API key, mensaje claro de cómo configurarla.
- [ ] Con API key, enviar mensaje recibe respuesta.
- [ ] Se pueden adjuntar fotos al chat (para identificación).
- [ ] El chat conserva el contexto durante la sesión.

**Notas / hallazgos**:


---

## Bloque 14 — Ajustes

- [ ] **Identidad criptográfica**: huella corta visible, opción de
  regenerar claves (con confirmación).
- [ ] **Backup**: generar backup .zip cifrado con todos los datos.
- [ ] **Restaurar backup**: pide confirmación antes de sobrescribir.
- [ ] **API keys** (Anthropic, DeepSeek): se guardan localmente.
- [ ] **Modo Experto**: activación con código, generar código propio.
- [ ] **Acerca**: versión, compromisos legales.

**Notas / hallazgos**:


---

## Bloque 15 — Pruebas de robustez

Probar cosas que pueden romper:

- [ ] Hacer un hallazgo sin foto.
- [ ] Hacer un hallazgo sin GPS (entrar coords a mano).
- [ ] Hacer un hallazgo con 5+ fotos.
- [ ] Borrar un hallazgo y verificar que también desaparece del mapa.
- [ ] Modo avión: app sigue funcionando para hallazgos ya cargados.
- [ ] Cerrar y abrir la app: el estado se conserva.
- [ ] Girar el dispositivo: el mapa no se rompe.
- [ ] Hacer backup, borrar un hallazgo, restaurar: el hallazgo vuelve.
- [ ] App en background durante grabación de track: la grabación NO se pierde.

**Notas / hallazgos**:


---

## Bloque 16 — Perspectiva geólogo profesional

*Esta sección está pensada para perfiles con formación en geología /
paleontología. El resto de testers puede saltarla o leerla por curiosidad.*

### Catálogos curados

- [ ] El catálogo cronoestratigráfico que usa la app (`cronoestratigrafia.dart`):
  ¿son razonables las edades, periodos y subdivisiones?
- [ ] El catálogo de fósiles guía (`datos_guia.dart`): para cada fósil,
  ¿son correctos el periodo, el grupo, la descripción corta, el lugar
  donde se encuentra?
- [ ] El catálogo de minerales (`datos_minerales.dart`): clasificación
  Strunz, durezas Mohs, fórmulas químicas — ¿algo evidentemente mal?
- [ ] El catálogo de yacimientos curados (`yacimientos_curados.dart`):
  para los yacimientos que conozcas, ¿son correctos los datos?

### Capas geológicas

- [ ] **MAGNA** (Mapa Geológico Nacional 1:50.000 del IGME): ¿se renderiza
  correctamente? ¿La leyenda es suficiente?
- [ ] **GEODE** (continuo digital): igual.
- [ ] **LIG** (Lugares de Interés Geológico del IGME): ¿la información
  está al día?
- [ ] **Asistente geológico**: cuando consultas un punto, ¿la formación,
  edad y litología que devuelve son acordes con lo que esperarías?

### Trazabilidad

- [ ] **Cadena de firmas para certificación**: ¿el modelo de tener un
  Modo Experto activado por código off-band cubre el caso de uso de un
  instituto geológico que certifica hallazgos amateurs?
- [ ] **Difuminado de coordenadas**: ¿el umbral de difuminado (2 decimales
  ≈ 1 km) es apropiado para evitar saqueo de hallazgos sensibles?

### Sugerencias estructurales

- [ ] ¿Qué datos del hallazgo crees que faltan? (orientación de la
  litología, espesor del estrato, foto del afloramiento general...).
- [ ] ¿Tiene sentido pedirle al usuario amateur strike/dip? ¿Hay forma
  mejor de capturarlo en campo?
- [ ] ¿Cómo crees que se debería gestionar el envío de un hallazgo
  importante a un museo o universidad?
- [ ] ¿Qué formaciones geológicas (Iberia / Euskal Herria / tu zona)
  faltan en el catálogo?
- [ ] Si añadimos formularios específicos de muestreo (sedimentología,
  paleomagnetismo, micropaleontología), ¿cuáles son los más útiles?

### Recursos externos consultados

- [ ] ¿Falta algún servicio público (AEMPS, IGME, ICONA, museos
  regionales) que sería útil integrar?

**Comentarios libres del geólogo**:


---

## Feedback general

Aquí espacio libre para lo que no encaje en los bloques anteriores:
funcionalidades que faltan, flujos que mejorarías, comparaciones con
otras apps que conoces, prioridades de qué arreglar primero, etc.

**Comentarios libres**:


---

## Información del tester

- **Nombre / alias**:
- **Perfil** (aficionado / geólogo / paleontólogo / programador / otro):
- **Dispositivo**:
- **Versión Android**:
- **Fecha del informe**:
- **Tiempo aproximado dedicado al testeo**:
