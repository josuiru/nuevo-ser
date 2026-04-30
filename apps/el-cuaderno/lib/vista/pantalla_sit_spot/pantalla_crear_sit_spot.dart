import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../dominio/geolocalizacion_privacy_first.dart';
import '../../dominio/observacion.dart';
import '../../dominio/sit_spot.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Pantalla de creación del primer sit spot del niño (biblia §3.5
/// y §5.1). El sit spot es central pedagógicamente — "habitar un
/// lugar" — pero hasta este punto sólo existía vía seed de debug.
///
/// Pide dos textos (nombre obligatorio, "dónde" descriptivo opcional)
/// y, si hay servicio de geolocalización inyectado, ofrece anclar
/// coordenadas opt-in con el mismo flujo de pre-permiso que ya usa
/// `PantallaObservacion`. Las coords se persisten sólo en
/// `SitSpot.coordenadas` (Isar local) — la frontera de privacidad de
/// `cliente_el_cuaderno.dart` impide que crucen red.
///
/// Voz adulta amable, sin diminutivos, sin urgencia. Doc 13 §2.4
/// acepta cualquier nombre que el niño le ponga al sitio.
class PantallaCrearSitSpot extends StatefulWidget {
  const PantallaCrearSitSpot({
    super.key,
    required this.alConfirmar,
    this.servicioGeolocalizacion,
    this.confirmarPrePermisoGeoOverride,
    DateTime Function()? proveedorAhora,
    String Function()? proveedorIds,
  })  : _proveedorAhora = proveedorAhora ?? DateTime.now,
        _proveedorIds = proveedorIds ?? _generarUuid;

  /// Llamado tras pulsar "guardar" con un nombre válido. La pantalla
  /// que monta esta widget se encarga de persistir el [SitSpot] en el
  /// repositorio y de cerrar la pantalla.
  final Future<void> Function(SitSpot sitSpot) alConfirmar;

  /// Si llega no nulo, aparece el bloque opt-in para anclar
  /// coordenadas. Mismo flujo que `PantallaObservacion` (B5).
  final ServicioGeolocalizacion? servicioGeolocalizacion;

  /// Para tests: closure que reemplaza el AlertDialog de pre-permiso.
  /// Devuelve `true` si el "niño" pulsa "anclar", `false` si cancela.
  final Future<bool> Function(BuildContext)? confirmarPrePermisoGeoOverride;

  final DateTime Function() _proveedorAhora;
  final String Function() _proveedorIds;

  static String _generarUuid() => const Uuid().v4();

  @override
  State<PantallaCrearSitSpot> createState() => _EstadoPantallaCrearSitSpot();
}

class _EstadoPantallaCrearSitSpot extends State<PantallaCrearSitSpot> {
  final TextEditingController _controladorNombre = TextEditingController();
  final TextEditingController _controladorDonde = TextEditingController();
  Coordenadas? _coordenadasAncladas;
  bool _solicitandoUbicacion = false;
  String? _avisoUbicacion;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _controladorNombre.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controladorNombre.dispose();
    _controladorDonde.dispose();
    super.dispose();
  }

  bool get _puedeGuardar =>
      !_guardando && _controladorNombre.text.trim().isNotEmpty;

  Future<void> _anclarPosicion() async {
    final servicio = widget.servicioGeolocalizacion;
    if (servicio == null) return;

    final override = widget.confirmarPrePermisoGeoOverride;
    final continua = override != null
        // ignore: use_build_context_synchronously
        ? await override(context)
        : await _mostrarPrePermisoUbicacion();
    if (continua != true) return;
    if (!mounted) return;

    setState(() {
      _solicitandoUbicacion = true;
      _avisoUbicacion = null;
    });
    try {
      var permiso = await servicio.permiso();
      if (permiso == PermisoGeo.noSolicitado || permiso == PermisoGeo.denegado) {
        permiso = await servicio.pedirPermiso();
      }
      if (!mounted) return;
      if (permiso != PermisoGeo.concedido) {
        setState(() {
          _solicitandoUbicacion = false;
          _avisoUbicacion = permiso == PermisoGeo.denegadoPermanente
              ? 'No se ha podido pedir permiso. Si quieres anclar la posición, '
                  'cámbialo en los ajustes del teléfono.'
              : 'Sin permiso de ubicación. Puedes seguir sin él.';
        });
        return;
      }
      final coords = await servicio.coordenadasActuales();
      if (!mounted) return;
      setState(() {
        _solicitandoUbicacion = false;
        if (coords == null) {
          _avisoUbicacion = 'No se ha podido localizar la posición. '
              'Puedes seguir sin ella.';
        } else {
          _coordenadasAncladas = coords;
          _avisoUbicacion = null;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _solicitandoUbicacion = false;
        _avisoUbicacion = 'No se ha podido localizar la posición. '
            'Puedes seguir sin ella.';
      });
    }
  }

  Future<bool> _mostrarPrePermisoUbicacion() async {
    final continuar = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('Anclar la posición a tu sit spot'),
        content: const Text(
          'La posición se queda en este cuaderno y no sale a internet. '
          'No la ve el adulto. Es opcional — el sit spot funciona sin ella.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogo).pop(false),
            child: const Text('cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogo).pop(true),
            child: const Text('anclar'),
          ),
        ],
      ),
    );
    return continuar ?? false;
  }

  void _quitarPosicion() {
    setState(() {
      _coordenadasAncladas = null;
      _avisoUbicacion = null;
    });
  }

  Future<void> _guardar() async {
    final nombre = _controladorNombre.text.trim();
    if (nombre.isEmpty) return;
    final donde = _controladorDonde.text.trim();
    setState(() => _guardando = true);

    final sitSpot = SitSpot(
      id: widget._proveedorIds(),
      nombre: nombre,
      dondeNombre: donde,
      coordenadas: _coordenadasAncladas,
      creadoEn: widget._proveedorAhora(),
    );
    await widget.alConfirmar(sitSpot);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Tu sit spot')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Un sit spot es un lugar al que vuelves. '
                'Lo ves cambiar con el tiempo.',
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano14,
                  altoLinea: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              const _Etiqueta('cómo se llama tu sit spot'),
              const SizedBox(height: 4),
              TextField(
                controller: _controladorNombre,
                enabled: !_guardando,
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano14,
                ),
                decoration: InputDecoration(
                  hintText: 'el roble grande, mi banco, donde fui con la abuela…',
                  hintStyle: TipografiaCuaderno.serif(
                    color: PaletaCuaderno.tintaTenue,
                    tamano: TipografiaCuaderno.tamano13,
                  ).copyWith(fontStyle: FontStyle.italic),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: esquema.outline),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _Etiqueta('dónde está, para acordarte (opcional)'),
              const SizedBox(height: 4),
              TextField(
                controller: _controladorDonde,
                enabled: !_guardando,
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano14,
                ),
                decoration: InputDecoration(
                  hintText: 'al final del parque, junto al pino más alto',
                  hintStyle: TipografiaCuaderno.serif(
                    color: PaletaCuaderno.tintaTenue,
                    tamano: TipografiaCuaderno.tamano13,
                  ).copyWith(fontStyle: FontStyle.italic),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: esquema.outline),
                  ),
                ),
              ),
              if (widget.servicioGeolocalizacion != null) ...[
                const SizedBox(height: 24),
                _BloqueAnclarSitSpot(
                  coordenadas: _coordenadasAncladas,
                  solicitando: _solicitandoUbicacion,
                  aviso: _avisoUbicacion,
                  alAnclar: _anclarPosicion,
                  alQuitar: _quitarPosicion,
                ),
              ],
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _puedeGuardar ? _guardar : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_guardando ? 'guardando…' : 'guardar sit spot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Text(
      texto,
      style: TipografiaCuaderno.sans(
        color: esquema.tertiary,
        tamano: TipografiaCuaderno.tamano12,
        peso: TipografiaCuaderno.pesoMedio,
      ),
    );
  }
}

class _BloqueAnclarSitSpot extends StatelessWidget {
  const _BloqueAnclarSitSpot({
    required this.coordenadas,
    required this.solicitando,
    required this.aviso,
    required this.alAnclar,
    required this.alQuitar,
  });

  final Coordenadas? coordenadas;
  final bool solicitando;
  final String? aviso;
  final VoidCallback alAnclar;
  final VoidCallback alQuitar;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: esquema.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: esquema.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coordenadas == null
                ? 'Posición no anclada'
                : 'Posición anclada al sit spot',
            style: TipografiaCuaderno.sans(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano13,
              peso: TipografiaCuaderno.pesoMedio,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'La posición se queda en este cuaderno y no sale a internet.',
            style: TipografiaCuaderno.serif(
              color: PaletaCuaderno.tintaTenue,
              tamano: TipografiaCuaderno.tamano12,
              altoLinea: 1.45,
            ),
          ),
          if (aviso != null) ...[
            const SizedBox(height: 8),
            Text(
              aviso!,
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.sienaTenue,
                tamano: TipografiaCuaderno.tamano12,
                altoLinea: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              if (coordenadas == null)
                TextButton(
                  onPressed: solicitando ? null : alAnclar,
                  child: Text(solicitando ? 'localizando…' : 'anclar mi posición'),
                )
              else ...[
                TextButton(
                  onPressed: alQuitar,
                  child: const Text('quitar posición'),
                ),
                const SizedBox(width: 8),
                Text(
                  '${coordenadas!.lat.toStringAsFixed(5)}, '
                  '${coordenadas!.lng.toStringAsFixed(5)}',
                  style: TipografiaCuaderno.sans(
                    color: PaletaCuaderno.tintaTenue,
                    tamano: TipografiaCuaderno.tamano12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
