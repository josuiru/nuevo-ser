import 'fragmento.dart';

/// Quién habla en una línea de diálogo. Por defecto Sora (la mentora);
/// Kai (el rival) aparece puntualmente para interrumpir sesiones.
enum PersonajeDialogo { sora, kai }

/// Una línea de diálogo escrita para un momento narrativo.
///
/// Si [esperaPulsacion] es verdadero, el jugador debe tocar para avanzar;
/// si es falso, la línea aparece y el flujo continúa automáticamente.
class LineaDialogo {
  final String texto;
  final bool esperaPulsacion;
  final PersonajeDialogo personaje;

  const LineaDialogo(
    this.texto, {
    this.esperaPulsacion = true,
    this.personaje = PersonajeDialogo.sora,
  });

  bool get esSora => personaje == PersonajeDialogo.sora;
  bool get esKai => personaje == PersonajeDialogo.kai;
}

/// Un encuentro con un Fragmento dentro de una sesión.
///
/// Si [numerador] es 1, es un Fragmento unitario (Familia B): un único
/// combate. Si [numerador] > 1, es un Fragmento compuesto (Familia C):
/// el jugador debe resolver [numerador] sub-combates consecutivos del
/// mismo unitario 1/[denominador] hasta "descomponer" el compuesto
/// entero. Biblia §5.2 C.
class ContratoFragmento {
  final int numerador;
  final int denominador;
  final String contextoNarrativo;
  final LineaDialogo invocacion;

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

/// Un momento cinemático que interrumpe una sesión.
///
/// [antesDelContrato] indica el índice del contrato antes del cual
/// aparecen las [beats]. Por ejemplo, si `antesDelContrato=3`, las
/// líneas se muestran después de resolver el contrato 2 y antes de
/// invocar el 3.
class InterrupcionNarrativa {
  final int antesDelContrato;
  final List<LineaDialogo> beats;

  const InterrupcionNarrativa({
    required this.antesDelContrato,
    required this.beats,
  });
}

/// Una sesión completa: líneas de presentación, contratos, cierre y
/// opcionalmente interrupciones narrativas puntuales (la aparición
/// de un rival, por ejemplo).
class SesionNoche {
  final String tituloDiegetico;
  final List<LineaDialogo> lineasIntro;
  final List<ContratoFragmento> contratos;
  final List<LineaDialogo> lineasCierre;
  final List<InterrupcionNarrativa> interrupciones;

  const SesionNoche({
    required this.tituloDiegetico,
    required this.lineasIntro,
    required this.contratos,
    required this.lineasCierre,
    this.interrupciones = const [],
  });

  int get numeroCombates => contratos.length;

  InterrupcionNarrativa? interrupcionAntesDe(int indiceContrato) {
    for (final interrupcion in interrupciones) {
      if (interrupcion.antesDelContrato == indiceContrato) {
        return interrupcion;
      }
    }
    return null;
  }
}
