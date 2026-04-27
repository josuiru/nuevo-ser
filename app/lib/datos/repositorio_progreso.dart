import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/habilidad.dart';
import '../dominio/rango_narrativo.dart';
import '../dominio/ritmo_juego.dart';
import '../dominio/tutor/disparador_tutor.dart';

/// Persistencia del progreso del jugador, ahora con soporte multi-perfil:
/// cada perfil guarda su propio estado bajo el prefijo
/// `uroto.perfil.<id>.<sufijo>`. El perfil activo se recuerda en la clave
/// global `uroto.perfil_activo_id`.
///
/// Al arrancar con un progreso anterior (claves `uroto.<sufijo>`), se
/// migran automáticamente al perfil `principal` la primera vez, para que
/// ningún niño pierda su partida por el cambio.
class RepositorioProgreso {
  static const _claveIdPerfilActivo = 'uroto.perfil_activo_id';
  static const _claveListaPerfiles = 'uroto.perfiles_lista';
  static const _claveTokenBackend = 'uroto.token_backend';
  static const idPerfilPorDefecto = 'principal';

  // Sufijos (sin prefijo de perfil).
  static const _sufSiguienteNoche = 'siguiente_noche';
  static const _sufUltimaAperturaMs = 'ultima_apertura_ms';
  static const _sufYaVioApertura = 'ya_vio_apertura';
  static const _sufEsquirlasTotal = 'esquirlas_total';
  static const _sufNombreJugador = 'nombre_jugador';
  static const _sufRangoActual = 'rango_actual';
  static const _sufVariantesEntrenamientoUsadas =
      'variantes_entrenamiento_usadas';
  static const _sufVariantesPuentesUsadas = 'variantes_puentes_usadas';
  static const _sufRitmoJuego = 'ritmo_juego';
  static const _prefijoCuadernoLeida = 'cuaderno.leida.';
  static const _prefijoDistritoVisitado = 'distrito_visitado.';
  static const _prefijoFlagNarrativo = 'flag.';
  static const _prefijoHabilidad = 'habilidad.';
  static const _prefijoEstadoTutor = 'tutor.estado.';
  static const _sufAudioModoSilencio = 'audio.modo_silencio';
  static const _prefijoAudioVolumenCapa = 'audio.volumen.';

  static String _prefijoDePerfil(String idPerfil) =>
      'uroto.perfil.$idPerfil.';

  Future<SharedPreferences> _prefs() async {
    final prefs = await SharedPreferences.getInstance();
    await _migrarSiHaceFalta(prefs);
    return prefs;
  }

  /// Migración única: si nunca se ha establecido un perfil activo pero
  /// existen claves `uroto.xxx` heredadas, las movemos al perfil
  /// `principal` y lo dejamos como activo.
  Future<void> _migrarSiHaceFalta(SharedPreferences prefs) async {
    if (prefs.getString(_claveIdPerfilActivo) != null) return;

    final todasLasClaves = prefs.getKeys().toList();
    final clavesHeredadas = todasLasClaves
        .where((clave) =>
            clave.startsWith('uroto.') &&
            !clave.startsWith('uroto.perfil.') &&
            clave != _claveIdPerfilActivo &&
            clave != _claveListaPerfiles)
        .toList();

    final prefijoDestino = _prefijoDePerfil(idPerfilPorDefecto);
    for (final claveAntigua in clavesHeredadas) {
      final sufijo = claveAntigua.substring('uroto.'.length);
      final claveNueva = '$prefijoDestino$sufijo';
      final valor = prefs.get(claveAntigua);
      if (valor is bool) {
        await prefs.setBool(claveNueva, valor);
      } else if (valor is int) {
        await prefs.setInt(claveNueva, valor);
      } else if (valor is double) {
        await prefs.setDouble(claveNueva, valor);
      } else if (valor is String) {
        await prefs.setString(claveNueva, valor);
      } else if (valor is List<String>) {
        await prefs.setStringList(claveNueva, valor);
      }
      await prefs.remove(claveAntigua);
    }

    await prefs.setString(_claveIdPerfilActivo, idPerfilPorDefecto);
    await prefs.setStringList(
      _claveListaPerfiles,
      [idPerfilPorDefecto],
    );
  }

  Future<String> idPerfilActivo() async {
    final prefs = await _prefs();
    return prefs.getString(_claveIdPerfilActivo) ?? idPerfilPorDefecto;
  }

  Future<String> _prefijoActivo() async {
    final id = await idPerfilActivo();
    return _prefijoDePerfil(id);
  }

  Future<String> _clave(String sufijo) async =>
      '${await _prefijoActivo()}$sufijo';

  // ═══ Token del backend (global, no por-perfil) ═══

  /// Token JWT del backend para llamadas al tutor / sync. Es global
  /// (todos los perfiles del dispositivo comparten autenticación) —
  /// la separación lógica entre niños la lleva el backend con el
  /// `nino_id` codificado en el propio token.
  Future<String?> cargarTokenBackend() async {
    final prefs = await _prefs();
    return prefs.getString(_claveTokenBackend);
  }

  Future<void> guardarTokenBackend(String token) async {
    final prefs = await _prefs();
    await prefs.setString(_claveTokenBackend, token);
  }

  Future<void> borrarTokenBackend() async {
    final prefs = await _prefs();
    await prefs.remove(_claveTokenBackend);
  }

  // ═══ Gestión de perfiles ═══

  /// Devuelve la lista de identificadores de perfil.
  Future<List<String>> listarPerfiles() async {
    final prefs = await _prefs();
    return prefs.getStringList(_claveListaPerfiles) ??
        [idPerfilPorDefecto];
  }

  /// Devuelve cada perfil con su nombre visible (si lo tiene guardado).
  /// Si un perfil no ha guardado nombre aún, usa el propio id como nombre.
  Future<List<PerfilInfo>> listarPerfilesConInfo() async {
    final prefs = await _prefs();
    final ids = prefs.getStringList(_claveListaPerfiles) ??
        [idPerfilPorDefecto];
    final activo = prefs.getString(_claveIdPerfilActivo) ??
        idPerfilPorDefecto;
    final resultado = <PerfilInfo>[];
    for (final id in ids) {
      final claveNombre =
          '${_prefijoDePerfil(id)}$_sufNombreJugador';
      final nombreGuardado = prefs.getString(claveNombre);
      final nombre = (nombreGuardado == null || nombreGuardado.trim().isEmpty)
          ? id
          : nombreGuardado;
      resultado.add(PerfilInfo(
        id: id,
        nombreVisible: nombre,
        esActivo: id == activo,
      ));
    }
    return resultado;
  }

  /// Crea un perfil derivando el id del nombre propuesto (slug). Si el id
  /// colisiona, añade sufijo numérico. Guarda el nombre dentro del
  /// perfil y devuelve el id final.
  Future<String> crearPerfil(String nombreVisible) async {
    final prefs = await _prefs();
    final existentes = await listarPerfiles();
    final idBase = _slugificar(nombreVisible);
    var idCandidato = idBase.isEmpty ? 'perfil' : idBase;
    var sufijoNum = 2;
    while (existentes.contains(idCandidato)) {
      idCandidato = '${idBase.isEmpty ? 'perfil' : idBase}$sufijoNum';
      sufijoNum++;
    }
    final nuevaLista = [...existentes, idCandidato];
    await prefs.setStringList(_claveListaPerfiles, nuevaLista);
    await prefs.setString(
      '${_prefijoDePerfil(idCandidato)}$_sufNombreJugador',
      nombreVisible.trim(),
    );
    return idCandidato;
  }

  /// Cambia el perfil activo. Si el id no existe, no hace nada.
  Future<void> cambiarAPerfil(String idPerfil) async {
    final prefs = await _prefs();
    final existentes = await listarPerfiles();
    if (!existentes.contains(idPerfil)) return;
    await prefs.setString(_claveIdPerfilActivo, idPerfil);
  }

  /// Borra todas las claves de un perfil. Si era el activo, pasa al
  /// primero restante; si no queda ninguno, recrea `principal` vacío.
  Future<void> borrarPerfil(String idPerfil) async {
    final prefs = await _prefs();
    final existentes = await listarPerfiles();
    if (!existentes.contains(idPerfil)) return;

    final prefijoABorrar = _prefijoDePerfil(idPerfil);
    final clavesDelPerfil = prefs
        .getKeys()
        .where((clave) => clave.startsWith(prefijoABorrar))
        .toList();
    for (final clave in clavesDelPerfil) {
      await prefs.remove(clave);
    }

    final listaRestante =
        existentes.where((id) => id != idPerfil).toList();
    if (listaRestante.isEmpty) {
      await prefs.setStringList(
        _claveListaPerfiles,
        [idPerfilPorDefecto],
      );
      await prefs.setString(_claveIdPerfilActivo, idPerfilPorDefecto);
    } else {
      await prefs.setStringList(_claveListaPerfiles, listaRestante);
      final activoActual = prefs.getString(_claveIdPerfilActivo);
      if (activoActual == idPerfil) {
        await prefs.setString(_claveIdPerfilActivo, listaRestante.first);
      }
    }
  }

  String _slugificar(String texto) {
    final minus = texto.toLowerCase().trim();
    final buffer = StringBuffer();
    for (final unidad in minus.runes) {
      final caracter = String.fromCharCode(unidad);
      if (RegExp(r'[a-z0-9]').hasMatch(caracter)) {
        buffer.write(caracter);
      } else if (caracter == ' ' || caracter == '-' || caracter == '_') {
        if (buffer.isNotEmpty &&
            !buffer.toString().endsWith('_')) {
          buffer.write('_');
        }
      } else if ('áàä'.contains(caracter)) {
        buffer.write('a');
      } else if ('éèë'.contains(caracter)) {
        buffer.write('e');
      } else if ('íìï'.contains(caracter)) {
        buffer.write('i');
      } else if ('óòö'.contains(caracter)) {
        buffer.write('o');
      } else if ('úùü'.contains(caracter)) {
        buffer.write('u');
      } else if (caracter == 'ñ') {
        buffer.write('n');
      }
    }
    var resultado = buffer.toString();
    while (resultado.endsWith('_')) {
      resultado = resultado.substring(0, resultado.length - 1);
    }
    return resultado;
  }

  // ═══ Progreso del perfil activo ═══

  Future<int> cargarSiguienteNoche() async {
    final prefs = await _prefs();
    return prefs.getInt(await _clave(_sufSiguienteNoche)) ?? 0;
  }

  Future<void> guardarSiguienteNoche(int indice) async {
    final prefs = await _prefs();
    await prefs.setInt(await _clave(_sufSiguienteNoche), indice);
  }

  Future<bool> yaVioLaApertura() async {
    final prefs = await _prefs();
    return prefs.getBool(await _clave(_sufYaVioApertura)) ?? false;
  }

  Future<void> marcarAperturaVista() async {
    final prefs = await _prefs();
    await prefs.setBool(await _clave(_sufYaVioApertura), true);
  }

  Future<String?> cargarNombreJugador() async {
    final prefs = await _prefs();
    final nombre = prefs.getString(await _clave(_sufNombreJugador));
    if (nombre == null || nombre.trim().isEmpty) return null;
    return nombre;
  }

  Future<void> guardarNombreJugador(String nombre) async {
    final prefs = await _prefs();
    await prefs.setString(await _clave(_sufNombreJugador), nombre.trim());
  }

  Future<RangoNarrativo> cargarRango() async {
    final prefs = await _prefs();
    final guardado = prefs.getInt(await _clave(_sufRangoActual)) ?? 0;
    final indice = guardado.clamp(0, RangoNarrativo.values.length - 1);
    return RangoNarrativo.values[indice];
  }

  Future<void> guardarRango(RangoNarrativo rango) async {
    final prefs = await _prefs();
    await prefs.setInt(await _clave(_sufRangoActual), rango.valor);
  }

  Future<Set<String>> cargarVariantesEntrenamientoUsadas() async {
    final prefs = await _prefs();
    final lista = prefs
            .getStringList(await _clave(_sufVariantesEntrenamientoUsadas)) ??
        [];
    return lista.toSet();
  }

  Future<void> marcarVarianteEntrenamientoUsada(String id) async {
    final prefs = await _prefs();
    final usadas = await cargarVariantesEntrenamientoUsadas();
    if (usadas.contains(id)) return;
    usadas.add(id);
    await prefs.setStringList(
      await _clave(_sufVariantesEntrenamientoUsadas),
      usadas.toList(),
    );
  }

  Future<void> resetearVariantesEntrenamiento() async {
    final prefs = await _prefs();
    await prefs.remove(await _clave(_sufVariantesEntrenamientoUsadas));
  }

  Future<Set<String>> cargarVariantesPuentesUsadas() async {
    final prefs = await _prefs();
    final lista =
        prefs.getStringList(await _clave(_sufVariantesPuentesUsadas)) ?? [];
    return lista.toSet();
  }

  Future<void> marcarVariantePuenteUsada(String id) async {
    final prefs = await _prefs();
    final usadas = await cargarVariantesPuentesUsadas();
    if (usadas.contains(id)) return;
    usadas.add(id);
    await prefs.setStringList(
      await _clave(_sufVariantesPuentesUsadas),
      usadas.toList(),
    );
  }

  Future<void> resetearVariantesPuentes() async {
    final prefs = await _prefs();
    await prefs.remove(await _clave(_sufVariantesPuentesUsadas));
  }

  Future<RitmoJuego> cargarRitmo() async {
    final prefs = await _prefs();
    final guardado = prefs.getInt(await _clave(_sufRitmoJuego)) ??
        RitmoJuego.estandar.valor;
    final indice = guardado.clamp(0, RitmoJuego.values.length - 1);
    return RitmoJuego.values[indice];
  }

  Future<void> guardarRitmo(RitmoJuego ritmo) async {
    final prefs = await _prefs();
    await prefs.setInt(await _clave(_sufRitmoJuego), ritmo.valor);
  }

  /// Preferencias de audio del perfil activo. El volumen de cada capa
  /// se guarda en 0..100; el motor lo traduce a 0.0..1.0.
  Future<bool> cargarAudioModoSilencio() async {
    final prefs = await _prefs();
    return prefs.getBool(await _clave(_sufAudioModoSilencio)) ?? false;
  }

  Future<void> guardarAudioModoSilencio(bool silencio) async {
    final prefs = await _prefs();
    await prefs.setBool(await _clave(_sufAudioModoSilencio), silencio);
  }

  Future<int> cargarAudioVolumenCapa(
    String claveCapa, {
    required int predeterminado,
  }) async {
    final prefs = await _prefs();
    final guardado = prefs.getInt(
      await _clave('$_prefijoAudioVolumenCapa$claveCapa'),
    );
    if (guardado == null) return predeterminado;
    return guardado.clamp(0, 100);
  }

  Future<void> guardarAudioVolumenCapa(String claveCapa, int valor) async {
    final prefs = await _prefs();
    await prefs.setInt(
      await _clave('$_prefijoAudioVolumenCapa$claveCapa'),
      valor.clamp(0, 100),
    );
  }

  Future<bool> entradaCuadernoLeida(String idEntrada) async {
    final prefs = await _prefs();
    return prefs
            .getBool(await _clave('$_prefijoCuadernoLeida$idEntrada')) ??
        false;
  }

  Future<void> marcarEntradaCuadernoLeida(String idEntrada) async {
    final prefs = await _prefs();
    await prefs.setBool(
      await _clave('$_prefijoCuadernoLeida$idEntrada'),
      true,
    );
  }

  /// Asegura que el rango sea al menos [minimo]. Si ya es igual o
  /// superior, no hace nada y devuelve `false`. Si sube, persiste el
  /// nuevo rango, activa su `flagAlcanzado` y devuelve `true`.
  Future<bool> forzarRangoMinimo(RangoNarrativo minimo) async {
    final actual = await cargarRango();
    if (actual.valor >= minimo.valor) return false;
    await guardarRango(minimo);
    await activarFlagNarrativo(minimo.flagAlcanzado);
    return true;
  }

  Future<DateTime?> cargarUltimaApertura() async {
    final prefs = await _prefs();
    final ms = prefs.getInt(await _clave(_sufUltimaAperturaMs));
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> guardarAhoraComoUltimaApertura() async {
    final prefs = await _prefs();
    await prefs.setInt(
      await _clave(_sufUltimaAperturaMs),
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<int> cargarEsquirlas() async {
    final prefs = await _prefs();
    return prefs.getInt(await _clave(_sufEsquirlasTotal)) ?? 0;
  }

  Future<void> guardarEsquirlas(int total) async {
    final prefs = await _prefs();
    await prefs.setInt(await _clave(_sufEsquirlasTotal), total);
  }

  Future<bool> distritoVisitado(String idDistrito) async {
    final prefs = await _prefs();
    return prefs
            .getBool(await _clave('$_prefijoDistritoVisitado$idDistrito')) ??
        false;
  }

  Future<void> marcarDistritoComoVisitado(String idDistrito) async {
    final prefs = await _prefs();
    await prefs.setBool(
      await _clave('$_prefijoDistritoVisitado$idDistrito'),
      true,
    );
  }

  Future<bool> flagNarrativoActivo(String flag) async {
    final prefs = await _prefs();
    return prefs.getBool(await _clave('$_prefijoFlagNarrativo$flag')) ??
        false;
  }

  Future<void> activarFlagNarrativo(String flag) async {
    final prefs = await _prefs();
    await prefs.setBool(await _clave('$_prefijoFlagNarrativo$flag'), true);
  }

  Future<EstadoHabilidad?> cargarEstadoHabilidad(String idHabilidad) async {
    final prefs = await _prefs();
    final clave = await _clave('$_prefijoHabilidad$idHabilidad');
    final texto = prefs.getString(clave);
    if (texto == null) return null;
    try {
      return EstadoHabilidad.desdeJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );
    } catch (_) {
      // Formato corrupto: borramos para no bloquear al niño.
      await prefs.remove(clave);
      return null;
    }
  }

  Future<void> guardarEstadoHabilidad(EstadoHabilidad estado) async {
    final prefs = await _prefs();
    await prefs.setString(
      await _clave('$_prefijoHabilidad${estado.identificadorHabilidad}'),
      jsonEncode(estado.aJson()),
    );
  }

  /// Estado del tutor para una habilidad concreta (fallos consecutivos,
  /// última oferta, veces usado). Por-perfil — no queremos que un niño
  /// vea el contador de otro.
  Future<EstadoTutorHabilidad> cargarEstadoTutor(String idHabilidad) async {
    final prefs = await _prefs();
    final clave = await _clave('$_prefijoEstadoTutor$idHabilidad');
    final texto = prefs.getString(clave);
    if (texto == null) return const EstadoTutorHabilidad();
    try {
      return EstadoTutorHabilidad.desdeJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );
    } catch (_) {
      await prefs.remove(clave);
      return const EstadoTutorHabilidad();
    }
  }

  Future<void> guardarEstadoTutor(
    String idHabilidad,
    EstadoTutorHabilidad estado,
  ) async {
    final prefs = await _prefs();
    await prefs.setString(
      await _clave('$_prefijoEstadoTutor$idHabilidad'),
      jsonEncode(estado.aJson()),
    );
  }

  /// Borra el progreso del perfil activo (sin eliminar el perfil ni
  /// afectar a otros perfiles).
  Future<void> reiniciar() async {
    final prefs = await _prefs();
    final prefijo = await _prefijoActivo();
    // Conservamos el nombre del jugador para no forzarle a repetirlo.
    final nombre = prefs.getString('$prefijo$_sufNombreJugador');
    final claves =
        prefs.getKeys().where((k) => k.startsWith(prefijo)).toList();
    for (final clave in claves) {
      await prefs.remove(clave);
    }
    if (nombre != null && nombre.trim().isNotEmpty) {
      await prefs.setString('$prefijo$_sufNombreJugador', nombre);
    }
  }

  /// Exporta el estado del perfil activo para `POST /sync/progress`.
  Future<Map<String, dynamic>> exportarProgresoParaSync() async {
    final prefs = await _prefs();
    final prefijo = await _prefijoActivo();
    final prefijoFlags = '$prefijo$_prefijoFlagNarrativo';
    final flags = <String, bool>{};
    for (final clave in prefs.getKeys()) {
      if (clave.startsWith(prefijoFlags)) {
        final nombre = clave.substring(prefijoFlags.length);
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

  /// Aplica sobre el perfil activo el estado devuelto por el servidor.
  Future<void> importarProgresoDesdeSync(
      Map<String, dynamic> progreso) async {
    final nombre = progreso['nombre_jugador'] as String? ?? '';
    if (nombre.isNotEmpty) await guardarNombreJugador(nombre);
    await guardarEsquirlas(
        (progreso['esquirlas_total'] as num?)?.toInt() ?? 0);
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

/// Información resumen de un perfil, para listarlos en la pantalla de
/// selección.
class PerfilInfo {
  final String id;
  final String nombreVisible;
  final bool esActivo;

  const PerfilInfo({
    required this.id,
    required this.nombreVisible,
    required this.esActivo,
  });
}
