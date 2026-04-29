import 'dart:async';

import 'package:flutter/material.dart';

import '../nucleo/paleta.dart';

class PantallaApertura extends StatefulWidget {
  final VoidCallback alTerminarApertura;

  const PantallaApertura({super.key, required this.alTerminarApertura});

  @override
  State<PantallaApertura> createState() => _PantallaAperturaState();
}

class _PantallaAperturaState extends State<PantallaApertura>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador;
  Timer? _temporizadorSalida;

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
    _temporizadorSalida =
        Timer(const Duration(milliseconds: 2900), widget.alTerminarApertura);
  }

  @override
  void dispose() {
    _controlador.dispose();
    _temporizadorSalida?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controlador,
            builder: (_, __) {
              final opacidadTitulo =
                  Curves.easeOut.transform(_controlador.value);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: opacidadTitulo,
                    child: const Text(
                      'UNO',
                      style: TextStyle(
                        fontSize: 64,
                        letterSpacing: 18,
                        color: PaletaNeon.textoPrincipal,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Opacity(
                    opacity: opacidadTitulo,
                    child: const Text(
                      'ROTO',
                      style: TextStyle(
                        fontSize: 64,
                        letterSpacing: 18,
                        color: PaletaNeon.violetaNeon,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
