import 'package:flutter/material.dart';

import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../pantalla_observacion/pantalla_observacion.dart';
import '../pantalla_tutor/pantalla_tutor.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'estado_cuaderno.dart';
import 'seccion_ultima_pagina.dart';
import 'tarjeta_misterio.dart';
import 'tarjeta_sit_spot.dart';

/// Pantalla principal del juego. Bottom nav con cuatro pestañas; en
/// S1 solo Cuaderno y Tutor llevan a algo — Mapa y Misterios muestran
/// "próximamente" sin más fanfarria.
class PantallaCuaderno extends StatefulWidget {
  const PantallaCuaderno({
    super.key,
    required this.repositorio,
    required this.estado,
  });

  final RepositorioLocal repositorio;
  final EstadoCuaderno estado;

  @override
  State<PantallaCuaderno> createState() => _EstadoPantallaCuaderno();
}

class _EstadoPantallaCuaderno extends State<PantallaCuaderno> {
  int _indicePestana = 0;

  @override
  void initState() {
    super.initState();
    widget.estado.cargar();
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(textos.tituloApp)),
      body: SafeArea(
        child: IndexedStack(
          index: _indicePestana,
          children: [
            _VistaCuaderno(
              estado: widget.estado,
              alAbrirNuevaObservacion: _abrirNuevaObservacion,
            ),
            _VistaProximamente(textos: textos),
            _VistaProximamente(textos: textos),
            PantallaTutor(repositorio: widget.repositorio),
          ],
        ),
      ),
      floatingActionButton: _indicePestana == 0
          ? FloatingActionButton(
              onPressed: _abrirNuevaObservacion,
              backgroundColor: esquema.primary,
              foregroundColor: esquema.onPrimary,
              child: const Icon(Icons.edit_outlined),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indicePestana,
        onDestinationSelected: (indice) =>
            setState(() => _indicePestana = indice),
        backgroundColor: esquema.surface,
        indicatorColor: esquema.surfaceContainerHighest,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: textos.navCuaderno,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: textos.navMapa,
          ),
          NavigationDestination(
            icon: const Icon(Icons.help_outline),
            selectedIcon: const Icon(Icons.help),
            label: textos.navMisterios,
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_outlined),
            selectedIcon: const Icon(Icons.chat),
            label: textos.navTutor,
          ),
        ],
      ),
    );
  }

  Future<void> _abrirNuevaObservacion() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => PantallaObservacion(
          repositorio: widget.repositorio,
          misteriosAbiertos: widget.estado.misteriosAbiertos,
          sitSpotActivo: widget.estado.sitSpot,
        ),
      ),
    );
    if (mounted) {
      await widget.estado.cargar();
    }
  }
}

/// Vista del cuaderno propiamente dicha — la primera pestaña. Scroll
/// vertical con cabecera + saludo + sit spot + Misterios + última
/// página, conforme al mockup descrito en biblia §5.4.
class _VistaCuaderno extends StatelessWidget {
  const _VistaCuaderno({
    required this.estado,
    required this.alAbrirNuevaObservacion,
  });

  final EstadoCuaderno estado;
  final VoidCallback alAbrirNuevaObservacion;

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: estado,
      builder: (context, _) {
        if (estado.cargando && estado.sitSpot == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final misteriosAMostrar =
            estado.misteriosAbiertos.take(3).toList(growable: false);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            Text(
              textos.saludoSinNombre,
              style: TipografiaCuaderno.serif(
                color: esquema.onSurface,
                tamano: TipografiaCuaderno.tamano17,
                peso: TipografiaCuaderno.pesoMedio,
              ),
            ),
            const SizedBox(height: 24),
            _Cabecera(textos.seccionSitSpot),
            const SizedBox(height: 8),
            TarjetaSitSpot(sitSpot: estado.sitSpot),
            const SizedBox(height: 24),
            _Cabecera(textos.seccionMisteriosAbiertos),
            const SizedBox(height: 8),
            if (misteriosAMostrar.isEmpty)
              Text(
                textos.misteriosVacio,
                style: TipografiaCuaderno.serif(
                  color: PaletaCuaderno.tintaTenue,
                  tamano: TipografiaCuaderno.tamano13,
                  altoLinea: 1.45,
                ),
              )
            else
              for (final misterio in misteriosAMostrar) ...[
                TarjetaMisterio(misterio: misterio),
                const SizedBox(height: 8),
              ],
            const SizedBox(height: 16),
            _Cabecera(textos.seccionUltimaPagina),
            const SizedBox(height: 8),
            SeccionUltimaPagina(observacion: estado.ultimaObservacion),
          ],
        );
      },
    );
  }
}

class _VistaProximamente extends StatelessWidget {
  const _VistaProximamente({required this.textos});

  final TextosApp textos;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          textos.navProximamente,
          textAlign: TextAlign.center,
          style: TipografiaCuaderno.serif(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano14,
          ),
        ),
      ),
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Text(
      texto,
      style: TipografiaCuaderno.sans(
        color: esquema.tertiary,
        tamano: TipografiaCuaderno.tamano12,
        peso: TipografiaCuaderno.pesoMedio,
      ),
    );
  }
}
