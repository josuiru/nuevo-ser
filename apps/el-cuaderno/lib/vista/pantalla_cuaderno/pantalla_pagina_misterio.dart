import 'package:flutter/material.dart';

import '../../dominio/misterio.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Página completa de un Misterio. La tarjeta del home muestra sólo
/// pregunta + bajada + estado; aquí el niño lee la pregunta del oficio
/// con calma, ve qué evidencia ya ha anotado y, si quiere, arranca una
/// observación nueva con el Misterio preseleccionado para no romper el
/// flujo "leer Misterio → anotar evidencia".
///
/// Lectura pura — toda la mutación pasa por `PantallaObservacion`. Si el
/// orquestador no inyecta [alAbrirNuevaObservacion], el botón no aparece
/// (modo S1, tests aislados).
class PantallaPaginaMisterio extends StatefulWidget {
  const PantallaPaginaMisterio({
    super.key,
    required this.repositorio,
    required this.misterio,
    this.alAbrirNuevaObservacion,
  });

  final RepositorioLocal repositorio;
  final Misterio misterio;

  /// Closure que el home cabla a `_abrirNuevaObservacion` con el id del
  /// Misterio preseleccionado. Si es null, sólo se muestra la cabecera
  /// + listado.
  final Future<void> Function(String misterioId)? alAbrirNuevaObservacion;

  @override
  State<PantallaPaginaMisterio> createState() => _EstadoPantallaPaginaMisterio();
}

class _EstadoPantallaPaginaMisterio extends State<PantallaPaginaMisterio> {
  List<Observacion> _observaciones = const [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await widget.repositorio
        .obtenerObservaciones(misterioId: widget.misterio.id);
    if (!mounted) return;
    setState(() {
      _observaciones = lista;
      _cargando = false;
    });
  }

  Future<void> _anotarEvidencia() async {
    final cb = widget.alAbrirNuevaObservacion;
    if (cb == null) return;
    await cb(widget.misterio.id);
    if (mounted) {
      await _cargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Misterio')),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator.adaptive())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _Cabecera(misterio: widget.misterio, textos: textos),
                  if (widget.alAbrirNuevaObservacion != null) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _anotarEvidencia,
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('anotar evidencia para este misterio'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Text(
                    'Lo que ya has anotado',
                    style: TipografiaCuaderno.sans(
                      color: esquema.tertiary,
                      tamano: TipografiaCuaderno.tamano12,
                      peso: TipografiaCuaderno.pesoMedio,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_observaciones.isEmpty)
                    Text(
                      'Todavía no has anotado nada para este misterio. '
                      'Cuando lo hagas, aparecerá aquí.',
                      style: TipografiaCuaderno.serif(
                        color: PaletaCuaderno.tintaTenue,
                        tamano: TipografiaCuaderno.tamano13,
                        altoLinea: 1.5,
                      ),
                    )
                  else
                    for (final obs in _observaciones) ...[
                      _TarjetaObservacionAnclada(
                        observacion: obs,
                        textos: textos,
                        esquema: esquema,
                      ),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
      ),
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera({required this.misterio, required this.textos});

  final Misterio misterio;
  final TextosApp textos;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
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
            misterio.pregunta,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano17,
              peso: TipografiaCuaderno.pesoMedio,
              altoLinea: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            misterio.descripcionCorta,
            style: TipografiaCuaderno.serif(
              color: PaletaCuaderno.tintaTenue,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            misterio.estado.toLocaleLabel(textos.localeName),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaObservacionAnclada extends StatelessWidget {
  const _TarjetaObservacionAnclada({
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
            _cabecera(observacion),
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

  String _cabecera(Observacion obs) {
    final cuando = _formatearFecha(obs.cuandoOcurrio);
    final donde =
        obs.dondeNombre.isEmpty ? '' : ' · ${obs.dondeNombre.toLowerCase()}';
    return '$cuando$donde';
  }

  static String _formatearFecha(DateTime cuando) {
    return '${cuando.day.toString().padLeft(2, '0')}/'
        '${cuando.month.toString().padLeft(2, '0')}/${cuando.year}';
  }
}
