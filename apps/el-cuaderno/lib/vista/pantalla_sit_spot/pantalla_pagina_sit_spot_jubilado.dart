import 'package:flutter/material.dart';

import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pantalla_comparar_visitas.dart';

/// Página de un sit spot jubilado (doc 13 §2.6). Lectura pura: el
/// niño vuelve a su sitio antiguo y ve qué anotó allí, sin poder
/// editar ni borrar. La cabecera muestra metadatos (nombre,
/// dondeNombre, periodo activo) y debajo lista las observaciones
/// ancladas a ese sit spot, ordenadas de más reciente a más antigua.
class PantallaPaginaSitSpotJubilado extends StatelessWidget {
  const PantallaPaginaSitSpotJubilado({
    super.key,
    required this.sitSpot,
    required this.repositorio,
  });

  final SitSpot sitSpot;
  final RepositorioLocal repositorio;

  static void _abrirComparador(
    BuildContext context,
    SitSpot sitSpot,
    RepositorioLocal repositorio,
  ) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => PantallaCompararVisitas(
          repositorio: repositorio,
          sitSpot: sitSpot,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(sitSpot.nombre)),
      body: SafeArea(
        child: FutureBuilder<List<Observacion>>(
          future: repositorio.obtenerObservaciones(sitSpotId: sitSpot.id),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            final observaciones = snapshot.data ?? const <Observacion>[];
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _CabeceraSitSpot(sitSpot: sitSpot, esquema: esquema),
                const SizedBox(height: 24),
                if (observaciones.isEmpty)
                  Text(
                    'No hay observaciones guardadas en esta página.',
                    style: TipografiaCuaderno.serif(
                      color: PaletaCuaderno.tintaTenue,
                      tamano: TipografiaCuaderno.tamano13,
                      altoLinea: 1.45,
                    ),
                  )
                else ...[
                  Text(
                    observaciones.length == 1
                        ? '1 observación guardada'
                        : '${observaciones.length} observaciones guardadas',
                    style: TipografiaCuaderno.sans(
                      color: esquema.tertiary,
                      tamano: TipografiaCuaderno.tamano12,
                      peso: TipografiaCuaderno.pesoMedio,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final observacion in observaciones) ...[
                    _TarjetaObservacionLectura(observacion: observacion),
                    const SizedBox(height: 12),
                  ],
                  if (observaciones.length >= 2) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _abrirComparador(context, sitSpot, repositorio),
                        icon: const Icon(Icons.compare_arrows_outlined),
                        label: Text(
                          TextosApp.of(context).compararVisitasEnlace,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CabeceraSitSpot extends StatelessWidget {
  const _CabeceraSitSpot({required this.sitSpot, required this.esquema});

  final SitSpot sitSpot;
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
          const SizedBox(height: 8),
          Text(
            _periodoActivo(sitSpot),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
        ],
      ),
    );
  }

  static String _periodoActivo(SitSpot sitSpot) {
    final desde = _formatearFecha(sitSpot.creadoEn);
    final hasta = sitSpot.retiradoEn;
    if (hasta == null) return 'Creado el $desde.';
    return 'Estuvo activo del $desde al ${_formatearFecha(hasta)}.';
  }

  static String _formatearFecha(DateTime cuando) {
    final dd = cuando.day.toString().padLeft(2, '0');
    final mm = cuando.month.toString().padLeft(2, '0');
    return '$dd/$mm/${cuando.year}';
  }
}

class _TarjetaObservacionLectura extends StatelessWidget {
  const _TarjetaObservacionLectura({required this.observacion});

  final Observacion observacion;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
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
            _formatearFechaLarga(observacion.cuandoOcurrio),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            observacion.queVio,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.5,
            ),
          ),
          if (observacion.creesQueEs != null) ...[
            const SizedBox(height: 8),
            Text(
              '${observacion.creesQueEs} · '
              '${observacion.confianza.toLocaleLabel(textos.localeName)}',
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

  static String _formatearFechaLarga(DateTime cuando) {
    final dd = cuando.day.toString().padLeft(2, '0');
    final mm = cuando.month.toString().padLeft(2, '0');
    return '$dd/$mm/${cuando.year}';
  }
}
