import 'package:flutter/material.dart';

import '../../dominio/observacion.dart';
import '../../dominio/pregunta_del_nino.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pantalla_cerrar_pregunta.dart';

/// Página completa de una pregunta del niño. Simétrica a
/// [PantallaPaginaMisterio] pero apuntando al catálogo del niño.
///
/// **Anatomía**:
/// - Cabecera: pregunta + fecha de formulación.
/// - Si está cerrada: bloque "Tu respuesta" con texto + fecha de
///   cierre + botón discreto "reabrir esta pregunta".
/// - Si está abierta: botón principal "anotar evidencia para esta
///   pregunta" (que abre [PantallaObservacion] con
///   `preguntaDelNinoPreseleccionadaId`); y, sólo si hay >=1 evidencia,
///   botón secundario "ya tengo mi respuesta" para abrir
///   [PantallaCerrarPregunta].
/// - Listado de observaciones ancladas como evidencia.
/// - Menú overflow: "borrar esta pregunta" con confirmación.
class PantallaPaginaPregunta extends StatefulWidget {
  const PantallaPaginaPregunta({
    super.key,
    required this.repositorio,
    required this.pregunta,
    this.alAbrirNuevaObservacion,
  });

  final RepositorioLocal repositorio;
  final PreguntaDelNino pregunta;

  /// Closure que el home cabla a `_abrirObservacion` con el id de la
  /// pregunta preseleccionado. Si es null, sólo se muestra la cabecera
  /// + listado (lectura pura para tests aislados).
  final Future<void> Function(String preguntaId)? alAbrirNuevaObservacion;

  @override
  State<PantallaPaginaPregunta> createState() => _EstadoPantallaPaginaPregunta();
}

class _EstadoPantallaPaginaPregunta extends State<PantallaPaginaPregunta> {
  late PreguntaDelNino _pregunta = widget.pregunta;
  List<Observacion> _evidencia = const [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final actualizada =
        await widget.repositorio.obtenerPreguntaDelNinoPorId(_pregunta.id);
    final lista = await widget.repositorio.obtenerObservaciones(
      preguntaDelNinoId: _pregunta.id,
    );
    if (!mounted) return;
    setState(() {
      if (actualizada != null) _pregunta = actualizada;
      _evidencia = lista;
      _cargando = false;
    });
  }

  Future<void> _anotarEvidencia() async {
    final cb = widget.alAbrirNuevaObservacion;
    if (cb == null) return;
    await cb(_pregunta.id);
    if (mounted) {
      await _cargar();
    }
  }

  Future<void> _abrirCierre() async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PantallaCerrarPregunta(
          repositorio: widget.repositorio,
          pregunta: _pregunta,
        ),
      ),
    );
    if (guardado == true && mounted) {
      await _cargar();
    }
  }

  Future<void> _confirmarReabrir() async {
    final textos = TextosApp.of(context);
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(textos.preguntaPaginaReabrir),
        content: Text(textos.preguntaPaginaConfirmaReabrir),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Reabrir'),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;
    await widget.repositorio.reabrirPreguntaDelNino(_pregunta.id);
    if (mounted) await _cargar();
  }

  Future<void> _confirmarBorrar() async {
    final textos = TextosApp.of(context);
    final navigator = Navigator.of(context);
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(textos.preguntaPaginaBorrar),
        content: Text(textos.preguntaPaginaConfirmaBorrar),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('borrar'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;
    await widget.repositorio.borrarPreguntaDelNino(_pregunta.id);
    if (!mounted) return;
    navigator.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    final estaCerrada = _pregunta.estaCerrada;
    final puedeAnotarEvidencia =
        widget.alAbrirNuevaObservacion != null && !estaCerrada;
    final puedeCerrar = !estaCerrada && _evidencia.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(textos.preguntaPaginaTitulo),
        actions: [
          PopupMenuButton<String>(
            onSelected: (valor) {
              if (valor == 'borrar') _confirmarBorrar();
            },
            itemBuilder: (popupContext) => [
              PopupMenuItem<String>(
                value: 'borrar',
                child: Text(textos.preguntaPaginaBorrar),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator.adaptive())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  Text(
                    _pregunta.pregunta,
                    style: TipografiaCuaderno.serif(
                      color: esquema.onSurface,
                      tamano: TipografiaCuaderno.tamano17,
                      peso: TipografiaCuaderno.pesoMedio,
                      altoLinea: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    textos.preguntaPaginaFormulada(
                      _formatearFecha(_pregunta.formuladaEn),
                    ),
                    style: TipografiaCuaderno.sans(
                      color: esquema.tertiary,
                      tamano: TipografiaCuaderno.tamano12,
                    ),
                  ),
                  if (estaCerrada) ...[
                    const SizedBox(height: 20),
                    _BloqueRespuesta(
                      pregunta: _pregunta,
                      esquema: esquema,
                      textos: textos,
                      alReabrir: _confirmarReabrir,
                    ),
                  ],
                  if (puedeAnotarEvidencia) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _anotarEvidencia,
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(textos.preguntaPaginaBotonEvidencia),
                      ),
                    ),
                  ],
                  if (puedeCerrar) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _abrirCierre,
                        icon: const Icon(Icons.bookmark_outline),
                        label: Text(textos.preguntaPaginaBotonCerrar),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Text(
                    textos.preguntaPaginaCabeceraEvidencia,
                    style: TipografiaCuaderno.sans(
                      color: esquema.tertiary,
                      tamano: TipografiaCuaderno.tamano12,
                      peso: TipografiaCuaderno.pesoMedio,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_evidencia.isEmpty)
                    Text(
                      textos.preguntaPaginaEvidenciaVacia,
                      style: TipografiaCuaderno.serif(
                        color: PaletaCuaderno.tintaTenue,
                        tamano: TipografiaCuaderno.tamano13,
                        altoLinea: 1.5,
                      ),
                    )
                  else
                    for (final obs in _evidencia) ...[
                      _TarjetaEvidencia(observacion: obs),
                      const SizedBox(height: 8),
                    ],
                ],
              ),
      ),
    );
  }
}

/// Bloque de la respuesta del niño cuando la pregunta está cerrada —
/// paralelo al `_BloqueRespuestaDelNino` de Misterio.
class _BloqueRespuesta extends StatelessWidget {
  const _BloqueRespuesta({
    required this.pregunta,
    required this.esquema,
    required this.textos,
    required this.alReabrir,
  });

  final PreguntaDelNino pregunta;
  final ColorScheme esquema;
  final TextosApp textos;
  final VoidCallback alReabrir;

  @override
  Widget build(BuildContext context) {
    final fecha = pregunta.cerradaEn!;
    return Container(
      decoration: BoxDecoration(
        color: esquema.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: esquema.outline, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textos.preguntaPaginaBloqueRespuesta,
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
              peso: TipografiaCuaderno.pesoMedio,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pregunta.respuestaDelNino ?? '',
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.55,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            textos.preguntaPaginaCerradaEl(_formatearFecha(fecha)),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano11,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: alReabrir,
              child: Text(textos.preguntaPaginaReabrir),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta minimalista para una observación anclada a la pregunta.
class _TarjetaEvidencia extends StatelessWidget {
  const _TarjetaEvidencia({required this.observacion});

  final Observacion observacion;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: esquema.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: esquema.outline, width: 0.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatearFecha(observacion.cuandoOcurrio),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            observacion.queVio,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatearFecha(DateTime fecha) {
  final dia = fecha.day.toString().padLeft(2, '0');
  final mes = fecha.month.toString().padLeft(2, '0');
  return '$dia/$mes/${fecha.year}';
}
