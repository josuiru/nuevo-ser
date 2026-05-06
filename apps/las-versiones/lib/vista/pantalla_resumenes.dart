import 'package:flutter/material.dart';

import '../datos/repositorio_mosaico.dart';
import '../dominio/mosaico_arco_1.dart';
import '../dominio/mosaico_arco_2.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla "Resúmenes" — lista los Mosaicos de fin de arco que la
/// Cronista ya ha entregado. Cada Mosaico aparece como tarjeta con
/// título + formato + fecha implícita ("entregado") + un acceso a
/// ver las marcas pieza a pieza (sólido/probable/disputado).
///
/// No permite editar nada — los Mosaicos entregados son lectura. La
/// `PantallaMosaicoArco1` y `PantallaMosaicoArco2` siguen siendo el
/// camino para entregarlos cuando aún están abiertos; aquí sólo se
/// vuelve a leer lo entregado.
class PantallaResumenes extends StatelessWidget {
  /// `true` si el Mosaico del Arco 1 ya se entregó. Cuando es `false`
  /// el resumen sigue apareciendo, pero como "pendiente" — la
  /// Cronista entrega el Mosaico desde el flujo del juego.
  final bool mosaicoArco1Entregado;

  /// `true` si el Mosaico del Arco 2 ya se entregó.
  final bool mosaicoArco2Entregado;

  /// Marcas del Mosaico del Arco 1 (idVineta → NivelConfianza). Vacío
  /// si la Cronista no ha marcado nada todavía.
  final Map<String, NivelConfianza> marcasArco1;

  /// Marcas del Mosaico del Arco 2.
  final Map<String, NivelConfianza> marcasArco2;

  const PantallaResumenes({
    super.key,
    required this.mosaicoArco1Entregado,
    required this.mosaicoArco2Entregado,
    required this.marcasArco1,
    required this.marcasArco2,
  });

  /// Constructor de conveniencia que carga las marcas vivas desde el
  /// repositorio. Útil para usar `PantallaResumenes.cargandoDesde(...)`
  /// en lugar de inyectar los maps a mano desde main.dart.
  static Future<PantallaResumenes> cargandoDesde({
    required RepositorioMosaico repoMosaico,
    required bool mosaicoArco1Entregado,
    required bool mosaicoArco2Entregado,
  }) async {
    final marcas1 = await repoMosaico.cargar(MosaicoArco1.idArco);
    final marcas2 = await repoMosaico.cargar(MosaicoArco2.idArco);
    return PantallaResumenes(
      mosaicoArco1Entregado: mosaicoArco1Entregado,
      mosaicoArco2Entregado: mosaicoArco2Entregado,
      marcasArco1: marcas1,
      marcasArco2: marcas2,
    );
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaArchivo.fondoProfundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PaletaArchivo.textoPrincipal,
          onPressed: () => Navigator.of(contexto).maybePop(),
        ),
        title: Text(
          'RESÚMENES',
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 5,
            color: PaletaArchivo.textoPrincipal,
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: PaletaArchivo.ambarLacre.withOpacity(0.35),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            const SizedBox(height: 6),
            const Text(
              'Los Mosaicos son la entrega creativa de fin de arco — '
              'cada uno reúne lo que la Cronista quiso recoger del oficio. '
              'Aquí los puedes volver a leer.',
              style: TextStyle(
                fontSize: 13,
                height: 1.55,
                color: PaletaArchivo.textoTenue,
              ),
            ),
            const SizedBox(height: 18),
            _TarjetaMosaicoArco1(
              entregado: mosaicoArco1Entregado,
              marcas: marcasArco1,
            ),
            const SizedBox(height: 14),
            _TarjetaMosaicoArco2(
              entregado: mosaicoArco2Entregado,
              marcas: marcasArco2,
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaMosaicoArco1 extends StatelessWidget {
  final bool entregado;
  final Map<String, NivelConfianza> marcas;

  const _TarjetaMosaicoArco1({required this.entregado, required this.marcas});

  @override
  Widget build(BuildContext contexto) {
    return _TarjetaMosaico(
      titulo: MosaicoArco1.titulo,
      formato: 'Cómic mudo de 8 viñetas',
      entregado: entregado,
      filas: [
        for (final vineta in MosaicoArco1.vinetas)
          _PiezaResumen(
            titulo: vineta.pieDescriptivo,
            nivel: marcas[vineta.id],
          ),
      ],
    );
  }
}

class _TarjetaMosaicoArco2 extends StatelessWidget {
  final bool entregado;
  final Map<String, NivelConfianza> marcas;

  const _TarjetaMosaicoArco2({required this.entregado, required this.marcas});

  @override
  Widget build(BuildContext contexto) {
    return _TarjetaMosaico(
      titulo: MosaicoArco2.titulo,
      formato: 'Audio-guía de 8 fragmentos (~90 segundos)',
      entregado: entregado,
      filas: [
        for (final fragmento in MosaicoArco2.fragmentos)
          _PiezaResumen(
            titulo: fragmento.textoLeido,
            nivel: marcas[fragmento.id],
          ),
      ],
    );
  }
}

class _TarjetaMosaico extends StatelessWidget {
  final String titulo;
  final String formato;
  final bool entregado;
  final List<_PiezaResumen> filas;

  const _TarjetaMosaico({
    required this.titulo,
    required this.formato,
    required this.entregado,
    required this.filas,
  });

  @override
  Widget build(BuildContext contexto) {
    final marcadas = filas.where((f) => f.nivel != null).length;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoMedio.withOpacity(0.5),
        border: Border.all(
          color: PaletaArchivo.ambarLacre.withOpacity(0.45),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    color: PaletaArchivo.textoPrincipal,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                entregado ? 'ENTREGADO' : 'PENDIENTE',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 2.5,
                  color: entregado
                      ? PaletaArchivo.ambarLacre
                      : PaletaArchivo.textoTenue.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formato,
            style: TextStyle(
              fontSize: 12,
              color: PaletaArchivo.textoTenue.withOpacity(0.85),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$marcadas de ${filas.length} piezas marcadas',
            style: const TextStyle(
              fontSize: 11,
              color: PaletaArchivo.textoTenue,
            ),
          ),
          const SizedBox(height: 14),
          for (int indice = 0; indice < filas.length; indice++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      '${indice + 1}.',
                      style: TextStyle(
                        fontSize: 12,
                        color: PaletaArchivo.textoTenue.withOpacity(0.85),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      filas[indice].titulo,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: PaletaArchivo.textoPrincipal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ChipNivel(nivel: filas[indice].nivel),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PiezaResumen {
  final String titulo;
  final NivelConfianza? nivel;
  const _PiezaResumen({required this.titulo, required this.nivel});
}

class _ChipNivel extends StatelessWidget {
  final NivelConfianza? nivel;
  const _ChipNivel({required this.nivel});

  @override
  Widget build(BuildContext contexto) {
    final etiqueta = _etiquetaNivel(nivel);
    final color = _colorNivel(nivel);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        etiqueta,
        style: TextStyle(
          fontSize: 9,
          letterSpacing: 1.5,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static String _etiquetaNivel(NivelConfianza? nivel) {
    if (nivel == null) return 'SIN MARCAR';
    switch (nivel) {
      case NivelConfianza.solido:
        return 'SÓLIDO';
      case NivelConfianza.probable:
        return 'PROBABLE';
      case NivelConfianza.disputado:
        return 'DISPUTADO';
    }
  }

  static Color _colorNivel(NivelConfianza? nivel) {
    if (nivel == null) {
      return PaletaArchivo.textoTenue.withOpacity(0.55);
    }
    switch (nivel) {
      case NivelConfianza.solido:
        return PaletaArchivo.ambarLacre;
      case NivelConfianza.probable:
        return PaletaArchivo.textoPrincipal;
      case NivelConfianza.disputado:
        return PaletaArchivo.tintaTenue;
    }
  }
}
