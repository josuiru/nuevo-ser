import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/ambiente_archivo.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  group('AmbienteArchivo', () {
    test('implementa el contrato genérico AmbienteEscenaContrato', () {
      expect(AmbienteArchivo.salaEvaluacion, isA<AmbienteEscenaContrato>());
      expect(AmbienteArchivo.archivoNocturno, isA<AmbienteEscenaContrato>());
      expect(AmbienteArchivo.sierraAmanecer, isA<AmbienteEscenaContrato>());
      expect(AmbienteArchivo.cuevaInterior, isA<AmbienteEscenaContrato>());
    });

    test('cada ambiente tiene un identificador estable en snake_case', () {
      expect(AmbienteArchivo.salaEvaluacion.identificador, 'sala_evaluacion');
      expect(AmbienteArchivo.archivoNocturno.identificador, 'archivo_nocturno');
      expect(AmbienteArchivo.sierraAmanecer.identificador, 'sierra_amanecer');
      expect(AmbienteArchivo.cuevaInterior.identificador, 'cueva_interior');
      expect(AmbienteArchivo.patioArchivo.identificador, 'patio_archivo');
      expect(AmbienteArchivo.aticoArchivo.identificador, 'atico_archivo');
      expect(AmbienteArchivo.salonConcilio.identificador, 'salon_concilio');
      expect(AmbienteArchivo.cocinaArchivo.identificador, 'cocina_archivo');
      expect(
        AmbienteArchivo.cocinaCasaMaren.identificador,
        'cocina_casa_maren',
      );
      expect(
        AmbienteArchivo.cuartoCasaMaren.identificador,
        'cuarto_casa_maren',
      );
      expect(
        AmbienteArchivo.recorridoArchivo.identificador,
        'recorrido_archivo',
      );
      expect(AmbienteArchivo.casaMaren.identificador, 'casa_maren');
    });

    test('los identificadores son únicos entre los ambientes catalogados',
        () {
      final identificadores = {
        AmbienteArchivo.salaEvaluacion.identificador,
        AmbienteArchivo.archivoNocturno.identificador,
        AmbienteArchivo.sierraAmanecer.identificador,
        AmbienteArchivo.cuevaInterior.identificador,
        AmbienteArchivo.patioArchivo.identificador,
        AmbienteArchivo.aticoArchivo.identificador,
        AmbienteArchivo.salonConcilio.identificador,
        AmbienteArchivo.cocinaArchivo.identificador,
        AmbienteArchivo.cocinaCasaMaren.identificador,
        AmbienteArchivo.cuartoCasaMaren.identificador,
        AmbienteArchivo.recorridoArchivo.identificador,
        AmbienteArchivo.casaMaren.identificador,
      };
      expect(identificadores.length, 12);
    });

    test('AmbienteEscenaNeutro del core sigue siendo válido como default '
        '— las escenas que no caracterizan ambiente caen al neutro', () {
      const ambiente = AmbienteEscenaNeutro();
      expect(ambiente, isA<AmbienteEscenaContrato>());
    });
  });
}
