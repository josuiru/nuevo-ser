import 'dart:math' as math;

/// Problema DEC.09: el niño ve un decimal con dos cifras decimales
/// (p. ej. "2,37") y elige su redondeo a la décima entre cuatro
/// candidatos. Para 2,37 el correcto es 2,4 (centésima ≥ 5 → sube).
class ProblemaRedondeoDecimal {
  final String etiquetaOriginal;
  final List<String> candidatos;
  final int indiceCorrecto;

  const ProblemaRedondeoDecimal({
    required this.etiquetaOriginal,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  String get etiquetaCorrecta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Redondea el decimal "e,cc" a la décima. Devuelve la cadena con
/// formato "e,d" (sin centésimas) — propaga si la décima era 9.
String _redondearADecima({
  required int entero,
  required int decima,
  required int centesima,
}) {
  if (centesima < 5) return '$entero,$decima';
  if (decima < 9) return '$entero,${decima + 1}';
  // Décima 9 + redondeo arriba → entero+1, décima 0.
  return '${entero + 1},0';
}

/// Trampas del niño al redondear:
/// - Truncar (cortar la centésima sin mirar): 2,37 → 2,3.
/// - Redondear pero dejar la centésima escrita: 2,37 → 2,40.
/// - Truncar y rellenar con cero: 2,37 → 2,30.
/// - Redondear de más cuando no hace falta: 2,32 → 2,4.
class GeneradorRedondeoDecimal {
  final math.Random _azar;

  GeneradorRedondeoDecimal({int? semilla}) : _azar = math.Random(semilla);

  /// Genera un problema. La centésima cae en zona de duda (3..7) en
  /// al menos el 50 % de los casos para que la respuesta no sea obvia.
  ProblemaRedondeoDecimal generar({int dificultad = 1}) {
    final maxEntero = switch (dificultad) {
      1 => 3,
      2 => 9,
      _ => 99,
    };
    final permitirPropagacion = dificultad >= 2;

    int entero;
    int decima;
    int centesima;
    do {
      entero = _azar.nextInt(maxEntero + 1);
      // Zona de duda con probabilidad 0,55: centésimas en {3..7}.
      if (_azar.nextDouble() < 0.55) {
        centesima = 3 + _azar.nextInt(5);
      } else {
        centesima = _azar.nextInt(10);
      }
      decima = _azar.nextInt(10);
    } while (!permitirPropagacion && centesima >= 5 && decima == 9);

    final etiquetaOriginal =
        '$entero,${decima.toString().padLeft(1, '0')}'
        '${centesima.toString().padLeft(1, '0')}';

    return generarDesdeEtiqueta(etiquetaOriginal);
  }

  /// Reproduce un problema concreto a partir de la etiqueta original.
  /// Se usa cuando el cazador ya generó la cifra y queremos consistencia
  /// al abrir el Fragmento.
  ProblemaRedondeoDecimal generarDesdeEtiqueta(String etiquetaOriginal) {
    final partes = etiquetaOriginal.split(',');
    final entero = int.parse(partes[0]);
    final decimales = partes[1].padRight(2, '0');
    final decima = int.parse(decimales[0]);
    final centesima = int.parse(decimales[1]);

    final correcta = _redondearADecima(
      entero: entero,
      decima: decima,
      centesima: centesima,
    );

    final candidatos = <String>[correcta];
    void anyadirSiNuevo(String s) {
      if (!candidatos.contains(s)) candidatos.add(s);
    }

    // Truncar.
    anyadirSiNuevo('$entero,$decima');
    // Redondear pero dejando la centésima — aparece como 2,40.
    if (centesima >= 5) {
      final decimaSubida = decima < 9 ? decima + 1 : 0;
      final enteroSubido = decima < 9 ? entero : entero + 1;
      anyadirSiNuevo('$enteroSubido,${decimaSubida}0');
    } else {
      anyadirSiNuevo('$entero,${decima}0');
    }
    // Truncar y rellenar con cero.
    anyadirSiNuevo('$entero,${decima}0');
    // Redondear de más (subir aunque la centésima fuera < 5).
    if (centesima < 5) {
      final decimaForzada = decima < 9 ? decima + 1 : 0;
      final enteroForzado = decima < 9 ? entero : entero + 1;
      anyadirSiNuevo('$enteroForzado,$decimaForzada');
    }

    // Si tras todas las trampas seguimos por debajo de 4 candidatos,
    // metemos vecinos ±0,1 razonables.
    var paso = 1;
    while (candidatos.length < 4) {
      final vecinoArriba = '$entero,${(decima + paso) % 10}';
      anyadirSiNuevo(vecinoArriba);
      if (candidatos.length < 4 && decima - paso >= 0) {
        anyadirSiNuevo('$entero,${decima - paso}');
      }
      paso++;
      if (paso > 9) break; // salvaguarda: nunca debería entrar aquí
    }

    final cuatro = candidatos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcta);
    return ProblemaRedondeoDecimal(
      etiquetaOriginal: etiquetaOriginal,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
