import 'package:flutter/material.dart';

/// Tarjeta de resumen con icono, valor principal y color de acento.
/// Usada en dashboards tipo "Hoy" para mostrar métricas rápidas.
///
/// Uso:
/// ```dart
/// TarjetaResumen(
///   titulo: 'Partidas de leche hoy',
///   valor: '3',
///   subtitulo: '240.5 litros',
///   icono: Icons.water_drop,
///   color: theme.colorScheme.primary,
/// )
/// ```
class TarjetaResumen extends StatelessWidget {
  final String titulo;
  final String valor;
  final String? subtitulo;
  final IconData icono;
  final Color color;

  const TarjetaResumen({
    super.key,
    required this.titulo,
    required this.valor,
    this.subtitulo,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Icon(icono, color: color),
        ),
        title: Text(titulo),
        trailing: Text(valor,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: color)),
        subtitle: subtitulo != null ? Text(subtitulo!) : null,
      ),
    );
  }
}
