import 'package:flutter/material.dart';

import '../../dominio/ayuda_puzzle.dart';
import '../../dominio/fragmento_en_tejado.dart';
import '../../nucleo/paleta.dart';
import '../estado_pista_puzzle.dart';

/// Comprueba si el niño ha fallado demasiadas veces y muestra ayuda.
/// Se llama desde cada pantalla de puzzle tras un fallo.
/// Si supera 5 fallos, muestra un dialog con la explicación del puzzle
/// y ofrece volver al mapa. Devuelve true si mostró el dialog.
Future<bool> comprobarYAyudarSiProcede(
  BuildContext context,
  EstadoPistaPuzzle pista,
  TipoFragmentoEnTejado tipo,
) async {
  if (pista.fallosConsecutivos < 5) return false;

  // Reset para no encadenar diálogos
  pista.registrarAcierto();

  if (!context.mounted) return false;

  final result = AyudaPuzzle.paraTipo(tipo);
  final titulo = result.$1;
  final texto = result.$2;
  final transferencia = result.$3;
  final quiereSalir = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (ctx) => AlertDialog(
      backgroundColor: PaletaNeon.fondoMedio,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: PaletaNeon.textoTenue.withOpacity(0.2),
        ),
      ),
      title: Text(
        '¿Necesitas ayuda?',
        style: const TextStyle(
          color: PaletaNeon.textoPrincipal,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: PaletaNeon.violetaNeon,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              texto,
              style: const TextStyle(
                color: PaletaNeon.textoTenue,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            if (transferencia.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PaletaNeon.fondoProfundo.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💡 ', style: const TextStyle(fontSize: 14)),
                    Expanded(
                      child: Text(
                        transferencia,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 13,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text(
            'SEGUIR',
            style: TextStyle(
              color: PaletaNeon.textoPrincipal,
              letterSpacing: 1.5,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text(
            'VOLVER',
            style: TextStyle(
              color: PaletaNeon.rosaAcento,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    ),
  );

  if (quiereSalir == true && context.mounted) {
    Navigator.of(context).pop(true);
  }
  return true;
}
