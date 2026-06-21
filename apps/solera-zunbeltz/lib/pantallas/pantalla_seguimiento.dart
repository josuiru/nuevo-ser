import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../branding.dart';
import '../datos/base_datos.dart';
import '../l10n/app_localizations.dart';
import '../modelos/apunte_economico.dart';
import '../modelos/constantes.dart';
import '../modelos/finca.dart';
import '../modelos/indicadores_seguimiento.dart';
import '../modelos/registro_actividad.dart';
import '../servicios/generador_informe_seguimiento.dart';
import 'nueva_actividad.dart';
import 'nuevo_apunte.dart';

/// Pestaña "Seguimiento": indicadores del testaje (alimentación, pariciones,
/// productos, ingresos, gastos, balance) + registros de actividad y apuntes
/// económicos, con informe PDF. Es el segundo bloque de la Fase 1.
class PantallaSeguimiento extends StatefulWidget {
  const PantallaSeguimiento({super.key});

  @override
  State<PantallaSeguimiento> createState() => _PantallaSeguimientoState();
}

class _PantallaSeguimientoState extends State<PantallaSeguimiento> {
  final _bd = BaseDatosSoleraZunbeltz();
  List<Finca> _fincas = const [];
  List<RegistroActividad> _actividades = const [];
  List<ApunteEconomico> _apuntes = const [];
  IndicadoresSeguimiento _indicadores = const IndicadoresSeguimiento();
  int? _fincaId;
  bool _cargando = true;
  bool _generando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final fincas = await _bd.listarFincas();
      final actividades = await _bd.listarRegistros(fincaId: _fincaId);
      final apuntes = await _bd.listarApuntes(fincaId: _fincaId);
      final indicadores = IndicadoresSeguimiento(
        kgAlimentacion:
            await _bd.sumarCantidadActividad('alimentacion', fincaId: _fincaId),
        pariciones:
            await _bd.sumarCantidadActividad('paricion', fincaId: _fincaId),
        productos:
            await _bd.sumarCantidadActividad('producto', fincaId: _fincaId),
        ingresosCentimos:
            await _bd.sumarImporteEconomico('ingreso', fincaId: _fincaId),
        gastosCentimos:
            await _bd.sumarImporteEconomico('gasto', fincaId: _fincaId),
      );
      if (!mounted) return;
      setState(() {
        _fincas = fincas;
        _actividades = actividades;
        _apuntes = apuntes;
        _indicadores = indicadores;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _anadir() async {
    final textos = AppLocalizations.of(context);
    final opcion = await showModalBottomSheet<int>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.grass_outlined),
              title: Text(textos.segNuevaActividad),
              onTap: () => Navigator.pop(context, 0),
            ),
            ListTile(
              leading: const Icon(Icons.euro_outlined),
              title: Text(textos.segNuevoApunte),
              onTap: () => Navigator.pop(context, 1),
            ),
          ],
        ),
      ),
    );
    if (opcion == null || !mounted) return;
    final ruta = opcion == 0
        ? MaterialPageRoute<bool>(
            builder: (_) =>
                NuevaActividad(fincas: _fincas, fincaIdInicial: _fincaId))
        : MaterialPageRoute<bool>(
            builder: (_) =>
                NuevoApunte(fincas: _fincas, fincaIdInicial: _fincaId));
    final creado = await Navigator.of(context).push(ruta);
    if (creado == true) await _cargar();
  }

  Future<void> _generarInforme() async {
    final textos = AppLocalizations.of(context);
    final idioma = Localizations.localeOf(context).languageCode;
    setState(() => _generando = true);
    try {
      final fichero = await generarInformeSeguimientoPdf(
        textos: textos,
        idioma: idioma,
        indicadores: _indicadores,
        actividades: _actividades,
        apuntes: _apuntes,
      );
      await Printing.sharePdf(
        bytes: await fichero.readAsBytes(),
        filename: fichero.uri.pathSegments.last,
      );
    } finally {
      if (mounted) setState(() => _generando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final idioma = Localizations.localeOf(context).languageCode;
    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: Text(textos.segTitulo)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(textos.segTitulo),
          actions: [
            IconButton(
              tooltip: textos.segInformePdf,
              icon: _generando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.picture_as_pdf_outlined),
              onPressed: _generando ? null : _generarInforme,
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(text: textos.segPestanaActividad),
            Tab(text: textos.segPestanaEconomico),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _anadir,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            _FiltroFinca(
              fincas: _fincas,
              fincaId: _fincaId,
              etiquetaTodas: textos.segTodasFincas,
              onCambio: (v) {
                setState(() => _fincaId = v);
                _cargar();
              },
            ),
            _PanelIndicadores(indicadores: _indicadores, textos: textos),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                children: [
                  _ListaActividad(
                      actividades: _actividades, idioma: idioma, textos: textos),
                  _ListaApuntes(apuntes: _apuntes, idioma: idioma, textos: textos),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltroFinca extends StatelessWidget {
  const _FiltroFinca({
    required this.fincas,
    required this.fincaId,
    required this.etiquetaTodas,
    required this.onCambio,
  });

  final List<Finca> fincas;
  final int? fincaId;
  final String etiquetaTodas;
  final ValueChanged<int?> onCambio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
      child: DropdownButtonFormField<int?>(
        initialValue: fincaId,
        isExpanded: true,
        decoration: const InputDecoration(isDense: true),
        items: [
          DropdownMenuItem(value: null, child: Text(etiquetaTodas)),
          for (final f in fincas)
            DropdownMenuItem(value: f.id, child: Text(f.nombre)),
        ],
        onChanged: onCambio,
      ),
    );
  }
}

class _PanelIndicadores extends StatelessWidget {
  const _PanelIndicadores({required this.indicadores, required this.textos});

  final IndicadoresSeguimiento indicadores;
  final AppLocalizations textos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _Indicador(
              etiqueta: textos.segAlimentacion,
              valor: cantidadBonita(indicadores.kgAlimentacion)),
          _Indicador(
              etiqueta: textos.segPariciones,
              valor: cantidadBonita(indicadores.pariciones)),
          _Indicador(
              etiqueta: textos.segProductos,
              valor: cantidadBonita(indicadores.productos)),
          _Indicador(
              etiqueta: textos.segIngresos,
              valor: '${eurosDesdeCentimos(indicadores.ingresosCentimos)} €'),
          _Indicador(
              etiqueta: textos.segGastos,
              valor: '${eurosDesdeCentimos(indicadores.gastosCentimos)} €'),
          _Indicador(
              etiqueta: textos.segBalance,
              valor: '${eurosDesdeCentimos(indicadores.balanceCentimos)} €',
              resaltado: true),
        ],
      ),
    );
  }
}

class _Indicador extends StatelessWidget {
  const _Indicador({
    required this.etiqueta,
    required this.valor,
    this.resaltado = false,
  });

  final String etiqueta;
  final String valor;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(etiqueta,
              style: Theme.of(context).textTheme.bodySmall, maxLines: 2),
        ],
      ),
    );
  }
}

class _ListaActividad extends StatelessWidget {
  const _ListaActividad({
    required this.actividades,
    required this.idioma,
    required this.textos,
  });

  final List<RegistroActividad> actividades;
  final String idioma;
  final AppLocalizations textos;

  @override
  Widget build(BuildContext context) {
    if (actividades.isEmpty) {
      return Center(child: Text(textos.segSinRegistros));
    }
    final formato = DateFormat('dd/MM/yyyy', idioma);
    return ListView(
      children: [
        for (final a in actividades)
          ListTile(
            leading: const Icon(Icons.grass_outlined),
            title: Text(
                '${buscarOpcion(tiposActividad, a.tipo)?.etiqueta(idioma) ?? a.tipo} · ${cantidadBonita(a.cantidad)} ${unidadActividad(a.tipo, idioma)}'),
            subtitle: Text([
              if (a.lote.isNotEmpty) a.lote,
              formato.format(DateTime.fromMillisecondsSinceEpoch(a.fechaMs)),
            ].join(' · ')),
          ),
      ],
    );
  }
}

class _ListaApuntes extends StatelessWidget {
  const _ListaApuntes({
    required this.apuntes,
    required this.idioma,
    required this.textos,
  });

  final List<ApunteEconomico> apuntes;
  final String idioma;
  final AppLocalizations textos;

  @override
  Widget build(BuildContext context) {
    if (apuntes.isEmpty) {
      return Center(child: Text(textos.segSinRegistros));
    }
    final formato = DateFormat('dd/MM/yyyy', idioma);
    return ListView(
      children: [
        for (final a in apuntes)
          ListTile(
            leading: Icon(
              a.tipo == 'ingreso'
                  ? Icons.south_west
                  : Icons.north_east,
              color: a.tipo == 'ingreso'
                  ? colorEstadoHecha
                  : colorEstadoBloqueada,
            ),
            title: Text(a.concepto.isEmpty
                ? (buscarOpcion(tiposApunte, a.tipo)?.etiqueta(idioma) ?? a.tipo)
                : a.concepto),
            subtitle: Text(
                formato.format(DateTime.fromMillisecondsSinceEpoch(a.fechaMs))),
            trailing: Text('${eurosDesdeCentimos(a.importeCentimos)} €',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
