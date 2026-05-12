import 'package:flutter/services.dart';
import 'package:quick_actions/quick_actions.dart';

/// Gestiona los accesos directos de la pantalla de inicio (Android/iOS).
///
/// Permite que el usuario añada un acceso directo "Nuevo hallazgo" en el
/// lanzador sin necesidad de abrir la app primero.
///
/// Uso en main.dart:
/// ```dart
/// AccesoDirectoHallazgo.inicializar(
///   onNuevoHallazgo: () => _navegarANuevoHallazgo(),
/// );
/// ```
class AccesoDirectoHallazgo {
  static final _quickActions = QuickActions();
  static const _tipoNuevoHallazgo = 'nuevo_hallazgo';

  /// Inicializa los accesos directos. Llama a `onNuevoHallazgo` cuando
  /// el usuario pulsa el acceso directo desde el lanzador.
  static Future<void> inicializar({
    required VoidCallback onNuevoHallazgo,
    String tipo = 'hallazgo',
    String icono = 'ic_launcher',
  }) async {
    try {
      await _quickActions.setShortcutItems(<ShortcutItem>[
        ShortcutItem(
          type: _tipoNuevoHallazgo,
          localizedTitle: tipo == 'fosil'
              ? 'Nuevo fósil'
              : 'Nuevo hallazgo',
          icon: icono,
        ),
      ]);

      _quickActions.initialize((String type) {
        if (type == _tipoNuevoHallazgo) {
          onNuevoHallazgo();
        }
      });
    } on PlatformException catch (_) {
      // No soportado en esta plataforma (web/linux)
    }
  }
}
