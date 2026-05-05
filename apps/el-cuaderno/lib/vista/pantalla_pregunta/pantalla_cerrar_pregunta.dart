import 'package:flutter/material.dart';

import '../../dominio/pregunta_del_nino.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Pantalla de cierre amable de una pregunta del niño. Paralela a
/// [PantallaCerrarMisterio]. El niño escribe lo que ha aprendido; al
/// guardar, [RepositorioLocal.cerrarPreguntaDelNino] persiste la fecha y
/// la respuesta. Sin valoración, sin corrección, sin nota — la
/// respuesta es del niño y no se contrasta con nada (no hay consenso
/// canónico).
class PantallaCerrarPregunta extends StatefulWidget {
  const PantallaCerrarPregunta({
    super.key,
    required this.repositorio,
    required this.pregunta,
  });

  final RepositorioLocal repositorio;
  final PreguntaDelNino pregunta;

  @override
  State<PantallaCerrarPregunta> createState() => _EstadoPantallaCerrarPregunta();
}

class _EstadoPantallaCerrarPregunta extends State<PantallaCerrarPregunta> {
  late final TextEditingController _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController();
    _controlador.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  bool get _puedeGuardar => _controlador.text.trim().isNotEmpty;

  Future<void> _guardar() async {
    if (!_puedeGuardar) return;
    await widget.repositorio.cerrarPreguntaDelNino(
      widget.pregunta.id,
      _controlador.text.trim(),
    );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(textos.preguntaCerrarTitulo)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.pregunta.pregunta,
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano16,
                  peso: TipografiaCuaderno.pesoMedio,
                  altoLinea: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                textos.preguntaCerrarIntro,
                style: TipografiaCuaderno.serif(
                  color: PaletaCuaderno.tintaTenue,
                  tamano: TipografiaCuaderno.tamano13,
                  altoLinea: 1.55,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _controlador,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  maxLength: 1500,
                  buildCounter: (_,
                          {required currentLength,
                          required isFocused,
                          required maxLength}) =>
                      null,
                  style: TipografiaCuaderno.serif(
                    color: esquema.onSurface,
                    tamano: TipografiaCuaderno.tamano14,
                    altoLinea: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: textos.preguntaCerrarPlaceholder,
                    hintStyle: TipografiaCuaderno.serif(
                      color: PaletaCuaderno.tintaTenue,
                      tamano: TipografiaCuaderno.tamano14,
                    ).copyWith(fontStyle: FontStyle.italic),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: esquema.outline),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _puedeGuardar ? _guardar : null,
                  child: Text(textos.preguntaCerrarBoton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
