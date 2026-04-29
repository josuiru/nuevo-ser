/// Cliente del Tutor IA — proxy a Claude API con caché y filtros.
///
/// Extracción del Chunk 5: el cliente HTTP, la caché LRU sobre prefs, el
/// filtro de seguridad y el disparador heurístico ya viven aquí. El
/// `ServicioTutor` orquestador queda en `apps/uno-roto/lib/dominio/tutor/`
/// porque depende de `RepositorioProgreso` (acoplado al juego concreto);
/// se moverá cuando C6/C7 separen el repositorio en core + específico.
library nuevo_ser_tutor;

export 'src/cache_tutor.dart';
export 'src/cliente_tutor.dart';
export 'src/disparador_tutor.dart';
export 'src/filtro_seguridad.dart';
export 'src/repositorio_estado_tutor.dart';
