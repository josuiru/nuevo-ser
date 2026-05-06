import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Persistencia del estado del Faro de Azula del perfil activo.
///
/// Cada perfil guarda:
///
/// - `primera_vista_ms`: epoch millis del primer momento en que el
///   niño abre el Faro. Marca el origen de la "semana 1" del banco
///   inicial. Una vez fijado no se cambia (los siguientes viernes
///   se calculan a partir de aquí).
/// - `ultima_edicion_vista`: número de la edición más reciente que
///   el niño abrió (1..N). Sirve para resaltar "hay edición nueva"
///   en la pila junto al Edificio de los Tejados.
/// - `respuesta.<n>`: respuesta libre que el niño envía al acertijo
///   de la edición `n` (formato texto, una por edición).
///
/// Es **por-perfil**: cada hermano del dispositivo tiene su propia
/// pila de ediciones leídas y sus propias respuestas a los
/// acertijos.
class RepositorioFaro {
  RepositorioFaro({required this.gestor});

  final GestorPerfiles gestor;

  static const _sufPrimeraVistaMs = 'faro.primera_vista_ms';
  static const _sufUltimaEdicionVista = 'faro.ultima_edicion_vista';
  static const _prefijoRespuesta = 'faro.respuesta.';

  Future<int?> cargarPrimeraVistaMs() async {
    final prefs = await gestor.prefsInicializadas();
    final clave = '${await gestor.prefijoActivo()}$_sufPrimeraVistaMs';
    return prefs.getInt(clave);
  }

  Future<void> guardarPrimeraVistaMs(int ms) async {
    final prefs = await gestor.prefsInicializadas();
    final clave = '${await gestor.prefijoActivo()}$_sufPrimeraVistaMs';
    await prefs.setInt(clave, ms);
  }

  /// Marca el origen de la semana 1 si todavía no estaba puesto.
  /// Idempotente: si ya hay valor, no lo sobrescribe (la primera
  /// vista del Faro define la cadencia para siempre).
  Future<void> marcarPrimeraVistaSiEsNueva(DateTime ahora) async {
    if (await cargarPrimeraVistaMs() != null) return;
    await guardarPrimeraVistaMs(ahora.millisecondsSinceEpoch);
  }

  Future<int?> cargarUltimaEdicionVista() async {
    final prefs = await gestor.prefsInicializadas();
    final clave = '${await gestor.prefijoActivo()}$_sufUltimaEdicionVista';
    return prefs.getInt(clave);
  }

  Future<void> guardarUltimaEdicionVista(int numeroSemana) async {
    final prefs = await gestor.prefsInicializadas();
    final clave = '${await gestor.prefijoActivo()}$_sufUltimaEdicionVista';
    await prefs.setInt(clave, numeroSemana);
  }

  Future<String?> cargarRespuestaAcertijo(int numeroSemana) async {
    final prefs = await gestor.prefsInicializadas();
    final clave =
        '${await gestor.prefijoActivo()}$_prefijoRespuesta$numeroSemana';
    final valor = prefs.getString(clave);
    if (valor == null || valor.trim().isEmpty) return null;
    return valor;
  }

  Future<void> guardarRespuestaAcertijo(
    int numeroSemana,
    String respuesta,
  ) async {
    final prefs = await gestor.prefsInicializadas();
    final clave =
        '${await gestor.prefijoActivo()}$_prefijoRespuesta$numeroSemana';
    await prefs.setString(clave, respuesta);
  }

  /// Borra todo el estado del Faro del perfil activo (primera vista,
  /// última edición y todas las respuestas). Pensado para tests y
  /// para "reiniciar partida" del perfil activo.
  Future<void> borrarTodo() async {
    final prefs = await gestor.prefsInicializadas();
    final prefijo = await gestor.prefijoActivo();
    final clavesABorrar = prefs
        .getKeys()
        .where((k) =>
            k == '$prefijo$_sufPrimeraVistaMs' ||
            k == '$prefijo$_sufUltimaEdicionVista' ||
            k.startsWith('$prefijo$_prefijoRespuesta'))
        .toList();
    for (final clave in clavesABorrar) {
      await prefs.remove(clave);
    }
  }
}

/// `true` cuando hay una edición del Faro que el niño todavía no ha
/// abierto en este perfil. Función pura — recibe los valores ya
/// cargados y la semana ya calculada para que el test no dependa de
/// `SharedPreferences` ni del reloj.
///
/// Reglas:
///
/// - Si `primeraVistaMs` es null (nunca abrió el Faro) → `true`.
///   La primera apertura es la que fija la "semana 1" y no queremos
///   que el badge se pierda esa por culpa de un null.
/// - Si `ultimaEdicionVista` es null pero hay primera vista (caso
///   de borde, no debería pasar en flujo normal) → `true` también,
///   por la misma razón.
/// - En el resto: `semanaActual > ultimaEdicionVista`.
bool tieneEdicionFaroNoLeida({
  required int? primeraVistaMs,
  required int? ultimaEdicionVista,
  required int semanaActual,
}) {
  if (primeraVistaMs == null) return true;
  if (ultimaEdicionVista == null) return true;
  return semanaActual > ultimaEdicionVista;
}

/// Calcula qué número de edición corresponde a `ahora` para un niño
/// cuyo Faro empezó en `primeraVistaMs`.
///
/// Reglas:
///
/// - Si `primeraVistaMs` es null (el niño todavía no ha abierto el
///   Faro nunca), devuelve 1.
/// - La edición avanza cada 7 días desde la primera vista.
///   `(ahora - primeraVista) / 7d` redondeado hacia abajo da el
///   número de semanas transcurridas; sumamos 1 porque la primera
///   vez ya está en la semana 1.
/// - Si `ahora` cae antes que la primera vista (reloj del
///   dispositivo retrocedido), devuelve 1 — es lo más cómodo para el
///   niño.
/// - Capping en `totalEdiciones`: si pasaron N semanas y solo hay M
///   ediciones (con N > M), el niño se queda leyendo la última hasta
///   que el equipo cargue ediciones nuevas.
///
/// El cálculo es puro — no toca `SharedPreferences`. Le pasamos los
/// dos valores ya cargados; eso facilita los tests.
int calcularNumeroSemanaActual({
  required DateTime ahora,
  required int? primeraVistaMs,
  required int totalEdiciones,
}) {
  assert(totalEdiciones > 0, 'El banco de ediciones no puede estar vacío');
  if (primeraVistaMs == null) return 1;
  final desde = DateTime.fromMillisecondsSinceEpoch(primeraVistaMs);
  final transcurrido = ahora.difference(desde);
  if (transcurrido.isNegative) return 1;
  final semanas = transcurrido.inDays ~/ 7;
  final propuesta = semanas + 1;
  if (propuesta > totalEdiciones) return totalEdiciones;
  return propuesta;
}
