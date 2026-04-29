import 'package:flutter/material.dart';

import '../datos/cliente_api.dart';
import '../datos/config_api.dart';
import '../datos/repositorio_progreso.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'pantalla_solicitar_reset.dart';

/// Estado de la cuenta con el backend. Tres modos:
/// - **Sin cuenta**: el niño juega offline; no hay sync ni tutor IA.
/// - **Vinculado**: hay token + email guardados. Sync funciona y el
///   tutor IA está disponible.
/// - **Sesión expirada**: hubo un email guardado pero el token ya no
///   vale (caducó o se borró). La pantalla pide volver a iniciar
///   sesión (sin perder el email para autocompletar).
///
/// La contraseña NO se persiste — cada vez que el JWT caduca, el
/// tutor pide login.
class PantallaCuenta extends StatefulWidget {
  final RepositorioProgreso repositorio;

  const PantallaCuenta({super.key, required this.repositorio});

  @override
  State<PantallaCuenta> createState() => _EstadoPantallaCuenta();
}

class _EstadoPantallaCuenta extends State<PantallaCuenta> {
  String? _email;
  bool _tieneToken = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final email = await widget.repositorio.cargarEmailBackend();
    final token = await widget.repositorio.cargarTokenBackend();
    if (!mounted) return;
    setState(() {
      _email = email;
      _tieneToken = token != null && token.isNotEmpty;
      _cargando = false;
    });
  }

  Future<void> _abrirRegistro() async {
    final ok = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => _PantallaRegistro(repositorio: widget.repositorio),
    ));
    if (ok == true) await _cargar();
  }

  Future<void> _abrirInicioSesion() async {
    final ok = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => _PantallaInicioSesion(
        repositorio: widget.repositorio,
        emailSugerido: _email,
      ),
    ));
    if (ok == true) await _cargar();
  }

  Future<void> _confirmarCerrarSesion() async {
    final textos = AppLocalizations.of(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          textos.cuentaCerrarSesionTitulo,
          style: const TextStyle(color: PaletaNeon.textoPrincipal),
        ),
        content: Text(
          textos.cuentaCerrarSesionCuerpo,
          style: const TextStyle(color: PaletaNeon.textoTenue),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: Text(
              textos.comunCancelar,
              style: const TextStyle(color: PaletaNeon.textoTenue),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: Text(
              textos.cuentaBotonCerrar,
              style: const TextStyle(color: PaletaNeon.rosaAcento),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    await widget.repositorio.cerrarSesionBackend();
    await _cargar();
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          AppLocalizations.of(contexto).cuentaTitulo,
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 16,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(color: PaletaNeon.textoTenue),
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: PaletaNeon.azulNeon),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: _construirCuerpo(),
            ),
    );
  }

  Widget _construirCuerpo() {
    if (_tieneToken && _email != null) {
      return _ModoVinculado(
        email: _email!,
        alCerrarSesion: _confirmarCerrarSesion,
      );
    }
    if (_email != null) {
      return _ModoSesionExpirada(
        email: _email!,
        alIniciarSesion: _abrirInicioSesion,
      );
    }
    return _ModoSinCuenta(
      alRegistrarse: _abrirRegistro,
      alIniciarSesion: _abrirInicioSesion,
    );
  }
}

class _ModoSinCuenta extends StatelessWidget {
  final VoidCallback alRegistrarse;
  final VoidCallback alIniciarSesion;

  const _ModoSinCuenta({
    required this.alRegistrarse,
    required this.alIniciarSesion,
  });

  @override
  Widget build(BuildContext contexto) {
    final textos = AppLocalizations.of(contexto);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          textos.cuentaSinCuentaTitulo,
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          textos.cuentaSinCuentaCuerpo,
          style: const TextStyle(
            color: PaletaNeon.textoTenue,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        _BotonGrande(
          texto: textos.cuentaBotonCrear,
          color: PaletaNeon.violetaNeon,
          alPulsar: alRegistrarse,
        ),
        const SizedBox(height: 12),
        _BotonGrande(
          texto: textos.cuentaBotonIniciar,
          color: PaletaNeon.azulNeon,
          alPulsar: alIniciarSesion,
        ),
      ],
    );
  }
}

class _ModoVinculado extends StatelessWidget {
  final String email;
  final VoidCallback alCerrarSesion;

  const _ModoVinculado({
    required this.email,
    required this.alCerrarSesion,
  });

  @override
  Widget build(BuildContext contexto) {
    final textos = AppLocalizations.of(contexto);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          textos.cuentaVinculadaTitulo,
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          email,
          style: const TextStyle(
            color: PaletaNeon.textoTenue,
            fontSize: 15,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          textos.cuentaVinculadaCuerpo,
          style: const TextStyle(
            color: PaletaNeon.textoTenue,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: alCerrarSesion,
          child: Text(
            textos.cuentaBotonCerrarSesion,
            style: const TextStyle(
              color: PaletaNeon.rosaAcento,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModoSesionExpirada extends StatelessWidget {
  final String email;
  final VoidCallback alIniciarSesion;

  const _ModoSesionExpirada({
    required this.email,
    required this.alIniciarSesion,
  });

  @override
  Widget build(BuildContext contexto) {
    final textos = AppLocalizations.of(contexto);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          textos.cuentaCaducadaTitulo,
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          textos.cuentaCaducadaCuerpo(email),
          style: const TextStyle(
            color: PaletaNeon.textoTenue,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        _BotonGrande(
          texto: textos.cuentaBotonIniciar,
          color: PaletaNeon.azulNeon,
          alPulsar: alIniciarSesion,
        ),
      ],
    );
  }
}

class _BotonGrande extends StatelessWidget {
  final String texto;
  final Color color;
  final VoidCallback alPulsar;

  const _BotonGrande({
    required this.texto,
    required this.color,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    return ElevatedButton(
      onPressed: alPulsar,
      style: ElevatedButton.styleFrom(
        backgroundColor: PaletaNeon.fondoMedio,
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.5)),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          letterSpacing: 3,
          fontWeight: FontWeight.w400,
        ),
      ),
      child: Text(texto),
    );
  }
}

// ═══ Subpantalla de registro ═══════════════════════════════════════

class _PantallaRegistro extends StatefulWidget {
  final RepositorioProgreso repositorio;

  const _PantallaRegistro({required this.repositorio});

  @override
  State<_PantallaRegistro> createState() => _EstadoPantallaRegistro();
}

class _EstadoPantallaRegistro extends State<_PantallaRegistro> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _nombreTutor = TextEditingController();
  final _nombreNino = TextEditingController();
  String? _mensajeError;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    widget.repositorio.cargarNombreJugador().then((nombre) {
      if (!mounted || nombre == null) return;
      _nombreNino.text = nombre;
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _nombreTutor.dispose();
    _nombreNino.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (_enviando) return;
    final email = _email.text.trim();
    final password = _password.text;
    final nombreTutor = _nombreTutor.text.trim();
    final nombreNino = _nombreNino.text.trim();
    if (email.isEmpty || password.length < 8 || nombreNino.isEmpty) {
      setState(() => _mensajeError =
          AppLocalizations.of(context).cuentaErrorCamposRegistro);
      return;
    }
    setState(() {
      _enviando = true;
      _mensajeError = null;
    });
    final api = ClienteApi(
      urlBase: ConfigApi.urlBase,
      hostOverride: ConfigApi.hostOverride,
    );
    try {
      final resp = await api.registrar(
        email: email,
        password: password,
        nombreTutor: nombreTutor.isEmpty ? 'Tutor' : nombreTutor,
        nombreNino: nombreNino,
      );
      await widget.repositorio.guardarTokenBackend(resp.token);
      await widget.repositorio.guardarEmailBackend(email);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ExcepcionApi catch (e) {
      if (!mounted) return;
      setState(() => _mensajeError = e.mensaje);
    } catch (e, st) {
      // ignore: avoid_print
      print('[uroto.cuenta] excepción registrar: $e');
      // ignore: avoid_print
      print(st);
      if (!mounted) return;
      setState(() =>
          _mensajeError = AppLocalizations.of(context).cuentaErrorRed);
    } finally {
      api.cerrar();
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext contexto) {
    final textos = AppLocalizations.of(contexto);
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          textos.cuentaCrearTitulo,
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 16,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(color: PaletaNeon.textoTenue),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Campo(
                controlador: _email,
                etiqueta: textos.cuentaCampoEmail,
                tecladoEmail: true,
              ),
              const SizedBox(height: 16),
              _Campo(
                controlador: _password,
                etiqueta: textos.cuentaCampoPasswordMin,
                obscure: true,
              ),
              const SizedBox(height: 16),
              _Campo(
                controlador: _nombreTutor,
                etiqueta: textos.cuentaCampoNombreTutor,
              ),
              const SizedBox(height: 16),
              _Campo(
                controlador: _nombreNino,
                etiqueta: textos.cuentaCampoNombreNino,
              ),
              if (_mensajeError != null) ...[
                const SizedBox(height: 16),
                Text(
                  _mensajeError!,
                  style: const TextStyle(
                    color: PaletaNeon.rosaAcento,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              _BotonGrande(
                texto: _enviando
                    ? textos.cuentaBotonCreando
                    : textos.cuentaBotonCrear,
                color: PaletaNeon.violetaNeon,
                alPulsar: _enviando ? () {} : _registrar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══ Subpantalla de inicio de sesión ═══════════════════════════════

class _PantallaInicioSesion extends StatefulWidget {
  final RepositorioProgreso repositorio;
  final String? emailSugerido;

  const _PantallaInicioSesion({
    required this.repositorio,
    this.emailSugerido,
  });

  @override
  State<_PantallaInicioSesion> createState() =>
      _EstadoPantallaInicioSesion();
}

class _EstadoPantallaInicioSesion extends State<_PantallaInicioSesion> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _mensajeError;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    if (widget.emailSugerido != null) {
      _email.text = widget.emailSugerido!;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _iniciar() async {
    if (_enviando) return;
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() =>
          _mensajeError = AppLocalizations.of(context).cuentaErrorCamposLogin);
      return;
    }
    setState(() {
      _enviando = true;
      _mensajeError = null;
    });
    final api = ClienteApi(
      urlBase: ConfigApi.urlBase,
      hostOverride: ConfigApi.hostOverride,
    );
    try {
      final resp =
          await api.iniciarSesion(email: email, password: password);
      await widget.repositorio.guardarTokenBackend(resp.token);
      await widget.repositorio.guardarEmailBackend(email);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ExcepcionApi catch (e) {
      if (!mounted) return;
      setState(() => _mensajeError = e.mensaje);
    } catch (e, st) {
      // ignore: avoid_print
      print('[uroto.cuenta] excepción login: $e');
      // ignore: avoid_print
      print(st);
      if (!mounted) return;
      setState(() =>
          _mensajeError = AppLocalizations.of(context).cuentaErrorRed);
    } finally {
      api.cerrar();
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext contexto) {
    final textos = AppLocalizations.of(contexto);
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          textos.cuentaIniciarTitulo,
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 16,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(color: PaletaNeon.textoTenue),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Campo(
                controlador: _email,
                etiqueta: textos.cuentaCampoEmail,
                tecladoEmail: true,
              ),
              const SizedBox(height: 16),
              _Campo(
                controlador: _password,
                etiqueta: textos.cuentaCampoPassword,
                obscure: true,
              ),
              if (_mensajeError != null) ...[
                const SizedBox(height: 16),
                Text(
                  _mensajeError!,
                  style: const TextStyle(
                    color: PaletaNeon.rosaAcento,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              _BotonGrande(
                texto: _enviando
                    ? textos.cuentaBotonEntrando
                    : textos.cuentaBotonIniciar,
                color: PaletaNeon.azulNeon,
                alPulsar: _enviando ? () {} : _iniciar,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _enviando
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const PantallaSolicitarReset(),
                          ),
                        );
                      },
                child: const Text(
                  'He olvidado mi contraseña',
                  style: TextStyle(
                    color: PaletaNeon.textoTenue,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Campo extends StatefulWidget {
  final TextEditingController controlador;
  final String etiqueta;
  final bool obscure;
  final bool tecladoEmail;

  const _Campo({
    required this.controlador,
    required this.etiqueta,
    this.obscure = false,
    this.tecladoEmail = false,
  });

  @override
  State<_Campo> createState() => _CampoState();
}

class _CampoState extends State<_Campo> {
  late bool _oculto;

  @override
  void initState() {
    super.initState();
    _oculto = widget.obscure;
  }

  @override
  Widget build(BuildContext contexto) {
    return TextField(
      controller: widget.controlador,
      obscureText: _oculto,
      keyboardType: widget.tecladoEmail
          ? TextInputType.emailAddress
          : TextInputType.text,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(color: PaletaNeon.textoPrincipal),
      cursorColor: PaletaNeon.violetaNeon,
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        labelStyle: const TextStyle(color: PaletaNeon.textoTenue),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: PaletaNeon.violetaBase.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: PaletaNeon.violetaNeon),
          borderRadius: BorderRadius.circular(6),
        ),
        // Solo mostramos el icono ojo cuando el campo es de password
        // (es decir, fue creado con obscure=true) — para los demás
        // el toggle no tiene sentido.
        suffixIcon: widget.obscure
            ? IconButton(
                onPressed: () => setState(() => _oculto = !_oculto),
                icon: Icon(
                  _oculto ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                  color: PaletaNeon.textoTenue,
                ),
              )
            : null,
      ),
    );
  }
}
