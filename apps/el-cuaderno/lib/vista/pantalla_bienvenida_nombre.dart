import 'package:flutter/material.dart';

import '../nucleo/i18n/generado/textos_app.dart';
import 'tema/colores.dart';

/// Segundo paso del primer arranque (tras elegir idioma): pide al niño
/// su nombre. El nombre se persiste como nombre del perfil activo (vía
/// `RepositorioPerfilCuaderno`). Una vez completado, el orquestador del
/// `main.dart` muestra `PantallaCuaderno`.
///
/// Sin solicitar edad, email, fecha de nacimiento ni cualquier otro
/// dato. El nombre se queda en el dispositivo (biblia §2.1: el cuaderno
/// es del niño).
class PantallaBienvenidaNombre extends StatefulWidget {
  const PantallaBienvenidaNombre({
    super.key,
    required this.alConfirmarNombre,
  });

  /// Llamado con el nombre que el niño escribió, ya con `trim` aplicado
  /// y garantizado no vacío. El callback es responsable de crear el
  /// perfil y reconstruir la app.
  final Future<void> Function(String nombre) alConfirmarNombre;

  @override
  State<PantallaBienvenidaNombre> createState() =>
      _EstadoPantallaBienvenidaNombre();
}

class _EstadoPantallaBienvenidaNombre extends State<PantallaBienvenidaNombre> {
  final TextEditingController _controlador = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  bool get _puedeContinuar =>
      _controlador.text.trim().isNotEmpty && !_enviando;

  Future<void> _continuar() async {
    final nombre = _controlador.text.trim();
    if (nombre.isEmpty) return;
    setState(() => _enviando = true);
    await widget.alConfirmarNombre(nombre);
    // No hace falta resetear estado: tras el callback, main reconstruye
    // la app con la pantalla principal y este widget queda fuera del árbol.
  }

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    return Scaffold(
      backgroundColor: PaletaCuaderno.papelClaro,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                textos.bienvenidaTitulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: PaletaCuaderno.tinta,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                textos.bienvenidaCuerpo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: PaletaCuaderno.tintaTenue,
                ),
              ),
              const Spacer(),
              TextField(
                controller: _controlador,
                autofocus: true,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) {
                  if (_puedeContinuar) _continuar();
                },
                decoration: InputDecoration(
                  hintText: textos.bienvenidaPlaceholderNombre,
                  filled: true,
                  fillColor: PaletaCuaderno.papelMedio,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: PaletaCuaderno.papelOscuro,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  color: PaletaCuaderno.tinta,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: _puedeContinuar ? _continuar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PaletaCuaderno.papelMedio,
                  foregroundColor: PaletaCuaderno.tinta,
                  disabledBackgroundColor: PaletaCuaderno.papelMedio,
                  disabledForegroundColor: PaletaCuaderno.tintaTenue,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: PaletaCuaderno.papelOscuro,
                    ),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                child: Text(textos.bienvenidaBotonContinuar),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
