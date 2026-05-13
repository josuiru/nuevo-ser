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

import '../datos/repositorio_familiaridad.dart';
import '../datos/repositorio_vocabulario.dart';
import '../dominio/decision_documento.dart';
import '../dominio/pieza_corpus.dart';
import '../dominio/vocabulario_jugador.dart';
import 'paleta_estafeta.dart';
import 'widgets/dialogo_marcar_palabra.dart';
import 'widgets/texto_marcable.dart';

class PantallaDocumento extends StatefulWidget {
  const PantallaDocumento({
    super.key,
    required this.pieza,
    required this.repositorioFamiliaridad,
    this.repositorioVocabularioInyectado,
    this.idPerfil = 'principal',
  });

  final PiezaCorpus pieza;
  final RepositorioFamiliaridad repositorioFamiliaridad;
  final RepositorioVocabulario? repositorioVocabularioInyectado;
  final String idPerfil;

  @override
  State<PantallaDocumento> createState() => _EstadoPantallaDocumento();
}

class _EstadoPantallaDocumento extends State<PantallaDocumento> {
  late final RepositorioVocabulario _repositorioVocabulario;
  VocabularioJugador? _vocabulario;

  @override
  void initState() {
    super.initState();
    _repositorioVocabulario = widget.repositorioVocabularioInyectado ??
        RepositorioVocabulario(idPerfil: widget.idPerfil);
    _cargarVocabulario();
  }

  Future<void> _cargarVocabulario() async {
    final vocabulario = await _repositorioVocabulario.cargar();
    if (!mounted) return;
    setState(() => _vocabulario = vocabulario);
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

  Future<void> _alDecidir(DecisionDocumento decision) async {
    await widget.repositorioFamiliaridad.registrarPiezaTrabajada(
      widget.pieza.remitenteRecurrente,
    );
    if (!mounted) return;
    Navigator.of(context).pop(decision);
  }

  @override
  Widget build(BuildContext contexto) {
    final vocabulario = _vocabulario ?? VocabularioJugador.inicial();
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
                  alTocarPalabra: _alTocarPalabra,
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
    required this.alTocarPalabra,
    required this.alDecidir,
  });

  final PiezaCorpus pieza;
  final VocabularioJugador vocabulario;
  final void Function(String palabraOriginal) alTocarPalabra;
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
                  pieza.lenguaPrincipal.nombreCanonico,
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
                  alTocarPalabra: alTocarPalabra,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: PaletaEstafeta.sepia.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            _BarraDecisiones(
              decisionesValidas: pieza.decisionesValidas,
              alDecidir: alDecidir,
            ),
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
