# nuevo_ser_core

Plataforma compartida de la **Colección Nuevo Ser Kids**.

## Estado

Paquete **vacío** en el Chunk 1 del refactor. Su contenido se extrae desde `apps/uno-roto/lib/` en chunks posteriores:

- **Chunk 5** — extracción de `datos/` y `sonido/` y partes genéricas de `dominio/` (motor de maestría, selector, sistema de cinemáticas, repositorio con whitelist, capa sonora).
- **Chunk 6** — refactor del motor adaptativo con interfaz `MasteryProfile` y stubs P2-P4.

Hasta entonces, el paquete solo declara la `library` para que Melos lo reconozca.

## Submódulos previstos

```
lib/src/
├── account/    autenticación, perfiles
├── sync/       cliente HTTP, last-write-wins, cola offline
├── mastery/    motor adaptativo, selector de habilidades
├── storage/    persistencia
├── i18n/       utilidades de localización
├── audio/      capa sonora, descargador de paquetes
└── narrative/  sistema de cinemáticas genérico
```

## Deuda técnica explícita

- **Persistencia**: el cliente actual usa `shared_preferences` con whitelist global y prefijos por perfil (`uroto.perfil.<id>.<sufijo>`). El doc de arquitectura prescribe Isar (`coleccion-nuevo-ser/plataforma/nuevo-ser-core-arquitectura.md` §3.1). **Migración a Isar diferida a v1.5** — no entra en este refactor para no inflar el alcance ni romper la promesa "tests existentes pasan idénticos" del Chunk 8.
- **Claves de persistencia**: el prefijo `uroto.*` se mantiene para Uno Roto. Juegos nuevos (Las Versiones, El Cuaderno) usarán `nuevoser.<juego>.*`. Renombrado uniforme diferido a v1.5.

## Licencia

AGPL-3.0 — coherente con el resto de la Colección Nuevo Ser.
