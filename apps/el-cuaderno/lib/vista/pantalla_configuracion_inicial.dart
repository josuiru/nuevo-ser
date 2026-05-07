import 'package:flutter/material.dart';

import '../nucleo/i18n/generado/textos_app.dart';
import 'tema/colores.dart';

/// Pantalla del primer arranque. Pide al niño que elija el idioma del
/// juego. Lo muestra en los **tres a la vez** porque al primer
/// arranque no sabemos cuál entiende — el botón se etiqueta en su
/// propia lengua.
///
/// Equivalente simétrico a la pantalla de configuración inicial de
/// Uno Roto y Las Versiones, pero con la paleta botánica del
/// Cuaderno. Sentence case en los textos (biblia §10).
///
/// Se persiste en `nuevoser.elcuaderno.idioma_app` vía
/// `RepositorioIdiomaApp` y la app vuelve a arrancar con el locale
/// elegido. Solo se muestra si esa clave no existe.
///
/// Incluye un enlace discreto a la política de privacidad: el adulto
/// que acompaña al niño en el primer arranque puede leerla antes de
/// continuar. El texto del diálogo es un BORRADOR — la versión
/// definitiva la escribirá la asesoría legal LOPDGDD (ítem 5 de la
/// memoria `project_el_cuaderno_decisiones_humanas_pendientes`).
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
      backgroundColor: PaletaCuaderno.papelClaro,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                'el cuaderno',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                  color: PaletaCuaderno.tinta,
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
              const SizedBox(height: 18),
              _EnlacePolitica(),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnlacePolitica extends StatelessWidget {
  @override
  Widget build(BuildContext contexto) {
    final textos = TextosApp.of(contexto);
    return TextButton(
      onPressed: () => _mostrarDialogoPolitica(contexto),
      style: TextButton.styleFrom(
        foregroundColor: PaletaCuaderno.tintaTenue,
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
        ),
      ),
      child: Text(textos.configuracionInicialEnlacePolitica),
    );
  }

  Future<void> _mostrarDialogoPolitica(BuildContext contexto) {
    final textos = TextosApp.of(contexto);
    return showDialog<void>(
      context: contexto,
      builder: (contextoDialogo) => AlertDialog(
        backgroundColor: PaletaCuaderno.papelClaro,
        title: Text(textos.configuracionInicialPoliticaTitulo),
        content: SingleChildScrollView(
          child: Text(
            textos.configuracionInicialPoliticaCuerpo,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: PaletaCuaderno.tinta,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contextoDialogo).pop(),
            child: Text(textos.sitSpotExplicacionCerrar),
          ),
        ],
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
    const estilo = TextStyle(
      color: PaletaCuaderno.tintaTenue,
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
        backgroundColor: PaletaCuaderno.papelMedio,
        foregroundColor: PaletaCuaderno.tinta,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: PaletaCuaderno.papelOscuro),
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
