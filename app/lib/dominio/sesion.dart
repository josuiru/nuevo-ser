import 'fragmento.dart';

/// Una línea de diálogo escrita para un momento narrativo.
///
/// Si [esperaPulsacion] es verdadero, el jugador debe tocar para avanzar;
/// si es falso, la línea aparece y el flujo continúa automáticamente
/// (por ejemplo, una felicitación tras un combate).
class LineaSora {
  final String texto;
  final bool esperaPulsacion;

  const LineaSora(this.texto, {this.esperaPulsacion = true});
}

/// Un encuentro con un Fragmento dentro de una sesión.
///
/// Si [numerador] es 1, es un Fragmento unitario (Familia B): un único
/// combate. Si [numerador] > 1, es un Fragmento compuesto (Familia C):
/// el jugador debe resolver [numerador] sub-combates consecutivos del
/// mismo unitario 1/[denominador] hasta "descomponer" el compuesto
/// entero. Biblia §5.2 C: "una fracción no unitaria es una suma de
/// unitarias; el niño lo vive físicamente".
class ContratoFragmento {
  final int numerador;
  final int denominador;
  final String contextoNarrativo;
  final LineaSora invocacion;

  const ContratoFragmento({
    this.numerador = 1,
    required this.denominador,
    required this.contextoNarrativo,
    required this.invocacion,
  }) : assert(numerador >= 1 && numerador < denominador);

  bool get esCompuesto => numerador > 1;

  String get etiquetaCompuesto => '$numerador/$denominador';

  FragmentoUnitario aFragmentoUnitario() => FragmentoUnitario(denominador);
}

/// Una sesión completa: líneas de presentación de Sora, varios contratos
/// de Fragmento, y líneas de cierre.
class SesionNoche {
  final String tituloDiegetico;
  final List<LineaSora> lineasIntro;
  final List<ContratoFragmento> contratos;
  final List<LineaSora> lineasCierre;

  const SesionNoche({
    required this.tituloDiegetico,
    required this.lineasIntro,
    required this.contratos,
    required this.lineasCierre,
  });

  int get numeroCombates => contratos.length;
}
