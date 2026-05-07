import 'package:flutter/material.dart';

import '../../dominio/misterio.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/tipografia.dart';

/// Selector opcional para anclar la observación a un Misterio. En el
/// flujo del campo (doc 13 §3.2.5) el sistema ofrece el Misterio que
/// encaja por contexto; en S1, sin contexto detectado, mostramos un
/// dropdown con los abiertos del niño.
///
/// "ninguno" siempre disponible — es el estado natural por defecto.
class SelectorMisterio extends StatelessWidget {
  const SelectorMisterio({
    super.key,
    required this.misteriosAbiertos,
    required this.misterioSeleccionadoId,
    required this.alCambiar,
  });

  final List<Misterio> misteriosAbiertos;
  final String? misterioSeleccionadoId;
  final ValueChanged<String?> alCambiar;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);

    if (misteriosAbiertos.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButtonFormField<String?>(
      value: misterioSeleccionadoId,
      onChanged: alCambiar,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: esquema.outline),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      style: TipografiaCuaderno.serif(
        color: esquema.onSurface,
        tamano: TipografiaCuaderno.tamano13,
      ),
      items: <DropdownMenuItem<String?>>[
        DropdownMenuItem<String?>(
          value: null,
          child: Text(
            'ninguno',
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano13,
            ),
          ),
        ),
        for (final misterio in misteriosAbiertos)
          DropdownMenuItem<String?>(
            value: misterio.id,
            child: Text(
              misterio.preguntaEn(textos.localeName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TipografiaCuaderno.serif(
                color: esquema.onSurface,
                tamano: TipografiaCuaderno.tamano13,
              ),
            ),
          ),
      ],
    );
  }
}
