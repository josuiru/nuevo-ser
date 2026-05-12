import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../datos/base_datos.dart';
import '../modelos/lote_aceite.dart';
import '../modelos/movimiento.dart';

/// Libro de movimientos del aceite — tabla cronológica de todas las
/// entradas/salidas/mezclas/envasados de cualquier lote, conforme al
/// seguimiento que exige AICA + RD 760/2021. F1-A5 generará el PDF
/// inspeccionable; aquí sólo damos la vista.
class PantallaLibroAceite extends StatefulWidget {
  const PantallaLibroAceite({super.key});

  @override
  State<PantallaLibroAceite> createState() => _PantallaLibroAceiteState();
}

class _PantallaLibroAceiteState extends State<PantallaLibroAceite> {
  final _formatoFecha = DateFormat('d/M/yyyy', 'es_ES');
  List<_FilaLibro> _filas = const [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final bd = BaseDatosSoleraAceitera();
    final lotes = await bd.listarLotesAceite();
    final mapaLotes = {for (final l in lotes) l.id!: l};
    final movimientos = await bd.listarMovimientos();
    final filas = movimientos
        .map((m) {
          final lote = mapaLotes[m.loteAceiteId];
          if (lote == null) return null;
          return _FilaLibro(movimiento: m, lote: lote);
        })
        .whereType<_FilaLibro>()
        .toList(growable: false);
    if (!mounted) return;
    setState(() => _filas = filas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Libro de movimientos del aceite')),
      body: _filas.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Sin movimientos registrados todavía.\n'
                  'Cada lote nuevo aporta una entrada al libro; mezclas, '
                  'envasados, ventas y autoconsumos también aparecen aquí.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _cargar,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: _filas.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final fila = _filas[i];
                  return ListTile(
                    leading: const Icon(Icons.swap_horiz,
                        color: Color(0xFF5C6B3A)),
                    title: Text(
                      '${_formatoFecha.format(DateTime.fromMillisecondsSinceEpoch(fila.movimiento.fechaMs))}'
                      ' · Lote ${fila.lote.identificadorLote}',
                    ),
                    subtitle: Text(
                      '${fila.movimiento.tipo} · '
                      '${fila.movimiento.kgMovidos.toStringAsFixed(1)} kg'
                      '${fila.movimiento.ubicacionDestino.isEmpty ? "" : " → ${fila.movimiento.ubicacionDestino}"}',
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _FilaLibro {
  final Movimiento movimiento;
  final LoteAceite lote;

  const _FilaLibro({required this.movimiento, required this.lote});
}
