import 'voz_personaje.dart';

/// Un plano es la unidad atómica de una escena cinematográfica —
/// doc 13 principios §2.1 (planos duran, no se cortan cada segundo).
///
/// Tipos implementados en v0.1:
/// - [PlanoAmbiente]: silencio visual, auto-avanza tras [duracion].
/// - [PlanoDialogo]: frase de un personaje, el niño pulsa para avanzar
///   después del reveal letra-a-letra.
///
/// Planos pendientes: PlanoEleccion (opciones con flags), PlanoCambioFondo,
/// PlanoTransmisionObjeto (brújula, concha) — se añaden al aparecer escenas
/// que los requieran.
sealed class PlanoEscena {
  const PlanoEscena();
}

class PlanoAmbiente extends PlanoEscena {
  final Duration duracion;
  final String? textoLectura;

  const PlanoAmbiente({
    required this.duracion,
    this.textoLectura,
  });
}

class PlanoDialogo extends PlanoEscena {
  final VozPersonaje voz;
  final String texto;

  /// Pausa antes de empezar el reveal. Útil para respirar entre frases
  /// del mismo personaje — guía visual §2.4 (silencios visuales).
  final Duration pausaPrevia;

  const PlanoDialogo({
    required this.voz,
    required this.texto,
    this.pausaPrevia = Duration.zero,
  });
}
