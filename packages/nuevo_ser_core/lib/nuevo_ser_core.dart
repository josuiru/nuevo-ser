/// Plataforma compartida de la Colección Nuevo Ser Kids.
///
/// Submódulos previstos en el plan de extracción (`coleccion-nuevo-ser/
/// plataforma/nuevo-ser-core-arquitectura.md` §8.2):
///   - `src/account/`   — autenticación, perfiles
///   - `src/sync/`      — cliente HTTP, last-write-wins, cola offline
///   - `src/mastery/`   — motor adaptativo, selector de habilidades
///   - `src/storage/`   — persistencia (shared_preferences hoy, Isar v1.5)
///   - `src/i18n/`      — utilidades de localización
///   - `src/audio/`     — capa sonora, descargador de paquetes
///   - `src/narrative/` — sistema de cinemáticas genérico
///
/// Estado de la extracción tras Chunk 6:
///   - mastery: modelos (`Habilidad`, `EstadoHabilidad`, `IntentoHabilidad`),
///              motor adaptativo (`MasteryEngine` + 4 `MasteryProfile`:
///              P1Precision funcional, P2/P3/P4 stubs).
///   - sync:    `ClienteApi`, `ExcepcionApi`.
///   - resto:   pendiente (ver README del paquete para deuda asumida).
library nuevo_ser_core;

export 'src/mastery/habilidad.dart';
export 'src/mastery/mastery_engine.dart';
export 'src/mastery/mastery_profile.dart';
export 'src/mastery/perfiles/p1_precision.dart';
export 'src/mastery/perfiles/p2_detection.dart';
export 'src/mastery/perfiles/p3_construction.dart';
export 'src/mastery/perfiles/p4_calibration.dart';
export 'src/mastery/selector_habilidades.dart';
export 'src/sync/cliente_api.dart';
