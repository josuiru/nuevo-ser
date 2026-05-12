import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:share_plus/share_plus.dart';

import '../servicios/backup_servicio.dart';

/// Pantalla de backup/restore. Operaciones lentas (segundos) y
/// destructivas — UI explícita con confirmaciones para que el usuario
/// nunca pierda datos por accidente.
class PantallaBackup extends StatefulWidget {
  PantallaBackup({super.key});

  @override
  State<PantallaBackup> createState() => _PantallaBackupState();
}

class _PantallaBackupState extends State<PantallaBackup> {
  bool _trabajando = false;
  DateTime? _ultimoBackup;

  @override
  void initState() {
    super.initState();
    _cargarUltimoBackup();
  }

  Future<void> _cargarUltimoBackup() async {
    final u = await BackupServicio.ultimoBackup();
    if (mounted) setState(() => _ultimoBackup = u);
  }

  Future<void> _crearYCompartir() async {
    setState(() => _trabajando = true);
    try {
      final fichero = await BackupServicio.crearZip();
      await _cargarUltimoBackup();
      if (!mounted) return;
      await Share.shareXFiles([XFile(fichero.path)], subject: 'Backup Solera');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(SoleraL10n.t('error_creando_backup:_$e'))));
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _restaurar() async {
        final aviso = await DialogoConfirmacion.mostrar(
      context,
      titulo: 'Restaurar desde un backup',
      mensaje: 'Esta acción sustituye la base de datos y las fotos por las del zip elegido.\n\n'
          'Antes de hacerlo, se creará automáticamente un backup del estado actual por seguridad.',
      textoConfirmar: 'Continuar',
      textoCancelar: 'Cancelar',
      icono: Icons.restore,
    );
    if (aviso != true) return;
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
    );
    if (resultado == null || resultado.files.isEmpty) return;
    final ruta = resultado.files.first.path;
    if (ruta == null) return;
    setState(() => _trabajando = true);
    try {
      final preRestore = await BackupServicio.restaurarZip(File(ruta));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 8),
          content: Text('Restaurado. Se guardó tu estado anterior en ${preRestore.path.split('/').last}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 8),
          content: Text('Error restaurando: $e\nTu BD original NO se ha tocado.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ultimo = _ultimoBackup;
    final hace = ultimo == null ? null : DateTime.now().difference(ultimo);
    return Scaffold(
      appBar: AppBar(title: Text('Backup y restauración')),
      body: AbsorbPointer(
        absorbing: _trabajando,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      ultimo == null ? Icons.warning_amber : (hace != null && hace.inDays > 7 ? Icons.error_outline : Icons.check_circle),
                      color: ultimo == null ? Colors.orange : (hace != null && hace.inDays > 7 ? Colors.red : Colors.green),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Último backup', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            ultimo == null
                                ? 'Nunca — recomendado hacer uno antes de salir al campo.'
                                : DateFormat("d 'de' MMMM 'de' yyyy 'a las' HH:mm", 'es_ES').format(ultimo),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Text('Crear backup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text(
              'Empaqueta la base de datos y todas las fotos en un zip que puedes compartir por WhatsApp, Drive, correo o copiar al PC. Si reinstalas la app o cambias de móvil podrás restaurar desde aquí.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            SizedBox(height: 12),
            FilledButton.icon(
              icon: Icon(Icons.archive),
              onPressed: _trabajando ? null : _crearYCompartir,
              label: Text(_trabajando ? 'Empaquetando…' : 'Crear backup y compartir'),
            ),
            Divider(height: 32),
            Text('Restaurar desde backup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text(
              'Sustituye la base de datos y fotos actuales por las del zip. Antes se hace un backup del estado actual por si quieres deshacer.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            SizedBox(height: 12),
            OutlinedButton.icon(
              icon: Icon(Icons.restore),
              onPressed: _trabajando ? null : _restaurar,
              label: Text('Restaurar zip'),
            ),
          ],
        ),
      ),
    );
  }
}
