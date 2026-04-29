import 'package:flutter/material.dart';

import '../../dominio/observacion.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Sección "última página" del home (biblia §5.4). Muestra una sola
/// observación — la más reciente — como tarjeta sobria con la
/// descripción literal del niño en serif y los metadatos (cuándo,
/// dónde, identificación propuesta + nivel de confianza) en sans
/// gris ceniza.
///
/// Cuando no hay observaciones, microcopia de estado vacío sobria
/// (doc 13 §11.10): *"Aún no has anotado nada. Cuando lo hagas,
/// aparecerá aquí."*.
class SeccionUltimaPagina extends StatelessWidget {
  const SeccionUltimaPagina({
    super.key,
    required this.observacion,
  });

  final Observacion? observacion;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);

    if (observacion == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: esquema.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: esquema.outline, width: 0.5),
        ),
        child: Text(
          textos.ultimaPaginaVacia,
          style: TipografiaCuaderno.serif(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano13,
            altoLinea: 1.45,
          ),
        ),
      );
    }

    final obs = observacion!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: esquema.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: esquema.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _cabecera(obs),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            obs.queVio,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.5,
            ),
          ),
          if (obs.creesQueEs != null) ...[
            const SizedBox(height: 8),
            Text(
              '${obs.creesQueEs} · ${obs.confianza.toLocaleLabel(textos.localeName)}',
              style: TipografiaCuaderno.sans(
                color: esquema.tertiary,
                tamano: TipografiaCuaderno.tamano12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _cabecera(Observacion obs) {
    final cuando = _formatearFecha(obs.cuandoOcurrio);
    final donde =
        obs.dondeNombre.isEmpty ? '' : ' · ${obs.dondeNombre.toLowerCase()}';
    return '$cuando$donde';
  }

  static String _formatearFecha(DateTime cuando) {
    final diferencia = DateTime.now().difference(cuando);
    if (diferencia.inDays == 0) return 'hoy';
    if (diferencia.inDays == 1) return 'ayer';
    if (diferencia.inDays < 7) return 'hace ${diferencia.inDays} días';
    final semanas = diferencia.inDays ~/ 7;
    if (semanas == 1) return 'hace una semana';
    return 'hace $semanas semanas';
  }
}
