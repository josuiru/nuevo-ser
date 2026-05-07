import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'modelos_isar.dart';

/// Apertura de la base Isar del juego. Vive bajo el directorio de
/// documentos de la app, en una carpeta `el_cuaderno/` propia del
/// juego — coherente con el patrón ya usado por uno-roto para audio
/// (`<docs>/uroto/sonido/`).
///
/// **Estado del cifrado en reposo (biblia §2.1, doc 03 §10.2):**
///
/// Isar 3.x Community NO soporta `encryptionKey` — la API de cifrado
/// vive en Isar Pro (de pago) y se anuncia para Isar v4 (en preview,
/// no estable). El paquete instalado (`isar: ^3.1.0+1`) no expone
/// `encryptionKey` en `Isar.open`. Comprobado contra el fuente del
/// paquete (no aparece la propiedad).
///
/// Mitigación actual (parcial pero real):
/// - Sandbox de Android: el fichero vive bajo `/data/data/<paquete>/`
///   y es inaccesible a otras apps salvo con root. Suficiente para
///   familias del operador en piloto interno.
/// - Frontera de privacidad estructural: el cliente HTTP del cuaderno
///   (cliente_el_cuaderno.dart) impide que texto libre/coords/fotos
///   crucen red — sólo viajan hash + region_code agregado.
///
/// Pendiente para piloto público (decisión humana, ver memoria
/// `project_el_cuaderno_decisiones_humanas_pendientes`):
/// 1. Migrar a Isar v4 cuando esté estable y pase de preview.
/// 2. O migrar persistencia a sqflite + sqflite_sqlcipher (mismo
///    patrón que naturaleza/fosiles, con cifrado nativo).
/// 3. O cifrar a mano campos sensibles (`queVio`, `creesQueEs`,
///    `dondeCoordenadas`) con `package:cryptography` y clave en
///    `flutter_secure_storage` — rompe la búsqueda accent-insensitive
///    de `PantallaListaObservaciones`.
/// 4. O pagar licencia Isar Pro.
///
/// Decisión: bloquea el piloto público; no bloquea el piloto interno
/// con familias del operador. Documentado para que la elección sea
/// consciente.
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
        PreguntaDelNinoIsarSchema,
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
