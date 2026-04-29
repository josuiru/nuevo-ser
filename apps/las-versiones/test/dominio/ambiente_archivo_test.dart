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
    });

    test('los identificadores son únicos entre los ambientes catalogados',
        () {
      final identificadores = {
        AmbienteArchivo.salaEvaluacion.identificador,
        AmbienteArchivo.archivoNocturno.identificador,
        AmbienteArchivo.sierraAmanecer.identificador,
        AmbienteArchivo.cuevaInterior.identificador,
      };
      expect(identificadores.length, 4);
    });

    test('AmbienteEscenaNeutro del core sigue siendo válido como default '
        '— las escenas que no caracterizan ambiente caen al neutro', () {
      const ambiente = AmbienteEscenaNeutro();
      expect(ambiente, isA<AmbienteEscenaContrato>());
    });
  });
}
