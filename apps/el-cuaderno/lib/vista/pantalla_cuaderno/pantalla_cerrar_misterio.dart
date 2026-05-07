import 'package:flutter/material.dart';

import '../../dominio/misterio.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// El niño declara *"ya tengo mi respuesta para este Misterio"*. Texto
/// libre, sin formato — el sistema no juzga la respuesta, sólo la
/// guarda. Cierra el ciclo del niño con la pregunta; el [Misterio.estado]
/// canónico (consenso/hipótesis activa) no se mueve, porque ese refleja
/// el consenso científico, no lo que el niño ha aprendido.
///
/// **No es un test, no es una autoevaluación**. La biblia §2.6 dice
/// "maestría observable, no declarada" — aquí el niño no se asigna un
/// nivel ni recibe corrección. Sólo escribe lo que ha aprendido y el
/// Misterio pasa a la sección "ya cerrados" del cuaderno.
class PantallaCerrarMisterio extends StatefulWidget {
  const PantallaCerrarMisterio({
    super.key,
    required this.repositorio,
    required this.misterio,
  });

  final RepositorioLocal repositorio;
  final Misterio misterio;

  @override
  State<PantallaCerrarMisterio> createState() => _EstadoPantallaCerrarMisterio();
}

class _EstadoPantallaCerrarMisterio extends State<PantallaCerrarMisterio> {
  final TextEditingController _controladorRespuesta = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _controladorRespuesta.dispose();
    super.dispose();
  }

  bool get _puedeGuardar =>
      _controladorRespuesta.text.trim().isNotEmpty && !_guardando;

  Future<void> _guardar() async {
    final respuesta = _controladorRespuesta.text.trim();
    if (respuesta.isEmpty) return;
    final textos = TextosApp.of(context);
    setState(() => _guardando = true);
    try {
      await widget.repositorio
          .cerrarMisterioParaNino(widget.misterio.id, respuesta);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(textos.misterioCerrarErrorGuardar),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(textos.misterioCerrarTitulo)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: esquema.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: esquema.outline, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textos.misterioCerrarCabeceraMisterio,
                    style: TipografiaCuaderno.sans(
                      color: esquema.tertiary,
                      tamano: TipografiaCuaderno.tamano12,
                      peso: TipografiaCuaderno.pesoMedio,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.misterio.preguntaEn(textos.localeName),
                    style: TipografiaCuaderno.serif(
                      color: esquema.onSurface,
                      tamano: TipografiaCuaderno.tamano14,
                      altoLinea: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              textos.misterioCerrarIntro,
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.tintaTenue,
                tamano: TipografiaCuaderno.tamano13,
                altoLinea: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controladorRespuesta,
              maxLines: 8,
              minLines: 4,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: textos.misterioCerrarPlaceholder,
              ),
              style: TipografiaCuaderno.serif(
                color: esquema.onSurface,
                tamano: TipografiaCuaderno.tamano14,
                altoLinea: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _puedeGuardar ? _guardar : null,
                child: Text(
                  _guardando
                      ? textos.misterioCerrarBotonGuardando
                      : textos.misterioCerrarBotonGuardar,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
