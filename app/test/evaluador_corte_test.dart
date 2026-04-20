import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:uno_roto/dominio/fragmento.dart';
import 'package:uno_roto/dominio/resolucion_corte.dart';

void main() {
  const evaluador = EvaluadorCorte();

  List<RadioTrazado> radiosUniformes(int cantidad, {double desfaseGrados = 0}) {
    final desfaseRad = desfaseGrados * math.pi / 180;
    final paso = (2 * math.pi) / cantidad;
    return List.generate(
      cantidad,
      (indice) => RadioTrazado(desfaseRad + paso * indice),
    );
  }

  test('cortar 1/2 con dos radios opuestos es éxito', () {
    final resultado = evaluador.evaluar(
      fragmento: const FragmentoUnitario(2),
      radios: radiosUniformes(2),
    );
    expect(resultado.esExito, isTrue);
    expect(resultado.puntuacionDistribucion, greaterThan(0.9));
  });

  test('cortar 1/3 con tres radios a 120° es éxito', () {
    final resultado = evaluador.evaluar(
      fragmento: const FragmentoUnitario(3),
      radios: radiosUniformes(3),
    );
    expect(resultado.esExito, isTrue);
  });

  test('cortar 1/4 con tres radios devuelve faltanTrazos', () {
    final resultado = evaluador.evaluar(
      fragmento: const FragmentoUnitario(4),
      radios: radiosUniformes(3),
    );
    expect(resultado.estado, EstadoIntento.faltanTrazos);
  });

  test('cortar 1/3 con cuatro radios devuelve sobranTrazos', () {
    final resultado = evaluador.evaluar(
      fragmento: const FragmentoUnitario(3),
      radios: radiosUniformes(4),
    );
    expect(resultado.estado, EstadoIntento.sobranTrazos);
  });

  test('distribución irregular se rechaza con mensaje amable', () {
    final radiosIrregulares = [
      const RadioTrazado(0),
      const RadioTrazado(0.3),
      const RadioTrazado(3.0),
    ];
    final resultado = evaluador.evaluar(
      fragmento: const FragmentoUnitario(3),
      radios: radiosIrregulares,
    );
    expect(resultado.esExito, isFalse);
    expect(resultado.estado, EstadoIntento.distribucionIrregular);
    expect(resultado.mensajeAmable, contains('iguales'));
  });

  test('tolerancia suave acepta un desvío pequeño', () {
    final radiosCasiUniformes = [
      const RadioTrazado(0),
      const RadioTrazado(2.0),
      const RadioTrazado(4.3),
    ];
    final resultado = evaluador.evaluar(
      fragmento: const FragmentoUnitario(3),
      radios: radiosCasiUniformes,
    );
    expect(resultado.esExito, isTrue,
        reason: 'el error angular debería caer dentro de los 12°');
  });
}
