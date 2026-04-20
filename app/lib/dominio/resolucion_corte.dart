import 'dart:math' as math;

import 'fragmento.dart';

/// Resultado de evaluar un intento de corte contra un Fragmento.
enum EstadoIntento {
  pendiente,
  exito,
  faltanTrazos,
  sobranTrazos,
  distribucionIrregular,
}

class ResultadoIntento {
  final EstadoIntento estado;
  final double puntuacionDistribucion;
  final String mensajeAmable;

  const ResultadoIntento({
    required this.estado,
    required this.puntuacionDistribucion,
    required this.mensajeAmable,
  });

  bool get esExito => estado == EstadoIntento.exito;
}

/// Evalúa una lista de radios trazados por el jugador contra el Fragmento
/// objetivo. Tolerante: el objetivo es validar el ADN del gesto, no exigir
/// precisión de décimo de grado.
///
/// El criterio de éxito es doble:
///   1. El número de radios debe coincidir con [fragmento.radiosRequeridos].
///   2. Los radios, una vez ordenados por ángulo, deben estar separados de
///      forma aproximadamente uniforme (el Fragmento queda dividido en
///      partes iguales), con una tolerancia [toleranciaGradosPorSector].
class EvaluadorCorte {
  final double toleranciaGradosPorSector;

  const EvaluadorCorte({this.toleranciaGradosPorSector = 12});

  ResultadoIntento evaluar({
    required FragmentoUnitario fragmento,
    required List<RadioTrazado> radios,
  }) {
    final cantidadTrazada = radios.length;
    final cantidadObjetivo = fragmento.radiosRequeridos;

    if (cantidadTrazada < cantidadObjetivo) {
      return ResultadoIntento(
        estado: EstadoIntento.faltanTrazos,
        puntuacionDistribucion: 0,
        mensajeAmable:
            'Te faltan ${cantidadObjetivo - cantidadTrazada} trazo(s). Prueba otra vez.',
      );
    }
    if (cantidadTrazada > cantidadObjetivo) {
      return ResultadoIntento(
        estado: EstadoIntento.sobranTrazos,
        puntuacionDistribucion: 0,
        mensajeAmable:
            'Te has pasado con $cantidadTrazada trazo(s). Necesitas $cantidadObjetivo.',
      );
    }

    final angulosOrdenados = radios
        .map((r) => r.anguloNormalizado)
        .toList()
      ..sort();

    final separacionesRad = <double>[];
    for (var indice = 0; indice < cantidadTrazada; indice++) {
      final siguiente = angulosOrdenados[(indice + 1) % cantidadTrazada];
      final actual = angulosOrdenados[indice];
      var diferencia = siguiente - actual;
      if (indice == cantidadTrazada - 1) {
        diferencia += 2 * math.pi;
      }
      separacionesRad.add(diferencia);
    }

    final separacionEsperadaRad = fragmento.anguloEsperadoEntreCortes;
    final toleranciaRad = toleranciaGradosPorSector * math.pi / 180;

    var maximoErrorRad = 0.0;
    for (final separacion in separacionesRad) {
      final error = (separacion - separacionEsperadaRad).abs();
      if (error > maximoErrorRad) maximoErrorRad = error;
    }

    final puntuacion = (1 - (maximoErrorRad / toleranciaRad)).clamp(0.0, 1.0);

    if (maximoErrorRad <= toleranciaRad) {
      return ResultadoIntento(
        estado: EstadoIntento.exito,
        puntuacionDistribucion: puntuacion,
        mensajeAmable: _mensajeExito(puntuacion),
      );
    }

    return ResultadoIntento(
      estado: EstadoIntento.distribucionIrregular,
      puntuacionDistribucion: puntuacion,
      mensajeAmable:
          'Las partes no han quedado iguales. Respira y prueba otra vez.',
    );
  }

  String _mensajeExito(double puntuacion) {
    if (puntuacion > 0.9) return 'Muy bien.';
    if (puntuacion > 0.7) return 'Bien.';
    return 'Lo has conseguido.';
  }
}
