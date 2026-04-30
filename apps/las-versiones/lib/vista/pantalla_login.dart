import 'package:flutter/material.dart';

import '../nucleo/paleta_archivo.dart';

/// Pantalla de inicio de sesión del adulto acompañante. Es **opt-in**
/// — el juego funciona sin token y los Mosaicos se preservan en local
/// pase lo que pase con la red. Iniciar sesión sólo activa el archivo
/// en el backend (`POST /companion/mosaicos`, `POST /companion/cuaderno/
/// entries` cuando entren) para que el adulto pueda ver lo que la
/// Cronista declaró desde su lado.
///
/// La pantalla NO crea cuentas — la creación pasa por el flujo del
/// adulto en otra superficie (web, otro juego de la Colección, etc.);
/// aquí sólo se introduce un email/contraseña ya existentes. El botón
/// "Olvidé mi contraseña" tampoco entra en este slice (el endpoint
/// `POST /auth/solicitar-reset` ya existe en el plugin WP, pero
/// añadirlo aquí amplía la superficie sin caso de uso fuerte hoy).
///
/// Texto en castellano hardcoded — la pantalla es para el adulto
/// acompañante, no para Maren, y no hace falta mantener paridad
/// trilingüe con la configuración inicial. El día que entren los ARBs
/// del juego se traduce sin tocar el flujo.
class PantallaLogin extends StatefulWidget {
  /// Callback que ejecuta la llamada real al backend. Debe devolver
  /// `null` si la sesión se inició correctamente, o un mensaje de
  /// error en castellano para enseñarlo en pantalla. La pantalla no
  /// sabe nada de `ClienteApi` ni de `RepositorioCuentaBackend` —
  /// quien la cablea decide cómo se hace la petición y dónde se
  /// guarda el token.
  final Future<String?> Function(String email, String password)
      alIntentarLogin;

  /// Email del adulto acompañante si ya hay sesión iniciada. Cuando
  /// está presente la pantalla cambia su modo: en lugar del formulario
  /// de login muestra una vista compacta de cuenta con el email y el
  /// botón "CERRAR SESIÓN". `null` cuando no hay sesión — la pantalla
  /// vuelve a su modo formulario.
  final String? emailActual;

  /// Callback que cierra la sesión. Sólo se invoca cuando hay sesión
  /// activa y el adulto pulsa "CERRAR SESIÓN". Tras la llamada la
  /// pantalla se cierra automáticamente con `Navigator.pop` para
  /// volver al esqueleto, donde el botón se refresca.
  final Future<void> Function()? alCerrarSesion;

  const PantallaLogin({
    super.key,
    required this.alIntentarLogin,
    this.emailActual,
    this.alCerrarSesion,
  });

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _controladorEmail = TextEditingController();
  final _controladorPassword = TextEditingController();
  bool _enviando = false;
  String? _mensajeError;

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorPassword.dispose();
    super.dispose();
  }

  Future<void> _cerrarSesion() async {
    final cerrar = widget.alCerrarSesion;
    if (cerrar == null) return;
    setState(() => _enviando = true);
    await cerrar();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _intentar() async {
    final email = _controladorEmail.text.trim();
    final password = _controladorPassword.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _mensajeError = 'Introduce email y contraseña.';
      });
      return;
    }
    setState(() {
      _enviando = true;
      _mensajeError = null;
    });
    final resultado = await widget.alIntentarLogin(email, password);
    if (!mounted) return;
    if (resultado == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _enviando = false;
      _mensajeError = resultado;
    });
  }

  @override
  Widget build(BuildContext contexto) {
    final email = widget.emailActual;
    final modoCuenta = email != null && widget.alCerrarSesion != null;
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: PaletaArchivo.textoPrincipal),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: SingleChildScrollView(
            child: modoCuenta
                ? _vistaCuenta(email)
                : _vistaLogin(),
          ),
        ),
      ),
    );
  }

  Widget _vistaCuenta(String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const Text(
          'SESIÓN INICIADA',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 4,
            fontWeight: FontWeight.w400,
            color: PaletaArchivo.textoPrincipal,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Sesión activa con',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            color: PaletaArchivo.textoTenue.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: PaletaArchivo.textoPrincipal,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: _enviando ? null : _cerrarSesion,
          style: FilledButton.styleFrom(
            backgroundColor: PaletaArchivo.fondoMedio,
            foregroundColor: PaletaArchivo.textoPrincipal,
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(
              color: PaletaArchivo.ambarLacre.withOpacity(0.6),
            ),
          ),
          child: _enviando
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: PaletaArchivo.textoPrincipal,
                  ),
                )
              : const Text(
                  'CERRAR SESIÓN',
                  style: TextStyle(letterSpacing: 4, fontSize: 13),
                ),
        ),
        const SizedBox(height: 18),
        Text(
          'Cerrar sesión sólo desvincula este Archivo del adulto. El '
          'progreso, los Mosaicos y el Cuaderno se preservan en local.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: PaletaArchivo.textoTenue.withOpacity(0.7),
            height: 1.55,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _vistaLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const Text(
          'INICIAR SESIÓN',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 4,
            fontWeight: FontWeight.w400,
            color: PaletaArchivo.textoPrincipal,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Vincular el Archivo de Iruña con la cuenta del adulto '
          'acompañante para que pueda ver lo que la Cronista declaró.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.55,
            color: PaletaArchivo.textoTenue.withOpacity(0.92),
          ),
        ),
        const SizedBox(height: 28),
        _Campo(
          controlador: _controladorEmail,
          etiqueta: 'Email',
          tipoTeclado: TextInputType.emailAddress,
          habilitado: !_enviando,
        ),
        const SizedBox(height: 16),
        _Campo(
          controlador: _controladorPassword,
          etiqueta: 'Contraseña',
          ocultarTexto: true,
          habilitado: !_enviando,
        ),
        const SizedBox(height: 22),
        if (_mensajeError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _mensajeError!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: PaletaArchivo.ambarLacre,
                height: 1.4,
              ),
            ),
          ),
        FilledButton(
          onPressed: _enviando ? null : _intentar,
          style: FilledButton.styleFrom(
            backgroundColor: PaletaArchivo.ambarLacre,
            foregroundColor: PaletaArchivo.fondoProfundo,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: _enviando
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: PaletaArchivo.fondoProfundo,
                  ),
                )
              : const Text(
                  'ENTRAR',
                  style: TextStyle(letterSpacing: 4, fontSize: 13),
                ),
        ),
        const SizedBox(height: 18),
        Text(
          'El juego funciona sin sesión: los Mosaicos se '
          'preservan en local. Iniciar sesión sólo añade el '
          'archivo compartido con el adulto.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: PaletaArchivo.textoTenue.withOpacity(0.7),
            height: 1.55,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _Campo extends StatelessWidget {
  final TextEditingController controlador;
  final String etiqueta;
  final bool ocultarTexto;
  final bool habilitado;
  final TextInputType? tipoTeclado;

  const _Campo({
    required this.controlador,
    required this.etiqueta,
    this.ocultarTexto = false,
    this.habilitado = true,
    this.tipoTeclado,
  });

  @override
  Widget build(BuildContext contexto) {
    return TextField(
      controller: controlador,
      enabled: habilitado,
      obscureText: ocultarTexto,
      keyboardType: tipoTeclado,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(
        color: PaletaArchivo.textoPrincipal,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: etiqueta,
        labelStyle: TextStyle(
          color: PaletaArchivo.textoTenue.withOpacity(0.9),
          letterSpacing: 1.5,
          fontSize: 12,
        ),
        filled: true,
        fillColor: PaletaArchivo.fondoMedio.withOpacity(0.55),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: PaletaArchivo.ambarLacre.withOpacity(0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: PaletaArchivo.ambarLacre.withOpacity(0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: PaletaArchivo.ambarLacre,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
