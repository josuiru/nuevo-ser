import 'package:flutter/material.dart';

import '../datos/base_datos.dart';
import '../modelos/tratamiento.dart';

/// Formulario para registrar un tratamiento fitosanitario sobre una
/// parcela. Sin catálogo curado en F1-A3 — sustancia y plaga son
/// text input libre. F1-A6 los conecta con el catálogo CSV.
class PantallaNuevoTratamiento extends StatefulWidget {
  final int parcelaId;

  const PantallaNuevoTratamiento({super.key, required this.parcelaId});

  @override
  State<PantallaNuevoTratamiento> createState() =>
      _PantallaNuevoTratamientoState();
}

class _PantallaNuevoTratamientoState extends State<PantallaNuevoTratamiento> {
  final _formKey = GlobalKey<FormState>();
  final _productoCtrl = TextEditingController();
  final _sustanciaCtrl = TextEditingController();
  final _dosisCtrl = TextEditingController();
  final _plagaCtrl = TextEditingController();
  final _aplicadorCtrl = TextEditingController();
  final _carnetCtrl = TextEditingController();
  final _observacionesCtrl = TextEditingController();
  bool _guardando = false;

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    await BaseDatosSoleraAceitera().insertarTratamiento(Tratamiento(
      parcelaId: widget.parcelaId,
      fechaMs: DateTime.now().millisecondsSinceEpoch,
      productoComercialReferencia: _productoCtrl.text.trim(),
      sustanciaActivaId: _sustanciaCtrl.text.trim(),
      dosisLitrosPorHa:
          double.tryParse(_dosisCtrl.text.replaceAll(',', '.')) ?? 0,
      plagaObjetivoId: _plagaCtrl.text.trim(),
      aplicadorNombre: _aplicadorCtrl.text.trim(),
      carnetAplicadorNumero: _carnetCtrl.text.trim(),
      observaciones: _observacionesCtrl.text.trim(),
    ));
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo tratamiento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _sustanciaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Sustancia activa',
                  hintText: 'deltametrina, dimetoato, cobre…',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _productoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Producto comercial (referencia)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dosisCtrl,
                decoration: const InputDecoration(
                  labelText: 'Dosis (L/ha)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _plagaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Plaga objetivo',
                  hintText: 'mosca, prays, repilo…',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _aplicadorCtrl,
                decoration: const InputDecoration(
                  labelText: 'Aplicador (nombre)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _carnetCtrl,
                decoration: const InputDecoration(
                  labelText: 'Carnet aplicador (número)',
                  hintText: 'Obligatorio para PAC',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Obligatorio para que el cuaderno PAC sea válido'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _observacionesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Guardar tratamiento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
