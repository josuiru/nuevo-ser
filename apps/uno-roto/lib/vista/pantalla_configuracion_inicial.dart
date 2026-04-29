import 'package:flutter/material.dart';

import '../nucleo/paleta.dart';

/// Pantalla del primer arranque. Pide al niño que elija idioma. Lo
/// muestra en los **tres idiomas a la vez** porque al primer arranque
/// no sabemos cuál entiende — el botón se etiqueta en su propia lengua.
///
/// Se persiste en `uroto.idioma_app` y la app vuelve a arrancar con el
/// locale elegido. Solo se muestra si esa clave no existe (primer
/// arranque). Después es accesible desde la pantalla de habilidades
/// (botón debug) por si el niño se equivocó.
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
      backgroundColor: PaletaNeon.fondoProfundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'UNO ROTO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 8,
                  color: PaletaNeon.textoPrincipal,
                  shadows: [
                    Shadow(
                      color: PaletaNeon.violetaNeon.withOpacity(0.5),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
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
      color: PaletaNeon.textoTenue.withOpacity(0.85),
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
        backgroundColor: PaletaNeon.fondoMedio,
        foregroundColor: PaletaNeon.textoPrincipal,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: PaletaNeon.violetaNeon.withOpacity(0.6)),
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
