import 'package:flutter/material.dart';

import '../estado/idioma_app.dart';
import '../l10n/app_localizations.dart';

/// Versión visible de la app. Se mantiene a mano sincronizada con `version`
/// del `pubspec.yaml` (campo antes del `+`).
const String versionAppZunbeltz = '0.1.0';

/// Pestaña "Ajustes": idioma y acerca de.
class PantallaAjustes extends StatefulWidget {
  const PantallaAjustes({super.key});

  @override
  State<PantallaAjustes> createState() => _PantallaAjustesState();
}

class _PantallaAjustesState extends State<PantallaAjustes> {
  Future<void> _cambiarIdioma(String codigo) async {
    await elegirIdiomaZunbeltz(codigo);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final localeActivo = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(textos.navAjustes)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.translate_outlined),
            title: Text(textos.ajustesIdioma),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    selected: localeActivo == 'es',
                    label: Text(textos.ajustesIdiomaCastellano),
                    onSelected: (_) => _cambiarIdioma('es'),
                  ),
                  ChoiceChip(
                    selected: localeActivo == 'eu',
                    label: Text(textos.ajustesIdiomaEuskera),
                    onSelected: (_) => _cambiarIdioma('eu'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(textos.ajustesAcercaDe),
            subtitle: Text(textos.ajustesVersion(versionAppZunbeltz)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Text(
              textos.ajustesProvisional,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
