import 'package:flutter/material.dart';

import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Pantalla del Tutor — versión Sprint 1, **canned response**. La
/// conexión real con Claude API en modo Zero Data Retention entra en
/// Sprint 4 con prompts versionados, lista negra de patrones y cuota
/// por niño.
///
/// El saludo canónico (doc 04 §3.1, doc 13 §6.2) es idéntico siempre:
/// *"Soy el Tutor del Cuaderno. Pregúntame lo que necesites."*. La
/// respuesta única en S1 documenta honestamente al niño que el Tutor
/// no está conectado todavía — coherente con el principio del doc 04
/// §3.2 *"No inventa hechos biológicos. Si no sabe, dice 'No lo
/// sé'"*.
///
/// El parámetro `repositorio` no se usa hoy pero se acepta por
/// constructor para que la pantalla esté preparada para Sprint 4
/// (cuando el Tutor podrá adjuntar una observación del cuaderno como
/// contexto).
class PantallaTutor extends StatefulWidget {
  const PantallaTutor({super.key, required this.repositorio});

  // ignore: unused_element
  final RepositorioLocal repositorio;

  @override
  State<PantallaTutor> createState() => _EstadoPantallaTutor();
}

class _EstadoPantallaTutor extends State<PantallaTutor> {
  late final TextEditingController _controlador;
  final List<_Turno> _conversacion = [];

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              textos.tutorSaludoCanonico,
              style: TipografiaCuaderno.serif(
                color: esquema.onSurface,
                tamano: TipografiaCuaderno.tamano14,
                altoLinea: 1.5,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _conversacion.length,
              itemBuilder: (context, indice) {
                final turno = _conversacion[indice];
                return _BurbujaTurno(turno: turno);
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controlador,
                  decoration: InputDecoration(
                    hintText: textos.tutorPlaceholderInput,
                    hintStyle: TipografiaCuaderno.serif(
                      color: PaletaCuaderno.tintaTenue,
                      tamano: TipografiaCuaderno.tamano13,
                    ).copyWith(fontStyle: FontStyle.italic),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: esquema.outline),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  style: TipografiaCuaderno.serif(
                    color: esquema.onSurface,
                    tamano: TipografiaCuaderno.tamano13,
                  ),
                  onSubmitted: (_) => _enviar(textos),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => _enviar(textos),
                style: FilledButton.styleFrom(
                  backgroundColor: esquema.primary,
                  foregroundColor: esquema.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(textos.tutorBotonEnviar),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _enviar(TextosApp textos) {
    final pregunta = _controlador.text.trim();
    if (pregunta.isEmpty) return;
    setState(() {
      _conversacion
        ..add(_Turno.deNino(pregunta))
        ..add(_Turno.deTutor(textos.tutorRespuestaCanned));
      _controlador.clear();
    });
  }
}

class _Turno {
  const _Turno({required this.texto, required this.esDelNino});

  factory _Turno.deNino(String texto) =>
      _Turno(texto: texto, esDelNino: true);
  factory _Turno.deTutor(String texto) =>
      _Turno(texto: texto, esDelNino: false);

  final String texto;
  final bool esDelNino;
}

class _BurbujaTurno extends StatelessWidget {
  const _BurbujaTurno({required this.turno});

  final _Turno turno;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final esDelNino = turno.esDelNino;

    return Align(
      alignment: esDelNino ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: esDelNino
            ? BoxDecoration(
                color: esquema.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        child: Text(
          turno.texto,
          style: TipografiaCuaderno.serif(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano14,
            altoLinea: 1.5,
          ),
        ),
      ),
    );
  }
}
