import 'package:flutter/material.dart';

import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Listado completo de observaciones con filtro de texto. La pantalla
/// principal del home muestra sólo la última como tarjeta destacada;
/// para releer las anteriores el niño abre esta pantalla y opcionalmente
/// filtra por una palabra (qué vio, qué cree que es, dónde estaba).
///
/// Filtro **case-insensitive** sobre tres campos: `queVio`, `creesQueEs`
/// y `dondeNombre`. Sin operadores complejos, sin búsqueda fuzzy — el
/// niño escribe lo que recuerda y aparece lo que coincida.
///
/// Lectura pura — toda la mutación pasa por `PantallaObservacion` desde
/// el home. Aquí sólo se relee.
class PantallaListaObservaciones extends StatefulWidget {
  const PantallaListaObservaciones({
    super.key,
    required this.repositorio,
  });

  final RepositorioLocal repositorio;

  @override
  State<PantallaListaObservaciones> createState() =>
      _EstadoPantallaListaObservaciones();
}

class _EstadoPantallaListaObservaciones
    extends State<PantallaListaObservaciones> {
  final TextEditingController _controladorBusqueda = TextEditingController();
  List<Observacion> _todas = const [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
    _controladorBusqueda.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final observaciones = await widget.repositorio.obtenerObservaciones();
    if (!mounted) return;
    setState(() {
      _todas = observaciones;
      _cargando = false;
    });
  }

  /// Filtro case-insensitive **y accent-insensitive** sobre los tres
  /// campos textuales. El niño que escribe "pajaro" sin la tilde
  /// debería encontrar "pájaro"; el que escribe "PEQUEÑO" en
  /// mayúsculas debería encontrar "pequeño". Comparamos substrings,
  /// no ordenamos — basta con un mapeo a-z para los acentos comunes
  /// del castellano + ñ/ç. Sin librería de Unicode folding (overkill).
  List<Observacion> get _filtradas {
    final consulta = _normalizar(_controladorBusqueda.text);
    if (consulta.isEmpty) return _todas;
    return _todas.where((obs) {
      final que = _normalizar(obs.queVio);
      final donde = _normalizar(obs.dondeNombre);
      final crees = _normalizar(obs.creesQueEs ?? '');
      return que.contains(consulta) ||
          donde.contains(consulta) ||
          crees.contains(consulta);
    }).toList();
  }

  static String _normalizar(String texto) {
    final base = texto.trim().toLowerCase();
    if (base.isEmpty) return base;
    final buffer = StringBuffer();
    for (final caracter in base.runes) {
      switch (caracter) {
        case 0x00E1: // á
        case 0x00E0: // à
        case 0x00E4: // ä
        case 0x00E2: // â
          buffer.writeCharCode(0x61); // a
        case 0x00E9: // é
        case 0x00E8: // è
        case 0x00EB: // ë
        case 0x00EA: // ê
          buffer.writeCharCode(0x65); // e
        case 0x00ED: // í
        case 0x00EC: // ì
        case 0x00EF: // ï
        case 0x00EE: // î
          buffer.writeCharCode(0x69); // i
        case 0x00F3: // ó
        case 0x00F2: // ò
        case 0x00F6: // ö
        case 0x00F4: // ô
          buffer.writeCharCode(0x6F); // o
        case 0x00FA: // ú
        case 0x00F9: // ù
        case 0x00FC: // ü
        case 0x00FB: // û
          buffer.writeCharCode(0x75); // u
        case 0x00F1: // ñ
          buffer.writeCharCode(0x6E); // n
        case 0x00E7: // ç
          buffer.writeCharCode(0x63); // c
        default:
          buffer.writeCharCode(caracter);
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    final filtradas = _filtradas;

    return Scaffold(
      appBar: AppBar(title: const Text('Todas tus páginas')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _controladorBusqueda,
                decoration: InputDecoration(
                  hintText: 'busca por algo que recuerdes',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controladorBusqueda.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'limpiar búsqueda',
                          onPressed: _controladorBusqueda.clear,
                        ),
                  filled: true,
                  fillColor: esquema.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : _Contenido(
                      total: _todas.length,
                      filtradas: filtradas,
                      hayBusquedaActiva:
                          _controladorBusqueda.text.trim().isNotEmpty,
                      esquema: esquema,
                      textos: textos,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({
    required this.total,
    required this.filtradas,
    required this.hayBusquedaActiva,
    required this.esquema,
    required this.textos,
  });

  final int total;
  final List<Observacion> filtradas;
  final bool hayBusquedaActiva;
  final ColorScheme esquema;
  final TextosApp textos;

  @override
  Widget build(BuildContext context) {
    if (total == 0) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Aún no has anotado nada. Cuando lo hagas, aparecerá aquí.',
          textAlign: TextAlign.center,
          style: TipografiaCuaderno.serif(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano14,
            altoLinea: 1.5,
          ),
        ),
      );
    }
    if (filtradas.isEmpty && hayBusquedaActiva) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Ninguna página guarda eso. Prueba con otra palabra.',
          textAlign: TextAlign.center,
          style: TipografiaCuaderno.serif(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano14,
            altoLinea: 1.5,
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: filtradas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, indice) => _TarjetaObservacion(
        observacion: filtradas[indice],
        esquema: esquema,
        textos: textos,
      ),
    );
  }
}

class _TarjetaObservacion extends StatelessWidget {
  const _TarjetaObservacion({
    required this.observacion,
    required this.esquema,
    required this.textos,
  });

  final Observacion observacion;
  final ColorScheme esquema;
  final TextosApp textos;

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
              '${observacion.creesQueEs} · ${observacion.confianza.toLocaleLabel(textos.localeName)}',
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
