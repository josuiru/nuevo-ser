import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'widgets/cuerpo_responsivo.dart';

/// Manual y ayuda dentro de la app, en lenguaje sencillo para personas no
/// familiarizadas con apps. Secciones desplegables paso a paso.
class PantallaAyuda extends StatelessWidget {
  const PantallaAyuda({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final secciones = <(String, String, IconData)>[
      (t.ayudaQueEsT, t.ayudaQueEsB, Icons.help_outline),
      (t.ayudaPestanasT, t.ayudaPestanasB, Icons.dashboard_outlined),
      (t.ayudaFincasT, t.ayudaFincasB, Icons.map_outlined),
      (t.ayudaTareasT, t.ayudaTareasB, Icons.checklist),
      (t.ayudaProyectosT, t.ayudaProyectosB, Icons.science_outlined),
      (t.ayudaInformesT, t.ayudaInformesB, Icons.ios_share),
      (t.ayudaIdiomaDatosT, t.ayudaIdiomaDatosB, Icons.translate_outlined),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.ayudaTitulo)),
      body: CuerpoResponsivo(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Text(t.ayudaIntro,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            for (final (titulo, cuerpo, icono) in secciones)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ExpansionTile(
                  leading: Icon(icono),
                  title: Text(titulo,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(cuerpo,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(t.ayudaPie,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
