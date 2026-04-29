import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NivelConfianza.toLocaleLabel', () {
    test('castellano devuelve la etiqueta canónica del doc 13 §3.2', () {
      expect(NivelConfianza.consenso.toLocaleLabel('es'), 'consenso');
      expect(
        NivelConfianza.hipotesisActiva.toLocaleLabel('es'),
        'hipótesis activa',
      );
      expect(NivelConfianza.abandonado.toLocaleLabel('es'), 'abandonado');
      expect(
        NivelConfianza.noSegura.toLocaleLabel('es'),
        'no estoy segura',
      );
    });

    test('euskera devuelve los provisionales (TODO_EU pendiente de revisar)',
        () {
      expect(NivelConfianza.consenso.toLocaleLabel('eu'), 'adostasuna');
      expect(
        NivelConfianza.hipotesisActiva.toLocaleLabel('eu'),
        'hipotesi aktiboa',
      );
      expect(NivelConfianza.abandonado.toLocaleLabel('eu'), 'utzia');
      expect(NivelConfianza.noSegura.toLocaleLabel('eu'), 'ez nago ziur');
    });

    test('catalán devuelve los provisionales (TODO_CA pendiente de revisar)',
        () {
      expect(NivelConfianza.consenso.toLocaleLabel('ca'), 'consens');
      expect(
        NivelConfianza.hipotesisActiva.toLocaleLabel('ca'),
        'hipòtesi activa',
      );
      expect(NivelConfianza.abandonado.toLocaleLabel('ca'), 'abandonat');
      expect(
        NivelConfianza.noSegura.toLocaleLabel('ca'),
        "no n'estic segura",
      );
    });

    test('idioma desconocido cae a castellano', () {
      expect(NivelConfianza.consenso.toLocaleLabel('xx'), 'consenso');
    });
  });

  group('NivelConfianza.fromString', () {
    test('reconstruye los cuatro valores desde su nombre serializado', () {
      expect(NivelConfianza.fromString('consenso'), NivelConfianza.consenso);
      expect(
        NivelConfianza.fromString('hipotesisActiva'),
        NivelConfianza.hipotesisActiva,
      );
      expect(
        NivelConfianza.fromString('abandonado'),
        NivelConfianza.abandonado,
      );
      expect(NivelConfianza.fromString('noSegura'), NivelConfianza.noSegura);
    });

    test('lanza ArgumentError con texto desconocido', () {
      expect(
        () => NivelConfianza.fromString('inventado'),
        throwsArgumentError,
      );
    });
  });
}
