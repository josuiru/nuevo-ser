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
  Map<String, int> _evidenciasPorMisterio = const {};

  bool get cargando => _cargando;
  SitSpot? get sitSpot => _sitSpot;
  List<Misterio> get misteriosAbiertos => _misteriosAbiertos;
  List<Observacion> get ultimasObservaciones => _ultimasObservaciones;
  Observacion? get ultimaObservacion =>
      _ultimasObservaciones.isEmpty ? null : _ultimasObservaciones.first;

  /// Cuántas observaciones tiene el niño anotadas contra cada Misterio
  /// abierto (clave = `Misterio.id`). Se resuelve al cargar y alimenta
  /// el contador "N evidencias anotadas" de la `TarjetaMisterio`. Si
  /// un Misterio no aparece como clave es que no tiene evidencias —
  /// las pantallas tratan ausencia y `0` como equivalentes.
  Map<String, int> get evidenciasPorMisterio => _evidenciasPorMisterio;

  Future<void> cargar() async {
    _cargando = true;
    notifyListeners();
    try {
      final sitSpotResultado = await repositorio.obtenerSitSpot();
      final misteriosResultado = await repositorio.obtenerMisteriosAbiertos();
      final ultimas = await repositorio.obtenerObservaciones(limite: 5);
      // Conteo por Misterio: una observación por cada id abierto. La
      // alternativa sería leer `misterio.observacionesIds.length`, pero
      // el query es la fuente de verdad — observacionesIds del modelo
      // puede arrastrar drift si en el futuro alguien guarda una
      // observación bypass del helper de anclar.
      final evidencias = <String, int>{};
      for (final misterio in misteriosResultado) {
        final lista =
            await repositorio.obtenerObservaciones(misterioId: misterio.id);
        evidencias[misterio.id] = lista.length;
      }
      _sitSpot = sitSpotResultado;
      _misteriosAbiertos = misteriosResultado;
      _ultimasObservaciones = ultimas;
      _evidenciasPorMisterio = evidencias;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
