import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'exportador_cuaderno_pdf.dart' show CargarMedioPdf;
import 'observacion.dart';

/// Genera un PDF **A5 vertical de una sola página** con una observación
/// concreta. Pensado para "imprime esa página y pégala en la nevera"
/// o "mándasela al abuelo" — el cuaderno es del niño, y a veces la
/// niña quiere darle a una persona lo que ha visto.
///
/// **Fallback de experto pendiente** (B4 + B9): la tipografía es la
/// `Times Roman` del paquete `pdf` y la paleta es negro tinta sobre
/// blanco. La ilustradora botánica + el auditor WCAG decidirán la
/// versión definitiva.
///
/// Si llega [cargarMedio], se intenta incrustar la foto y el dibujo
/// como `pw.MemoryImage` — si la ruta apunta a un fichero que ya no
/// existe (medio borrado a mano, dispositivo migrado), se omite el
/// bloque correspondiente sin lanzar. La función nunca toca disco ni
/// red por sí misma; toda la I/O viaja por el callback.
class GeneradorObservacionPdf {
  const GeneradorObservacionPdf._();

  static Future<Uint8List> aBytes({
    required Observacion observacion,
    String? nombreDelNino,
    String? nombreSitSpot,
    CargarMedioPdf? cargarMedio,
  }) async {
    final documento = pw.Document(
      title: 'Página del cuaderno',
      author: nombreDelNino,
      creator: 'El Cuaderno (Colección Nuevo Ser Kids)',
    );

    Uint8List? fotoBytes;
    Uint8List? dibujoBytes;
    if (cargarMedio != null) {
      if (observacion.fotoRutaLocal != null) {
        fotoBytes = await cargarMedio(observacion.fotoRutaLocal!);
      }
      if (observacion.dibujoRutaLocal != null) {
        dibujoBytes = await cargarMedio(observacion.dibujoRutaLocal!);
      }
    }

    documento.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.fromLTRB(36, 40, 36, 36),
        build: (context) => _construirPagina(
          observacion: observacion,
          nombreDelNino: nombreDelNino,
          nombreSitSpot: nombreSitSpot,
          fotoBytes: fotoBytes,
          dibujoBytes: dibujoBytes,
        ),
      ),
    );

    return documento.save();
  }

  static pw.Widget _construirPagina({
    required Observacion observacion,
    required String? nombreDelNino,
    required String? nombreSitSpot,
    required Uint8List? fotoBytes,
    required Uint8List? dibujoBytes,
  }) {
    final cabecera = _formatearCabecera(observacion);
    final pieDelNino = (nombreDelNino?.trim().isEmpty ?? true)
        ? 'Cuaderno de campo'
        : 'Cuaderno de campo · ${nombreDelNino!.trim()}';
    final lineaSitSpot = (nombreSitSpot?.trim().isEmpty ?? true)
        ? null
        : 'Sit spot: ${nombreSitSpot!.trim()}';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          cabecera,
          style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
        ),
        if (lineaSitSpot != null) ...[
          pw.SizedBox(height: 4),
          pw.Text(
            lineaSitSpot,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
        pw.SizedBox(height: 12),
        pw.Divider(thickness: 0.5, color: PdfColors.grey400),
        pw.SizedBox(height: 12),
        pw.Text(
          'Qué viste',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          observacion.queVio,
          style: const pw.TextStyle(fontSize: 14, lineSpacing: 4),
        ),
        if (observacion.creesQueEs != null &&
            observacion.creesQueEs!.isNotEmpty) ...[
          pw.SizedBox(height: 14),
          pw.Text(
            'Crees que es',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '${observacion.creesQueEs} · '
            '${observacion.confianza.toLocaleLabel('es')}',
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
        if (observacion.climaResumen != null &&
            observacion.climaResumen!.isNotEmpty) ...[
          pw.SizedBox(height: 10),
          pw.Text(
            'Tiempo: ${observacion.climaResumen}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
        if (fotoBytes != null) ...[
          pw.SizedBox(height: 14),
          pw.Container(
            constraints: const pw.BoxConstraints(maxHeight: 220),
            child: pw.Image(pw.MemoryImage(fotoBytes), fit: pw.BoxFit.contain),
          ),
        ],
        if (dibujoBytes != null) ...[
          pw.SizedBox(height: 14),
          pw.Container(
            constraints: const pw.BoxConstraints(maxHeight: 220),
            child:
                pw.Image(pw.MemoryImage(dibujoBytes), fit: pw.BoxFit.contain),
          ),
        ],
        pw.Spacer(),
        pw.Divider(thickness: 0.5, color: PdfColors.grey400),
        pw.SizedBox(height: 4),
        pw.Text(
          pieDelNino,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
      ],
    );
  }

  static String _formatearCabecera(Observacion observacion) {
    final cuando = observacion.cuandoOcurrio;
    final fecha = '${cuando.day.toString().padLeft(2, '0')}/'
        '${cuando.month.toString().padLeft(2, '0')}/${cuando.year}';
    if (observacion.dondeNombre.isEmpty) return fecha;
    return '$fecha · ${observacion.dondeNombre}';
  }
}
