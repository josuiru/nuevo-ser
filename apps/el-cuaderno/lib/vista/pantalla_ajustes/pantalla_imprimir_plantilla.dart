import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../dominio/generador_plantilla_pdf.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Pantalla "Imprimir páginas en blanco para el campo". Genera un
/// PDF con N páginas en blanco que el adulto puede imprimir y la
/// niña se lleva al campo. La promesa de la biblia §2.8
/// (offline-first) deja de ser sólo arquitectura técnica y pasa a
/// ser práctica real: la niña con su cuaderno de papel en la
/// mochila.
///
/// **Acceso**: Ajustes → "imprimir páginas en blanco para el campo".
///
/// **Anatomía**:
/// - Cabecera serif con la pedagogía corta.
/// - Selector de cantidad (4 / 8 / 16 páginas, default 8).
/// - Botón "imprimir o compartir" que delega en `Printing.layoutPdf`
///   — el SO ofrece imprimir, guardar como PDF, compartir.
class PantallaImprimirPlantilla extends StatefulWidget {
  const PantallaImprimirPlantilla({
    super.key,
    required this.repositorio,
    this.nombrePerfilActivo,
    this.lanzadorImpresion,
  });

  final RepositorioLocal repositorio;
  final String? nombrePerfilActivo;

  /// Inyectable para tests. Recibe los bytes del PDF y los lleva al
  /// SO. Si null, usa `Printing.layoutPdf` real.
  final Future<void> Function(Uint8List bytes)? lanzadorImpresion;

  @override
  State<PantallaImprimirPlantilla> createState() =>
      _EstadoPantallaImprimirPlantilla();
}

class _EstadoPantallaImprimirPlantilla
    extends State<PantallaImprimirPlantilla> {
  int _paginasElegidas = 8;
  static const _opciones = [4, 8, 16];

  SitSpot? _sitSpotActivo;
  bool _cargandoSitSpot = true;

  bool _generando = false;

  @override
  void initState() {
    super.initState();
    _cargarSitSpot();
  }

  Future<void> _cargarSitSpot() async {
    final sitSpot = await widget.repositorio.obtenerSitSpot();
    if (!mounted) return;
    setState(() {
      _sitSpotActivo = sitSpot;
      _cargandoSitSpot = false;
    });
  }

  Future<void> _generarYImprimir() async {
    setState(() => _generando = true);
    try {
      final bytes = await GeneradorPlantillaPdf.generar(
        paginas: _paginasElegidas,
        nombreNino: widget.nombrePerfilActivo ?? '',
        nombreSitSpot: _sitSpotActivo?.nombre,
      );
      final lanzador =
          widget.lanzadorImpresion ?? _lanzadorImpresionPorDefecto;
      await lanzador(bytes);
    } finally {
      if (mounted) setState(() => _generando = false);
    }
  }

  Future<void> _lanzadorImpresionPorDefecto(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(textos.imprimirPlantillaTitulo)),
      body: SafeArea(
        child: _cargandoSitSpot
            ? const Center(child: CircularProgressIndicator.adaptive())
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  Text(
                    textos.imprimirPlantillaIntro,
                    style: TipografiaCuaderno.serif(
                      color: esquema.onSurface,
                      tamano: TipografiaCuaderno.tamano14,
                      altoLinea: 1.55,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    textos.imprimirPlantillaContenido,
                    style: TipografiaCuaderno.serif(
                      color: PaletaCuaderno.tintaTenue,
                      tamano: TipografiaCuaderno.tamano13,
                      altoLinea: 1.55,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    textos.imprimirPlantillaSelectorCabecera,
                    style: TipografiaCuaderno.sans(
                      color: esquema.tertiary,
                      tamano: TipografiaCuaderno.tamano12,
                      peso: TipografiaCuaderno.pesoMedio,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final opcion in _opciones)
                        ChoiceChip(
                          label: Text(
                            textos.imprimirPlantillaOpcionPaginas(opcion),
                          ),
                          selected: _paginasElegidas == opcion,
                          onSelected: (selected) {
                            if (!selected) return;
                            setState(() => _paginasElegidas = opcion);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _generando ? null : _generarYImprimir,
                      icon: _generando
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.print_outlined),
                      label: Text(textos.imprimirPlantillaBoton),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    textos.imprimirPlantillaNotaFinal,
                    style: TipografiaCuaderno.serif(
                      color: PaletaCuaderno.tintaTenue,
                      tamano: TipografiaCuaderno.tamano12,
                      altoLinea: 1.5,
                    ).copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
      ),
    );
  }
}

