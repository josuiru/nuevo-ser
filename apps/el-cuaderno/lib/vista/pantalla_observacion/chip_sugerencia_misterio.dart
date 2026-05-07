import 'package:flutter/material.dart';

import '../../dominio/misterio.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Chip discreto que ofrece un Misterio candidato derivado de lo que
/// el niño ha escrito (o de lo que ya hay en una observación pasada).
/// Dos botones explícitos `no` / `anclar`, sin auto-aceptar — el niño
/// decide. Pedagogía: invita a recordar que el Misterio existe, sin
/// imponer; la observación encaja con una pregunta abierta (biblia
/// §3.4 hipotetizar y contrastar).
///
/// Se usa desde [PantallaObservacion] (al crear) y desde
/// [PantallaDetalleObservacion] (al releer una página antigua y darse
/// cuenta de que encajaba con un Misterio).
class ChipSugerenciaMisterio extends StatelessWidget {
  const ChipSugerenciaMisterio({
    super.key,
    required this.misterioSugerido,
    required this.alAnclar,
    required this.alRechazar,
  });

  final Misterio misterioSugerido;
  final VoidCallback alAnclar;
  final VoidCallback alRechazar;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    return Material(
      color: esquema.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: esquema.outline, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'esto suena al Misterio:',
              style: TipografiaCuaderno.sans(
                color: PaletaCuaderno.tintaTenue,
                tamano: TipografiaCuaderno.tamano11,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              misterioSugerido.preguntaEn(textos.localeName),
              style: TipografiaCuaderno.serif(
                color: esquema.onSurface,
                tamano: TipografiaCuaderno.tamano14,
                peso: TipografiaCuaderno.pesoMedio,
                altoLinea: 1.35,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: alRechazar,
                  child: Text(textos.chipSugerenciaMisterioNo),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: alAnclar,
                  child: Text(textos.chipSugerenciaMisterioAnclar),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
