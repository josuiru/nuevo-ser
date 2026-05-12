import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../servicios/servicio_commons.dart';

/// Miniatura de Wikimedia Commons para usar como `leading` en un
/// `ListTile` o `ExpansionTile`. Sin pie de atribución (la ficha
/// de detalle expandida ya lo incluye vía `ImagenCommonsWidget`).
class MiniaturaCommons extends StatefulWidget {
  final String tituloWikipedia;
  final String terminoBusqueda;
  final double size;

  const MiniaturaCommons({
    super.key,
    required this.tituloWikipedia,
    required this.terminoBusqueda,
    this.size = 48,
  });

  @override
  State<MiniaturaCommons> createState() => _MiniaturaCommonsState();
}

class _MiniaturaCommonsState extends State<MiniaturaCommons> {
  late final Future<ImagenCommons?> _futureImagen;

  @override
  void initState() {
    super.initState();
    _futureImagen = buscarImagenLibreParaCultivo(
      widget.tituloWikipedia,
      termino: widget.terminoBusqueda,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImagenCommons?>(
      future: _futureImagen,
      builder: (_, snapshot) {
        final url = snapshot.data?.urlThumb;
        if (url == null) return const SizedBox.shrink();
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: url,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.cover,
            memCacheWidth: (widget.size * 2).toInt(),
          ),
        );
      },
    );
  }
}
