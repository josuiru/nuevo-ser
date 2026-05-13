// Pantalla del cuaderno del jugador.
//
// El cuaderno es el progreso visible del niño en el juego. Sin XP,
// sin barras, sin estrellas — solo páginas que ganan densidad.
//
// Tres secciones iniciales en v0.4.0:
//   - Lenguas: una página por lengua vista en el corpus trabajado.
//   - Personajes: una página por VozRemitente recurrente con piezas
//     trabajadas. Muestra nivel de familiaridad.
//   - Documentos resueltos: lista de piezas en bandeja resuelto.
//
// Diseño tipográfico: el cuaderno habla poco (doc 09 §2). Su voz es
// la tipografía, no el adjetivo.

import 'package:flutter/material.dart';

import '../dominio/estado_sesion.dart';
import '../dominio/familiaridad_remitente.dart';
import '../dominio/lengua.dart';
import '../dominio/pieza_corpus.dart';
import '../dominio/voz_remitente.dart';
import 'paleta_estafeta.dart';

class PantallaCuaderno extends StatelessWidget {
  const PantallaCuaderno({
    super.key,
    required this.estadoSesion,
    required this.familiaridad,
  });

  /// Estado actual de la sesión: piezas resueltas que el cuaderno
  /// indexa.
  final EstadoSesion estadoSesion;

  /// Familiaridad con remitentes recurrentes (acumulada en sesiones).
  final FamiliaridadRemitente familiaridad;

  @override
  Widget build(BuildContext contexto) {
    final piezasResueltas = estadoSesion.piezasResueltas();
    final lenguasVistas = _lenguasVistasEn(piezasResueltas);
    final remitentesConocidos = familiaridad.remitentesConocidos();

    return Scaffold(
      backgroundColor: PaletaEstafeta.madera,
      appBar: AppBar(
        backgroundColor: PaletaEstafeta.madera,
        foregroundColor: PaletaEstafeta.papel,
        title: const Text(
          'Tu cuaderno',
          style: TextStyle(fontFamily: 'serif'),
        ),
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Card(
            color: PaletaEstafeta.papel,
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SeccionLenguas(lenguasVistas: lenguasVistas),
                  const _SeparadorPagina(),
                  _SeccionPersonajes(
                    familiaridad: familiaridad,
                    remitentes: remitentesConocidos,
                  ),
                  const _SeparadorPagina(),
                  _SeccionDocumentosResueltos(piezas: piezasResueltas),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Set<Lengua> _lenguasVistasEn(List<PiezaCorpus> piezas) {
    final lenguas = <Lengua>{};
    for (final pieza in piezas) {
      lenguas.add(pieza.lenguaPrincipal);
      lenguas.addAll(pieza.lenguasInfiltradas);
    }
    return lenguas;
  }
}

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion(this.texto);

  final String texto;

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        texto,
        style: const TextStyle(
          color: PaletaEstafeta.tinta,
          fontSize: 20,
          fontFamily: 'serif',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SeparadorPagina extends StatelessWidget {
  const _SeparadorPagina();

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '※',
            style: TextStyle(
              color: PaletaEstafeta.sepia.withValues(alpha: 0.6),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeccionLenguas extends StatelessWidget {
  const _SeccionLenguas({required this.lenguasVistas});

  final Set<Lengua> lenguasVistas;

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSeccion('Lenguas'),
        if (lenguasVistas.isEmpty)
          const _MensajeVacio(
            'Aún no has visto ninguna lengua. Lo harás cuando abras la primera pieza.',
          )
        else
          for (final lengua in lenguasVistas)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    '·',
                    style: TextStyle(
                      color: PaletaEstafeta.sepia.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    lengua.nombreCanonico,
                    style: const TextStyle(
                      color: PaletaEstafeta.tinta,
                      fontSize: 15,
                      fontFamily: 'serif',
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}

class _SeccionPersonajes extends StatelessWidget {
  const _SeccionPersonajes({
    required this.familiaridad,
    required this.remitentes,
  });

  final FamiliaridadRemitente familiaridad;
  final Set<VozRemitente> remitentes;

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSeccion('Personajes'),
        if (remitentes.isEmpty)
          const _MensajeVacio(
            'Aún no conoces a nadie. Las cartas que llegan tienen quién las firma.',
          )
        else
          for (final remitente in remitentes)
            _FilaPersonaje(
              remitente: remitente,
              nivel: familiaridad.nivelCon(remitente),
            ),
      ],
    );
  }
}

class _FilaPersonaje extends StatelessWidget {
  const _FilaPersonaje({required this.remitente, required this.nivel});

  final VozRemitente remitente;
  final NivelFamiliaridad nivel;

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '·',
            style: TextStyle(
              color: PaletaEstafeta.sepia.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  remitente.nombreCanonico,
                  style: const TextStyle(
                    color: PaletaEstafeta.tinta,
                    fontSize: 15,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nivel.etiquetaCanonica,
                  style: TextStyle(
                    color: PaletaEstafeta.sepia.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeccionDocumentosResueltos extends StatelessWidget {
  const _SeccionDocumentosResueltos({required this.piezas});

  final List<PiezaCorpus> piezas;

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSeccion('Documentos resueltos'),
        if (piezas.isEmpty)
          const _MensajeVacio(
            'Aún no has decidido sobre ninguna pieza. Lo harás cuando archives o entregues la primera.',
          )
        else
          for (final pieza in piezas)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '·',
                    style: TextStyle(
                      color: PaletaEstafeta.sepia.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${pieza.remitenteTextoLibre.replaceAll('_', ' ')} '
                      '— ${pieza.lenguaPrincipal.nombreCanonico}',
                      style: const TextStyle(
                        color: PaletaEstafeta.tinta,
                        fontSize: 14,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}

class _MensajeVacio extends StatelessWidget {
  const _MensajeVacio(this.texto);

  final String texto;

  @override
  Widget build(BuildContext contexto) {
    return Text(
      texto,
      style: TextStyle(
        color: PaletaEstafeta.tinta.withValues(alpha: 0.5),
        fontSize: 13,
        fontFamily: 'serif',
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
