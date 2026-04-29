import 'package:flutter/foundation.dart';

import '../../dominio/misterio.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';

/// `ChangeNotifier` que mantiene la vista del cuaderno sincronizada
/// con el [RepositorioLocal]. Vanilla — sin Provider, sin Riverpod
/// (decisión de S1 documentada en `CLAUDE.md` del juego).
///
/// Lectura: la pantalla principal hace `cargar()` en su `initState` y
/// se suscribe con `ListenableBuilder`. Escritura: cualquier cambio
/// (nueva observación, sit spot configurado) llama de vuelta a
/// `cargar()` para refrescar.
class EstadoCuaderno extends ChangeNotifier {
  EstadoCuaderno({required this.repositorio});

  final RepositorioLocal repositorio;

  bool _cargando = false;
  SitSpot? _sitSpot;
  List<Misterio> _misteriosAbiertos = const [];
  List<Observacion> _ultimasObservaciones = const [];

  bool get cargando => _cargando;
  SitSpot? get sitSpot => _sitSpot;
  List<Misterio> get misteriosAbiertos => _misteriosAbiertos;
  List<Observacion> get ultimasObservaciones => _ultimasObservaciones;
  Observacion? get ultimaObservacion =>
      _ultimasObservaciones.isEmpty ? null : _ultimasObservaciones.first;

  Future<void> cargar() async {
    _cargando = true;
    notifyListeners();
    try {
      final sitSpotResultado = await repositorio.obtenerSitSpot();
      final misteriosResultado = await repositorio.obtenerMisteriosAbiertos();
      final ultimas = await repositorio.obtenerObservaciones(limite: 5);
      _sitSpot = sitSpotResultado;
      _misteriosAbiertos = misteriosResultado;
      _ultimasObservaciones = ultimas;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
