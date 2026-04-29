/// Plataforma compartida de la Colección Nuevo Ser Kids.
///
/// Este paquete está vacío en C1 del refactor. Su contenido se extrae desde
/// `apps/uno-roto/lib/` a `lib/src/` en el Chunk 5 del plan de migración (ver
/// `coleccion-nuevo-ser/plataforma/nuevo-ser-core-arquitectura.md` §8.2).
///
/// Submódulos previstos:
///   - `src/account/`   — autenticación, perfiles
///   - `src/sync/`      — cliente HTTP, last-write-wins, cola offline
///   - `src/mastery/`   — motor adaptativo, selector de habilidades
///   - `src/storage/`   — persistencia (shared_preferences hoy, Isar v1.5)
///   - `src/i18n/`      — utilidades de localización
///   - `src/audio/`     — capa sonora, descargador de paquetes
///   - `src/narrative/` — sistema de cinemáticas genérico
library nuevo_ser_core;
