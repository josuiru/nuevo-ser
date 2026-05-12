import 'package:flutter/material.dart';

/// Barra de búsqueda reutilizable con debounce implícito (el caller
/// controla cuándo ejecuta la búsqueda via `onChanged`).
///
/// Uso:
/// ```dart
/// BarraBusqueda(
///   controlador: _buscador,
///   onChanged: (_) => setState(() {}),
///   sugerencia: 'Buscar por nombre o lote…',
/// )
/// ```
class BarraBusqueda extends StatelessWidget {
  final TextEditingController controlador;
  final ValueChanged<String> onChanged;
  final String sugerencia;

  const BarraBusqueda({
    super.key,
    required this.controlador,
    required this.onChanged,
    this.sugerencia = 'Buscar…',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: controlador,
        decoration: InputDecoration(
          hintText: sugerencia,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          isDense: true,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
