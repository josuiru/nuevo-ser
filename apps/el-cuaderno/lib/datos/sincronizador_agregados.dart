import 'dart:async';
import 'dart:io';

import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../dominio/agregado_semanal.dart';
import '../dominio/repositorio_local.dart';

/// `game_id` con el que el backend identifica al cuaderno. Provisional —
/// la decisión definitiva del nombre del juego es humana (biblia §10.1)
/// y se cierra en piloto. La fila de `ns_games` correspondiente se
/// inserta como parte de M003 con este mismo identificador.
const String gameIdElCuaderno = 'el-cuaderno';

/// Resultado de un intento de sincronización. La pantalla del cuidador
/// lo usa para decidir qué mostrar: si llega el `agregadoBackend`,
/// reemplaza al fallback offline; si no, mantiene la pregunta offline y
/// opcionalmente notifica el motivo del fallo.
sealed class ResultadoSync {
  const ResultadoSync();
}

class SyncSinToken extends ResultadoSync {
  const SyncSinToken();
}

class SyncExito extends ResultadoSync {
  const SyncExito({required this.agregadoBackend});

  final companion.AgregadoSemanal agregadoBackend;
}

class SyncError extends ResultadoSync {
  const SyncError({required this.razon});

  /// Cadena humana corta — la pantalla puede mostrarla en castellano.
  /// No se intenta tipar más fino: el cuidador no necesita distinguir
  /// 4xx/5xx, solo saber que hoy no se pudo y que puede reintentar.
  final String razon;
}

/// Sube los agregados semanales del cuaderno al endpoint
/// `POST /companion/aggregates/weekly`. **No toca texto libre del
/// niño** — solo `iso_week`, counts y reparto por misterio/confianza
/// (lo que `AgregadoSemanal.aJson()` produce).
///
/// Diseño:
/// - El componente NO decide cuándo sincronizar. Lo dispara la pantalla
///   del cuidador cuando el adulto pulsa el botón. Sin push, sin sync
///   automático en background — la sincronización es opt-in (biblia
///   §2.1, principio 1).
/// - Sin cola persistente. Si falla, el adulto puede reintentar; los
///   agregados se recalculan desde Isar local cada vez. El backend hace
///   upsert por `(nino, juego, semana)`, así que reintentar es seguro.
/// - El token se lee en cada llamada (puede haber cambiado entre
///   intentos). Si no hay → `SyncSinToken`, sin tocar red.
class SincronizadorAgregadosCuaderno {
  SincronizadorAgregadosCuaderno({
    required this.repositorio,
    required this.repoCuenta,
    required this.clienteCompanion,
    this.regionCodePorDefecto = 'ES',
    this.gameId = gameIdElCuaderno,
  });

  final RepositorioLocal repositorio;
  final RepositorioCuentaBackend repoCuenta;
  final companion.ClienteCompanion clienteCompanion;
  final String regionCodePorDefecto;
  final String gameId;

  /// Computa el agregado de la semana que contiene [semanaPivote] (o de
  /// "ahora" si null) y lo sube al backend. Ver [ResultadoSync] para
  /// los caminos posibles.
  Future<ResultadoSync> sincronizarSemana({DateTime? semanaPivote}) async {
    final token = await repoCuenta.cargarToken();
    if (token == null || token.isEmpty) {
      return const SyncSinToken();
    }
    final observaciones = await repositorio.obtenerObservaciones();
    final agregadoLocal = computarAgregadoSemanal(
      observaciones,
      semanaPivote: semanaPivote,
      regionCode: regionCodePorDefecto,
    );
    try {
      final agregadoBackend = await clienteCompanion.archivarAgregadosSemanales(
        token: token,
        gameId: gameId,
        isoWeek: agregadoLocal.isoWeek,
        aggregates: Map<String, dynamic>.from(agregadoLocal.aJson()),
      );
      return SyncExito(agregadoBackend: agregadoBackend);
    } on ExcepcionApi catch (e) {
      return SyncError(razon: 'API ${e.codigo}: ${e.mensaje}');
    } on TimeoutException {
      return const SyncError(razon: 'Tiempo de espera agotado.');
    } on SocketException {
      return const SyncError(razon: 'Sin conexión.');
    } catch (e) {
      return SyncError(razon: e.toString());
    }
  }
}
