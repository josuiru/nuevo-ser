import 'dart:math' as math;

import '../datos/catalogo_habilidades.dart';
import 'distrito.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'mapeo_habilidades_puzzle.dart';

/// Selector adaptativo de habilidades. Dado el estado de maestría del
/// niño y el contexto actual (distrito), decide qué habilidad tocar
/// a continuación. Implementa (versión simplificada) el algoritmo del
/// doc 03 §8.5.
class SelectorHabilidades {
  SelectorHabilidades({
    required this.catalogo,
    required this.cargarEstado,
    int? semilla,
  }) : _azar = math.Random(semilla);

  final CatalogoHabilidades catalogo;
  final Future<EstadoHabilidad?> Function(String idHabilidad) cargarEstado;
  final math.Random _azar;

  String? _ultimaElegida;

  /// Elige la siguiente habilidad a practicar. Devuelve null si
  /// ninguna está disponible (nunca en la práctica del MVP).
  ///
  /// En modo entrenamiento (`dominioFiltrado != null`), las candidatas
  /// se restringen a las habilidades de ese dominio (FR/DEC/PROP/…) en
  /// lugar de a las del distrito. La penalización de anti-repetición y
  /// el bonus por nivel siguen aplicando, pero la bonificación de
  /// pertenencia al distrito se desactiva — en entrenamiento el niño
  /// elige el dominio explícitamente, el distrito ambiental no manda.
  Future<String?> elegirSiguienteHabilidad({
    required Distrito distrito,
    String? dominioFiltrado,
  }) async {
    final candidatas = (dominioFiltrado != null
            ? catalogo.delDominio(dominioFiltrado)
            : catalogo.delDistrito(distrito.identificador))
        .where((h) => skillsConPuzzleImplementado.contains(h.identificador))
        .toList();

    if (candidatas.isEmpty) return null;

    // Cargamos todos los estados una vez para evitar lecturas dentro
    // del bucle de puntuación.
    final estados = <String, EstadoHabilidad>{};
    for (final habilidad in candidatas) {
      final estado = await cargarEstado(habilidad.identificador) ??
          EstadoHabilidad.inicial(habilidad.identificador);
      estados[habilidad.identificador] = estado;
    }

    final puntuaciones = <String, double>{};
    for (final habilidad in candidatas) {
      if (!_dependenciasListas(habilidad, estados)) continue;
      final estado = estados[habilidad.identificador]!;
      puntuaciones[habilidad.identificador] = _puntuar(
        habilidad: habilidad,
        estado: estado,
        distrito: distrito,
        modoEntrenamiento: dominioFiltrado != null,
      );
    }

    if (puntuaciones.isEmpty) return null;
    final elegida = _muestreoPonderado(puntuaciones);
    if (elegida != null) _ultimaElegida = elegida;
    return elegida;
  }

  /// Una habilidad está "lista" si sus dependencias directas están al
  /// menos en nivel Competente o si el propio estado actual de la
  /// habilidad ya supera Introducida (ya se ha expuesto antes, no
  /// tiene sentido bloquearla porque falten deps formalmente).
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
      // Si la dep no está en el conjunto de candidatas ni cargada,
      // asumimos que es prerrequisito externo (p. ej. DIV.*, todavía
      // sin puzzle). La consideramos lista para no bloquear nada.
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
    required Distrito distrito,
    bool modoEntrenamiento = false,
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

    // Bonificación por decaimiento: si lleva días sin practicar y ya
    // se había expuesto, la priorizamos ligeramente.
    if (estado.totalExposiciones > 0) {
      final dias = DateTime.now().difference(estado.ultimaPractica).inDays;
      if (dias > 10) {
        puntos += math.min(5.0, dias * 0.3);
      }
    }

    // Bonificación si la habilidad pertenece específicamente al
    // distrito actual (frente a "todos"). En entrenamiento el niño
    // elige el dominio, no el distrito, así que no aplica.
    if (!modoEntrenamiento &&
        habilidad.distritos.contains(distrito.identificador)) {
      puntos += 2;
    }

    // Penalización si es la última elegida: evitamos repetir combates
    // idénticos seguidos.
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
