import 'package:shared_preferences/shared_preferences.dart';

import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import '../dominio/progreso_arco.dart';
import '../dominio/rango_narrativo.dart';
import '../dominio/ritmo_juego.dart';
import 'package:nuevo_ser_tutor/nuevo_ser_tutor.dart';

// Re-exporta PerfilInfo para que la pantalla de selección no necesite
// importar nuevo_ser_core directamente — la API histórica del
// repositorio incluye este tipo.
export 'package:nuevo_ser_core/nuevo_ser_core.dart' show PerfilInfo;

/// Persistencia del progreso del jugador, con soporte multi-perfil
/// delegado en [GestorPerfiles] (`packages/nuevo_ser_core`):
/// cada perfil guarda su propio estado bajo el prefijo
/// `uroto.perfil.<id>.<sufijo>`. El perfil activo se recuerda en la clave
/// global `uroto.perfil_activo_id`.
///
/// Al arrancar con un progreso anterior (claves `uroto.<sufijo>`), el
/// gestor las migra automáticamente al perfil `principal` la primera
/// vez, para que ningún niño pierda su partida por el cambio.
class RepositorioProgreso {
  static const _claveTokenBackend = 'uroto.token_backend';
  static const _claveEmailBackend = 'uroto.email_backend';
  static const _claveVersionPaqueteAudio = 'uroto.audio.version_local';
  static const _claveAudioSugerenciaVista = 'uroto.audio.sugerencia_vista';
  static const _claveIdiomaApp = 'uroto.idioma_app';
  static const idPerfilPorDefecto = GestorPerfiles.idPerfilPorDefecto;

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
  static const _sufVariantesMaquinasUsadas = 'variantes_maquinas_usadas';
  static const _sufRitmoJuego = 'ritmo_juego';
  static const _sufRutaAvatar = 'avatar.ruta';
  static const _prefijoCuadernoLeida = 'cuaderno.leida.';
  static const _prefijoDistritoVisitado = 'distrito_visitado.';
  static const _prefijoFlagNarrativo = 'flag.';
  static const _sufAudioModoSilencio = 'audio.modo_silencio';
  static const _prefijoAudioVolumenCapa = 'audio.volumen.';

  /// Gestor de perfiles del juego — la lógica de identificación,
  /// listado, creación, borrado y migración legada vive en la
  /// plataforma. El repositorio sólo le pasa la whitelist de claves
  /// globales (token, idioma, versión de audio…) que NO deben moverse
  /// al prefijo del perfil cuando se migra desde versiones pre-perfiles.
  final GestorPerfiles _gestor = GestorPerfiles(
    namespace: 'uroto',
    sufijoNombreVisible: _sufNombreJugador,
    clavesGlobalesNoMigrables: const {
      _claveTokenBackend,
      _claveEmailBackend,
      _claveVersionPaqueteAudio,
      _claveAudioSugerenciaVista,
      _claveIdiomaApp,
    },
  );

  /// Persistencia de [EstadoHabilidad] sobre el gestor activo. Los
  /// métodos públicos del repositorio que tocan habilidades delegan
  /// aquí.
  late final RepositorioHabilidades _repoHabilidades =
      RepositorioHabilidades(gestor: _gestor);

  /// Persistencia de [EstadoTutorHabilidad] sobre el gestor activo.
  /// Expuesto para el `ServicioTutor` (que vive en `nuevo_ser_tutor`),
  /// los call-sites lo pasan al constructor del servicio.
  late final RepositorioEstadoTutor estadoTutor =
      RepositorioEstadoTutor(gestor: _gestor);

  /// Preferencias de audio del perfil activo (modo silencio + volumen
  /// por capa). Sufijo y prefijo conservan el shape histórico.
  late final RepositorioPreferenciasAudio _preferenciasAudio =
      RepositorioPreferenciasAudio(
    gestor: _gestor,
    sufijoModoSilencio: _sufAudioModoSilencio,
    prefijoVolumenCapa: _prefijoAudioVolumenCapa,
  );

  /// Cuenta del backend (token JWT + email) — global, no por-perfil.
  /// Las claves conservan el shape histórico de Uno Roto.
  late final RepositorioCuentaBackend _cuentaBackend = RepositorioCuentaBackend(
    prefs: SharedPreferences.getInstance,
    claveToken: _claveTokenBackend,
    claveEmail: _claveEmailBackend,
  );

  /// Idioma elegido en el primer arranque — clave global compartida
  /// entre perfiles. La whitelist de claves no migrables (arriba) lo
  /// conserva al migrar progresos pre-perfiles.
  late final RepositorioIdiomaApp _repoIdiomaApp = RepositorioIdiomaApp(
    prefs: SharedPreferences.getInstance,
    clave: _claveIdiomaApp,
  );

  /// Versión del paquete sonoro descargable instalado localmente —
  /// pareja directa de `DescargadorAudio` (los callbacks
  /// leerVersion/escribirVersion/borrarVersion delegan aquí). Clave
  /// global compartida entre perfiles.
  late final RepositorioVersionPaqueteAudio _repoVersionPaqueteAudio =
      RepositorioVersionPaqueteAudio(
    prefs: SharedPreferences.getInstance,
    clave: _claveVersionPaqueteAudio,
  );

  Future<SharedPreferences> _prefs() => _gestor.prefsInicializadas();

  Future<String> idPerfilActivo() => _gestor.idPerfilActivo();

  Future<String> _prefijoActivo() => _gestor.prefijoActivo();

  Future<String> _clave(String sufijo) async =>
      '${await _prefijoActivo()}$sufijo';

  // ═══ Cuenta del backend (global, no por-perfil) ═══
  // Delegada a RepositorioCuentaBackend del core. La API se mantiene
  // idéntica para no tocar los call-sites (pantalla_caza,
  // pantalla_login, main…).

  Future<String?> cargarTokenBackend() => _cuentaBackend.cargarToken();

  Future<void> guardarTokenBackend(String token) =>
      _cuentaBackend.guardarToken(token);

  Future<void> borrarTokenBackend() => _cuentaBackend.borrarToken();

  Future<String?> cargarEmailBackend() => _cuentaBackend.cargarEmail();

  Future<void> guardarEmailBackend(String email) =>
      _cuentaBackend.guardarEmail(email);

  Future<void> borrarEmailBackend() => _cuentaBackend.borrarEmail();

  /// Versión del paquete sonoro descargable instalado localmente.
  /// Es global (compartido entre perfiles — los OGG no dependen de qué
  /// niño juega). null si nunca se descargó. El `DescargadorAudio` del
  /// core consulta esto a través de los callbacks de su constructor.
  Future<int?> cargarVersionPaqueteAudio() =>
      _repoVersionPaqueteAudio.cargar();

  Future<void> guardarVersionPaqueteAudio(int version) =>
      _repoVersionPaqueteAudio.guardar(version);

  Future<void> borrarVersionPaqueteAudio() => _repoVersionPaqueteAudio.borrar();

  /// Si el aviso "¿quieres descargar el paquete de sonido?" ya se
  /// mostró al niño/adulto. Es global (no tiene sentido reofrecerlo
  /// por cada perfil) y se persiste a `true` en cuanto el banner se
  /// dismisses, así no reaparece nunca aunque rechace.
  Future<bool> cargarAudioSugerenciaVista() async {
    final prefs = await _prefs();
    return prefs.getBool(_claveAudioSugerenciaVista) ?? false;
  }

  Future<void> marcarAudioSugerenciaVista() async {
    final prefs = await _prefs();
    await prefs.setBool(_claveAudioSugerenciaVista, true);
  }

  /// Idioma elegido manualmente por el niño en la pantalla de
  /// configuración inicial. Es global (no por-perfil): la elección se
  /// hace antes de cualquier perfil. Valores: 'es', 'eu', 'ca'. null si
  /// no se ha elegido todavía — el orquestador lo interpreta como
  /// "primer arranque, mostrar configuración inicial".
  Future<String?> cargarIdiomaApp() => _repoIdiomaApp.cargar();

  Future<void> guardarIdiomaApp(String codigoIdioma) =>
      _repoIdiomaApp.guardar(codigoIdioma);

  /// Atajo: borra token y email a la vez, equivalente a "cerrar sesión".
  Future<void> cerrarSesionBackend() => _cuentaBackend.cerrarSesion();

  // ═══ Gestión de perfiles ═══
  // Delegada al GestorPerfiles del core. La API se mantiene idéntica
  // para que los call-sites de pantalla_perfiles, main, etc. no
  // cambien.

  Future<List<String>> listarPerfiles() => _gestor.listarPerfiles();

  Future<List<PerfilInfo>> listarPerfilesConInfo() =>
      _gestor.listarPerfilesConInfo();

  Future<String> crearPerfil(String nombreVisible) =>
      _gestor.crearPerfil(nombreVisible);

  Future<void> cambiarAPerfil(String idPerfil) =>
      _gestor.cambiarAPerfil(idPerfil);

  Future<void> borrarPerfil(String idPerfil) =>
      _gestor.borrarPerfil(idPerfil);

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

  /// Ruta absoluta a la imagen-avatar del niño (foto de su dibujo en
  /// papel, o cualquier imagen elegida desde la galería). Se persiste
  /// **por perfil** — cada niño tiene su propio personaje. La imagen
  /// vive bajo el directorio de documentos de la app, así que la
  /// ruta es estable mientras la app esté instalada.
  ///
  /// `null` significa "todavía no ha subido nada" — la vista cae al
  /// avatar genérico (Icons.person en círculo violeta).
  Future<String?> cargarRutaAvatar() async {
    final prefs = await _prefs();
    final ruta = prefs.getString(await _clave(_sufRutaAvatar));
    if (ruta == null || ruta.trim().isEmpty) return null;
    return ruta;
  }

  Future<void> guardarRutaAvatar(String ruta) async {
    final prefs = await _prefs();
    await prefs.setString(await _clave(_sufRutaAvatar), ruta);
  }

  Future<void> borrarRutaAvatar() async {
    final prefs = await _prefs();
    await prefs.remove(await _clave(_sufRutaAvatar));
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

  Future<Set<String>> cargarVariantesMaquinasUsadas() async {
    final prefs = await _prefs();
    final lista =
        prefs.getStringList(await _clave(_sufVariantesMaquinasUsadas)) ?? [];
    return lista.toSet();
  }

  Future<void> marcarVarianteMaquinaUsada(String id) async {
    final prefs = await _prefs();
    final usadas = await cargarVariantesMaquinasUsadas();
    if (usadas.contains(id)) return;
    usadas.add(id);
    await prefs.setStringList(
      await _clave(_sufVariantesMaquinasUsadas),
      usadas.toList(),
    );
  }

  Future<void> resetearVariantesMaquinas() async {
    final prefs = await _prefs();
    await prefs.remove(await _clave(_sufVariantesMaquinasUsadas));
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
  Future<bool> cargarAudioModoSilencio() =>
      _preferenciasAudio.cargarModoSilencio();

  Future<void> guardarAudioModoSilencio(bool silencio) =>
      _preferenciasAudio.guardarModoSilencio(silencio);

  Future<int> cargarAudioVolumenCapa(
    String claveCapa, {
    required int predeterminado,
  }) =>
      _preferenciasAudio.cargarVolumenCapa(
        claveCapa,
        predeterminado: predeterminado,
      );

  Future<void> guardarAudioVolumenCapa(String claveCapa, int valor) =>
      _preferenciasAudio.guardarVolumenCapa(claveCapa, valor);

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

  Future<EstadoHabilidad?> cargarEstadoHabilidad(String idHabilidad) =>
      _repoHabilidades.cargar(idHabilidad);

  Future<void> guardarEstadoHabilidad(EstadoHabilidad estado) =>
      _repoHabilidades.guardar(estado);

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

  /// Exporta los estados de habilidades del perfil activo en el shape
  /// que espera el backend WP (`/sync/progress`). Si una habilidad no
  /// tiene estado guardado, no se incluye.
  Future<List<Map<String, dynamic>>> exportarHabilidadesParaSync() =>
      _repoHabilidades.exportarParaSync();

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
    final ahoraMysql = aFechaMysql(ultima ?? DateTime.now());
    final arco = await ProgresoArco.arcoActual(flagNarrativoActivo);

    return {
      'nombre_jugador': await cargarNombreJugador() ?? '',
      'esquirlas_total': await cargarEsquirlas(),
      'rango': (await cargarRango()).valor,
      'arco_actual': arco.numero,
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

}
