import 'dart:math' as math;

import 'habilidad.dart';

/// Selector adaptativo genérico de habilidades.
///
/// Versión de plataforma del algoritmo del doc 03 §8.5: dado un conjunto
/// de habilidades candidatas y los estados de maestría correspondientes,
/// pondera por nivel + decaimiento + bonus de contexto y aplica una
/// penalización para evitar repetir la misma habilidad dos veces seguidas.
///
/// Es deliberadamente agnóstico al juego: NO conoce distritos, catálogos
/// concretos ni qué habilidades tienen puzzle implementado. La capa de
/// adaptación específica (p. ej. el selector de Uno Roto) decide qué
/// candidatas pasar y qué identificador usar como contexto.
class SelectorHabilidades {
  SelectorHabilidades({
    required this.cargarEstado,
    int? semilla,
  }) : _azar = math.Random(semilla);

  /// Devuelve el estado actual de la habilidad para el niño activo, o
  /// null si nunca se ha tocado (en cuyo caso se usa
  /// [EstadoHabilidad.inicial]).
  final Future<EstadoHabilidad?> Function(String idHabilidad) cargarEstado;

  final math.Random _azar;

  String? _ultimaElegida;

  /// Elige la siguiente habilidad a practicar entre [candidatas].
  ///
  /// Devuelve null si el conjunto de candidatas listas (con sus
  /// dependencias cubiertas) acaba vacío.
  ///
  /// [contextoBonusId] — si una habilidad tiene este id en su lista de
  /// distritos, suma un bonus de 2 puntos (siempre que
  /// [aplicarBonusContexto] sea true). Pensado para que la capa
  /// específica del juego priorice levemente las habilidades que
  /// pertenecen al contexto ambiental actual (distrito en Uno Roto, era
  /// en Las Versiones…). Si la app no usa contextos, basta con pasar
  /// null y el bonus queda inerte.
  ///
  /// [aplicarBonusContexto] — false en modos donde el niño elige
  /// explícitamente el dominio (entrenamiento), de forma que el contexto
  /// ambiental no manda.
  Future<String?> elegirSiguienteHabilidad({
    required Iterable<Habilidad> candidatas,
    String? contextoBonusId,
    bool aplicarBonusContexto = true,
  }) async {
    final lista = candidatas.toList();
    if (lista.isEmpty) return null;

    final estados = <String, EstadoHabilidad>{};
    for (final habilidad in lista) {
      final estado = await cargarEstado(habilidad.identificador) ??
          EstadoHabilidad.inicial(habilidad.identificador);
      estados[habilidad.identificador] = estado;
    }

    final puntuaciones = <String, double>{};
    for (final habilidad in lista) {
      if (!_dependenciasListas(habilidad, estados)) continue;
      final estado = estados[habilidad.identificador]!;
      puntuaciones[habilidad.identificador] = _puntuar(
        habilidad: habilidad,
        estado: estado,
        contextoBonusId: contextoBonusId,
        aplicarBonusContexto: aplicarBonusContexto,
      );
    }

    if (puntuaciones.isEmpty) return null;
    final elegida = _muestreoPonderado(puntuaciones);
    if (elegida != null) _ultimaElegida = elegida;
    return elegida;
  }

  /// Una habilidad está "lista" si su propio estado actual ya supera
  /// Introducida (ya se ha expuesto antes, no tiene sentido bloquearla
  /// porque falten deps formalmente) o si todas sus dependencias
  /// directas presentes en el conjunto están al menos en Competente.
  ///
  /// Las dependencias ausentes del mapa de estados se consideran
  /// prerrequisitos externos (p. ej. dominios todavía sin puzzle) y no
  /// bloquean — el selector no es responsable de modelar el currículum
  /// completo, solo de no sugerir algo claramente fuera del alcance del
  /// niño.
  bool _dependenciasListas(
    Habilidad habilidad,
    Map<String, EstadoHabilidad> estados,
  ) {
    final estadoActual = estados[habilidad.identificador];
    if (estadoActual != null &&
        estadoActual.nivel.valor >= NivelMaestria.enDesarrollo.valor) {
      return true;
    }
    for (final dep in habilidad.dependencias) {
      final estadoDep = estados[dep];
      if (estadoDep == null) continue;
      if (estadoDep.nivel.valor < NivelMaestria.competente.valor) {
        return false;
      }
    }
    return true;
  }

  double _puntuar({
    required Habilidad habilidad,
    required EstadoHabilidad estado,
    required String? contextoBonusId,
    required bool aplicarBonusContexto,
  }) {
    double puntos = 0;

    switch (estado.nivel) {
      case NivelMaestria.inexplorada:
        puntos += 10;
        break;
      case NivelMaestria.introducida:
        puntos += 10;
        break;
      case NivelMaestria.enDesarrollo:
        puntos += 7;
        break;
      case NivelMaestria.competente:
        puntos += 3;
        break;
      case NivelMaestria.maestria:
        puntos += 1;
        break;
    }

    if (estado.totalExposiciones > 0) {
      final dias = DateTime.now().difference(estado.ultimaPractica).inDays;
      if (dias > 10) {
        puntos += math.min(5.0, dias * 0.3);
      }
    }

    if (aplicarBonusContexto &&
        contextoBonusId != null &&
        habilidad.distritos.contains(contextoBonusId)) {
      puntos += 2;
    }

    if (habilidad.identificador == _ultimaElegida) {
      puntos *= 0.3;
    }

    return math.max(0, puntos);
  }

  String? _muestreoPonderado(Map<String, double> puntuaciones) {
    final total = puntuaciones.values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return null;
    final r = _azar.nextDouble() * total;
    double acumulado = 0;
    for (final entrada in puntuaciones.entries) {
      acumulado += entrada.value;
      if (r < acumulado) return entrada.key;
    }
    return puntuaciones.keys.last;
  }
}
