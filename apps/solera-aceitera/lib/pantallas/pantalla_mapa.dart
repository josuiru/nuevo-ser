import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../datos/base_datos.dart';
import '../modelos/parcela.dart';
import '../utiles/permisos_gps.dart';
import 'pantalla_ficha_parcela.dart';
import 'pantalla_nueva_parcela.dart';

/// Mapa de las parcelas del olivar.
///
/// - Las parcelas con coordenadas se pintan como marcadores tocables que
///   abren la ficha.
/// - Las parcelas sin coordenadas se listan en un sheet que se abre desde
///   el chip de la barra superior, con un botón "Asignar GPS" — un toque
///   y se les pone la posición actual del dispositivo, así no hace falta
///   volver al formulario.
/// - El FAB lleva a crear una parcela nueva (que ya soporta captura GPS
///   desde el propio formulario).
class PantallaMapa extends StatefulWidget {
  const PantallaMapa({super.key});

  @override
  State<PantallaMapa> createState() => _PantallaMapaState();
}

class _PantallaMapaState extends State<PantallaMapa> {
  List<Parcela> _conCoords = const [];
  List<Parcela> _sinCoords = const [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final todas = await BaseDatosSoleraAceitera().listarParcelas();
    if (!mounted) return;
    setState(() {
      _conCoords = todas
          .where((p) => p.latitud != null && p.longitud != null)
          .toList(growable: false);
      _sinCoords = todas
          .where((p) => p.latitud == null || p.longitud == null)
          .toList(growable: false);
      _cargando = false;
    });
  }

  Future<void> _crearNueva() async {
    final olivar = await BaseDatosSoleraAceitera().obtenerOlivar();
    if (!mounted) return;
    if (olivar?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falta crear el olivar primero.')),
      );
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PantallaNuevaParcela(olivarId: olivar!.id!),
    ));
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mapa')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_conCoords.isEmpty && _sinCoords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mapa')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Todavía no hay parcelas.\n'
                  'Crea una y pulsa "Capturar GPS" en el formulario '
                  'para que aparezca aquí.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _crearNueva,
                  icon: const Icon(Icons.add_location_alt),
                  label: const Text('Nueva parcela con GPS'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final centroide = _conCoords.isNotEmpty
        ? LatLng(_conCoords.first.latitud!, _conCoords.first.longitud!)
        : const LatLng(37.5, -3.5); // centro aproximado del olivar peninsular
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          if (_sinCoords.isNotEmpty)
            IconButton(
              icon: Badge(
                label: Text('${_sinCoords.length}'),
                child: const Icon(Icons.location_off),
              ),
              tooltip: 'Parcelas sin coordenadas',
              onPressed: _mostrarSinCoords,
            ),
        ],
      ),
      body: _conCoords.isEmpty
          ? _mensajeSinMarcadores()
          : FlutterMap(
              options: MapOptions(
                initialCenter: centroide,
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.coleccionnuevoser.solera_aceitera',
                ),
                MarkerLayer(
                  markers: _conCoords
                      .map((p) => Marker(
                            point: LatLng(p.latitud!, p.longitud!),
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PantallaFichaParcela(parcela: p),
                                ),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFF5C6B3A),
                                size: 36,
                              ),
                            ),
                          ))
                      .toList(growable: false),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _crearNueva,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Nueva parcela'),
      ),
    );
  }

  Widget _mensajeSinMarcadores() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Ninguna de las ${_sinCoords.length} parcelas tiene '
              'coordenadas. Pulsa el icono de arriba a la derecha para '
              'verlas y asignarles GPS.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarSinCoords() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Parcelas sin coordenadas (${_sinCoords.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ..._sinCoords.map((p) => ListTile(
                  leading: const Icon(Icons.location_off),
                  title: Text(p.nombre),
                  subtitle: p.codigoSigpac.isNotEmpty
                      ? Text(p.codigoSigpac)
                      : null,
                  trailing: TextButton.icon(
                    icon: const Icon(Icons.my_location),
                    label: const Text('Asignar GPS'),
                    onPressed: () => _asignarGpsActual(p),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PantallaFichaParcela(parcela: p),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _asignarGpsActual(Parcela p) async {
    // Cerramos el sheet primero para que el usuario vea el feedback de
    // la captura GPS en la pantalla del mapa.
    Navigator.of(context).pop();
    final mensajero = ScaffoldMessenger.of(context);
    mensajero.showSnackBar(
      const SnackBar(content: Text('Capturando GPS…')),
    );
    try {
      final permiso = await asegurarPermisoUbicacion();
      if (!mounted) return;
      if (!permiso) {
        mensajero.hideCurrentSnackBar();
        mensajero.showSnackBar(
          const SnackBar(
            content: Text(
              'GPS no disponible. Revisa que la ubicación esté '
              'encendida y los permisos concedidos.',
            ),
          ),
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );
      if (!mounted) return;
      await BaseDatosSoleraAceitera().actualizarParcelaCoords(
        id: p.id!,
        latitud: pos.latitude,
        longitud: pos.longitude,
      );
      if (!mounted) return;
      mensajero.hideCurrentSnackBar();
      mensajero.showSnackBar(
        SnackBar(
          content: Text(
            'GPS asignado a ${p.nombre}: '
            '${pos.latitude.toStringAsFixed(5)}, '
            '${pos.longitude.toStringAsFixed(5)}',
          ),
        ),
      );
      await _cargar();
    } catch (e) {
      if (!mounted) return;
      mensajero.hideCurrentSnackBar();
      mensajero.showSnackBar(
        SnackBar(content: Text('Error capturando GPS: $e')),
      );
    }
  }
}
