import 'package:flutter/material.dart';

import '../nucleo/paleta_archivo.dart';

/// Pantalla del primer arranque. Pide a quien juega que elija idioma.
/// Lo muestra en los **tres idiomas a la vez** porque al primer
/// arranque no sabemos cuál entiende — el botón se etiqueta en su
/// propia lengua.
///
/// Equivalente simétrico a la pantalla de configuración inicial de
/// Uno Roto, pero con la paleta del Archivo. Cualquier diferencia de
/// presentación se cierra cuando se aborde el doc 11 (guía visual)
/// de Las Versiones.
///
/// Se persiste en `nuevoser.lasversiones.idioma_app` vía
/// [RepositorioIdiomaApp] y la app vuelve a arrancar con el locale
/// elegido. Solo se muestra si esa clave no existe.
class PantallaConfiguracionInicial extends StatelessWidget {
  /// Llamado con el código del idioma elegido (`'es'`, `'eu'`, `'ca'`).
  final ValueChanged<String> alElegirIdioma;

  const PantallaConfiguracionInicial({
    super.key,
    required this.alElegirIdioma,
  });

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: LayoutBuilder(
            builder: (contexto, restricciones) {
              final alturaLogo =
                  (restricciones.maxHeight * 0.35).clamp(140.0, 280.0);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Image.asset(
                    'assets/marca/las_versiones_logo.png',
                    height: alturaLogo,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  const _LineaTrilingue('Hola.', 'Kaixo.', 'Hola.'),
                  const SizedBox(height: 12),
                  const _LineaTrilingue(
                    '¿En qué idioma te hablo?',
                    'Zein hizkuntzatan hitz egingo dizut?',
                    'En quina llengua et parlo?',
                  ),
                  const Spacer(),
                  _BotonIdioma(
                    etiqueta: 'Castellano',
                    codigo: 'es',
                    alPulsar: alElegirIdioma,
                  ),
                  const SizedBox(height: 14),
                  _BotonIdioma(
                    etiqueta: 'Euskara',
                    codigo: 'eu',
                    alPulsar: alElegirIdioma,
                  ),
                  const SizedBox(height: 14),
                  _BotonIdioma(
                    etiqueta: 'Català',
                    codigo: 'ca',
                    alPulsar: alElegirIdioma,
                  ),
                  const Spacer(flex: 2),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LineaTrilingue extends StatelessWidget {
  final String es;
  final String eu;
  final String ca;

  const _LineaTrilingue(this.es, this.eu, this.ca);

  @override
  Widget build(BuildContext contexto) {
    final estilo = TextStyle(
      color: PaletaArchivo.textoTenue.withOpacity(0.9),
      fontSize: 14,
      height: 1.5,
    );
    return Column(
      children: [
        Text(es, textAlign: TextAlign.center, style: estilo),
        Text(eu, textAlign: TextAlign.center, style: estilo),
        Text(ca, textAlign: TextAlign.center, style: estilo),
      ],
    );
  }
}

class _BotonIdioma extends StatelessWidget {
  final String etiqueta;
  final String codigo;
  final ValueChanged<String> alPulsar;

  const _BotonIdioma({
    required this.etiqueta,
    required this.codigo,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    return ElevatedButton(
      onPressed: () => alPulsar(codigo),
      style: ElevatedButton.styleFrom(
        backgroundColor: PaletaArchivo.fondoMedio,
        foregroundColor: PaletaArchivo.textoPrincipal,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: PaletaArchivo.ambarLacre.withOpacity(0.55),
          ),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w400,
        ),
      ),
      child: Text(etiqueta),
    );
  }
}
