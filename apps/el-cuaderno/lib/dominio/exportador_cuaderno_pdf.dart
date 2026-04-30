import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'misterio.dart';
import 'observacion.dart';
import 'sit_spot.dart';

/// Exporta el cuaderno del niño a un PDF legible. **El cuaderno es
/// del niño** (biblia §2.1) — y por tanto debe poder llevárselo en
/// formato leíble por una persona, no sólo en el JSON técnico.
///
/// **Fallback de experto pendiente de validación humana** (B4 +
/// B9 del plan):
/// - **Tipografía**. Hoy `Times Roman` por defecto del paquete `pdf`.
///   La biblia §11 prescribe una serif "calmada con presencia" — la
///   ilustradora botánica decidirá con un tipógrafo si entra Crimson
///   Pro, EB Garamond o similar.
/// - **Paleta**. Hoy negro tinta sobre blanco. La paleta crema del
///   cuaderno digital no se traslada todavía al PDF porque el
///   contraste WCAG sobre fondo crema requiere una tinta más oscura
///   que tinta `#2C2A24`, y eso es decisión que pertenece a la
///   auditoría WCAG 2.1 AA (B9).
/// - **Accesibilidad PDF/UA**: los `Text` van sin estructura semántica
///   accesible (TaggedPDF). Para release pública hay que añadir
///   etiquetas `Heading`, `P`, `List` con `pdfTagging` — eso lo
///   resuelve la consultora de accesibilidad junto con WCAG visual.
///
/// La función no toca disco ni red — devuelve los bytes del PDF.
/// El call site (PantallaAjustes en su botón "Exportar como PDF")
/// decide qué hacer con ellos: pasarlos a `printing.Printing.layoutPdf`
/// para que el SO ofrezca compartir/imprimir/guardar.
/// Función que devuelve los bytes de un fichero medio (foto o dibujo)
/// apuntado por una ruta relativa. Devuelve `null` si el fichero no
/// existe (no es error: el medio puede haber sido borrado a mano, el
/// dispositivo cambió, etc.).
typedef CargarMedioPdf = Future<Uint8List?> Function(String rutaRelativa);

class ExportadorCuadernoPdf {
  const ExportadorCuadernoPdf._();

  /// Genera los bytes del PDF.
  ///
  /// Si llega [cargarMedio], el exportador resuelve cada
  /// `Observacion.fotoRutaLocal` y `dibujoRutaLocal` antes de construir
  /// el documento para incrustar las imágenes con `pw.MemoryImage`.
  /// Sin [cargarMedio] el PDF queda como antes (sólo texto) — los
  /// tests de dominio siguen ejecutándose sin filesystem.
  static Future<Uint8List> aBytes({
    required String tituloDelNino,
    required List<Observacion> observaciones,
    SitSpot? sitSpot,
    required List<Misterio> misterios,
    DateTime? exportadoEn,
    CargarMedioPdf? cargarMedio,
  }) async {
    final fecha = exportadoEn ?? DateTime.now();
    final documento = pw.Document(
      title: 'Cuaderno de $tituloDelNino',
      author: tituloDelNino,
      creator: 'El Cuaderno (Colección Nuevo Ser Kids)',
    );

    final mediosPorObservacion =
        await _resolverMedios(observaciones, cargarMedio);

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(48),
        build: (context) => [
          _portada(tituloDelNino, fecha),
          pw.SizedBox(height: 24),
          if (sitSpot != null) ...[
            _seccionSitSpot(sitSpot),
            pw.SizedBox(height: 24),
          ],
          if (misterios.isNotEmpty) ...[
            _seccionMisterios(misterios),
            pw.SizedBox(height: 24),
          ],
          _seccionObservaciones(observaciones, mediosPorObservacion),
        ],
      ),
    );

    return documento.save();
  }

  /// Pre-carga las imágenes en paralelo (foto + dibujo de cada
  /// observación) y devuelve un mapa por id. Si no hay [cargarMedio]
  /// inyectado, devuelve mapa vacío y `_seccionObservaciones` cae al
  /// formato sólo-texto.
  static Future<Map<String, _MediosObservacion>> _resolverMedios(
    List<Observacion> observaciones,
    CargarMedioPdf? cargarMedio,
  ) async {
    if (cargarMedio == null) return const {};
    final resultado = <String, _MediosObservacion>{};
    for (final observacion in observaciones) {
      final foto = observacion.fotoRutaLocal;
      final dibujo = observacion.dibujoRutaLocal;
      if (foto == null && dibujo == null) continue;
      final fotoFuture = foto != null ? cargarMedio(foto) : Future.value(null);
      final dibujoFuture =
          dibujo != null ? cargarMedio(dibujo) : Future.value(null);
      final resueltos = await Future.wait([fotoFuture, dibujoFuture]);
      resultado[observacion.id] = _MediosObservacion(
        foto: resueltos[0],
        dibujo: resueltos[1],
      );
    }
    return resultado;
  }

  static pw.Widget _portada(String nombre, DateTime fecha) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Cuaderno de $nombre',
          style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Exportado el ${_fechaLargaCastellano(fecha)}',
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static pw.Widget _seccionSitSpot(SitSpot sitSpot) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _cabeceraSeccion('Tu sit spot'),
        pw.SizedBox(height: 8),
        pw.Text(sitSpot.nombre,
            style: pw.TextStyle(
                fontSize: 16, fontWeight: pw.FontWeight.bold)),
        if (sitSpot.dondeNombre.isNotEmpty)
          pw.Text(sitSpot.dondeNombre,
              style: const pw.TextStyle(fontSize: 12)),
      ],
    );
  }

  static pw.Widget _seccionMisterios(List<Misterio> misterios) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _cabeceraSeccion('Misterios abiertos'),
        pw.SizedBox(height: 8),
        for (final misterio in misterios.where((m) => m.abierto)) ...[
          pw.Text(misterio.pregunta,
              style: pw.TextStyle(
                  fontSize: 14, fontWeight: pw.FontWeight.bold)),
          if (misterio.descripcionCorta.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 12, top: 2),
              child: pw.Text(misterio.descripcionCorta,
                  style: const pw.TextStyle(fontSize: 11)),
            ),
          pw.SizedBox(height: 8),
        ],
      ],
    );
  }

  static pw.Widget _seccionObservaciones(
    List<Observacion> observaciones,
    Map<String, _MediosObservacion> medios,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _cabeceraSeccion('Observaciones'),
        pw.SizedBox(height: 8),
        if (observaciones.isEmpty)
          pw.Text(
            'Aún no hay observaciones anotadas.',
            style: pw.TextStyle(
              fontSize: 11,
              color: PdfColors.grey700,
              fontStyle: pw.FontStyle.italic,
            ),
          )
        else
          for (final observacion in observaciones)
            _entradaObservacion(observacion, medios[observacion.id]),
      ],
    );
  }

  static pw.Widget _entradaObservacion(
    Observacion observacion,
    _MediosObservacion? medios,
  ) {
    final imagenes = <pw.Widget>[];
    final foto = medios?.foto;
    if (foto != null) {
      imagenes.add(_imagenContenida(foto, etiqueta: 'foto'));
    }
    final dibujo = medios?.dibujo;
    if (dibujo != null) {
      imagenes.add(_imagenContenida(dibujo, etiqueta: 'dibujo'));
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${_fechaCortaCastellano(observacion.cuandoOcurrio)} · ${observacion.dondeNombre}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 4),
          pw.Text(observacion.queVio, style: const pw.TextStyle(fontSize: 12)),
          if (observacion.creesQueEs != null && observacion.creesQueEs!.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 4),
              child: pw.Text(
                'crees que es: ${observacion.creesQueEs}',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey800,
                ),
              ),
            ),
          pw.SizedBox(height: 2),
          pw.Text(
            'confianza: ${_etiquetaConfianza(observacion.confianza)}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          if (imagenes.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Wrap(
              spacing: 12,
              runSpacing: 8,
              children: imagenes,
            ),
          ],
        ],
      ),
    );
  }

  /// Encierra la imagen en una caja de tamaño contenido. El ancho
  /// máximo es 220 pt (≈30% del ancho útil de A4 con márgenes 48 pt) y
  /// la altura escala manteniendo proporción gracias a `fit:
  /// BoxFit.contain`. Por debajo, la etiqueta breve dice qué es.
  static pw.Widget _imagenContenida(
    Uint8List bytes, {
    required String etiqueta,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 220,
          height: 165,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
          ),
          child: pw.Image(
            pw.MemoryImage(bytes),
            fit: pw.BoxFit.contain,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          etiqueta,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
      ],
    );
  }

  static pw.Widget _cabeceraSeccion(String texto) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
        ),
      ),
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        texto,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static const _meses = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  static String _fechaLargaCastellano(DateTime fecha) {
    return '${fecha.day} de ${_meses[fecha.month - 1]} de ${fecha.year}';
  }

  static String _fechaCortaCastellano(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  static String _etiquetaConfianza(dynamic confianza) {
    final str = confianza.toString().split('.').last;
    switch (str) {
      case 'consenso':
        return 'consenso';
      case 'hipotesisActiva':
        return 'hipótesis activa';
      case 'noSegura':
        return 'no segura';
      case 'abandonado':
        return 'abandonado';
      default:
        return str;
    }
  }
}

/// Bytes ya en memoria de los medios de una observación. Se cachea
/// antes del build del PDF para no mezclar I/O con widgets.
class _MediosObservacion {
  const _MediosObservacion({this.foto, this.dibujo});

  final Uint8List? foto;
  final Uint8List? dibujo;
}
