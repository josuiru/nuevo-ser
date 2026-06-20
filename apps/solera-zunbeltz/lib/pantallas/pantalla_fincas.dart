import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Pestaña "Fincas". Marcador de posición de FZ-1: en FZ-3 se sustituye por
/// el mapa de las dos fincas con sus puntos de infraestructura y el tablero
/// de tareas de mantenimiento.
class PantallaFincas extends StatelessWidget {
  const PantallaFincas({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(textos.navFincas)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.map_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                textos.hoyVacio,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
