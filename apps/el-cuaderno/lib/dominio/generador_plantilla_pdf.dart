import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Genera un PDF con páginas en blanco listas para llevar al campo
/// con el cuaderno **en papel**. El campo no tiene wifi (biblia §2.8
/// offline-first) y a veces el aparato distrae más que ayuda — la
/// niña con su cuaderno físico en la mochila es exactamente lo que
/// el juego apunta.
///
/// Cada página tiene la estructura del oficio: hueco para fecha y
/// lugar, recuadro grande para *qué viste* (lo más importante),
/// recuadro para *crees que es* + tres casillas de confianza, y
/// recuadro grande inferior para el dibujo.
///
/// **Fallback de experto pendiente** (B4 + B9 del plan): tipografía
/// y paleta no son las definitivas — Times Roman + tinta negra sobre
/// blanco mientras la ilustradora botánica + auditoría WCAG no
/// cierren guía visual del PDF.
class GeneradorPlantillaPdf {
  const GeneradorPlantillaPdf._();

  /// Genera los bytes del PDF.
  ///
  /// [nombreNino] aparece en la cabecera de cada página. Si está
  /// vacío, la cabecera dice sólo "Cuaderno de campo".
  ///
  /// [nombreSitSpot] aparece en la cabecera bajo el nombre del niño.
  /// Si es null, la cabecera no muestra ese línea.
  ///
  /// [paginas] es el número de páginas en blanco a generar (1..32 —
  /// más arriba la impresión doméstica empieza a dolerle al cartucho
  /// y al planeta; el operador puede subir el cap si lo necesita).
  static Future<Uint8List> generar({
    required int paginas,
    String nombreNino = '',
    String? nombreSitSpot,
  }) async {
    if (paginas < 1 || paginas > 32) {
      throw ArgumentError.value(
        paginas,
        'paginas',
        'pídele entre 1 y 32 páginas',
      );
    }

    final tituloCabecera = nombreNino.trim().isEmpty
        ? 'Cuaderno de campo'
        : 'Cuaderno de campo · $nombreNino';

    final documento = pw.Document(
      title: tituloCabecera,
      author: nombreNino.trim().isEmpty ? 'El Cuaderno' : nombreNino,
    );

    for (var indice = 0; indice < paginas; indice++) {
      documento.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(40, 36, 40, 40),
          build: (contexto) => _construirPagina(
            tituloCabecera: tituloCabecera,
            nombreSitSpot: nombreSitSpot,
            numeroPagina: indice + 1,
            totalPaginas: paginas,
          ),
        ),
      );
    }

    return documento.save();
  }

  static pw.Widget _construirPagina({
    required String tituloCabecera,
    required String? nombreSitSpot,
    required int numeroPagina,
    required int totalPaginas,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // Cabecera. Línea fina y serena — esto es papel real, no
        // pantalla. La paleta crema/tinta no se traslada todavía
        // (B4 + B9).
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              tituloCabecera,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.normal,
                color: PdfColors.grey800,
              ),
            ),
            pw.Text(
              'pág. $numeroPagina de $totalPaginas',
              style: const pw.TextStyle(
                fontSize: 9,
                color: PdfColors.grey600,
              ),
            ),
          ],
        ),
        if (nombreSitSpot != null && nombreSitSpot.trim().isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text(
            'Sit spot: $nombreSitSpot',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
        ],
        pw.SizedBox(height: 6),
        pw.Container(
          height: 0.5,
          color: PdfColors.grey400,
        ),
        pw.SizedBox(height: 14),

        // Línea de fecha y lugar — dos huecos pequeños lado a lado.
        _filaCampoLinea(['Día y hora', 'Dónde estabas']),
        pw.SizedBox(height: 14),

        // Bloque "qué viste" — recuadro grande con su título.
        _bloqueRecuadro('Qué viste', altura: 130),
        pw.SizedBox(height: 12),

        // Bloque "crees que es" + casillas de confianza.
        _bloqueRecuadro('Crees que es', altura: 56),
        pw.SizedBox(height: 8),
        _filaConfianza(),
        pw.SizedBox(height: 14),

        // Bloque dibujo — el resto del espacio disponible. Como
        // pw.Page no permite Expanded de Column directamente,
        // usamos un recuadro de altura calculada que ocupe el
        // espacio razonable.
        _bloqueRecuadro('Dibuja', altura: 320),
      ],
    );
  }

  /// Una fila con N campos pequeños — cada uno con su etiqueta
  /// arriba y una línea de escritura debajo.
  static pw.Widget _filaCampoLinea(List<String> etiquetas) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (final (indice, etiqueta) in etiquetas.indexed) ...[
          if (indice > 0) pw.SizedBox(width: 14),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  etiqueta,
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 18),
                pw.Container(
                  height: 0.5,
                  color: PdfColors.grey500,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Recuadro etiquetado con altura fija para escribir o dibujar
  /// dentro. Sin líneas pautadas — el campo es libre, como el
  /// cuaderno botánico clásico.
  static pw.Widget _bloqueRecuadro(String etiqueta, {required double altura}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          etiqueta,
          style: const pw.TextStyle(
            fontSize: 9,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Container(
          height: altura,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
          ),
        ),
      ],
    );
  }

  /// Tres casillas de confianza con su etiqueta a la derecha. Las
  /// casillas son cuadritos vacíos que la niña marca a mano.
  static pw.Widget _filaConfianza() {
    return pw.Row(
      children: [
        _casillaConEtiqueta('consenso'),
        pw.SizedBox(width: 14),
        _casillaConEtiqueta('hipótesis activa'),
        pw.SizedBox(width: 14),
        _casillaConEtiqueta('no segura'),
      ],
    );
  }

  static pw.Widget _casillaConEtiqueta(String etiqueta) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 10,
          height: 10,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey600, width: 0.6),
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Text(
          etiqueta,
          style: const pw.TextStyle(
            fontSize: 9,
            color: PdfColors.grey800,
          ),
        ),
      ],
    );
  }
}
