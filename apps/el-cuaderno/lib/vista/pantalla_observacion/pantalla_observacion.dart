import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../dominio/misterio.dart';
import '../../dominio/nivel_confianza.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'selector_confianza.dart';
import 'selector_misterio.dart';

/// Pantalla de Nueva Observación. Coherente con el mockup de la
/// biblia §5.2 y el detalle operativo del doc 13 §3.2.
class PantallaObservacion extends StatefulWidget {
  const PantallaObservacion({
    super.key,
    required this.repositorio,
    required this.misteriosAbiertos,
    required this.sitSpotActivo,
    this.misterioPreseleccionadoId,
    DateTime Function()? proveedorAhora,
    String Function()? proveedorIds,
  })  : _proveedorAhora = proveedorAhora ?? DateTime.now,
        _proveedorIds = proveedorIds ?? _generarUuid;

  final RepositorioLocal repositorio;
  final List<Misterio> misteriosAbiertos;
  final SitSpot? sitSpotActivo;
  final String? misterioPreseleccionadoId;
  final DateTime Function() _proveedorAhora;
  final String Function() _proveedorIds;

  static String _generarUuid() => const Uuid().v4();

  @override
  State<PantallaObservacion> createState() => _EstadoPantallaObservacion();
}

class _EstadoPantallaObservacion extends State<PantallaObservacion> {
  late final TextEditingController _controladorQueViste;
  late final TextEditingController _controladorCreesQueEs;
  late NivelConfianza _confianza;
  String? _misterioId;

  @override
  void initState() {
    super.initState();
    _controladorQueViste = TextEditingController();
    _controladorCreesQueEs = TextEditingController();
    _confianza = NivelConfianza.hipotesisActiva;
    _misterioId = widget.misterioPreseleccionadoId;

    // Reconstruye el botón Guardar al cambiar la longitud del campo
    // obligatorio.
    _controladorQueViste.addListener(() => setState(() {}));
    _controladorCreesQueEs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controladorQueViste.dispose();
    _controladorCreesQueEs.dispose();
    super.dispose();
  }

  bool get _puedeGuardar => _controladorQueViste.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;
    final ahora = widget._proveedorAhora();

    return Scaffold(
      appBar: AppBar(title: Text(textos.observacionTitulo)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  _Cabecera(
                    cabecera: textos.observacionCabecera(_formatearHora(ahora)),
                    sitSpot: widget.sitSpotActivo,
                  ),
                  const SizedBox(height: 16),
                  _CajaFotoDibujo(textos: textos),
                  const SizedBox(height: 24),
                  _Etiqueta(textos.observacionEtiquetaQueViste),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _controladorQueViste,
                    minLines: 4,
                    maxLines: 8,
                    maxLength: 2000,
                    style: TipografiaCuaderno.serif(
                      color: esquema.onSurface,
                      tamano: TipografiaCuaderno.tamano14,
                      altoLinea: 1.5,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: textos.observacionPlaceholderQueViste,
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
                  const SizedBox(height: 16),
                  _Etiqueta(textos.observacionEtiquetaCreesQueEs),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _controladorCreesQueEs,
                    style: TipografiaCuaderno.serif(
                      color: esquema.onSurface,
                      tamano: TipografiaCuaderno.tamano14,
                    ),
                    decoration: InputDecoration(
                      hintText: textos.observacionPlaceholderCreesQueEs,
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
                  const SizedBox(height: 12),
                  // Los chips solo aparecen cuando el niño ha escrito algo
                  // en `crees que es` — coherente con doc 13 §3.2.4.
                  if (_controladorCreesQueEs.text.trim().isNotEmpty)
                    SelectorConfianza(
                      confianza: _confianza,
                      alCambiar: (nuevoNivel) =>
                          setState(() => _confianza = nuevoNivel),
                    ),
                  const SizedBox(height: 24),
                  if (widget.misteriosAbiertos.isNotEmpty) ...[
                    const _Etiqueta('va con un Misterio'),
                    const SizedBox(height: 4),
                    SelectorMisterio(
                      misteriosAbiertos: widget.misteriosAbiertos,
                      misterioSeleccionadoId: _misterioId,
                      alCambiar: (id) => setState(() => _misterioId = id),
                    ),
                  ],
                ],
              ),
            ),
            _BotonGuardar(
              habilitado: _puedeGuardar,
              alPulsar: _guardar,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    final queViste = _controladorQueViste.text.trim();
    final creesQueEs = _controladorCreesQueEs.text.trim();
    final ahora = widget._proveedorAhora();
    final observacion = Observacion(
      id: widget._proveedorIds(),
      cuandoCreada: ahora,
      cuandoOcurrio: ahora,
      dondeNombre: widget.sitSpotActivo?.nombre ?? '',
      sitSpotId: widget.sitSpotActivo?.id,
      queVio: queViste,
      creesQueEs: creesQueEs.isEmpty ? null : creesQueEs,
      // Si el niño no escribió identificación, el nivel registrado
      // baja a hipótesis activa por defecto — incluso si el chip
      // mostrado decía otra cosa antes de borrar el texto.
      confianza: creesQueEs.isEmpty
          ? NivelConfianza.hipotesisActiva
          : _confianza,
      misterioId: _misterioId,
    );

    await widget.repositorio.guardarObservacion(observacion);
    if (_misterioId != null) {
      await widget.repositorio.anclarObservacionAMisterio(
        observacion.id,
        _misterioId!,
      );
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _formatearHora(DateTime cuando) {
    final hh = cuando.hour.toString().padLeft(2, '0');
    final mm = cuando.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera({required this.cabecera, required this.sitSpot});

  final String cabecera;
  final SitSpot? sitSpot;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textoLugar =
        sitSpot == null ? '' : ' · ${sitSpot!.nombre.toLowerCase()}';
    return Text(
      '$cabecera$textoLugar',
      style: TipografiaCuaderno.sans(
        color: esquema.tertiary,
        tamano: TipografiaCuaderno.tamano12,
      ),
    );
  }
}

class _CajaFotoDibujo extends StatelessWidget {
  const _CajaFotoDibujo({required this.textos});

  final TextosApp textos;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: esquema.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            textos.observacionCajaPlaceholder,
            textAlign: TextAlign.center,
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
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

class _BotonGuardar extends StatelessWidget {
  const _BotonGuardar({required this.habilitado, required this.alPulsar});

  final bool habilitado;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!habilitado)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                textos.observacionAvisoFalta,
                textAlign: TextAlign.center,
                style: TipografiaCuaderno.sans(
                  color: esquema.tertiary,
                  tamano: TipografiaCuaderno.tamano12,
                ),
              ),
            ),
          FilledButton(
            onPressed: habilitado ? alPulsar : null,
            style: FilledButton.styleFrom(
              backgroundColor: esquema.primary,
              foregroundColor: esquema.onPrimary,
              disabledBackgroundColor:
                  // Flutter 3.24: usar withOpacity (CLAUDE.md uno-roto).
                  // ignore: deprecated_member_use
                  esquema.surfaceContainerHighest.withOpacity(0.5),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: TipografiaCuaderno.sans(
                color: esquema.onPrimary,
                tamano: TipografiaCuaderno.tamano14,
                peso: TipografiaCuaderno.pesoMedio,
              ),
            ),
            child: Text(textos.observacionBotonGuardar),
          ),
        ],
      ),
    );
  }
}
