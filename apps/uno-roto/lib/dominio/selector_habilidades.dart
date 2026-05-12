import 'package:nuevo_ser_core/nuevo_ser_core.dart' as core;

import '../datos/catalogo_habilidades.dart';
import 'distrito.dart';
import 'mapeo_habilidades_puzzle.dart';

/// Wrapper específico de Uno Roto sobre [core.SelectorHabilidades].
///
/// Mantiene la API histórica que `pantalla_caza` espera (Distrito +
/// dominioFiltrado) y se encarga de los acoplamientos juego-específicos
/// — catálogo concreto, conjunto de habilidades con puzzle implementado
/// — antes de delegar el algoritmo en la plataforma.
///
/// La pieza algorítmica vive en `packages/nuevo_ser_core/lib/src/mastery/
/// selector_habilidades.dart` con los tests caracterización del repo.
class SelectorHabilidades {
  SelectorHabilidades({
    required this.catalogo,
    required this.cargarEstado,
    int? semilla,
  }) : _selectorCore = core.SelectorHabilidades(
          cargarEstado: cargarEstado,
          semilla: semilla,
        );

  final CatalogoHabilidades catalogo;
  final Future<core.EstadoHabilidad?> Function(String idHabilidad) cargarEstado;
  final core.SelectorHabilidades _selectorCore;

  /// Elige la siguiente habilidad a practicar.
  ///
  /// En modo entrenamiento (`dominioFiltrado != null`) las candidatas se
  /// restringen al dominio elegido (FR/DEC/PROP/…) y la bonificación de
  /// pertenencia al distrito se desactiva — en entrenamiento el niño
  /// elige el dominio explícitamente, el distrito ambiental no manda.
  ///
  /// [rangoActual] es el nombre del rango del niño en formato JSON
  /// (p. ej. `'Aprendiz_II'`, `'Iniciado_I'`). Si no se proporciona,
  /// no se filtra por rango (comportamiento predeterminado).
  Future<String?> elegirSiguienteHabilidad({
    required Distrito distrito,
    String? dominioFiltrado,
    String? rangoActual,
  }) {
    final candidatas = (dominioFiltrado != null
            ? catalogo.delDominio(dominioFiltrado, rangoActual: rangoActual)
            : catalogo.delDistrito(distrito.identificador,
                rangoActual: rangoActual))
        .where((h) => skillsConPuzzleImplementado.contains(h.identificador));
    return _selectorCore.elegirSiguienteHabilidad(
      candidatas: candidatas,
      contextoBonusId: distrito.identificador,
      aplicarBonusContexto: dominioFiltrado == null,
    );
  }
}
