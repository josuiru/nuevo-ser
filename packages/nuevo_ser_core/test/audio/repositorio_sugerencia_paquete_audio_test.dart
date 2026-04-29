import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late RepositorioSugerenciaPaqueteAudio sugerencia;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    sugerencia = RepositorioSugerenciaPaqueteAudio(
      prefs: SharedPreferences.getInstance,
      clave: 'uroto.audio.sugerencia_vista',
    );
  });

  test('por defecto devuelve false (banner debe mostrarse)', () async {
    expect(await sugerencia.cargar(), isFalse);
  });

  test('marcar pasa a true', () async {
    await sugerencia.marcar();
    expect(await sugerencia.cargar(), isTrue);
  });

  test('marcar es idempotente', () async {
    await sugerencia.marcar();
    await sugerencia.marcar();
    expect(await sugerencia.cargar(), isTrue);
  });

  test('borrar vuelve a false (banner se reofrecerá)', () async {
    await sugerencia.marcar();
    await sugerencia.borrar();
    expect(await sugerencia.cargar(), isFalse);
  });

  test('claves distintas — dos juegos coexisten en el mismo prefs',
      () async {
    final sugerenciaUroto = RepositorioSugerenciaPaqueteAudio(
      prefs: SharedPreferences.getInstance,
      clave: 'uroto.audio.sugerencia_vista',
    );
    final sugerenciaLasVersiones = RepositorioSugerenciaPaqueteAudio(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.lasversiones.audio.sugerencia_vista',
    );

    await sugerenciaUroto.marcar();

    expect(await sugerenciaUroto.cargar(), isTrue);
    expect(await sugerenciaLasVersiones.cargar(), isFalse);
  });
}
