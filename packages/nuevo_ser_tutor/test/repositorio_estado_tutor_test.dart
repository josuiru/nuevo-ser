import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:nuevo_ser_tutor/nuevo_ser_tutor.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late GestorPerfiles gestor;
  late RepositorioEstadoTutor repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    gestor = GestorPerfiles(
      namespace: 'uroto',
      sufijoNombreVisible: 'nombre_jugador',
    );
    repo = RepositorioEstadoTutor(gestor: gestor);
  });

  test('cargar sin nada guardado devuelve estado por defecto', () async {
    final estado = await repo.cargar('FR.05');
    expect(estado.fallosConsecutivos, 0);
    expect(estado.ultimaOferta, isNull);
    expect(estado.vecesUsado, 0);
  });

  test('guardar + cargar produce estado equivalente', () async {
    final ahora = DateTime(2026, 4, 20, 10);
    final estado = EstadoTutorHabilidad(
      fallosConsecutivos: 3,
      ultimaOferta: ahora,
      vecesUsado: 2,
    );
    await repo.guardar('FR.05', estado);
    final leido = await repo.cargar('FR.05');
    expect(leido.fallosConsecutivos, 3);
    expect(leido.ultimaOferta, ahora);
    expect(leido.vecesUsado, 2);
  });

  test('clave usa el shape <ns>.perfil.<activo>.tutor.estado.<id>',
      () async {
    await repo.guardar('FR.05', const EstadoTutorHabilidad());
    final prefs = await gestor.prefsInicializadas();
    expect(
      prefs.getString('uroto.perfil.principal.tutor.estado.FR.05'),
      isNotNull,
    );
  });

  test('cargar JSON corrupto borra la clave y devuelve por defecto',
      () async {
    final prefs = await gestor.prefsInicializadas();
    const clave = 'uroto.perfil.principal.tutor.estado.FR.05';
    await prefs.setString(clave, '{json-malo');
    final estado = await repo.cargar('FR.05');
    expect(estado.fallosConsecutivos, 0);
    expect(prefs.getString(clave), isNull);
  });

  test('estado se aísla por perfil activo', () async {
    await repo.guardar(
      'FR.05',
      const EstadoTutorHabilidad(fallosConsecutivos: 5),
    );
    await gestor.crearPerfil('Otro');
    await gestor.cambiarAPerfil('otro');
    expect((await repo.cargar('FR.05')).fallosConsecutivos, 0);
    await gestor.cambiarAPerfil('principal');
    expect((await repo.cargar('FR.05')).fallosConsecutivos, 5);
  });
}
