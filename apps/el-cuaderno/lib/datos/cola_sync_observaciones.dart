import 'dart:convert';

import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/repositorio_local.dart';
import 'cliente_el_cuaderno.dart';

/// Cola simple de UUIDs de observaciones pendientes de subir al
/// servidor. Persistencia clave-valor en `SharedPreferences` con
/// clave global `nuevoser.elcuaderno.cola_sync.observaciones`.
///
/// Diseño:
/// - El cuaderno principal vive en Isar (cifrado en reposo). La cola
///   solo contiene UUIDs — la observación completa se rehidrata al
///   intentar enviar.
/// - Idempotencia del servidor: si la cola reintenta una observación
///   ya subida (porque la respuesta anterior se perdió en una caída
///   de red), el endpoint responde 200 con el mismo id. La cola
///   trata 200 y 201 como éxito.
/// - Errores `4xx` salvo `401`/`429`/`408` se consideran irreversibles
///   (la observación está mal y nunca pasará validación). Se quitan
///   de la cola y se reportan como `rechazadas`.
/// - Errores `5xx`, `401`, `429`, `408` y excepciones de red dejan la
///   observación en la cola para reintento posterior.
///
/// La cola NO orquesta su propia ejecución — la pantalla la invoca
/// cuando le conviene (al volver online, cada N minutos, al pulsar
/// "sincronizar ahora"…). Mantenerla pasiva facilita los tests.
class ColaSyncObservaciones {
  /// Clave global de SharedPreferences donde vive la lista de UUIDs.
  /// La compartimos entre todos los perfiles del dispositivo porque
  /// el JWT del backend ya separa por `nino_id` — la cola no necesita
  /// el segundo nivel de aislamiento.
  static const claveSharedPrefs =
      'nuevoser.elcuaderno.cola_sync.observaciones';

  ColaSyncObservaciones({
    required this.prefs,
    this.clave = claveSharedPrefs,
  });

  /// Callback que devuelve la instancia de `SharedPreferences`. Se
  /// inyecta para tests con `setMockInitialValues`.
  final Future<SharedPreferences> Function() prefs;

  /// Permite a tests usar una clave específica para no contaminar el
  /// almacenamiento global del juego.
  final String clave;

  /// UUIDs pendientes (en orden de inserción).
  Future<List<String>> uuidsPendientes() async {
    final p = await prefs();
    final raw = p.getString(clave);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final lista = jsonDecode(raw);
      if (lista is! List) return const [];
      return lista.map((e) => e.toString()).toList();
    } catch (_) {
      // Auto-curación: clave corrupta → vacía. La cola no debe
      // bloquear al niño porque un valor antiguo se haya estropeado.
      await p.remove(clave);
      return const [];
    }
  }

  /// Apunta una observación recién creada para enviar más tarde.
  /// Idempotente — si el UUID ya está, no lo duplica.
  Future<void> marcarPendiente(String uuid) async {
    final actuales = await uuidsPendientes();
    if (actuales.contains(uuid)) return;
    final nuevas = [...actuales, uuid];
    await _persistir(nuevas);
  }

  /// Itera los pendientes en orden y los envía con [cliente]. Devuelve
  /// el resumen del intento. Errores irrecuperables sacan el UUID de
  /// la cola; los recuperables lo dejan para el siguiente intento.
  ///
  /// El [regionCode] se aplica a todas las observaciones del intento;
  /// la región del niño rara vez cambia entre observaciones recientes,
  /// y mantenerlo fuera del modelo evita acoplar la cola a la fuente
  /// del valor (geolocalización en S5, manual en S2).
  Future<ResultadoSyncObservaciones> intentarEnviar({
    required RepositorioLocal repositorio,
    required ClienteElCuaderno cliente,
    required String regionCode,
  }) async {
    final pendientes = await uuidsPendientes();
    final enviadas = <String>[];
    final rechazadas = <ObservacionRechazada>[];
    final dejadas = <String>[];

    for (final uuid in pendientes) {
      final observacion = await repositorio.obtenerObservacionPorId(uuid);
      if (observacion == null) {
        // La observación se borró del cuaderno antes de subirse;
        // sacar de la cola sin contar como rechazo.
        continue;
      }
      try {
        await cliente.crearObservacion(observacion, regionCode: regionCode);
        enviadas.add(uuid);
      } on ExcepcionApi catch (e) {
        if (_esRecuperable(e.codigo)) {
          dejadas.add(uuid);
        } else {
          rechazadas.add(ObservacionRechazada(uuid: uuid, motivo: e));
        }
      } catch (_) {
        // Fallo de red, timeout, etc. — recuperable.
        dejadas.add(uuid);
      }
    }

    await _persistir(dejadas);

    return ResultadoSyncObservaciones(
      enviadas: enviadas,
      rechazadas: rechazadas,
      dejadasParaReintento: dejadas,
    );
  }

  Future<void> _persistir(List<String> uuids) async {
    final p = await prefs();
    if (uuids.isEmpty) {
      await p.remove(clave);
      return;
    }
    await p.setString(clave, jsonEncode(uuids));
  }

  static bool _esRecuperable(int codigo) {
    // Servidor caído (5xx) o problemas transitorios (timeout, rate
    // limit, sesión expirada). El resto de 4xx (400/403/404/422…) son
    // irreversibles: el reintento producirá el mismo error.
    if (codigo >= 500) return true;
    return codigo == 401 || codigo == 408 || codigo == 429;
  }
}

class ResultadoSyncObservaciones {
  const ResultadoSyncObservaciones({
    required this.enviadas,
    required this.rechazadas,
    required this.dejadasParaReintento,
  });

  /// UUIDs que se enviaron correctamente (201 nuevo o 200 idempotente).
  final List<String> enviadas;

  /// UUIDs que el servidor ha rechazado de manera permanente. La UI
  /// del cuaderno puede mostrarlos al niño para que decida (editar,
  /// borrar, reportar el problema).
  final List<ObservacionRechazada> rechazadas;

  /// UUIDs que se quedan en la cola para el siguiente intento.
  final List<String> dejadasParaReintento;

  bool get hayPendientes => dejadasParaReintento.isNotEmpty;
}

class ObservacionRechazada {
  const ObservacionRechazada({required this.uuid, required this.motivo});

  final String uuid;
  final ExcepcionApi motivo;
}
