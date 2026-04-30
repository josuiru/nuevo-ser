import 'package:flutter/material.dart';

import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Página del sit spot activo. Hermana de `PantallaPaginaSitSpotJubilado`
/// pero con dos diferencias estructurales:
///
/// - La cabecera dice "Activo desde DD/MM/YYYY" en lugar de "Estuvo
///   activo del DD/MM al DD/MM" (no hay fecha de jubilación todavía).
/// - Hay un botón "anotar observación aquí" que abre el flujo de nueva
///   observación con el sit spot activo ya preseleccionado (lo hace el
///   home porque `PantallaObservacion` recibe `sitSpotActivo` y lo
///   ancla automáticamente). El botón no está en la jubilada porque doc
///   13 §2.6 prohíbe registrar observaciones contra un sit spot ya
///   retirado.
///
/// El listado de observaciones lo lee del repositorio cada vez que se
/// monta (y al volver del callback de nueva observación).
class PantallaPaginaSitSpot extends StatefulWidget {
  const PantallaPaginaSitSpot({
    super.key,
    required this.repositorio,
    required this.sitSpot,
    this.alAbrirNuevaObservacion,
  });

  final RepositorioLocal repositorio;
  final SitSpot sitSpot;

  /// Closure que el home cabla a `_abrirObservacion(null)` — la
  /// observación quedará anclada al sit spot por la lógica de
  /// `PantallaObservacion` que ya recibe `sitSpotActivo`. Si es null,
  /// el botón no se monta.
  final Future<void> Function()? alAbrirNuevaObservacion;

  @override
  State<PantallaPaginaSitSpot> createState() => _EstadoPantallaPaginaSitSpot();
}

class _EstadoPantallaPaginaSitSpot extends State<PantallaPaginaSitSpot> {
  List<Observacion> _observaciones = const [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await widget.repositorio
        .obtenerObservaciones(sitSpotId: widget.sitSpot.id);
    if (!mounted) return;
    setState(() {
      _observaciones = lista;
      _cargando = false;
    });
  }

  Future<void> _anotar() async {
    final cb = widget.alAbrirNuevaObservacion;
    if (cb == null) return;
    await cb();
    if (mounted) await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.sitSpot.nombre)),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator.adaptive())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _CabeceraSitSpotActivo(
                    sitSpot: widget.sitSpot,
                    esquema: esquema,
                  ),
                  if (widget.alAbrirNuevaObservacion != null) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _anotar,
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('anotar observación aquí'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Text(
                    _observaciones.isEmpty
                        ? 'Lo que ya has anotado aquí'
                        : _contadorEtiqueta(_observaciones.length),
                    style: TipografiaCuaderno.sans(
                      color: esquema.tertiary,
                      tamano: TipografiaCuaderno.tamano12,
                      peso: TipografiaCuaderno.pesoMedio,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_observaciones.isEmpty)
                    Text(
                      'Todavía no has anotado nada en este sit spot. '
                      'Cuando lo hagas, aparecerá aquí.',
                      style: TipografiaCuaderno.serif(
                        color: PaletaCuaderno.tintaTenue,
                        tamano: TipografiaCuaderno.tamano13,
                        altoLinea: 1.5,
                      ),
                    )
                  else
                    for (final obs in _observaciones) ...[
                      _TarjetaObservacionLectura(
                        observacion: obs,
                        textos: textos,
                        esquema: esquema,
                      ),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
      ),
    );
  }

  static String _contadorEtiqueta(int n) =>
      n == 1 ? '1 observación guardada' : '$n observaciones guardadas';
}

class _CabeceraSitSpotActivo extends StatelessWidget {
  const _CabeceraSitSpotActivo({required this.sitSpot, required this.esquema});

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
            'Activo desde el ${_formatearFecha(sitSpot.creadoEn)}.',
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatearFecha(DateTime cuando) {
    final dd = cuando.day.toString().padLeft(2, '0');
    final mm = cuando.month.toString().padLeft(2, '0');
    return '$dd/$mm/${cuando.year}';
  }
}

class _TarjetaObservacionLectura extends StatelessWidget {
  const _TarjetaObservacionLectura({
    required this.observacion,
    required this.textos,
    required this.esquema,
  });

  final Observacion observacion;
  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: esquema.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: esquema.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatearFecha(observacion.cuandoOcurrio),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            observacion.queVio,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.5,
            ),
          ),
          if (observacion.creesQueEs != null &&
              observacion.creesQueEs!.isNotEmpty) ...[
            const SizedBox(height: 4),
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

  static String _formatearFecha(DateTime cuando) {
    final dd = cuando.day.toString().padLeft(2, '0');
    final mm = cuando.month.toString().padLeft(2, '0');
    return '$dd/$mm/${cuando.year}';
  }
}
