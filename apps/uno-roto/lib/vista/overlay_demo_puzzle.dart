import 'package:flutter/material.dart';

import '../nucleo/paleta.dart';

/// Overlay-tutorial gestual que aparece **una sola vez** la primera vez
/// que el niño abre una familia de puzzle. Muestra una mano-fantasma
/// (círculo claro) que pulsa de forma rítmica sobre la zona de respuesta
/// con un texto corto debajo (p. ej. "Toca aquí cuando lo sepas").
///
/// La pantalla padre se encarga de:
/// 1. Decidir si mostrarlo (consultando [RepositorioProgreso.cargarDemosPuzzlesVistos]).
/// 2. Persistir el flag al cerrarse ([RepositorioProgreso.marcarDemoPuzzleVisto]).
/// 3. Pasar el [mensaje] localizado y, opcionalmente, [posicionRelativa]
///    (alineamiento de la mano dentro del lienzo — por defecto centro).
///
/// Auto-cierre tras 3,5 s o al primer toque del niño.
class OverlayDemoPuzzle extends StatefulWidget {
  const OverlayDemoPuzzle({
    super.key,
    required this.mensaje,
    required this.alCerrar,
    this.posicionRelativa = Alignment.center,
    this.duracion = const Duration(milliseconds: 3500),
  });

  final String mensaje;
  final VoidCallback alCerrar;
  final Alignment posicionRelativa;
  final Duration duracion;

  @override
  State<OverlayDemoPuzzle> createState() => _OverlayDemoPuzzleState();
}

class _OverlayDemoPuzzleState extends State<OverlayDemoPuzzle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    Future.delayed(widget.duracion, () {
      if (!mounted) return;
      widget.alCerrar();
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contexto) {
    return GestureDetector(
      onTap: widget.alCerrar,
      child: Container(
        color: Colors.black.withOpacity(0.55),
        child: Stack(
          children: [
            Align(
              alignment: widget.posicionRelativa,
              child: AnimatedBuilder(
                animation: _controlador,
                builder: (_, __) {
                  final escala = 0.85 + 0.25 * _controlador.value;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: escala,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: PaletaNeon.azulNeon.withOpacity(0.35),
                            border: Border.all(
                              color: PaletaNeon.azulNeon,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: PaletaNeon.azulNeon.withOpacity(
                                  0.4 * _controlador.value,
                                ),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.touch_app,
                            color: PaletaNeon.textoPrincipal,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: PaletaNeon.fondoMedio.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: PaletaNeon.violetaBase,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.mensaje,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: PaletaNeon.textoPrincipal,
                            fontSize: 15,
                            letterSpacing: 0.5,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: SafeArea(
                child: GestureDetector(
                  onTap: widget.alCerrar,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: PaletaNeon.textoTenue.withOpacity(0.6),
                      ),
                    ),
                    child: const Text(
                      'cerrar',
                      style: TextStyle(
                        color: PaletaNeon.textoTenue,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
