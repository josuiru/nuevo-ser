import 'dart:io';

import 'package:intl/intl.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/app_localizations.dart';
import '../modelos/apunte_economico.dart';
import '../modelos/constantes.dart';
import '../modelos/indicadores_seguimiento.dart';
import '../modelos/proyecto_test.dart';
import '../modelos/registro_comercializacion.dart';

/// Exporta los movimientos económicos de un proyecto (apuntes + ventas) a un
/// CSV apto para Excel (delimitador `;`, decimales con coma, BOM UTF-8), para
/// que el coordinador analice por su cuenta.
Future<File> generarCsvProyecto({
  required AppLocalizations textos,
  required String idioma,
  required ProyectoTest proyecto,
  required List<ApunteEconomico> apuntes,
  required List<RegistroComercializacion> ventas,
}) async {
  final formato = DateFormat('dd/MM/yyyy', idioma);
  String fecha(int ms) =>
      ms == 0 ? '' : formato.format(DateTime.fromMillisecondsSinceEpoch(ms));

  final filas = <String>[
    filaCsvAString([
      textos.comunFecha,
      textos.apuTipo,
      '${textos.apuCategoria} / ${textos.comCanal}',
      '${textos.apuConcepto} / ${textos.comProducto}',
      textos.apuImporte,
      textos.apuIva,
      'Base',
      'Cuota IVA',
    ], delim: ';'),
  ];

  for (final a in apuntes) {
    filas.add(filaCsvAString([
      fecha(a.fechaMs),
      buscarOpcion(tiposApunte, a.tipo)?.etiqueta(idioma) ?? a.tipo,
      buscarOpcion(categoriasDe(a.tipo), a.categoria)?.etiqueta(idioma) ??
          a.categoria,
      a.concepto,
      eurosDesdeCentimos(a.importeCentimos),
      '${a.ivaPorcentaje}',
      eurosDesdeCentimos(baseDesdeTotalConIva(a.importeCentimos, a.ivaPorcentaje)),
      eurosDesdeCentimos(cuotaIva(a.importeCentimos, a.ivaPorcentaje)),
    ], delim: ';'));
  }

  for (final v in ventas) {
    filas.add(filaCsvAString([
      fecha(v.fechaMs),
      textos.rentVentas,
      buscarOpcion(canalesComercializacion, v.canal)?.etiqueta(idioma) ?? v.canal,
      v.producto,
      eurosDesdeCentimos(v.ingresoCentimos),
      '${v.ivaPorcentaje}',
      eurosDesdeCentimos(baseDesdeTotalConIva(v.ingresoCentimos, v.ivaPorcentaje)),
      eurosDesdeCentimos(cuotaIva(v.ingresoCentimos, v.ivaPorcentaje)),
    ], delim: ';'));
  }

  final contenido = '﻿${filas.join('\r\n')}';
  final dir = await getTemporaryDirectory();
  final base = proyecto.nombre.isEmpty ? 'proyecto' : proyecto.nombre;
  final nombre =
      'proyecto_${base.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}.csv';
  final fichero = File('${dir.path}/$nombre');
  await fichero.writeAsString(contenido);
  return fichero;
}
