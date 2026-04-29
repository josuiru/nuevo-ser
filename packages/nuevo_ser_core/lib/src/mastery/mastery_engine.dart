import 'habilidad.dart';
import 'mastery_profile.dart';
import 'perfiles/p1_precision.dart';
import 'perfiles/p2_detection.dart';
import 'perfiles/p3_construction.dart';
import 'perfiles/p4_calibration.dart';

/// Identificador del perfil P1, único soportado en producción hoy.
/// Las constantes están aquí (no en `MasteryProfile`) para que
/// llamantes que solo necesitan P1 no importen las cuatro clases.
const String idPerfilP1 = 'P1';
const String idPerfilP2 = 'P2';
const String idPerfilP3 = 'P3';
const String idPerfilP4 = 'P4';

/// Dispatcher del motor adaptativo (doc §6.1).
///
/// Recibe el estado previo + el intento nuevo + el id del perfil y
/// devuelve el `EstadoHabilidad` actualizado. Es puro (no toca tiempo
/// real ni almacenamiento) — la persistencia y los efectos secundarios
/// (callbacks de "subió de nivel") son responsabilidad del facade que
/// envuelve este motor en cada juego.
///
/// La lista de perfiles es inyectable para tests y para que un juego
/// pueda registrar perfiles propios (p. ej. un P5 experimental).
class MasteryEngine {
  final Map<String, MasteryProfile> _perfiles;

  MasteryEngine({Map<String, MasteryProfile>? perfiles})
      : _perfiles = perfiles ?? const {
          idPerfilP1: P1Precision(),
          idPerfilP2: P2Detection(),
          idPerfilP3: P3Construction(),
          idPerfilP4: P4Calibration(),
        };

  /// Devuelve el perfil registrado con `id`. Lanza `ArgumentError` si no
  /// existe; nunca devuelve null para forzar a quien cablee mal el id
  /// del perfil a verlo en el primer intento.
  MasteryProfile perfil(String id) {
    final perfil = _perfiles[id];
    if (perfil == null) {
      throw ArgumentError(
        'Perfil de medición desconocido: "$id". '
        'Perfiles registrados: ${_perfiles.keys.join(", ")}.',
      );
    }
    return perfil;
  }

  /// Aplica un intento nuevo sobre el estado previo y devuelve el
  /// estado actualizado. Versión funcional pura: no persiste, no
  /// notifica subidas de nivel, no consulta el reloj.
  EstadoHabilidad actualizarMaestria({
    required EstadoHabilidad previo,
    required SessionPayload payload,
    String idPerfil = idPerfilP1,
    ProfileConfig config = ProfileConfig.defaultP1,
  }) {
    final perfilUsado = perfil(idPerfil);
    final score = perfilUsado.compute(
      payload: payload,
      previo: previo,
      config: config,
    );
    final nivel = perfilUsado.levelFromScore(
      score: score,
      config: config,
      nivelPrevio: previo.nivel,
    );
    return previo.copiarCon(
      nivel: nivel,
      precision: score.precision,
      tiempoMedianoSeg: score.tiempoMedianoSeg,
      ultimaPractica: payload.instante,
      sesionesConsecutivasBuenas: score.sesionesConsecutivasBuenas,
      totalExposiciones: score.totalExposiciones,
      intentosRecientes: score.intentosRecientes,
    );
  }
}
