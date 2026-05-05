import 'dart:io';

import 'package:flutter/material.dart';

import '../../datos/almacenador_medios.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Constructor de imagen — paralelo al de [PantallaDetalleObservacion],
/// reutilizable en tests para evitar el decode async de `Image.file`.
typedef ConstructorImagenLectura = Widget Function(File fichero);

/// Pantalla "Leer tus páginas" — modo lectura tranquilo del cuaderno.
/// Cada observación es una página de un libro: serif grande, padding
/// generoso, sin tarjeta enmarcada — la sensación es la de pasar
/// hojas, no la de mirar una lista.
///
/// Acceso desde [PantallaListaObservaciones] vía un IconButton en el
/// AppBar. Lectura pura — toda la mutación pasa por
/// `PantallaObservacion` desde el home; aquí sólo se relee con calma.
/// El orden es **cronológico descendente** (la más reciente primero,
/// igual que la lista) y la primera vez que se entra arranca en la
/// página 0 (la más reciente).
///
/// Si la observación trae rutas de foto o dibujo, [almacenadorMedios]
/// resuelve la ruta absoluta y [constructorImagen] decide cómo pintar
/// el fichero (default `Image.file`). Sin [almacenadorMedios], los
/// bloques de imagen se omiten — modo S1 / tests aislados.
class PantallaLecturaCuaderno extends StatefulWidget {
  const PantallaLecturaCuaderno({
    super.key,
    required this.repositorio,
    this.almacenadorMedios,
    this.constructorImagen,
  });

  final RepositorioLocal repositorio;
  final AlmacenadorMedios? almacenadorMedios;
  final ConstructorImagenLectura? constructorImagen;

  @override
  State<PantallaLecturaCuaderno> createState() =>
      _EstadoPantallaLecturaCuaderno();
}

class _EstadoPantallaLecturaCuaderno extends State<PantallaLecturaCuaderno> {
  final PageController _controlador = PageController();
  List<Observacion> _observaciones = const [];
  bool _cargando = true;
  int _paginaActual = 0;

  @override
  void initState() {
    super.initState();
    _controlador.addListener(_alCambiarPagina);
    _cargar();
  }

  @override
  void dispose() {
    _controlador.removeListener(_alCambiarPagina);
    _controlador.dispose();
    super.dispose();
  }

  void _alCambiarPagina() {
    final pagina = _controlador.page?.round() ?? 0;
    if (pagina != _paginaActual) {
      setState(() => _paginaActual = pagina);
    }
  }

  Future<void> _cargar() async {
    final observaciones = await widget.repositorio.obtenerObservaciones();
    if (!mounted) return;
    setState(() {
      _observaciones = observaciones;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(textos.lecturaTitulo)),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _observaciones.isEmpty
                ? _BloqueVacio(textos: textos, esquema: esquema)
                : Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _controlador,
                          itemCount: _observaciones.length,
                          itemBuilder: (context, indice) {
                            return _PaginaLectura(
                              observacion: _observaciones[indice],
                              almacenadorMedios: widget.almacenadorMedios,
                              constructorImagen: widget.constructorImagen,
                              textos: textos,
                              esquema: esquema,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          textos.lecturaPaginaIndicador(
                            _paginaActual + 1,
                            _observaciones.length,
                          ),
                          style: TipografiaCuaderno.sans(
                            color: esquema.tertiary,
                            tamano: TipografiaCuaderno.tamano12,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _BloqueVacio extends StatelessWidget {
  const _BloqueVacio({required this.textos, required this.esquema});

  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          textos.lecturaVacioCuerpo,
          textAlign: TextAlign.center,
          style: TipografiaCuaderno.serif(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano14,
            altoLinea: 1.5,
          ),
        ),
      ),
    );
  }
}

class _PaginaLectura extends StatefulWidget {
  const _PaginaLectura({
    required this.observacion,
    required this.almacenadorMedios,
    required this.constructorImagen,
    required this.textos,
    required this.esquema,
  });

  final Observacion observacion;
  final AlmacenadorMedios? almacenadorMedios;
  final ConstructorImagenLectura? constructorImagen;
  final TextosApp textos;
  final ColorScheme esquema;

  @override
  State<_PaginaLectura> createState() => _EstadoPaginaLectura();
}

class _EstadoPaginaLectura extends State<_PaginaLectura> {
  String? _rutaFotoAbsoluta;
  String? _rutaDibujoAbsoluta;

  @override
  void initState() {
    super.initState();
    _resolverMedios();
  }

  Future<void> _resolverMedios() async {
    final almacenador = widget.almacenadorMedios;
    if (almacenador == null) return;
    String? rutaFoto;
    String? rutaDibujo;
    if (widget.observacion.fotoRutaLocal != null) {
      rutaFoto = await almacenador.resolverAbsoluta(
        widget.observacion.fotoRutaLocal!,
      );
    }
    if (widget.observacion.dibujoRutaLocal != null) {
      rutaDibujo = await almacenador.resolverAbsoluta(
        widget.observacion.dibujoRutaLocal!,
      );
    }
    if (!mounted) return;
    setState(() {
      _rutaFotoAbsoluta = rutaFoto;
      _rutaDibujoAbsoluta = rutaDibujo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final obs = widget.observacion;
    final esquema = widget.esquema;
    final textos = widget.textos;
    final fechaFormateada = _formatearFecha(obs.cuandoOcurrio);
    final cabecera = obs.dondeNombre.isEmpty
        ? fechaFormateada
        : '$fechaFormateada · ${obs.dondeNombre}';

    final constructor = widget.constructorImagen ?? _imagenPorDefecto;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cabecera,
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
              peso: TipografiaCuaderno.pesoMedio,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            obs.queVio,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano17,
              altoLinea: 1.55,
            ),
          ),
          if (obs.creesQueEs != null && obs.creesQueEs!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              '${obs.creesQueEs} · '
              '${obs.confianza.toLocaleLabel(textos.localeName)}',
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.tintaTenue,
                tamano: TipografiaCuaderno.tamano14,
                altoLinea: 1.45,
              ),
            ),
          ],
          if (_rutaFotoAbsoluta != null) ...[
            const SizedBox(height: 24),
            Container(
              constraints: const BoxConstraints(maxHeight: 320),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: esquema.outline, width: 0.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: constructor(File(_rutaFotoAbsoluta!)),
            ),
          ],
          if (_rutaDibujoAbsoluta != null) ...[
            const SizedBox(height: 24),
            Container(
              constraints: const BoxConstraints(maxHeight: 320),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: esquema.outline, width: 0.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: constructor(File(_rutaDibujoAbsoluta!)),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatearFecha(DateTime cuando) {
    final dd = cuando.day.toString().padLeft(2, '0');
    final mm = cuando.month.toString().padLeft(2, '0');
    return '$dd/$mm/${cuando.year}';
  }

  static Widget _imagenPorDefecto(File fichero) =>
      Image.file(fichero, fit: BoxFit.cover);
}
