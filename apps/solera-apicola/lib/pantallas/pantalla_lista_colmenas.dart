import 'package:flutter/material.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:intl/intl.dart';

import '../datos/base_datos.dart';
import '../modelos/apiario.dart';
import '../modelos/colmena.dart';
import 'pantalla_ficha_colmena.dart';

/// Lista filtrable de colmenas por matrícula, raza, estado o notas.
class PantallaListaColmenas extends StatefulWidget {
  const PantallaListaColmenas({super.key});

  @override
  State<PantallaListaColmenas> createState() => _PantallaListaColmenasState();
}

class _PantallaListaColmenasState extends State<PantallaListaColmenas> {
  List<Colmena> _colmenas = [];
  Map<int, Apiario> _apiariosPorId = {};
  String _busqueda = '';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final db = BaseDatosSoleraApicola.instancia;
    final colmenas = await db.listarColmenas();
    final apiarios = await db.listarApiarios();
    if (!mounted) return;
    setState(() {
      _colmenas = colmenas;
      _apiariosPorId = {for (final a in apiarios) a.id!: a};
      _cargando = false;
    });
  }

  List<Colmena> _filtradas() {
    final q = _busqueda.trim().toLowerCase();
    if (q.isEmpty) return _colmenas;
    return _colmenas.where((c) {
      return c.matricula.toLowerCase().contains(q) ||
          c.razaId.toLowerCase().contains(q) ||
          c.tipoColmenaId.toLowerCase().contains(q) ||
          c.notas.toLowerCase().contains(q);
    }).toList();
  }

  String _etiquetaEstado(EstadoColmena e) {
    switch (e) {
      case EstadoColmena.viva:
        return 'Viva';
      case EstadoColmena.vacia:
        return 'Vacía';
      case EstadoColmena.descolmenada:
        return 'Descolmenada';
      case EstadoColmena.enjambreNuevo:
        return 'Enjambre nuevo';
    }
  }

  Color _colorEstado(EstadoColmena e, ColorScheme paleta) {
    switch (e) {
      case EstadoColmena.viva:
      case EstadoColmena.enjambreNuevo:
        return paleta.primary;
      case EstadoColmena.vacia:
        return Colors.grey.shade500;
      case EstadoColmena.descolmenada:
        return Colors.red.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtradas = _filtradas();
    final formatoFecha = DateFormat('dd/MM/yyyy');
    final paleta = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colmenas'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Buscar (matrícula, raza, tipo, notas)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (v) => setState(() => _busqueda = v),
            ),
          ),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : filtradas.isEmpty
              ? Center(
                  child: Text(
                    _colmenas.isEmpty ? 'Sin colmenas registradas todavía.' : 'Sin resultados.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )
              : ListView.separated(
                  itemCount: filtradas.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final c = filtradas[i];
                    final a = c.apiarioId == null ? null : _apiariosPorId[c.apiarioId];
                    final fechaCreacion = formatoFecha.format(
                      DateTime.fromMillisecondsSinceEpoch(c.fechaCreacionMs),
                    );
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _colorEstado(c.estado, paleta),
                        child: const Icon(Icons.hexagon, color: Colors.white, size: 18),
                      ),
                      title: Text(c.matricula),
                      subtitle: Text([
                        a?.nombre ?? 'Punto suelto',
                        if (c.razaId.isNotEmpty) c.razaId,
                        _etiquetaEstado(c.estado),
                        if (c.anoReina != null) 'Reina ${c.anoReina} (${c.colorMarcaReina})',
                        'Alta $fechaCreacion',
                      ].join(' · ')),
                      onTap: () async {
                        final cambio = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(builder: (_) => PantallaFichaColmena(colmenaId: c.id!)),
                        );
                        if (cambio == true) _cargar();
                      },
                    );
                  },
                ),
    );
  }
}
