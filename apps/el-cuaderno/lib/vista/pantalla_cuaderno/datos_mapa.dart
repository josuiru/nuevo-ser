import 'package:flutter/material.dart';

/// Datos agnósticos de UI que `_VistaMapa` calcula y entrega al
/// constructor del widget mapa. El default monta `FlutterMap` con
/// tiles OSM; tests inyectan un stub que pinta un placeholder en
/// lugar de hacer requests a internet.
///
/// Clases públicas para no exponer tipos privados en la API de
/// `PantallaCuaderno.constructorMapa`. Sin esto, el linter avisa con
/// `library_private_types_in_public_api`.
class DatosMapa {
  const DatosMapa({
    required this.centroLat,
    required this.centroLng,
    required this.markers,
    this.zoom = 15,
  });

  final double centroLat;
  final double centroLng;

  /// Zoom inicial. 15 = nivel "barrio". El default es razonable para
  /// el caso de uso del juego (un sit spot cabe en pantalla con su
  /// vecindario).
  final double zoom;
  final List<DescriptorMarker> markers;
}

/// Descriptor agnóstico de un marker. La traducción a `Marker` de
/// `flutter_map` ocurre en el constructor del mapa real — los tests
/// pueden trabajar con la lista cruda y comprobar coordenadas, icon
/// y callback sin pintar tiles.
class DescriptorMarker {
  const DescriptorMarker({
    required this.lat,
    required this.lng,
    required this.icono,
    this.color,
    this.tooltip,
    this.alPulsar,
  });

  final double lat;
  final double lng;
  final IconData icono;
  final Color? color;
  final String? tooltip;
  final VoidCallback? alPulsar;
}
