import 'package:flutter/material.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../../dominio/exportador_cuaderno.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../pantalla_cuidador/pantalla_cuidador.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Pantalla de Ajustes — punto de control del niño sobre **su**
/// cuaderno. Tres acciones nucleares:
///
/// 1. Cambiar idioma (vuelve al selector trilingüe inicial).
/// 2. Exportar el cuaderno como JSON portable. "El cuaderno es del
///    niño" (biblia §2.1) — y por tanto se debe poder llevar.
/// 3. Borrar todo lo local. Doble confirmación: dialog explicativo +
///    palabra-clave que el niño tiene que escribir. Sin emojis ni
///    fanfarria — la pérdida de un cuaderno no se celebra.
///
/// Acceso a la **vista del cuidador** desde aquí también (doc 15 §1) —
/// la única superficie compartida con un adulto, controlada por el
/// niño.
class PantallaAjustes extends StatelessWidget {
  const PantallaAjustes({
    super.key,
    required this.repositorio,
    required this.repoIdioma,
    required this.locale,
    required this.alCambiarIdioma,
  });

  final RepositorioLocal repositorio;
  final RepositorioIdiomaApp repoIdioma;
  final Locale locale;

  /// Callback que `main.dart` provee para volver al selector
  /// trilingüe. Borra la preferencia y resetea el `ValueNotifier`
  /// global; la app reconstruye y muestra `PantallaConfiguracionInicial`.
  final Future<void> Function() alCambiarIdioma;

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(textos.ajustesTitulo)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            _BloqueIdioma(
              textoActual: textos.ajustesIdiomaActual(_nombreIdioma(locale)),
              etiquetaCambiar: textos.ajustesIdiomaCambiar,
              alPulsar: alCambiarIdioma,
              esquema: esquema,
            ),
            const SizedBox(height: 16),
            _BloqueAccion(
              titulo: textos.ajustesVistaCuidador,
              descripcion: textos.ajustesVistaCuidadorDescripcion,
              alPulsar: () => _abrirCuidador(context),
              esquema: esquema,
            ),
            const SizedBox(height: 16),
            _BloqueAccion(
              titulo: textos.ajustesExportar,
              descripcion: textos.ajustesExportarDescripcion,
              alPulsar: () => _exportar(context),
              esquema: esquema,
            ),
            const SizedBox(height: 16),
            _BloqueAccion(
              titulo: textos.ajustesBorrar,
              descripcion: textos.ajustesBorrarDescripcion,
              alPulsar: () => _borrar(context),
              esquema: esquema,
              destacado: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _abrirCuidador(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => PantallaCuidador(repositorio: repositorio),
      ),
    );
  }

  Future<void> _exportar(BuildContext context) async {
    final observaciones = await repositorio.obtenerObservaciones();
    final sitSpot = await repositorio.obtenerSitSpot();
    final misterios = await repositorio.obtenerMisteriosAbiertos();
    if (!context.mounted) return;
    final json = ExportadorCuaderno.aJson(
      observaciones: observaciones,
      sitSpot: sitSpot,
      misterios: misterios,
    );
    final textos = TextosApp.of(context);
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(textos.ajustesExportarDialogoTitulo),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
          child: SingleChildScrollView(
            child: SelectableText(
              json,
              style: TipografiaCuaderno.sans(
                color: PaletaCuaderno.tinta,
                tamano: TipografiaCuaderno.tamano12,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(textos.ajustesExportarDialogoCerrar),
          ),
        ],
      ),
    );
  }

  Future<void> _borrar(BuildContext context) async {
    final observaciones = await repositorio.obtenerObservaciones();
    final sitSpot = await repositorio.obtenerSitSpot();
    final misterios = await repositorio.obtenerMisteriosAbiertos();
    if (!context.mounted) return;
    final textos = TextosApp.of(context);
    // Primer paso: dialog explicativo con counts.
    final continuar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(textos.ajustesBorrarDialogoTitulo),
        content: Text(textos.ajustesBorrarDialogoCuerpo(
          observaciones.length,
          misterios.length,
          sitSpot == null ? 0 : 1,
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(textos.ajustesBorrarDialogoCancelar),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(textos.ajustesBorrarDialogoSeguir),
          ),
        ],
      ),
    );
    if (continuar != true || !context.mounted) return;
    // Segundo paso: el niño escribe la palabra-clave para confirmar.
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => _DialogoPalabraClave(
        palabraEsperada: textos.ajustesBorrarConfirmacionPalabra,
        titulo: textos.ajustesBorrarConfirmacionTitulo,
        cuerpo: textos.ajustesBorrarConfirmacionCuerpo,
        placeholder: textos.ajustesBorrarConfirmacionPlaceholder,
        botonConfirmar: textos.ajustesBorrarConfirmacionBoton,
        botonCancelar: textos.ajustesBorrarDialogoCancelar,
      ),
    );
    if (confirmado != true || !context.mounted) return;
    final resultado = await repositorio.borrarTodoLoLocal();
    if (!context.mounted) return;
    final mensaje = '${textos.ajustesBorradoCompleto} '
        '(${resultado.observacionesBorradas} · '
        '${resultado.misteriosBorrados} · '
        '${resultado.sitSpotsBorrados})';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
    Navigator.of(context).pop();
  }

  String _nombreIdioma(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return 'castellano';
      case 'eu':
        return 'euskara';
      case 'ca':
        return 'català';
      default:
        return locale.languageCode;
    }
  }
}

class _BloqueIdioma extends StatelessWidget {
  const _BloqueIdioma({
    required this.textoActual,
    required this.etiquetaCambiar,
    required this.alPulsar,
    required this.esquema,
  });

  final String textoActual;
  final String etiquetaCambiar;
  final Future<void> Function() alPulsar;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: esquema.surfaceContainerHighest,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                textoActual,
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano14,
                ),
              ),
            ),
            TextButton(
              onPressed: alPulsar,
              child: Text(etiquetaCambiar),
            ),
          ],
        ),
      ),
    );
  }
}

class _BloqueAccion extends StatelessWidget {
  const _BloqueAccion({
    required this.titulo,
    required this.descripcion,
    required this.alPulsar,
    required this.esquema,
    this.destacado = false,
  });

  final String titulo;
  final String descripcion;
  final VoidCallback alPulsar;
  final ColorScheme esquema;
  final bool destacado;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: destacado
          ? esquema.surfaceContainerHighest
          : esquema.surfaceContainerHighest,
      elevation: 0,
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TipografiaCuaderno.serif(
                  color: destacado ? esquema.secondary : esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano16,
                  peso: TipografiaCuaderno.pesoMedio,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                descripcion,
                style: TipografiaCuaderno.serif(
                  color: PaletaCuaderno.tintaTenue,
                  tamano: TipografiaCuaderno.tamano13,
                  altoLinea: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogoPalabraClave extends StatefulWidget {
  const _DialogoPalabraClave({
    required this.palabraEsperada,
    required this.titulo,
    required this.cuerpo,
    required this.placeholder,
    required this.botonConfirmar,
    required this.botonCancelar,
  });

  final String palabraEsperada;
  final String titulo;
  final String cuerpo;
  final String placeholder;
  final String botonConfirmar;
  final String botonCancelar;

  @override
  State<_DialogoPalabraClave> createState() => _EstadoDialogoPalabraClave();
}

class _EstadoDialogoPalabraClave extends State<_DialogoPalabraClave> {
  final TextEditingController _controlador = TextEditingController();
  bool _coincide = false;

  @override
  void initState() {
    super.initState();
    _controlador.addListener(() {
      final coincide = _controlador.text.trim().toLowerCase() ==
          widget.palabraEsperada.trim().toLowerCase();
      if (coincide != _coincide) {
        setState(() => _coincide = coincide);
      }
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.cuerpo),
          const SizedBox(height: 12),
          TextField(
            controller: _controlador,
            autofocus: true,
            decoration: InputDecoration(hintText: widget.placeholder),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(widget.botonCancelar),
        ),
        TextButton(
          onPressed: _coincide
              ? () => Navigator.of(context).pop(true)
              : null,
          child: Text(widget.botonConfirmar),
        ),
      ],
    );
  }
}
