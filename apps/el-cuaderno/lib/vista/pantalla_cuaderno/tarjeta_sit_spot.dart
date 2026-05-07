import 'package:flutter/material.dart';

import '../../dominio/sit_spot.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../pantalla_sit_spot/pantalla_presentacion_sit_spot.dart';
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
    this.alPulsarActivo,
    this.alJubilar,
  });

  final SitSpot? sitSpot;

  /// Callback que el home cabla al flujo de creación. Si es null y el
  /// niño todavía no tiene sit spot, la tarjeta se muestra estática
  /// (modo S1, tests que no quieren disparar navegación).
  final VoidCallback? alPulsarInvitacion;

  /// Callback que el home cabla a `PantallaPaginaSitSpot` cuando el
  /// sit spot activo existe. Si es null, la tarjeta no es pulsable —
  /// modo lectura para tests aislados.
  final VoidCallback? alPulsarActivo;

  /// Callback que el home cabla a la jubilación del sit spot activo
  /// (doc 13 §2.6). Si es null, el menú no aparece (tests que no
  /// quieren simular la confirmación).
  final VoidCallback? alJubilar;

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

    return _TarjetaActiva(
      sitSpot: sitSpot!,
      textos: textos,
      esquema: esquema,
      alPulsar: alPulsarActivo,
      alJubilar: alJubilar,
    );
  }
}

class _TarjetaInvitacion extends StatelessWidget {
  const _TarjetaInvitacion({required this.textos, this.alPulsar});

  final TextosApp textos;
  final VoidCallback? alPulsar;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final invitacion = Text(
      textos.sitSpotInvitacion,
      style: TipografiaCuaderno.serif(
        color: esquema.onSurface,
        tamano: TipografiaCuaderno.tamano14,
        altoLinea: 1.45,
      ),
    );
    final superficiePulsable = alPulsar == null
        ? Padding(padding: const EdgeInsets.all(16), child: invitacion)
        : InkWell(
            onTap: alPulsar,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: invitacion,
            ),
          );
    return Container(
      decoration: BoxDecoration(
        color: esquema.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          superficiePulsable,
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _mostrarExplicacion(context),
                style: TextButton.styleFrom(
                  foregroundColor: esquema.tertiary,
                  textStyle: TipografiaCuaderno.sans(
                    color: esquema.tertiary,
                    tamano: TipografiaCuaderno.tamano12,
                    peso: TipografiaCuaderno.pesoMedio,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(textos.tarjetaSitSpotQueEs),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarExplicacion(BuildContext context) {
    final textos = TextosApp.of(context);
    return showDialog<void>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: Text(textos.presentacionSitSpotTitulo),
        content: const SingleChildScrollView(
          child: ExplicacionSitSpot(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contextoDialogo).pop(),
            child: Text(textos.sitSpotExplicacionCerrar),
          ),
        ],
      ),
    );
  }
}

class _TarjetaActiva extends StatelessWidget {
  const _TarjetaActiva({
    required this.sitSpot,
    required this.textos,
    required this.esquema,
    this.alPulsar,
    this.alJubilar,
  });

  final SitSpot sitSpot;
  final TextosApp textos;
  final ColorScheme esquema;
  final VoidCallback? alPulsar;
  final VoidCallback? alJubilar;

  @override
  Widget build(BuildContext context) {
    final contenido = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  sitSpot.nombre,
                  style: TipografiaCuaderno.serif(
                    color: esquema.onSurface,
                    tamano: TipografiaCuaderno.tamano17,
                    peso: TipografiaCuaderno.pesoMedio,
                  ),
                ),
              ),
            ),
            if (alJubilar != null)
              PopupMenuButton<String>(
                tooltip: textos.tarjetaSitSpotOpcionesTooltip,
                icon: const Icon(Icons.more_vert),
                onSelected: (valor) {
                  if (valor == 'jubilar') alJubilar!();
                },
                itemBuilder: (_) => [
                  PopupMenuItem<String>(
                    value: 'jubilar',
                    child: Text(textos.tarjetaSitSpotJubilarOpcion),
                  ),
                ],
              ),
          ],
        ),
        if (sitSpot.dondeNombre.isNotEmpty) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 8),
            child: Text(
              sitSpot.dondeNombre,
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.tintaTenue,
                tamano: TipografiaCuaderno.tamano13,
                altoLinea: 1.4,
              ),
            ),
          ),
        ],
        if (sitSpot.ultimaVisita != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 8),
            child: Text(
              textos.sitSpotUltimaVisita(
                _formatearHace(sitSpot.ultimaVisita!),
              ),
              style: TipografiaCuaderno.sans(
                color: esquema.tertiary,
                tamano: TipografiaCuaderno.tamano12,
              ),
            ),
          ),
        ],
      ],
    );

    return Material(
      color: esquema.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: esquema.outline, width: 0.5),
      ),
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
          child: contenido,
        ),
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
