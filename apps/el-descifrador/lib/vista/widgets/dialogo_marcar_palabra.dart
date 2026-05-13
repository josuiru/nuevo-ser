// Dialog para marcar una palabra con verde / amarillo / rojo y
// escribir hipótesis opcional. Sobrio según manifiesto Kids §9.

import 'package:flutter/material.dart';

import '../../dominio/vocabulario_jugador.dart';
import '../paleta_estafeta.dart';

/// Resultado del diálogo. null si el niño cierra sin decidir.
class ResultadoMarca {
  const ResultadoMarca.aplicar(this.marca) : olvidar = false;
  const ResultadoMarca.olvidar()
      : marca = null,
        olvidar = true;

  final MarcaPalabra? marca;
  final bool olvidar;
}

/// Abre el diálogo modal. Devuelve ResultadoMarca o null si cancela.
Future<ResultadoMarca?> mostrarDialogoMarcarPalabra({
  required BuildContext contexto,
  required String palabraOriginal,
  required MarcaPalabra? marcaActual,
}) {
  return showDialog<ResultadoMarca>(
    context: contexto,
    builder: (contexto) => _DialogoMarcarPalabra(
      palabraOriginal: palabraOriginal,
      marcaActual: marcaActual,
    ),
  );
}

class _DialogoMarcarPalabra extends StatefulWidget {
  const _DialogoMarcarPalabra({
    required this.palabraOriginal,
    required this.marcaActual,
  });

  final String palabraOriginal;
  final MarcaPalabra? marcaActual;

  @override
  State<_DialogoMarcarPalabra> createState() => _EstadoDialogo();
}

class _EstadoDialogo extends State<_DialogoMarcarPalabra> {
  late MarcaColor? _colorSeleccionado;
  late final TextEditingController _controladorHipotesis;

  @override
  void initState() {
    super.initState();
    _colorSeleccionado = widget.marcaActual?.color;
    _controladorHipotesis = TextEditingController(
      text: widget.marcaActual?.hipotesis ?? '',
    );
  }

  @override
  void dispose() {
    _controladorHipotesis.dispose();
    super.dispose();
  }

  void _aplicar() {
    final color = _colorSeleccionado;
    if (color == null) return;
    final hipotesisTrim = _controladorHipotesis.text.trim();
    Navigator.of(context).pop(
      ResultadoMarca.aplicar(
        MarcaPalabra(
          color: color,
          hipotesis: hipotesisTrim.isEmpty ? null : hipotesisTrim,
        ),
      ),
    );
  }

  void _olvidar() {
    Navigator.of(context).pop(const ResultadoMarca.olvidar());
  }

  @override
  Widget build(BuildContext contexto) {
    return Dialog(
      backgroundColor: PaletaEstafeta.papel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.palabraOriginal,
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 20,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _BotonColor(
                      color: MarcaColor.verde,
                      etiqueta: 'La conozco',
                      seleccionado: _colorSeleccionado == MarcaColor.verde,
                      alPulsar: () => setState(
                        () => _colorSeleccionado = MarcaColor.verde,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _BotonColor(
                      color: MarcaColor.amarillo,
                      etiqueta: 'Me suena',
                      seleccionado: _colorSeleccionado == MarcaColor.amarillo,
                      alPulsar: () => setState(
                        () => _colorSeleccionado = MarcaColor.amarillo,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _BotonColor(
                      color: MarcaColor.rojo,
                      etiqueta: 'No la conozco',
                      seleccionado: _colorSeleccionado == MarcaColor.rojo,
                      alPulsar: () => setState(
                        () => _colorSeleccionado = MarcaColor.rojo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controladorHipotesis,
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 14,
                  fontFamily: 'serif',
                ),
                decoration: InputDecoration(
                  hintText: 'Anota lo que crees (opcional)',
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
                  isDense: true,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.marcaActual != null)
                    TextButton(
                      onPressed: _olvidar,
                      style: TextButton.styleFrom(
                        foregroundColor: PaletaEstafeta.sepia,
                      ),
                      child: const Text(
                        'Olvidar marca',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: PaletaEstafeta.tinta,
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      OutlinedButton(
                        onPressed:
                            _colorSeleccionado == null ? null : _aplicar,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: PaletaEstafeta.tinta,
                          side: const BorderSide(color: PaletaEstafeta.sepia),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: const Text(
                          'Guardar',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
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

class _BotonColor extends StatelessWidget {
  const _BotonColor({
    required this.color,
    required this.etiqueta,
    required this.seleccionado,
    required this.alPulsar,
  });

  final MarcaColor color;
  final String etiqueta;
  final bool seleccionado;
  final VoidCallback alPulsar;

  Color get _colorFondo {
    switch (color) {
      case MarcaColor.verde:
        return const Color(0xFFDCEDC8);
      case MarcaColor.amarillo:
        return const Color(0xFFFFF59D);
      case MarcaColor.rojo:
        return const Color(0xFFFFCDD2);
    }
  }

  Color get _colorBorde {
    switch (color) {
      case MarcaColor.verde:
        return const Color(0xFF558B2F);
      case MarcaColor.amarillo:
        return const Color(0xFFE0A500);
      case MarcaColor.rojo:
        return const Color(0xFFC62828);
    }
  }

  @override
  Widget build(BuildContext contexto) {
    return Material(
      color: seleccionado ? _colorFondo : Colors.transparent,
      borderRadius: BorderRadius.circular(2),
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: seleccionado
                  ? _colorBorde
                  : PaletaEstafeta.sepia.withValues(alpha: 0.3),
              width: seleccionado ? 1.5 : 1.0,
            ),
          ),
          child: Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PaletaEstafeta.tinta,
              fontSize: 12,
              fontFamily: 'serif',
              fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
