import 'package:flutter/material.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../nucleo/paleta_archivo.dart';

/// Pantalla de gestión multi-perfil. Cada perfil es una Cronista
/// distinta del mismo dispositivo (típicamente, dos hermanos). Cada
/// perfil tiene su propio progreso aislado: flags narrativos,
/// Brechas, Cuaderno, Mosaicos, evaluaciones — todo bajo el prefijo
/// `<namespace>.perfil.<id>.*` que aplica el [GestorPerfiles] del
/// core.
///
/// Cosas que **NO** son por-perfil (claves globales del juego, no se
/// migran entre perfiles ni se duplican): el idioma de la app, el
/// token JWT del adulto acompañante y su email. La cuenta del
/// backend es **una sola para el dispositivo** porque la separación
/// entre niños la lleva el `nino_id` del JWT, no los perfiles
/// locales.
///
/// La pantalla permite tres acciones:
/// - **Cambiar de perfil**: tap sobre uno no activo → llama a
///   [alCambiarAPerfil] que ejecuta `gestor.cambiarAPerfil(id)` y
///   vuelve al esqueleto recargando el estado en memoria.
/// - **Crear perfil**: botón flotante "+" abre un diálogo con
///   campo de texto. Al confirmar llama a [alCrearPerfil].
/// - **Borrar perfil**: icono de papelera por fila, salvo cuando
///   sólo queda uno (no permitido — el gestor recrearía el
///   principal vacío inmediatamente; mejor pedir reset desde el
///   menú).
class PantallaPerfiles extends StatefulWidget {
  /// El gestor del que se leen y al que se escriben los cambios. La
  /// pantalla es agnóstica al juego: cualquier Las Versiones / Uno
  /// Roto / El Cuaderno con su propio namespace puede reusarla.
  final GestorPerfiles gestor;

  /// Tras cambiar a otro perfil — el orquestador del juego limpia su
  /// estado en memoria y re-despacha desde la PantallaConfiguracionInicial
  /// porque el nuevo perfil podría no haber elegido idioma todavía.
  final Future<void> Function(String idPerfil) alCambiarAPerfil;

  const PantallaPerfiles({
    super.key,
    required this.gestor,
    required this.alCambiarAPerfil,
  });

  @override
  State<PantallaPerfiles> createState() => _PantallaPerfilesState();
}

class _PantallaPerfilesState extends State<PantallaPerfiles> {
  List<PerfilInfo> _perfiles = const [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await widget.gestor.listarPerfilesConInfo();
    if (!mounted) return;
    setState(() {
      _perfiles = lista;
      _cargando = false;
    });
  }

  Future<void> _crearPerfil() async {
    final nombre = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const _DialogoCrearPerfil(),
    );
    if (nombre == null || nombre.trim().isEmpty) return;
    await widget.gestor.crearPerfil(nombre.trim());
    await _cargar();
  }

  Future<void> _borrarPerfil(PerfilInfo perfil) async {
    if (_perfiles.length <= 1) return;
    final confirmacion = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _DialogoConfirmarBorrado(
        nombreVisible: perfil.nombreVisible,
      ),
    );
    if (confirmacion != true) return;
    await widget.gestor.borrarPerfil(perfil.id);
    if (!mounted) return;
    if (perfil.esActivo) {
      // El gestor ya cambió el perfil activo al primer restante. El
      // orquestador necesita recargar el estado en memoria para
      // reflejar el progreso del nuevo perfil activo.
      final activoTrasBorrar = await widget.gestor.idPerfilActivo();
      await widget.alCambiarAPerfil(activoTrasBorrar);
      return;
    }
    await _cargar();
  }

  Future<void> _cambiarAPerfil(PerfilInfo perfil) async {
    if (perfil.esActivo) return;
    await widget.alCambiarAPerfil(perfil.id);
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaArchivo.fondoProfundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PaletaArchivo.textoPrincipal,
          onPressed: () => Navigator.of(contexto).maybePop(),
        ),
        title: Text(
          'PERFILES',
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 5,
            color: PaletaArchivo.textoPrincipal,
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: PaletaArchivo.ambarLacre.withOpacity(0.35),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: PaletaArchivo.fondoMedio,
        foregroundColor: PaletaArchivo.ambarLacre,
        elevation: 0,
        onPressed: _cargando ? null : _crearPerfil,
        icon: const Icon(Icons.person_add_alt_outlined),
        label: const Text(
          'Nueva Cronista',
          style: TextStyle(letterSpacing: 1, fontSize: 13),
        ),
      ),
      body: SafeArea(
        top: false,
        child: _cargando
            ? const Center(
                child: CircularProgressIndicator(
                  color: PaletaArchivo.ambarLacre,
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(
                      'Cada perfil es una Cronista con su propio Archivo. '
                      'El idioma de la app y la sesión del adulto '
                      'acompañante son comunes al dispositivo.',
                      style: TextStyle(
                        fontSize: 13,
                        color: PaletaArchivo.textoPrincipal.withOpacity(0.85),
                        height: 1.5,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  for (final perfil in _perfiles)
                    _FilaPerfil(
                      perfil: perfil,
                      puedeBorrar: _perfiles.length > 1,
                      alPulsar: () => _cambiarAPerfil(perfil),
                      alBorrar: () => _borrarPerfil(perfil),
                    ),
                ],
              ),
      ),
    );
  }
}

class _FilaPerfil extends StatelessWidget {
  final PerfilInfo perfil;
  final bool puedeBorrar;
  final VoidCallback alPulsar;
  final VoidCallback alBorrar;

  const _FilaPerfil({
    required this.perfil,
    required this.puedeBorrar,
    required this.alPulsar,
    required this.alBorrar,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorAcento = perfil.esActivo
        ? PaletaArchivo.ambarLacre
        : PaletaArchivo.textoTenue.withOpacity(0.55);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoMedio.withOpacity(0.4),
        border: Border(
          left: BorderSide(color: colorAcento, width: 2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: alPulsar,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            child: Row(
              children: [
                Icon(
                  perfil.esActivo
                      ? Icons.person
                      : Icons.person_outline,
                  color: colorAcento,
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
                          fontSize: 15,
                          color: PaletaArchivo.textoPrincipal
                              .withOpacity(0.95),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        perfil.esActivo
                            ? 'ACTIVO'
                            : 'Pulsa para activar',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: colorAcento,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (puedeBorrar)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: PaletaArchivo.textoTenue.withOpacity(0.65),
                    iconSize: 20,
                    tooltip: 'Borrar perfil',
                    onPressed: alBorrar,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogoCrearPerfil extends StatefulWidget {
  const _DialogoCrearPerfil();

  @override
  State<_DialogoCrearPerfil> createState() => _DialogoCrearPerfilState();
}

class _DialogoCrearPerfilState extends State<_DialogoCrearPerfil> {
  final TextEditingController controlador = TextEditingController();

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contexto) {
    return AlertDialog(
      backgroundColor: PaletaArchivo.fondoProfundo,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      title: const Text(
        'Nueva Cronista',
        style: TextStyle(
          fontSize: 16,
          color: PaletaArchivo.textoPrincipal,
          letterSpacing: 0.5,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nombre de la Cronista — para distinguirla de otras del '
            'mismo dispositivo.',
            style: TextStyle(
              fontSize: 13,
              color: PaletaArchivo.textoPrincipal.withOpacity(0.85),
              height: 1.45,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controlador,
            autofocus: true,
            style: const TextStyle(
              color: PaletaArchivo.textoPrincipal,
              fontSize: 14,
            ),
            cursorColor: PaletaArchivo.ambarLacre,
            decoration: InputDecoration(
              hintText: 'Nombre',
              hintStyle: TextStyle(
                color: PaletaArchivo.textoTenue.withOpacity(0.6),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PaletaArchivo.ambarLacre),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: PaletaArchivo.textoTenue.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(),
          child: const Text(
            'CANCELAR',
            style: TextStyle(
              color: PaletaArchivo.textoTenue,
              letterSpacing: 1.5,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(controlador.text),
          child: const Text(
            'CREAR',
            style: TextStyle(
              color: PaletaArchivo.ambarLacre,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogoConfirmarBorrado extends StatelessWidget {
  final String nombreVisible;

  const _DialogoConfirmarBorrado({required this.nombreVisible});

  @override
  Widget build(BuildContext contexto) {
    return AlertDialog(
      backgroundColor: PaletaArchivo.fondoProfundo,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      title: const Text(
        '¿Borrar este perfil?',
        style: TextStyle(
          fontSize: 16,
          color: PaletaArchivo.textoPrincipal,
          letterSpacing: 0.5,
        ),
      ),
      content: Text(
        'Borrarás todo el progreso de "$nombreVisible" en este '
        'dispositivo: flags, Brechas, Cuaderno, Mosaicos. No hay '
        'vuelta atrás.',
        style: TextStyle(
          fontSize: 13,
          color: PaletaArchivo.textoPrincipal.withOpacity(0.85),
          height: 1.45,
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(false),
          child: const Text(
            'CANCELAR',
            style: TextStyle(
              color: PaletaArchivo.textoTenue,
              letterSpacing: 1.5,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(true),
          child: const Text(
            'SÍ, BORRAR',
            style: TextStyle(
              color: PaletaArchivo.ambarLacre,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
