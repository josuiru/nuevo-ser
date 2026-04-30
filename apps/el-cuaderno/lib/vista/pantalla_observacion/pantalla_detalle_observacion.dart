import 'dart:io';

import 'package:flutter/material.dart';

import '../../datos/almacenador_medios.dart';
import '../../dominio/misterio.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pantalla_editar_observacion.dart';

/// Constructor de la miniatura para foto/dibujo. Por defecto
/// `Image.file`. Tests pueden inyectar un `Container()` para evitar el
/// decode async de imágenes que hace colgar el flutter tester.
typedef ConstructorMiniaturaDetalle = Widget Function(File fichero);

/// Pantalla de detalle (lectura) de una observación completa: foto,
/// dibujo, qué viste, qué crees que es + nivel de confianza, anclajes
/// (Misterio/sit spot/coords) y clima si los hay. La inserción y la
/// edición pasan por `PantallaObservacion` — esta pantalla es sólo
/// para releer; el niño puede abrir su anotación de ayer y revisar
/// con calma sin riesgo de tocarla.
///
/// Si la observación trae [Observacion.misterioId] o
/// [Observacion.sitSpotId] no nulos, se consulta al [repositorio] para
/// resolver el nombre legible (la pregunta del Misterio o el nombre del
/// sit spot) y se muestra en línea bajo el texto principal. Si la
/// resolución falla porque la entidad ya no existe, se omite el bloque
/// — la observación sigue legible.
///
/// Si la observación trae rutas de foto o dibujo, [almacenadorMedios]
/// resuelve la ruta absoluta y [constructorMiniatura] decide cómo
/// pintar el fichero (default `Image.file`). Si [almacenadorMedios] es
/// null, los bloques de imagen se omiten — modo S1 / tests aislados.
class PantallaDetalleObservacion extends StatefulWidget {
  const PantallaDetalleObservacion({
    super.key,
    required this.repositorio,
    required this.observacion,
    this.almacenadorMedios,
    this.constructorMiniatura,
  });

  final RepositorioLocal repositorio;
  final Observacion observacion;
  final AlmacenadorMedios? almacenadorMedios;
  final ConstructorMiniaturaDetalle? constructorMiniatura;

  @override
  State<PantallaDetalleObservacion> createState() =>
      _EstadoPantallaDetalleObservacion();
}

class _EstadoPantallaDetalleObservacion
    extends State<PantallaDetalleObservacion> {
  late Observacion _observacion;
  Misterio? _misterio;
  SitSpot? _sitSpot;
  String? _rutaFotoAbsoluta;
  String? _rutaDibujoAbsoluta;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _observacion = widget.observacion;
    _resolverDependencias();
  }

  Future<void> _editar() async {
    final actualizada = await Navigator.of(context).push<Observacion>(
      MaterialPageRoute(
        builder: (_) => PantallaEditarObservacion(
          repositorio: widget.repositorio,
          observacion: _observacion,
        ),
      ),
    );
    if (actualizada == null || !mounted) return;
    setState(() {
      _observacion = actualizada;
      _cargando = true;
    });
    await _resolverDependencias();
  }

  Future<void> _confirmarBorrar() async {
    final navegador = Navigator.of(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('Borrar este registro'),
        content: const Text(
          'Vas a borrar esta página del cuaderno. La foto y el dibujo, '
          'si los tenía, también se borrarán. No se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogo).pop(false),
            child: const Text('cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogo).pop(true),
            child: const Text('borrar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    await widget.repositorio.borrarObservacion(_observacion.id);
    final almacenador = widget.almacenadorMedios;
    final obs = _observacion;
    if (almacenador != null) {
      if (obs.fotoRutaLocal != null) {
        await almacenador.borrar(obs.fotoRutaLocal!);
      }
      if (obs.dibujoRutaLocal != null) {
        await almacenador.borrar(obs.dibujoRutaLocal!);
      }
    }
    if (!mounted) return;
    navegador.pop();
  }

  Future<void> _resolverDependencias() async {
    final obs = _observacion;
    Misterio? misterio;
    SitSpot? sitSpot;
    String? rutaFoto;
    String? rutaDibujo;

    if (obs.misterioId != null) {
      final abiertos = await widget.repositorio.obtenerMisteriosAbiertos();
      misterio = abiertos.firstWhere(
        (m) => m.id == obs.misterioId,
        orElse: () => Misterio(
          id: obs.misterioId!,
          pregunta: '—',
          descripcionCorta: '—',
          estado: obs.confianza,
          abierto: false,
        ),
      );
      // Si vino del fallback (pregunta '—'), preferimos no mostrar
      // nada para no confundir al niño con un guion suelto.
      if (misterio.pregunta == '—') misterio = null;
    }
    if (obs.sitSpotId != null) {
      final activo = await widget.repositorio.obtenerSitSpot();
      if (activo != null && activo.id == obs.sitSpotId) {
        sitSpot = activo;
      } else {
        final jubilados =
            await widget.repositorio.obtenerSitSpotsJubilados();
        for (final s in jubilados) {
          if (s.id == obs.sitSpotId) {
            sitSpot = s;
            break;
          }
        }
      }
    }
    final almacenador = widget.almacenadorMedios;
    if (almacenador != null) {
      if (obs.fotoRutaLocal != null) {
        rutaFoto = await almacenador.resolverAbsoluta(obs.fotoRutaLocal!);
      }
      if (obs.dibujoRutaLocal != null) {
        rutaDibujo = await almacenador.resolverAbsoluta(obs.dibujoRutaLocal!);
      }
    }

    if (!mounted) return;
    setState(() {
      _misterio = misterio;
      _sitSpot = sitSpot;
      _rutaFotoAbsoluta = rutaFoto;
      _rutaDibujoAbsoluta = rutaDibujo;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    final obs = _observacion;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página del cuaderno'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'opciones de la página',
            icon: const Icon(Icons.more_vert),
            onSelected: (valor) {
              if (valor == 'editar') _editar();
              if (valor == 'borrar') _confirmarBorrar();
            },
            itemBuilder: (_) => const [
              PopupMenuItem<String>(
                value: 'editar',
                child: Text('editar este registro'),
              ),
              PopupMenuItem<String>(
                value: 'borrar',
                child: Text('borrar este registro'),
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
                    _cabeceraFecha(obs.cuandoOcurrio, obs.dondeNombre),
                    style: TipografiaCuaderno.sans(
                      color: esquema.tertiary,
                      tamano: TipografiaCuaderno.tamano12,
                      peso: TipografiaCuaderno.pesoMedio,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_rutaFotoAbsoluta != null)
                    _BloqueImagen(
                      rutaAbsoluta: _rutaFotoAbsoluta!,
                      etiqueta: 'foto',
                      esquema: esquema,
                      constructor: widget.constructorMiniatura,
                    ),
                  if (_rutaDibujoAbsoluta != null) ...[
                    const SizedBox(height: 12),
                    _BloqueImagen(
                      rutaAbsoluta: _rutaDibujoAbsoluta!,
                      etiqueta: 'dibujo',
                      esquema: esquema,
                      constructor: widget.constructorMiniatura,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    obs.queVio,
                    style: TipografiaCuaderno.serif(
                      color: esquema.onSurface,
                      tamano: TipografiaCuaderno.tamano16,
                      altoLinea: 1.5,
                    ),
                  ),
                  if (obs.creesQueEs != null &&
                      obs.creesQueEs!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      '${obs.creesQueEs} · '
                      '${obs.confianza.toLocaleLabel(textos.localeName)}',
                      style: TipografiaCuaderno.sans(
                        color: esquema.tertiary,
                        tamano: TipografiaCuaderno.tamano13,
                      ),
                    ),
                  ],
                  if (obs.climaResumen != null &&
                      obs.climaResumen!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'tiempo: ${obs.climaResumen}',
                      style: TipografiaCuaderno.sans(
                        color: esquema.tertiary,
                        tamano: TipografiaCuaderno.tamano12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _SeccionAnclajes(
                    misterio: _misterio,
                    sitSpot: _sitSpot,
                    tieneCoordenadas: obs.dondeCoordenadas != null,
                    esquema: esquema,
                  ),
                ],
              ),
      ),
    );
  }

  static String _cabeceraFecha(DateTime cuando, String donde) {
    final dd = cuando.day.toString().padLeft(2, '0');
    final mm = cuando.month.toString().padLeft(2, '0');
    final fecha = '$dd/$mm/${cuando.year}';
    if (donde.isEmpty) return fecha;
    return '$fecha · ${donde.toLowerCase()}';
  }
}

class _BloqueImagen extends StatelessWidget {
  const _BloqueImagen({
    required this.rutaAbsoluta,
    required this.etiqueta,
    required this.esquema,
    this.constructor,
  });

  final String rutaAbsoluta;
  final String etiqueta;
  final ColorScheme esquema;
  final ConstructorMiniaturaDetalle? constructor;

  @override
  Widget build(BuildContext context) {
    final fichero = File(rutaAbsoluta);
    final hijo = constructor != null
        ? constructor!(fichero)
        : Image.file(fichero, fit: BoxFit.cover);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: esquema.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: esquema.outline, width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: hijo,
        ),
        const SizedBox(height: 4),
        Text(
          etiqueta,
          style: TipografiaCuaderno.sans(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano12,
          ),
        ),
      ],
    );
  }
}

class _SeccionAnclajes extends StatelessWidget {
  const _SeccionAnclajes({
    required this.misterio,
    required this.sitSpot,
    required this.tieneCoordenadas,
    required this.esquema,
  });

  final Misterio? misterio;
  final SitSpot? sitSpot;
  final bool tieneCoordenadas;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    final filas = <Widget>[];
    if (misterio != null) {
      filas.add(_Fila(
        icono: Icons.help_outline,
        texto: 'anclada al misterio: ${misterio!.pregunta}',
        esquema: esquema,
      ));
    }
    if (sitSpot != null) {
      filas.add(_Fila(
        icono: Icons.place_outlined,
        texto: 'anotada en ${sitSpot!.nombre}',
        esquema: esquema,
      ));
    }
    if (tieneCoordenadas) {
      filas.add(_Fila(
        icono: Icons.my_location_outlined,
        texto: 'posición anclada (sólo en este cuaderno, no sale a internet)',
        esquema: esquema,
      ));
    }
    if (filas.isEmpty) return const SizedBox.shrink();

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
          for (var indice = 0; indice < filas.length; indice++) ...[
            filas[indice],
            if (indice < filas.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila({
    required this.icono,
    required this.texto,
    required this.esquema,
  });

  final IconData icono;
  final String texto;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 16, color: PaletaCuaderno.tintaTenue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano13,
              altoLinea: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
