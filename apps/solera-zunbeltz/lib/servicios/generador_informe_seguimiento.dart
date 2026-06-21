import 'dart:io';

import 'package:intl/intl.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../l10n/app_localizations.dart';
import '../modelos/apunte_economico.dart';
import '../modelos/constantes.dart';
import '../modelos/indicadores_seguimiento.dart';
import '../modelos/registro_actividad.dart';

/// Genera el informe de seguimiento en PDF (indicadores del periodo +
/// registros de actividad + apuntes económicos) reutilizando el informe
/// periódico del core. Sello PROVISIONAL hasta validación humana.
Future<File> generarInformeSeguimientoPdf({
  required AppLocalizations textos,
  required String idioma,
  required IndicadoresSeguimiento indicadores,
  required List<RegistroActividad> actividades,
  required List<ApunteEconomico> apuntes,
}) async {
  final formatoFecha = DateFormat('dd/MM/yyyy', idioma);

  String etiqueta(List<OpcionCatalogo> catalogo, String codigo) =>
      buscarOpcion(catalogo, codigo)?.etiqueta(idioma) ?? codigo;

  String fecha(int ms) =>
      ms == 0 ? '—' : formatoFecha.format(DateTime.fromMillisecondsSinceEpoch(ms));

  return generarInformePeriodicoPdf(
    tituloCabecera: textos.informeSegTitulo,
    subtituloCabecera: textos.parteSubtitulo,
    bulletsResumen: [
      textos.parteProvisional,
      textos.informeSegResumenPeriodo(actividades.length, apuntes.length),
      '${textos.segAlimentacion}: ${cantidadBonita(indicadores.kgAlimentacion)}',
      '${textos.segPariciones}: ${cantidadBonita(indicadores.pariciones)}',
      '${textos.segProductos}: ${cantidadBonita(indicadores.productos)}',
      '${textos.segIngresos}: ${eurosDesdeCentimos(indicadores.ingresosCentimos)} €',
      '${textos.segGastos}: ${eurosDesdeCentimos(indicadores.gastosCentimos)} €',
      '${textos.segBalance}: ${eurosDesdeCentimos(indicadores.balanceCentimos)} €',
    ],
    tablas: [
      TablaInforme(
        titulo: textos.informeSegTablaActividad,
        headers: [
          textos.informeSegColTipo,
          textos.informeSegColCantidad,
          textos.actLote,
          textos.comunFecha,
        ],
        mensajeSiVacia: textos.segSinRegistros,
        filas: [
          for (final a in actividades)
            [
              etiqueta(tiposActividad, a.tipo),
              '${cantidadBonita(a.cantidad)} ${unidadActividad(a.tipo, idioma)}',
              a.lote,
              fecha(a.fechaMs),
            ],
        ],
      ),
      TablaInforme(
        titulo: textos.informeSegTablaEconomico,
        headers: [
          textos.informeSegColTipo,
          textos.informeSegColConcepto,
          textos.informeSegColImporte,
          textos.comunFecha,
        ],
        mensajeSiVacia: textos.segSinRegistros,
        filas: [
          for (final a in apuntes)
            [
              etiqueta(tiposApunte, a.tipo),
              a.concepto,
              eurosDesdeCentimos(a.importeCentimos),
              fecha(a.fechaMs),
            ],
        ],
      ),
    ],
    prefijoNombreFichero: 'informe_seguimiento',
  );
}
