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
///
/// Pendiente (siguen 501 en el servidor):
/// - `POST /companion/aggregates/weekly`
/// - `POST /classrooms`, `POST /classrooms/{code}/join`,
///   `GET /classrooms/{id}/aggregates`
/// - `POST /caregivers/link/{request,verify}`,
///   `GET /caregivers/{caregiverId}/children/{childId}/summary`
library nuevo_ser_companion;

export 'src/cliente_companion.dart';
export 'src/cuaderno/entrada_cuaderno.dart';
export 'src/cuaderno/listado_entradas_cuaderno.dart';
export 'src/mosaicos/mosaico.dart';
