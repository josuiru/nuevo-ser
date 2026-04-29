import 'dart:math' as math;

/// Banco de líneas pre-escritas de Sora. Respeta biblia personajes §3.6:
/// frases cortas (6-12 palabras), "bien" como máxima felicitación,
/// sin efusividad, sin emoticonos verbales.
class DialogosSora {
  DialogosSora._();

  static const String bienvenida =
      'Ese Fragmento se come las luces del callejón. Pártelo.';

  static const Map<int, String> instruccionPorDenominador = {
    2: 'En dos mitades iguales. Despacio.',
    3: 'En tres. Tres partes del mismo tamaño.',
    4: 'En cuatro. Ojo con el centro.',
    5: 'En cinco. Este te va a hacer pensar.',
  };

  static const List<String> felicitaciones = [
    'Bien.',
    'Bien hecho.',
    'Sigue así.',
    'Así.',
  ];

  static const List<String> animosTrasFallo = [
    'No pasa nada. Otra vez.',
    'Respira.',
    'Deshaz y prueba.',
    'Lo estás pensando tú, no yo. Mira al Fragmento.',
  ];

  /// Devuelve una línea de felicitación rotando por las disponibles según
  /// el índice (victorias acumuladas). Garantiza variedad sin azar.
  static String felicitacionPara(int victoriasAcumuladas) {
    final indice = victoriasAcumuladas % felicitaciones.length;
    return felicitaciones[indice];
  }

  static String animoTrasFallo(int fallosAcumulados) {
    final indice = fallosAcumulados % animosTrasFallo.length;
    return animosTrasFallo[indice];
  }

  /// Inicio de combate: si es el primer Fragmento absoluto, da la
  /// bienvenida; si no, da la instrucción del denominador.
  static String inicioCombate({
    required int denominador,
    required bool esPrimerCombate,
  }) {
    if (esPrimerCombate) return bienvenida;
    return instruccionPorDenominador[denominador] ??
        'Parte este también.';
  }

  static final math.Random _azar = math.Random();
  static int _ultimoIndiceAleatorio = -1;

  /// Útil cuando se quiere un poco de variedad orgánica sin repetir la
  /// misma línea dos veces seguidas.
  static String variarSinRepetir(List<String> opciones) {
    if (opciones.length <= 1) return opciones.first;
    int candidato;
    do {
      candidato = _azar.nextInt(opciones.length);
    } while (candidato == _ultimoIndiceAleatorio);
    _ultimoIndiceAleatorio = candidato;
    return opciones[candidato];
  }
}
