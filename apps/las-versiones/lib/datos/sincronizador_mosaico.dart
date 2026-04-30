import 'dart:async';
import 'dart:io';

import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../dominio/mosaico_arco_1.dart';
import '../dominio/mosaico_arco_2.dart';
import 'repositorio_mosaico.dart';

/// `game_id` con el que el backend identifica a Las Versiones (sembrado
/// en `ns_games` por `class-ns-esquema.php`). Convención de la
/// Colección: minúsculas con guiones, sin namespace de Dart. Se valida
/// server-side al recibir cualquier endpoint companion — si el seed de
/// la BD no incluye este id, los POST devolverán 400 con
/// `invalid_fields.game_id`.
const String gameIdLasVersiones = 'las-versiones';

/// `format` del Mosaico v2 — cómic de 8 viñetas con código de
/// confianza por viñeta (Sólido/Probable/Disputado). El servidor lo
/// guarda como string libre, así que no se valida más allá de la
/// longitud.
const String formatoMosaicoV2 = 'comic_8_vinetas_confianza';

/// `format` del Mosaico del Arco 2 — audio-guía de aproximadamente
/// 90 segundos compuesta por 8 fragmentos pre-escritos, cada uno con
/// código de confianza por fragmento (Sólido/Probable/Disputado). El
/// formato es distinto del M1 (cómic mudo) a propósito; el servidor
/// lo guarda como string libre y el adulto acompañante (vista del
/// cuidador, futura) puede distinguir el formato para presentar la
/// vista correspondiente.
const String formatoAudioGuiaArco2 = 'audio_guia_arco_2';

/// Resultado de un intento de sincronización del Mosaico. La pantalla
/// puede usar esta información para enseñar al jugador qué pasó (sin
/// presionarlo a reintentar — el cliente la mantiene local en cualquier
/// caso).
sealed class ResultadoSyncMosaico {
  const ResultadoSyncMosaico();
}

/// No había token JWT cuando se llamó al sincronizador. El Mosaico se
/// quedó sólo en local; cuando el jugador haga login y vuelva a
/// entregar (futuro: opción "compartir con el adulto"), el cliente
/// volverá a intentarlo. Hoy no hay reintento automático.
class SyncMosaicoSinToken extends ResultadoSyncMosaico {
  const SyncMosaicoSinToken();
}

/// El backend recibió y archivó el Mosaico. El `id` y el `completedAt`
/// del servidor están en [mosaicoBackend] por si una pantalla futura
/// quiere mostrarlos.
class SyncMosaicoExito extends ResultadoSyncMosaico {
  const SyncMosaicoExito({required this.mosaicoBackend});

  final companion.Mosaico mosaicoBackend;
}

/// Algo falló — red, timeout, o error HTTP. El Mosaico se quedó en
/// local; el jugador puede volver a entrar en la pantalla y reintentar
/// si así lo decide.
class SyncMosaicoError extends ResultadoSyncMosaico {
  const SyncMosaicoError({required this.razon});

  /// Cadena humana corta — la pantalla puede mostrarla en castellano.
  /// Sigue el patrón de `SincronizadorAgregadosCuaderno` para que las
  /// dos vistas hablen un idioma común.
  final String razon;
}

/// Sube el Mosaico del Arco 1 al endpoint `POST /companion/mosaicos`.
///
/// Diseño:
/// - El componente NO decide cuándo sincronizar. Lo dispara el
///   orquestador justo después de que el jugador pulse ENTREGAR. Sin
///   reintento automático — el cliente persiste el Mosaico en local
///   pase lo que pase con la red.
/// - Sin cola persistente. Si el backend está caído cuando se entrega,
///   el Mosaico se queda local; cuando el jugador vuelva a abrir el
///   juego con conexión, una pantalla futura de Ajustes podrá
///   ofrecerle reintentar.
/// - El token se lee al construir el payload — puede haber cambiado
///   desde la última llamada.
class SincronizadorMosaicoArco1 {
  SincronizadorMosaicoArco1({
    required this.repoCuenta,
    required this.repoMosaico,
    required this.clienteCompanion,
    this.gameId = gameIdLasVersiones,
    this.formato = formatoMosaicoV2,
  });

  final RepositorioCuentaBackend repoCuenta;

  /// Repositorio local que persiste las marcas (`Map<String,
  /// NivelConfianza>`). Lo lee el sincronizador para construir el
  /// payload — no escribe nada aquí.
  final RepositorioMosaico repoMosaico;

  final companion.ClienteCompanion clienteCompanion;
  final String gameId;
  final String formato;

  /// Sincroniza el Mosaico del Arco 1 con el backend. Lee el token, lee
  /// las marcas del repositorio local, construye el payload (con
  /// `requiredAnchors` = ids de las viñetas con anclaje obligatorio,
  /// `fulfilledAnchors` = ids de las viñetas que el jugador marcó, y
  /// `contentMeta` = mapa nivel-por-viñeta) y llama al cliente. Devuelve
  /// el [ResultadoSyncMosaico] correspondiente.
  Future<ResultadoSyncMosaico> sincronizar() async {
    final token = await repoCuenta.cargarToken();
    if (token == null || token.isEmpty) {
      return const SyncMosaicoSinToken();
    }
    final marcas = await repoMosaico.cargar(MosaicoArco1.idArco);
    final mosaico = construirPayload(marcas: marcas);
    try {
      final mosaicoBackend = await clienteCompanion.crearMosaico(
        token: token,
        mosaico: mosaico,
      );
      return SyncMosaicoExito(mosaicoBackend: mosaicoBackend);
    } on ExcepcionApi catch (e) {
      return SyncMosaicoError(razon: 'API ${e.codigo}: ${e.mensaje}');
    } on TimeoutException {
      return const SyncMosaicoError(razon: 'Tiempo de espera agotado.');
    } on SocketException {
      return const SyncMosaicoError(razon: 'Sin conexión.');
    }
  }

  /// Construye el payload `Mosaico` que el cliente envía al backend.
  /// Pública para que los tests puedan verificar la forma sin tocar la
  /// red. `requiredAnchors` lista los ids de **todas** las viñetas que
  /// llevan anclaje arqueológico obligatorio (la pieza de cómic anclada
  /// a fuentes catalogadas); `fulfilledAnchors` lista los ids de
  /// **las que el jugador marcó** con cualquier nivel de confianza.
  /// `contentMeta` lleva el mapa completo `idVineta → nivel` para que
  /// el adulto acompañante (cuando entre la vista del cuidador) pueda
  /// ver lo que la Cronista declaró.
  companion.Mosaico construirPayload({
    required Map<String, NivelConfianza> marcas,
  }) {
    final idsObligatorios = <String>[
      for (final v in MosaicoArco1.vinetas)
        if (v.esAnclajeObligatorio) v.id,
    ];
    final idsMarcados = marcas.keys.toList()..sort();
    final contentMeta = <String, dynamic>{
      for (final entrada in marcas.entries)
        entrada.key: _serializarNivel(entrada.value),
    };
    return companion.Mosaico(
      gameId: gameId,
      arcId: MosaicoArco1.idArco,
      format: formato,
      title: MosaicoArco1.titulo,
      contentRef: '',
      contentMeta: contentMeta,
      requiredAnchors: idsObligatorios,
      fulfilledAnchors: idsMarcados,
    );
  }

  static String _serializarNivel(NivelConfianza nivel) {
    switch (nivel) {
      case NivelConfianza.solido:
        return 'solido';
      case NivelConfianza.probable:
        return 'probable';
      case NivelConfianza.disputado:
        return 'disputado';
    }
  }
}

/// Sube el Mosaico del Arco 2 (audio-guía) al endpoint
/// `POST /companion/mosaicos`. Paralelo al `SincronizadorMosaicoArco1`
/// — mismo diseño (no decide cuándo sincronizar, sin reintento
/// automático, lee el token al construir el payload), distinta
/// fuente de datos (`MosaicoArco2.fragmentos` en lugar de
/// `MosaicoArco1.vinetas`) y distinto `format` por defecto
/// (`formatoAudioGuiaArco2`).
class SincronizadorMosaicoArco2 {
  SincronizadorMosaicoArco2({
    required this.repoCuenta,
    required this.repoMosaico,
    required this.clienteCompanion,
    this.gameId = gameIdLasVersiones,
    this.formato = formatoAudioGuiaArco2,
  });

  final RepositorioCuentaBackend repoCuenta;

  /// Repositorio local — el mismo `RepositorioMosaico` del M1 (que
  /// es genérico por `idArco`). Lo lee el sincronizador para
  /// construir el payload con `MosaicoArco2.idArco`.
  final RepositorioMosaico repoMosaico;

  final companion.ClienteCompanion clienteCompanion;
  final String gameId;
  final String formato;

  /// Sincroniza el Mosaico del Arco 2 con el backend. Lee el token,
  /// lee las marcas del repositorio local con `MosaicoArco2.idArco`,
  /// construye el payload y llama al cliente. Devuelve el
  /// [ResultadoSyncMosaico] correspondiente.
  Future<ResultadoSyncMosaico> sincronizar() async {
    final token = await repoCuenta.cargarToken();
    if (token == null || token.isEmpty) {
      return const SyncMosaicoSinToken();
    }
    final marcas = await repoMosaico.cargar(MosaicoArco2.idArco);
    final mosaico = construirPayload(marcas: marcas);
    try {
      final mosaicoBackend = await clienteCompanion.crearMosaico(
        token: token,
        mosaico: mosaico,
      );
      return SyncMosaicoExito(mosaicoBackend: mosaicoBackend);
    } on ExcepcionApi catch (e) {
      return SyncMosaicoError(razon: 'API ${e.codigo}: ${e.mensaje}');
    } on TimeoutException {
      return const SyncMosaicoError(razon: 'Tiempo de espera agotado.');
    } on SocketException {
      return const SyncMosaicoError(razon: 'Sin conexión.');
    }
  }

  /// Construye el payload `Mosaico` que el cliente envía al backend.
  /// `requiredAnchors` lista los ids de los fragmentos con anclaje
  /// arqueológico/documental obligatorio (en el M2 son **todos** los
  /// fragmentos — la audio-guía ancla cada declaración a evidencia,
  /// no hay fragmentos de transición pura como sí los había en
  /// alguna viñeta del M1). `fulfilledAnchors` lista los ids de los
  /// fragmentos que el jugador marcó. `contentMeta` lleva el mapa
  /// completo `idFragmento → nivel`.
  companion.Mosaico construirPayload({
    required Map<String, NivelConfianza> marcas,
  }) {
    final idsObligatorios = <String>[
      for (final fragmento in MosaicoArco2.fragmentos)
        if (fragmento.esAnclajeObligatorio) fragmento.id,
    ];
    final idsMarcados = marcas.keys.toList()..sort();
    final contentMeta = <String, dynamic>{
      for (final entrada in marcas.entries)
        entrada.key: _serializarNivel(entrada.value),
    };
    return companion.Mosaico(
      gameId: gameId,
      arcId: MosaicoArco2.idArco,
      format: formato,
      title: MosaicoArco2.titulo,
      contentRef: '',
      contentMeta: contentMeta,
      requiredAnchors: idsObligatorios,
      fulfilledAnchors: idsMarcados,
    );
  }

  static String _serializarNivel(NivelConfianza nivel) {
    switch (nivel) {
      case NivelConfianza.solido:
        return 'solido';
      case NivelConfianza.probable:
        return 'probable';
      case NivelConfianza.disputado:
        return 'disputado';
    }
  }
}
