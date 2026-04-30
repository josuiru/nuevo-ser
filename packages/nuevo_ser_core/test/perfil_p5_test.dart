import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Tests del perfil P5 compuesto (doc 03 §4 — El Cuaderno) y paridad
/// Dart/PHP. Consume `test/fixtures/perfil_p5.json`. El test PHP
/// (`wp-plugin/nuevo-ser-core/tests/test_paridad_perfil_p5.php`) lee la
/// misma fixture; cualquier cambio en el algoritmo o las umbrales
/// debe verificarse en ambos lados.
void main() {
  group('PerfilP5Compuesto — comportamiento básico', () {
    final perfil = const PerfilP5Compuesto();

    test('PesosP5 rechaza sumas distintas de 1.0', () {
      expect(
        () => PesosP5({ComponenteP5.precision: 0.5, ComponenteP5.rubrica: 0.4}),
        throwsArgumentError,
      );
    });

    test('PesosP5 acepta sumas dentro de eps=1e-6', () {
      expect(
        () => PesosP5({
          ComponenteP5.precision: 0.3333333333333,
          ComponenteP5.rubrica: 0.3333333333333,
          ComponenteP5.cobertura: 0.3333333333334,
        }),
        returnsNormally,
      );
    });

    test('PesosP5 rechaza pesos fuera de [0, 1]', () {
      expect(
        () => PesosP5({ComponenteP5.precision: 1.2}),
        throwsArgumentError,
      );
      expect(
        () => PesosP5({ComponenteP5.precision: -0.1, ComponenteP5.rubrica: 1.1}),
        throwsArgumentError,
      );
    });

    test('NaN en proxy se trata como 0', () {
      final r = perfil.calcular(
        mediciones: MedicionesP5(
          proxy: double.nan,
          historico: const HistoricoP5(sesiones: 3),
        ),
        pesos: PesosP5({ComponenteP5.proxy: 1.0}),
      );
      expect(r.scoresNormalizados[ComponenteP5.proxy], 0);
      expect(r.scoreCompuesto, 0);
    });

    test('valor de proxy >1 clampa a 1', () {
      final r = perfil.calcular(
        mediciones: MedicionesP5(
          proxy: 1.6,
          historico: const HistoricoP5(sesiones: 3),
        ),
        pesos: PesosP5({ComponenteP5.proxy: 1.0}),
      );
      expect(r.scoresNormalizados[ComponenteP5.proxy], 1.0);
    });
  });

  group('PerfilP5Compuesto — paridad Dart/PHP (fixture)', () {
    late List<dynamic> casos;

    setUpAll(() {
      final fixture =
          File('test/fixtures/perfil_p5.json').readAsStringSync();
      casos = (jsonDecode(fixture) as Map<String, dynamic>)['casos'] as List;
    });

    test('todos los casos coinciden con el algoritmo P5', () {
      const perfil = PerfilP5Compuesto();
      for (final caso in casos.cast<Map<String, dynamic>>()) {
        final nombre = caso['nombre'] as String;
        final mediciones = _medicionesDesdeJson(
          caso['mediciones'] as Map<String, dynamic>,
        );
        final pesos = _pesosDesdeJson(caso['pesos'] as Map<String, dynamic>);
        final esperado = caso['esperado'] as Map<String, dynamic>;

        final resultado = perfil.calcular(
          mediciones: mediciones,
          pesos: pesos,
        );

        expect(
          resultado.nivel.index,
          esperado['nivel'],
          reason: 'nivel — $nombre',
        );
        expect(
          resultado.scoreCompuesto,
          closeTo(esperado['score_compuesto'] as num, 1e-6),
          reason: 'score_compuesto — $nombre',
        );
        final scoresEsperados =
            esperado['scores'] as Map<String, dynamic>;
        for (final entrada in scoresEsperados.entries) {
          final componente = _componenteDesdeClave(entrada.key);
          expect(
            resultado.scoresNormalizados[componente],
            closeTo((entrada.value as num).toDouble(), 1e-6),
            reason: 'score normalizado de ${entrada.key} — $nombre',
          );
        }
      }
    });
  });
}

MedicionesP5 _medicionesDesdeJson(Map<String, dynamic> json) {
  final hist = json['historico'] as Map<String, dynamic>;
  return MedicionesP5(
    precision: (json['precision'] as num?)?.toDouble(),
    rubricaMedia: (json['rubrica_media'] as num?)?.toDouble(),
    coberturaContextosVistos: (json['cobertura_vistos'] as num?)?.toInt(),
    coberturaContextosEsperados:
        (json['cobertura_esperados'] as num?)?.toInt(),
    proxy: (json['proxy'] as num?)?.toDouble(),
    historico: HistoricoP5(
      sesiones: (hist['sesiones'] as num?)?.toInt() ?? 0,
      semanasDistintas: (hist['semanas_distintas'] as num?)?.toInt() ?? 0,
      estacionesDistintas: (hist['estaciones'] as num?)?.toInt() ?? 0,
      transferenciaConfirmada: (hist['transferencia'] as bool?) ?? false,
    ),
  );
}

PesosP5 _pesosDesdeJson(Map<String, dynamic> json) {
  return PesosP5({
    for (final entrada in json.entries)
      _componenteDesdeClave(entrada.key): (entrada.value as num).toDouble(),
  });
}

ComponenteP5 _componenteDesdeClave(String clave) {
  switch (clave) {
    case 'precision':
      return ComponenteP5.precision;
    case 'rubrica':
      return ComponenteP5.rubrica;
    case 'cobertura':
      return ComponenteP5.cobertura;
    case 'proxy':
      return ComponenteP5.proxy;
    default:
      throw ArgumentError('Componente P5 desconocido: $clave');
  }
}
