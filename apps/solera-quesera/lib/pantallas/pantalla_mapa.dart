import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import '../datos/base_datos.dart';
import '../modelos/proveedor_leche.dart';
import '../utiles/permisos_gps.dart';

class PantallaMapa extends StatefulWidget {
  const PantallaMapa({super.key});
  @override
  State<PantallaMapa> createState() => _PantallaMapaState();
}

class _PantallaMapaState extends State<PantallaMapa> {
  final _ctrl = MapController();
  final _bd = BaseDatosSoleraQuesera.instancia;
  List<ProveedorLeche> _provs = [];
  LatLng _centro = const LatLng(42.8, -2.0);
  double _zoom = 8;

  @override
  void initState() { super.initState(); _cargar(); _centrar(); }

  Future<void> _cargar() async { _provs = await _bd.listarProveedores(); if (mounted) setState(() {}); }

  Future<void> _centrar() async {
    try { final p = await Geolocator.getLastKnownPosition(); if (p != null) { _centro = LatLng(p.latitude, p.longitude); _zoom = 14; if (mounted) setState(() {}); } } catch (_) {}
    final ok = await asegurarPermisoUbicacion(); if (!ok) return;
    try { final p = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 8)); _centro = LatLng(p.latitude, p.longitude); _zoom = 14; if (mounted) setState(() {}); } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final markers = _provs.where((p) => p.latitud != null && p.longitud != null).map((p) => Marker(point: LatLng(p.latitud!, p.longitud!), width: 40, height: 40, child: GestureDetector(onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(p.nombre))), child: const Icon(Icons.pets, color: Color(0xFFC8923B), size: 28)))).toList();
    return Scaffold(
      appBar: AppBar(title: Text(SoleraL10n.t('mapa'))),
      body: FlutterMap(mapController: _ctrl, options: MapOptions(initialCenter: _centro, initialZoom: _zoom), children: [
        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.josu.solera_quesera'),
        MarkerLayer(markers: markers),
      ]),
      floatingActionButton: FloatingActionButton(heroTag: 'fab_gps', onPressed: _centrar, child: const Icon(Icons.my_location)),
    );
  }
}
