import 'package:flutter/material.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../../datos/cliente_auth_cuaderno.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Bloque "Cuenta del adulto" en Ajustes — punto de entrada para
/// vincular la cuenta del backend de la persona adulta acompañante. Es
/// la pareja real del `_BloqueTutorDebug` debug-only: una vez vinculada
/// la cuenta, los tres opt-ins ya cableados (Tutor real, sync de
/// agregados, sync de observaciones) quedan disponibles.
///
/// Por privacidad estructural (memoria
/// `project_el_cuaderno_decisiones_humanas_pendientes` ítem 5: LOPDGDD
/// para menores), el **registro NO se hace in-app**: la persona adulta
/// crea la cuenta primero en la web del backend y aquí sólo introduce
/// las credenciales para vincular. Esto deja el alta del niño fuera del
/// ámbito que requiere la asesoría legal.
///
/// El bloque consume un closure `iniciarSesion` inyectado por
/// `main.dart` — el widget no construye `ClienteAuthCuaderno` para que
/// los tests puedan ejercitar el flujo con `MockClient` directo. Al
/// éxito, persiste token + email en `RepositorioCuentaBackend` y
/// notifica al orquestador con `alCambiarToken` para que el
/// `FutureBuilder` del Tutor recompute y los demás bloques dependientes
/// del token aparezcan habilitados.
class BloqueLoginAdulto extends StatefulWidget {
  const BloqueLoginAdulto({
    super.key,
    required this.repoCuenta,
    required this.iniciarSesion,
    required this.esquema,
    this.alCambiarToken,
  });

  final RepositorioCuentaBackend repoCuenta;

  /// Closure que invoca `ClienteAuthCuaderno.iniciarSesion`. Inyectada
  /// para que los tests sustituyan la red por un stub.
  final Future<ResultadoLogin> Function({
    required String email,
    required String password,
  }) iniciarSesion;

  final ColorScheme esquema;

  /// Notifica al orquestador (`main.dart`) que el token cambió tras
  /// iniciar/cerrar sesión, para que recompute la closure del Tutor sin
  /// reiniciar la app — mismo patrón que `_BloqueTutorDebug`.
  final VoidCallback? alCambiarToken;

  @override
  State<BloqueLoginAdulto> createState() => _EstadoBloqueLoginAdulto();
}

class _EstadoBloqueLoginAdulto extends State<BloqueLoginAdulto> {
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorPassword = TextEditingController();

  bool _cargandoEstadoInicial = true;
  bool _enviando = false;
  bool _hayTokenGuardado = false;
  String? _emailGuardado;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargarEstadoInicial();
  }

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorPassword.dispose();
    super.dispose();
  }

  Future<void> _cargarEstadoInicial() async {
    final token = await widget.repoCuenta.cargarToken();
    final email = await widget.repoCuenta.cargarEmail();
    if (!mounted) return;
    setState(() {
      _hayTokenGuardado = token != null && token.isNotEmpty;
      _emailGuardado = email;
      _cargandoEstadoInicial = false;
    });
  }

  Future<void> _entrar() async {
    final textos = TextosApp.of(context);
    final email = _controladorEmail.text.trim();
    final password = _controladorPassword.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _mensajeError = textos.ajustesCuentaErrorVacio);
      return;
    }
    setState(() {
      _enviando = true;
      _mensajeError = null;
    });
    final resultado = await widget.iniciarSesion(
      email: email,
      password: password,
    );
    if (!mounted) return;
    switch (resultado) {
      case LoginExito(:final token):
        await widget.repoCuenta.guardarToken(token);
        await widget.repoCuenta.guardarEmail(email);
        if (!mounted) return;
        _controladorEmail.clear();
        _controladorPassword.clear();
        setState(() {
          _enviando = false;
          _hayTokenGuardado = true;
          _emailGuardado = email;
        });
        widget.alCambiarToken?.call();
      case LoginCredencialesIncorrectas():
        setState(() {
          _enviando = false;
          _mensajeError = textos.ajustesCuentaErrorCredenciales;
        });
      case LoginSinPerfilDeNino():
        setState(() {
          _enviando = false;
          _mensajeError = textos.ajustesCuentaErrorSinPerfil;
        });
      case LoginErrorRed():
        setState(() {
          _enviando = false;
          _mensajeError = textos.ajustesCuentaErrorRed;
        });
    }
  }

  Future<void> _cerrarSesion() async {
    await widget.repoCuenta.cerrarSesion();
    if (!mounted) return;
    setState(() {
      _hayTokenGuardado = false;
      _emailGuardado = null;
      _mensajeError = null;
    });
    widget.alCambiarToken?.call();
  }

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = widget.esquema;

    return Card(
      color: esquema.surfaceContainerHighest,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textos.ajustesCuentaTitulo,
              style: TipografiaCuaderno.serif(
                color: esquema.onSurface,
                tamano: TipografiaCuaderno.tamano16,
                peso: TipografiaCuaderno.pesoMedio,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              textos.ajustesCuentaDescripcion,
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.tintaTenue,
                tamano: TipografiaCuaderno.tamano13,
                altoLinea: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            if (_cargandoEstadoInicial)
              const SizedBox(
                height: 20,
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (_hayTokenGuardado)
              _construirEstadoSesionIniciada(textos, esquema)
            else
              _construirFormulario(textos, esquema),
          ],
        ),
      ),
    );
  }

  Widget _construirEstadoSesionIniciada(
    TextosApp textos,
    ColorScheme esquema,
  ) {
    final email = _emailGuardado;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          email != null && email.isNotEmpty
              ? textos.ajustesCuentaSesionIniciada(email)
              : textos.ajustesCuentaSesionIniciadaSinEmail,
          style: TipografiaCuaderno.sans(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano13,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _cerrarSesion,
          child: Text(textos.ajustesCuentaCerrarSesion),
        ),
      ],
    );
  }

  Widget _construirFormulario(TextosApp textos, ColorScheme esquema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controladorEmail,
          enabled: !_enviando,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          autofillHints: const [AutofillHints.email, AutofillHints.username],
          decoration: InputDecoration(
            hintText: textos.ajustesCuentaPlaceholderEmail,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          style: TipografiaCuaderno.sans(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano13,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controladorPassword,
          enabled: !_enviando,
          obscureText: true,
          autofillHints: const [AutofillHints.password],
          decoration: InputDecoration(
            hintText: textos.ajustesCuentaPlaceholderPassword,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          style: TipografiaCuaderno.sans(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano13,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            FilledButton(
              onPressed: _enviando ? null : _entrar,
              child: Text(
                _enviando
                    ? textos.ajustesCuentaEntrando
                    : textos.ajustesCuentaBotonEntrar,
              ),
            ),
          ],
        ),
        if (_mensajeError != null) ...[
          const SizedBox(height: 8),
          Text(
            _mensajeError!,
            style: TipografiaCuaderno.serif(
              color: PaletaCuaderno.sienaTenue,
              tamano: TipografiaCuaderno.tamano12,
              altoLinea: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}
