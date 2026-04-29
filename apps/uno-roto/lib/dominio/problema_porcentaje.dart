import 'dart:math' as math;

import 'problema_espejo.dart';

/// Par (etiqueta porcentaje, fracción equivalente). El Mercado (biblia
/// §3.3) intercambia porcentajes literales por bienes — aquí los usamos
/// para enseñar la conversión.
class PorcentajeConocido {
  final String etiqueta;
  final Fraccion fraccionEquivalente;

  const PorcentajeConocido(this.etiqueta, this.fraccionEquivalente);
}

const List<PorcentajeConocido> porcentajesConocidos = [
  PorcentajeConocido('10%', Fraccion(1, 10)),
  PorcentajeConocido('20%', Fraccion(1, 5)),
  PorcentajeConocido('25%', Fraccion(1, 4)),
  PorcentajeConocido('30%', Fraccion(3, 10)),
  PorcentajeConocido('40%', Fraccion(2, 5)),
  PorcentajeConocido('50%', Fraccion(1, 2)),
  PorcentajeConocido('60%', Fraccion(3, 5)),
  PorcentajeConocido('70%', Fraccion(7, 10)),
  PorcentajeConocido('75%', Fraccion(3, 4)),
  PorcentajeConocido('80%', Fraccion(4, 5)),
  PorcentajeConocido('90%', Fraccion(9, 10)),
];

class ProblemaPorcentaje {
  final String etiquetaPorcentaje;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaPorcentaje({
    required this.etiquetaPorcentaje,
    required this.candidatos,
    required this.indiceCorrecto,
  });
}

class GeneradorPorcentaje {
  final math.Random _azar;

  GeneradorPorcentaje({int? semilla}) : _azar = math.Random(semilla);

  ProblemaPorcentaje generar() {
    final correcto = porcentajesConocidos[
        _azar.nextInt(porcentajesConocidos.length)];
    return _problemaDesde(correcto);
  }

  ProblemaPorcentaje generarDesde(PorcentajeConocido objetivo) {
    return _problemaDesde(objetivo);
  }

  ProblemaPorcentaje _problemaDesde(PorcentajeConocido correcto) {
    final distractores = <Fraccion>[];
    final vistos = <String>{correcto.fraccionEquivalente.etiqueta};

    while (distractores.length < 3) {
      final candidato = porcentajesConocidos[
              _azar.nextInt(porcentajesConocidos.length)]
          .fraccionEquivalente;
      if (vistos.contains(candidato.etiqueta)) continue;
      if (candidato.esEquivalenteA(correcto.fraccionEquivalente)) continue;
      vistos.add(candidato.etiqueta);
      distractores.add(candidato);
    }

    final candidatos = [correcto.fraccionEquivalente, ...distractores];
    candidatos.shuffle(_azar);
    final indiceCorrecto = candidatos.indexWhere(
      (c) => c.numerador == correcto.fraccionEquivalente.numerador &&
          c.denominador == correcto.fraccionEquivalente.denominador,
    );

    return ProblemaPorcentaje(
      etiquetaPorcentaje: correcto.etiqueta,
      candidatos: candidatos,
      indiceCorrecto: indiceCorrecto,
    );
  }
}
