import 'package:flutter/material.dart';

import '../dominio/tutor/filtro_seguridad.dart';
import '../dominio/tutor/servicio_tutor.dart';
import '../nucleo/paleta.dart';

/// Pantalla del Tutor IA. Una sola conversación por sesión, ligada a
/// una habilidad concreta. El niño escribe lo que no entiende y recibe
/// una explicación corta.
///
/// Diseño deliberadamente sobrio (doc 01 §3): ni pomposo ni con muchos
/// botones. Solo lo necesario.
/// - Cabecera con el nombre de la habilidad.
/// - Historial de la conversación (niño y tutor) en una columna.
/// - Campo de texto y botón "preguntar".
/// - Si hay error o rechazo, se muestra como una burbuja del tutor con
///   un tono más tenue.
class PantallaTutor extends StatefulWidget {
  final ServicioTutor servicio;
  final String idHabilidad;
  final String nombreHabilidad;

  /// Texto opcional que se envía como contexto al servidor (qué ve el
  /// niño en pantalla). No se muestra al niño.
  final String? contextoFragmento;

  const PantallaTutor({
    super.key,
    required this.servicio,
    required this.idHabilidad,
    required this.nombreHabilidad,
    this.contextoFragmento,
  });

  @override
  State<PantallaTutor> createState() => _EstadoPantallaTutor();
}

class _EstadoPantallaTutor extends State<PantallaTutor> {
  final TextEditingController _controlador = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_MensajeConversacion> _mensajes = [];
  bool _esperandoRespuesta = false;

  @override
  void initState() {
    super.initState();
    // Marcar que se ha invocado el tutor — arranca el cooldown del
    // disparador para no acosar al niño con la oferta otra vez.
    widget.servicio.registrarOferta(widget.idHabilidad);
  }

  @override
  void dispose() {
    _controlador.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final texto = _controlador.text;
    if (texto.trim().isEmpty || _esperandoRespuesta) return;
    setState(() {
      _mensajes.add(_MensajeConversacion(esNino: true, texto: texto.trim()));
      _esperandoRespuesta = true;
      _controlador.clear();
    });
    _bajarScroll();

    final respuesta = await widget.servicio.pedirExplicacion(
      idHabilidad: widget.idHabilidad,
      pregunta: texto,
      contextoFragmento: widget.contextoFragmento,
    );
    if (!mounted) return;
    setState(() {
      _mensajes.add(_MensajeConversacion(
        esNino: false,
        texto: respuesta.texto,
        esTenue: respuesta.estado != EstadoRespuestaTutor.ok,
      ));
      _esperandoRespuesta = false;
    });
    _bajarScroll();
  }

  void _bajarScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          'tutor — ${widget.nombreHabilidad.toLowerCase()}',
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 16,
            letterSpacing: 3,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(color: PaletaNeon.textoTenue),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _mensajes.isEmpty && !_esperandoRespuesta
                  ? const _EstadoVacio()
                  : ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          _mensajes.length + (_esperandoRespuesta ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == _mensajes.length && _esperandoRespuesta) {
                          return const _BurbujaEsperando();
                        }
                        return _Burbuja(mensaje: _mensajes[i]);
                      },
                    ),
            ),
            _Compositor(
              controlador: _controlador,
              habilitado: !_esperandoRespuesta,
              alEnviar: _enviar,
            ),
          ],
        ),
      ),
    );
  }
}

class _MensajeConversacion {
  final bool esNino;
  final String texto;
  final bool esTenue;

  const _MensajeConversacion({
    required this.esNino,
    required this.texto,
    this.esTenue = false,
  });
}

class _Burbuja extends StatelessWidget {
  final _MensajeConversacion mensaje;
  const _Burbuja({required this.mensaje});

  @override
  Widget build(BuildContext contexto) {
    final esNino = mensaje.esNino;
    final colorFondo = esNino
        ? PaletaNeon.violetaBase.withOpacity(0.5)
        : PaletaNeon.fondoMedio;
    final colorTexto = mensaje.esTenue
        ? PaletaNeon.textoTenue
        : PaletaNeon.textoPrincipal;
    return Align(
      alignment: esNino ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          mensaje.texto,
          style: TextStyle(color: colorTexto, fontSize: 15, height: 1.4),
        ),
      ),
    );
  }
}

/// Burbuja del tutor mientras la respuesta está en vuelo. Tres puntos
/// que pulsan para que el niño sepa que algo está pasando — el LLM
/// puede tardar varios segundos y un spinner pequeño se queda corto.
class _BurbujaEsperando extends StatefulWidget {
  const _BurbujaEsperando();

  @override
  State<_BurbujaEsperando> createState() => _BurbujaEsperandoState();
}

class _BurbujaEsperandoState extends State<_BurbujaEsperando>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ciclo;

  @override
  void initState() {
    super.initState();
    _ciclo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ciclo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contexto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio,
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedBuilder(
          animation: _ciclo,
          builder: (_, __) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final fase = (_ciclo.value - i * 0.18) % 1.0;
                final opacidad = (fase < 0.5 ? fase * 2 : (1 - fase) * 2)
                    .clamp(0.25, 1.0);
                return Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PaletaNeon.textoPrincipal.withOpacity(opacidad),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext contexto) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          'Cuéntame qué te ha trabado.\nCon tus palabras.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: PaletaNeon.textoTenue,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _Compositor extends StatelessWidget {
  final TextEditingController controlador;
  final bool habilitado;
  final Future<void> Function() alEnviar;

  const _Compositor({
    required this.controlador,
    required this.habilitado,
    required this.alEnviar,
  });

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        color: PaletaNeon.fondoMedio,
        border: Border(
          top: BorderSide(color: PaletaNeon.violetaBase, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controlador,
              enabled: habilitado,
              maxLines: 4,
              minLines: 1,
              maxLength: longitudMaximaPregunta,
              cursorColor: PaletaNeon.violetaNeon,
              style: const TextStyle(color: PaletaNeon.textoPrincipal),
              decoration: const InputDecoration(
                hintText: 'pregunta',
                hintStyle: TextStyle(color: PaletaNeon.textoTenue),
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'preguntar',
            onPressed: habilitado ? alEnviar : null,
            icon: const Icon(
              Icons.send,
              color: PaletaNeon.violetaNeon,
            ),
          ),
        ],
      ),
    );
  }
}
