import 'package:flutter/material.dart';

import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pantalla_pagina_sit_spot_jubilado.dart';

/// Pantalla de "sit spots de antes" (doc 13 §2.6). Lectura pura — el
/// niño NO puede editar ni borrar páginas jubiladas; sólo verlas. La
/// confirmación de jubilación promete que la página seguirá guardada
/// en el cuaderno; esta pantalla cumple esa promesa.
///
/// Sólo se muestra si hay al menos un sit spot jubilado. El acceso
/// está en Ajustes para no contaminar el flujo principal del niño,
/// que se centra en el sit spot activo (biblia §3.5).
class PantallaSitSpotsJubilados extends StatelessWidget {
  const PantallaSitSpotsJubilados({
    super.key,
    required this.jubilados,
    this.repositorio,
  });

  final List<SitSpot> jubilados;

  /// Si llega no nulo, cada tarjeta es pulsable y abre la página
  /// detallada con las observaciones del sit spot jubilado. Si es
  /// null, las tarjetas son lectura simple — útil para tests aislados
  /// que no quieren simular navegación.
  final RepositorioLocal? repositorio;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Sit spots de antes')),
      body: SafeArea(
        child: jubilados.isEmpty
            ? _MensajeVacio(esquema: esquema)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: jubilados.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, indice) => _PaginaSitSpotJubilado(
                  sitSpot: jubilados[indice],
                  repositorio: repositorio,
                ),
              ),
      ),
    );
  }
}

class _MensajeVacio extends StatelessWidget {
  const _MensajeVacio({required this.esquema});

  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'Aquí aparecerán los sit spots que jubiles. Sus páginas '
          'seguirán guardadas con sus observaciones.',
          textAlign: TextAlign.center,
          style: TipografiaCuaderno.serif(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano13,
            altoLinea: 1.5,
          ),
        ),
      ),
    );
  }
}

class _PaginaSitSpotJubilado extends StatelessWidget {
  const _PaginaSitSpotJubilado({required this.sitSpot, this.repositorio});

  final SitSpot sitSpot;
  final RepositorioLocal? repositorio;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final tarjeta = Container(
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
          if (repositorio != null) ...[
            const SizedBox(height: 4),
            _ContadorObservaciones(
              sitSpotId: sitSpot.id,
              repositorio: repositorio!,
              esquema: esquema,
            ),
          ],
        ],
      ),
    );
    if (repositorio == null) return tarjeta;
    return InkWell(
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => PantallaPaginaSitSpotJubilado(
            sitSpot: sitSpot,
            repositorio: repositorio!,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(8),
      child: tarjeta,
    );
  }

  /// "Estuvo activo del DD/MM/AAAA al DD/MM/AAAA". Si no tiene
  /// retiradoEn (no debería ocurrir con esta pantalla, pero por
  /// robustez), muestra sólo la fecha de creación.
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

class _ContadorObservaciones extends StatelessWidget {
  const _ContadorObservaciones({
    required this.sitSpotId,
    required this.repositorio,
    required this.esquema,
  });

  final String sitSpotId;
  final RepositorioLocal repositorio;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: repositorio
          .obtenerObservaciones(sitSpotId: sitSpotId)
          .then((lista) => lista.length),
      builder: (_, snapshot) {
        final cuenta = snapshot.data;
        if (cuenta == null) return const SizedBox.shrink();
        final texto = cuenta == 0
            ? 'Sin observaciones guardadas.'
            : cuenta == 1
                ? '1 observación guardada.'
                : '$cuenta observaciones guardadas.';
        return Text(
          texto,
          style: TipografiaCuaderno.sans(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano12,
          ),
        );
      },
    );
  }
}
