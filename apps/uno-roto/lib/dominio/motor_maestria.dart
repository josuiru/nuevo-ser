import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../datos/catalogo_habilidades.dart';

/// Facade del motor de maestría para Uno Roto.
///
/// Tras el Chunk 6 del refactor, la lógica de cálculo vive en
/// `MasteryEngine` (`packages/nuevo_ser_core/lib/src/mastery/`). Esta
/// clase la envuelve para añadir lo específico del juego:
///
/// - Persistencia local vía callbacks `cargarEstado`/`guardarEstado`
///   (Uno Roto usa `RepositorioProgreso` con `shared_preferences`).
/// - Notificación `alSubirNivel` cuando el nivel sube de forma
///   estricta — el orquestador la engancha al estado narrativo para
///   activar flags como `fr_05_competente`.
/// - Reglas de decaimiento del catálogo concreto (las "21d/14d" están
///   en `assets/data/skills.json`).
/// - Convención de flags `flagDeMaestria(...)`.
///
/// El cálculo agregado en sí (precisión ponderada, sesiones
/// consecutivas, mapeo a nivel) no vive aquí: lo aporta el perfil
/// `P1Precision` de la plataforma. La paridad bit a bit con la versión
/// pre-refactor está cubierta por `test/motor_maestria_test.dart`.
class MotorMaestria {
  MotorMaestria({
    required this.catalogo,
    required this.cargarEstado,
    required this.guardarEstado,
    this.alSubirNivel,
    MasteryEngine? motor,
  }) : _motor = motor ?? MasteryEngine();

  final CatalogoHabilidades catalogo;

  /// Lee el estado de una habilidad desde el almacén. Devuelve null si
  /// no existe todavía (la habilidad no se ha practicado nunca).
  final Future<EstadoHabilidad?> Function(String idHabilidad) cargarEstado;

  /// Persiste el estado actualizado.
  final Future<void> Function(EstadoHabilidad estado) guardarEstado;

  /// Notificación cada vez que una habilidad sube de nivel (estricto:
  /// nuevo > previo). Sirve para conectar progreso pedagógico con flags
  /// narrativos — el catálogo de escenas reacciona a esos flags.
  final void Function(String idHabilidad, NivelMaestria nuevoNivel)?
      alSubirNivel;

  final MasteryEngine _motor;

  /// Registra el resultado de un ejercicio para una habilidad y
  /// devuelve el [EstadoHabilidad] actualizado. Delega el cómputo al
  /// `MasteryEngine` con el perfil P1 (único soportado por las 66
  /// habilidades de Uno Roto).
  Future<EstadoHabilidad> registrarResultado({
    required String idHabilidad,
    required bool acierto,
    required double dificultad,
    required int duracionSegundos,
    DateTime? ahora,
  }) async {
    final ahoraEfectivo = ahora ?? DateTime.now();
    final estadoPrevio = (await cargarEstado(idHabilidad)) ??
        EstadoHabilidad.inicial(idHabilidad);

    final payload = SessionPayload(
      acierto: acierto,
      dificultad: dificultad,
      duracionSegundos: duracionSegundos,
      instante: ahoraEfectivo,
    );

    final estadoNuevo = _motor.actualizarMaestria(
      previo: estadoPrevio,
      payload: payload,
    );

    await guardarEstado(estadoNuevo);
    if (estadoNuevo.nivel.valor > estadoPrevio.nivel.valor) {
      alSubirNivel?.call(idHabilidad, estadoNuevo.nivel);
    }
    return estadoNuevo;
  }

  /// Convención estable de flags narrativos derivados de un nivel de
  /// maestría: `<id_habilidad_normalizado>_<nivel>`. Por ejemplo,
  /// FR.05 + competente → "fr_05_competente". Usado por el catálogo de
  /// escenas para gating narrativo.
  static String flagDeMaestria(String idHabilidad, NivelMaestria nivel) {
    final idNormalizado = idHabilidad.toLowerCase().replaceAll('.', '_');
    return '${idNormalizado}_${_sufijoNivel(nivel)}';
  }

  static String _sufijoNivel(NivelMaestria nivel) {
    switch (nivel) {
      case NivelMaestria.inexplorada:
        return 'inexplorada';
      case NivelMaestria.introducida:
        return 'introducida';
      case NivelMaestria.enDesarrollo:
        return 'en_desarrollo';
      case NivelMaestria.competente:
        return 'competente';
      case NivelMaestria.maestria:
        return 'maestria';
    }
  }

  /// Aplica decaimiento a un estado según el tiempo transcurrido.
  /// No baja del nivel suelo definido por el catálogo.
  ///
  /// Vive en la facade (no en `MasteryEngine`) porque las reglas de
  /// decaimiento son del juego concreto: vienen de `assets/data/
  /// skills.json` y pueden ser distintas en Las Versiones.
  EstadoHabilidad aplicarDecaimiento(
    EstadoHabilidad estado, {
    DateTime? ahora,
  }) {
    final ahoraEfectivo = ahora ?? DateTime.now();
    if (estado.nivel == NivelMaestria.inexplorada) return estado;
    final dias = ahoraEfectivo.difference(estado.ultimaPractica).inDays;
    final reglas = catalogo.reglasDecaimiento;

    var nivel = estado.nivel;
    if (nivel == NivelMaestria.maestria &&
        dias > reglas.diasMaestriaACompetente) {
      nivel = NivelMaestria.competente;
    }
    if (nivel == NivelMaestria.competente &&
        dias > reglas.diasCompetenteAEnDesarrollo) {
      nivel = NivelMaestria.enDesarrollo;
    }
    final suelo = NivelMaestriaEntero.desdeValor(reglas.nivelSuelo);
    if (nivel.valor < suelo.valor && estado.totalExposiciones > 0) {
      nivel = suelo;
    }
    return nivel == estado.nivel ? estado : estado.copiarCon(nivel: nivel);
  }
}
