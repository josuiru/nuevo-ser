import 'package:nuevo_ser_tutor/nuevo_ser_tutor.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import '../../datos/repositorio_progreso.dart';

/// Orquestador del Tutor IA. Compone las cuatro piezas independientes
/// (filtro, disparador, caché, cliente HTTP) en la API de alto nivel
/// que la `PantallaTutor` y el motor de combate usan.
///
/// La capa pantalla NO conoce filtro, caché ni cliente HTTP por
/// separado — solo este servicio. Eso permite cambiar la implementación
/// de cualquier subpieza sin tocar la UI.
///
/// El servicio NO mantiene estado: lee/escribe a través del repositorio
/// (estados del disparador por skill) y de la caché (respuestas). Esto
/// permite que cualquier pantalla cree una instancia ligera sin
/// preocuparse por compartir estado.
class ServicioTutor {
  final FiltroSeguridad _filtro;
  final DisparadorTutor _disparador;
  final CacheTutor _cache;
  final ClienteTutor _cliente;
  final RepositorioProgreso _repositorio;
  final String Function() _proveedorToken;

  ServicioTutor({
    required CacheTutor cache,
    required ClienteTutor cliente,
    required RepositorioProgreso repositorio,
    required String Function() proveedorToken,
    FiltroSeguridad filtro = const FiltroSeguridad(),
    DisparadorTutor disparador = const DisparadorTutor(),
  })  : _filtro = filtro,
        _disparador = disparador,
        _cache = cache,
        _cliente = cliente,
        _repositorio = repositorio,
        _proveedorToken = proveedorToken;

  // ─── Política: cuándo ofrecer / registrar resultados ──────────

  /// Llamar tras cada respuesta del niño en un puzzle. Si fue correcta,
  /// resetea el contador de fallos consecutivos. Si fue incorrecta,
  /// incrementa.
  Future<void> registrarResultado({
    required String idHabilidad,
    required bool acierto,
  }) async {
    final estado = await _repositorio.cargarEstadoTutor(idHabilidad);
    final nuevo = acierto
        ? estado.registrandoAcierto()
        : estado.registrandoFallo();
    await _repositorio.guardarEstadoTutor(idHabilidad, nuevo);
  }

  /// Decide si la pantalla del puzzle debe mostrar el botón de tutor
  /// para esta habilidad ahora.
  Future<bool> deberiaOfrecer(String idHabilidad, {DateTime? ahora}) async {
    final estado = await _repositorio.cargarEstadoTutor(idHabilidad);
    return _disparador.deberiaOfrecer(estado, ahora ?? DateTime.now());
  }

  /// Llamar cuando el niño ABRE el tutor (acepta la oferta o lo invoca
  /// manualmente). Marca la oferta como mostrada y arranca el cooldown.
  Future<void> registrarOferta(String idHabilidad, {DateTime? ahora}) async {
    final estado = await _repositorio.cargarEstadoTutor(idHabilidad);
    await _repositorio.guardarEstadoTutor(
      idHabilidad,
      estado.registrandoOferta(ahora ?? DateTime.now()),
    );
  }

  // ─── Petición principal: pregunta del niño → explicación ──────

  /// Procesa la pregunta del niño:
  /// 1. Filtro local — si rechaza, devuelve mensaje cariñoso sin red.
  /// 2. Cache local — si hit, sirve sin llamar al backend.
  /// 3. Llamada HTTP al backend.
  /// 4. Filtro a la respuesta — si rechaza (PII en la respuesta del LLM)
  ///    devolvemos error genérico para que la UI muestre algo prudente.
  /// 5. Trunca y guarda en caché.
  Future<RespuestaServicioTutor> pedirExplicacion({
    required String idHabilidad,
    required String pregunta,
    String? contextoFragmento,
  }) async {
    // (1) Filtro de entrada.
    final revisionEntrada = _filtro.revisarPregunta(pregunta);
    if (revisionEntrada is RevisionRechazada) {
      return RespuestaServicioTutor.rechazadaPorFiltro(
        _filtro.mensajeAmableParaMotivo(revisionEntrada.motivo),
      );
    }
    final preguntaLimpia =
        (revisionEntrada as RevisionAceptada).contenidoLimpio;

    // (2) Cache.
    final desdeCache = await _cache.recuperar(
      idHabilidad: idHabilidad,
      pregunta: preguntaLimpia,
    );
    if (desdeCache != null) {
      return RespuestaServicioTutor.ok(desdeCache, desdeCacheLocal: true);
    }

    // (3) Llamada al backend.
    final RespuestaTutor respuestaHttp;
    try {
      respuestaHttp = await _cliente.explicar(
        token: _proveedorToken(),
        idHabilidad: idHabilidad,
        pregunta: preguntaLimpia,
        contextoFragmento: contextoFragmento,
      );
    } on ExcepcionApi catch (e) {
      // 422 = el filtro PHP del servidor rechazó. Su mensaje suele
      // estar en castellano y se muestra tal cual.
      if (e.codigo == 422) {
        return RespuestaServicioTutor.rechazadaPorFiltro(e.mensaje);
      }
      return RespuestaServicioTutor.errorRed(e.mensaje);
    } catch (_) {
      return RespuestaServicioTutor.errorRed(
        'No he podido conectar. Inténtalo en un rato.',
      );
    }

    // (4) Filtro de salida.
    final revisionSalida = _filtro.revisarRespuesta(respuestaHttp.explicacion);
    if (revisionSalida is RevisionRechazada) {
      return RespuestaServicioTutor.errorRed(
        'Hoy no puedo ayudarte con eso, prueba a preguntarlo de otra forma.',
      );
    }
    final explicacionFinal =
        (revisionSalida as RevisionAceptada).contenidoLimpio;

    // (5) Cachear.
    await _cache.guardar(
      idHabilidad: idHabilidad,
      pregunta: preguntaLimpia,
      explicacion: explicacionFinal,
    );

    return RespuestaServicioTutor.ok(
      explicacionFinal,
      desdeCacheLocal: false,
      desdeCacheServidor: respuestaHttp.desdeCache,
    );
  }
}

/// Resultado de pedir una explicación. Tres estados con tipo etiquetado.
class RespuestaServicioTutor {
  final EstadoRespuestaTutor estado;
  final String texto;

  /// Solo verdadero si la respuesta vino de la caché del cliente
  /// (sin llamada HTTP). El servidor también puede tener su caché y
  /// eso se refleja en [desdeCacheServidor].
  final bool desdeCacheLocal;
  final bool desdeCacheServidor;

  const RespuestaServicioTutor._({
    required this.estado,
    required this.texto,
    this.desdeCacheLocal = false,
    this.desdeCacheServidor = false,
  });

  factory RespuestaServicioTutor.ok(
    String texto, {
    bool desdeCacheLocal = false,
    bool desdeCacheServidor = false,
  }) =>
      RespuestaServicioTutor._(
        estado: EstadoRespuestaTutor.ok,
        texto: texto,
        desdeCacheLocal: desdeCacheLocal,
        desdeCacheServidor: desdeCacheServidor,
      );

  factory RespuestaServicioTutor.rechazadaPorFiltro(String mensaje) =>
      RespuestaServicioTutor._(
        estado: EstadoRespuestaTutor.rechazada,
        texto: mensaje,
      );

  factory RespuestaServicioTutor.errorRed(String mensaje) =>
      RespuestaServicioTutor._(
        estado: EstadoRespuestaTutor.errorRed,
        texto: mensaje,
      );
}

enum EstadoRespuestaTutor { ok, rechazada, errorRed }
