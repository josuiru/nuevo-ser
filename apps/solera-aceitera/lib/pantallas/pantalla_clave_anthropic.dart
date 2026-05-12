import 'package:flutter/material.dart';

import '../estado/clave_anthropic.dart';

/// Editor de la clave Anthropic del usuario. **Solo local** — la
/// clave se guarda en SharedPreferences y nunca sale del dispositivo
/// a ningún servidor de Solera.
class PantallaClaveAnthropic extends StatefulWidget {
  const PantallaClaveAnthropic({super.key});

  @override
  State<PantallaClaveAnthropic> createState() => _PantallaClaveAnthropicState();
}

class _PantallaClaveAnthropicState extends State<PantallaClaveAnthropic> {
  final _claveCtrl = TextEditingController();
  final _estado = ClaveAnthropic();
  bool _cargando = true;
  bool _guardando = false;
  bool _claveVisible = false;
  bool _claveYaExiste = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final clave = await _estado.cargar();
    if (!mounted) return;
    setState(() {
      if (clave != null) {
        _claveCtrl.text = clave;
        _claveYaExiste = true;
      }
      _cargando = false;
    });
  }

  Future<void> _guardar() async {
    final clave = _claveCtrl.text.trim();
    if (clave.length < 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('La clave Anthropic tiene al menos 16 caracteres.')),
      );
      return;
    }
    setState(() => _guardando = true);
    await _estado.guardar(clave);
    if (!mounted) return;
    setState(() {
      _claveYaExiste = true;
      _guardando = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clave guardada localmente.')),
    );
  }

  Future<void> _borrar() async {
    await _estado.borrar();
    if (!mounted) return;
    setState(() {
      _claveCtrl.text = '';
      _claveYaExiste = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clave borrada.')),
    );
  }

  @override
  void dispose() {
    _claveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Clave Anthropic (IA)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text(
              'La identificación visual de plagas y variedades usa la API '
              'de Anthropic Claude. Pega aquí tu clave personal — se guarda '
              'sólo en este dispositivo y nunca sale a un servidor de Solera.\n\n'
              'Las llamadas se facturan en tu cuenta de Anthropic; cada '
              'consulta consume unos cuantos miles de tokens (típicamente '
              'unas décimas de céntimo con Claude Haiku 4.5).',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _claveCtrl,
            obscureText: !_claveVisible,
            decoration: InputDecoration(
              labelText: 'Clave Anthropic',
              hintText: 'sk-ant-…',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_claveVisible
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () =>
                    setState(() => _claveVisible = !_claveVisible),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _guardando ? null : _guardar,
            icon: _guardando
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save),
            label: const Text('Guardar clave'),
          ),
          if (_claveYaExiste) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _borrar,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Borrar clave del dispositivo'),
            ),
          ],
        ],
      ),
    );
  }
}
