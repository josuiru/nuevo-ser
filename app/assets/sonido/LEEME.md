# Assets sonoros — placeholders

Este árbol implementa la arquitectura de 4 capas del doc 12:

- `ambient/` — capa 1 (viento, ruido rosa, agua por distrito).
- `musica/` — capa 2 (loops por distrito, combate, narrativos).
- `efectos/` — capa 3 (tap, acierto, error, gestos).
- `narrativos/` — capa 4 (silbido de Zafrán, voz de Eco, baja de volumen).

Entrega esperada: **WAV 44.1 kHz 16-bit**, loops con punto de bucle
alineado sin clicks, archivos independientes por capa.

El motor (`lib/sonido/servicio_sonoro.dart`) resuelve los identificadores
lógicos en `catalogo_sonidos.dart` a rutas concretas de esta carpeta.
Si un archivo no existe, la llamada es silenciosa: la app sigue
funcionando sin sonido. Esto permite integrar las llamadas en el
código del juego antes de tener los assets finales.
