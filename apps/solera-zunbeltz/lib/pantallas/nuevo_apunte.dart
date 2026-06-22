import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../datos/base_datos.dart';
import '../l10n/app_localizations.dart';
import '../modelos/apunte_economico.dart';
import '../modelos/constantes.dart';
import '../modelos/finca.dart';
import 'widgets/cuerpo_responsivo.dart';

/// Alta de un apunte económico simple (ingreso o gasto).
class NuevoApunte extends StatefulWidget {
  const NuevoApunte({super.key, required this.fincas, this.fincaIdInicial});

  final List<Finca> fincas;
  final int? fincaIdInicial;

  @override
  State<NuevoApunte> createState() => _NuevoApunteState();
}

class _NuevoApunteState extends State<NuevoApunte> {
  final _bd = BaseDatosSoleraZunbeltz();
  final _concepto = TextEditingController();
  final _importe = TextEditingController();
  final _notas = TextEditingController();

  late int? _fincaId;
  String _tipo = tipoApuntePorDefecto;
  DateTime _fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fincaId = widget.fincaIdInicial ??
        (widget.fincas.isNotEmpty ? widget.fincas.first.id : null);
  }

  @override
  void dispose() {
    _concepto.dispose();
    _importe.dispose();
    _notas.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(_fecha.year - 2),
      lastDate: DateTime(_fecha.year + 1),
    );
    if (elegida != null) setState(() => _fecha = elegida);
  }

  Future<void> _guardar() async {
    final textos = AppLocalizations.of(context);
    final euros = double.tryParse(_importe.text.trim().replaceAll(',', '.'));
    if (_fincaId == null || euros == null || euros <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(textos.apuImporteObligatorio)));
      return;
    }
    await _bd.guardarApunte(ApunteEconomico(
      fincaId: _fincaId!,
      tipo: _tipo,
      concepto: _concepto.text.trim(),
      importeCentimos: (euros * 100).round(),
      fechaMs: _fecha.millisecondsSinceEpoch,
      notas: _notas.text.trim(),
      fechaCreacionMs: DateTime.now().millisecondsSinceEpoch,
    ));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(textos.apuGuardado)));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final idioma = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(textos.apuNuevoTitulo)),
      body: CuerpoResponsivo(child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            initialValue: _fincaId,
            decoration: InputDecoration(labelText: textos.puntoFinca),
            items: [
              for (final f in widget.fincas)
                DropdownMenuItem(value: f.id, child: Text(f.nombre)),
            ],
            onChanged: (v) => setState(() => _fincaId = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _tipo,
            decoration: InputDecoration(labelText: textos.apuTipo),
            items: [
              for (final t in tiposApunte)
                DropdownMenuItem(value: t.codigo, child: Text(t.etiqueta(idioma))),
            ],
            onChanged: (v) => setState(() => _tipo = v ?? _tipo),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _concepto,
            decoration: InputDecoration(labelText: textos.apuConcepto),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _importe,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: textos.apuImporte, suffixText: '€'),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(textos.comunFecha),
            subtitle: Text(DateFormat('dd/MM/yyyy', idioma).format(_fecha)),
            trailing: const Icon(Icons.edit_calendar_outlined),
            onTap: _elegirFecha,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notas,
            maxLines: 2,
            decoration: InputDecoration(labelText: textos.apuNotas),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _fincaId == null ? null : _guardar,
            icon: const Icon(Icons.save),
            label: Text(textos.comunGuardar),
          ),
        ],
      )),
    );
  }
}
