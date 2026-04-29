import 'dart:math' as math;

import 'problema_espejo.dart';

/// Par (etiqueta decimal, fracción equivalente) usado para generar
/// problemas y para decorar Fragmentos decimales en el tejado.
class DecimalConocido {
  final String etiqueta;
  final Fraccion fraccionEquivalente;

  const DecimalConocido(this.etiqueta, this.fraccionEquivalente);
}

/// Decimales "amigables" que tienen una representación fraccionaria
/// exacta y común. Se presentan al jugador como etiqueta del Fragmento.
const List<DecimalConocido> decimalesConocidos = [
  DecimalConocido('0,5', Fraccion(1, 2)),
  DecimalConocido('0,25', Fraccion(1, 4)),
  DecimalConocido('0,75', Fraccion(3, 4)),
  DecimalConocido('0,2', Fraccion(1, 5)),
  DecimalConocido('0,4', Fraccion(2, 5)),
  DecimalConocido('0,6', Fraccion(3, 5)),
  DecimalConocido('0,8', Fraccion(4, 5)),
  DecimalConocido('0,1', Fraccion(1, 10)),
  DecimalConocido('0,3', Fraccion(3, 10)),
  DecimalConocido('0,7', Fraccion(7, 10)),
  DecimalConocido('0,125', Fraccion(1, 8)),
  DecimalConocido('0,375', Fraccion(3, 8)),
  DecimalConocido('0,625', Fraccion(5, 8)),
];

/// Problema DEC.08: el niño ve una fracción y elige el decimal
/// equivalente entre cuatro candidatos. Mecánica de conversión
/// fracción → decimal (la habilidad real, no la inversa que tenía
/// el puzzle anterior).
class ProblemaDecimal {
  final Fraccion fraccionMostrada;
  final List<String> candidatos;
  final int indiceCorrecto;

  const ProblemaDecimal({
    required this.fraccionMostrada,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  String get etiquetaCorrecta => candidatos[indiceCorrecto];
}

class GeneradorDecimal {
  final math.Random _azar;

  GeneradorDecimal({int? semilla}) : _azar = math.Random(semilla);

  /// Elige uno de los decimales conocidos al azar y construye un
  /// problema con cuatro candidatos (uno correcto, tres distractores
  /// seleccionados de otros decimales conocidos para que los valores
  /// sean plausibles).
  ProblemaDecimal generar() {
    final correcto =
        decimalesConocidos[_azar.nextInt(decimalesConocidos.length)];
    return _problemaDesde(correcto);
  }

  /// Cuando el Fragmento en el tejado ya definió qué decimal muestra
  /// (su etiqueta visible), generamos el problema anclado a la
  /// fracción equivalente para que el niño vea siempre la misma
  /// fracción que va a resolver.
  ProblemaDecimal generarDesde(DecimalConocido decimalObjetivo) {
    return _problemaDesde(decimalObjetivo);
  }

  ProblemaDecimal _problemaDesde(DecimalConocido correcto) {
    final distractores = <String>[];
    final vistos = <String>{correcto.etiqueta};

    while (distractores.length < 3) {
      final candidato =
          decimalesConocidos[_azar.nextInt(decimalesConocidos.length)]
              .etiqueta;
      if (vistos.contains(candidato)) continue;
      vistos.add(candidato);
      distractores.add(candidato);
    }

    final candidatos = [correcto.etiqueta, ...distractores]..shuffle(_azar);
    final indiceCorrecto = candidatos.indexOf(correcto.etiqueta);

    return ProblemaDecimal(
      fraccionMostrada: correcto.fraccionEquivalente,
      candidatos: candidatos,
      indiceCorrecto: indiceCorrecto,
    );
  }
}
