import 'package:flutter/material.dart';

import '../../dominio/misterio.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pantalla_cerrar_misterio.dart';

/// Página completa de un Misterio. La tarjeta del home muestra sólo
/// pregunta + bajada + estado; aquí el niño lee la pregunta del oficio
/// con calma, ve qué evidencia ya ha anotado y, si quiere, arranca una
/// observación nueva con el Misterio preseleccionado para no romper el
/// flujo "leer Misterio → anotar evidencia".
///
/// Si el Misterio está abierto y tiene >=1 evidencia, aparece también
/// el botón "ya tengo mi respuesta sobre este Misterio" que abre la
/// pantalla de cierre amable. Sin evidencias el botón no aparece —
/// cerrar un Misterio sin haber anotado nada es prematuro.
///
/// Si el Misterio está cerrado por el niño, en lugar del botón "anotar
/// evidencia" aparece el bloque con la respuesta + fecha + botón
/// discreto "reabrir este Misterio".
///
/// Lectura pura — toda la mutación pasa por `PantallaObservacion` o por
/// la pantalla de cierre. Si el orquestador no inyecta
/// [alAbrirNuevaObservacion], el botón de evidencia no aparece (modo
/// S1, tests aislados).
class PantallaPaginaMisterio extends StatefulWidget {
  const PantallaPaginaMisterio({
    super.key,
    required this.repositorio,
    required this.misterio,
    this.alAbrirNuevaObservacion,
  });

  final RepositorioLocal repositorio;
  final Misterio misterio;

  /// Closure que el home cabla a `_abrirNuevaObservacion` con el id del
  /// Misterio preseleccionado. Si es null, sólo se muestra la cabecera
  /// + listado.
  final Future<void> Function(String misterioId)? alAbrirNuevaObservacion;

  @override
  State<PantallaPaginaMisterio> createState() => _EstadoPantallaPaginaMisterio();
}

class _EstadoPantallaPaginaMisterio extends State<PantallaPaginaMisterio> {
  late Misterio _misterio = widget.misterio;
  List<Observacion> _observaciones = const [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista =
        await widget.repositorio.obtenerObservaciones(misterioId: _misterio.id);
    final actualizado =
        await widget.repositorio.obtenerMisterioPorId(_misterio.id);
    if (!mounted) return;
    setState(() {
      _observaciones = lista;
      if (actualizado != null) _misterio = actualizado;
      _cargando = false;
    });
  }

  Future<void> _anotarEvidencia() async {
    final cb = widget.alAbrirNuevaObservacion;
    if (cb == null) return;
    await cb(_misterio.id);
    if (mounted) {
      await _cargar();
    }
  }

  Future<void> _abrirCierre() async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PantallaCerrarMisterio(
          repositorio: widget.repositorio,
          misterio: _misterio,
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
        title: Text(textos.misterioReabrirTitulo),
        content: Text(textos.misterioReabrirMensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(textos.misterioReabrirCancelar),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(textos.misterioReabrirConfirmar),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;
    await widget.repositorio.reabrirMisterioParaNino(_misterio.id);
    if (mounted) await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    final estaCerrado = _misterio.estaCerradoPorNino;
    final puedeAnotarEvidencia =
        widget.alAbrirNuevaObservacion != null && !estaCerrado;
    final puedeCerrar =
        !estaCerrado && _observaciones.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(textos.misterioPaginaTitulo)),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator.adaptive())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _Cabecera(misterio: _misterio, textos: textos),
                  if (estaCerrado) ...[
                    const SizedBox(height: 20),
                    _BloqueRespuestaDelNino(
                      misterio: _misterio,
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
                        label: Text(textos.misterioBotonEvidencia),
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
                        label: Text(textos.misterioBotonCerrar),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Text(
                    textos.misterioCabeceraEvidencia,
                    style: TipografiaCuaderno.sans(
                      color: esquema.tertiary,
                      tamano: TipografiaCuaderno.tamano12,
                      peso: TipografiaCuaderno.pesoMedio,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_observaciones.isEmpty)
                    Text(
                      textos.misterioPaginaEvidenciaVacia,
                      style: TipografiaCuaderno.serif(
                        color: PaletaCuaderno.tintaTenue,
                        tamano: TipografiaCuaderno.tamano13,
                        altoLinea: 1.5,
                      ),
                    )
                  else
                    for (final obs in _observaciones) ...[
                      _TarjetaObservacionAnclada(
                        observacion: obs,
                        textos: textos,
                        esquema: esquema,
                      ),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
      ),
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera({required this.misterio, required this.textos});

  final Misterio misterio;
  final TextosApp textos;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Container(
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
            misterio.preguntaEn(textos.localeName),
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano17,
              peso: TipografiaCuaderno.pesoMedio,
              altoLinea: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            misterio.descripcionEn(textos.localeName),
            style: TipografiaCuaderno.serif(
              color: PaletaCuaderno.tintaTenue,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            misterio.estado.toLocaleLabel(textos.localeName),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
        ],
      ),
    );
  }
}

class _BloqueRespuestaDelNino extends StatelessWidget {
  const _BloqueRespuestaDelNino({
    required this.misterio,
    required this.esquema,
    required this.textos,
    required this.alReabrir,
  });

  final Misterio misterio;
  final ColorScheme esquema;
  final TextosApp textos;
  final VoidCallback alReabrir;

  @override
  Widget build(BuildContext context) {
    final fecha = misterio.cerradoPorNino!;
    final fechaFormateada =
        '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: esquema.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: esquema.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textos.misterioBloqueRespuesta,
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
              peso: TipografiaCuaderno.pesoMedio,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            misterio.respuestaDelNino ?? '',
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            textos.misterioCerradoEl(fechaFormateada),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: alReabrir,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(textos.misterioReabrir),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaObservacionAnclada extends StatelessWidget {
  const _TarjetaObservacionAnclada({
    required this.observacion,
    required this.textos,
    required this.esquema,
  });

  final Observacion observacion;
  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: esquema.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: esquema.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _cabecera(observacion),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            observacion.queVio,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.5,
            ),
          ),
          if (observacion.creesQueEs != null &&
              observacion.creesQueEs!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '${observacion.creesQueEs} · '
              '${observacion.confianza.toLocaleLabel(textos.localeName)}',
              style: TipografiaCuaderno.sans(
                color: esquema.tertiary,
                tamano: TipografiaCuaderno.tamano12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _cabecera(Observacion obs) {
    final cuando = _formatearFecha(obs.cuandoOcurrio);
    final donde =
        obs.dondeNombre.isEmpty ? '' : ' · ${obs.dondeNombre.toLowerCase()}';
    return '$cuando$donde';
  }

  static String _formatearFecha(DateTime cuando) {
    return '${cuando.day.toString().padLeft(2, '0')}/'
        '${cuando.month.toString().padLeft(2, '0')}/${cuando.year}';
  }
}
