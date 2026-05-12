import 'package:flutter/material.dart';
import '../i18n/solera_l10n.dart';

/// Selector de idioma para la suite Solera.
/// Muestra los 4 idiomas disponibles (es, eu, ca, gl) como chips.
///
/// Uso:
/// ```dart
/// SelectorIdioma(
///   onCambio: (codigo) => setState(() {}),
/// )
/// ```
class SelectorIdioma extends StatelessWidget {
  final VoidCallback? onCambio;

  const SelectorIdioma({super.key, this.onCambio});

  static const idiomas = [
    _InfoIdioma('es', 'Español'),
    _InfoIdioma('eu', 'Euskera'),
    _InfoIdioma('ca', 'Català'),
    _InfoIdioma('gl', 'Galego'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: idiomas.map((idioma) {
        final activo = SoleraL10n.idioma == idioma.codigo;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            selected: activo,
            label: Text(idioma.nombre),
            onSelected: (_) {
              SoleraL10n.idioma = idioma.codigo;
              onCambio?.call();
            },
          ),
        );
      }).toList(),
    );
  }
}

class _InfoIdioma {
  final String codigo;
  final String nombre;
  const _InfoIdioma(this.codigo, this.nombre);
}
