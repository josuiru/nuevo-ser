import '../datos/catalogo_habilidades.dart';
import 'habilidad.dart';

/// Motor de maestría mínimo.
///
/// Implementa lo esencial del modelo descrito en `docs/02 §16` y
/// `docs/03 §8`: recibe resultados de ejercicios, recalcula precisión
/// ponderada, tiempo mediano y nivel de maestría. Aplica decaimiento
/// por días sin práctica. Usa almacenamiento en memoria; la capa de
/// persistencia lo inyecta vía [cargarEstado] / [guardarEstado].
class MotorMaestria {
  MotorMaestria({
    required this.catalogo,
    required this.cargarEstado,
    required this.guardarEstado,
  });

  final CatalogoHabilidades catalogo;

  /// Lee el estado de una habilidad desde el almacén. Devuelve null si
  /// no existe todavía (la habilidad no se ha practicado nunca).
  final Future<EstadoHabilidad?> Function(String idHabilidad) cargarEstado;

  /// Persiste el estado actualizado.
  final Future<void> Function(EstadoHabilidad estado) guardarEstado;

  static const int _maxIntentosRecientes = 20;

  /// Registra el resultado de un ejercicio para una habilidad y
  /// devuelve el [EstadoHabilidad] actualizado. Calcula:
  /// - precisión ponderada por dificultad sobre los últimos N intentos,
  /// - tiempo mediano,
  /// - nivel de maestría según umbrales del §4 del doc 02.
  Future<EstadoHabilidad> registrarResultado({
    required String idHabilidad,
    required bool acierto,
    required double dificultad,
    required int duracionSegundos,
    DateTime? ahora,
  }) async {
    assert(dificultad >= 0.5 && dificultad <= 2.0);
    final ahoraEfectivo = ahora ?? DateTime.now();
    final estadoPrevio = (await cargarEstado(idHabilidad)) ??
        EstadoHabilidad.inicial(idHabilidad);

    final nuevoIntento = IntentoHabilidad(
      instante: ahoraEfectivo,
      acierto: acierto,
      dificultad: dificultad,
      duracionSegundos: duracionSegundos,
    );
    final intentos = [...estadoPrevio.intentosRecientes, nuevoIntento];
    if (intentos.length > _maxIntentosRecientes) {
      intentos.removeRange(0, intentos.length - _maxIntentosRecientes);
    }

    final precision = _calcularPrecisionPonderada(intentos);
    final tiempoMediano = _calcularTiempoMediano(intentos);

    final totalExposiciones = estadoPrevio.totalExposiciones + 1;
    final sesionesConsecutivas = _actualizarSesionesConsecutivas(
      estadoPrevio: estadoPrevio,
      ahora: ahoraEfectivo,
      precisionActual: precision,
    );
    final nivel = _nivelSegunPrecision(
      precision: precision,
      totalExposiciones: totalExposiciones,
      sesionesConsecutivas: sesionesConsecutivas,
      nivelPrevio: estadoPrevio.nivel,
    );

    final estadoNuevo = estadoPrevio.copiarCon(
      nivel: nivel,
      precision: precision,
      tiempoMedianoSeg: tiempoMediano,
      ultimaPractica: ahoraEfectivo,
      sesionesConsecutivasBuenas: sesionesConsecutivas,
      totalExposiciones: totalExposiciones,
      intentosRecientes: intentos,
    );
    await guardarEstado(estadoNuevo);
    return estadoNuevo;
  }

  /// Aplica decaimiento a un estado según el tiempo transcurrido.
  /// No baja del nivel suelo (en desarrollo por defecto).
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

  double _calcularPrecisionPonderada(List<IntentoHabilidad> intentos) {
    if (intentos.isEmpty) return 0;
    var numerador = 0.0;
    var denominador = 0.0;
    for (final intento in intentos) {
      numerador += (intento.acierto ? 1 : 0) * intento.dificultad;
      denominador += intento.dificultad;
    }
    if (denominador <= 0) return 0;
    return numerador / denominador;
  }

  double _calcularTiempoMediano(List<IntentoHabilidad> intentos) {
    if (intentos.isEmpty) return 0;
    final tiempos = intentos.map((i) => i.duracionSegundos).toList()..sort();
    final mitad = tiempos.length ~/ 2;
    if (tiempos.length.isOdd) return tiempos[mitad].toDouble();
    return (tiempos[mitad - 1] + tiempos[mitad]) / 2;
  }

  int _actualizarSesionesConsecutivas({
    required EstadoHabilidad estadoPrevio,
    required DateTime ahora,
    required double precisionActual,
  }) {
    // Consideramos "sesión" un bloque de práctica con gap > 4 horas.
    final gapHoras =
        ahora.difference(estadoPrevio.ultimaPractica).inHours;
    final esNuevaSesion = gapHoras >= 4;
    if (!esNuevaSesion) return estadoPrevio.sesionesConsecutivasBuenas;
    if (precisionActual >= 0.75) {
      return estadoPrevio.sesionesConsecutivasBuenas + 1;
    }
    return 0;
  }

  NivelMaestria _nivelSegunPrecision({
    required double precision,
    required int totalExposiciones,
    required int sesionesConsecutivas,
    required NivelMaestria nivelPrevio,
  }) {
    // Maestría: ≥0.90 + ≥20 exposiciones + ≥5 sesiones consecutivas buenas.
    if (precision >= 0.90 &&
        totalExposiciones >= 20 &&
        sesionesConsecutivas >= 5) {
      return NivelMaestria.maestria;
    }
    // Competente: ≥0.75 + ≥3 sesiones consecutivas buenas.
    if (precision >= 0.75 && sesionesConsecutivas >= 3) {
      return NivelMaestria.competente;
    }
    // En desarrollo: ≥0.50.
    if (precision >= 0.50) return NivelMaestria.enDesarrollo;
    // Introducida: hay alguna exposición, no basta para en desarrollo.
    if (totalExposiciones > 0) return NivelMaestria.introducida;
    return NivelMaestria.inexplorada;
  }
}
