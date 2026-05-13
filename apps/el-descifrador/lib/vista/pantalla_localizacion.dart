// Pantalla simple de una localización del puerto que NO es la
// oficina (despacho del maestro, muelle, Boletín, calle mayor).
//
// v0.13.0: contenido mínimo — fondo renderizado + texto narrativo
// breve + acceso al mapa para moverse. Los hooks de cada localización
// (recoger correo en el muelle, hablar con el maestro, ver
// publicaciones del Boletín) llegan en sprints posteriores cuando el
// sistema de correo y eventos exista.

import 'package:flutter/material.dart';

import '../dominio/localizacion.dart';
import 'paleta_estafeta.dart';

class PantallaLocalizacion extends StatelessWidget {
  const PantallaLocalizacion({
    super.key,
    required this.localizacion,
    required this.alAbrirMapa,
    required this.alVolverAOficina,
  });

  final Localizacion localizacion;
  final VoidCallback alAbrirMapa;
  final VoidCallback alVolverAOficina;

  String _textoNarrativo() {
    switch (localizacion) {
      case Localizacion.calleMayor:
        return 'La Calle Mayor. Empedrada, con tiendas que cierran al '
            'atardecer. A un lado La Estafeta. Al fondo El Boletín. La '
            'cuesta abajo lleva al muelle.';
      case Localizacion.despachoMaestro:
        return 'El despacho de Antón. Huele a tabaco apagado y café de '
            'puchero. Mapa del puerto colgado en la pared. Estás de pie '
            'frente a su mesa.\n\n'
            'Hoy no tiene nada que decirte. Vuelve a tu mesa.';
      case Localizacion.muelle:
        return 'El muelle al atardecer. Tablones gastados, olor a brea, '
            'rumor de mar. Las sacas de correo del día ya están vacías: '
            'el cartero las llevó a la oficina por la mañana.\n\n'
            'No ha llegado correo nuevo.';
      case Localizacion.boletin:
        return 'El taller del Boletín. La prensa de hierro y madera '
            'reposa en el centro. Dos hojas recién impresas cuelgan a '
            'secar.\n\n'
            'Aún no has publicado nada.';
      case Localizacion.oficina:
        // Caso defensivo — la oficina tiene PantallaMesa propia.
        return 'Tu mesa.';
    }
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaEstafeta.madera,
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo renderizado.
            Positioned.fill(
              child: Image.asset(
                localizacion.rutaFondo,
                fit: BoxFit.cover,
              ),
            ),
            // Velo oscuro suave para legibilidad del texto.
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.30)),
            ),
            // Mapa y volver, esquina superior izquierda.
            Positioned(
              top: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BotonNavegar(
                    icono: Icons.map_outlined,
                    etiqueta: 'Mapa',
                    alPulsar: alAbrirMapa,
                  ),
                  const SizedBox(height: 8),
                  _BotonNavegar(
                    icono: Icons.home_outlined,
                    etiqueta: 'Volver a tu mesa',
                    alPulsar: alVolverAOficina,
                  ),
                ],
              ),
            ),
            // Texto narrativo, centro.
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizacion.nombreCanonico,
                        style: const TextStyle(
                          color: PaletaEstafeta.papel,
                          fontSize: 28,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _textoNarrativo(),
                        style: TextStyle(
                          color: PaletaEstafeta.papel.withValues(alpha: 0.92),
                          fontSize: 16,
                          fontFamily: 'serif',
                          height: 1.45,
                        ),
                      ),
                    ],
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

class _BotonNavegar extends StatelessWidget {
  const _BotonNavegar({
    required this.icono,
    required this.etiqueta,
    required this.alPulsar,
  });

  final IconData icono;
  final String etiqueta;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext contexto) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(2),
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, color: PaletaEstafeta.papel, size: 16),
              const SizedBox(width: 8),
              Text(
                etiqueta,
                style: const TextStyle(
                  color: PaletaEstafeta.papel,
                  fontSize: 13,
                  fontFamily: 'serif',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
