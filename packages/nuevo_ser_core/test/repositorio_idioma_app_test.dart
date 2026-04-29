import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late RepositorioIdiomaApp idioma;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    idioma = RepositorioIdiomaApp(
      prefs: SharedPreferences.getInstance,
      clave: 'uroto.idioma_app',
    );
  });

  test('sin guardar devuelve null (primer arranque)', () async {
    expect(await idioma.cargar(), isNull);
  });

  test('guardar + cargar devuelve lo guardado', () async {
    await idioma.guardar('eu');
    expect(await idioma.cargar(), 'eu');
  });

  test('guardar sobreescribe el valor anterior', () async {
    await idioma.guardar('es');
    await idioma.guardar('ca');
    expect(await idioma.cargar(), 'ca');
  });

  test('borrar vuelve al estado de primer arranque', () async {
    await idioma.guardar('eu');
    await idioma.borrar();
    expect(await idioma.cargar(), isNull);
  });

  test('borrar es idempotente cuando nunca se guardó', () async {
    await idioma.borrar();
    expect(await idioma.cargar(), isNull);
  });

  test('claves personalizadas — dos juegos coexisten en el mismo prefs',
      () async {
    final idiomaUroto = RepositorioIdiomaApp(
      prefs: SharedPreferences.getInstance,
      clave: 'uroto.idioma_app',
    );
    final idiomaLasVersiones = RepositorioIdiomaApp(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.lasversiones.idioma_app',
    );

    await idiomaUroto.guardar('eu');
    await idiomaLasVersiones.guardar('ca');

    expect(await idiomaUroto.cargar(), 'eu');
    expect(await idiomaLasVersiones.cargar(), 'ca');

    await idiomaUroto.borrar();
    expect(await idiomaUroto.cargar(), isNull);
    expect(await idiomaLasVersiones.cargar(), 'ca');
  });
}
