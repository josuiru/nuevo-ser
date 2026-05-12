import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:printing/printing.dart';
import '../datos/base_datos.dart';
import '../servicios/generador_libro_trazabilidad.dart';
import 'pantalla_perfil_do.dart';
import 'pantalla_registro_appcc.dart';
import 'pantalla_simulacion_trazabilidad.dart';

class PantallaTrazabilidad extends StatefulWidget {
  const PantallaTrazabilidad({super.key});
  @override
  State<PantallaTrazabilidad> createState() => _PantallaTrazabilidadState();
}

class _PantallaTrazabilidadState extends State<PantallaTrazabilidad> {
  final _bd = BaseDatosSoleraQuesera.instancia;
  final _gen = GeneradorLibroTrazabilidad();
  final _f = DateFormat('d MMM yyyy', 'es_ES');
  DateTime _desde = DateTime.now().subtract(const Duration(days: 90)), _hasta = DateTime.now();
  bool _genPdf = false;

  Future<void> _generarPdf() async {
    setState(() => _genPdf = true);
    try {
      final doc = await _gen.generar(bd: _bd, desdeMs: _desde.millisecondsSinceEpoch, hastaMs: _hasta.millisecondsSinceEpoch);
      await Printing.sharePdf(bytes: await doc.save(), filename: 'libro_trazabilidad.pdf');
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'))); }
    finally { if (mounted) setState(() => _genPdf = false); }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(SoleraL10n.t('documentacion'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.description, color: t.colorScheme.primary), const SizedBox(width: 8), Text('Libro de Trazabilidad APPCC', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))]),
          const Text('PDF inspeccionable con 7 secciones.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: OutlinedButton(onPressed: () async { final p = await showDatePicker(context: context, initialDate: _desde, firstDate: DateTime(2020), lastDate: DateTime.now()); if (p != null) setState(() => _desde = p); }, child: Text('Desde: ${_f.format(_desde)}'))), const SizedBox(width: 12), Expanded(child: OutlinedButton(onPressed: () async { final p = await showDatePicker(context: context, initialDate: _hasta, firstDate: DateTime(2020), lastDate: DateTime.now()); if (p != null) setState(() => _hasta = p); }, child: Text('Hasta: ${_f.format(_hasta)}')))]),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _genPdf ? null : _generarPdf, icon: _genPdf ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.picture_as_pdf), label: Text(_genPdf ? 'Generando…' : 'Generar y compartir PDF')),
        ]))),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.analytics, color: t.colorScheme.primary), const SizedBox(width: 8), Text('Ejercicio de simulación', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))]),
          const Text('Simula una inspección real: selecciona un lote al azar y traza la cadena completa.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaSimulacionTrazabilidad())), icon: const Icon(Icons.play_arrow), label: const Text('Iniciar simulación')),
        ]))),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.assignment, color: t.colorScheme.primary), const SizedBox(width: 8), Text('Registros APPCC', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))]),
          const Text('Temperatura, limpieza, plagas, analíticas y formación.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaRegistroAppcc())), icon: const Icon(Icons.app_registration), label: const Text('Gestionar registros APPCC')),
        ]))),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.verified, color: t.colorScheme.primary), const SizedBox(width: 8), Text('Perfil DO', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))]),
          const Text('Activa las DO de tu quesería para validar requisitos.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaPerfilDo())), icon: const Icon(Icons.verified), label: const Text('Configurar DOs activas')),
        ]))),
      ]),
    );
  }
}
