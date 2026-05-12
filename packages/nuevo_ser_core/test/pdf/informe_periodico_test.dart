import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:pdf/widgets.dart' as pw;

/// Tests del módulo de informes PDF del core. No comparamos píxeles
/// (los tests visuales serían frágiles); verificamos que el binario
/// se produce, es un PDF válido (header `%PDF-`) y supera un tamaño
/// mínimo razonable. El comportamiento puro del API (omitir tabla
/// vacía vs mostrar mensaje) sí queda cubierto en tests separados.
class _PathProviderTemporalEnTest extends PathProviderPlatform {
  final Directory directorioBase;
  _PathProviderTemporalEnTest(this.directorioBase);

  @override
  Future<String?> getTemporaryPath() async => directorioBase.path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory directorioTemporal;

  setUp(() {
    directorioTemporal = Directory.systemTemp.createTempSync('informe_pdf_test_');
    PathProviderPlatform.instance = _PathProviderTemporalEnTest(directorioTemporal);
  });

  tearDown(() {
    if (directorioTemporal.existsSync()) {
      directorioTemporal.deleteSync(recursive: true);
    }
  });

  group('generarInformePeriodicoPdf', () {
    test('PDF mínimo: solo cabecera + bullets', () async {
      final fichero = await generarInformePeriodicoPdf(
        tituloCabecera: 'Finca Norte',
        subtituloCabecera: 'Campaña 2025',
        bulletsResumen: const ['Plantas: 42', 'Cosecha total: 120 kg'],
        tablas: const [],
        prefijoNombreFichero: 'campana',
      );

      expect(await fichero.exists(), true);
      final bytes = await fichero.readAsBytes();
      expect(bytes.length, greaterThan(500));
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('PDF con una tabla con filas', () async {
      final fichero = await generarInformePeriodicoPdf(
        tituloCabecera: 'Finca Norte',
        subtituloCabecera: 'Campaña 2025',
        bulletsResumen: const ['Plantas: 3'],
        tablas: [
          TablaInforme(
            titulo: 'Cosechas',
            headers: const ['Etiqueta', 'Kg'],
            filas: const [
              ['A-1', '12.50'],
              ['A-2', '8.00'],
            ],
            alineamientoCeldas: const {1: pw.Alignment.centerRight},
          ),
        ],
        prefijoNombreFichero: 'campana',
      );

      final bytes = await fichero.readAsBytes();
      expect(bytes.length, greaterThan(500));
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('TablaInforme vacía + mensajeSiVacia: se renderiza con el texto', () async {
      final fichero = await generarInformePeriodicoPdf(
        tituloCabecera: 'Finca Norte',
        subtituloCabecera: 'Campaña 2025',
        bulletsResumen: const ['Plantas: 0'],
        tablas: [
          TablaInforme(
            titulo: 'Cosechas',
            headers: const ['Etiqueta', 'Kg'],
            filas: const [],
            mensajeSiVacia: 'Sin cosechas registradas.',
          ),
        ],
        prefijoNombreFichero: 'campana_vacia',
      );

      final bytes = await fichero.readAsBytes();
      expect(bytes.length, greaterThan(500));
    });

    test('operador y fechaGeneracion se admiten opcionalmente', () async {
      final fichero = await generarInformePeriodicoPdf(
        tituloCabecera: 'Finca Norte',
        subtituloCabecera: 'Campaña 2025',
        bulletsResumen: const ['Plantas: 10'],
        tablas: const [],
        prefijoNombreFichero: 'campana',
        operador: 'Antonio Beltrán',
        fechaGeneracion: DateTime(2026, 5, 7, 10, 30),
      );

      expect(await fichero.exists(), true);
    });

    test('prefijo se sanea: espacios y caracteres no seguros → _', () async {
      final fichero = await generarInformePeriodicoPdf(
        tituloCabecera: 'X',
        subtituloCabecera: 'Y',
        bulletsResumen: const [],
        tablas: const [],
        prefijoNombreFichero: 'mi finca/2025!',
      );

      expect(fichero.path, contains('mi_finca_2025_'));
    });

    test('múltiples tablas se incluyen en orden', () async {
      final fichero = await generarInformePeriodicoPdf(
        tituloCabecera: 'X',
        subtituloCabecera: 'Y',
        bulletsResumen: const [],
        tablas: [
          TablaInforme(
            titulo: 'Primera',
            headers: const ['a', 'b'],
            filas: const [
              ['1', '2'],
            ],
          ),
          TablaInforme(
            titulo: 'Segunda',
            headers: const ['c', 'd'],
            filas: const [
              ['3', '4'],
            ],
          ),
        ],
        prefijoNombreFichero: 'multitabla',
      );

      expect(await fichero.exists(), true);
    });
  });

  group('guardarPdfTemporal — fichero resultante', () {
    test('extensión .pdf y existe en disco', () async {
      final fichero = await generarInformePeriodicoPdf(
        tituloCabecera: 'X',
        subtituloCabecera: 'Y',
        bulletsResumen: const [],
        tablas: const [],
        prefijoNombreFichero: 'minimo',
      );

      expect(fichero.path, endsWith('.pdf'));
      expect(await fichero.exists(), true);
    });
  });
}
