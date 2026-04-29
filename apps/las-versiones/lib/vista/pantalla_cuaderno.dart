import 'package:flutter/material.dart';

import '../dominio/cuaderno.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla del Cuaderno — espacio paralelo del juego (doc 15).
/// Lista vertical de entradas con fecha diegética y texto.
///
/// La Cronista accede al Cuaderno desde el esqueleto y, en el
/// futuro, desde dentro de la pantalla de Brecha (icono arriba).
/// La pantalla es read-only en esta versión — la escritura libre
/// llegará cuando se implemente.
class PantallaCuaderno extends StatelessWidget {
  /// Entradas a mostrar — ya filtradas y ordenadas por el
  /// orquestador. La pantalla no toca persistencia.
  final List<EntradaCuaderno> entradas;

  const PantallaCuaderno({super.key, required this.entradas});

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
          'CUADERNO',
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
        child: entradas.isEmpty
            ? const _CuadernoVacio()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                itemCount: entradas.length,
                separatorBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Divider(
                    color: PaletaArchivo.tintaTenue.withOpacity(0.25),
                    height: 1,
                  ),
                ),
                itemBuilder: (_, indice) {
                  final entrada = entradas[indice];
                  return _EntradaCuaderno(entrada: entrada);
                },
              ),
      ),
    );
  }
}

class _EntradaCuaderno extends StatelessWidget {
  final EntradaCuaderno entrada;

  const _EntradaCuaderno({required this.entrada});

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entrada.fechaDiegetica.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 3.5,
            color: PaletaArchivo.ambarLacre,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          entrada.texto,
          style: TextStyle(
            fontSize: 16,
            color: PaletaArchivo.textoPrincipal.withOpacity(0.92),
            height: 1.6,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _CuadernoVacio extends StatelessWidget {
  const _CuadernoVacio();

  @override
  Widget build(BuildContext contexto) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Text(
          'Aún no has escrito nada. Las entradas aparecerán solas '
          'a medida que el oficio avance.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: PaletaArchivo.textoTenue.withOpacity(0.85),
            height: 1.6,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
