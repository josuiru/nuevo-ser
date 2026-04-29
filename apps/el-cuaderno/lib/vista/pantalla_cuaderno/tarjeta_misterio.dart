import 'package:flutter/material.dart';

import '../../dominio/misterio.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Una tarjeta para un Misterio abierto en el home. Pregunta + bajada
/// + estado discreto en sans gris ceniza ("hipótesis activa").
///
/// Widget puro — recibe el [Misterio] y un callback opcional al
/// pulsar para abrir su página.
class TarjetaMisterio extends StatelessWidget {
  const TarjetaMisterio({super.key, required this.misterio, this.alPulsar});

  final Misterio misterio;
  final VoidCallback? alPulsar;

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
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                misterio.pregunta,
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano16,
                  peso: TipografiaCuaderno.pesoMedio,
                  altoLinea: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                misterio.descripcionCorta,
                style: TipografiaCuaderno.serif(
                  color: PaletaCuaderno.tintaTenue,
                  tamano: TipografiaCuaderno.tamano13,
                  altoLinea: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                misterio.estado.toLocaleLabel(_idioma(textos)),
                style: TipografiaCuaderno.sans(
                  color: esquema.tertiary,
                  tamano: TipografiaCuaderno.tamano11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _idioma(TextosApp textos) => textos.localeName;
}
