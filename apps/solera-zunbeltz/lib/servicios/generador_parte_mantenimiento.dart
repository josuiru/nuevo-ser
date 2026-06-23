import 'dart:io';

import 'package:intl/intl.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../l10n/app_localizations.dart';
import '../modelos/constantes.dart';
import '../modelos/finca.dart';
import '../modelos/punto_infraestructura.dart';
import '../modelos/tarea_mantenimiento.dart';

/// Genera el parte de mantenimiento en PDF reutilizando el informe
/// periódico del core. Una tabla por finca con sus tareas. Lleva sello
/// PROVISIONAL hasta validación humana del formato.
Future<File> generarParteMantenimientoPdf({
  required AppLocalizations textos,
  required String idioma,
  required List<Finca> fincas,
  required List<TareaMantenimiento> tareas,
  required Map<int, PuntoInfraestructura> puntosPorId,
}) async {
  final formatoFecha = DateFormat('dd/MM/yyyy', idioma);

  String etiqueta(List<OpcionCatalogo> catalogo, String codigo) =>
      buscarOpcion(catalogo, codigo)?.etiqueta(idioma) ?? codigo;

  String nombrePunto(int? puntoId) {
    if (puntoId == null) return textos.tareaDeFinca;
    final punto = puntosPorId[puntoId];
    if (punto == null) return textos.tareaDeFinca;
    if (punto.nombre.isNotEmpty) return punto.nombre;
    return etiqueta(tiposPunto, punto.tipo);
  }

  final tablas = <TablaInforme>[];
  for (final finca in fincas) {
    final tareasFinca =
        tareas.where((t) => t.fincaId == finca.id).toList(growable: false);
    if (tareasFinca.isEmpty) continue;
    tablas.add(TablaInforme(
      titulo: finca.nombre,
      headers: [
        textos.parteColPunto,
        textos.parteColTarea,
        textos.parteColResponsable,
        textos.parteColPrioridad,
        textos.parteColEstado,
        textos.parteColFecha,
      ],
      filas: [
        for (final tarea in tareasFinca)
          [
            nombrePunto(tarea.puntoId),
            tarea.titulo,
            tarea.responsable.isEmpty
                ? textos.parteSinResponsable
                : tarea.responsable,
            etiqueta(prioridadesTarea, tarea.prioridad),
            etiqueta(estadosTarea, tarea.estado),
            tarea.fechaObjetivoMs == null
                ? '—'
                : formatoFecha.format(DateTime.fromMillisecondsSinceEpoch(
                    tarea.fechaObjetivoMs!)),
          ],
      ],
    ));
  }

  return generarInformePeriodicoPdf(
    tituloCabecera: textos.parteTitulo,
    subtituloCabecera: textos.parteSubtitulo,
    bulletsResumen: [
      textos.parteProvisional,
      textos.parteResumenTareas(tareas.length),
    ],
    tablas: tablas,
    prefijoNombreFichero: 'parte_mantenimiento',
  );
}
