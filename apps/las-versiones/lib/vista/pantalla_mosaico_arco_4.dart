import 'package:flutter/material.dart';

import '../datos/repositorio_mosaico.dart';
import '../dominio/mosaico_arco_4.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla del Mosaico del Arco 4 — proyecto integrador final del
/// MVP (doc 10 §M4).
///
/// **Formato doble cartela paralela**: dos cartelas mostradas una al
/// lado de la otra, cada una con seis líneas (procedencia, datación,
/// lengua, función original, reutilización, lo que la pieza dice).
/// La pantalla las muestra en bloques verticales para que la Cronista
/// las lea en paralelo: la conversación entre las dos piezas — el
/// fragmento cerámico campaniforme de Aralar (Brecha 1.1) y el ara
/// funeraria romana de Pompelo (Brecha 2.1) — es lo que el oficio del
/// MVP le ha enseñado a oír.
///
/// Como en el M3, cada línea ya lleva en su texto el nivel de
/// confianza correspondiente — la pantalla no pide a la Cronista que
/// asigne nivel, sino que lea la cartela y la marque línea por línea.
/// La regla de entrega — al menos 10 líneas leídas de 12 — preserva
/// el respeto a la decisión de la Cronista de no marcar alguna línea
/// si quiere reservarse algo.
///
/// La entrega encadena con la cinemática `M4.entrega` (Andrés archiva
/// el Mosaico y reconoce *"Doble cartela en paralelo. Original."*; al
/// preguntar Maren *"¿Funciona?"*, Andrés cierra *"Maren. La pregunta
/// no me la haces a mí. Ya eres tú la que decide si funciona."*). El
/// orquestador maneja esa cadena.
class PantallaMosaicoArco4 extends StatefulWidget {
  /// Callback al que llamar cuando la Cronista entrega el Mosaico.
  final Future<void> Function() alEntregar;

  /// Repositorio genérico por `idArco`. Reutilizado de M1/M2/M3 con
  /// `idArco='arco_4'` — el M4 marca cada línea con
  /// `NivelConfianza.solido` como marcador binario de "leída" (las
  /// líneas ya tienen el nivel canónico declarado en su texto).
  final RepositorioMosaico repoMosaico;

  /// Callback opcional para abrir el Menú principal.
  final VoidCallback? alAbrirMenu;

  const PantallaMosaicoArco4({
    super.key,
    required this.alEntregar,
    required this.repoMosaico,
    this.alAbrirMenu,
  });

  @override
  State<PantallaMosaicoArco4> createState() => _PantallaMosaicoArco4State();
}

class _PantallaMosaicoArco4State extends State<PantallaMosaicoArco4> {
  Set<String> _lineasLeidas = const {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarMarcasPersistidas();
  }

  Future<void> _cargarMarcasPersistidas() async {
    final mapa = await widget.repoMosaico.cargar(MosaicoArco4.idArco);
    if (!mounted) return;
    setState(() {
      _lineasLeidas = mapa.keys.toSet();
      _cargando = false;
    });
  }

  Future<void> _alAlternarLinea(LineaCartelaParalela linea) async {
    setState(() {
      _lineasLeidas = Set.of(_lineasLeidas);
      if (_lineasLeidas.contains(linea.id)) {
        _lineasLeidas.remove(linea.id);
      } else {
        _lineasLeidas.add(linea.id);
      }
    });
    final mapa = <String, NivelConfianza>{
      for (final id in _lineasLeidas) id: NivelConfianza.solido,
    };
    await widget.repoMosaico.guardar(MosaicoArco4.idArco, mapa);
  }

  Future<void> _alPulsarEntregar() async {
    if (_lineasLeidas.length <
        MosaicoArco4.minimoLineasLeidasParaEntregar) {
      return;
    }
    final mapa = <String, NivelConfianza>{
      for (final id in _lineasLeidas) id: NivelConfianza.solido,
    };
    await widget.repoMosaico.guardar(MosaicoArco4.idArco, mapa);
    await widget.alEntregar();
  }

  int get _totalLineas =>
      MosaicoArco4.cartelaAralar.lineas.length +
      MosaicoArco4.cartelaPompelo.lineas.length;

  @override
  Widget build(BuildContext contexto) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: PaletaArchivo.fondoProfundo,
        body: SizedBox.expand(),
      );
    }
    final puedeEntregar = _lineasLeidas.length >=
        MosaicoArco4.minimoLineasLeidasParaEntregar;
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: _construirCuerpoMosaico(puedeEntregar),
            ),
            if (widget.alAbrirMenu != null)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  tooltip: 'Menú',
                  iconSize: 22,
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: PaletaArchivo.ambarLacre,
                  ),
                  onPressed: widget.alAbrirMenu,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _construirCuerpoMosaico(bool puedeEntregar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          MosaicoArco4.titulo.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            letterSpacing: 4,
            color: PaletaArchivo.ambarLacre,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          MosaicoArco4.preguntaAbiertaDelArco,
          style: TextStyle(
            fontSize: 14,
            color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
            height: 1.5,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          MosaicoArco4.glosa,
          style: TextStyle(
            fontSize: 12,
            color: PaletaArchivo.textoPrincipal.withOpacity(0.75),
            height: 1.5,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 8),
            children: [
              _BloqueCartela(
                cartela: MosaicoArco4.cartelaAralar,
                lineasLeidas: _lineasLeidas,
                alAlternarLinea: _alAlternarLinea,
              ),
              const SizedBox(height: 18),
              _BloqueCartela(
                cartela: MosaicoArco4.cartelaPompelo,
                lineasLeidas: _lineasLeidas,
                alAlternarLinea: _alAlternarLinea,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _textoContador(_lineasLeidas.length),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.4,
            color: PaletaArchivo.textoTenue.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: puedeEntregar ? _alPulsarEntregar : null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: PaletaArchivo.textoPrincipal,
              backgroundColor: PaletaArchivo.fondoMedio
                  .withOpacity(puedeEntregar ? 0.6 : 0.3),
              side: BorderSide(
                color: PaletaArchivo.ambarLacre.withOpacity(
                  puedeEntregar ? 0.7 : 0.3,
                ),
              ),
            ),
            child: const Text(
              'ENTREGAR EL MOSAICO',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _textoContador(int cantidadLeidas) {
    final total = _totalLineas;
    const minimo = MosaicoArco4.minimoLineasLeidasParaEntregar;
    if (cantidadLeidas < minimo) {
      final faltan = minimo - cantidadLeidas;
      return '$cantidadLeidas de $total leídas — faltan $faltan para '
          'entregar';
    }
    return '$cantidadLeidas de $total leídas';
  }
}

class _BloqueCartela extends StatelessWidget {
  final CartelaPiezaArco4 cartela;
  final Set<String> lineasLeidas;
  final Future<void> Function(LineaCartelaParalela) alAlternarLinea;

  const _BloqueCartela({
    required this.cartela,
    required this.lineasLeidas,
    required this.alAlternarLinea,
  });

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          cartela.titulo,
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 3,
            color: PaletaArchivo.ambarLacre,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: PaletaArchivo.fondoMedio.withOpacity(0.4),
            border: Border.all(
              color: PaletaArchivo.ambarLacre.withOpacity(0.45),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            cartela.identificacionDeLaPieza,
            style: TextStyle(
              fontSize: 11,
              color: PaletaArchivo.textoTenue.withOpacity(0.95),
              height: 1.55,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 10),
        for (final linea in cartela.lineas) ...[
          _LineaCartelaParalela(
            linea: linea,
            marcada: lineasLeidas.contains(linea.id),
            alPulsar: () => alAlternarLinea(linea),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _LineaCartelaParalela extends StatelessWidget {
  final LineaCartelaParalela linea;
  final bool marcada;
  final VoidCallback alPulsar;

  const _LineaCartelaParalela({
    required this.linea,
    required this.marcada,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: PaletaArchivo.fondoMedio.withOpacity(0.55),
          border: Border.all(
            color: marcada
                ? PaletaArchivo.ambarLacre.withOpacity(0.85)
                : PaletaArchivo.ambarLacre.withOpacity(0.35),
            width: marcada ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  linea.etiqueta,
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2.5,
                    color: PaletaArchivo.ambarLacre.withOpacity(0.95),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (marcada)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: PaletaArchivo.ambarLacre.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: PaletaArchivo.ambarLacre.withOpacity(0.75),
                      ),
                    ),
                    child: const Text(
                      'LEÍDA',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.6,
                        color: PaletaArchivo.ambarLacre,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              linea.textoDescriptivo,
              style: TextStyle(
                fontSize: 13,
                color: PaletaArchivo.textoPrincipal.withOpacity(0.92),
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
