import 'package:flutter/material.dart';

import '../dominio/avances.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla "Avances" — vista lectora del progreso de la Cronista.
/// Muestra cuántas cinemáticas se han visto en cada arco, cuántas
/// Brechas se han cerrado, cuántas entradas hay en el Cuaderno y
/// cuántos Mosaicos se han entregado. Pensada para que tanto la
/// Cronista como el adulto acompañante puedan situarse sin recorrer
/// el mapa narrativo entero.
class PantallaAvances extends StatelessWidget {
  final AvancesArchivo avances;

  const PantallaAvances({super.key, required this.avances});

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
          'AVANCES',
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
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 36),
          children: [
            const _BloqueEncabezado(texto: 'POR ARCO'),
            for (final arco in avances.arcos)
              _FilaArco(arco: arco),
            const SizedBox(height: 24),
            const _BloqueEncabezado(texto: 'EN GLOBAL'),
            _FilaContador(
              icono: Icons.science_outlined,
              etiqueta: 'Brechas cerradas',
              vistas: avances.brechasCompletadas,
              total: avances.brechasTotal,
            ),
            _FilaContador(
              icono: Icons.menu_book_outlined,
              etiqueta: 'Entradas del Cuaderno',
              vistas: avances.entradasCuaderno,
              total: avances.entradasCuadernoTotal,
            ),
            _FilaContador(
              icono: Icons.collections_bookmark_outlined,
              etiqueta: 'Mosaicos entregados',
              vistas: avances.mosaicosEntregados,
              total: avances.mosaicosTotal,
            ),
            const SizedBox(height: 28),
            Text(
              'Las Versiones no premia tener razón. Premia haber juzgado '
              'bien con lo disponible. Estos números cuentan dónde está la '
              'Cronista — no si lo está haciendo bien.',
              style: TextStyle(
                fontSize: 12,
                height: 1.55,
                color: PaletaArchivo.textoTenue.withOpacity(0.85),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BloqueEncabezado extends StatelessWidget {
  final String texto;
  const _BloqueEncabezado({required this.texto});

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: PaletaArchivo.ambarLacre.withOpacity(0.7),
              width: 0.6,
            ),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 4,
            color: PaletaArchivo.ambarLacre,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _FilaArco extends StatelessWidget {
  final AvanceArco arco;
  const _FilaArco({required this.arco});

  @override
  Widget build(BuildContext contexto) {
    final fraccion = arco.cinematicasTotal == 0
        ? 0.0
        : arco.cinematicasVistas / arco.cinematicasTotal;
    final estado = arco.cerrado
        ? 'cerrado'
        : (arco.cinematicasVistas == 0 ? 'sin abrir' : 'en marcha');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  arco.titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    color: PaletaArchivo.textoPrincipal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                estado.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 2.5,
                  color: arco.cerrado
                      ? PaletaArchivo.ambarLacre
                      : PaletaArchivo.textoTenue.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: fraccion.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: PaletaArchivo.tintaTenue.withOpacity(0.25),
              valueColor: AlwaysStoppedAnimation<Color>(
                PaletaArchivo.ambarLacre.withOpacity(0.85),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${arco.cinematicasVistas} de ${arco.cinematicasTotal} '
            'cinemáticas',
            style: TextStyle(
              fontSize: 11,
              color: PaletaArchivo.textoTenue.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaContador extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final int vistas;
  final int total;

  const _FilaContador({
    required this.icono,
    required this.etiqueta,
    required this.vistas,
    required this.total,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icono, color: PaletaArchivo.ambarLacre, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(
                fontSize: 14,
                color: PaletaArchivo.textoPrincipal,
              ),
            ),
          ),
          Text(
            '$vistas / $total',
            style: const TextStyle(
              fontSize: 14,
              color: PaletaArchivo.textoPrincipal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
