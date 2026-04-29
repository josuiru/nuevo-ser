import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late GestorPerfiles gestor;
  late RepositorioPreferenciasAudio prefsAudio;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    gestor = GestorPerfiles(
      namespace: 'uroto',
      sufijoNombreVisible: 'nombre_jugador',
    );
    prefsAudio = RepositorioPreferenciasAudio(gestor: gestor);
  });

  test('modo silencio por defecto es false', () async {
    expect(await prefsAudio.cargarModoSilencio(), isFalse);
  });

  test('modo silencio guardar + cargar', () async {
    await prefsAudio.guardarModoSilencio(true);
    expect(await prefsAudio.cargarModoSilencio(), isTrue);
    await prefsAudio.guardarModoSilencio(false);
    expect(await prefsAudio.cargarModoSilencio(), isFalse);
  });

  test('volumen sin guardar devuelve el predeterminado', () async {
    expect(
      await prefsAudio.cargarVolumenCapa('musica', predeterminado: 70),
      70,
    );
    expect(
      await prefsAudio.cargarVolumenCapa('ambient', predeterminado: 45),
      45,
    );
  });

  test('volumen guardar + cargar', () async {
    await prefsAudio.guardarVolumenCapa('musica', 42);
    expect(
      await prefsAudio.cargarVolumenCapa('musica', predeterminado: 70),
      42,
    );
  });

  test('volumen fuera de rango se acota a 0..100 al guardar', () async {
    await prefsAudio.guardarVolumenCapa('ambient', 150);
    expect(
      await prefsAudio.cargarVolumenCapa('ambient', predeterminado: 45),
      100,
    );
    await prefsAudio.guardarVolumenCapa('efectos', -10);
    expect(
      await prefsAudio.cargarVolumenCapa('efectos', predeterminado: 80),
      0,
    );
  });

  test('clave usa shape <ns>.perfil.<activo>.audio.volumen.<capa>', () async {
    await prefsAudio.guardarVolumenCapa('musica', 60);
    final prefs = await gestor.prefsInicializadas();
    expect(
      prefs.getInt('uroto.perfil.principal.audio.volumen.musica'),
      60,
    );
    await prefsAudio.guardarModoSilencio(true);
    expect(
      prefs.getBool('uroto.perfil.principal.audio.modo_silencio'),
      true,
    );
  });

  test('preferencias se aíslan por perfil activo', () async {
    await prefsAudio.guardarVolumenCapa('musica', 30);
    await prefsAudio.guardarModoSilencio(true);
    await gestor.crearPerfil('Otro');
    await gestor.cambiarAPerfil('otro');
    expect(
      await prefsAudio.cargarVolumenCapa('musica', predeterminado: 70),
      70,
      reason: 'El otro perfil parte limpio.',
    );
    expect(await prefsAudio.cargarModoSilencio(), isFalse);
    await gestor.cambiarAPerfil('principal');
    expect(
      await prefsAudio.cargarVolumenCapa('musica', predeterminado: 70),
      30,
    );
    expect(await prefsAudio.cargarModoSilencio(), isTrue);
  });
}
