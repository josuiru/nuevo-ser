import 'package:flutter/material.dart';

import '../../dominio/nivel_confianza.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'selector_confianza.dart';

/// Pantalla acotada de edición de una observación. **Sólo edita los
/// campos textuales**: `queVio`, `creesQueEs`, `confianza`,
/// `climaResumen`, `dondeNombre`. Foto, dibujo, coordenadas, anclaje
/// al Misterio y al sit spot quedan como estaban — cambiar esos
/// requiere borrar y crear de nuevo.
///
/// Por qué no editar todo: el flujo de foto/dibujo de
/// `PantallaObservacion` está cableado a la creación (genera UUID
/// nuevo, copia ficheros temporales al destino final, gestiona
/// huérfanos si se cancela). Reutilizar ese flujo en modo edición
/// duplica la complejidad por un caso minoritario (cambiar la foto de
/// una observación pasada). Para el 90% de errores reales — un typo
/// en `queVio`, identificación equivocada, nivel de confianza mal
/// elegido — basta con esta pantalla.
///
/// Devuelve la [Observacion] actualizada vía `Navigator.pop` o `null`
/// si el niño cancela. Idempotente por id en el repositorio.
class PantallaEditarObservacion extends StatefulWidget {
  const PantallaEditarObservacion({
    super.key,
    required this.repositorio,
    required this.observacion,
  });

  final RepositorioLocal repositorio;
  final Observacion observacion;

  @override
  State<PantallaEditarObservacion> createState() =>
      _EstadoPantallaEditarObservacion();
}

class _EstadoPantallaEditarObservacion
    extends State<PantallaEditarObservacion> {
  late final TextEditingController _controladorQueVio;
  late final TextEditingController _controladorCreesQueEs;
  late final TextEditingController _controladorClima;
  late final TextEditingController _controladorDonde;
  late NivelConfianza _confianza;

  @override
  void initState() {
    super.initState();
    final obs = widget.observacion;
    _controladorQueVio = TextEditingController(text: obs.queVio);
    _controladorCreesQueEs =
        TextEditingController(text: obs.creesQueEs ?? '');
    _controladorClima = TextEditingController(text: obs.climaResumen ?? '');
    _controladorDonde = TextEditingController(text: obs.dondeNombre);
    _confianza = obs.confianza;
    _controladorQueVio.addListener(() => setState(() {}));
    _controladorCreesQueEs.addListener(() => setState(() {}));
    _controladorDonde.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controladorQueVio.dispose();
    _controladorCreesQueEs.dispose();
    _controladorClima.dispose();
    _controladorDonde.dispose();
    super.dispose();
  }

  bool get _puedeGuardar {
    if (_controladorQueVio.text.trim().isEmpty) return false;
    if (_controladorDonde.text.trim().isEmpty) return false;
    // Coherente con la validación de dominio: declarar consenso
    // requiere haber propuesto identificación.
    if (_confianza == NivelConfianza.consenso &&
        _controladorCreesQueEs.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _guardar() async {
    if (!_puedeGuardar) return;
    final navegador = Navigator.of(context);
    final original = widget.observacion;
    final creesQueEsLimpio = _controladorCreesQueEs.text.trim();
    final climaLimpio = _controladorClima.text.trim();
    final actualizada = Observacion(
      id: original.id,
      cuandoCreada: original.cuandoCreada,
      cuandoOcurrio: original.cuandoOcurrio,
      dondeNombre: _controladorDonde.text.trim(),
      dondeCoordenadas: original.dondeCoordenadas,
      climaResumen: climaLimpio.isEmpty ? null : climaLimpio,
      queVio: _controladorQueVio.text.trim(),
      creesQueEs: creesQueEsLimpio.isEmpty ? null : creesQueEsLimpio,
      confianza: _confianza,
      fotoRutaLocal: original.fotoRutaLocal,
      dibujoRutaLocal: original.dibujoRutaLocal,
      misterioId: original.misterioId,
      sitSpotId: original.sitSpotId,
    );
    await widget.repositorio.guardarObservacion(actualizada);
    if (!mounted) return;
    navegador.pop(actualizada);
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    final mostrarChips = _controladorCreesQueEs.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(textos.editarObservacionTitulo)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                children: [
                  Text(
                    'Estás editando esta página del cuaderno. La foto, '
                    'el dibujo, la posición y los anclajes (Misterio, '
                    'sit spot) se conservan tal cual.',
                    style: TipografiaCuaderno.serif(
                      color: PaletaCuaderno.tintaTenue,
                      tamano: TipografiaCuaderno.tamano13,
                      altoLinea: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _Etiqueta(textos.observacionEtiquetaQueViste),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _controladorQueVio,
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: esquema.outline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (mostrarChips)
                    SelectorConfianza(
                      confianza: _confianza,
                      alCambiar: (nuevo) =>
                          setState(() => _confianza = nuevo),
                    ),
                  const SizedBox(height: 24),
                  _Etiqueta(textos.editarObservacionEtiquetaDonde),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _controladorDonde,
                    style: TipografiaCuaderno.serif(
                      color: esquema.onSurface,
                      tamano: TipografiaCuaderno.tamano14,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: esquema.outline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _Etiqueta('cómo estaba el tiempo (opcional)'),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _controladorClima,
                    style: TipografiaCuaderno.serif(
                      color: esquema.onSurface,
                      tamano: TipografiaCuaderno.tamano14,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: esquema.outline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton(
                onPressed: _puedeGuardar ? _guardar : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(textos.editarObservacionBotonGuardar),
              ),
            ),
          ],
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
