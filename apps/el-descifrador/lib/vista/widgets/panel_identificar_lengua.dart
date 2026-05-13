// Panel que se interpone entre el niño y el documento mientras no ha
// identificado la lengua de la pieza. Mecánica nuclear §3.1.
//
// El niño ve el texto del documento pero el botón de identificar es
// lo primero que tiene a mano. Las decisiones, interpretación y marcado
// de palabras quedan desbloqueados solo tras identificar — porque sin
// saber qué lengua es, esas operaciones son arbitrarias.
//
// Cuando el niño elige una candidata:
//   - acertada: el maestro asiente brevemente, el panel desaparece.
//   - errada: el maestro da una pista corta sin penalizar, vuelve a
//     pedir hipótesis. El panel se mantiene.

import 'package:flutter/material.dart';

import '../../dominio/identificaciones_lengua.dart';
import '../../dominio/lengua.dart';
import '../paleta_estafeta.dart';

class PanelIdentificarLengua extends StatelessWidget {
  const PanelIdentificarLengua({
    super.key,
    required this.candidatas,
    required this.identificacionPrevia,
    required this.lenguaCorrecta,
    required this.alElegir,
  });

  final List<Lengua> candidatas;
  final IdentificacionLengua? identificacionPrevia;

  /// Lengua real de la pieza. Solo se usa para construir el mensaje
  /// del maestro tras un fallo (no se muestra al niño hasta que acierte).
  final Lengua lenguaCorrecta;

  final ValueChanged<Lengua> alElegir;

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: PaletaEstafeta.madera.withValues(alpha: 0.08),
        border: Border.all(
          color: PaletaEstafeta.sepia.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿En qué lengua viene?',
            style: TextStyle(
              color: PaletaEstafeta.sepia.withValues(alpha: 0.95),
              fontSize: 13,
              fontFamily: 'serif',
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _instruccion(),
            style: TextStyle(
              color: PaletaEstafeta.tinta.withValues(alpha: 0.7),
              fontSize: 12,
              fontFamily: 'serif',
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final candidata in candidatas)
                _BotonCandidata(
                  lengua: candidata,
                  alPulsar: () => alElegir(candidata),
                ),
            ],
          ),
          if (_huboFalloPrevio()) ...[
            const SizedBox(height: 12),
            _PistaTrasFallo(
              ultimoIntento: identificacionPrevia!.intentos.last,
              lenguaCorrecta: lenguaCorrecta,
            ),
          ],
        ],
      ),
    );
  }

  String _instruccion() {
    if (identificacionPrevia == null || identificacionPrevia!.intentos.isEmpty) {
      return 'Mira las terminaciones, los acentos, las palabritas que se '
          'repiten. No te juegas nada — hipoteja.';
    }
    return 'Otra hipótesis. Sin prisa.';
  }

  bool _huboFalloPrevio() {
    final previa = identificacionPrevia;
    if (previa == null || previa.intentos.isEmpty) return false;
    return !previa.identificadaCorrectamente;
  }
}

class _BotonCandidata extends StatelessWidget {
  const _BotonCandidata({required this.lengua, required this.alPulsar});

  final Lengua lengua;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext contexto) {
    return OutlinedButton(
      onPressed: alPulsar,
      style: OutlinedButton.styleFrom(
        foregroundColor: PaletaEstafeta.tinta,
        side: BorderSide(
          color: PaletaEstafeta.sepia.withValues(alpha: 0.7),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      child: Text(
        lengua.nombreCanonico,
        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'serif',
        ),
      ),
    );
  }
}

class _PistaTrasFallo extends StatelessWidget {
  const _PistaTrasFallo({
    required this.ultimoIntento,
    required this.lenguaCorrecta,
  });

  final Lengua ultimoIntento;
  final Lengua lenguaCorrecta;

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: PaletaEstafeta.madera.withValues(alpha: 0.05),
        border: Border(
          left: BorderSide(
            color: PaletaEstafeta.sepia.withValues(alpha: 0.6),
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'El maestro:',
            style: TextStyle(
              color: PaletaEstafeta.sepia.withValues(alpha: 0.9),
              fontSize: 11,
              fontFamily: 'serif',
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _construirPista(),
            style: const TextStyle(
              color: PaletaEstafeta.tinta,
              fontSize: 13,
              fontFamily: 'serif',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _construirPista() {
    if (ultimoIntento.familia == lenguaCorrecta.familia) {
      return 'Cerca. La familia es la misma. Mira de nuevo qué la '
          'distingue — un acento, una terminación.';
    }
    return 'Mira otra vez. No es ${ultimoIntento.nombreCanonico} — '
        'fíjate en las palabras que se repiten.';
  }
}
