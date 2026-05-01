import 'package:el_cuaderno/datos/repositorio_mapa_online_opt_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  RepositorioMapaOnlineOptIn crear() => RepositorioMapaOnlineOptIn(
        prefs: SharedPreferences.getInstance,
      );

  test('default es false antes de cualquier activación', () async {
    final repo = crear();
    expect(await repo.cargar(), isFalse);
  });

  test('activar persiste true; cargar devuelve true', () async {
    final repo = crear();
    await repo.activar();
    expect(await repo.cargar(), isTrue);
  });

  test('desactivar tras activar persiste false', () async {
    final repo = crear();
    await repo.activar();
    await repo.desactivar();
    expect(await repo.cargar(), isFalse);
  });

  test('borrar tras activar deja la clave ausente (default false)',
      () async {
    final repo = crear();
    await repo.activar();
    await repo.borrar();
    expect(await repo.cargar(), isFalse);
  });

  test('clave distinta aísla dos instancias', () async {
    final repoA = RepositorioMapaOnlineOptIn(
      prefs: SharedPreferences.getInstance,
      clave: 'app.a.mapa_online',
    );
    final repoB = RepositorioMapaOnlineOptIn(
      prefs: SharedPreferences.getInstance,
      clave: 'app.b.mapa_online',
    );
    await repoA.activar();
    expect(await repoA.cargar(), isTrue);
    expect(await repoB.cargar(), isFalse);
  });
}
