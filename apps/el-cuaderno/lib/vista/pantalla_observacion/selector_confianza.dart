import 'package:flutter/material.dart';

import '../../dominio/nivel_confianza.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/tipografia.dart';

/// Tres chips horizontales con las opciones canónicas (doc 13 §3.2):
/// `consenso`, `hipótesis activa`, `no estoy segura`. Por defecto
/// seleccionado `hipótesis activa` — es el estado natural al
/// registrar algo nuevo.
///
/// Con tooltips al mantener pulsado: el de `consenso` recuerda que
/// solo se declara así si lo confirmó una clave o el Tutor; el de
/// `no estoy segura` honra explícitamente el "no sé" como respuesta
/// válida del oficio.
///
/// `abandonado` no aparece — pertenece a Misterios, no a observaciones
/// individuales.
class SelectorConfianza extends StatelessWidget {
  const SelectorConfianza({
    super.key,
    required this.confianza,
    required this.alCambiar,
  });

  final NivelConfianza confianza;
  final ValueChanged<NivelConfianza> alCambiar;

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;

    final opciones = <_OpcionConfianza>[
      _OpcionConfianza(
        valor: NivelConfianza.consenso,
        etiqueta: textos.confianzaConsenso,
        tooltip: textos.confianzaConsensoTooltip,
      ),
      _OpcionConfianza(
        valor: NivelConfianza.hipotesisActiva,
        etiqueta: textos.confianzaHipotesisActiva,
      ),
      _OpcionConfianza(
        valor: NivelConfianza.noSegura,
        etiqueta: textos.confianzaNoSegura,
        tooltip: textos.confianzaNoSeguraTooltip,
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final opcion in opciones)
          _ChipConfianza(
            opcion: opcion,
            seleccionado: opcion.valor == confianza,
            onTap: () => alCambiar(opcion.valor),
            esquema: esquema,
          ),
      ],
    );
  }
}

class _OpcionConfianza {
  const _OpcionConfianza({
    required this.valor,
    required this.etiqueta,
    this.tooltip,
  });

  final NivelConfianza valor;
  final String etiqueta;
  final String? tooltip;
}

class _ChipConfianza extends StatelessWidget {
  const _ChipConfianza({
    required this.opcion,
    required this.seleccionado,
    required this.onTap,
    required this.esquema,
  });

  final _OpcionConfianza opcion;
  final bool seleccionado;
  final VoidCallback onTap;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    final fondo =
        seleccionado ? esquema.surfaceContainerHighest : esquema.surface;
    final borde = seleccionado ? esquema.tertiary : esquema.outline;

    final chip = Material(
      color: fondo,
      shape: StadiumBorder(
        side: BorderSide(color: borde, width: seleccionado ? 1 : 0.5),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            opcion.etiqueta,
            style: TipografiaCuaderno.sans(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano13,
              peso: seleccionado
                  ? TipografiaCuaderno.pesoMedio
                  : TipografiaCuaderno.pesoRegular,
            ),
          ),
        ),
      ),
    );

    if (opcion.tooltip == null) {
      return chip;
    }
    return Tooltip(message: opcion.tooltip!, child: chip);
  }
}
