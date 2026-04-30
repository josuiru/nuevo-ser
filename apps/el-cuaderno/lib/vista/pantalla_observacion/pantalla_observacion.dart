import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../datos/almacenador_medios.dart';
import '../../datos/selector_imagen.dart';
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
    this.alGuardarObservacion,
    this.selectorImagen,
    this.almacenadorMedios,
    this.constructorMiniatura,
    DateTime Function()? proveedorAhora,
    String Function()? proveedorIds,
  })  : _proveedorAhora = proveedorAhora ?? DateTime.now,
        _proveedorIds = proveedorIds ?? _generarUuid;

  final RepositorioLocal repositorio;
  final List<Misterio> misteriosAbiertos;
  final SitSpot? sitSpotActivo;
  final String? misterioPreseleccionadoId;

  /// Invocado tras persistir la observación en el repositorio. El
  /// orquestador lo cablea a la cola de sync para que la observación
  /// recién creada quede como pendiente de subir al backend (cuando
  /// haya token y el adulto pulse "Sincronizar"). Si es null, la
  /// observación se guarda sólo en local (modo S1, tests, demo).
  final Future<void> Function(Observacion observacion)? alGuardarObservacion;

  /// Picker de cámara/galería para anclar una foto a la observación.
  /// Si es null, los botones de foto no aparecen (modo S1, tests que
  /// no quieren simular el flujo de imagen).
  final SelectorImagen? selectorImagen;

  /// Almacenador que mueve la foto seleccionada al directorio privado
  /// de la app. Requerido si [selectorImagen] no es null.
  final AlmacenadorMedios? almacenadorMedios;

  /// Constructor de la miniatura. Por defecto `Image.file`. Tests
  /// pueden inyectar un `Container()` para evitar el decode async
  /// que cuelga el flutter tester con `Future.then` pendientes.
  final Widget Function(File fichero)? constructorMiniatura;

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

  /// Ruta absoluta de la foto seleccionada por el niño (cámara o
  /// galería). Solo es válida durante la sesión de la pantalla; al
  /// pulsar "Guardar" se mueve al directorio de medios y la ruta
  /// **relativa** se persiste en `Observacion.fotoRutaLocal`.
  String? _rutaFotoTemporal;
  bool _seleccionandoFoto = false;

  /// Id estable de esta observación. Se genera al montar la pantalla
  /// para que el almacenador de medios pueda nombrar el fichero con
  /// él incluso cuando todavía no se ha llamado a `_guardar`. Si el
  /// niño se vuelve atrás, la foto temporal queda huérfana en el
  /// directorio de medios — A5 (export v2) ya hace una verificación
  /// de "fichero apuntado existe".
  late final String _idObservacion;

  @override
  void initState() {
    super.initState();
    _controladorQueViste = TextEditingController();
    _controladorCreesQueEs = TextEditingController();
    _confianza = NivelConfianza.hipotesisActiva;
    _misterioId = widget.misterioPreseleccionadoId;
    _idObservacion = widget._proveedorIds();

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
                  _CajaFotoDibujo(
                    textos: textos,
                    selectorImagen: widget.selectorImagen,
                    rutaFoto: _rutaFotoTemporal,
                    cargando: _seleccionandoFoto,
                    alTomarFoto: widget.selectorImagen == null
                        ? null
                        : () => _capturarFoto(_OrigenFoto.camara),
                    alElegirFoto: widget.selectorImagen == null
                        ? null
                        : () => _capturarFoto(_OrigenFoto.galeria),
                    alQuitarFoto: _rutaFotoTemporal == null
                        ? null
                        : _quitarFoto,
                    constructorMiniatura: widget.constructorMiniatura,
                  ),
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

  Future<void> _capturarFoto(_OrigenFoto origen) async {
    final selector = widget.selectorImagen;
    final almacenador = widget.almacenadorMedios;
    if (selector == null || almacenador == null) return;

    setState(() => _seleccionandoFoto = true);
    try {
      final rutaOrigen = origen == _OrigenFoto.camara
          ? await selector.desdeCamara()
          : await selector.desdeGaleria();
      if (rutaOrigen == null) return;

      // Copiamos al directorio privado de la app aunque el niño
      // todavía no haya pulsado "Guardar". Si se vuelve atrás, la
      // foto queda huérfana — A5 (export v2) y la limpieza programada
      // se encargan de los huérfanos. La ventaja de copiar ya: la
      // miniatura sale del fichero estable, no del path del picker
      // que puede caducar.
      final rutaRelativa = await almacenador.guardar(
        rutaOrigen: rutaOrigen,
        observacionId: _idObservacion,
        tipo: TipoMedio.foto,
      );
      final rutaAbsoluta = await almacenador.resolverAbsoluta(rutaRelativa);
      if (!mounted) return;
      setState(() => _rutaFotoTemporal = rutaAbsoluta);
    } finally {
      if (mounted) {
        setState(() => _seleccionandoFoto = false);
      }
    }
  }

  Future<void> _quitarFoto() async {
    final almacenador = widget.almacenadorMedios;
    final rutaActual = _rutaFotoTemporal;
    if (almacenador == null || rutaActual == null) return;
    setState(() => _rutaFotoTemporal = null);
    // Borramos el fichero copiado del directorio privado. Si el niño
    // vuelve a tomar una foto, se generará otra con el mismo nombre.
    final rutaRelativa = '${AlmacenadorMedios.subdirectorioMedios}/'
        '${_idObservacion}_${TipoMedio.foto.sufijo}'
        '${_extraerExtensionDe(rutaActual)}';
    await almacenador.borrar(rutaRelativa);
  }

  String _extraerExtensionDe(String ruta) {
    final ultimoPunto = ruta.lastIndexOf('.');
    final ultimaBarra = ruta.lastIndexOf('/');
    if (ultimoPunto > ultimaBarra && ultimoPunto < ruta.length - 1) {
      return ruta.substring(ultimoPunto).toLowerCase();
    }
    return TipoMedio.foto.extensionPredeterminada;
  }

  Future<void> _guardar() async {
    final queViste = _controladorQueViste.text.trim();
    final creesQueEs = _controladorCreesQueEs.text.trim();
    final ahora = widget._proveedorAhora();

    // La ruta persistida es **relativa** al directorio de documentos —
    // sobrevive a cambios del sandbox UUID en Android y a un export/
    // import del cuaderno (A5).
    String? rutaFotoRelativa;
    final rutaAbsoluta = _rutaFotoTemporal;
    final almacenador = widget.almacenadorMedios;
    if (rutaAbsoluta != null && almacenador != null) {
      final dirRaiz = await almacenador.resolverAbsoluta('');
      // dirRaiz incluye trailing slash; recortamos para obtener la
      // ruta relativa.
      final prefijo = dirRaiz.endsWith('/') ? dirRaiz : '$dirRaiz/';
      if (rutaAbsoluta.startsWith(prefijo)) {
        rutaFotoRelativa = rutaAbsoluta.substring(prefijo.length);
      }
    }

    final observacion = Observacion(
      id: _idObservacion,
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
      fotoRutaLocal: rutaFotoRelativa,
    );

    await widget.repositorio.guardarObservacion(observacion);
    if (_misterioId != null) {
      await widget.repositorio.anclarObservacionAMisterio(
        observacion.id,
        _misterioId!,
      );
    }
    await widget.alGuardarObservacion?.call(observacion);
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

/// Caja de foto/dibujo de la pantalla de Nueva Observación.
///
/// Tres modos según el estado:
/// 1. **Sin selector cableado**: muestra el placeholder informativo
///    (modo S1, tests que no inyectan `SelectorImagen`).
/// 2. **Cargando**: spinner mientras `_capturarFoto` se ejecuta.
/// 3. **Con foto**: muestra la miniatura + un botón "quitar foto"
///    discreto.
/// 4. **Sin foto pero selector disponible**: dos botones lado a lado
///    "tomar foto" y "elegir foto" + un placeholder corto debajo.
class _CajaFotoDibujo extends StatelessWidget {
  const _CajaFotoDibujo({
    required this.textos,
    required this.selectorImagen,
    required this.rutaFoto,
    required this.cargando,
    required this.alTomarFoto,
    required this.alElegirFoto,
    required this.alQuitarFoto,
    required this.constructorMiniatura,
  });

  final TextosApp textos;
  final SelectorImagen? selectorImagen;
  final String? rutaFoto;
  final bool cargando;
  final VoidCallback? alTomarFoto;
  final VoidCallback? alElegirFoto;
  final VoidCallback? alQuitarFoto;
  final Widget Function(File fichero)? constructorMiniatura;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    if (selectorImagen == null) {
      return _CajaInformativa(textos: textos);
    }
    if (cargando) {
      return Container(
        height: 110,
        decoration: BoxDecoration(
          color: esquema.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (rutaFoto != null) {
      return _CajaConFoto(
        rutaAbsoluta: rutaFoto!,
        alQuitarFoto: alQuitarFoto,
        textos: textos,
        constructorMiniatura: constructorMiniatura,
      );
    }
    return _CajaBotones(
      textos: textos,
      alTomarFoto: alTomarFoto,
      alElegirFoto: alElegirFoto,
    );
  }
}

class _CajaInformativa extends StatelessWidget {
  const _CajaInformativa({required this.textos});

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

class _CajaBotones extends StatelessWidget {
  const _CajaBotones({
    required this.textos,
    required this.alTomarFoto,
    required this.alElegirFoto,
  });

  final TextosApp textos;
  final VoidCallback? alTomarFoto;
  final VoidCallback? alElegirFoto;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: esquema.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: alTomarFoto,
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: Text(textos.observacionFotoTomar),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: alElegirFoto,
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: Text(textos.observacionFotoElegir),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            textos.observacionCajaPlaceholder,
            textAlign: TextAlign.center,
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

class _CajaConFoto extends StatelessWidget {
  const _CajaConFoto({
    required this.rutaAbsoluta,
    required this.alQuitarFoto,
    required this.textos,
    required this.constructorMiniatura,
  });

  final String rutaAbsoluta;
  final VoidCallback? alQuitarFoto;
  final TextosApp textos;
  final Widget Function(File fichero)? constructorMiniatura;

  @override
  Widget build(BuildContext context) {
    final fichero = File(rutaAbsoluta);
    final miniatura = constructorMiniatura?.call(fichero) ??
        Image.file(
          fichero,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        );
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: miniatura,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: textos.observacionFotoQuitar,
              onPressed: alQuitarFoto,
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
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

enum _OrigenFoto { camara, galeria }

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
