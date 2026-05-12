import 'package:flutter/material.dart';

/// Diálogo de confirmación estandarizado con acciones personalizables.
/// Devuelve `true` si el usuario confirma, `false` si cancela.
///
/// Uso:
/// ```dart
/// final ok = await DialogoConfirmacion.mostrar(
///   context,
///   titulo: 'Borrar lote',
///   mensaje: '¿Estás seguro? Esta acción no se puede deshacer.',
///   textoConfirmar: 'Borrar',
///   esPeligroso: true,
/// );
/// ```
class DialogoConfirmacion {
  /// Muestra un diálogo de confirmación. Devuelve `true` si se confirmó.
  static Future<bool> mostrar(
    BuildContext context, {
    required String titulo,
    required String mensaje,
    String textoConfirmar = 'Confirmar',
    String textoCancelar = 'Cancelar',
    bool esPeligroso = false,
    IconData icono = Icons.warning_amber,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(icono,
            color: esPeligroso ? Colors.red : Colors.orange, size: 36),
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(textoCancelar),
          ),
          FilledButton(
            style: esPeligroso
                ? FilledButton.styleFrom(backgroundColor: Colors.red)
                : null,
            onPressed: () => Navigator.pop(context, true),
            child: Text(textoConfirmar,
                style: TextStyle(
                    color: esPeligroso ? Colors.white : null)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
