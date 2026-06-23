import 'package:flutter/material.dart';

import '../datos/base_datos.dart';
import '../l10n/app_localizations.dart';
import '../modelos/finca.dart';
import '../modelos/proyecto_test.dart';
import 'nuevo_proyecto.dart';
import 'proyecto_detalle.dart';

/// Pestaña "Proyectos": el proceso de test por persona tester. Lista de
/// proyectos; al entrar en uno, su panel de rentabilidad, producción,
/// comercialización, validación de producto y económico.
class PantallaProyectos extends StatefulWidget {
  const PantallaProyectos({super.key});

  @override
  State<PantallaProyectos> createState() => _PantallaProyectosState();
}

class _PantallaProyectosState extends State<PantallaProyectos> {
  final _bd = BaseDatosSoleraZunbeltz();
  List<ProyectoTest> _proyectos = const [];
  List<Finca> _fincas = const [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    var proyectos = <ProyectoTest>[];
    var fincas = <Finca>[];
    try {
      proyectos = await _bd.listarProyectos();
      fincas = await _bd.listarFincas();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _proyectos = proyectos;
      _fincas = fincas;
      _cargando = false;
    });
  }

  Future<void> _nuevo() async {
    final creado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => NuevoProyecto(fincas: _fincas)),
    );
    if (creado == true) await _cargar();
  }

  Future<void> _abrir(ProyectoTest p) async {
    final cambiado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ProyectoDetalle(proyecto: p)),
    );
    if (cambiado == true) await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(textos.proyectosTitulo)),
      floatingActionButton: FloatingActionButton(
        onPressed: _nuevo,
        child: const Icon(Icons.add),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _proyectos.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(textos.proyectosVacio,
                        textAlign: TextAlign.center),
                  ),
                )
              : ListView(
                  children: [
                    for (final p in _proyectos)
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        child: ListTile(
                          leading: const CircleAvatar(
                              child: Icon(Icons.science_outlined)),
                          title: Text(p.nombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text([p.persona, p.actividad]
                              .where((s) => s.isNotEmpty)
                              .join(' · ')),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _abrir(p),
                        ),
                      ),
                  ],
                ),
    );
  }
}
