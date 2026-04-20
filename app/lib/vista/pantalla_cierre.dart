import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'sora_presencia.dart';

/// Pantalla amable al terminar la sesión. Biblia §2.7: la app nunca
/// presiona para jugar más — siempre propone descansar.
class PantallaCierre extends StatefulWidget {
  final List<String> lineasDeSora;
  final VoidCallback alCerrar;
  final VoidCallback alSeguirPracticando;

  const PantallaCierre({
    super.key,
    required this.lineasDeSora,
    required this.alCerrar,
    required this.alSeguirPracticando,
  });

  @override
  State<PantallaCierre> createState() => _PantallaCierreState();
}

class _PantallaCierreState extends State<PantallaCierre>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  int _indiceLinea = 0;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    super.dispose();
  }

  void _avanzarLinea() {
    if (_indiceLinea < widget.lineasDeSora.length - 1) {
      setState(() => _indiceLinea++);
    }
  }

  bool get _esUltimaLinea => _indiceLinea == widget.lineasDeSora.length - 1;

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controladorCielo,
        builder: (_, __) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: PintorEscenario(
                  fasePulso: _controladorCielo.value,
                  nivelRestauracion: 1.0,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: _avanzarLinea,
                      child: SoraPresencia(
                        textoActivo: widget.lineasDeSora[_indiceLinea],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_esUltimaLinea)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _BotonCierre(
                              etiqueta: 'Seguir practicando',
                              acentuado: false,
                              alPulsar: widget.alSeguirPracticando,
                            ),
                            _BotonCierre(
                              etiqueta: 'Buenas noches',
                              acentuado: true,
                              alPulsar: () {
                                SystemNavigator.pop();
                                widget.alCerrar();
                              },
                            ),
                          ],
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Text(
                          'toca para continuar',
                          style: TextStyle(
                            color: PaletaNeon.textoTenue,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BotonCierre extends StatelessWidget {
  final String etiqueta;
  final bool acentuado;
  final VoidCallback alPulsar;

  const _BotonCierre({
    required this.etiqueta,
    required this.acentuado,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorBorde =
        acentuado ? PaletaNeon.azulNeon : PaletaNeon.violetaNeon;
    final colorFondo = acentuado
        ? PaletaNeon.azulNeon.withOpacity(0.15)
        : Colors.transparent;

    return GestureDetector(
      onTap: alPulsar,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: colorFondo,
          border: Border.all(color: colorBorde, width: 1.5),
          borderRadius: BorderRadius.circular(28),
          boxShadow: acentuado
              ? [
                  BoxShadow(
                    color: PaletaNeon.azulNeon.withOpacity(0.35),
                    blurRadius: 14,
                  ),
                ]
              : const [],
        ),
        child: Text(
          etiqueta,
          style: TextStyle(
            color: PaletaNeon.textoPrincipal
                .withOpacity(acentuado ? 1 : 0.85),
            fontSize: 14,
            letterSpacing: 1.1,
            fontWeight: acentuado ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
