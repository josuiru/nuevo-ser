import 'package:flutter/foundation.dart';

import '../../dominio/contexto_misterio.dart';
import '../../dominio/fenologia.dart';
import '../../dominio/geolocalizacion_privacy_first.dart';
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
///
/// **Filtrado fenológico** (biblia §5.3 + doc 06 §4): tras leer los
/// Misterios abiertos del repositorio, el estado los filtra al
/// contexto actual del niño (estación astronómica + región derivada
/// del sit spot). Se inyecta [proveedorAhora] para tests deterministas
/// — los tests fijan la fecha y comprueban qué Misterios sobreviven al
/// filtro. Si el sit spot tiene `coordenadas`, se deriva su region NUTS
/// con [normalizarRegion]; sin coordenadas, no se filtra por región
/// (más amable mostrar el catálogo entero que recortar por una región
/// arbitraria). El filtrado **no toca el repo** — la página de un
/// Misterio sigue accesible vía anclajes históricos del cuaderno.
class EstadoCuaderno extends ChangeNotifier {
  EstadoCuaderno({
    required this.repositorio,
    DateTime Function()? proveedorAhora,
    String? Function(SitSpot? sitSpot)? proveedorRegion,
  })  : _proveedorAhora = proveedorAhora ?? DateTime.now,
        _proveedorRegion = proveedorRegion ?? _regionPorDefecto;

  final RepositorioLocal repositorio;
  final DateTime Function() _proveedorAhora;
  final String? Function(SitSpot? sitSpot) _proveedorRegion;

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
      final misteriosCrudo = await repositorio.obtenerMisteriosAbiertos();
      final ultimas = await repositorio.obtenerObservaciones(limite: 5);
      final estacionActual = estacionDeFecha(_proveedorAhora());
      final regionActual = _proveedorRegion(sitSpotResultado);
      final misteriosFiltrados = filtrarMisteriosAlContexto(
        misteriosCrudo,
        estacionActual: estacionActual,
        regionActual: regionActual,
      );
      // Conteo por Misterio: una observación por cada id abierto. La
      // alternativa sería leer `misterio.observacionesIds.length`, pero
      // el query es la fuente de verdad — observacionesIds del modelo
      // puede arrastrar drift si en el futuro alguien guarda una
      // observación bypass del helper de anclar.
      final evidencias = <String, int>{};
      for (final misterio in misteriosFiltrados) {
        final lista =
            await repositorio.obtenerObservaciones(misterioId: misterio.id);
        evidencias[misterio.id] = lista.length;
      }
      _sitSpot = sitSpotResultado;
      _misteriosAbiertos = misteriosFiltrados;
      _ultimasObservaciones = ultimas;
      _evidenciasPorMisterio = evidencias;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}

/// Default del proveedor de región: si el sit spot tiene coordenadas,
/// las normaliza a un region_code NUTS; si no, devuelve `null` (sin
/// filtro de región). Vive fuera de la clase para que el constructor
/// pueda referenciarla como tear-off; el override en tests es trivial.
String? _regionPorDefecto(SitSpot? sitSpot) {
  final coordenadas = sitSpot?.coordenadas;
  if (coordenadas == null) return null;
  return normalizarRegion(coordenadas);
}
