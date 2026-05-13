import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../datos/base_datos.dart';
import '../../servicios/servicio_meteo_aceitera.dart';
import '../../utiles/permisos_gps.dart';
import '../pantalla_meteo_aceitera.dart';

/// Tarjeta compacta de meteo del día para el dashboard "Hoy" de
/// aceitera. Muestra temperaturas, lluvia, viento y avisos clave
/// (helada, mosca del olivo, golpe de calor, mal día tratamiento) y al
/// pulsarla abre la `PantallaMeteoAceitera` completa con previsión a
/// 7 días y consejos olivareros.
class TarjetaResumenMeteo extends StatefulWidget {
  const TarjetaResumenMeteo({super.key});

  @override
  State<TarjetaResumenMeteo> createState() => _TarjetaResumenMeteoState();
}

class _TarjetaResumenMeteoState extends State<TarjetaResumenMeteo> {
  final _servicio = ServicioMeteoAceitera();
  Future<PrevisionAceitera>? _futuro;
  String _origen = 'olivar';

  @override
  void initState() {
    super.initState();
    _futuro = _cargar();
  }

  Future<PrevisionAceitera> _cargar() async {
    final destino = await resolverDestinoMeteoAceitera();
    _origen = destino.nombre;
    return _servicio.obtener(
      latitud: destino.latitud,
      longitud: destino.longitud,
    );
  }

  void _abrirCompleta() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PantallaMeteoAceitera()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _abrirCompleta,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder<PrevisionAceitera>(
            future: _futuro,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Row(
                  children: [
                    Icon(Icons.cloud_outlined, color: Color(0xFF5C6B3A)),
                    SizedBox(width: 12),
                    Text('Cargando previsión meteo…'),
                  ],
                );
              }
              if (snapshot.hasError || snapshot.data == null) {
                return const Row(
                  children: [
                    Icon(Icons.cloud_off, color: Colors.grey),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                          'No se pudo cargar la previsión. Toca para reintentar.'),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                );
              }
              final prevision = snapshot.data!;
              final hoy = prevision.hoy;
              if (hoy == null) {
                return const Text('Sin datos meteo para hoy.');
              }
              final avisos = avisosClaveOlivar(hoy);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud, color: Color(0xFF5C6B3A)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Meteo hoy · $_origen',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _ChipMeteo(
                        icono: Icons.thermostat,
                        texto:
                            '${_fmt(hoy.tempMin)} / ${_fmt(hoy.tempMax)} °C',
                      ),
                      _ChipMeteo(
                        icono: Icons.water,
                        texto:
                            '${_fmt(hoy.lluviaMm)} mm · ${_fmt(hoy.probLluviaMax)} %',
                      ),
                      _ChipMeteo(
                        icono: Icons.air,
                        texto: '${_fmt(hoy.vientoMaxKmh)} km/h',
                      ),
                    ],
                  ),
                  if (avisos.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    for (final aviso in avisos)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(aviso.icono,
                                size: 18, color: aviso.color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                aviso.titulo,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static String _fmt(double? v, {int decimales = 1}) =>
      v == null ? '--' : v.toStringAsFixed(decimales);
}

class _ChipMeteo extends StatelessWidget {
  final IconData icono;
  final String texto;
  const _ChipMeteo({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icono, size: 16),
      label: Text(texto, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// Aviso clave del olivar para mostrar en el resumen de "Hoy". Cada
/// aviso lleva un icono, título corto y color (rojo para riesgo
/// agronómico, naranja para precaución, verde si conviene aprovechar
/// la ventana).
class AvisoOlivar {
  final IconData icono;
  final String titulo;
  final Color color;
  const AvisoOlivar(this.icono, this.titulo, this.color);
}

/// Conjunto de avisos a mostrar en el resumen de hoy. Los avisos
/// detallados (con descripción larga y manejo recomendado) viven en
/// `pantalla_meteo_aceitera.dart`.
List<AvisoOlivar> avisosClaveOlivar(DiaMeteoOlivar dia) {
  final avisos = <AvisoOlivar>[];
  if (dia.riesgoHelada) {
    avisos.add(const AvisoOlivar(
      Icons.ac_unit,
      'Riesgo de helada · revisa olivos jóvenes',
      Color(0xFF1976D2),
    ));
  }
  if (dia.golpeCalorAceituna) {
    avisos.add(const AvisoOlivar(
      Icons.local_fire_department,
      'Golpe de calor en aceituna (>38 °C)',
      Color(0xFFD84315),
    ));
  }
  if (dia.vueloMoscaOlivoActivo) {
    avisos.add(const AvisoOlivar(
      Icons.bug_report,
      'Vuelo activo de mosca del olivo',
      Color(0xFFE65100),
    ));
  }
  if (dia.malDiaTratamiento) {
    avisos.add(const AvisoOlivar(
      Icons.science,
      'Tratamientos delicados (viento o lluvia)',
      Color(0xFFE65100),
    ));
  }
  if (dia.estresHidrico) {
    avisos.add(const AvisoOlivar(
      Icons.water_drop,
      'Demanda hídrica alta · activa riego',
      Color(0xFF0277BD),
    ));
  }
  if (dia.floracionEnRiesgo) {
    avisos.add(const AvisoOlivar(
      Icons.local_florist,
      'Floración en condiciones de mal cuajado',
      Color(0xFFE65100),
    ));
  }
  return avisos;
}

/// Destino del meteo: nombre humano + coordenadas. Se calcula en
/// cascada desde el centroide de las parcelas con coordenadas hacia
/// el GPS reciente y, como fallback, hacia el centro del olivar
/// peninsular.
class DestinoMeteoAceitera {
  final String nombre;
  final double latitud;
  final double longitud;
  const DestinoMeteoAceitera({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });
}

Future<DestinoMeteoAceitera> resolverDestinoMeteoAceitera() async {
  final db = BaseDatosSoleraAceitera();
  final parcelas = await db.listarParcelas();
  final conCoords =
      parcelas.where((p) => p.latitud != null && p.longitud != null).toList();
  if (conCoords.isNotEmpty) {
    final lat = conCoords.map((p) => p.latitud!).reduce((a, b) => a + b) /
        conCoords.length;
    final lon = conCoords.map((p) => p.longitud!).reduce((a, b) => a + b) /
        conCoords.length;
    final olivar = await db.obtenerOlivar();
    return DestinoMeteoAceitera(
      nombre: (olivar?.nombre.isNotEmpty == true)
          ? olivar!.nombre
          : 'centro de parcelas',
      latitud: lat,
      longitud: lon,
    );
  }

  final permitido = await asegurarPermisoUbicacion();
  if (permitido) {
    try {
      final ultima = await Geolocator.getLastKnownPosition();
      if (ultima != null) {
        return DestinoMeteoAceitera(
          nombre: 'GPS reciente',
          latitud: ultima.latitude,
          longitud: ultima.longitude,
        );
      }
    } catch (_) {}
    try {
      final pos = await Geolocator.getCurrentPosition()
          .timeout(const Duration(seconds: 8));
      return DestinoMeteoAceitera(
        nombre: 'GPS actual',
        latitud: pos.latitude,
        longitud: pos.longitude,
      );
    } catch (_) {}
  }
  // Fallback: centro aproximado del olivar peninsular (Jaén — el centro
  // de masa real de la producción olivarera ibérica).
  return const DestinoMeteoAceitera(
    nombre: 'centro del olivar peninsular',
    latitud: 37.78,
    longitud: -3.78,
  );
}
