import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/habilidad.dart';
import '../dominio/rango_narrativo.dart';
import '../dominio/ritmo_juego.dart';

/// Persistencia mínima del progreso del jugador: en qué noche va y
/// cuándo abrió la app por última vez. Todo local, sin sincronización,
/// coherente con el principio offline-first de la biblia §2.8.
class RepositorioProgreso {
  static const _claveSiguienteNoche = 'uroto.siguiente_noche';
  static const _claveUltimaAperturaMs = 'uroto.ultima_apertura_ms';
  static const _claveYaVioApertura = 'uroto.ya_vio_apertura';
  static const _claveEsquirlasTotal = 'uroto.esquirlas_total';
  static const _claveNombreJugador = 'uroto.nombre_jugador';
  static const _claveRangoActual = 'uroto.rango_actual';
  static const _claveVariantesEntrenamientoUsadas =
      'uroto.variantes_entrenamiento_usadas';
  static const _claveVariantesPuentesUsadas =
      'uroto.variantes_puentes_usadas';
  static const _claveRitmoJuego = 'uroto.ritmo_juego';

  Future<int> cargarSiguienteNoche() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_claveSiguienteNoche) ?? 0;
  }

  Future<void> guardarSiguienteNoche(int indice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveSiguienteNoche, indice);
  }

  Future<bool> yaVioLaApertura() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveYaVioApertura) ?? false;
  }

  Future<void> marcarAperturaVista() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveYaVioApertura, true);
  }

  Future<String?> cargarNombreJugador() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre = prefs.getString(_claveNombreJugador);
    if (nombre == null || nombre.trim().isEmpty) return null;
    return nombre;
  }

  Future<void> guardarNombreJugador(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveNombreJugador, nombre.trim());
  }

  Future<RangoNarrativo> cargarRango() async {
    final prefs = await SharedPreferences.getInstance();
    final guardado = prefs.getInt(_claveRangoActual) ?? 0;
    final indice = guardado.clamp(0, RangoNarrativo.values.length - 1);
    return RangoNarrativo.values[indice];
  }

  Future<void> guardarRango(RangoNarrativo rango) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveRangoActual, rango.valor);
  }

  Future<Set<String>> cargarVariantesEntrenamientoUsadas() async {
    final prefs = await SharedPreferences.getInstance();
    final lista =
        prefs.getStringList(_claveVariantesEntrenamientoUsadas) ?? [];
    return lista.toSet();
  }

  Future<void> marcarVarianteEntrenamientoUsada(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final usadas = await cargarVariantesEntrenamientoUsadas();
    if (usadas.contains(id)) return;
    usadas.add(id);
    await prefs.setStringList(
      _claveVariantesEntrenamientoUsadas,
      usadas.toList(),
    );
  }

  Future<void> resetearVariantesEntrenamiento() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveVariantesEntrenamientoUsadas);
  }

  Future<Set<String>> cargarVariantesPuentesUsadas() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_claveVariantesPuentesUsadas) ?? [];
    return lista.toSet();
  }

  Future<void> marcarVariantePuenteUsada(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final usadas = await cargarVariantesPuentesUsadas();
    if (usadas.contains(id)) return;
    usadas.add(id);
    await prefs.setStringList(
      _claveVariantesPuentesUsadas,
      usadas.toList(),
    );
  }

  Future<void> resetearVariantesPuentes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveVariantesPuentesUsadas);
  }

  Future<RitmoJuego> cargarRitmo() async {
    final prefs = await SharedPreferences.getInstance();
    final guardado = prefs.getInt(_claveRitmoJuego) ?? RitmoJuego.estandar.valor;
    final indice = guardado.clamp(0, RitmoJuego.values.length - 1);
    return RitmoJuego.values[indice];
  }

  Future<void> guardarRitmo(RitmoJuego ritmo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveRitmoJuego, ritmo.valor);
  }

  String _claveEntradaLeida(String idEntrada) =>
      'uroto.cuaderno.leida.$idEntrada';

  Future<bool> entradaCuadernoLeida(String idEntrada) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveEntradaLeida(idEntrada)) ?? false;
  }

  Future<void> marcarEntradaCuadernoLeida(String idEntrada) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveEntradaLeida(idEntrada), true);
  }

  /// Asegura que el rango sea al menos [minimo]. Si ya es igual o
  /// superior, no hace nada y devuelve `false`. Si sube, persiste el
  /// nuevo rango, activa su `flagAlcanzado` y devuelve `true`.
  /// Pensado para hitos narrativos que garantizan rango (kurz_3
  /// victoria → Aprendiz II), evitando que el niño quede sin escenas
  /// posteriores por no haber acumulado esquirlas suficientes.
  Future<bool> forzarRangoMinimo(RangoNarrativo minimo) async {
    final actual = await cargarRango();
    if (actual.valor >= minimo.valor) return false;
    await guardarRango(minimo);
    await activarFlagNarrativo(minimo.flagAlcanzado);
    return true;
  }

  Future<DateTime?> cargarUltimaApertura() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_claveUltimaAperturaMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> guardarAhoraComoUltimaApertura() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _claveUltimaAperturaMs,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<int> cargarEsquirlas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_claveEsquirlasTotal) ?? 0;
  }

  Future<void> guardarEsquirlas(int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveEsquirlasTotal, total);
  }

  String _claveDistritoVisitado(String idDistrito) =>
      'uroto.distrito_visitado.$idDistrito';

  Future<bool> distritoVisitado(String idDistrito) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveDistritoVisitado(idDistrito)) ?? false;
  }

  Future<void> marcarDistritoComoVisitado(String idDistrito) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveDistritoVisitado(idDistrito), true);
  }

  String _claveFlagNarrativo(String flag) => 'uroto.flag.$flag';

  Future<bool> flagNarrativoActivo(String flag) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveFlagNarrativo(flag)) ?? false;
  }

  Future<void> activarFlagNarrativo(String flag) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveFlagNarrativo(flag), true);
  }

  static String _claveEstadoHabilidad(String id) =>
      'uroto.habilidad.$id';

  Future<EstadoHabilidad?> cargarEstadoHabilidad(String idHabilidad) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_claveEstadoHabilidad(idHabilidad));
    if (texto == null) return null;
    try {
      return EstadoHabilidad.desdeJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );
    } catch (_) {
      // Formato corrupto: borramos para no bloquear al niño.
      await prefs.remove(_claveEstadoHabilidad(idHabilidad));
      return null;
    }
  }

  Future<void> guardarEstadoHabilidad(EstadoHabilidad estado) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _claveEstadoHabilidad(estado.identificadorHabilidad),
      jsonEncode(estado.aJson()),
    );
  }

  /// Útil para reiniciar desde el principio (modo desarrollo o niño que
  /// quiere rejugarlo desde cero).
  Future<void> reiniciar() async {
    final prefs = await SharedPreferences.getInstance();
    final todasLasClaves = prefs.getKeys();
    final clavesUroto =
        todasLasClaves.where((k) => k.startsWith('uroto.')).toList();
    for (final clave in clavesUroto) {
      await prefs.remove(clave);
    }
  }

  /// Exporta el estado local en el formato que espera
  /// `POST /sync/progress` del plugin WP. Los flags narrativos viven
  /// como claves `uroto.flag.<nombre>` con valor bool; aquí los
  /// empaquetamos en un mapa plano `{nombre: true}`.
  Future<Map<String, dynamic>> exportarProgresoParaSync() async {
    final prefs = await SharedPreferences.getInstance();
    final flags = <String, bool>{};
    for (final clave in prefs.getKeys()) {
      if (clave.startsWith('uroto.flag.')) {
        final nombre = clave.substring('uroto.flag.'.length);
        final valor = prefs.getBool(clave);
        if (valor == true) flags[nombre] = true;
      }
    }

    final ultima = await cargarUltimaApertura();
    final ahoraMysql = _aFechaMysql(ultima ?? DateTime.now());

    return {
      'nombre_jugador': await cargarNombreJugador() ?? '',
      'esquirlas_total': await cargarEsquirlas(),
      'rango': (await cargarRango()).valor,
      'arco_actual': 1,
      'flags': flags,
      'actualizado_en': ahoraMysql,
    };
  }

  /// Aplica el estado devuelto por `/sync/progress` o `/progress`.
  /// Si el servidor ganó el LWW y trae datos distintos, los
  /// persiste localmente.
  Future<void> importarProgresoDesdeSync(Map<String, dynamic> progreso) async {
    final nombre = progreso['nombre_jugador'] as String? ?? '';
    if (nombre.isNotEmpty) await guardarNombreJugador(nombre);
    await guardarEsquirlas((progreso['esquirlas_total'] as num?)?.toInt() ?? 0);
    final rangoIdx = (progreso['rango'] as num?)?.toInt() ?? 0;
    if (rangoIdx >= 0 && rangoIdx < RangoNarrativo.values.length) {
      await guardarRango(RangoNarrativo.values[rangoIdx]);
    }
    final flags = progreso['flags'];
    if (flags is Map) {
      for (final entry in flags.entries) {
        if (entry.value == true) {
          await activarFlagNarrativo(entry.key as String);
        }
      }
    }
  }

  String _aFechaMysql(DateTime fecha) {
    final utc = fecha.toUtc();
    String pad(int v, [int n = 2]) => v.toString().padLeft(n, '0');
    return '${utc.year}-${pad(utc.month)}-${pad(utc.day)} '
        '${pad(utc.hour)}:${pad(utc.minute)}:${pad(utc.second)}';
  }
}
