import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'modelos_isar.dart';

/// Apertura de la base Isar del juego. Vive bajo el directorio de
/// documentos de la app, en una carpeta `el_cuaderno/` propia del
/// juego — coherente con el patrón ya usado por uno-roto para audio
/// (`<docs>/uroto/sonido/`). Sprint 5 añadirá cifrado en reposo
/// (`encryptionKey`) derivado de la cuenta + dispositivo (doc 03
/// §10.2). En S1 la base abre sin cifrar para no enmascarar la
/// decisión que aún no se ha tomado a nivel de cuenta.
class IsarSetup {
  IsarSetup({this.directorioOverride});

  /// Directorio donde abrir la base. Si es `null`, se usa el
  /// `getApplicationDocumentsDirectory()` del dispositivo. El
  /// override lo usan los tests para apuntar a un directorio
  /// temporal.
  final String? directorioOverride;

  Isar? _instancia;

  Isar get instancia {
    final actual = _instancia;
    if (actual == null) {
      throw StateError('llama a abrir() antes de usar la instancia Isar');
    }
    return actual;
  }

  Future<Isar> abrir() async {
    final yaAbierta = _instancia;
    if (yaAbierta != null) {
      return yaAbierta;
    }

    final directorio = directorioOverride ??
        (await getApplicationDocumentsDirectory()).path;

    final isar = await Isar.open(
      [
        ObservacionIsarSchema,
        SitSpotIsarSchema,
        MisterioIsarSchema,
        PaginaCuadernoIsarSchema,
      ],
      directory: directorio,
      name: 'el_cuaderno',
    );
    _instancia = isar;
    return isar;
  }

  Future<void> cerrar() async {
    final actual = _instancia;
    if (actual == null) return;
    await actual.close();
    _instancia = null;
  }
}
