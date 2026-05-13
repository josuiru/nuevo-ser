// Dialog para proponer (o revisar) la interpretación del niño sobre
// un documento. Operación 4 de la mecánica nuclear, §3.4.
//
// El espacio es libre: síntesis del documento en la lengua del niño.
// No se exige nada (la hipótesis es estado válido, biblia §2.3).
// Si ya hay interpretación previa, se carga su texto y se muestra
// cuándo fue propuesta para que el niño se sitúe.

import 'package:flutter/material.dart';

import '../../dominio/interpretacion_pieza.dart';
import '../paleta_estafeta.dart';

/// Resultado del diálogo. null si el niño cierra sin guardar.
class ResultadoInterpretacion {
  const ResultadoInterpretacion({required this.texto});
  final String texto;
}

Future<ResultadoInterpretacion?> mostrarDialogoProponerInterpretacion({
  required BuildContext contexto,
  required InterpretacionPieza? interpretacionActual,
}) {
  return showDialog<ResultadoInterpretacion>(
    context: contexto,
    builder: (contexto) => _DialogoProponerInterpretacion(
      interpretacionActual: interpretacionActual,
    ),
  );
}

class _DialogoProponerInterpretacion extends StatefulWidget {
  const _DialogoProponerInterpretacion({required this.interpretacionActual});

  final InterpretacionPieza? interpretacionActual;

  @override
  State<_DialogoProponerInterpretacion> createState() => _EstadoDialogo();
}

class _EstadoDialogo extends State<_DialogoProponerInterpretacion> {
  late final TextEditingController _controladorTexto;

  @override
  void initState() {
    super.initState();
    _controladorTexto = TextEditingController(
      text: widget.interpretacionActual?.texto ?? '',
    );
  }

  @override
  void dispose() {
    _controladorTexto.dispose();
    super.dispose();
  }

  void _guardar() {
    final textoLimpio = _controladorTexto.text.trim();
    if (textoLimpio.isEmpty) return;
    Navigator.of(context).pop(ResultadoInterpretacion(texto: textoLimpio));
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anyo = fecha.year.toString();
    return '$dia/$mes/$anyo';
  }

  @override
  Widget build(BuildContext contexto) {
    final interpretacionActual = widget.interpretacionActual;
    final esRevision = interpretacionActual != null;

    return Dialog(
      backgroundColor: PaletaEstafeta.papel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                esRevision ? 'Revisar tu interpretación' : 'Tu interpretación',
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 18,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Escribe lo que crees que dice este documento. No tiene que '
                'ser traducción palabra por palabra: con que captes la idea '
                'es suficiente.',
                style: TextStyle(
                  color: PaletaEstafeta.tinta.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontFamily: 'serif',
                ),
              ),
              if (esRevision) ...[
                const SizedBox(height: 12),
                Text(
                  'Propuesta el ${_formatearFecha(interpretacionActual.fechaPropuesta)}'
                  '${interpretacionActual.fechaUltimaRevision != null ? ' · revisada el ${_formatearFecha(interpretacionActual.fechaUltimaRevision!)}' : ''}',
                  style: TextStyle(
                    color: PaletaEstafeta.sepia.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                controller: _controladorTexto,
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 14,
                  fontFamily: 'serif',
                ),
                decoration: InputDecoration(
                  hintText: 'Lo que yo creo que dice…',
                  hintStyle: TextStyle(
                    color: PaletaEstafeta.tinta.withValues(alpha: 0.4),
                    fontSize: 13,
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                    borderSide: BorderSide(
                      color: PaletaEstafeta.sepia.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                maxLines: 8,
                minLines: 5,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: PaletaEstafeta.tinta,
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _guardar,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PaletaEstafeta.tinta,
                      side: const BorderSide(color: PaletaEstafeta.sepia),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      esRevision ? 'Guardar revisión' : 'Guardar',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
