import 'package:flutter/material.dart';

/// Superposición de cruz/círculo en el centro del mapa para indicar
/// dónde se añadirá el nuevo punto al confirmar. Se activa con un
/// FloatingActionButton que alterna el modo "añadir punto aquí".
///
/// Uso:
/// ```dart
/// Stack(
///   children: [
///     FlutterMap(/* el mapa */),
///     if (modoAgregar)
///       CruzCentroMapa(
///         latitud: centro.latitude,
///         longitud: centro.longitude,
///         precisionMetros: 10,
///         onConfirmar: () => _guardarPunto(centro),
///         onCancelar: () => setState(() => modoAgregar = false),
///       ),
///   ],
/// )
/// ```
class CruzCentroMapa extends StatelessWidget {
  final double? latitud;
  final double? longitud;
  final double? precisionMetros;
  final VoidCallback onConfirmar;
  final VoidCallback onCancelar;

  const CruzCentroMapa({
    super.key,
    this.latitud,
    this.longitud,
    this.precisionMetros,
    required this.onConfirmar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Sombra del círculo
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 80, // espacio para la barra inferior
          child: IgnorePointer(
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary.withAlpha(180),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Líneas de la cruz
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 80,
          child: IgnorePointer(
            child: Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CustomPaint(
                  painter: _CruzPainter(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Barra inferior de coordenadas + botones
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (latitud != null && longitud != null) ...[
                  Text(
                    '${latitud!.toStringAsFixed(6)}, ${longitud!.toStringAsFixed(6)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (precisionMetros != null)
                    Text(
                      '± ${precisionMetros!.toStringAsFixed(1)} m',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onCancelar,
                        icon: const Icon(Icons.close),
                        label: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onConfirmar,
                        icon: const Icon(Icons.check),
                        label: const Text('Añadir aquí'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Indicador visual superior
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, size: 16,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text('Toca confirmar para añadir el punto aquí',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CruzPainter extends CustomPainter {
  final Color color;

  _CruzPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(120)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Línea vertical
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paint,
    );
    // Línea horizontal
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CruzPainter oldDelegate) =>
      oldDelegate.color != color;
}
