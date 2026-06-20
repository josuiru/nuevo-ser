import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Pestaña "Cuaderno": el cuaderno ganadero (animales, lotes, pastoreo,
/// eventos) llega en una fase posterior. En FZ-1 es un marcador de posición.
class PantallaCuaderno extends StatelessWidget {
  const PantallaCuaderno({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(textos.cuadernoProximamente)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pets_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                textos.cuadernoProximamenteCuerpo,
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
