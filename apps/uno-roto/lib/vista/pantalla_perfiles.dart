import 'package:flutter/material.dart';

import '../datos/repositorio_progreso.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';

/// Pantalla de selección de perfiles. Lista los perfiles existentes, el
/// activo aparece marcado, y ofrece crear un perfil nuevo o borrar uno
/// existente. Al tocar un perfil se establece como activo y se llama a
/// [alPerfilSeleccionado] para que el orquestador decida cómo seguir.
class PantallaPerfiles extends StatefulWidget {
  final RepositorioProgreso repositorio;
  final VoidCallback alPerfilSeleccionado;

  const PantallaPerfiles({
    super.key,
    required this.repositorio,
    required this.alPerfilSeleccionado,
  });

  @override
  State<PantallaPerfiles> createState() => _PantallaPerfilesState();
}

class _PantallaPerfilesState extends State<PantallaPerfiles> {
  List<PerfilInfo> _perfiles = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _recargar();
  }

  Future<void> _recargar() async {
    final perfiles = await widget.repositorio.listarPerfilesConInfo();
    if (!mounted) return;
    setState(() {
      _perfiles = perfiles;
      _cargando = false;
    });
  }

  Future<void> _elegirPerfil(PerfilInfo perfil) async {
    await widget.repositorio.cambiarAPerfil(perfil.id);
    if (!mounted) return;
    widget.alPerfilSeleccionado();
  }

  Future<void> _crearPerfilNuevo() async {
    final textos = AppLocalizations.of(context);
    final controladorNombre = TextEditingController();
    final String? nombreIntroducido;
    try {
      nombreIntroducido = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: PaletaNeon.fondoMedio,
          title: Text(
            textos.perfDialogNuevoTitulo,
            style: const TextStyle(color: PaletaNeon.textoPrincipal),
          ),
          content: TextField(
            controller: controladorNombre,
            autofocus: true,
            maxLength: 20,
            style: const TextStyle(color: PaletaNeon.textoPrincipal),
            decoration: InputDecoration(
              hintText: textos.perfDialogNuevoHint,
              hintStyle: const TextStyle(color: PaletaNeon.textoTenue),
              counterStyle: const TextStyle(color: PaletaNeon.textoTenue),
            ),
            onSubmitted: (texto) =>
                Navigator.of(context).pop(texto.trim()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                textos.comunCancelar,
                style: const TextStyle(color: PaletaNeon.textoTenue),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .pop(controladorNombre.text.trim()),
              child: Text(
                textos.perfBotonCrear,
                style: const TextStyle(color: PaletaNeon.violetaNeon),
              ),
            ),
          ],
        ),
      );
    } finally {
      controladorNombre.dispose();
    }
    if (nombreIntroducido == null || nombreIntroducido.isEmpty) return;
    final idCreado =
        await widget.repositorio.crearPerfil(nombreIntroducido);
    await widget.repositorio.cambiarAPerfil(idCreado);
    if (!mounted) return;
    widget.alPerfilSeleccionado();
  }

  Future<void> _borrarPerfil(PerfilInfo perfil) async {
    final textos = AppLocalizations.of(context);
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          textos.perfDialogBorrarTitulo,
          style: const TextStyle(color: PaletaNeon.textoPrincipal),
        ),
        content: Text(
          textos.perfDialogBorrarCuerpo(perfil.nombreVisible),
          style: const TextStyle(color: PaletaNeon.textoTenue),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              textos.comunCancelar,
              style: const TextStyle(color: PaletaNeon.textoTenue),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              textos.perfBotonBorrar,
              style: const TextStyle(color: PaletaNeon.rosaAcento),
            ),
          ),
        ],
      ),
    );
    if (confirmado != true) return;
    await widget.repositorio.borrarPerfil(perfil.id);
    await _recargar();
  }

  @override
  Widget build(BuildContext contexto) {
    final textos = AppLocalizations.of(contexto);
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textos.perfHeaderQuienEres,
                style: const TextStyle(
                  color: PaletaNeon.textoTenue,
                  fontSize: 13,
                  letterSpacing: 5,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                textos.perfHeaderSubtitulo,
                style: TextStyle(
                  color: PaletaNeon.textoTenue.withOpacity(0.7),
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _cargando
                    ? const SizedBox.shrink()
                    : ListView.separated(
                        itemCount: _perfiles.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final perfil = _perfiles[i];
                          return _TarjetaPerfil(
                            perfil: perfil,
                            alElegir: () => _elegirPerfil(perfil),
                            alBorrar: _perfiles.length > 1
                                ? () => _borrarPerfil(perfil)
                                : null,
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              _BotonCrearNuevo(alPulsar: _crearPerfilNuevo),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaPerfil extends StatelessWidget {
  final PerfilInfo perfil;
  final VoidCallback alElegir;
  final VoidCallback? alBorrar;

  const _TarjetaPerfil({
    required this.perfil,
    required this.alElegir,
    required this.alBorrar,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorBorde = perfil.esActivo
        ? PaletaNeon.violetaNeon
        : PaletaNeon.violetaBase.withOpacity(0.6);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: alElegir,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: PaletaNeon.fondoMedio.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorBorde, width: 1.6),
            boxShadow: perfil.esActivo
                ? [
                    BoxShadow(
                      color: PaletaNeon.violetaNeon.withOpacity(0.25),
                      blurRadius: 14,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                perfil.esActivo
                    ? Icons.person
                    : Icons.person_outline,
                color: perfil.esActivo
                    ? PaletaNeon.violetaNeon
                    : PaletaNeon.textoTenue,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      perfil.nombreVisible,
                      style: TextStyle(
                        color: perfil.esActivo
                            ? PaletaNeon.textoPrincipal
                            : PaletaNeon.textoPrincipal
                                .withOpacity(0.85),
                        fontSize: 17,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (perfil.esActivo)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          AppLocalizations.of(contexto).perfBadgeActual,
                          style: TextStyle(
                            color: PaletaNeon.violetaNeon
                                .withOpacity(0.8),
                            fontSize: 10,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (alBorrar != null)
                IconButton(
                  tooltip: AppLocalizations.of(contexto).perfTooltipBorrar,
                  icon: Icon(
                    Icons.delete_outline,
                    color: PaletaNeon.textoTenue.withOpacity(0.7),
                    size: 20,
                  ),
                  onPressed: alBorrar,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonCrearNuevo extends StatelessWidget {
  final VoidCallback alPulsar;

  const _BotonCrearNuevo({required this.alPulsar});

  @override
  Widget build(BuildContext contexto) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: alPulsar,
        icon: const Icon(
          Icons.add,
          color: PaletaNeon.azulNeon,
          size: 18,
        ),
        label: Text(
          AppLocalizations.of(contexto).perfBotonNuevo,
          style: const TextStyle(
            color: PaletaNeon.azulNeon,
            fontSize: 13,
            letterSpacing: 2.5,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: PaletaNeon.azulNeon.withOpacity(0.6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
