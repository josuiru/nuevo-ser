import 'package:shared_preferences/shared_preferences.dart';

/// Gestión multi-perfil sobre [SharedPreferences].
///
/// Cada juego de la Colección Nuevo Ser Kids tiene un namespace propio
/// (`uroto` para Uno Roto, `lasversiones` para Las Versiones…). Bajo ese
/// namespace se guardan:
///   - claves globales: `<ns>.<sufijo>` (token backend, idioma, versión
///     del paquete de audio). No se migran ni se duplican por perfil.
///   - claves por perfil: `<ns>.perfil.<id>.<sufijo>` (progreso, flags
///     narrativos, preferencias).
///
/// El gestor se encarga de:
///   - Recordar qué perfil está activo y su prefijo.
///   - Listar/crear/cambiar/borrar perfiles.
///   - Migrar una vez claves heredadas de versiones pre-perfiles
///     (`<ns>.<sufijo>`) al perfil `principal`, sin tocar las claves
///     globales que se le pasen como protegidas.
///
/// El gestor NO conoce el contenido del progreso (esquirlas, rangos,
/// flags…). Eso lo modela el repositorio específico de cada juego sobre
/// las claves que devuelve [prefijoActivo].
class GestorPerfiles {
  GestorPerfiles({
    required this.namespace,
    required this.sufijoNombreVisible,
    Set<String> clavesGlobalesNoMigrables = const {},
  }) : _clavesGlobales = clavesGlobalesNoMigrables;

  /// Identificador raíz del juego (`uroto`, `lasversiones`…). Determina
  /// el prefijo de todas las claves del juego.
  final String namespace;

  /// Sufijo (sin prefijo de perfil) bajo el que cada perfil guarda su
  /// nombre humano. Necesario para [listarPerfilesConInfo]. Por
  /// convención: `'nombre_jugador'`.
  final String sufijoNombreVisible;

  final Set<String> _clavesGlobales;

  /// Identificador del perfil con el que arranca un dispositivo limpio
  /// y al que se migran las claves heredadas de versiones pre-perfiles.
  static const idPerfilPorDefecto = 'principal';

  String get _claveIdPerfilActivo => '$namespace.perfil_activo_id';
  String get _claveListaPerfiles => '$namespace.perfiles_lista';

  /// Prefijo completo de las claves que pertenecen al [idPerfil] dado.
  String prefijoDePerfil(String idPerfil) =>
      '$namespace.perfil.$idPerfil.';

  /// Devuelve las preferencias ya inicializadas. La primera invocación
  /// dispara la migración silenciosa de claves heredadas si
  /// corresponde.
  Future<SharedPreferences> prefsInicializadas() async {
    final prefs = await SharedPreferences.getInstance();
    await _migrarSiHaceFalta(prefs);
    return prefs;
  }

  Future<void> _migrarSiHaceFalta(SharedPreferences prefs) async {
    if (prefs.getString(_claveIdPerfilActivo) != null) return;

    final globalesProtegidas = <String>{
      ..._clavesGlobales,
      _claveIdPerfilActivo,
      _claveListaPerfiles,
    };
    final prefijoLegado = '$namespace.';
    final prefijoYaMigrado = '$namespace.perfil.';

    final clavesHeredadas = prefs
        .getKeys()
        .where((clave) =>
            clave.startsWith(prefijoLegado) &&
            !clave.startsWith(prefijoYaMigrado) &&
            !globalesProtegidas.contains(clave))
        .toList();

    final destino = prefijoDePerfil(idPerfilPorDefecto);
    for (final claveAntigua in clavesHeredadas) {
      final sufijo = claveAntigua.substring(prefijoLegado.length);
      final claveNueva = '$destino$sufijo';
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
    final prefs = await prefsInicializadas();
    return prefs.getString(_claveIdPerfilActivo) ?? idPerfilPorDefecto;
  }

  Future<String> prefijoActivo() async {
    final id = await idPerfilActivo();
    return prefijoDePerfil(id);
  }

  Future<List<String>> listarPerfiles() async {
    final prefs = await prefsInicializadas();
    return prefs.getStringList(_claveListaPerfiles) ??
        [idPerfilPorDefecto];
  }

  Future<List<PerfilInfo>> listarPerfilesConInfo() async {
    final prefs = await prefsInicializadas();
    final ids = prefs.getStringList(_claveListaPerfiles) ??
        [idPerfilPorDefecto];
    final activo =
        prefs.getString(_claveIdPerfilActivo) ?? idPerfilPorDefecto;
    final resultado = <PerfilInfo>[];
    for (final id in ids) {
      final claveNombre = '${prefijoDePerfil(id)}$sufijoNombreVisible';
      final nombreGuardado = prefs.getString(claveNombre);
      final nombre =
          (nombreGuardado == null || nombreGuardado.trim().isEmpty)
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

  /// Crea un perfil derivando el id del nombre propuesto (slug). Si
  /// colisiona, añade sufijo numérico. Guarda el nombre dentro del
  /// perfil y devuelve el id final.
  Future<String> crearPerfil(String nombreVisible) async {
    final prefs = await prefsInicializadas();
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
      '${prefijoDePerfil(idCandidato)}$sufijoNombreVisible',
      nombreVisible.trim(),
    );
    return idCandidato;
  }

  /// Cambia el perfil activo. Si el id no existe, no hace nada.
  Future<void> cambiarAPerfil(String idPerfil) async {
    final prefs = await prefsInicializadas();
    final existentes = await listarPerfiles();
    if (!existentes.contains(idPerfil)) return;
    await prefs.setString(_claveIdPerfilActivo, idPerfil);
  }

  /// Borra todas las claves de [idPerfil]. Si era el activo, pasa al
  /// primer restante; si no queda ninguno, recrea
  /// [idPerfilPorDefecto] vacío.
  Future<void> borrarPerfil(String idPerfil) async {
    final prefs = await prefsInicializadas();
    final existentes = await listarPerfiles();
    if (!existentes.contains(idPerfil)) return;

    final prefijoABorrar = prefijoDePerfil(idPerfil);
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
}

/// Resumen de un perfil para listarlos en la UI de selección.
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
