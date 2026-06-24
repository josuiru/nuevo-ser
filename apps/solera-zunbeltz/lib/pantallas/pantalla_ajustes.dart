import 'package:flutter/material.dart';

import '../estado/coordinador.dart';
import '../estado/idioma_app.dart';
import '../l10n/app_localizations.dart';
import 'pantalla_acerca_espacio_test.dart';
import 'pantalla_ayuda.dart';

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
  String _coordinador = '';

  @override
  void initState() {
    super.initState();
    Coordinador.cargarCorreo().then((c) {
      if (mounted) setState(() => _coordinador = c);
    });
  }

  Future<void> _cambiarIdioma(String codigo) async {
    await elegirIdiomaZunbeltz(codigo);
    if (mounted) setState(() {});
  }

  Future<void> _editarCoordinador() async {
    final textos = AppLocalizations.of(context);
    final controlador = TextEditingController(text: _coordinador);
    final correo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(textos.ajustesCoordinador),
        content: TextField(
          controller: controlador,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: textos.coordinadorCorreo),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(textos.comunCancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, controlador.text.trim()),
              child: Text(textos.comunGuardar)),
        ],
      ),
    );
    if (correo == null) return;
    await Coordinador.guardarCorreo(correo);
    if (mounted) setState(() => _coordinador = correo);
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
            leading: const Icon(Icons.help_outline),
            title: Text(textos.ayudaTitulo),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PantallaAyuda()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.outgoing_mail),
            title: Text(textos.ajustesCoordinador),
            subtitle: Text(
                _coordinador.isEmpty ? textos.ajustesCoordinadorVacio : _coordinador),
            trailing: const Icon(Icons.edit_outlined),
            onTap: _editarCoordinador,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.landscape_outlined),
            title: Text(textos.acercaTitulo),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const PantallaAcercaEspacioTest()),
            ),
          ),
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
