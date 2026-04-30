import 'package:flutter/material.dart';

import '../datos/repositorio_mosaico.dart';
import '../dominio/mosaico_arco_1.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla del Mosaico v2 del Arco 1 (doc 07 §M1, F8.7).
///
/// Cómic mudo de 8 viñetas pre-descritas. Cada viñeta tiene un pie
/// descriptivo y un selector de **código de confianza** (Sólido /
/// Probable / Disputado) con código de color: azul claro para
/// Sólido, ámbar para Probable, rojo claro para Disputado. Al tap
/// sobre una viñeta se abre un modal de selección. Al pulsar otra
/// vez sobre la misma viñeta se desmarca.
///
/// La pantalla **no evalúa la cualidad estética** ni la corrección
/// de los códigos. Sólo respeta el mínimo de viñetas marcadas para
/// permitir entregar (`MosaicoArco1.minimoVinetasMarcadasParaEntregar`).
/// Tras la entrega, la cinemática `entregaDelMosaico` se reproduce
/// (Andrés + Marina) y la 1.Z cierra el arco — esa cadena la maneja
/// el orquestador en `main.dart`, no la pantalla.
class PantallaMosaicoArco1 extends StatefulWidget {
  /// Callback al que llamar cuando la Cronista entrega el Mosaico.
  /// El orquestador activa el flag de entregado y encadena con la
  /// cinemática post-entrega.
  final Future<void> Function() alEntregar;

  /// Repositorio de persistencia. Inyectable para tests.
  final RepositorioMosaico repoMosaico;

  const PantallaMosaicoArco1({
    super.key,
    required this.alEntregar,
    this.repoMosaico = const RepositorioMosaico(),
  });

  @override
  State<PantallaMosaicoArco1> createState() => _PantallaMosaicoArco1State();
}

class _PantallaMosaicoArco1State extends State<PantallaMosaicoArco1> {
  Map<String, NivelConfianza> _marcas = const {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarMarcasPersistidas();
  }

  Future<void> _cargarMarcasPersistidas() async {
    final mapa = await widget.repoMosaico.cargar(MosaicoArco1.idArco);
    if (!mounted) return;
    setState(() {
      _marcas = Map.of(mapa);
      _cargando = false;
    });
  }

  Future<void> _alSeleccionarVineta(VinetaMosaico vineta) async {
    final nivelSeleccionado = await showModalBottomSheet<_OpcionMarca?>(
      context: context,
      backgroundColor: PaletaArchivo.fondoMedio,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (contexto) => _SelectorConfianza(
        vineta: vineta,
        nivelActual: _marcas[vineta.id],
      ),
    );
    if (!mounted || nivelSeleccionado == null) return;
    setState(() {
      _marcas = Map.of(_marcas);
      if (nivelSeleccionado.borrar) {
        _marcas.remove(vineta.id);
      } else {
        _marcas[vineta.id] = nivelSeleccionado.nivel!;
      }
    });
    await widget.repoMosaico.guardar(MosaicoArco1.idArco, _marcas);
  }

  Future<void> _alPulsarEntregar() async {
    if (_marcas.length < MosaicoArco1.minimoVinetasMarcadasParaEntregar) {
      return;
    }
    await widget.repoMosaico.guardar(MosaicoArco1.idArco, _marcas);
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
    final puedeEntregar =
        _marcas.length >= MosaicoArco1.minimoVinetasMarcadasParaEntregar;
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                MosaicoArco1.titulo.toUpperCase(),
                style: const TextStyle(
                  fontSize: 13,
                  letterSpacing: 4,
                  color: PaletaArchivo.ambarLacre,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                MosaicoArco1.preguntaAbiertaDelArco,
                style: TextStyle(
                  fontSize: 14,
                  color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                MosaicoArco1.glosa,
                style: TextStyle(
                  fontSize: 12,
                  color: PaletaArchivo.textoPrincipal.withOpacity(0.75),
                  height: 1.5,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: MosaicoArco1.vinetas.length,
                  itemBuilder: (contexto, indice) {
                    final vineta = MosaicoArco1.vinetas[indice];
                    return _CartaVineta(
                      vineta: vineta,
                      indice: indice + 1,
                      nivelActual: _marcas[vineta.id],
                      alPulsar: () => _alSeleccionarVineta(vineta),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _textoContador(_marcas.length),
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
          ),
        ),
      ),
    );
  }

  String _textoContador(int cantidadMarcadas) {
    final total = MosaicoArco1.vinetas.length;
    final minimo = MosaicoArco1.minimoVinetasMarcadasParaEntregar;
    if (cantidadMarcadas < minimo) {
      final faltan = minimo - cantidadMarcadas;
      return '$cantidadMarcadas de $total marcadas — faltan $faltan para '
          'entregar';
    }
    return '$cantidadMarcadas de $total marcadas';
  }
}

class _CartaVineta extends StatelessWidget {
  final VinetaMosaico vineta;
  final int indice;
  final NivelConfianza? nivelActual;
  final VoidCallback alPulsar;

  const _CartaVineta({
    required this.vineta,
    required this.indice,
    required this.nivelActual,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    final color = nivelActual != null ? colorParaNivel(nivelActual!) : null;
    final etiqueta = nivelActual != null ? etiquetaParaNivel(nivelActual!) : null;
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        decoration: BoxDecoration(
          color: PaletaArchivo.fondoMedio.withOpacity(0.55),
          border: Border.all(
            color: color != null
                ? color
                : PaletaArchivo.ambarLacre.withOpacity(0.4),
            width: color != null ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${indice.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2.5,
                    color: PaletaArchivo.textoTenue.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (etiqueta != null && color != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: color.withOpacity(0.7)),
                    ),
                    child: Text(
                      etiqueta.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.6,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                vineta.pieDescriptivo,
                style: TextStyle(
                  fontSize: 12,
                  color: PaletaArchivo.textoPrincipal.withOpacity(0.92),
                  height: 1.42,
                  fontStyle: FontStyle.italic,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectorConfianza extends StatelessWidget {
  final VinetaMosaico vineta;
  final NivelConfianza? nivelActual;

  const _SelectorConfianza({
    required this.vineta,
    required this.nivelActual,
  });

  @override
  Widget build(BuildContext contexto) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              vineta.pieDescriptivo,
              style: TextStyle(
                fontSize: 13,
                color: PaletaArchivo.textoPrincipal.withOpacity(0.92),
                height: 1.45,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              '¿CON QUÉ CONFIANZA SOSTIENES ESTA VIÑETA?',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                color: PaletaArchivo.ambarLacre,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            for (final nivel in NivelConfianza.values) ...[
              _BotonNivel(
                nivel: nivel,
                seleccionado: nivelActual == nivel,
                alPulsar: () => Navigator.of(contexto)
                    .pop(_OpcionMarca(nivel: nivel, borrar: false)),
              ),
              const SizedBox(height: 6),
            ],
            if (nivelActual != null) ...[
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Navigator.of(contexto)
                    .pop(const _OpcionMarca(nivel: null, borrar: true)),
                style: TextButton.styleFrom(
                  foregroundColor: PaletaArchivo.textoTenue,
                ),
                child: const Text(
                  'DESMARCAR',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BotonNivel extends StatelessWidget {
  final NivelConfianza nivel;
  final bool seleccionado;
  final VoidCallback alPulsar;

  const _BotonNivel({
    required this.nivel,
    required this.seleccionado,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    final color = colorParaNivel(nivel);
    final etiqueta = etiquetaParaNivel(nivel);
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(seleccionado ? 0.22 : 0.08),
          border: Border.all(
            color: color.withOpacity(seleccionado ? 0.9 : 0.45),
            width: seleccionado ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              etiqueta.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 2.4,
                color: PaletaArchivo.textoPrincipal,
                fontWeight: seleccionado ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Color del código de confianza (doc 07 §M1: azul claro para
/// Sólido, ámbar para Probable, rojo claro para Disputado). Las
/// tonalidades concretas son provisionales hasta cerrar la paleta
/// del juego (doc 11).
Color colorParaNivel(NivelConfianza nivel) {
  switch (nivel) {
    case NivelConfianza.solido:
      return const Color(0xFF7AAFD8);
    case NivelConfianza.probable:
      return PaletaArchivo.ambarLacre;
    case NivelConfianza.disputado:
      return const Color(0xFFD08A82);
  }
}

/// Etiqueta visible del nivel — castellano. Cuando la pantalla
/// pase a localización con ARBs (cuando entren los textos largos),
/// esta función se sustituye por la versión localizada.
String etiquetaParaNivel(NivelConfianza nivel) {
  switch (nivel) {
    case NivelConfianza.solido:
      return 'Sólido';
    case NivelConfianza.probable:
      return 'Probable';
    case NivelConfianza.disputado:
      return 'Disputado';
  }
}

class _OpcionMarca {
  final NivelConfianza? nivel;
  final bool borrar;

  const _OpcionMarca({required this.nivel, required this.borrar});
}
