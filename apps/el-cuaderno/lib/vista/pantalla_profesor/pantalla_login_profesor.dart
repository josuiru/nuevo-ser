import 'package:flutter/material.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

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
    if (email.isEmpty || password.isEmpty) {
      setState(() => _mensajeError =
          'Escribe el correo y la contraseña antes de continuar.');
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
          _mensajeError =
              'El correo o la contraseña no coinciden con ninguna cuenta de profesor.';
        });
      case companion.LoginAdultoSinRolAsignado():
        setState(() {
          _enviando = false;
          _mensajeError =
              'Esta cuenta no tiene perfil de profesor. Si eres cuidador, busca ese acceso aparte.';
        });
      case companion.LoginAdultoRolInvalido():
        setState(() {
          _enviando = false;
          _mensajeError = 'El servidor no aceptó la petición. Avisa al equipo.';
        });
      case companion.LoginAdultoErrorRed():
        setState(() {
          _enviando = false;
          _mensajeError =
              'No se ha podido conectar con el servidor. Inténtalo en un momento.';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Acceso del profesor')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Acceso del profesor',
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano17,
                  peso: TipografiaCuaderno.pesoMedio,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Esta pantalla es para el adulto que acompaña a la clase. '
                'No se enseña al niño. La cuenta de profesor se crea desde '
                'la web; aquí solo se vincula.',
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
                decoration: const InputDecoration(
                  labelText: 'correo del profesor',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controladorPassword,
                enabled: !_enviando,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                decoration: const InputDecoration(
                  labelText: 'contraseña',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _enviando ? null : _entrar,
                child: Text(_enviando ? 'Entrando…' : 'Iniciar sesión'),
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
