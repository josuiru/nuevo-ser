/// Acompañamiento (Cuaderno, Mosaicos, dashboards de aula y cuidador)
/// de la Colección Nuevo Ser Kids.
///
/// Cliente HTTP de los endpoints `/wp-json/nuevo-ser/v1/companion/*`
/// del plugin `nuevo-ser-core`. Implementación incremental: cada ruta
/// sale del estado 501 reservado en C7 cuando esta librería tiene un
/// cliente capaz de invocarla.
///
/// Estado v0.1:
/// - Cuaderno: `crearEntradaCuaderno` cubre `POST /companion/cuaderno/entries`.
/// - Cuaderno: `listarEntradasCuaderno` cubre `GET /companion/cuaderno/entries`.
/// - Mosaicos: `crearMosaico` cubre `POST /companion/mosaicos`.
/// - Mosaicos: `listarMosaicos` cubre `GET /companion/mosaicos`.
/// - Aulas (niño): `unirseAula` cubre `POST /classrooms/{code}/join`.
/// - Aulas (profesor): `crearAula` cubre `POST /classrooms`;
///   `obtenerAgregadosAula` cubre `GET /classrooms/{id}/aggregates`
///   con k mínimo = 5 (B7 — fallback de experto, pendiente de policy
///   escolar y de UI del profesor en cliente).
/// - Auth adulto: [ClienteAuthAdulto] cubre `POST /auth/login` con
///   shape `{email, password, rol}` para profesor o cuidador.
/// - Agregados: `archivarAgregadosSemanales` cubre
///   `POST /companion/aggregates/weekly`. El servidor llama al tutor IA
///   (Claude Haiku) cuando los agregados cambian, aplica el filtro de
///   PII y cachea por hash. Si el LLM falla, archivamos sin resumen y
///   el cliente reintenta más tarde.
///
/// Pendiente (siguen 501 en el servidor):
/// - `POST /caregivers/link/{request,verify}`,
///   `GET /caregivers/{caregiverId}/children/{childId}/summary`
library nuevo_ser_companion;

export 'src/agregados/agregado_semanal.dart';
export 'src/aulas/agregados_aula.dart';
export 'src/aulas/aula_creada.dart';
export 'src/aulas/membresia_aula.dart';
export 'src/auth/cliente_auth_adulto.dart';
export 'src/cliente_companion.dart';
export 'src/cuaderno/entrada_cuaderno.dart';
export 'src/cuaderno/listado_entradas_cuaderno.dart';
export 'src/mosaicos/listado_mosaicos.dart';
export 'src/mosaicos/mosaico.dart';
