import 'package:flutter/material.dart';

import '../../datos/cliente_tutor_cuaderno.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Función que la pantalla del Tutor invoca cuando el niño manda una
/// pregunta. Permite tres caminos:
///
/// - **Canned response** (S1, sin red): la implementación devuelve un
///   string fijo y la pantalla lo muestra como turno del Tutor.
/// - **Cliente real** (`ClienteTutorCuaderno.preguntar`): se cablea en
///   `main.dart` cuando hay token JWT. Las excepciones tipadas se
///   manejan abajo.
/// - **Mock en tests**: cualquier función que devuelva un string.
typedef EnviarPreguntaTutor = Future<String> Function(String pregunta);

/// Pantalla del Tutor del Cuaderno. Saludo canónico (doc 04 §3.1)
/// arriba y conversación en burbujas debajo.
///
/// **Sin historial conversacional** entre llamadas (doc 04 §3.2): cada
/// pregunta es independiente; el cliente real no manda turnos previos
/// al servidor. La conversación visible aquí es local — solo decora la
/// vista para el niño.
class PantallaTutor extends StatefulWidget {
  const PantallaTutor({
    super.key,
    required this.repositorio,
    this.enviarPregunta,
  });

  // ignore: unused_element
  final RepositorioLocal repositorio;

  /// Si null, se muestra la canned response del S1 ("El Tutor todavía
  /// no está conectado"). Si llega, la pantalla la usa para enviar al
  /// backend real (`ClienteTutorCuaderno`) o para mockear en tests.
  final EnviarPreguntaTutor? enviarPregunta;

  @override
  State<PantallaTutor> createState() => _EstadoPantallaTutor();
}

class _EstadoPantallaTutor extends State<PantallaTutor> {
  late final TextEditingController _controlador;
  late final ScrollController _controladorScroll;
  final List<_Turno> _conversacion = [];
  bool _esperando = false;

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController();
    _controladorScroll = ScrollController();
  }

  @override
  void dispose() {
    _controlador.dispose();
    _controladorScroll.dispose();
    super.dispose();
  }

  /// Mueve el ListView al fondo en el siguiente frame, después de que
  /// el `setState` haya pintado el turno o la burbuja "pensando" recién
  /// añadidos. Si el controller aún no tiene clientes (la pestaña Tutor
  /// no se ha llegado a montar este frame), salta sin error.
  void _scrollAlFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controladorScroll.hasClients) return;
      _controladorScroll.animateTo(
        _controladorScroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
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
              controller: _controladorScroll,
              itemCount: _conversacion.length + (_esperando ? 1 : 0),
              itemBuilder: (context, indice) {
                if (_esperando && indice == _conversacion.length) {
                  return const _BurbujaPensando();
                }
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
                  enabled: !_esperando,
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
                onPressed: _esperando ? null : () => _enviar(textos),
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

  Future<void> _enviar(TextosApp textos) async {
    final pregunta = _controlador.text.trim();
    if (pregunta.isEmpty) return;
    setState(() {
      _conversacion.add(_Turno.deNino(pregunta));
      _controlador.clear();
    });
    _scrollAlFinal();
    final canalPregunta = widget.enviarPregunta;
    if (canalPregunta == null) {
      // Caso "sin token vinculado": cliente pasa null como `enviarPregunta`.
      // No es un error de red — el adulto no ha vinculado cuenta todavía.
      setState(() {
        _conversacion.add(_Turno.deTutor(textos.tutorRespuestaCanned));
      });
      _scrollAlFinal();
      return;
    }
    setState(() => _esperando = true);
    _scrollAlFinal();
    String respuesta;
    try {
      respuesta = await canalPregunta(pregunta);
    } on CuotaTutorAgotada catch (excepcion) {
      respuesta = excepcion.mensaje;
    } catch (_) {
      // Hay token vinculado pero la llamada falló (red caída, 5xx, JSON
      // malformado, timeout). No equivale a "no está conectado" — la
      // cuenta sí lo está, ahora mismo no llega la respuesta. Voz adulta
      // amable que nombra la situación sin culpar al niño.
      respuesta = textos.tutorErrorRed;
    }
    if (!mounted) return;
    setState(() {
      _conversacion.add(_Turno.deTutor(respuesta));
      _esperando = false;
    });
    _scrollAlFinal();
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

/// Burbuja con tres puntos discretos mientras la respuesta del Tutor
/// está en vuelo (uno-roto usa el mismo patrón). Sin animación
/// elaborada — un punto fijo de "pensando…" en serif tenue.
class _BurbujaPensando extends StatelessWidget {
  const _BurbujaPensando();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          '· · ·',
          style: TipografiaCuaderno.serif(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano14,
          ),
        ),
      ),
    );
  }
}
