import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../branding.dart';
import '../datos/base_datos.dart';
import '../l10n/app_localizations.dart';
import '../modelos/finca.dart';
import '../modelos/punto_infraestructura.dart';
import '../utiles/estilos_tarea.dart';
import '../utiles/permisos_gps.dart';
import 'ficha_punto.dart';
import 'nuevo_punto.dart';
import 'tablero_tareas.dart';

enum _EstiloMapa { calle, satelite }

enum _OrigenAlta { gps, centroMapa }

/// Pestaña "Fincas": mapa de Zunbeltz y La Planilla con sus puntos de
/// infraestructura. Tap en un punto → ficha con sus tareas. FAB → nuevo
/// punto (GPS o centro del mapa). Acción → tablero de tareas.
class PantallaFincas extends StatefulWidget {
  const PantallaFincas({super.key});

  @override
  State<PantallaFincas> createState() => _PantallaFincasState();
}

class _PantallaFincasState extends State<PantallaFincas> {
  final _controlador = MapController();
  final _bd = BaseDatosSoleraZunbeltz();
  List<Finca> _fincas = const [];
  List<PuntoInfraestructura> _conCoords = const [];
  bool _cargando = true;
  _EstiloMapa _estiloMapa = _EstiloMapa.calle;
  LatLng? _posicionGps;
  // Centro aproximado de la zona de Andía / Tierra Estella (Navarra).
  LatLng _centroActual = const LatLng(42.793, -1.958);
  double _zoomActual = 12;
  bool _centroResuelto = false;

  @override
  void initState() {
    super.initState();
    _cargar();
    _resolverCentroInicial();
  }

  Future<void> _cargar() async {
    var fincas = <Finca>[];
    var puntos = <PuntoInfraestructura>[];
    try {
      await _bd.sembrarFincasDemoSiVacia();
      fincas = await _bd.listarFincas();
      puntos = await _bd.listarPuntos();
    } catch (_) {
      // Sin BD disponible (p. ej. en tests sin plugins) mostramos el mapa
      // vacío en lugar de romper la pestaña.
    }
    if (!mounted) return;
    setState(() {
      _fincas = fincas;
      _conCoords = puntos
          .where((p) => p.latitud != null && p.longitud != null)
          .toList(growable: false);
      _cargando = false;
    });
    if (!_centroResuelto) {
      final referencia = <LatLng>[];
      if (_conCoords.isNotEmpty) {
        for (final p in _conCoords) {
          referencia.add(LatLng(p.latitud!, p.longitud!));
        }
      } else {
        for (final f in fincas) {
          if (f.latitud != null && f.longitud != null) {
            referencia.add(LatLng(f.latitud!, f.longitud!));
          }
        }
      }
      if (referencia.isNotEmpty) {
        final lat = referencia.map((p) => p.latitude).reduce((a, b) => a + b) /
            referencia.length;
        final lon = referencia.map((p) => p.longitude).reduce((a, b) => a + b) /
            referencia.length;
        _aplicarCentro(LatLng(lat, lon), 13);
      }
    }
  }

  Future<void> _resolverCentroInicial() async {
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null && !_centroResuelto && mounted) {
        _posicionGps = LatLng(last.latitude, last.longitude);
      }
    } catch (_) {}
  }

  void _aplicarCentro(LatLng centro, double zoom) {
    _centroActual = centro;
    _zoomActual = zoom;
    if (!_centroResuelto) {
      setState(() => _centroResuelto = true);
    } else {
      try {
        _controlador.move(centro, zoom);
      } catch (_) {}
    }
  }

  Future<void> _centrarEnGps() async {
    final textos = AppLocalizations.of(context);
    final permitido = await asegurarPermisoUbicacion();
    if (!permitido) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(textos.mapaGpsNoDisponible)));
      }
      return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition()
          .timeout(const Duration(seconds: 8));
      if (!mounted) return;
      setState(() => _posicionGps = LatLng(pos.latitude, pos.longitude));
      _aplicarCentro(LatLng(pos.latitude, pos.longitude), 16);
    } catch (_) {}
  }

  Future<int?> _elegirFinca() async {
    if (_fincas.length == 1) return _fincas.first.id;
    final textos = AppLocalizations.of(context);
    return showModalBottomSheet<int>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(textos.mapaElegirFinca)),
            const Divider(height: 1),
            for (final f in _fincas)
              ListTile(
                leading: const Icon(Icons.landscape_outlined),
                title: Text(f.nombre),
                onTap: () => Navigator.pop(context, f.id),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _alAnadirPunto() async {
    final textos = AppLocalizations.of(context);
    final fincaId = await _elegirFinca();
    if (fincaId == null || !mounted) return;

    final origen = await showModalBottomSheet<_OrigenAlta>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.gps_fixed),
              title: Text(textos.mapaUsarGps),
              onTap: () => Navigator.pop(context, _OrigenAlta.gps),
            ),
            ListTile(
              leading: const Icon(Icons.center_focus_strong),
              title: Text(textos.mapaUsarCentro),
              subtitle: Text(
                  '${_centroActual.latitude.toStringAsFixed(5)}, ${_centroActual.longitude.toStringAsFixed(5)}'),
              onTap: () => Navigator.pop(context, _OrigenAlta.centroMapa),
            ),
          ],
        ),
      ),
    );
    if (origen == null || !mounted) return;

    double? latitud;
    double? longitud;
    if (origen == _OrigenAlta.centroMapa) {
      latitud = _centroActual.latitude;
      longitud = _centroActual.longitude;
    } else {
      try {
        final permitido = await asegurarPermisoUbicacion();
        if (permitido) {
          final pos = await Geolocator.getCurrentPosition()
              .timeout(const Duration(seconds: 8));
          latitud = pos.latitude;
          longitud = pos.longitude;
          if (mounted) {
            setState(() => _posicionGps = LatLng(pos.latitude, pos.longitude));
          }
        }
      } catch (_) {}
      if (latitud == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(textos.mapaGpsNoDisponible)));
      }
    }

    if (!mounted) return;
    final creado = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => NuevoPunto(
        fincas: _fincas,
        fincaIdInicial: fincaId,
        latitudInicial: latitud,
        longitudInicial: longitud,
      ),
    ));
    if (creado == true) await _cargar();
  }

  List<Marker> _marcadores() {
    return [
      if (_posicionGps != null)
        Marker(
          point: _posicionGps!,
          width: 28,
          height: 28,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.25),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.circle, size: 10, color: Colors.blueAccent),
            ),
          ),
        ),
      for (final punto in _conCoords)
        Marker(
          point: LatLng(punto.latitud!, punto.longitud!),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () async {
              final cambiado = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => FichaPunto(punto: punto)),
              );
              if (cambiado == true && mounted) await _cargar();
            },
            child: Icon(Icons.location_on,
                size: 38, color: colorEstadoPunto(punto.estado)),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: Text(textos.navFincas)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(textos.navFincas),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TableroTareas()),
            ),
            icon: const Icon(Icons.checklist),
            label: Text(textos.mapaTablero),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _controlador,
            options: MapOptions(
              initialCenter: _centroActual,
              initialZoom: _zoomActual,
              minZoom: 3,
              maxZoom: 22,
              onPositionChanged: (cam, _) {
                _centroActual = cam.center;
                _zoomActual = cam.zoom;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _estiloMapa == _EstiloMapa.calle
                    ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                    : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.coleccionnuevoser.solera_zunbeltz',
                maxZoom: 22,
                maxNativeZoom: 19,
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 42,
                  disableClusteringAtZoom: 20,
                  size: const Size(40, 40),
                  markers: _marcadores(),
                  builder: (context, markers) => Container(
                    decoration: const BoxDecoration(
                      color: colorMonteZunbeltz,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${markers.length}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_conCoords.isEmpty)
            Positioned(
              left: 16,
              right: 16,
              top: 12,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(textos.mapaSinPuntos,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _estiloMapa = _estiloMapa == _EstiloMapa.calle
                        ? _EstiloMapa.satelite
                        : _EstiloMapa.calle;
                  }),
                  icon: Icon(_estiloMapa == _EstiloMapa.calle
                      ? Icons.layers_outlined
                      : Icons.map_outlined),
                  label: Text(_estiloMapa == _EstiloMapa.calle
                      ? textos.mapaCapas
                      : textos.mapaMapa),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _centrarEnGps,
                  icon: const Icon(Icons.my_location),
                  label: Text(textos.mapaGps),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _alAnadirPunto,
        icon: const Icon(Icons.add_location_alt),
        label: Text(textos.mapaNuevoPunto),
      ),
    );
  }
}
