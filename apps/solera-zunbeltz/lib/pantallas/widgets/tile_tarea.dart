import 'package:flutter/material.dart';

import '../../modelos/constantes.dart';
import '../../modelos/tarea_mantenimiento.dart';
import '../../utiles/estilos_tarea.dart';

/// Fila de una tarea reutilizable (ficha de punto y tablero). Muestra un
/// punto de color por estado, el título, un subtítulo opcional (finca /
/// punto) y chips de estado, prioridad y responsable.
class TileTarea extends StatelessWidget {
  const TileTarea({
    super.key,
    required this.tarea,
    required this.idioma,
    this.subtitulo,
    this.onTap,
  });

  final TareaMantenimiento tarea;
  final String idioma;
  final String? subtitulo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final estado = buscarOpcion(estadosTarea, tarea.estado)?.etiqueta(idioma) ??
        tarea.estado;
    final prioridad =
        buscarOpcion(prioridadesTarea, tarea.prioridad)?.etiqueta(idioma) ??
            tarea.prioridad;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: colorEstadoTarea(tarea.estado),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(tarea.titulo.isEmpty ? '—' : tarea.titulo,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitulo != null && subtitulo!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 6),
                child: Text(subtitulo!,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                _Chip(texto: estado, color: colorEstadoTarea(tarea.estado)),
                _Chip(texto: prioridad),
                if (tarea.responsable.isNotEmpty)
                  _Chip(texto: tarea.responsable),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.texto, this.color});

  final String texto;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fondo = color ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final claro = color != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: claro ? Colors.white : null,
        ),
      ),
    );
  }
}
