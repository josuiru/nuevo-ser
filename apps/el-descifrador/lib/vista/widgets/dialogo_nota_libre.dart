// Diálogo para crear o editar una nota libre del cuaderno. Mecánica
// nuclear §3.3 y cuaderno §3.2.
//
// El cuaderno respeta lo que el niño escribe — sin autocorrección,
// sin subrayado en rojo. Si pone una palabra mal, queda mal. Es suya.

import 'package:flutter/material.dart';

import '../../dominio/notas_libres.dart';
import '../paleta_estafeta.dart';

class ResultadoNota {
  const ResultadoNota({required this.texto});
  final String texto;
}

/// Abre el diálogo. `notaActual` null → modo crear. null si el niño
/// cierra sin guardar.
Future<ResultadoNota?> mostrarDialogoNotaLibre({
  required BuildContext contexto,
  NotaLibre? notaActual,
}) {
  return showDialog<ResultadoNota>(
    context: contexto,
    builder: (contexto) => _DialogoNotaLibre(notaActual: notaActual),
  );
}

class _DialogoNotaLibre extends StatefulWidget {
  const _DialogoNotaLibre({required this.notaActual});

  final NotaLibre? notaActual;

  @override
  State<_DialogoNotaLibre> createState() => _EstadoDialogo();
}

class _EstadoDialogo extends State<_DialogoNotaLibre> {
  late final TextEditingController _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController(text: widget.notaActual?.texto ?? '');
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _guardar() {
    final texto = _controlador.text.trim();
    if (texto.isEmpty) return;
    Navigator.of(context).pop(ResultadoNota(texto: texto));
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext contexto) {
    final esEdicion = widget.notaActual != null;
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
                esEdicion ? 'Editar nota' : 'Nueva nota',
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 18,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                esEdicion
                    ? 'Es tu cuaderno. Lo que escribas queda como lo escribes.'
                    : 'Apunta lo que quieras: una observación, una pregunta '
                        'para ti mismo, una idea sobre una lengua, un dibujo '
                        'descrito en palabras.',
                style: TextStyle(
                  color: PaletaEstafeta.tinta.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontFamily: 'serif',
                ),
              ),
              if (esEdicion) ...[
                const SizedBox(height: 8),
                Text(
                  widget.notaActual!.fechaUltimaEdicion == null
                      ? 'Escrita el ${_formatearFecha(widget.notaActual!.fechaCreacion)}'
                      : 'Escrita el ${_formatearFecha(widget.notaActual!.fechaCreacion)}'
                          ' · editada el ${_formatearFecha(widget.notaActual!.fechaUltimaEdicion!)}',
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
                  hintText: 'Escribe aquí…',
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
                maxLines: 10,
                minLines: 6,
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
                      esEdicion ? 'Guardar cambios' : 'Guardar nota',
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
