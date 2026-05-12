import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../datos/base_datos.dart';
import '../datos/catalogo_cultivos.dart';
import '../estado/finca_activa.dart';
import '../modelos/finca.dart';
import '../modelos/planta.dart';
import 'pantalla_ficha_planta.dart';

class PantallaListaPlantas extends StatefulWidget {
  const PantallaListaPlantas({super.key});

  @override
  State<PantallaListaPlantas> createState() => _PantallaListaPlantasState();
}

class _PantallaListaPlantasState extends State<PantallaListaPlantas> {
  final _persistenciaFinca = FincaActivaPersistida();
  final _controladorBusqueda = TextEditingController();
  List<Planta> _plantas = [];
  Map<int, Finca> _fincasIndice = {};
  bool _cargando = true;
  String _consulta = '';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final fincaActivaId = await _persistenciaFinca.cargar();
    final fincas = await BaseDatosAgro.instancia.listarFincas();
    final plantas = await BaseDatosAgro.instancia.listarPlantas(fincaId: fincaActivaId);
    if (!mounted) return;
    setState(() {
      _fincasIndice = {for (final f in fincas) f.id!: f};
      _plantas = plantas;
      _cargando = false;
    });
  }

  /// Filtra por etiqueta, variedad, nombre del cultivo y nombre de la
  /// finca. Coincidencia case-insensitive sin tildes (mosca olivo
  /// debería encontrarse buscando "olivo" o "OLIVO" o "Olivar").
  List<Planta> get _plantasFiltradas {
    if (_consulta.trim().isEmpty) return _plantas;
    final q = _normalizar(_consulta);
    return _plantas.where((p) {
      final cultivo = cultivoPorId(p.cultivoId);
      final finca = p.fincaId != null ? _fincasIndice[p.fincaId] : null;
      return _normalizar(p.etiqueta).contains(q) ||
          _normalizar(p.variedad).contains(q) ||
          _normalizar(cultivo.nombreVisible).contains(q) ||
          _normalizar(cultivo.nombreCientifico).contains(q) ||
          (finca != null && _normalizar(finca.nombre).contains(q));
    }).toList();
  }

  /// Normaliza a minúsculas y quita las tildes habituales del castellano
  /// para que la búsqueda no falle por acento. Patrón heredado del
  /// `slugify` del nuevo_ser_core.
  static String _normalizar(String texto) {
    return texto
        .toLowerCase()
        .replaceAll(RegExp(r'[áàä]'), 'a')
        .replaceAll(RegExp(r'[éèë]'), 'e')
        .replaceAll(RegExp(r'[íìï]'), 'i')
        .replaceAll(RegExp(r'[óòö]'), 'o')
        .replaceAll(RegExp(r'[úùü]'), 'u')
        .replaceAll('ñ', 'n');
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final filtradas = _plantasFiltradas;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantas'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _controladorBusqueda,
              decoration: InputDecoration(
                hintText: 'Buscar por etiqueta, variedad, cultivo o finca',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _consulta.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controladorBusqueda.clear();
                          setState(() => _consulta = '');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (v) => setState(() => _consulta = v),
            ),
          ),
        ),
      ),
      body: _plantas.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aún no hay plantas registradas.\nVe al mapa y usa el botón "Añadir aquí" o el modo censo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          : filtradas.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Sin resultados para "$_consulta".',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: ListView.builder(
                    itemCount: filtradas.length,
                    itemBuilder: (_, i) {
                      final p = filtradas[i];
                      final cultivo = cultivoPorId(p.cultivoId);
                      final finca = p.fincaId != null ? _fincasIndice[p.fincaId] : null;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: cultivo.color,
                          child: Icon(cultivo.icono, color: Colors.white),
                        ),
                        title: Text(p.etiqueta.isNotEmpty ? p.etiqueta : cultivo.nombreVisible),
                        subtitle: Text([
                          cultivo.nombreVisible,
                          if (p.variedad.isNotEmpty) p.variedad,
                          if (finca != null) finca.nombre else 'Punto suelto',
                          DateFormat('dd MMM yyyy', 'es_ES').format(DateTime.fromMillisecondsSinceEpoch(p.fechaCreacionMs)),
                        ].join('  ·  ')),
                        onTap: () async {
                          final cambio = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(builder: (_) => PantallaFichaPlanta(plantaId: p.id!)),
                          );
                          if (cambio == true) _cargar();
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
