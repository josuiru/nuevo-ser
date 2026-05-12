import 'dart:io';

import 'package:flutter/material.dart';

/// Galería de imágenes con desplazamiento horizontal y zoom al tap.
/// Muestra una lista de rutas de archivos (locales) o URLs.
///
/// Uso:
/// ```dart
/// GaleriaImagenes(
///   rutas: ['/path/to/foto1.jpg', '/path/to/foto2.jpg'],
///   onEliminar: (ruta) => setState(() => _rutas.remove(ruta)),
/// )
/// ```
class GaleriaImagenes extends StatelessWidget {
  final List<String> rutas;
  final void Function(String ruta)? onEliminar;
  final double alturaMiniatura;

  const GaleriaImagenes({
    super.key,
    required this.rutas,
    this.onEliminar,
    this.alturaMiniatura = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (rutas.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: alturaMiniatura + 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: rutas.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (_, i) {
          final ruta = rutas[i];
          final esUrl = ruta.startsWith('http://') || ruta.startsWith('https://');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => _verAmpliada(context, ruta, esUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: esUrl
                        ? Image.network(ruta,
                            width: alturaMiniatura,
                            height: alturaMiniatura,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 40))
                        : Image.file(File(ruta),
                            width: alturaMiniatura,
                            height: alturaMiniatura,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 40)),
                  ),
                ),
                if (onEliminar != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => onEliminar!(ruta),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _verAmpliada(BuildContext context, String ruta, bool esUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text('Foto'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: esUrl
                  ? Image.network(ruta, fit: BoxFit.contain)
                  : Image.file(File(ruta), fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
