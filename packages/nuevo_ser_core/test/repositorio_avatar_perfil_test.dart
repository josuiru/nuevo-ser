import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late GestorPerfiles gestor;
  late RepositorioAvatarPerfil avatar;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    gestor = GestorPerfiles(
      namespace: 'uroto',
      sufijoNombreVisible: 'nombre_jugador',
    );
    avatar = RepositorioAvatarPerfil(gestor: gestor);
  });

  test('sin guardar devuelve null (sin avatar todavía)', () async {
    expect(await avatar.cargarRuta(), isNull);
  });

  test('guardar + cargar', () async {
    await avatar.guardarRuta('/data/uroto/avatares/niko.png');
    expect(await avatar.cargarRuta(), '/data/uroto/avatares/niko.png');
  });

  test('cadena vacía se trata como null', () async {
    await avatar.guardarRuta('');
    expect(await avatar.cargarRuta(), isNull);
  });

  test('cadena con sólo espacios se trata como null', () async {
    await avatar.guardarRuta('   ');
    expect(await avatar.cargarRuta(), isNull);
  });

  test('borrar elimina la ruta', () async {
    await avatar.guardarRuta('/x.png');
    await avatar.borrarRuta();
    expect(await avatar.cargarRuta(), isNull);
  });

  test('aislamiento por perfil — cada niño tiene su avatar', () async {
    await gestor.crearPerfil('Niko');
    await gestor.crearPerfil('Mara');

    final perfiles = await gestor.listarPerfiles();
    final idNiko = perfiles.firstWhere((id) => id.contains('niko'));
    final idMara = perfiles.firstWhere((id) => id.contains('mara'));

    await gestor.cambiarAPerfil(idNiko);
    await avatar.guardarRuta('/uroto/avatares/niko.png');

    await gestor.cambiarAPerfil(idMara);
    expect(await avatar.cargarRuta(), isNull,
        reason: 'Mara no debería ver el avatar de Niko');
    await avatar.guardarRuta('/uroto/avatares/mara.png');

    await gestor.cambiarAPerfil(idNiko);
    expect(await avatar.cargarRuta(), '/uroto/avatares/niko.png');

    await gestor.cambiarAPerfil(idMara);
    expect(await avatar.cargarRuta(), '/uroto/avatares/mara.png');
  });

  test('sufijo personalizado se respeta', () async {
    final avatarPersonalizado = RepositorioAvatarPerfil(
      gestor: gestor,
      sufijoRuta: 'foto.dibujo',
    );
    await avatarPersonalizado.guardarRuta('/x.png');
    expect(await avatarPersonalizado.cargarRuta(), '/x.png');
    expect(await avatar.cargarRuta(), isNull,
        reason: 'el sufijo por defecto no debe ver lo escrito en otro');
  });
}
