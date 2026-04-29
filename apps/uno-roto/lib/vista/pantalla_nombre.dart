import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';

/// Pantalla minimalista de entrada de nombre. Se muestra una sola vez
/// tras la apertura y antes de cualquier cinemática. El nombre se guarda
/// y se usa para sustituir `{nombre}` en los textos del guion.
class PantallaNombre extends StatefulWidget {
  final ValueChanged<String> alConfirmar;

  const PantallaNombre({super.key, required this.alConfirmar});

  @override
  State<PantallaNombre> createState() => _PantallaNombreState();
}

class _PantallaNombreState extends State<PantallaNombre> {
  final TextEditingController _controlador = TextEditingController();
  bool _habilitado = false;

  @override
  void initState() {
    super.initState();
    _controlador.addListener(() {
      final tieneAlgo = _controlador.text.trim().isNotEmpty;
      if (tieneAlgo != _habilitado) {
        setState(() => _habilitado = tieneAlgo);
      }
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _confirmar() {
    final nombre = _controlador.text.trim();
    if (nombre.isEmpty) return;
    HapticFeedback.selectionClick();
    widget.alConfirmar(nombre);
  }

  @override
  Widget build(BuildContext contexto) {
    final textos = AppLocalizations.of(contexto);
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  textos.nombreTitulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    color: PaletaNeon.textoPrincipal,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  textos.nombreSubtitulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    fontStyle: FontStyle.italic,
                    color: PaletaNeon.textoTenue.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controlador,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  maxLength: 24,
                  onSubmitted: (_) => _confirmar(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: PaletaNeon.textoPrincipal,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: PaletaNeon.azulNeon.withOpacity(0.5),
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: PaletaNeon.azulNeon,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Center(
                  child: TextButton(
                    onPressed: _habilitado ? _confirmar : null,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      foregroundColor: PaletaNeon.textoPrincipal,
                      disabledForegroundColor:
                          PaletaNeon.textoTenue.withOpacity(0.4),
                      side: BorderSide(
                        color: _habilitado
                            ? PaletaNeon.azulNeon.withOpacity(0.6)
                            : PaletaNeon.textoTenue.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      textos.nombreBotonContinuar,
                      style: const TextStyle(letterSpacing: 3, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
