// Pantalla principal del juego: la mesa del descifrador.
//
// Vista cenital con tres zonas:
//   - Bandeja de entrada (esquina superior izquierda): los documentos
//     del día apilados con leves rotaciones (4-6° entre piezas).
//   - Bandeja de resuelto (esquina superior derecha): documentos
//     archivados con decisión, más pequeños y ordenados.
//   - Banner del maestro (parte superior): saludo según estado.
//
// Cuando el niño toca una pieza, se navega a PantallaDocumento. Al
// volver, la pieza ya está en bandeja resuelto.
//
// Composición según `el-descifrador-11-guia-visual.md` §5.1. Versión
// inicial — la estética definitiva la cierra el ilustrador asignado
// (B8 BLOQUEOS-PENDIENTES.md).

import 'package:flutter/material.dart';

import '../datos/cargador_corpus.dart';
import '../datos/repositorio_familiaridad.dart';
import '../datos/repositorio_sesion.dart';
import '../datos/repositorio_vocabulario.dart';
import '../dominio/decision_documento.dart';
import '../dominio/estado_sesion.dart';
import '../dominio/pieza_corpus.dart';
import 'paleta_estafeta.dart';
import 'pantalla_cuaderno.dart';
import 'pantalla_documento.dart';

class PantallaMesa extends StatefulWidget {
  const PantallaMesa({
    super.key,
    this.idPerfil = 'principal',
    this.cargadorInyectado,
    this.repositorioFamiliaridadInyectado,
    this.repositorioSesionInyectado,
    this.repositorioVocabularioInyectado,
  });

  /// ID del perfil del niño activo. En v0.4.0 hardcodeado a 'principal'
  /// hasta que llegue el sistema de perfiles del Descifrador.
  final String idPerfil;

  /// CargadorCorpus inyectado (para tests con bundle in-memory). Si
  /// null, se construye uno con rootBundle.
  final CargadorCorpus? cargadorInyectado;

  /// RepositorioFamiliaridad inyectado (para tests). Si null, se
  /// construye con el idPerfil.
  final RepositorioFamiliaridad? repositorioFamiliaridadInyectado;

  /// RepositorioSesion inyectado (para tests). Si null, se construye
  /// con el idPerfil.
  final RepositorioSesion? repositorioSesionInyectado;

  /// RepositorioVocabulario inyectado (para tests). Si null, se
  /// construye con el idPerfil.
  final RepositorioVocabulario? repositorioVocabularioInyectado;

  @override
  State<PantallaMesa> createState() => _EstadoPantallaMesa();
}

class _EstadoPantallaMesa extends State<PantallaMesa> {
  EstadoSesion? _estado;
  String? _errorCarga;
  late final RepositorioFamiliaridad _repositorioFamiliaridad;
  late final RepositorioSesion _repositorioSesion;
  late final RepositorioVocabulario _repositorioVocabulario;
  late final CargadorCorpus _cargador;

  @override
  void initState() {
    super.initState();
    _repositorioFamiliaridad =
        widget.repositorioFamiliaridadInyectado ??
            RepositorioFamiliaridad(idPerfil: widget.idPerfil);
    _repositorioSesion = widget.repositorioSesionInyectado ??
        RepositorioSesion(idPerfil: widget.idPerfil);
    _repositorioVocabulario = widget.repositorioVocabularioInyectado ??
        RepositorioVocabulario(idPerfil: widget.idPerfil);
    _cargador = widget.cargadorInyectado ?? CargadorCorpus();
    _cargarCorpus();
  }

  Future<void> _cargarCorpus() async {
    try {
      final resultado = await _cargador.cargarTodo();
      final sesion = await _repositorioSesion.cargar();
      if (!mounted) return;
      setState(() {
        _estado = EstadoSesion.reconciliar(
          piezasDelCorpus: resultado.piezasCargadas,
          idsResueltas: sesion.decisionesPorPieza.keys.toSet(),
        );
        _errorCarga = null;
      });
    } catch (excepcion) {
      if (!mounted) return;
      setState(() {
        _errorCarga = excepcion.toString();
      });
    }
  }

  Future<void> _abrirPieza(PiezaCorpus pieza) async {
    final decision = await Navigator.of(context).push<DecisionDocumento>(
      MaterialPageRoute(
        builder: (contexto) => PantallaDocumento(
          pieza: pieza,
          repositorioFamiliaridad: _repositorioFamiliaridad,
          repositorioVocabularioInyectado: _repositorioVocabulario,
          idPerfil: widget.idPerfil,
        ),
      ),
    );
    if (!mounted) return;
    if (decision != null) {
      // Persistir antes de actualizar UI para que un cierre forzoso
      // entre setState y guardar no pierda la decisión.
      await _repositorioSesion.registrarPiezaResuelta(pieza.id, decision);
      if (!mounted) return;
      setState(() {
        _estado = _estado?.conPiezaResuelta(pieza.id);
      });
    }
  }

  Future<void> _abrirCuaderno() async {
    final estado = _estado;
    if (estado == null) return;
    final familiaridad = await _repositorioFamiliaridad.cargar();
    final vocabulario = await _repositorioVocabulario.cargar();
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (contexto) => PantallaCuaderno(
          estadoSesion: estado,
          familiaridad: familiaridad,
          vocabulario: vocabulario,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext contexto) {
    final estado = _estado;
    final error = _errorCarga;

    return Scaffold(
      backgroundColor: PaletaEstafeta.madera,
      body: SafeArea(
        child: error != null
            ? _ErrorCarga(error: error)
            : estado == null
                ? const _Cargando()
                : _Mesa(
                    estado: estado,
                    alTocarPieza: _abrirPieza,
                    alAbrirCuaderno: _abrirCuaderno,
                  ),
      ),
    );
  }
}

class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext contexto) {
    return const Center(
      child: CircularProgressIndicator(color: PaletaEstafeta.papel),
    );
  }
}

class _ErrorCarga extends StatelessWidget {
  const _ErrorCarga({required this.error});

  final String error;

  @override
  Widget build(BuildContext contexto) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'La oficina está cerrada por hoy.',
              style: TextStyle(color: PaletaEstafeta.papel, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(color: PaletaEstafeta.papel, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Mesa extends StatelessWidget {
  const _Mesa({
    required this.estado,
    required this.alTocarPieza,
    required this.alAbrirCuaderno,
  });

  final EstadoSesion estado;
  final ValueChanged<PiezaCorpus> alTocarPieza;
  final VoidCallback alAbrirCuaderno;

  @override
  Widget build(BuildContext contexto) {
    return Stack(
      children: [
        // Mesa de madera oscura — fondo plano provisional, sin textura
        // hasta que llegue el ilustrador (B8).
        Positioned.fill(
          child: Container(color: PaletaEstafeta.madera),
        ),
        // Frase del maestro en la parte superior.
        Positioned(
          top: 24,
          left: 32,
          right: 32,
          child: _SaludoMaestro(estado: estado),
        ),
        // Bandeja de entrada (esquina superior izquierda).
        Positioned(
          left: 32,
          top: 96,
          child: _BandejaEntrada(
            piezas: estado.piezasEnBandejaDeEntrada(),
            alTocarPieza: alTocarPieza,
          ),
        ),
        // Bandeja resuelto (esquina superior derecha) — indicador
        // discreto del trabajo del día.
        Positioned(
          right: 32,
          top: 96,
          child: _BandejaResuelto(cantidad: estado.cantidadResueltas),
        ),
        // Botón del cuaderno (lateral derecho). Doc 11 §5.1 sitúa el
        // cuaderno parcialmente visible en lateral derecho de la mesa.
        Positioned(
          right: 32,
          bottom: 32,
          child: _BotonCuaderno(alPulsar: alAbrirCuaderno),
        ),
      ],
    );
  }
}

class _SaludoMaestro extends StatelessWidget {
  const _SaludoMaestro({required this.estado});

  final EstadoSesion estado;

  @override
  Widget build(BuildContext contexto) {
    final String saludo = estado.bandejaDeEntradaVacia
        ? 'El correo de hoy está hecho.'
        : 'Hay correo en la mesa.';
    return Text(
      saludo,
      style: const TextStyle(
        color: PaletaEstafeta.papel,
        fontSize: 18,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class _BandejaEntrada extends StatelessWidget {
  const _BandejaEntrada({required this.piezas, required this.alTocarPieza});

  final List<PiezaCorpus> piezas;
  final ValueChanged<PiezaCorpus> alTocarPieza;

  @override
  Widget build(BuildContext contexto) {
    if (piezas.isEmpty) {
      return const SizedBox.shrink();
    }
    // Layout vertical sin solapamiento en v0.4.0. El "papeles apilados
    // con leves rotaciones" del doc 11 §5.1 lo afinará el ilustrador
    // asignado cuando llegue (B8). Esta versión es funcional y
    // permite hit-testing claro en tests.
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var indice = 0; indice < piezas.length; indice++) ...[
            if (indice > 0) const SizedBox(height: 12),
            _PapelEnBandeja(
              key: ValueKey('pieza-${piezas[indice].id}'),
              pieza: piezas[indice],
              alTocar: () => alTocarPieza(piezas[indice]),
            ),
          ],
        ],
      ),
    );
  }
}

class _PapelEnBandeja extends StatelessWidget {
  const _PapelEnBandeja({
    super.key,
    required this.pieza,
    required this.alTocar,
  });

  final PiezaCorpus pieza;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext contexto) {
    // Nota v0.4.0: rotación visual diferida hasta que llegue ilustrador
    // (doc 11 §5.1 pide leves rotaciones de 4-6° entre piezas). Transform.rotate
    // interfiere con hit-testing en tests; el efecto se aplicará en CSS/widget
    // de presentación cuando se cierre la guía visual definitiva.
    return Material(
      color: PaletaEstafeta.papel,
      elevation: 4,
      borderRadius: BorderRadius.circular(2),
      child: InkWell(
        onTap: alTocar,
        borderRadius: BorderRadius.circular(2),
        child: Container(
            width: 220,
            height: 280,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pieza.tipo.identificadorTecnico,
                  style: TextStyle(
                    color: PaletaEstafeta.sepia.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pieza.remitenteTextoLibre.replaceAll('_', ' '),
                  style: const TextStyle(
                    color: PaletaEstafeta.tinta,
                    fontSize: 13,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  pieza.lenguaPrincipal.nombreCanonico,
                  style: const TextStyle(
                    color: PaletaEstafeta.sepia,
                    fontSize: 11,
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                Text(
                  // Asomo del texto sin abrir — solo las primeras
                  // palabras, atenuadas. El cuerpo se ve al abrir.
                  pieza.textoDocumento.split('\n').first,
                  style: TextStyle(
                    color: PaletaEstafeta.tinta.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontFamily: 'serif',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class _BotonCuaderno extends StatelessWidget {
  const _BotonCuaderno({required this.alPulsar});

  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext contexto) {
    return Material(
      color: PaletaEstafeta.papel,
      elevation: 4,
      borderRadius: BorderRadius.circular(2),
      child: InkWell(
        key: const ValueKey('boton-cuaderno'),
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.book_outlined,
                color: PaletaEstafeta.tinta,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Tu cuaderno',
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 14,
                  fontFamily: 'serif',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BandejaResuelto extends StatelessWidget {
  const _BandejaResuelto({required this.cantidad});

  final int cantidad;

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: PaletaEstafeta.sepia.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: PaletaEstafeta.sepia.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        cantidad == 0
            ? 'Archivo: nada hoy'
            : cantidad == 1
                ? 'Archivo: 1 pieza'
                : 'Archivo: $cantidad piezas',
        style: const TextStyle(
          color: PaletaEstafeta.papel,
          fontSize: 12,
          fontFamily: 'serif',
        ),
      ),
    );
  }
}
