import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/repositorio_faro.dart';
import '../dominio/faro_de_azula.dart';

/// Pantalla del Faro de Azula — el periódico semanal del lore.
///
/// Lectura larga en scroll vertical (no paginado): el niño se sienta
/// y lo lee como un periódico. Estilo "papel viejo + tinta": fondo
/// crema cálido, tinta marrón oscura, tipografía serif (Cormorant
/// Garamond, ya cargada en pubspec para los Fragmentos nombrados).
///
/// La edición que muestra se calcula a partir de la primera vista —
/// la apertura inicial fija el origen de la "semana 1" para ese
/// perfil. A partir de ahí, cada 7 días aparece la siguiente.
///
/// El acertijo lleva un input de texto libre. La validación contra
/// `solucionCanonica` es deliberadamente laxa (el periódico no
/// corrige; la solución llega como noticia en la edición siguiente).
/// Lo que sí hacemos es persistir lo enviado para que el niño vea su
/// propia respuesta al volver.
class PantallaFaro extends StatefulWidget {
  const PantallaFaro({
    super.key,
    required this.repositorioFaro,
    required this.banco,
  });

  final RepositorioFaro repositorioFaro;
  final List<EdicionFaro> banco;

  @override
  State<PantallaFaro> createState() => _PantallaFaroState();
}

class _PantallaFaroState extends State<PantallaFaro> {
  /// Semana **actual** del jugador — la última disponible. Se calcula
  /// una vez al cargar y queda fija en esta sesión: las flechas no
  /// dejan navegar más allá.
  int _semanaMaxima = 1;

  /// Semana que el niño está viendo en este momento. Por defecto =
  /// `_semanaMaxima` (su edición de la semana). Cambia con las
  /// flechas del AppBar.
  int _semanaVisible = 1;

  EdicionFaro? _edicion;
  String? _respuestaGuardada;
  final TextEditingController _controladorRespuesta = TextEditingController();

  /// Estado derivado del TextField: `true` cuando el texto (tras
  /// trim) tiene contenido. Se recalcula con cada cambio del
  /// controller para activar/desactivar el botón ENVIAR.
  bool _puedeEnviar = false;

  @override
  void initState() {
    super.initState();
    _controladorRespuesta.addListener(_actualizarPuedeEnviar);
    _cargarInicial();
  }

  void _actualizarPuedeEnviar() {
    final puedeAhora = _controladorRespuesta.text.trim().isNotEmpty;
    if (puedeAhora == _puedeEnviar) return;
    setState(() => _puedeEnviar = puedeAhora);
  }

  Future<void> _cargarInicial() async {
    final ahora = DateTime.now();
    await widget.repositorioFaro.marcarPrimeraVistaSiEsNueva(ahora);
    final primeraVistaMs =
        await widget.repositorioFaro.cargarPrimeraVistaMs();
    final semana = calcularNumeroSemanaActual(
      ahora: ahora,
      primeraVistaMs: primeraVistaMs,
      totalEdiciones: widget.banco.length,
    );
    // La semana actual del niño marca la edición vista (no las
    // que pueda releer hacia atrás).
    await widget.repositorioFaro.guardarUltimaEdicionVista(semana);
    if (!mounted) return;
    _semanaMaxima = semana;
    await _mostrarEdicion(semana);
  }

  /// Carga la edición de la semana `n` (1..semanaMaxima) y rellena
  /// la respuesta previa al acertijo de esa edición. Idempotente.
  Future<void> _mostrarEdicion(int n) async {
    final edicion =
        widget.banco.firstWhere((e) => e.numeroSemana == n);
    final respuestaPrevia =
        await widget.repositorioFaro.cargarRespuestaAcertijo(n);
    if (!mounted) return;
    setState(() {
      _semanaVisible = n;
      _edicion = edicion;
      _respuestaGuardada = respuestaPrevia;
      _controladorRespuesta.text = respuestaPrevia ?? '';
    });
  }

  @override
  void dispose() {
    _controladorRespuesta.removeListener(_actualizarPuedeEnviar);
    _controladorRespuesta.dispose();
    super.dispose();
  }

  Future<void> _enviarRespuesta() async {
    final edicion = _edicion;
    if (edicion == null) return;
    final texto = _controladorRespuesta.text.trim();
    if (texto.isEmpty) return;
    HapticFeedback.selectionClick();
    await widget.repositorioFaro.guardarRespuestaAcertijo(
      edicion.numeroSemana,
      texto,
    );
    if (!mounted) return;
    setState(() {
      _respuestaGuardada = texto;
    });
  }

  void _irAEdicionAnterior() {
    if (_semanaVisible <= 1) return;
    HapticFeedback.selectionClick();
    _mostrarEdicion(_semanaVisible - 1);
  }

  void _irAEdicionSiguiente() {
    if (_semanaVisible >= _semanaMaxima) return;
    HapticFeedback.selectionClick();
    _mostrarEdicion(_semanaVisible + 1);
  }

  @override
  Widget build(BuildContext contexto) {
    final edicion = _edicion;
    final puedeIrAtras = _semanaVisible > 1;
    final puedeIrAdelante = _semanaVisible < _semanaMaxima;
    return Scaffold(
      backgroundColor: _ColoresFaro.papel,
      appBar: AppBar(
        backgroundColor: _ColoresFaro.papel,
        foregroundColor: _ColoresFaro.tinta,
        elevation: 0,
        iconTheme: const IconThemeData(color: _ColoresFaro.tinta),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'EL FARO DE AZULA',
              style: TextStyle(
                color: _ColoresFaro.tinta,
                fontFamily: 'CormorantGaramond',
                fontSize: 18,
                letterSpacing: 4,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_semanaMaxima > 1)
              Text(
                'Semana $_semanaVisible de $_semanaMaxima',
                style: const TextStyle(
                  color: _ColoresFaro.tintaTenue,
                  fontFamily: 'CormorantGaramond',
                  fontSize: 11,
                  letterSpacing: 2,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Edición anterior',
            icon: const Icon(Icons.chevron_left),
            color: puedeIrAtras
                ? _ColoresFaro.tinta
                : _ColoresFaro.tintaTenue.withOpacity(0.3),
            onPressed: puedeIrAtras ? _irAEdicionAnterior : null,
          ),
          IconButton(
            tooltip: 'Edición siguiente',
            icon: const Icon(Icons.chevron_right),
            color: puedeIrAdelante
                ? _ColoresFaro.tinta
                : _ColoresFaro.tintaTenue.withOpacity(0.3),
            onPressed: puedeIrAdelante ? _irAEdicionSiguiente : null,
          ),
        ],
      ),
      body: edicion == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CabeceraPeriodico(edicion: edicion),
                  const SizedBox(height: 28),
                  for (final noticia in edicion.portada) ...[
                    _NoticiaWidget(noticia: noticia),
                    const SizedBox(height: 24),
                  ],
                  const _Separador(),
                  _CronicaWidget(cronica: edicion.cronica),
                  const _Separador(),
                  const _TituloSeccion('Cartas al director'),
                  const SizedBox(height: 12),
                  for (final carta in edicion.cartas) ...[
                    _CartaWidget(carta: carta),
                    const SizedBox(height: 18),
                  ],
                  const _Separador(),
                  _AcertijoWidget(
                    acertijo: edicion.acertijo,
                    controlador: _controladorRespuesta,
                    respuestaGuardada: _respuestaGuardada,
                    puedeEnviar: _puedeEnviar,
                    alEnviar: _enviarRespuesta,
                  ),
                ],
              ),
            ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Sub-widgets de la pantalla
// ──────────────────────────────────────────────────────────────────

class _CabeceraPeriodico extends StatelessWidget {
  const _CabeceraPeriodico({required this.edicion});

  final EdicionFaro edicion;

  @override
  Widget build(BuildContext contexto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: _ColoresFaro.tinta, width: 2),
          bottom: BorderSide(color: _ColoresFaro.tinta, width: 2),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'EL FARO DE AZULA',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              color: _ColoresFaro.tinta,
              fontSize: 30,
              letterSpacing: 6,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Periódico semanal de la ciudad',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              color: _ColoresFaro.tintaTenue,
              fontSize: 13,
              letterSpacing: 2,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: _ColoresFaro.tinta.withOpacity(0.45),
          ),
          const SizedBox(height: 8),
          Text(
            'Año ${edicion.anioOrden} de la Orden  ·  Edición ${edicion.numeroEdicion}',
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              color: _ColoresFaro.tinta,
              fontSize: 13,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticiaWidget extends StatelessWidget {
  const _NoticiaWidget({required this.noticia});

  final NoticiaPortada noticia;

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          noticia.titulo,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            color: _ColoresFaro.tinta,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        if (noticia.firma != null) ...[
          const SizedBox(height: 6),
          Text(
            noticia.firma ?? '',
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              color: _ColoresFaro.tintaTenue,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 12),
        _TextoMarkdown(noticia.cuerpo),
      ],
    );
  }
}

class _CronicaWidget extends StatelessWidget {
  const _CronicaWidget({required this.cronica});

  final Cronica cronica;

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TituloSeccion('Crónica'),
        const SizedBox(height: 12),
        Text(
          cronica.titulo,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            color: _ColoresFaro.tinta,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          cronica.firma,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            color: _ColoresFaro.tintaTenue,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 0, 6, 0),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: _ColoresFaro.tintaTenue, width: 2),
            ),
          ),
          child: Text(
            cronica.introduccion,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              color: _ColoresFaro.tintaTenue,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _TextoMarkdown(cronica.cuerpo),
      ],
    );
  }
}

class _CartaWidget extends StatelessWidget {
  const _CartaWidget({required this.carta});

  final CartaAlDirector carta;

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 0, 6, 0),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: _ColoresFaro.tintaTenue, width: 2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                carta.pregunta,
                style: const TextStyle(
                  fontFamily: 'CormorantGaramond',
                  color: _ColoresFaro.tinta,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '— ${carta.firmante}.',
                style: const TextStyle(
                  fontFamily: 'CormorantGaramond',
                  color: _ColoresFaro.tintaTenue,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _TextoMarkdown(carta.respuesta),
      ],
    );
  }
}

class _AcertijoWidget extends StatelessWidget {
  const _AcertijoWidget({
    required this.acertijo,
    required this.controlador,
    required this.respuestaGuardada,
    required this.puedeEnviar,
    required this.alEnviar,
  });

  final Acertijo acertijo;
  final TextEditingController controlador;
  final String? respuestaGuardada;
  final bool puedeEnviar;
  final VoidCallback alEnviar;

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: _ColoresFaro.tinta, width: 2),
        color: _ColoresFaro.papelOscuro,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acertijo de la semana',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              color: _ColoresFaro.tintaTenue,
              fontSize: 12,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            acertijo.titulo,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              color: _ColoresFaro.tinta,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),
          _TextoMarkdown(acertijo.enunciado),
          if (acertijo.pista != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _ColoresFaro.papel,
                border: Border.all(
                  color: _ColoresFaro.tintaTenue.withOpacity(0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pista: ',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      color: _ColoresFaro.tinta,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      acertijo.pista ?? '',
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        color: _ColoresFaro.tinta,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          TextField(
            controller: controlador,
            maxLines: 2,
            minLines: 1,
            // Capitaliza la primera letra de cada frase (más natural
            // en castellano). El niño puede escribir "veinte naranjas"
            // y aparecer como "Veinte naranjas".
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              color: _ColoresFaro.tinta,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Tu respuesta…',
              hintStyle: TextStyle(
                fontFamily: 'CormorantGaramond',
                color: _ColoresFaro.tintaTenue.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
              filled: true,
              fillColor: _ColoresFaro.papel,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: _ColoresFaro.tintaTenue),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: _ColoresFaro.tinta, width: 2),
                borderRadius: BorderRadius.zero,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: _ColoresFaro.tintaTenue),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: puedeEnviar ? alEnviar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _ColoresFaro.tinta,
                  foregroundColor: _ColoresFaro.papel,
                  // Cuando está deshabilitado, Material 3 da un gris
                  // por defecto que choca con la paleta del Faro.
                  // Forzamos un papel oscuro para que se siga viendo
                  // como "del periódico" pero claramente inactivo.
                  disabledBackgroundColor: _ColoresFaro.papelOscuro,
                  disabledForegroundColor:
                      _ColoresFaro.tintaTenue.withOpacity(0.6),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                ),
                child: const Text(
                  'ENVIAR',
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 14,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (respuestaGuardada != null)
                const Expanded(
                  child: Text(
                    'Tu respuesta queda anotada en el buzón.',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      color: _ColoresFaro.tintaTenue,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'La solución se publica en la edición de la semana siguiente.',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              color: _ColoresFaro.tintaTenue,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion(this.texto);

  final String texto;

  @override
  Widget build(BuildContext contexto) {
    return Text(
      texto.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'CormorantGaramond',
        color: _ColoresFaro.tintaTenue,
        fontSize: 12,
        letterSpacing: 4,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        children: [
          Expanded(
            child: Container(
                height: 1, color: _ColoresFaro.tinta.withOpacity(0.3)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '※',
              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                color: _ColoresFaro.tintaTenue,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Container(
                height: 1, color: _ColoresFaro.tinta.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }
}

/// Renderizador de markdown muy ligero (solo `**` para negrita y `*`
/// para cursiva). Divide por `\n\n` en párrafos. No interpreta listas
/// ni links — el banco del Faro los escribe como texto plano.
///
/// Visible para tests con `@visibleForTesting` no haría falta porque
/// el parser pasa por `parsearMarkdownLigero`, que es público.
class _TextoMarkdown extends StatelessWidget {
  const _TextoMarkdown(this.texto);

  final String texto;

  @override
  Widget build(BuildContext contexto) {
    final parrafos = texto.split('\n\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < parrafos.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == parrafos.length - 1 ? 0 : 12),
            child: RichText(
              text: TextSpan(
                children: parsearMarkdownLigero(
                  parrafos[i],
                  const TextStyle(
                    fontFamily: 'CormorantGaramond',
                    color: _ColoresFaro.tinta,
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Parser puro de markdown ligero. Reconoce:
///
/// - `**texto**` → negrita
/// - `*texto*` → cursiva
///
/// Si los marcadores no cierran (texto roto), el parser sigue
/// adelante en silencio — el contenido se ve sin formato pero la
/// pantalla no se rompe. Las listas con guion (`- ...`) se respetan
/// como texto plano (cae en el plano `\n` natural del párrafo).
///
/// Expuesto para tests.
List<InlineSpan> parsearMarkdownLigero(String texto, TextStyle estiloBase) {
  final spans = <InlineSpan>[];
  final buffer = StringBuffer();
  bool negrita = false;
  bool cursiva = false;

  void volcar() {
    if (buffer.isEmpty) return;
    spans.add(TextSpan(
      text: buffer.toString(),
      style: estiloBase.copyWith(
        fontWeight: negrita ? FontWeight.w700 : null,
        fontStyle: cursiva ? FontStyle.italic : null,
      ),
    ));
    buffer.clear();
  }

  int i = 0;
  while (i < texto.length) {
    if (i + 1 < texto.length && texto[i] == '*' && texto[i + 1] == '*') {
      volcar();
      negrita = !negrita;
      i += 2;
      continue;
    }
    if (texto[i] == '*') {
      volcar();
      cursiva = !cursiva;
      i++;
      continue;
    }
    buffer.write(texto[i]);
    i++;
  }
  volcar();
  return spans;
}

class _ColoresFaro {
  static const tinta = Color(0xFF2A2017);
  static const tintaTenue = Color(0xFF7A6A55);
  static const papel = Color(0xFFEFE6D2);
  static const papelOscuro = Color(0xFFE3D7BC);
}
