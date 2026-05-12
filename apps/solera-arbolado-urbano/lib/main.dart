import 'package:flutter/material.dart';

import 'pantallas/pantalla_mapa.dart';
import 'pantallas/pantalla_onboarding.dart';

void main() {
  runApp(const SoleraArboladoUrbanoApp());
}

class SoleraArboladoUrbanoApp extends StatelessWidget {
  const SoleraArboladoUrbanoApp({super.key});

  @override
  Widget build(BuildContext contexto) {
    final ColorScheme esquemaColores = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32), // verde hoja oscuro
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'Solera Arbolado Urbano',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: esquemaColores,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F8F0), // crema savia
      ),
      home: const _OrquestadorArranque(),
    );
  }
}

/// Decide qué pantalla mostrar al arrancar — onboarding la primera vez,
/// PantallaMapa a partir de la segunda. El flag se persiste en
/// SharedPreferences (`solera_arbolado_urbano.onboarding.visto`).
class _OrquestadorArranque extends StatefulWidget {
  const _OrquestadorArranque();

  @override
  State<_OrquestadorArranque> createState() => _OrquestadorArranqueState();
}

class _OrquestadorArranqueState extends State<_OrquestadorArranque> {
  bool? _onboardingVisto;

  @override
  void initState() {
    super.initState();
    _comprobarOnboarding();
  }

  Future<void> _comprobarOnboarding() async {
    final visto = await PantallaOnboarding.yaVisto();
    if (mounted) setState(() => _onboardingVisto = visto);
  }

  @override
  Widget build(BuildContext context) {
    final visto = _onboardingVisto;
    if (visto == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!visto) {
      return PantallaOnboarding(
        alTerminar: () => setState(() => _onboardingVisto = true),
      );
    }
    return const PantallaMapa();
  }
}
