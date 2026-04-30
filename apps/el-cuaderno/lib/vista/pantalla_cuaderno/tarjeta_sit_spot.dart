import 'package:flutter/material.dart';

import '../../dominio/sit_spot.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Tarjeta del sit spot en el home. Dos estados:
///
/// - **Sin sit spot configurado**: invitación discreta (doc 13 §2.1).
///   Sin urgencia, sin parpadeo.
/// - **Con sit spot**: nombre + última visita ("hace 4 días"). Más
///   adelante mostrará el botón "Ver lo que sabes de este sitio"
///   cuando se cumplan las condiciones de la biblia §5.1 (≥10 visitas
///   en ≥2 estaciones); en S1 ese botón no aparece nunca.
///
/// Widget puro — recibe los datos por parámetros, no toca repositorio.
class TarjetaSitSpot extends StatelessWidget {
  const TarjetaSitSpot({
    super.key,
    required this.sitSpot,
    this.alPulsarInvitacion,
  });

  final SitSpot? sitSpot;

  /// Callback que el home cabla al flujo de creación. Si es null y el
  /// niño todavía no tiene sit spot, la tarjeta se muestra estática
  /// (modo S1, tests que no quieren disparar navegación).
  final VoidCallback? alPulsarInvitacion;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);

    if (sitSpot == null) {
      return _TarjetaInvitacion(
        textos: textos,
        alPulsar: alPulsarInvitacion,
      );
    }

    return _TarjetaActiva(sitSpot: sitSpot!, textos: textos, esquema: esquema);
  }
}

class _TarjetaInvitacion extends StatelessWidget {
  const _TarjetaInvitacion({required this.textos, this.alPulsar});

  final TextosApp textos;
  final VoidCallback? alPulsar;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final contenido = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: esquema.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        textos.sitSpotInvitacion,
        style: TipografiaCuaderno.serif(
          color: esquema.onSurface,
          tamano: TipografiaCuaderno.tamano14,
          altoLinea: 1.45,
        ),
      ),
    );
    if (alPulsar == null) return contenido;
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(8),
      child: contenido,
    );
  }
}

class _TarjetaActiva extends StatelessWidget {
  const _TarjetaActiva({
    required this.sitSpot,
    required this.textos,
    required this.esquema,
  });

  final SitSpot sitSpot;
  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: esquema.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: esquema.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sitSpot.nombre,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano17,
              peso: TipografiaCuaderno.pesoMedio,
            ),
          ),
          if (sitSpot.dondeNombre.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              sitSpot.dondeNombre,
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.tintaTenue,
                tamano: TipografiaCuaderno.tamano13,
                altoLinea: 1.4,
              ),
            ),
          ],
          if (sitSpot.ultimaVisita != null) ...[
            const SizedBox(height: 8),
            Text(
              textos.sitSpotUltimaVisita(_formatearHace(sitSpot.ultimaVisita!)),
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

  /// Formato "hace N días" sin librería externa. Aceptamos
  /// imperfección: en S1 solo se usa para el sit spot sembrado y para
  /// la próxima visita registrada — no es ruta crítica de
  /// internacionalización aún. Cuando se introduzca `intl` para las
  /// fechas, se reemplaza esto por DateFormat.
  static String _formatearHace(DateTime cuando) {
    final diferencia = DateTime.now().difference(cuando);
    if (diferencia.inDays == 0) {
      return 'hoy';
    }
    if (diferencia.inDays == 1) {
      return 'ayer';
    }
    return 'hace ${diferencia.inDays} días';
  }
}
