import 'package:flutter/material.dart';

import '../nucleo/paleta_archivo.dart';

/// Pantalla provisional para mientras el juego está en construcción.
///
/// Se muestra cuando la configuración inicial ya está hecha (idioma
/// elegido) pero todavía no hay Brechas, Mesa de Trabajo, Concilio,
/// ni Cuaderno cableados. Su única función es indicarle a quien abra
/// la app antes de tiempo que la cosa avanza.
///
/// Esta pantalla desaparece en cuanto haya un primer flujo jugable
/// — típicamente la primera Brecha del Arco 1 (ver doc 07).
class PantallaEsqueleto extends StatelessWidget {
  const PantallaEsqueleto({super.key});

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'LAS VERSIONES',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 6,
                  color: PaletaArchivo.textoPrincipal,
                  shadows: [
                    Shadow(
                      color: PaletaArchivo.ambarLacre.withOpacity(0.45),
                      blurRadius: 14,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'El Archivo abre sus puertas pronto.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: PaletaArchivo.textoTenue.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Estamos preparando las primeras Brechas — fragmentos '
                'de historia donde el registro se rompe y donde tu '
                'oficio comenzará. Vuelve pronto.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: PaletaArchivo.textoTenue,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
