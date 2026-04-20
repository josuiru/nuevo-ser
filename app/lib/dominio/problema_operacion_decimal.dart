import 'dart:math' as math;

import 'fragmento_en_tejado.dart'
    show OperadorAritmetico, SimboloOperador;

/// Una operación aritmética con decimales pequeños y limpios (0,25,
/// 0,5, 1,5...). El resultado siempre es un decimal con a lo sumo dos
/// cifras significativas tras la coma.
class ProblemaOperacionDecimal {
  final String etiquetaA;
  final String etiquetaB;
  final OperadorAritmetico operador;
  final List<String> candidatos;
  final int indiceCorrecto;

  const ProblemaOperacionDecimal({
    required this.etiquetaA,
    required this.etiquetaB,
    required this.operador,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  String get etiqueta => '$etiquetaA ${operador.simbolo} $etiquetaB';
}

class GeneradorOperacionDecimal {
  final math.Random _azar;

  GeneradorOperacionDecimal({int? semilla}) : _azar = math.Random(semilla);

  /// Tuplas de (operando A, operando B, operador) preseleccionadas para
  /// que los resultados sean decimales limpios. Mantener esta lista
  /// curada evita problemas de redondeo y hace que las operaciones
  /// "canten" cuando el niño las interioriza.
  static final List<_CasoDecimal> _casos = [
    // Sumas y restas sencillas.
    _CasoDecimal(0.5, 0.3, OperadorAritmetico.suma),
    _CasoDecimal(0.25, 0.75, OperadorAritmetico.suma),
    _CasoDecimal(0.1, 0.9, OperadorAritmetico.suma),
    _CasoDecimal(1.2, 0.8, OperadorAritmetico.suma),
    _CasoDecimal(0.6, 0.3, OperadorAritmetico.suma),
    _CasoDecimal(1.5, 2.5, OperadorAritmetico.suma),
    _CasoDecimal(0.8, 0.3, OperadorAritmetico.resta),
    _CasoDecimal(1.0, 0.25, OperadorAritmetico.resta),
    _CasoDecimal(2.5, 1.2, OperadorAritmetico.resta),
    _CasoDecimal(0.75, 0.25, OperadorAritmetico.resta),
    _CasoDecimal(1.5, 0.3, OperadorAritmetico.resta),
    // Productos con decimales con 1 cifra.
    _CasoDecimal(0.5, 0.4, OperadorAritmetico.producto),
    _CasoDecimal(0.3, 0.6, OperadorAritmetico.producto),
    _CasoDecimal(0.2, 0.5, OperadorAritmetico.producto),
    _CasoDecimal(1.5, 0.2, OperadorAritmetico.producto),
    _CasoDecimal(2.5, 0.4, OperadorAritmetico.producto),
    _CasoDecimal(0.25, 4, OperadorAritmetico.producto),
    // Divisiones con resultado decimal limpio.
    _CasoDecimal(1.5, 3, OperadorAritmetico.division),
    _CasoDecimal(2.4, 2, OperadorAritmetico.division),
    _CasoDecimal(4.5, 5, OperadorAritmetico.division),
    _CasoDecimal(0.8, 4, OperadorAritmetico.division),
    _CasoDecimal(1.2, 0.4, OperadorAritmetico.division),
    _CasoDecimal(2.0, 0.5, OperadorAritmetico.division),
  ];

  ProblemaOperacionDecimal generar() {
    final caso = _casos[_azar.nextInt(_casos.length)];
    return _construirProblema(caso);
  }

  ProblemaOperacionDecimal generarDesde({
    required String etiquetaA,
    required String etiquetaB,
    required OperadorAritmetico operador,
  }) {
    final valorA = _parsearDecimal(etiquetaA);
    final valorB = _parsearDecimal(etiquetaB);
    return _construirProblema(_CasoDecimal(valorA, valorB, operador));
  }

  ProblemaOperacionDecimal _construirProblema(_CasoDecimal caso) {
    final resultado = _aplicar(caso.a, caso.b, caso.operador);
    final etiquetaCorrecta = _formatearDecimal(resultado);

    final distractoresCandidatos = <String>{};
    // Generamos distractores modificando el resultado con perturbaciones
    // pequeñas y con errores típicos según operador.
    distractoresCandidatos
        .add(_formatearDecimal(_error(caso, _ErrorTipico.cambioOperador)));
    distractoresCandidatos
        .add(_formatearDecimal(_error(caso, _ErrorTipico.comaDesplazada)));
    distractoresCandidatos
        .add(_formatearDecimal(_error(caso, _ErrorTipico.sumaIngenua)));
    distractoresCandidatos.remove(etiquetaCorrecta);

    final distractores = distractoresCandidatos.take(3).toList();
    while (distractores.length < 3) {
      final perturbacion = resultado +
          (0.1 * (_azar.nextInt(5) - 2)) *
              (_azar.nextBool() ? 1 : -1);
      final etiqueta = _formatearDecimal(perturbacion.abs());
      if (etiqueta == etiquetaCorrecta) continue;
      if (distractores.contains(etiqueta)) continue;
      distractores.add(etiqueta);
    }

    final candidatos = <String>[etiquetaCorrecta, ...distractores];
    candidatos.shuffle(_azar);
    final indiceCorrecto = candidatos.indexOf(etiquetaCorrecta);

    return ProblemaOperacionDecimal(
      etiquetaA: _formatearDecimal(caso.a),
      etiquetaB: _formatearDecimal(caso.b),
      operador: caso.operador,
      candidatos: candidatos,
      indiceCorrecto: indiceCorrecto,
    );
  }

  double _aplicar(double a, double b, OperadorAritmetico operador) {
    switch (operador) {
      case OperadorAritmetico.suma:
        return a + b;
      case OperadorAritmetico.resta:
        return a - b;
      case OperadorAritmetico.producto:
        return a * b;
      case OperadorAritmetico.division:
        return a / b;
    }
  }

  double _error(_CasoDecimal caso, _ErrorTipico tipo) {
    switch (tipo) {
      case _ErrorTipico.cambioOperador:
        final operadorAlternativo = caso.operador == OperadorAritmetico.suma
            ? OperadorAritmetico.resta
            : caso.operador == OperadorAritmetico.resta
                ? OperadorAritmetico.suma
                : caso.operador == OperadorAritmetico.producto
                    ? OperadorAritmetico.suma
                    : OperadorAritmetico.producto;
        return _aplicar(caso.a, caso.b, operadorAlternativo).abs();
      case _ErrorTipico.comaDesplazada:
        final correcto = _aplicar(caso.a, caso.b, caso.operador);
        return correcto * 10;
      case _ErrorTipico.sumaIngenua:
        return (caso.a + caso.b).abs();
    }
  }

  double _parsearDecimal(String etiqueta) {
    return double.parse(etiqueta.replaceAll(',', '.'));
  }

  /// Formatea un decimal en formato español (coma), eliminando ceros
  /// finales inútiles (1,50 → 1,5) y mostrando entero sin coma (2,0 → 2).
  String _formatearDecimal(double valor) {
    if (valor.isNaN || valor.isInfinite) return '0';
    final absoluto = valor.abs();
    // Redondeamos a 3 decimales para evitar ruido tipo 0.30000000000001.
    final redondeado = (absoluto * 1000).round() / 1000;
    String texto = redondeado.toStringAsFixed(3);
    // Eliminar ceros finales tras la coma.
    while (texto.endsWith('0')) {
      texto = texto.substring(0, texto.length - 1);
    }
    if (texto.endsWith('.')) texto = texto.substring(0, texto.length - 1);
    final conSigno = valor < 0 ? '-$texto' : texto;
    return conSigno.replaceAll('.', ',');
  }
}

class _CasoDecimal {
  final double a;
  final double b;
  final OperadorAritmetico operador;

  const _CasoDecimal(this.a, this.b, this.operador);
}

enum _ErrorTipico { cambioOperador, comaDesplazada, sumaIngenua }
