import 'package:flutter/material.dart';

import '../nucleo/paleta_archivo.dart';

/// Pantalla de ajustes del juego — superficie mínima de escape para la
/// Cronista. Hoy ofrece sólo una acción real: **resetear el Archivo**
/// (borrar todo el progreso local y volver a la configuración inicial).
///
/// Existe a partir de F2-21 después de que una prueba con la app
/// instalada en un dispositivo real expusiera que no había ningún
/// camino para volver atrás desde dentro del juego — la única salida
/// era desinstalar la app o borrar sus datos desde Ajustes Android. La
/// PantallaAjustes resuelve ese bloqueo añadiendo el escape dentro del
/// propio juego.
///
/// Cambio de idioma y selector de perfil quedan **fuera de scope** de
/// este slice: el cambio de idioma hoy no tendría efecto observable
/// (los textos jugables están en castellano) y el multi-perfil sigue
/// pendiente (`GestorPerfiles` no cableado, ver CLAUDE.md). Cuando
/// alguno de los dos entre, se le da su propia acción aquí.
class PantallaAjustes extends StatelessWidget {
  /// Callback que ejecuta el reset real (borrado total). La pantalla
  /// no toca persistencia ni Navigator — el orquestador es el que
  /// recarga el estado y vuelve a despachar a la configuración
  /// inicial. La pantalla sólo invoca el callback dentro de
  /// [_confirmarReseteo] cuando la Cronista confirma.
  final Future<void> Function() alResetearArchivo;

  const PantallaAjustes({
    super.key,
    required this.alResetearArchivo,
  });

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaArchivo.fondoProfundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PaletaArchivo.textoPrincipal,
          onPressed: () => Navigator.of(contexto).maybePop(),
        ),
        title: Text(
          'AJUSTES',
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 5,
            color: PaletaArchivo.textoPrincipal,
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: PaletaArchivo.ambarLacre.withOpacity(0.35),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                'EMPEZAR DE CERO',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 4,
                  color: PaletaArchivo.textoTenue.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Resetear el Archivo borra el idioma elegido, todo '
                'el progreso narrativo, las Brechas trabajadas, las '
                'entradas del Cuaderno y los Mosaicos. Después la '
                'Cronista vuelve al primer arranque.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: PaletaArchivo.textoPrincipal,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'No hay vuelta atrás.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.55,
                  color: PaletaArchivo.ambarLacre,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              OutlinedButton(
                onPressed: () => _confirmarReseteo(contexto),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: PaletaArchivo.ambarLacre.withOpacity(0.7),
                    width: 1.2,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'RESETEAR ARCHIVO',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 4,
                    color: PaletaArchivo.textoPrincipal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'El cambio de idioma y la selección de perfil llegarán '
                'cuando estén cableados. Por ahora la única acción es '
                'el reset.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: PaletaArchivo.textoTenue.withOpacity(0.75),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarReseteo(BuildContext contexto) async {
    final confirmado = await showDialog<bool>(
      context: contexto,
      barrierDismissible: true,
      builder: (ctxDialogo) {
        return AlertDialog(
          backgroundColor: PaletaArchivo.fondoProfundo,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: const Text(
            '¿Resetear el Archivo?',
            style: TextStyle(
              fontSize: 16,
              color: PaletaArchivo.textoPrincipal,
              letterSpacing: 0.5,
            ),
          ),
          content: const Text(
            'Se borrará todo el progreso de esta Cronista. La acción '
            'no se puede deshacer.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: PaletaArchivo.textoPrincipal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctxDialogo).pop(false),
              child: const Text(
                'CANCELAR',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 3,
                  color: PaletaArchivo.textoTenue,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctxDialogo).pop(true),
              child: const Text(
                'SÍ, RESETEAR',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 3,
                  color: PaletaArchivo.ambarLacre,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (confirmado != true) return;
    await alResetearArchivo();
    if (!contexto.mounted) return;
    Navigator.of(contexto).maybePop();
  }
}
