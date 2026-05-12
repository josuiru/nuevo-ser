import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../datos/base_datos.dart';
import '../modelos/parcela.dart';
import 'pantalla_ficha_parcela.dart';

/// Mapa de las parcelas del olivar con sus coordenadas (si tienen).
/// Si una parcela no tiene coords, no aparece — F1-A3 no captura
/// coordenadas en la creación; F1-A8 añadirá el botón GPS.
class PantallaMapa extends StatefulWidget {
  const PantallaMapa({super.key});

  @override
  State<PantallaMapa> createState() => _PantallaMapaState();
}

class _PantallaMapaState extends State<PantallaMapa> {
  List<Parcela> _parcelas = const [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final ps = await BaseDatosSoleraAceitera().listarParcelas();
    if (!mounted) return;
    setState(() =>
        _parcelas = ps.where((p) => p.latitud != null && p.longitud != null).toList());
  }

  @override
  Widget build(BuildContext context) {
    if (_parcelas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mapa')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Todavía no hay parcelas con coordenadas en el mapa.\n'
              'Las parcelas aparecerán aquí cuando entre la captura GPS '
              'desde el formulario (F1-A8).',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    final centroide = _parcelas.first;
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(centroide.latitud!, centroide.longitud!),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.josu.solera_aceitera',
          ),
          MarkerLayer(
            markers: _parcelas
                .map((p) => Marker(
                      point: LatLng(p.latitud!, p.longitud!),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PantallaFichaParcela(parcela: p),
                          ),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF5C6B3A),
                          size: 36,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
