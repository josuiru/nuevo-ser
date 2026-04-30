import 'package:flutter/material.dart';

import '../../dominio/misterio.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Una tarjeta para un Misterio abierto en el home. Pregunta + bajada
/// + estado discreto en sans gris ceniza ("hipótesis activa") + un
/// contador opcional de evidencias anotadas para que el niño sepa,
/// de un vistazo, cuánto ha trabajado para cada Misterio.
///
/// Widget puro — recibe el [Misterio], opcionalmente el conteo de
/// evidencias ancladas, y un callback opcional al pulsar.
class TarjetaMisterio extends StatelessWidget {
  const TarjetaMisterio({
    super.key,
    required this.misterio,
    this.evidencias,
    this.alPulsar,
  });

  final Misterio misterio;

  /// Cuántas observaciones tiene el niño anotadas contra este
  /// Misterio. Si es `null` o `0`, se muestra microcopia "todavía no
  /// has anotado nada"; si es 1, "1 evidencia anotada"; si es N>1, "N
  /// evidencias anotadas". El motivo de aceptar null Y 0 como
  /// equivalentes es que el caller (estado del cuaderno) sólo añade
  /// claves para Misterios con conteo conocido — la ausencia es lo
  /// mismo que cero.
  final int? evidencias;

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
                _piePagina(textos),
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

  String _piePagina(TextosApp textos) {
    final estado = misterio.estado.toLocaleLabel(_idioma(textos));
    final n = evidencias ?? 0;
    final contador = n == 0
        ? 'todavía no has anotado nada'
        : n == 1
            ? '1 evidencia anotada'
            : '$n evidencias anotadas';
    return '$estado · $contador';
  }

  static String _idioma(TextosApp textos) => textos.localeName;
}
