import 'package:flutter/material.dart';

import '../datos/repositorio_mosaico.dart';
import '../dominio/mosaico_arco_3.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla del Mosaico del Arco 3 (doc 09 §M3).
///
/// **Formato ficha de museo**: una sola cartela con seis líneas
/// (procedencia, datación, lengua, función original, reutilización,
/// lo que la piedra dice). Cada línea ya lleva en su texto el
/// nivel de confianza correspondiente — la pantalla no pide a la
/// Cronista que asigne nivel, sino que lea la cartela y la marque
/// como leída línea por línea.
///
/// **Pedagogía clave** (doc 09 §M3): la cartela es la voz
/// museográfica de Maren articulando la pieza con todos los niveles
/// visibles. La regla de entrega — al menos 5 líneas leídas de 6 —
/// preserva el respeto a la decisión de la Cronista de no marcar
/// alguna línea si quiere reservarse algo.
///
/// La entrega encadena con la cinemática `M3.entrega` (Andrés
/// archiva la cartela, pregunta sólo *"¿La piedra existe?"* y
/// cierra *"La gente que pase por allí ya sabe que hay alguien que
/// la mira con respeto."*). El orquestador maneja esa cadena.
///
/// **PENDIENTE DE VALIDACIÓN COMITÉ TUDELA-1378**: la pieza concreta
/// (piedra grabada del barrio mudéjar de Tudela) y la cartela
/// completa son material del doc 09 v0.3 que reproduce fielmente
/// el original. Registrado en `BLOQUEOS-PENDIENTES.md`.
class PantallaMosaicoArco3 extends StatefulWidget {
  /// Callback al que llamar cuando la Cronista entrega la ficha.
  final Future<void> Function() alEntregar;

  /// Repositorio genérico por `idArco`. Reutilizado del M1/M2 con
  /// `idArco='arco_3'` — el M3 marca cada línea con
  /// `NivelConfianza.solido` como marcador binario de "leída"
  /// (las líneas ya tienen el nivel canónico declarado en su texto;
  /// la pantalla NO pide a la Cronista que reasigne).
  final RepositorioMosaico repoMosaico;

  /// Callback opcional para abrir el Menú principal.
  final VoidCallback? alAbrirMenu;

  const PantallaMosaicoArco3({
    super.key,
    required this.alEntregar,
    required this.repoMosaico,
    this.alAbrirMenu,
  });

  @override
  State<PantallaMosaicoArco3> createState() => _PantallaMosaicoArco3State();
}

class _PantallaMosaicoArco3State extends State<PantallaMosaicoArco3> {
  Set<String> _lineasLeidas = const {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarMarcasPersistidas();
  }

  Future<void> _cargarMarcasPersistidas() async {
    final mapa = await widget.repoMosaico.cargar(MosaicoArco3.idArco);
    if (!mounted) return;
    setState(() {
      _lineasLeidas = mapa.keys.toSet();
      _cargando = false;
    });
  }

  Future<void> _alAlternarLinea(LineaCartelaMuseo linea) async {
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
    await widget.repoMosaico.guardar(MosaicoArco3.idArco, mapa);
  }

  Future<void> _alPulsarEntregar() async {
    if (_lineasLeidas.length <
        MosaicoArco3.minimoLineasLeidasParaEntregar) {
      return;
    }
    final mapa = <String, NivelConfianza>{
      for (final id in _lineasLeidas) id: NivelConfianza.solido,
    };
    await widget.repoMosaico.guardar(MosaicoArco3.idArco, mapa);
    await widget.alEntregar();
  }

  @override
  Widget build(BuildContext contexto) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: PaletaArchivo.fondoProfundo,
        body: SizedBox.expand(),
      );
    }
    final puedeEntregar = _lineasLeidas.length >=
        MosaicoArco3.minimoLineasLeidasParaEntregar;
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
          MosaicoArco3.titulo.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            letterSpacing: 4,
            color: PaletaArchivo.ambarLacre,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          MosaicoArco3.preguntaAbiertaDelArco,
          style: TextStyle(
            fontSize: 14,
            color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
            height: 1.5,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          MosaicoArco3.glosa,
          style: TextStyle(
            fontSize: 12,
            color: PaletaArchivo.textoPrincipal.withOpacity(0.75),
            height: 1.5,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 12),
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
            MosaicoArco3.identificacionDeLaPieza,
            style: TextStyle(
              fontSize: 11,
              color: PaletaArchivo.textoTenue.withOpacity(0.95),
              height: 1.55,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: MosaicoArco3.cartela.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (contexto, indice) {
              final linea = MosaicoArco3.cartela[indice];
              return _LineaCartela(
                linea: linea,
                marcada: _lineasLeidas.contains(linea.id),
                alPulsar: () => _alAlternarLinea(linea),
              );
            },
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
              'ENTREGAR LA FICHA',
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
    final total = MosaicoArco3.cartela.length;
    const minimo = MosaicoArco3.minimoLineasLeidasParaEntregar;
    if (cantidadLeidas < minimo) {
      final faltan = minimo - cantidadLeidas;
      return '$cantidadLeidas de $total leídas — faltan $faltan para '
          'entregar';
    }
    return '$cantidadLeidas de $total leídas';
  }
}

class _LineaCartela extends StatelessWidget {
  final LineaCartelaMuseo linea;
  final bool marcada;
  final VoidCallback alPulsar;

  const _LineaCartela({
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
                    child: Text(
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
