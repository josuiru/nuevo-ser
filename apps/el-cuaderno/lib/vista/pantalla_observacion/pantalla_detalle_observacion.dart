import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../datos/almacenador_medios.dart';
import '../../dominio/atlas.dart';
import '../../dominio/contexto_misterio.dart';
import '../../dominio/exportador_cuaderno_pdf.dart' show CargarMedioPdf;
import '../../dominio/fenologia.dart';
import '../../dominio/generador_observacion_pdf.dart';
import '../../dominio/misterio.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';
import '../../dominio/sugeridor_misterio.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'chip_sugerencia_misterio.dart';
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
///
/// [proveedorAhora] permite a los tests congelar la fecha del aviso
/// "vuelve en X" para Misterios fuera de temporada. En producción se
/// queda como `DateTime.now`.
class PantallaDetalleObservacion extends StatefulWidget {
  const PantallaDetalleObservacion({
    super.key,
    required this.repositorio,
    required this.observacion,
    this.almacenadorMedios,
    this.constructorMiniatura,
    this.proveedorAhora,
    this.nombrePerfilActivo,
    this.cargarMedioParaPdf,
    this.lanzadorPdf,
    this.lanzadorCompartirFoto,
  });

  final RepositorioLocal repositorio;
  final Observacion observacion;
  final AlmacenadorMedios? almacenadorMedios;
  final ConstructorMiniaturaDetalle? constructorMiniatura;
  final DateTime Function()? proveedorAhora;

  /// Nombre del perfil activo para el pie del PDF de la observación
  /// — *"Cuaderno de campo · {nombre}"*. Si null o vacío, el pie cae
  /// al genérico "Cuaderno de campo".
  final String? nombrePerfilActivo;

  /// Resuelve los bytes de un fichero medio (foto/dibujo) por su ruta
  /// relativa para incrustarlo en el PDF de la observación. Si null,
  /// el botón "compartir esta página" sigue activo pero el PDF se
  /// genera sólo con texto. Misma firma que `ExportadorCuadernoPdf`.
  final CargarMedioPdf? cargarMedioParaPdf;

  /// Inyectable para tests del flujo "compartir esta página". Recibe
  /// los bytes del PDF y los lleva al SO. Si null, usa
  /// `Printing.layoutPdf` real.
  final Future<void> Function(Uint8List bytes)? lanzadorPdf;

  /// Inyectable para tests del flujo "compartir foto al adulto".
  /// Recibe la ruta absoluta de la foto y dispara el sheet del SO.
  /// Si null, usa `SharePlus.instance.share` real con la microcopia
  /// del cuaderno como texto acompañante.
  final Future<void> Function({
    required String rutaAbsolutaFoto,
    required String texto,
  })? lanzadorCompartirFoto;

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

  /// Misterio sugerido para anclar a esta observación si todavía no
  /// tiene `misterioId`. Se calcula con [sugerirMisterio] sobre el
  /// `queVio` y los Misterios abiertos del repositorio. Null si la
  /// observación ya está anclada, si la heurística no encuentra
  /// match, o si el niño rechazó la sugerencia en esta sesión.
  Misterio? _sugerencia;

  /// Ids de sugerencias rechazadas en esta sesión de la pantalla
  /// detalle. Se mantienen mientras la pantalla viva — al cerrar y
  /// volver, el sistema vuelve a intentar.
  final Set<String> _sugerenciasRechazadas = <String>{};

  /// Próxima estación en la que el Misterio anclado volverá a aplicar
  /// si hoy NO aplica (estación distinta). Null si aplica hoy, si es
  /// atemporal o si el Misterio queda fuera por región (ahí "vuelve
  /// en X" no es la respuesta — no va a aplicar nunca aquí).
  Estacion? _proximaEstacionMisterio;

  /// True si esta observación es la primera del cuaderno con su
  /// `creesQueEs` normalizado. Activa la microcopia "primera vez"
  /// bajo el bloque de identificación. Se calcula contra la lista
  /// completa de observaciones del repo, así que es coherente con el
  /// listado de "Tus primeras veces" del atlas.
  bool _esPrimeraVezDeIdentificacion = false;

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

  Future<void> _compartirComoPdf() async {
    final bytes = await GeneradorObservacionPdf.aBytes(
      observacion: _observacion,
      nombreDelNino: widget.nombrePerfilActivo,
      nombreSitSpot: _sitSpot?.nombre,
      cargarMedio: widget.cargarMedioParaPdf,
    );
    final lanzador = widget.lanzadorPdf ?? _lanzadorPdfPorDefecto;
    await lanzador(bytes);
  }

  Future<void> _lanzadorPdfPorDefecto(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  Future<void> _compartirFotoConAdulto() async {
    final ruta = _rutaFotoAbsoluta;
    if (ruta == null) return;
    final textos = TextosApp.of(context);
    final lanzador =
        widget.lanzadorCompartirFoto ?? _lanzadorCompartirFotoPorDefecto;
    await lanzador(
      rutaAbsolutaFoto: ruta,
      texto: textos.detalleCompartirFotoTextoAdjunto,
    );
  }

  Future<void> _lanzadorCompartirFotoPorDefecto({
    required String rutaAbsolutaFoto,
    required String texto,
  }) async {
    await Share.shareXFiles(
      [XFile(rutaAbsolutaFoto)],
      text: texto,
    );
  }

  Future<void> _confirmarBorrar() async {
    final navegador = Navigator.of(context);
    final textos = TextosApp.of(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: Text(textos.detalleObservacionBorrarTitulo),
        content: Text(textos.detalleObservacionBorrarMensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogo).pop(false),
            child: Text(textos.detalleObservacionBorrarCancelar),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogo).pop(true),
            child: Text(textos.detalleObservacionBorrarConfirmar),
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

    Misterio? sugerencia;
    if (obs.misterioId == null && obs.queVio.isNotEmpty) {
      final abiertos = await widget.repositorio.obtenerMisteriosAbiertos();
      final candidatos = abiertos
          .where((m) => !_sugerenciasRechazadas.contains(m.id))
          .toList(growable: false);
      sugerencia = sugerirMisterio(
        queVio: obs.queVio,
        candidatos: candidatos,
      );
    }

    Estacion? proximaEstacion;
    if (misterio != null) {
      final ahora = (widget.proveedorAhora ?? DateTime.now)();
      final estacionActual = estacionDeFecha(ahora);
      proximaEstacion = proximaEstacionDeAplicabilidad(
        misterio,
        estacionActual: estacionActual,
      );
    }

    // Calcular "primera vez" contra el repositorio completo. La
    // identificación normalizada se compara con todas las
    // observaciones; si esta es la más temprana con esa
    // identificación, encendemos el flag.
    final identificacion = obs.creesQueEs?.trim() ?? '';
    bool esPrimeraVez = false;
    if (identificacion.isNotEmpty) {
      final todas =
          await widget.repositorio.obtenerObservaciones(limite: 5000);
      esPrimeraVez = Atlas.esPrimeraVezDeIdentificacion(obs, todas);
    }

    if (!mounted) return;
    setState(() {
      _misterio = misterio;
      _sitSpot = sitSpot;
      _rutaFotoAbsoluta = rutaFoto;
      _rutaDibujoAbsoluta = rutaDibujo;
      _sugerencia = sugerencia;
      _proximaEstacionMisterio = proximaEstacion;
      _esPrimeraVezDeIdentificacion = esPrimeraVez;
      _cargando = false;
    });
  }

  Future<void> _anclarSugerido(Misterio sugerido) async {
    await widget.repositorio.anclarObservacionAMisterio(
      _observacion.id,
      sugerido.id,
    );
    if (!mounted) return;
    setState(() {
      _observacion = _observacion.copyWith(misterioId: sugerido.id);
      _sugerencia = null;
    });
    await _resolverDependencias();
  }

  void _rechazarSugerido(Misterio sugerido) {
    setState(() {
      _sugerenciasRechazadas.add(sugerido.id);
      _sugerencia = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    final obs = _observacion;

    return Scaffold(
      appBar: AppBar(
        title: Text(textos.detalleObservacionTitulo),
        actions: [
          PopupMenuButton<String>(
            tooltip: textos.detalleObservacionTooltipOpciones,
            icon: const Icon(Icons.more_vert),
            onSelected: (valor) {
              if (valor == 'editar') _editar();
              if (valor == 'compartir') _compartirComoPdf();
              if (valor == 'compartir-foto') _compartirFotoConAdulto();
              if (valor == 'borrar') _confirmarBorrar();
            },
            itemBuilder: (_) => [
              PopupMenuItem<String>(
                value: 'editar',
                child: Text(textos.detalleObservacionMenuEditar),
              ),
              PopupMenuItem<String>(
                value: 'compartir',
                child: Text(textos.detalleObservacionMenuCompartirPdf),
              ),
              if (_rutaFotoAbsoluta != null)
                PopupMenuItem<String>(
                  value: 'compartir-foto',
                  child: Text(textos.detalleCompartirFotoOpcion),
                ),
              PopupMenuItem<String>(
                value: 'borrar',
                child: Text(textos.detalleObservacionMenuBorrar),
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
                    if (_esPrimeraVezDeIdentificacion) ...[
                      const SizedBox(height: 6),
                      Text(
                        textos.detalleObservacionPrimeraVez,
                        style: TipografiaCuaderno.serif(
                          color: PaletaCuaderno.tintaTenue,
                          tamano: TipografiaCuaderno.tamano12,
                          altoLinea: 1.4,
                        ).copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
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
                  if (_sugerencia != null) ...[
                    const SizedBox(height: 16),
                    ChipSugerenciaMisterio(
                      misterioSugerido: _sugerencia!,
                      alAnclar: () => _anclarSugerido(_sugerencia!),
                      alRechazar: () => _rechazarSugerido(_sugerencia!),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _SeccionAnclajes(
                    misterio: _misterio,
                    proximaEstacionMisterio: _proximaEstacionMisterio,
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
    required this.proximaEstacionMisterio,
    required this.sitSpot,
    required this.tieneCoordenadas,
    required this.esquema,
  });

  final Misterio? misterio;
  final Estacion? proximaEstacionMisterio;
  final SitSpot? sitSpot;
  final bool tieneCoordenadas;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final filas = <Widget>[];
    if (misterio != null) {
      filas.add(_Fila(
        icono: Icons.help_outline,
        texto:
            'anclada al misterio: ${misterio!.preguntaEn(textos.localeName)}',
        esquema: esquema,
        subtexto: proximaEstacionMisterio != null
            ? 'vuelve en ${_nombreEstacion(proximaEstacionMisterio!)}'
            : null,
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
    this.subtexto,
  });

  final IconData icono;
  final String texto;
  final ColorScheme esquema;
  final String? subtexto;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 16, color: PaletaCuaderno.tintaTenue),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texto,
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano13,
                  altoLinea: 1.4,
                ),
              ),
              if (subtexto != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtexto!,
                  style: TipografiaCuaderno.serif(
                    color: PaletaCuaderno.tintaTenue,
                    tamano: TipografiaCuaderno.tamano12,
                    altoLinea: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

String _nombreEstacion(Estacion estacion) {
  switch (estacion) {
    case Estacion.primavera:
      return 'primavera';
    case Estacion.verano:
      return 'verano';
    case Estacion.otono:
      return 'otoño';
    case Estacion.invierno:
      return 'invierno';
  }
}
