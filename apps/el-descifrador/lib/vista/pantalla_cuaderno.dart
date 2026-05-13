// Pantalla del cuaderno del jugador.
//
// El cuaderno es el progreso visible del niño en el juego. Sin XP,
// sin barras, sin estrellas — solo páginas que ganan densidad.
//
// Secciones del cuaderno:
//   - Lenguas: una página por lengua vista en el corpus trabajado.
//   - Personajes: una página por VozRemitente recurrente con piezas
//     trabajadas. Muestra nivel de familiaridad.
//   - Vocabulario: palabras marcadas verde/amarillo/rojo por lengua.
//   - Mis interpretaciones: hipótesis del niño sobre documentos. Mecánica
//     nuclear §3.4. La hipótesis es estado válido (biblia §2.3).
//   - Documentos resueltos: lista de piezas en bandeja resuelto.
//
// Diseño tipográfico: el cuaderno habla poco (doc 09 §2). Su voz es
// la tipografía, no el adjetivo.

import 'package:flutter/material.dart';

import '../dominio/estado_sesion.dart';
import '../dominio/familiaridad_remitente.dart';
import '../dominio/interpretacion_pieza.dart';
import '../dominio/lengua.dart';
import '../dominio/pieza_corpus.dart';
import '../dominio/vocabulario_jugador.dart';
import '../dominio/voz_remitente.dart';
import 'paleta_estafeta.dart';

class PantallaCuaderno extends StatelessWidget {
  PantallaCuaderno({
    super.key,
    required this.estadoSesion,
    required this.familiaridad,
    required this.vocabulario,
    InterpretacionesPropuestas? interpretaciones,
  }) : interpretaciones =
            interpretaciones ?? InterpretacionesPropuestas.inicial();

  /// Estado actual de la sesión: piezas resueltas que el cuaderno
  /// indexa.
  final EstadoSesion estadoSesion;

  /// Familiaridad con remitentes recurrentes (acumulada en sesiones).
  final FamiliaridadRemitente familiaridad;

  /// Vocabulario de palabras marcadas por el niño en cada lengua.
  final VocabularioJugador vocabulario;

  /// Interpretaciones que el niño ha propuesto para documentos.
  final InterpretacionesPropuestas interpretaciones;

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
                  _SeccionVocabulario(vocabulario: vocabulario),
                  const _SeparadorPagina(),
                  _SeccionInterpretaciones(
                    interpretaciones: interpretaciones,
                    estadoSesion: estadoSesion,
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

class _SeccionVocabulario extends StatelessWidget {
  const _SeccionVocabulario({required this.vocabulario});

  final VocabularioJugador vocabulario;

  @override
  Widget build(BuildContext contexto) {
    final lenguas = vocabulario.lenguasConPalabrasMarcadas();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSeccion('Vocabulario'),
        if (lenguas.isEmpty)
          const _MensajeVacio(
            'Aún no has marcado ninguna palabra. Las que toques aparecerán aquí.',
          )
        else
          for (final lengua in lenguas) ...[
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                lengua.nombreCanonico,
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 14,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            for (final entrada in vocabulario.palabrasEn(lengua))
              _FilaPalabra(palabra: entrada.key, marca: entrada.value),
            const SizedBox(height: 8),
          ],
      ],
    );
  }
}

class _FilaPalabra extends StatelessWidget {
  const _FilaPalabra({required this.palabra, required this.marca});

  final String palabra;
  final MarcaPalabra marca;

  Color get _colorMarca {
    switch (marca.color) {
      case MarcaColor.verde:
        return const Color(0xFF558B2F);
      case MarcaColor.amarillo:
        return const Color(0xFFE0A500);
      case MarcaColor.rojo:
        return const Color(0xFFC62828);
    }
  }

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(
              color: _colorMarca,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 14,
                  fontFamily: 'serif',
                ),
                children: [
                  TextSpan(
                    text: palabra,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (marca.hipotesis != null && marca.hipotesis!.isNotEmpty)
                    TextSpan(
                      text: ' — ${marca.hipotesis}',
                      style: TextStyle(
                        color: PaletaEstafeta.tinta.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeccionInterpretaciones extends StatelessWidget {
  const _SeccionInterpretaciones({
    required this.interpretaciones,
    required this.estadoSesion,
  });

  final InterpretacionesPropuestas interpretaciones;
  final EstadoSesion estadoSesion;

  String _tituloPieza(String idPieza) {
    try {
      final pieza = estadoSesion.piezaPorId(idPieza);
      return '${pieza.remitenteTextoLibre.replaceAll('_', ' ')} '
          '— ${pieza.lenguaPrincipal.nombreCanonico}';
    } catch (_) {
      return idPieza;
    }
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext contexto) {
    final lista = interpretaciones.ordenadasPorFecha();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSeccion('Mis interpretaciones'),
        if (lista.isEmpty)
          const _MensajeVacio(
            'Aún no has propuesto ninguna interpretación. Cuando creas saber '
            'lo que dice un documento, escríbelo aquí.',
          )
        else
          for (final interpretacion in lista)
            _FilaInterpretacion(
              titulo: _tituloPieza(interpretacion.idPieza),
              texto: interpretacion.texto,
              fechaPropuesta: _formatearFecha(interpretacion.fechaPropuesta),
              fechaRevision: interpretacion.fechaUltimaRevision == null
                  ? null
                  : _formatearFecha(interpretacion.fechaUltimaRevision!),
            ),
      ],
    );
  }
}

class _FilaInterpretacion extends StatelessWidget {
  const _FilaInterpretacion({
    required this.titulo,
    required this.texto,
    required this.fechaPropuesta,
    required this.fechaRevision,
  });

  final String titulo;
  final String texto;
  final String fechaPropuesta;
  final String? fechaRevision;

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: PaletaEstafeta.tinta,
              fontSize: 14,
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            fechaRevision == null
                ? 'Propuesta el $fechaPropuesta'
                : 'Propuesta el $fechaPropuesta · revisada el $fechaRevision',
            style: TextStyle(
              color: PaletaEstafeta.sepia.withValues(alpha: 0.8),
              fontSize: 11,
              fontFamily: 'serif',
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            texto,
            style: const TextStyle(
              color: PaletaEstafeta.tinta,
              fontSize: 14,
              fontFamily: 'serif',
              height: 1.4,
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
