import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late RepositorioVersionPaqueteAudio version;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    version = RepositorioVersionPaqueteAudio(
      prefs: SharedPreferences.getInstance,
      clave: 'uroto.audio.version_local',
    );
  });

  test('sin guardar devuelve null (nunca se descargó)', () async {
    expect(await version.cargar(), isNull);
  });

  test('guardar + cargar', () async {
    await version.guardar(7);
    expect(await version.cargar(), 7);
  });

  test('guardar versión nueva sobreescribe la anterior', () async {
    await version.guardar(5);
    await version.guardar(8);
    expect(await version.cargar(), 8);
  });

  test('borrar deja el repositorio en estado de primer arranque', () async {
    await version.guardar(3);
    await version.borrar();
    expect(await version.cargar(), isNull);
  });

  test('borrar es idempotente cuando nunca se guardó', () async {
    await version.borrar();
    expect(await version.cargar(), isNull);
  });

  test('claves distintas — dos juegos coexisten en el mismo prefs',
      () async {
    final versionUroto = RepositorioVersionPaqueteAudio(
      prefs: SharedPreferences.getInstance,
      clave: 'uroto.audio.version_local',
    );
    final versionLasVersiones = RepositorioVersionPaqueteAudio(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.lasversiones.audio.version_local',
    );

    await versionUroto.guardar(7);
    await versionLasVersiones.guardar(2);

    expect(await versionUroto.cargar(), 7);
    expect(await versionLasVersiones.cargar(), 2);

    await versionUroto.borrar();
    expect(await versionUroto.cargar(), isNull);
    expect(await versionLasVersiones.cargar(), 2);
  });
}
