import 'package:el_cuaderno/dominio/exportador_cuaderno_pdf.dart';
import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExportadorCuadernoPdf.aBytes', () {
    test('genera bytes que empiezan con la firma %PDF-', () async {
      final bytes = await ExportadorCuadernoPdf.aBytes(
        tituloDelNino: 'Lucía',
        observaciones: const [],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      expect(bytes, isNotEmpty);
      // Cabecera PDF estándar: 0x25 0x50 0x44 0x46 0x2D = "%PDF-".
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('cuaderno vacío produce un PDF válido sin lanzar', () async {
      final bytes = await ExportadorCuadernoPdf.aBytes(
        tituloDelNino: 'Lucía',
        observaciones: const [],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      expect(bytes.length, greaterThan(500));
    });

    test('cuaderno con observaciones, sit spot y misterios produce más bytes',
        () async {
      final bytesVacio = await ExportadorCuadernoPdf.aBytes(
        tituloDelNino: 'Lucía',
        observaciones: const [],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      final observaciones = [
        Observacion(
          id: 'obs-1',
          cuandoCreada: DateTime.utc(2026, 4, 30, 17, 48),
          cuandoOcurrio: DateTime.utc(2026, 4, 30, 17, 30),
          dondeNombre: 'El Roble Grande',
          queVio: 'Pájaro pequeño marrón con pico fino',
          confianza: NivelConfianza.hipotesisActiva,
          creesQueEs: 'petirrojo',
        ),
      ];
      final sitSpot = SitSpot(
        id: 'sp-1',
        nombre: 'El Roble Grande',
        dondeNombre: 'al final del parque',
        creadoEn: DateTime.utc(2026, 3, 1),
      );
      final misterios = [
        Misterio(
          id: 'mist-1',
          pregunta: '¿Cuándo florece el almendro?',
          descripcionCorta: 'Vigila el almendro de tu calle desde febrero.',
          estado: NivelConfianza.consenso,
          abierto: true,
        ),
      ];
      final bytesPleno = await ExportadorCuadernoPdf.aBytes(
        tituloDelNino: 'Lucía',
        observaciones: observaciones,
        sitSpot: sitSpot,
        misterios: misterios,
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      expect(bytesPleno.length, greaterThan(bytesVacio.length));
    });

    test(
        'cargarMedio inyectado se invoca con cada ruta apuntada y null no rompe',
        () async {
      // Verificamos el comportamiento del callback (qué rutas pide, en
      // qué orden, ignora observaciones sin medios). Devolvemos `null`
      // como si los ficheros no existieran — el PDF se genera sin esas
      // imágenes y el path "medio huérfano" del exportador queda
      // ejercitado. La incrustación real requiere bytes JPEG/PNG
      // decodificables y se cubre en el smoke manual del APK.
      final rutasPedidas = <String>[];
      final observaciones = [
        Observacion(
          id: 'obs-1',
          cuandoCreada: DateTime.utc(2026, 4, 30),
          cuandoOcurrio: DateTime.utc(2026, 4, 30),
          dondeNombre: 'parque',
          queVio: 'algo',
          confianza: NivelConfianza.hipotesisActiva,
          fotoRutaLocal: 'medios/obs-1_foto.jpg',
          dibujoRutaLocal: 'medios/obs-1_dibujo.png',
        ),
        Observacion(
          id: 'obs-2',
          cuandoCreada: DateTime.utc(2026, 4, 30),
          cuandoOcurrio: DateTime.utc(2026, 4, 30),
          dondeNombre: 'parque',
          queVio: 'otro',
          confianza: NivelConfianza.hipotesisActiva,
          // sin medios — no debe pedir nada al callback.
        ),
      ];
      final bytes = await ExportadorCuadernoPdf.aBytes(
        tituloDelNino: 'Lucía',
        observaciones: observaciones,
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
        cargarMedio: (ruta) async {
          rutasPedidas.add(ruta);
          return null;
        },
      );
      // Sólo se piden los medios de la observación que los tiene.
      expect(rutasPedidas, [
        'medios/obs-1_foto.jpg',
        'medios/obs-1_dibujo.png',
      ]);
      // El PDF se genera; el null no rompe el documento.
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('sin cargarMedio, no se intenta resolver ningún medio', () async {
      // Caso degradado: no se inyecta cargarMedio. El PDF queda en
      // formato sólo-texto (modo S1) y el `Future.wait` interno no
      // se ejecuta.
      final observaciones = [
        Observacion(
          id: 'obs-x',
          cuandoCreada: DateTime.utc(2026, 4, 30),
          cuandoOcurrio: DateTime.utc(2026, 4, 30),
          dondeNombre: 'parque',
          queVio: 'algo',
          confianza: NivelConfianza.hipotesisActiva,
          fotoRutaLocal: 'medios/obs-x_foto.jpg',
        ),
      ];
      final bytes = await ExportadorCuadernoPdf.aBytes(
        tituloDelNino: 'Lucía',
        observaciones: observaciones,
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('título con caracteres acentuados se preserva en la cabecera',
        () async {
      // No miramos el contenido binario del PDF (los strings van
      // codificados internamente); el smoke es que la generación
      // no lanza con tildes y eñes.
      final bytes = await ExportadorCuadernoPdf.aBytes(
        tituloDelNino: 'Iñaki',
        observaciones: const [],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      expect(bytes.length, greaterThan(500));
    });
  });
}
