// Re-export de los planos genéricos del core para que los call-sites
// del juego sigan importando un solo archivo. Los modelos genéricos
// (PlanoEscena, PlanoAmbiente, PlanoDialogo, PlanoEleccion,
// PlanoCierreAmable, OpcionEleccion) viven en el paquete
// nuevo_ser_core, submódulo narrative/.
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'voz_personaje.dart';

export 'package:nuevo_ser_core/nuevo_ser_core.dart' show
    OpcionEleccion,
    PlanoAmbiente,
    PlanoCierreAmable,
    PlanoDialogo,
    PlanoEleccion,
    PlanoEscena;

/// Acción del niño que desbloquea el avance en un PlanoInteractivo.
/// - [dividirPleno]: swipe horizontal parte el Pleno (valor 1) en dos
///   mitades de 1/2.
/// - [desfragmentarMitades]: tap sobre cada mitad la disuelve. Avanza
///   cuando las dos están disueltas.
enum AccionEsperada { dividirPleno, desfragmentarMitades }

/// Un plano donde el niño hace una acción concreta con un Fragmento en
/// pantalla para avanzar — el tutorial de la escena 1.2 §1.2 del doc 07.
/// Durante el plano se muestra una instrucción corta y un Pleno real.
///
/// Es el primer plano específico de Uno Roto que extiende la jerarquía
/// abstracta del core sin tocar plataforma — patrón canónico para
/// añadir planos por-juego (Las Versiones podrá añadir
/// `PlanoMesaTrabajo`, `PlanoConcilio`, etc. del mismo modo).
class PlanoInteractivo extends PlanoEscena {
  final VozPersonaje vozInstruccion;
  final String instruccion;
  final AccionEsperada accion;

  /// Estado inicial del Fragmento. Para [AccionEsperada.dividirPleno]
  /// debe ser `plenoCompleto`; para [AccionEsperada.desfragmentarMitades]
  /// debe ser `dosMitades` (el plano anterior ya lo dividió).
  final EstadoFragmentoTutorial estadoInicial;

  const PlanoInteractivo({
    required this.vozInstruccion,
    required this.instruccion,
    required this.accion,
    required this.estadoInicial,
  });
}

enum EstadoFragmentoTutorial {
  plenoCompleto,
  dosMitades,
  unaMitad,
  vacio,
}
