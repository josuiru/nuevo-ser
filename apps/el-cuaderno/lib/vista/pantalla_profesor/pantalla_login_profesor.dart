import 'package:flutter/material.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pantalla_aula_profesor.dart';

/// Pantalla de login del profesor (B7 — fallback de experto pendiente
/// de policy escolar). Pareja del `BloqueLoginAdulto` (login del
/// adulto-cuidador) pero con shape distinto: el endpoint del profesor
/// es `POST /auth/login` con `{email, password, rol: 'profesor'}` y
/// devuelve un JWT con `tipo='profesor'`.
///
/// Decisiones provisionales documentadas:
/// - **Misma app que el cuaderno del niño**. La biblia §15 / doc 15
///   hablan de la vista del aula como espacio adulto separado del
///   cuaderno; cuando se decida si va en una APK aparte o como
///   "modo profesor" gateado, los widgets de esta carpeta se mueven
///   tal cual. La persistencia del token usa una clave aparte de la
///   del adulto-cuidador (`nuevoser.elcuaderno.token_profesor`) para
///   que coexistan sin interferirse.
/// - **Sin registro in-app**. Mismo principio que el cliente del niño:
///   el profesor crea su cuenta primero por web (la asesoría LOPDGDD
///   B3 cubre el alta) y aquí sólo vincula.
/// - **Sólo rol `profesor`**. La UI de cuidador la puebla otro
///   widget cuando llegue B7-cuidador (caso 1 doc 15 §8 + asesoría
///   psicológica B8).
class PantallaLoginProfesor extends StatefulWidget {
  const PantallaLoginProfesor({
    super.key,
    required this.clienteAuth,
    required this.clienteCompanion,
    required this.repoCuentaProfesor,
    required this.repoAulaProfesor,
  });

  final companion.ClienteAuthAdulto clienteAuth;
  final companion.ClienteCompanion clienteCompanion;
  final RepositorioCuentaBackend repoCuentaProfesor;
  final RepositorioAulaProfesorContrato repoAulaProfesor;

  @override
  State<PantallaLoginProfesor> createState() => _EstadoPantallaLoginProfesor();
}

/// Contrato pequeño para evitar que esta pantalla importe
/// `lib/datos/repositorio_aula_profesor.dart` directamente — los tests
/// inyectan un fake en línea.
abstract class RepositorioAulaProfesorContrato {
  Future<int?> cargar();
  Future<void> guardar(int classroomId);
  Future<void> borrar();
}

class _EstadoPantallaLoginProfesor extends State<PantallaLoginProfesor> {
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorPassword = TextEditingController();
  bool _enviando = false;
  String? _mensajeError;

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorPassword.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final email = _controladorEmail.text.trim();
    final password = _controladorPassword.text;
    final textos = TextosApp.of(context);
    if (email.isEmpty || password.isEmpty) {
      setState(() => _mensajeError = textos.loginProfesorErrorVacio);
      return;
    }
    setState(() {
      _enviando = true;
      _mensajeError = null;
    });

    final resultado = await widget.clienteAuth.iniciarSesion(
      email: email,
      password: password,
      rol: companion.RolAdulto.profesor,
    );
    if (!mounted) return;

    switch (resultado) {
      case companion.LoginAdultoExito(:final token):
        await widget.repoCuentaProfesor.guardarToken(token);
        await widget.repoCuentaProfesor.guardarEmail(email);
        if (!mounted) return;
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => PantallaAulaProfesor(
              clienteCompanion: widget.clienteCompanion,
              repoCuentaProfesor: widget.repoCuentaProfesor,
              repoAulaProfesor: widget.repoAulaProfesor,
            ),
          ),
        );
      case companion.LoginAdultoCredencialesIncorrectas():
        setState(() {
          _enviando = false;
          _mensajeError = textos.loginProfesorErrorCredenciales;
        });
      case companion.LoginAdultoSinRolAsignado():
        setState(() {
          _enviando = false;
          _mensajeError = textos.loginProfesorErrorSinRol;
        });
      case companion.LoginAdultoRolInvalido():
        setState(() {
          _enviando = false;
          _mensajeError = textos.loginProfesorErrorRolInvalido;
        });
      case companion.LoginAdultoErrorRed():
        setState(() {
          _enviando = false;
          _mensajeError = textos.loginProfesorErrorRed;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(textos.loginProfesorTitulo)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textos.loginProfesorTitulo,
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano17,
                  peso: TipografiaCuaderno.pesoMedio,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                textos.loginProfesorIntro,
                style: TipografiaCuaderno.serif(
                  color: PaletaCuaderno.tintaTenue,
                  tamano: TipografiaCuaderno.tamano13,
                  altoLinea: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controladorEmail,
                enabled: !_enviando,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: textos.loginProfesorPlaceholderEmail,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controladorPassword,
                enabled: !_enviando,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: textos.loginProfesorPlaceholderPassword,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _enviando ? null : _entrar,
                child: Text(_enviando
                    ? textos.loginProfesorEntrando
                    : textos.loginProfesorBotonEntrar),
              ),
              if (_mensajeError != null) ...[
                const SizedBox(height: 12),
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
          ),
        ),
      ),
    );
  }
}
