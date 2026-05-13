// Widget que tokeniza un texto en palabras y permite tocar cada
// palabra para marcarla. Las palabras ya marcadas se muestran
// subrayadas con el color de su marca.
//
// La tokenización es deliberadamente simple: separador es espacio o
// salto de línea. Los signos de puntuación pegados a la palabra
// se quedan visualmente con ella, pero la normalización para
// almacenamiento los retira (ver normalizarPalabra).

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../dominio/lengua.dart';
import '../../dominio/vocabulario_jugador.dart';
import '../paleta_estafeta.dart';

class TextoMarcable extends StatefulWidget {
  const TextoMarcable({
    super.key,
    required this.texto,
    required this.lengua,
    required this.vocabulario,
    required this.alTocarPalabra,
    this.estiloBase,
  });

  final String texto;
  final Lengua lengua;
  final VocabularioJugador vocabulario;
  final void Function(String palabraOriginal) alTocarPalabra;
  final TextStyle? estiloBase;

  @override
  State<TextoMarcable> createState() => _EstadoTextoMarcable();
}

class _EstadoTextoMarcable extends State<TextoMarcable> {
  final List<TapGestureRecognizer> _reconocedores = [];

  @override
  void dispose() {
    for (final reconocedor in _reconocedores) {
      reconocedor.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext contexto) {
    final estiloBase = widget.estiloBase ??
        const TextStyle(
          color: PaletaEstafeta.tinta,
          fontSize: 16,
          fontFamily: 'serif',
          height: 1.6,
        );

    // Limpiar reconocedores anteriores antes de reconstruir.
    for (final reconocedor in _reconocedores) {
      reconocedor.dispose();
    }
    _reconocedores.clear();

    final segmentos = _segmentar(widget.texto);
    final spans = <InlineSpan>[];
    for (final segmento in segmentos) {
      if (segmento.esPalabra) {
        final marca = widget.vocabulario.marcaDe(
          widget.lengua,
          segmento.contenido,
        );
        final reconocedor = TapGestureRecognizer()
          ..onTap = () => widget.alTocarPalabra(segmento.contenido);
        _reconocedores.add(reconocedor);

        spans.add(
          TextSpan(
            text: segmento.contenido,
            style: _estiloParaMarca(estiloBase, marca),
            recognizer: reconocedor,
          ),
        );
      } else {
        spans.add(TextSpan(text: segmento.contenido, style: estiloBase));
      }
    }

    return SelectableText.rich(
      TextSpan(children: spans, style: estiloBase),
      // SelectableText permite seleccionar para copiar; pero el tap
      // simple sobre palabra dispara el recognizer.
    );
  }

  TextStyle _estiloParaMarca(TextStyle base, MarcaPalabra? marca) {
    if (marca == null) return base;
    final color = _colorParaMarca(marca.color);
    return base.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: color,
      decorationThickness: 2.5,
      decorationStyle: TextDecorationStyle.solid,
    );
  }

  Color _colorParaMarca(MarcaColor color) {
    switch (color) {
      case MarcaColor.verde:
        return const Color(0xFF558B2F);
      case MarcaColor.amarillo:
        return const Color(0xFFE0A500);
      case MarcaColor.rojo:
        return const Color(0xFFC62828);
    }
  }
}

/// Segmento del texto: palabra o separador.
class _SegmentoTexto {
  const _SegmentoTexto.palabra(this.contenido) : esPalabra = true;
  const _SegmentoTexto.separador(this.contenido) : esPalabra = false;

  final String contenido;
  final bool esPalabra;
}

List<_SegmentoTexto> _segmentar(String texto) {
  final segmentos = <_SegmentoTexto>[];
  final buffer = StringBuffer();
  bool enPalabra = false;

  void cerrar() {
    if (buffer.isEmpty) return;
    if (enPalabra) {
      segmentos.add(_SegmentoTexto.palabra(buffer.toString()));
    } else {
      segmentos.add(_SegmentoTexto.separador(buffer.toString()));
    }
    buffer.clear();
  }

  for (final caracter in texto.split('')) {
    final esEspacio = caracter == ' ' || caracter == '\n' || caracter == '\t';
    if (esEspacio) {
      if (enPalabra) cerrar();
      enPalabra = false;
      buffer.write(caracter);
    } else {
      if (!enPalabra && buffer.isNotEmpty) cerrar();
      enPalabra = true;
      buffer.write(caracter);
    }
  }
  cerrar();
  return segmentos;
}
