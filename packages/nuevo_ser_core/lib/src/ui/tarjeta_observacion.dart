import 'dart:io';

import 'package:flutter/material.dart';

/// Tarjeta de observación reutilizable para listas de naturaleza/fósiles.
///
/// Uso:
/// ```dart
/// TarjetaObservacion(
///   titulo: 'Buteo buteo',
///   subtitulo: '12/05/2026 · Busardo ratonero',
///   coordenadas: '42.123, -2.456',
///   urlFoto: '/path/to/foto.jpg',
///   categoriaColor: Colors.green,
///   categoriaIcono: Icons.aviary,
///   onTap: () => _abrirDetalle(hallazgo),
/// )
/// ```
class TarjetaObservacion extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final String? coordenadas;
  final String? urlFoto;
  final Color? categoriaColor;
  final IconData? categoriaIcono;
  final VoidCallback? onTap;

  const TarjetaObservacion({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.coordenadas,
    this.urlFoto,
    this.categoriaColor,
    this.categoriaIcono,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = categoriaColor ?? Colors.grey;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Mini foto
            if (urlFoto != null && urlFoto!.isNotEmpty)
              SizedBox(
                width: 72,
                height: 72,
                child: _buildFoto(),
              )
            else
              Container(
                width: 72,
                height: 72,
                color: color.withAlpha(30),
                child: Icon(categoriaIcono ?? Icons.image,
                    color: color, size: 32),
              ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    if (subtitulo != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(subtitulo!,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                    if (coordenadas != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(coordenadas!,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoto() {
    final esUrl = urlFoto!.startsWith('http://') || urlFoto!.startsWith('https://');
    if (esUrl) {
      return Image.network(urlFoto!, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 32));
    }
    return Image.file(File(urlFoto!), fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 32));
  }
}
