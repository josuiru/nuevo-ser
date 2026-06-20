import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../branding.dart';
import '../estado/idioma_app.dart';
import '../l10n/app_localizations.dart';

/// Bienvenida de primer arranque. Permite elegir idioma (castellano/euskera)
/// y entrar. Marca `zunbeltz.onboarding_visto` para no repetirse.
class PantallaOnboarding extends StatefulWidget {
  const PantallaOnboarding({super.key, required this.alTerminar});

  final VoidCallback alTerminar;

  static const _claveVisto = 'zunbeltz.onboarding_visto';

  static Future<bool> yaVisto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveVisto) ?? false;
  }

  @override
  State<PantallaOnboarding> createState() => _PantallaOnboardingState();
}

class _PantallaOnboardingState extends State<PantallaOnboarding> {
  Future<void> _empezar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PantallaOnboarding._claveVisto, true);
    widget.alTerminar();
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final localeActivo = Localizations.localeOf(context).languageCode;
    return Scaffold(
      backgroundColor: colorMonteZunbeltz,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                textos.onboardingTitulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                textos.onboardingCuerpo,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Selector de idioma: ambos de primera clase desde el día uno.
              Wrap(
                spacing: 10,
                children: [
                  _ChipIdioma(
                    etiqueta: textos.ajustesIdiomaCastellano,
                    activo: localeActivo == 'es',
                    alPulsar: () => elegirIdiomaZunbeltz('es'),
                  ),
                  _ChipIdioma(
                    etiqueta: textos.ajustesIdiomaEuskera,
                    activo: localeActivo == 'eu',
                    alPulsar: () => elegirIdiomaZunbeltz('eu'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorOcreZunbeltz,
                    foregroundColor: colorMonteZunbeltz,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _empezar,
                  child: Text(
                    textos.onboardingBoton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipIdioma extends StatelessWidget {
  const _ChipIdioma({
    required this.etiqueta,
    required this.activo,
    required this.alPulsar,
  });

  final String etiqueta;
  final bool activo;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: activo,
      label: Text(etiqueta),
      onSelected: (_) => alPulsar(),
      selectedColor: colorMusgoZunbeltz,
      backgroundColor: Colors.white.withValues(alpha: 0.12),
      labelStyle: TextStyle(
        color: activo ? colorMonteZunbeltz : Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
