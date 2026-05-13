// Diálogo para anotar (o editar una anotación) sobre la pieza abierta.
// Cuaderno §3.3.
//
// La anotación es local a la pieza — no es interpretación global ni
// nota libre. Suele ser un apunte breve sobre un detalle que el niño
// quiere recordar al volver al documento.

import 'package:flutter/material.dart';

import '../../dominio/anotaciones_piezas.dart';
import '../paleta_estafeta.dart';

class ResultadoAnotacion {
  const ResultadoAnotacion({required this.texto});
  final String texto;
}

Future<ResultadoAnotacion?> mostrarDialogoAnotacion({
  required BuildContext contexto,
  AnotacionPieza? anotacionActual,
}) {
  return showDialog<ResultadoAnotacion>(
    context: contexto,
    builder: (contexto) =>
        _DialogoAnotacion(anotacionActual: anotacionActual),
  );
}

class _DialogoAnotacion extends StatefulWidget {
  const _DialogoAnotacion({required this.anotacionActual});

  final AnotacionPieza? anotacionActual;

  @override
  State<_DialogoAnotacion> createState() => _EstadoDialogo();
}

class _EstadoDialogo extends State<_DialogoAnotacion> {
  late final TextEditingController _controlador;

  @override
  void initState() {
    super.initState();
    _controlador =
        TextEditingController(text: widget.anotacionActual?.texto ?? '');
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _guardar() {
    final texto = _controlador.text.trim();
    if (texto.isEmpty) return;
    Navigator.of(context).pop(ResultadoAnotacion(texto: texto));
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext contexto) {
    final esEdicion = widget.anotacionActual != null;
    return Dialog(
      backgroundColor: PaletaEstafeta.papel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                esEdicion ? 'Editar anotación' : 'Anotar este documento',
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 17,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                esEdicion
                    ? 'Es tu apunte sobre esta pieza. Lo verás cuando vuelvas '
                        'a abrirla.'
                    : 'Un apunte sobre algo que ves en este documento — '
                        'una palabra que reconoces, una duda, una pista para '
                        'cuando vuelvas.',
                style: TextStyle(
                  color: PaletaEstafeta.tinta.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontFamily: 'serif',
                ),
              ),
              if (esEdicion) ...[
                const SizedBox(height: 8),
                Text(
                  widget.anotacionActual!.fechaUltimaEdicion == null
                      ? 'Anotada el ${_formatearFecha(widget.anotacionActual!.fechaCreacion)}'
                      : 'Anotada el ${_formatearFecha(widget.anotacionActual!.fechaCreacion)}'
                          ' · editada el ${_formatearFecha(widget.anotacionActual!.fechaUltimaEdicion!)}',
                  style: TextStyle(
                    color: PaletaEstafeta.sepia.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                controller: _controlador,
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 14,
                  fontFamily: 'serif',
                ),
                decoration: InputDecoration(
                  hintText: 'Apunta lo que veas…',
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
                maxLines: 6,
                minLines: 3,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
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
                      style: TextStyle(fontFamily: 'serif', fontSize: 13),
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
                      esEdicion ? 'Guardar cambios' : 'Guardar anotación',
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
