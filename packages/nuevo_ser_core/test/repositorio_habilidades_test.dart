import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

EstadoHabilidad estadoEjemplo({
  String id = 'FR.05',
  NivelMaestria nivel = NivelMaestria.competente,
  double precision = 0.83,
  int totalExposiciones = 7,
  DateTime? ultimaPractica,
}) {
  return EstadoHabilidad(
    identificadorHabilidad: id,
    nivel: nivel,
    precision: precision,
    tiempoMedianoSeg: 5.4,
    ultimaPractica: ultimaPractica ?? DateTime(2026, 4, 20, 17, 30),
    sesionesConsecutivasBuenas: 3,
    totalExposiciones: totalExposiciones,
    intentosRecientes: [
      IntentoHabilidad(
        instante: DateTime(2026, 4, 20, 17, 29, 50),
        acierto: true,
        dificultad: 1.0,
        duracionSegundos: 5,
      ),
    ],
  );
}

void main() {
  late GestorPerfiles gestor;
  late RepositorioHabilidades repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    gestor = GestorPerfiles(
      namespace: 'uroto',
      sufijoNombreVisible: 'nombre_jugador',
    );
    repo = RepositorioHabilidades(gestor: gestor);
  });

  test('cargar con clave inexistente devuelve null', () async {
    expect(await repo.cargar('FR.99'), isNull);
  });

  test('guardar + cargar produce un estado equivalente', () async {
    final estado = estadoEjemplo();
    await repo.guardar(estado);
    final leido = await repo.cargar('FR.05');
    expect(leido, isNotNull);
    expect(leido!.identificadorHabilidad, 'FR.05');
    expect(leido.nivel, NivelMaestria.competente);
    expect(leido.precision, closeTo(0.83, 1e-9));
    expect(leido.totalExposiciones, 7);
    expect(leido.sesionesConsecutivasBuenas, 3);
    expect(leido.intentosRecientes, hasLength(1));
    expect(leido.intentosRecientes.single.acierto, true);
  });

  test('guardar usa la clave <ns>.perfil.<activo>.habilidad.<id>', () async {
    await repo.guardar(estadoEjemplo(id: 'DEC.04'));
    final prefs = await gestor.prefsInicializadas();
    final clave = 'uroto.perfil.principal.habilidad.DEC.04';
    expect(prefs.getString(clave), isNotNull);
  });

  test('cargar con JSON corrupto borra la clave y devuelve null', () async {
    final prefs = await gestor.prefsInicializadas();
    const clave = 'uroto.perfil.principal.habilidad.FR.05';
    await prefs.setString(clave, '{esto-no-es-json');
    expect(await repo.cargar('FR.05'), isNull);
    expect(prefs.getString(clave), isNull);
  });

  test('exportarTodos lista solo las claves del prefijo correcto', () async {
    await repo.guardar(estadoEjemplo(id: 'FR.05'));
    await repo.guardar(estadoEjemplo(id: 'DEC.04'));
    // Una clave intrusa: misma raíz pero distinto sufijo.
    final prefs = await gestor.prefsInicializadas();
    await prefs.setString(
      'uroto.perfil.principal.tutor.estado.FR.05',
      '{"f": 1}',
    );
    final lista = await repo.exportarTodos();
    final ids = lista.map((e) => e.identificadorHabilidad).toSet();
    expect(ids, {'FR.05', 'DEC.04'});
  });

  test('exportarTodos ignora corruptos sin fallar', () async {
    await repo.guardar(estadoEjemplo(id: 'FR.05'));
    final prefs = await gestor.prefsInicializadas();
    await prefs.setString(
      'uroto.perfil.principal.habilidad.DEC.04',
      'no-json',
    );
    final lista = await repo.exportarTodos();
    expect(lista, hasLength(1));
    expect(lista.single.identificadorHabilidad, 'FR.05');
  });

  test('exportarTodos sólo ve el perfil activo', () async {
    await repo.guardar(estadoEjemplo(id: 'FR.05'));
    // Simulamos otro perfil con su propio estado.
    final prefs = await gestor.prefsInicializadas();
    await prefs.setString(
      'uroto.perfil.otro.habilidad.FR.05',
      jsonEncode(estadoEjemplo(id: 'FR.05', precision: 0.1).aJson()),
    );

    final lista = await repo.exportarTodos();
    expect(lista, hasLength(1));
    expect(lista.single.precision, closeTo(0.83, 1e-9));
  });

  test('exportarParaSync mapea al shape del backend WP', () async {
    await repo.guardar(estadoEjemplo(
      id: 'FR.05',
      ultimaPractica: DateTime.utc(2026, 4, 20, 17, 30, 0),
    ));
    final lista = await repo.exportarParaSync();
    expect(lista, hasLength(1));
    final fila = lista.single;
    expect(fila['id_habilidad'], 'FR.05');
    expect(fila['nivel'], NivelMaestria.competente.valor);
    expect(fila['precision_ponderada'], closeTo(0.83, 1e-9));
    expect(fila['total_exposiciones'], 7);
    expect(fila['sesiones_consecutivas_buenas'], 3);
    expect(fila['ultima_practica'], '2026-04-20 17:30:00');
    expect(fila['actualizado_en'], matches(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'));
    expect(fila['intentos_recientes'], hasLength(1));
  });

  test('aFechaMysql convierte a UTC y formatea con padding', () {
    expect(
      aFechaMysql(DateTime.utc(2026, 1, 5, 7, 8, 9)),
      '2026-01-05 07:08:09',
    );
    // Hora local ambigua: el helper la convierte a UTC.
    final local = DateTime(2026, 1, 5, 9, 0, 0);
    final esperado = local.toUtc();
    final s = aFechaMysql(local);
    final r = RegExp(r'^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$')
        .firstMatch(s)!;
    expect(int.parse(r.group(1)!), esperado.year);
    expect(int.parse(r.group(4)!), esperado.hour);
  });
}
