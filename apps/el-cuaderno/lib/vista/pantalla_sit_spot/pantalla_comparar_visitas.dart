import 'package:flutter/material.dart';

import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Pantalla "Comparar dos visitas" del sit spot. La biblia §3.5 lo
/// dice así: *"si vas siempre a sitios distintos, ves cosas
/// distintas; si vuelves al mismo sitio, ves cómo cambia"*. Esta
/// pantalla pone esa frase en mecánica.
///
/// **Anatomía**:
/// - Cabecera con el nombre del sit spot y una microcopia que enmarca
///   la pedagogía sin imponerla.
/// - Dos columnas lado a lado, cada una con un dropdown para elegir
///   una observación entre las del sit spot y un panel con su
///   contenido (fecha, queVio, creesQueEs/confianza, dibujo no
///   incrustado — esta es lectura comparativa, no editorial).
/// - Si el sit spot tiene menos de dos observaciones, microcopia
///   amable explicando que el comparador necesita al menos dos
///   visitas para tener sentido. Sin reproches.
///
/// Funciona también para sit spots jubilados — comparar dos visitas
/// pasadas tiene tanto sentido como comparar visitas activas. La
/// pantalla no escribe nada al repositorio: es lectura pura.
class PantallaCompararVisitas extends StatefulWidget {
  const PantallaCompararVisitas({
    super.key,
    required this.repositorio,
    required this.sitSpot,
  });

  final RepositorioLocal repositorio;
  final SitSpot sitSpot;

  @override
  State<PantallaCompararVisitas> createState() =>
      _EstadoPantallaCompararVisitas();
}

class _EstadoPantallaCompararVisitas
    extends State<PantallaCompararVisitas> {
  List<Observacion> _observaciones = const [];
  bool _cargando = true;

  /// La columna izquierda y la derecha guardan el id de la
  /// observación elegida. Default razonable: izquierda = la más
  /// antigua, derecha = la más reciente. Así el primer pantallazo ya
  /// dice algo: el principio y el final de lo guardado en este
  /// sitio.
  String? _idIzquierda;
  String? _idDerecha;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await widget.repositorio
        .obtenerObservaciones(sitSpotId: widget.sitSpot.id);
    if (!mounted) return;
    // El repo devuelve por cuandoOcurrio descendente. Para los
    // defaults necesitamos también la primera (la más antigua),
    // que es el último elemento.
    setState(() {
      _observaciones = lista;
      _cargando = false;
      if (lista.length >= 2) {
        _idIzquierda = lista.last.id;
        _idDerecha = lista.first.id;
      }
    });
  }

  Observacion? _obsPorId(String? id) {
    if (id == null) return null;
    for (final obs in _observaciones) {
      if (obs.id == id) return obs;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(textos.compararVisitasTitulo)),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _observaciones.length < 2
                ? _SinSuficientesVisitas(textos: textos, esquema: esquema)
                : _Comparador(
                    nombreSitSpot: widget.sitSpot.nombre,
                    observaciones: _observaciones,
                    obsIzquierda: _obsPorId(_idIzquierda),
                    obsDerecha: _obsPorId(_idDerecha),
                    alElegirIzquierda: (id) =>
                        setState(() => _idIzquierda = id),
                    alElegirDerecha: (id) =>
                        setState(() => _idDerecha = id),
                    textos: textos,
                    esquema: esquema,
                  ),
      ),
    );
  }
}

class _SinSuficientesVisitas extends StatelessWidget {
  const _SinSuficientesVisitas({
    required this.textos,
    required this.esquema,
  });

  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textos.compararVisitasInsuficientesCabecera,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano16,
              peso: TipografiaCuaderno.pesoMedio,
              altoLinea: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            textos.compararVisitasInsuficientesCuerpo,
            style: TipografiaCuaderno.serif(
              color: PaletaCuaderno.tintaTenue,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _Comparador extends StatelessWidget {
  const _Comparador({
    required this.nombreSitSpot,
    required this.observaciones,
    required this.obsIzquierda,
    required this.obsDerecha,
    required this.alElegirIzquierda,
    required this.alElegirDerecha,
    required this.textos,
    required this.esquema,
  });

  final String nombreSitSpot;
  final List<Observacion> observaciones;
  final Observacion? obsIzquierda;
  final Observacion? obsDerecha;
  final void Function(String? id) alElegirIzquierda;
  final void Function(String? id) alElegirDerecha;
  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        Text(
          nombreSitSpot,
          style: TipografiaCuaderno.serif(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano17,
            peso: TipografiaCuaderno.pesoMedio,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          textos.compararVisitasIntro,
          style: TipografiaCuaderno.serif(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano13,
            altoLinea: 1.5,
          ).copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 24),
        // En móvil estrecho las dos columnas no caben — usamos un
        // LayoutBuilder para decidir entre filas (ancho >=600 px) y
        // columnas verticales (ancho <600 px).
        LayoutBuilder(
          builder: (context, constraints) {
            final esAnchoSuficiente = constraints.maxWidth >= 600;
            if (esAnchoSuficiente) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Columna(
                      etiqueta: textos.compararVisitasColumnaIzquierda,
                      observaciones: observaciones,
                      observacionElegida: obsIzquierda,
                      alElegir: alElegirIzquierda,
                      textos: textos,
                      esquema: esquema,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _Columna(
                      etiqueta: textos.compararVisitasColumnaDerecha,
                      observaciones: observaciones,
                      observacionElegida: obsDerecha,
                      alElegir: alElegirDerecha,
                      textos: textos,
                      esquema: esquema,
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                _Columna(
                  etiqueta: textos.compararVisitasColumnaIzquierda,
                  observaciones: observaciones,
                  observacionElegida: obsIzquierda,
                  alElegir: alElegirIzquierda,
                  textos: textos,
                  esquema: esquema,
                ),
                const SizedBox(height: 16),
                _Columna(
                  etiqueta: textos.compararVisitasColumnaDerecha,
                  observaciones: observaciones,
                  observacionElegida: obsDerecha,
                  alElegir: alElegirDerecha,
                  textos: textos,
                  esquema: esquema,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Columna extends StatelessWidget {
  const _Columna({
    required this.etiqueta,
    required this.observaciones,
    required this.observacionElegida,
    required this.alElegir,
    required this.textos,
    required this.esquema,
  });

  final String etiqueta;
  final List<Observacion> observaciones;
  final Observacion? observacionElegida;
  final void Function(String? id) alElegir;
  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: TipografiaCuaderno.sans(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano12,
            peso: TipografiaCuaderno.pesoMedio,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          isExpanded: true,
          value: observacionElegida?.id,
          items: [
            for (final obs in observaciones)
              DropdownMenuItem<String>(
                value: obs.id,
                child: Text(
                  _resumenCorto(obs),
                  overflow: TextOverflow.ellipsis,
                  style: TipografiaCuaderno.serif(
                    color: esquema.onSurface,
                    tamano: TipografiaCuaderno.tamano13,
                  ),
                ),
              ),
          ],
          onChanged: alElegir,
        ),
        const SizedBox(height: 12),
        if (observacionElegida != null)
          _PanelObservacion(
            observacion: observacionElegida!,
            textos: textos,
            esquema: esquema,
          ),
      ],
    );
  }

  static String _resumenCorto(Observacion obs) {
    final fecha = _formatearFecha(obs.cuandoOcurrio);
    final fragmento = obs.queVio.length > 32
        ? '${obs.queVio.substring(0, 32)}…'
        : obs.queVio;
    return '$fecha · $fragmento';
  }
}

class _PanelObservacion extends StatelessWidget {
  const _PanelObservacion({
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
            _formatearFecha(observacion.cuandoOcurrio),
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
            ),
          ),
          const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            Text(
              '${observacion.creesQueEs} · '
              '${observacion.confianza.toLocaleLabel(textos.localeName)}',
              style: TipografiaCuaderno.sans(
                color: esquema.tertiary,
                tamano: TipografiaCuaderno.tamano12,
              ),
            ),
          ],
          if (observacion.climaResumen != null &&
              observacion.climaResumen!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'tiempo: ${observacion.climaResumen}',
              style: TipografiaCuaderno.sans(
                color: esquema.tertiary,
                tamano: TipografiaCuaderno.tamano11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _formatearFecha(DateTime cuando) {
  final dd = cuando.day.toString().padLeft(2, '0');
  final mm = cuando.month.toString().padLeft(2, '0');
  return '$dd/$mm/${cuando.year}';
}
