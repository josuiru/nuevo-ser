import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../servicios/backup_servicio.dart';

class PantallaBackup extends StatefulWidget {
  const PantallaBackup({super.key});
  @override
  State<PantallaBackup> createState() => _PantallaBackupState();
}

class _PantallaBackupState extends State<PantallaBackup> {
  bool _trabajando = false;
  DateTime? _ultimoBackup;
  final _fmt = DateFormat('d MMM yyyy HH:mm', 'es_ES');

  @override
  void initState() { super.initState(); _cargar(); }
  Future<void> _cargar() async { final u = await BackupServicioQuesera.ultimoBackup(); if (mounted) setState(() => _ultimoBackup = u); }

  Future<void> _crear() async {
    setState(() => _trabajando = true);
    try {
      final f = await BackupServicioQuesera.crearZip();
      await _cargar();
      if (mounted) await Share.shareXFiles([XFile(f.path)], subject: 'Backup Solera Quesera');
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creando backup: $e'))); }
    finally { if (mounted) setState(() => _trabajando = false); }
  }

  Future<void> _restaurar() async {
    final ok = await DialogoConfirmacion.mostrar(context, titulo: 'Restaurar desde un backup', mensaje: 'Esta acción sustituye la BD y fotos por las del zip.', textoConfirmar: 'Continuar', icono: Icons.restore);
    if (!ok) return;
    final r = (await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: const ['zip']))?.files.first.path;
    if (r == null) return;
    setState(() => _trabajando = true);
    try { await BackupServicioQuesera.restaurarZip(File(r)); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restaurado correctamente'))); }
    catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error restaurando: $e'))); }
    finally { if (mounted) setState(() => _trabajando = false); }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(SoleraL10n.t('backup'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Icon(Icons.backup, size: 48, color: t.colorScheme.primary),
          const SizedBox(height: 12),
          Text('Copia de seguridad', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_ultimoBackup != null ? '${SoleraL10n.t('ultimo_backup')}: ${_fmt.format(_ultimoBackup!)}' : SoleraL10n.t('nunca_backup'), style: TextStyle(color: Colors.grey)),
        ]))),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: _trabajando ? null : _crear, icon: _trabajando ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.upload), label: Text(_trabajando ? 'Generando…' : SoleraL10n.t('crear_y_compartir_backup'))),
        const SizedBox(height: 12),
        OutlinedButton.icon(onPressed: _trabajando ? null : _restaurar, icon: const Icon(Icons.download), label: Text(SoleraL10n.t('restaurar_desde_zip'))),
      ]),
    );
  }
}
