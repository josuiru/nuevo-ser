import 'dart:typed_data';

import 'package:el_cuaderno/dominio/generador_observacion_pdf.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:flutter_test/flutter_test.dart';

Observacion _obs({
  String id = 'o1',
  DateTime? cuando,
  String dondeNombre = 'jardín',
  String queVio = 'una golondrina',
  String? creesQueEs,
  NivelConfianza confianza = NivelConfianza.hipotesisActiva,
  String? climaResumen,
  String? fotoRutaLocal,
  String? dibujoRutaLocal,
}) =>
    Observacion(
      id: id,
      cuandoCreada: cuando ?? DateTime(2026, 5, 15),
      cuandoOcurrio: cuando ?? DateTime(2026, 5, 15),
      dondeNombre: dondeNombre,
      queVio: queVio,
      confianza: creesQueEs == null
          ? NivelConfianza.noSegura
          : confianza,
      creesQueEs: creesQueEs,
      climaResumen: climaResumen,
      fotoRutaLocal: fotoRutaLocal,
      dibujoRutaLocal: dibujoRutaLocal,
    );

void main() {
  group('GeneradorObservacionPdf.aBytes', () {
    test('observación mínima (sólo queVio) → PDF válido no vacío', () async {
      final bytes = await GeneradorObservacionPdf.aBytes(
        observacion: _obs(),
      );
      expect(bytes.length, greaterThan(500));
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('con creesQueEs y confianza → genera sin lanzar', () async {
      final bytes = await GeneradorObservacionPdf.aBytes(
        observacion: _obs(
          creesQueEs: 'helecho',
          confianza: NivelConfianza.hipotesisActiva,
        ),
      );
      expect(bytes.length, greaterThan(500));
    });

    test('con clima resumen → genera sin lanzar', () async {
      final bytes = await GeneradorObservacionPdf.aBytes(
        observacion: _obs(climaResumen: 'soleado y fresco'),
      );
      expect(bytes.length, greaterThan(500));
    });

    test(
      'con nombre del niño y nombre del sit spot → genera sin lanzar',
      () async {
        final bytes = await GeneradorObservacionPdf.aBytes(
          observacion: _obs(),
          nombreDelNino: 'Maren',
          nombreSitSpot: 'El Roble Grande',
        );
        expect(bytes.length, greaterThan(500));
      },
    );

    test(
      'nombre del niño vacío o sólo espacios → cae al pie genérico, '
      'sin lanzar',
      () async {
        final bytesVacio = await GeneradorObservacionPdf.aBytes(
          observacion: _obs(),
          nombreDelNino: '',
        );
        final bytesEspacios = await GeneradorObservacionPdf.aBytes(
          observacion: _obs(),
          nombreDelNino: '   ',
        );
        expect(bytesVacio.length, greaterThan(500));
        expect(bytesEspacios.length, greaterThan(500));
      },
    );

    test(
      'nombre del sit spot vacío → no se pinta la línea de sit spot, '
      'sin lanzar',
      () async {
        final bytes = await GeneradorObservacionPdf.aBytes(
          observacion: _obs(),
          nombreSitSpot: '',
        );
        expect(bytes.length, greaterThan(500));
      },
    );

    test(
      'cargarMedio se invoca con las rutas de foto y dibujo si existen',
      () async {
        final pedidas = <String>[];
        await GeneradorObservacionPdf.aBytes(
          observacion: _obs(
            fotoRutaLocal: 'medios/o1_foto.jpg',
            dibujoRutaLocal: 'medios/o1_dibujo.png',
          ),
          cargarMedio: (ruta) async {
            pedidas.add(ruta);
            // Devolvemos null para no incrustar — basta con verificar
            // que el callback recibe las rutas correctas.
            return null;
          },
        );
        expect(pedidas, contains('medios/o1_foto.jpg'));
        expect(pedidas, contains('medios/o1_dibujo.png'));
      },
    );

    test(
      'cargarMedio que devuelve null no rompe el documento — el bloque '
      'de la imagen se omite',
      () async {
        final bytes = await GeneradorObservacionPdf.aBytes(
          observacion: _obs(
            fotoRutaLocal: 'medios/o1_foto.jpg',
            dibujoRutaLocal: 'medios/o1_dibujo.png',
          ),
          cargarMedio: (ruta) async => null,
        );
        expect(bytes.length, greaterThan(500));
      },
    );

    test(
      'observación sin medios y sin cargarMedio → genera el texto puro',
      () async {
        final bytes = await GeneradorObservacionPdf.aBytes(
          observacion: _obs(),
        );
        expect(bytes.length, greaterThan(500));
      },
    );

    test('confianza consenso requiere creesQueEs no null', () async {
      // Coherente con la validación del modelo: si pasamos consenso
      // sin identificación, lanza ArgumentError ANTES de llegar al
      // generador. Esta es una salvaguarda contra regresiones del
      // contrato del modelo `Observacion`, no del generador.
      expect(
        () => Observacion(
          id: 'o',
          cuandoCreada: DateTime(2026, 5, 15),
          cuandoOcurrio: DateTime(2026, 5, 15),
          dondeNombre: 'jardín',
          queVio: 'algo',
          confianza: NivelConfianza.consenso,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('los bytes son Uint8List utilizables por Printing', () async {
      final bytes = await GeneradorObservacionPdf.aBytes(observacion: _obs());
      expect(bytes, isA<Uint8List>());
    });
  });
}
