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

/// Un encuentro con un Fragmento dentro de una sesión: qué denominador,
/// qué se está comiendo en el mundo, y cómo lo invoca Sora.
class ContratoFragmento {
  final int denominador;
  final String contextoNarrativo;
  final LineaSora invocacion;

  const ContratoFragmento({
    required this.denominador,
    required this.contextoNarrativo,
    required this.invocacion,
  });

  FragmentoUnitario aFragmento() => FragmentoUnitario(denominador);
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
