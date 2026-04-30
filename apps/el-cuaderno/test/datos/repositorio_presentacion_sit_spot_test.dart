import 'package:el_cuaderno/datos/repositorio_presentacion_sit_spot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  RepositorioPresentacionSitSpot crear() => RepositorioPresentacionSitSpot(
        prefs: SharedPreferences.getInstance,
      );

  test('cargar() devuelve false en el primer arranque', () async {
    expect(await crear().cargar(), isFalse);
  });

  test('marcar() persiste true; cargar() devuelve true tras marcar',
      () async {
    final repo = crear();
    await repo.marcar();
    expect(await repo.cargar(), isTrue);
  });

  test('marcar() es idempotente — dos llamadas no rompen', () async {
    final repo = crear();
    await repo.marcar();
    await repo.marcar();
    expect(await repo.cargar(), isTrue);
  });

  test('borrar() devuelve el flag a false', () async {
    final repo = crear();
    await repo.marcar();
    await repo.borrar();
    expect(await repo.cargar(), isFalse);
  });

  test('borrar() es idempotente — borrar antes de marcar no rompe',
      () async {
    final repo = crear();
    await repo.borrar();
    expect(await repo.cargar(), isFalse);
  });

  test('clave por defecto sigue el namespace nuevoser.elcuaderno.*',
      () async {
    final repo = crear();
    await repo.marcar();
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getKeys(),
      contains('nuevoser.elcuaderno.presentacion_sit_spot.vista'),
    );
  });

  test('clave personalizada (para pruebas multi-instancia)', () async {
    final repo = RepositorioPresentacionSitSpot(
      prefs: SharedPreferences.getInstance,
      clave: 'mi.clave.custom',
    );
    await repo.marcar();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getKeys(), contains('mi.clave.custom'));
    expect(prefs.getKeys(),
        isNot(contains('nuevoser.elcuaderno.presentacion_sit_spot.vista')));
  });
}
