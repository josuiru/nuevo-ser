// Pantalla focal del documento abierto.
//
// El documento ocupa el 80-85% del centro de pantalla. Lo demás se
// atenúa. El niño puede:
//   - Tocar palabras para marcarlas (verde/amarillo/rojo + hipótesis
//     opcional). Operación de mecánica nuclear §3.2.
//   - Pulsar una decisión (Archivar / Devolver / Entregar / Publicar /
//     Esperar) según lo declarado en la pieza.
//
// Al decidir:
//   - Se registra familiaridad con el remitente (si recurrente).
//   - Se devuelve la decisión a PantallaMesa, que la persiste.

import 'package:flutter/material.dart';

import '../datos/repositorio_anotaciones.dart';
import '../datos/repositorio_familiaridad.dart';
import '../datos/repositorio_identificaciones.dart';
import '../datos/repositorio_interpretaciones.dart';
import '../datos/repositorio_pistas.dart';
import '../datos/repositorio_sellos.dart';
import '../datos/repositorio_vocabulario.dart';
import '../dominio/anotaciones_piezas.dart';
import '../dominio/decision_documento.dart';
import '../dominio/identificaciones_lengua.dart';
import '../dominio/interpretacion_pieza.dart';
import '../dominio/lengua.dart';
import '../dominio/pieza_corpus.dart';
import '../dominio/pistas_pedidas.dart';
import '../dominio/sellos.dart';
import '../dominio/servicio_candidatas_lengua.dart';
import '../dominio/servicio_pistas.dart';
import '../dominio/servicio_sellos.dart';
import '../dominio/vocabulario_jugador.dart';
import 'paleta_estafeta.dart';
import 'widgets/dialogo_anotacion_pieza.dart';
import 'widgets/dialogo_marcar_palabra.dart';
import 'widgets/dialogo_pedir_pista.dart';
import 'widgets/dialogo_proponer_interpretacion.dart';
import 'widgets/panel_identificar_lengua.dart';
import 'widgets/texto_marcable.dart';

/// Lo que la sesión de un documento devuelve a `PantallaMesa` al
/// cerrarse: decisión tomada y sellos del cuaderno que se han
/// activado durante la sesión.
class ResultadoSesionDocumento {
  const ResultadoSesionDocumento({
    required this.decision,
    required this.sellosNuevos,
  });

  final DecisionDocumento decision;
  final List<SelloConcedido> sellosNuevos;
}

class PantallaDocumento extends StatefulWidget {
  const PantallaDocumento({
    super.key,
    required this.pieza,
    required this.repositorioFamiliaridad,
    this.repositorioVocabularioInyectado,
    this.repositorioInterpretacionesInyectado,
    this.repositorioPistasInyectado,
    this.repositorioIdentificacionesInyectado,
    this.repositorioAnotacionesInyectado,
    this.repositorioSellosInyectado,
    this.servicioCandidatasInyectado,
    this.servicioSellosInyectado,
    this.piezasResueltas = const [],
    this.idPerfil = 'principal',
  });

  final PiezaCorpus pieza;
  final RepositorioFamiliaridad repositorioFamiliaridad;
  final RepositorioVocabulario? repositorioVocabularioInyectado;
  final RepositorioInterpretaciones? repositorioInterpretacionesInyectado;
  final RepositorioPistas? repositorioPistasInyectado;
  final RepositorioIdentificaciones? repositorioIdentificacionesInyectado;
  final RepositorioAnotaciones? repositorioAnotacionesInyectado;
  final RepositorioSellos? repositorioSellosInyectado;

  /// Servicio que produce las candidatas de lengua. Inyectable para
  /// tests deterministas.
  final ServicioCandidatasLengua? servicioCandidatasInyectado;
  final ServicioSellos? servicioSellosInyectado;

  /// Piezas que el niño ha resuelto antes. El servicio de pistas las
  /// consulta para construir la pista de comparación.
  final List<PiezaCorpus> piezasResueltas;
  final String idPerfil;

  @override
  State<PantallaDocumento> createState() => _EstadoPantallaDocumento();
}

class _EstadoPantallaDocumento extends State<PantallaDocumento> {
  late final RepositorioVocabulario _repositorioVocabulario;
  late final RepositorioInterpretaciones _repositorioInterpretaciones;
  late final RepositorioPistas _repositorioPistas;
  late final RepositorioIdentificaciones _repositorioIdentificaciones;
  late final RepositorioAnotaciones _repositorioAnotaciones;
  late final RepositorioSellos _repositorioSellos;
  late final ServicioCandidatasLengua _servicioCandidatas;
  late final ServicioSellos _servicioSellos;
  static const ServicioPistas _servicioPistas = ServicioPistas();
  VocabularioJugador? _vocabulario;
  InterpretacionPieza? _interpretacionActual;
  PistasPedidas _pistas = PistasPedidas.inicial();
  IdentificacionLengua? _identificacion;
  List<Lengua>? _candidatasLengua;
  AnotacionesPiezas _anotaciones = AnotacionesPiezas.inicial();
  Sellos _sellos = Sellos.inicial();
  IdentificacionesPiezas _identificacionesPrevias =
      IdentificacionesPiezas.inicial();
  final List<SelloConcedido> _sellosNuevosAcumulados = [];

  @override
  void initState() {
    super.initState();
    _repositorioVocabulario = widget.repositorioVocabularioInyectado ??
        RepositorioVocabulario(idPerfil: widget.idPerfil);
    _repositorioInterpretaciones =
        widget.repositorioInterpretacionesInyectado ??
            RepositorioInterpretaciones(idPerfil: widget.idPerfil);
    _repositorioPistas = widget.repositorioPistasInyectado ??
        RepositorioPistas(idPerfil: widget.idPerfil);
    _repositorioIdentificaciones =
        widget.repositorioIdentificacionesInyectado ??
            RepositorioIdentificaciones(idPerfil: widget.idPerfil);
    _repositorioAnotaciones = widget.repositorioAnotacionesInyectado ??
        RepositorioAnotaciones(idPerfil: widget.idPerfil);
    _repositorioSellos = widget.repositorioSellosInyectado ??
        RepositorioSellos(idPerfil: widget.idPerfil);
    _servicioCandidatas =
        widget.servicioCandidatasInyectado ?? ServicioCandidatasLengua();
    _servicioSellos =
        widget.servicioSellosInyectado ?? const ServicioSellos();
    _cargarVocabulario();
    _cargarInterpretacion();
    _cargarPistas();
    _cargarIdentificacion();
    _cargarAnotaciones();
    _cargarSellos();
  }

  Future<void> _cargarSellos() async {
    final sellos = await _repositorioSellos.cargar();
    if (!mounted) return;
    setState(() => _sellos = sellos);
  }

  Future<void> _registrarSellos(List<String> claves) async {
    if (claves.isEmpty) return;
    var sellosActuales = _sellos;
    final nuevos = <SelloConcedido>[];
    for (final clave in claves) {
      final (siguientes, eraNuevo) =
          await _repositorioSellos.registrarSelloSiNuevo(clave);
      if (eraNuevo) {
        sellosActuales = siguientes;
        final fecha = siguientes.fechaDe(clave) ?? DateTime.now();
        nuevos.add(SelloConcedido(
          clave: clave,
          texto: textoCanonicoDeClave(clave),
          fecha: fecha,
        ));
      }
    }
    if (!mounted) return;
    setState(() {
      _sellos = sellosActuales;
      _sellosNuevosAcumulados.addAll(nuevos);
    });
  }

  Future<void> _cargarAnotaciones() async {
    final anotaciones = await _repositorioAnotaciones.cargar();
    if (!mounted) return;
    setState(() => _anotaciones = anotaciones);
  }

  Future<void> _alAnyadirAnotacion() async {
    final resultado = await mostrarDialogoAnotacion(contexto: context);
    if (resultado == null || !mounted) return;
    final siguientes = await _repositorioAnotaciones.anyadirAnotacion(
      idPieza: widget.pieza.id,
      texto: resultado.texto,
    );
    if (!mounted) return;
    setState(() => _anotaciones = siguientes);
  }

  Future<void> _alEditarAnotacion(AnotacionPieza anotacion) async {
    final resultado = await mostrarDialogoAnotacion(
      contexto: context,
      anotacionActual: anotacion,
    );
    if (resultado == null || !mounted) return;
    final siguientes = await _repositorioAnotaciones.editarAnotacion(
      id: anotacion.id,
      texto: resultado.texto,
    );
    if (!mounted) return;
    setState(() => _anotaciones = siguientes);
  }

  Future<void> _alBorrarAnotacion(AnotacionPieza anotacion) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        backgroundColor: PaletaEstafeta.papel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        title: const Text(
          'Borrar esta anotación',
          style: TextStyle(fontFamily: 'serif', fontSize: 16),
        ),
        content: const Text(
          'Quedará fuera del documento. No se puede recuperar.',
          style: TextStyle(fontFamily: 'serif', fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontFamily: 'serif', fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: const Text(
              'Borrar',
              style: TextStyle(fontFamily: 'serif', fontSize: 13),
            ),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;
    final siguientes =
        await _repositorioAnotaciones.borrarAnotacion(anotacion.id);
    if (!mounted) return;
    setState(() => _anotaciones = siguientes);
  }

  Future<void> _cargarIdentificacion() async {
    final identificaciones = await _repositorioIdentificaciones.cargar();
    if (!mounted) return;
    setState(() {
      _identificacionesPrevias = identificaciones;
      _identificacion = identificaciones.identificacionDe(widget.pieza.id);
      _candidatasLengua = _servicioCandidatas.candidatasPara(
        lenguaCorrecta: widget.pieza.lenguaPrincipal,
      );
    });
  }

  Future<void> _alElegirLengua(Lengua intentada) async {
    final identificacionesPreviasAlIntento = _identificacionesPrevias;
    final actualizadas =
        await _repositorioIdentificaciones.registrarIntento(
      idPieza: widget.pieza.id,
      lenguaIntentada: intentada,
      lenguaCorrecta: widget.pieza.lenguaPrincipal,
    );
    if (!mounted) return;
    setState(() {
      _identificacionesPrevias = actualizadas;
      _identificacion = actualizadas.identificacionDe(widget.pieza.id);
    });

    final acerto = intentada == widget.pieza.lenguaPrincipal;
    if (acerto) {
      final sellosNuevos = _servicioSellos.sellosTrasIdentificacionExitosa(
        lenguaIdentificada: widget.pieza.lenguaPrincipal,
        identificacionesPrevias: identificacionesPreviasAlIntento,
        sellosPrevios: _sellos,
      );
      await _registrarSellos(sellosNuevos);
    }
  }

  Future<void> _cargarPistas() async {
    final pistas = await _repositorioPistas.cargar();
    if (!mounted) return;
    setState(() => _pistas = pistas);
  }

  Future<void> _cargarVocabulario() async {
    final vocabulario = await _repositorioVocabulario.cargar();
    if (!mounted) return;
    setState(() => _vocabulario = vocabulario);
  }

  Future<void> _cargarInterpretacion() async {
    final interpretaciones = await _repositorioInterpretaciones.cargar();
    if (!mounted) return;
    setState(() {
      _interpretacionActual =
          interpretaciones.interpretacionDe(widget.pieza.id);
    });
  }

  Future<void> _alProponerInterpretacion() async {
    final resultado = await mostrarDialogoProponerInterpretacion(
      contexto: context,
      interpretacionActual: _interpretacionActual,
    );
    if (resultado == null || !mounted) return;
    final actualizadas =
        await _repositorioInterpretaciones.proponerInterpretacion(
      idPieza: widget.pieza.id,
      texto: resultado.texto,
    );
    if (!mounted) return;
    setState(() {
      _interpretacionActual =
          actualizadas.interpretacionDe(widget.pieza.id);
    });
  }

  Future<void> _alTocarPalabra(String palabraOriginal) async {
    final vocabulario = _vocabulario;
    if (vocabulario == null) return;
    final marcaActual = vocabulario.marcaDe(
      widget.pieza.lenguaPrincipal,
      palabraOriginal,
    );
    final resultado = await mostrarDialogoMarcarPalabra(
      contexto: context,
      palabraOriginal: palabraOriginal,
      marcaActual: marcaActual,
    );
    if (resultado == null || !mounted) return;

    if (resultado.pedirPista) {
      await _alPedirPista(palabraOriginal);
      return;
    }
    if (resultado.olvidar) {
      final nuevo = await _repositorioVocabulario.olvidarMarca(
        lengua: widget.pieza.lenguaPrincipal,
        palabra: palabraOriginal,
      );
      if (!mounted) return;
      setState(() => _vocabulario = nuevo);
    } else if (resultado.marca != null) {
      final nuevo = await _repositorioVocabulario.registrarMarca(
        lengua: widget.pieza.lenguaPrincipal,
        palabra: palabraOriginal,
        marca: resultado.marca!,
      );
      if (!mounted) return;
      setState(() => _vocabulario = nuevo);
    }
  }

  Future<void> _alPedirPista(String palabraOriginal) async {
    final vocabulario = _vocabulario ?? VocabularioJugador.inicial();
    final nivelesYaPedidos = _pistas.nivelesPedidos(
      idPieza: widget.pieza.id,
      palabra: palabraOriginal,
    );
    await mostrarDialogoPedirPista(
      contexto: context,
      palabraOriginal: palabraOriginal,
      nivelesYaPedidos: nivelesYaPedidos,
      responder: (nivel) {
        // Registra la pista en background y devuelve la respuesta del
        // maestro inmediatamente para que el niño la lea.
        _repositorioPistas
            .registrarPista(
          idPieza: widget.pieza.id,
          palabra: palabraOriginal,
          nivel: nivel,
        )
            .then((actualizadas) {
          if (!mounted) return;
          setState(() => _pistas = actualizadas);
        });
        return _servicioPistas.responder(
          nivel: nivel,
          piezaActual: widget.pieza,
          palabraOriginal: palabraOriginal,
          vocabulario: vocabulario,
          piezasResueltas: widget.piezasResueltas,
        );
      },
    );
  }

  Future<void> _alDecidir(DecisionDocumento decision) async {
    await widget.repositorioFamiliaridad.registrarPiezaTrabajada(
      widget.pieza.remitenteRecurrente,
    );
    final sellosNuevos = _servicioSellos.sellosTrasDecision(
      lenguaDePieza: widget.pieza.lenguaPrincipal,
      decisionTomada: decision,
      sellosPrevios: _sellos,
    );
    await _registrarSellos(sellosNuevos);
    if (!mounted) return;
    Navigator.of(context).pop(ResultadoSesionDocumento(
      decision: decision,
      sellosNuevos: List.unmodifiable(_sellosNuevosAcumulados),
    ));
  }

  @override
  Widget build(BuildContext contexto) {
    final vocabulario = _vocabulario ?? VocabularioJugador.inicial();
    final yaIdentificada =
        _identificacion?.identificadaCorrectamente ?? false;
    final candidatas = _candidatasLengua;
    return Scaffold(
      backgroundColor: PaletaEstafeta.madera.withValues(alpha: 0.95),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: PaletaEstafeta.madera),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 720,
                  maxHeight: 900,
                ),
                child: _DocumentoAbierto(
                  pieza: widget.pieza,
                  vocabulario: vocabulario,
                  interpretacionActual: _interpretacionActual,
                  palabrasConPistaPedida:
                      _pistas.palabrasConPistaEn(widget.pieza.id),
                  identificada: yaIdentificada,
                  identificacionPrevia: _identificacion,
                  candidatasLengua: candidatas ?? const [],
                  anotaciones: _anotaciones.anotacionesDe(widget.pieza.id),
                  alElegirLengua: _alElegirLengua,
                  alTocarPalabra: _alTocarPalabra,
                  alProponerInterpretacion: _alProponerInterpretacion,
                  alAnyadirAnotacion: _alAnyadirAnotacion,
                  alEditarAnotacion: _alEditarAnotacion,
                  alBorrarAnotacion: _alBorrarAnotacion,
                  alDecidir: _alDecidir,
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: PaletaEstafeta.papel,
                onPressed: () => Navigator.of(contexto).maybePop(),
                tooltip: 'Cerrar sin decidir',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentoAbierto extends StatelessWidget {
  const _DocumentoAbierto({
    required this.pieza,
    required this.vocabulario,
    required this.interpretacionActual,
    required this.palabrasConPistaPedida,
    required this.identificada,
    required this.identificacionPrevia,
    required this.candidatasLengua,
    required this.anotaciones,
    required this.alElegirLengua,
    required this.alTocarPalabra,
    required this.alProponerInterpretacion,
    required this.alAnyadirAnotacion,
    required this.alEditarAnotacion,
    required this.alBorrarAnotacion,
    required this.alDecidir,
  });

  final PiezaCorpus pieza;
  final VocabularioJugador vocabulario;
  final InterpretacionPieza? interpretacionActual;
  final Set<String> palabrasConPistaPedida;
  final bool identificada;
  final IdentificacionLengua? identificacionPrevia;
  final List<Lengua> candidatasLengua;
  final List<AnotacionPieza> anotaciones;
  final ValueChanged<Lengua> alElegirLengua;
  final void Function(String palabraOriginal) alTocarPalabra;
  final VoidCallback alProponerInterpretacion;
  final VoidCallback alAnyadirAnotacion;
  final ValueChanged<AnotacionPieza> alEditarAnotacion;
  final ValueChanged<AnotacionPieza> alBorrarAnotacion;
  final ValueChanged<DecisionDocumento> alDecidir;

  @override
  Widget build(BuildContext contexto) {
    return Material(
      color: PaletaEstafeta.papel,
      elevation: 8,
      borderRadius: BorderRadius.circular(2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(48, 40, 48, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pieza.tipo.identificadorTecnico.replaceAll('_', ' '),
                  style: TextStyle(
                    color: PaletaEstafeta.sepia.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontFamily: 'serif',
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  identificada ? pieza.lenguaPrincipal.nombreCanonico : '?',
                  style: const TextStyle(
                    color: PaletaEstafeta.sepia,
                    fontSize: 12,
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: PaletaEstafeta.sepia.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: TextoMarcable(
                  texto: pieza.textoDocumento,
                  lengua: pieza.lenguaPrincipal,
                  vocabulario: vocabulario,
                  palabrasConPistaPedida: palabrasConPistaPedida,
                  alTocarPalabra:
                      identificada ? alTocarPalabra : (_) {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: PaletaEstafeta.sepia.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            if (!identificada)
              PanelIdentificarLengua(
                candidatas: candidatasLengua,
                identificacionPrevia: identificacionPrevia,
                lenguaCorrecta: pieza.lenguaPrincipal,
                alElegir: alElegirLengua,
              )
            else ...[
              _SeccionAnotaciones(
                anotaciones: anotaciones,
                alAnyadir: alAnyadirAnotacion,
                alEditar: alEditarAnotacion,
                alBorrar: alBorrarAnotacion,
              ),
              const SizedBox(height: 12),
              _BotonInterpretacion(
                tieneInterpretacion: interpretacionActual != null,
                alPulsar: alProponerInterpretacion,
              ),
              const SizedBox(height: 12),
              _BarraDecisiones(
                decisionesValidas: pieza.decisionesValidas,
                alDecidir: alDecidir,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BarraDecisiones extends StatelessWidget {
  const _BarraDecisiones({
    required this.decisionesValidas,
    required this.alDecidir,
  });

  final Set<DecisionDocumento> decisionesValidas;
  final ValueChanged<DecisionDocumento> alDecidir;

  @override
  Widget build(BuildContext contexto) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        for (final decision in decisionesValidas)
          _BotonDecision(
            decision: decision,
            alPulsar: () => alDecidir(decision),
          ),
      ],
    );
  }
}

class _BotonDecision extends StatelessWidget {
  const _BotonDecision({required this.decision, required this.alPulsar});

  final DecisionDocumento decision;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext contexto) {
    return OutlinedButton(
      onPressed: alPulsar,
      style: OutlinedButton.styleFrom(
        foregroundColor: PaletaEstafeta.tinta,
        side: const BorderSide(color: PaletaEstafeta.sepia),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        _etiqueta(decision),
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'serif',
        ),
      ),
    );
  }

  String _etiqueta(DecisionDocumento decision) {
    switch (decision) {
      case DecisionDocumento.archivar:
        return 'Archivar';
      case DecisionDocumento.devolverAlRemitente:
        return 'Devolver al remitente';
      case DecisionDocumento.entregarAlDestinatario:
        return 'Entregar al destinatario';
      case DecisionDocumento.publicarEnBoletin:
        return 'Publicar en el Boletín';
      case DecisionDocumento.esperar:
        return 'Esperar';
    }
  }
}

class _SeccionAnotaciones extends StatelessWidget {
  const _SeccionAnotaciones({
    required this.anotaciones,
    required this.alAnyadir,
    required this.alEditar,
    required this.alBorrar,
  });

  final List<AnotacionPieza> anotaciones;
  final VoidCallback alAnyadir;
  final ValueChanged<AnotacionPieza> alEditar;
  final ValueChanged<AnotacionPieza> alBorrar;

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tus anotaciones',
              style: TextStyle(
                color: PaletaEstafeta.sepia.withValues(alpha: 0.9),
                fontSize: 12,
                fontFamily: 'serif',
                letterSpacing: 1.2,
              ),
            ),
            TextButton.icon(
              onPressed: alAnyadir,
              style: TextButton.styleFrom(
                foregroundColor: PaletaEstafeta.sepia,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                minimumSize: const Size(0, 28),
              ),
              icon: const Icon(Icons.add, size: 14),
              label: const Text(
                'Anotar',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        if (anotaciones.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Text(
              'Aún no has anotado nada sobre este documento.',
              style: TextStyle(
                color: PaletaEstafeta.tinta.withValues(alpha: 0.5),
                fontSize: 12,
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          for (final anotacion in anotaciones)
            _TarjetaAnotacion(
              key: ValueKey('anotacion-${anotacion.id}'),
              anotacion: anotacion,
              fecha: _formatearFecha(anotacion.fechaCreacion),
              fechaEdicion: anotacion.fechaUltimaEdicion == null
                  ? null
                  : _formatearFecha(anotacion.fechaUltimaEdicion!),
              alEditar: () => alEditar(anotacion),
              alBorrar: () => alBorrar(anotacion),
            ),
      ],
    );
  }
}

class _TarjetaAnotacion extends StatelessWidget {
  const _TarjetaAnotacion({
    super.key,
    required this.anotacion,
    required this.fecha,
    required this.fechaEdicion,
    required this.alEditar,
    required this.alBorrar,
  });

  final AnotacionPieza anotacion;
  final String fecha;
  final String? fechaEdicion;
  final VoidCallback alEditar;
  final VoidCallback alBorrar;

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: PaletaEstafeta.sepia.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fechaEdicion == null
                  ? 'Anotada el $fecha'
                  : 'Anotada el $fecha · editada el $fechaEdicion',
              style: TextStyle(
                color: PaletaEstafeta.sepia.withValues(alpha: 0.8),
                fontSize: 10,
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              anotacion.texto,
              style: const TextStyle(
                color: PaletaEstafeta.tinta,
                fontSize: 13,
                fontFamily: 'serif',
                height: 1.35,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: alEditar,
                  style: TextButton.styleFrom(
                    foregroundColor: PaletaEstafeta.sepia,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: const Size(0, 24),
                  ),
                  child: const Text(
                    'Editar',
                    style: TextStyle(fontFamily: 'serif', fontSize: 11),
                  ),
                ),
                TextButton(
                  onPressed: alBorrar,
                  style: TextButton.styleFrom(
                    foregroundColor: PaletaEstafeta.sepia,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: const Size(0, 24),
                  ),
                  child: const Text(
                    'Borrar',
                    style: TextStyle(fontFamily: 'serif', fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonInterpretacion extends StatelessWidget {
  const _BotonInterpretacion({
    required this.tieneInterpretacion,
    required this.alPulsar,
  });

  final bool tieneInterpretacion;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext contexto) {
    return TextButton.icon(
      onPressed: alPulsar,
      style: TextButton.styleFrom(
        foregroundColor: PaletaEstafeta.sepia,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(
        tieneInterpretacion ? Icons.edit_note : Icons.note_add_outlined,
        size: 18,
        color: PaletaEstafeta.sepia,
      ),
      label: Text(
        tieneInterpretacion ? 'Revisar tu interpretación' : 'Tu interpretación',
        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'serif',
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
