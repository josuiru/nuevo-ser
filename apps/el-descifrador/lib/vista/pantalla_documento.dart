// Pantalla focal del documento abierto.
//
// El documento ocupa el 80-85% del centro de pantalla. Lo demás se
// atenúa. Botón "decidir" abajo despliega un dialog con las decisiones
// válidas declaradas en la pieza.
//
// Al decidir:
//   - Se registra la pieza trabajada con el remitente en el
//     RepositorioFamiliaridad (si el remitente es recurrente).
//   - Se vuelve a PantallaMesa, que mueve la pieza a bandeja resuelto.
//
// Composición según `el-descifrador-11-guia-visual.md` §5.2 y mecánica
// nuclear §3.6. Versión inicial — falta marcar palabras, anotar al
// cuaderno, proponer interpretación, pedir pistas (eso es del próximo
// sprint, cuando entre el cuaderno completo).

import 'package:flutter/material.dart';

import '../datos/repositorio_familiaridad.dart';
import '../dominio/decision_documento.dart';
import '../dominio/pieza_corpus.dart';
import 'paleta_estafeta.dart';

class PantallaDocumento extends StatelessWidget {
  const PantallaDocumento({
    super.key,
    required this.pieza,
    required this.repositorioFamiliaridad,
  });

  final PiezaCorpus pieza;
  final RepositorioFamiliaridad repositorioFamiliaridad;

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaEstafeta.madera.withValues(alpha: 0.95),
      body: SafeArea(
        child: Stack(
          children: [
            // Mesa atenuada de fondo.
            Positioned.fill(
              child: Container(color: PaletaEstafeta.madera),
            ),
            // Documento centrado al 80% del ancho disponible.
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 720,
                  maxHeight: 900,
                ),
                child: _DocumentoAbierto(
                  pieza: pieza,
                  alDecidir: (decision) => _alDecidir(contexto, decision),
                ),
              ),
            ),
            // Botón cerrar arriba a la derecha (sin decidir todavía).
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

  Future<void> _alDecidir(
    BuildContext contexto,
    DecisionDocumento decision,
  ) async {
    // Registrar familiaridad con el remitente (si recurrente).
    // Manifiesto Kids §3: el progreso del niño es el cuaderno, no XP
    // visible. El registro de familiaridad es silencioso.
    await repositorioFamiliaridad.registrarPiezaTrabajada(
      pieza.remitenteRecurrente,
    );

    if (!contexto.mounted) return;

    // Cerrar la pantalla. La PantallaMesa moverá la pieza a resuelto.
    Navigator.of(contexto).pop();
  }
}

class _DocumentoAbierto extends StatelessWidget {
  const _DocumentoAbierto({required this.pieza, required this.alDecidir});

  final PiezaCorpus pieza;
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
                child: _TextoDocumento(texto: pieza.textoDocumento),
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

class _TextoDocumento extends StatelessWidget {
  const _TextoDocumento({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext contexto) {
    // v0.3.0 muestra el texto literal del documento. La interpretación
    // de marcadores `*cursiva*` y `**negrita**` (doc 13 §10) se cablea
    // cuando llegue el sprint de marcar palabras.
    return Text(
      texto,
      style: const TextStyle(
        color: PaletaEstafeta.tinta,
        fontSize: 16,
        fontFamily: 'serif',
        height: 1.6,
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
