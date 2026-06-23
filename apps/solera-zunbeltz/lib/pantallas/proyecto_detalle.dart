import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../branding.dart';
import '../datos/base_datos.dart';
import '../l10n/app_localizations.dart';
import '../modelos/apunte_economico.dart';
import '../modelos/constantes.dart';
import '../modelos/indicadores_seguimiento.dart';
import '../modelos/proyecto_test.dart';
import '../modelos/registro_actividad.dart';
import '../modelos/registro_comercializacion.dart';
import '../modelos/rentabilidad_proyecto.dart';
import '../modelos/validacion_producto.dart';
import '../servicios/generador_informe_proyecto.dart';
import 'nueva_actividad.dart';
import 'nueva_comercializacion.dart';
import 'nueva_validacion.dart';
import 'nuevo_apunte.dart';

/// Detalle de un proyecto de test: análisis de rentabilidad + producción,
/// comercialización, validación de producto y económico, con informe PDF.
class ProyectoDetalle extends StatefulWidget {
  const ProyectoDetalle({super.key, required this.proyecto});

  final ProyectoTest proyecto;

  @override
  State<ProyectoDetalle> createState() => _ProyectoDetalleState();
}

class _ProyectoDetalleState extends State<ProyectoDetalle> {
  final _bd = BaseDatosSoleraZunbeltz();
  RentabilidadProyecto _rent = const RentabilidadProyecto();
  List<RegistroComercializacion> _ventas = const [];
  List<RegistroActividad> _produccion = const [];
  List<ValidacionProducto> _validaciones = const [];
  List<ApunteEconomico> _apuntes = const [];
  bool _cargando = true;
  bool _generando = false;

  int get _proyectoId => widget.proyecto.id!;
  int get _fincaId => widget.proyecto.fincaId ?? 0;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final rent = await _bd.rentabilidadProyecto(_proyectoId);
      final ventas = await _bd.listarComercializacion(proyectoId: _proyectoId);
      final produccion = await _bd.listarRegistros(proyectoId: _proyectoId);
      final validaciones = await _bd.listarValidaciones(proyectoId: _proyectoId);
      final apuntes = await _bd.listarApuntes(proyectoId: _proyectoId);
      if (!mounted) return;
      setState(() {
        _rent = rent;
        _ventas = ventas;
        _produccion = produccion;
        _validaciones = validaciones;
        _apuntes = apuntes;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  int? _diasPeriodo() {
    final inicio = widget.proyecto.fechaInicioMs;
    if (inicio == null) return null;
    final fin =
        widget.proyecto.fechaFinMs ?? DateTime.now().millisecondsSinceEpoch;
    final dias = ((fin - inicio) / 86400000).round();
    return dias > 0 ? dias : null;
  }

  Future<void> _abrir(Widget pantalla) async {
    final creado = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => pantalla));
    if (creado == true) await _cargar();
  }

  Future<void> _anadir(int pestana) async {
    switch (pestana) {
      case 0:
        await _abrir(NuevaActividad(proyectoId: _proyectoId, fincaId: _fincaId));
      case 1:
        await _abrir(NuevaComercializacion(proyectoId: _proyectoId));
      case 2:
        await _abrir(NuevaValidacion(proyectoId: _proyectoId));
      case 3:
        await _abrir(NuevoApunte(proyectoId: _proyectoId, fincaId: _fincaId));
    }
  }

  Future<void> _borrar() async {
    final textos = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(textos.proyectoBorrar),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(textos.comunCancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(textos.comunBorrar)),
        ],
      ),
    );
    if (ok != true) return;
    await _bd.borrarProyecto(_proyectoId);
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _informe() async {
    final textos = AppLocalizations.of(context);
    final idioma = Localizations.localeOf(context).languageCode;
    setState(() => _generando = true);
    try {
      final fichero = await generarInformeProyectoPdf(
        textos: textos,
        idioma: idioma,
        proyecto: widget.proyecto,
        rentabilidad: _rent,
        comercializacion: _ventas,
        validaciones: _validaciones,
        actividades: _produccion,
      );
      await Printing.sharePdf(
          bytes: await fichero.readAsBytes(),
          filename: fichero.uri.pathSegments.last);
    } finally {
      if (mounted) setState(() => _generando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final idioma = Localizations.localeOf(context).languageCode;
    final p = widget.proyecto;
    final subt = [p.persona, p.actividad].where((s) => s.isNotEmpty).join(' · ');
    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: Text(p.nombre)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(p.nombre),
          actions: [
            IconButton(
              tooltip: textos.detInformePdf,
              icon: _generando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.picture_as_pdf_outlined),
              onPressed: _generando ? null : _informe,
            ),
            IconButton(
              tooltip: textos.proyectoBorrar,
              icon: const Icon(Icons.delete_outline),
              onPressed: _borrar,
            ),
          ],
          bottom: TabBar(isScrollable: true, tabs: [
            Tab(text: textos.detProduccion),
            Tab(text: textos.detComercial),
            Tab(text: textos.detValidacion),
            Tab(text: textos.detEconomico),
          ]),
        ),
        floatingActionButton: Builder(
          builder: (ctx) => FloatingActionButton(
            onPressed: () => _anadir(DefaultTabController.of(ctx).index),
            child: const Icon(Icons.add),
          ),
        ),
        body: Column(
          children: [
            if (subt.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(subt,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
            _PanelRentabilidad(
                rent: _rent, dias: _diasPeriodo(), textos: textos),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                children: [
                  _ListaProduccion(items: _produccion, idioma: idioma, textos: textos),
                  _ListaVentas(items: _ventas, idioma: idioma, textos: textos),
                  _ListaValidacion(items: _validaciones, idioma: idioma, textos: textos),
                  _ListaApuntes(items: _apuntes, idioma: idioma, textos: textos),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelRentabilidad extends StatelessWidget {
  const _PanelRentabilidad(
      {required this.rent, required this.dias, required this.textos});

  final RentabilidadProyecto rent;
  final int? dias;
  final AppLocalizations textos;

  @override
  Widget build(BuildContext context) {
    final proyeccion =
        dias == null ? null : rent.balanceAnualExtrapoladoCentimos(dias!);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _Cifra(textos.rentVentas,
              '${eurosDesdeCentimos(rent.ingresosComercializacionCentimos)} €'),
          _Cifra(textos.rentGastos,
              '${eurosDesdeCentimos(rent.gastosCentimos)} €'),
          _Cifra(textos.rentBalance,
              '${eurosDesdeCentimos(rent.balanceCentimos)} €',
              resaltado: true),
          _Cifra(textos.rentMargen,
              '${rent.margenPorcentaje.toStringAsFixed(0)} %'),
          if (proyeccion != null)
            _Cifra(textos.rentProyeccion,
                '${eurosDesdeCentimos(proyeccion)} €'),
        ],
      ),
    );
  }
}

class _Cifra extends StatelessWidget {
  const _Cifra(this.etiqueta, this.valor, {this.resaltado = false});
  final String etiqueta;
  final String valor;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: resaltado ? colorMusgoZunbeltz.withValues(alpha: 0.30) : null,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(valor,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(etiqueta,
              style: Theme.of(context).textTheme.bodySmall, maxLines: 2),
        ],
      ),
    );
  }
}

class _ListaProduccion extends StatelessWidget {
  const _ListaProduccion(
      {required this.items, required this.idioma, required this.textos});
  final List<RegistroActividad> items;
  final String idioma;
  final AppLocalizations textos;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Center(child: Text(textos.detSinDatos));
    final f = DateFormat('dd/MM/yyyy', idioma);
    return ListView(children: [
      for (final a in items)
        ListTile(
          leading: const Icon(Icons.grass_outlined),
          title: Text(
              '${buscarOpcion(tiposActividad, a.tipo)?.etiqueta(idioma) ?? a.tipo} · ${cantidadBonita(a.cantidad)} ${unidadActividad(a.tipo, idioma)}'),
          subtitle: Text(f.format(DateTime.fromMillisecondsSinceEpoch(a.fechaMs))),
        ),
    ]);
  }
}

class _ListaVentas extends StatelessWidget {
  const _ListaVentas(
      {required this.items, required this.idioma, required this.textos});
  final List<RegistroComercializacion> items;
  final String idioma;
  final AppLocalizations textos;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Center(child: Text(textos.detSinDatos));
    final f = DateFormat('dd/MM/yyyy', idioma);
    return ListView(children: [
      for (final c in items)
        ListTile(
          leading: const Icon(Icons.storefront_outlined),
          title: Text(c.producto.isEmpty
              ? (buscarOpcion(canalesComercializacion, c.canal)?.etiqueta(idioma) ?? c.canal)
              : c.producto),
          subtitle: Text(
              '${buscarOpcion(canalesComercializacion, c.canal)?.etiqueta(idioma) ?? c.canal} · ${cantidadBonita(c.cantidad)} ${c.unidad} · ${f.format(DateTime.fromMillisecondsSinceEpoch(c.fechaMs))}'),
          trailing: Text('${eurosDesdeCentimos(c.ingresoCentimos)} €',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
    ]);
  }
}

class _ListaValidacion extends StatelessWidget {
  const _ListaValidacion(
      {required this.items, required this.idioma, required this.textos});
  final List<ValidacionProducto> items;
  final String idioma;
  final AppLocalizations textos;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Center(child: Text(textos.detSinDatos));
    final f = DateFormat('dd/MM/yyyy', idioma);
    return ListView(children: [
      for (final v in items)
        ListTile(
          leading: const Icon(Icons.verified_outlined),
          title: Text(v.descripcion.isEmpty
              ? (buscarOpcion(resultadosValidacion, v.resultado)?.etiqueta(idioma) ?? v.resultado)
              : v.descripcion),
          subtitle: Text([
            buscarOpcion(resultadosValidacion, v.resultado)?.etiqueta(idioma) ?? v.resultado,
            if (v.valoracion > 0) '${v.valoracion}/5',
            f.format(DateTime.fromMillisecondsSinceEpoch(v.fechaMs)),
          ].join(' · ')),
        ),
    ]);
  }
}

class _ListaApuntes extends StatelessWidget {
  const _ListaApuntes(
      {required this.items, required this.idioma, required this.textos});
  final List<ApunteEconomico> items;
  final String idioma;
  final AppLocalizations textos;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Center(child: Text(textos.detSinDatos));
    final f = DateFormat('dd/MM/yyyy', idioma);
    return ListView(children: [
      for (final a in items)
        ListTile(
          leading: Icon(a.tipo == 'ingreso' ? Icons.south_west : Icons.north_east,
              color: a.tipo == 'ingreso' ? colorEstadoHecha : colorEstadoBloqueada),
          title: Text(a.concepto.isEmpty
              ? (buscarOpcion(tiposApunte, a.tipo)?.etiqueta(idioma) ?? a.tipo)
              : a.concepto),
          subtitle: Text(f.format(DateTime.fromMillisecondsSinceEpoch(a.fechaMs))),
          trailing: Text('${eurosDesdeCentimos(a.importeCentimos)} €',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
    ]);
  }
}
