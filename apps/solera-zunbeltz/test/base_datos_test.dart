// Tests de la base de datos (FZ-2) con sqflite_common_ffi en memoria.
// Cubren el contrato CRUD y, sobre todo, las cascadas de borrado: borrar
// una finca arrastra sus puntos y tareas; borrar un punto deja sus tareas
// huérfanas (punto_id = NULL) sin perderlas.

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:solera_zunbeltz/datos/base_datos.dart';
import 'package:solera_zunbeltz/modelos/finca.dart';
import 'package:solera_zunbeltz/modelos/punto_infraestructura.dart';
import 'package:solera_zunbeltz/modelos/tarea_mantenimiento.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  Future<BaseDatosSoleraZunbeltz> abrirBdEnMemoria() async {
    final db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        // BD nueva por test: sin esto, todas las llamadas comparten la
        // misma BD en memoria y el estado se filtra entre tests.
        singleInstance: false,
        onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
        onCreate: (d, v) => BaseDatosSoleraZunbeltz.crearEsquemaV1(d),
      ),
    );
    return BaseDatosSoleraZunbeltz.paraTests(db);
  }

  test('alta finca → punto → tarea y lectura', () async {
    final bd = await abrirBdEnMemoria();
    final fincaId = await bd.guardarFinca(Finca(nombre: 'Zunbeltz'));
    final puntoId = await bd.guardarPunto(
        PuntoInfraestructura(fincaId: fincaId, tipo: 'abrevadero'));
    final tareaId = await bd.guardarTarea(TareaMantenimiento(
      fincaId: fincaId,
      puntoId: puntoId,
      titulo: 'Revisar fuga',
      estado: 'pendiente',
    ));

    expect((await bd.listarFincas()).single.nombre, 'Zunbeltz');
    expect((await bd.listarPuntos(fincaId: fincaId)).single.id, puntoId);
    expect((await bd.obtenerTarea(tareaId))!.titulo, 'Revisar fuga');
    expect(await bd.contarTareasAbiertas(), 1);
  });

  test('filtros de listarTareas (estado y responsable)', () async {
    final bd = await abrirBdEnMemoria();
    final fincaId = await bd.guardarFinca(Finca(nombre: 'La Planilla'));
    await bd.guardarTarea(TareaMantenimiento(
        fincaId: fincaId, titulo: 'A', estado: 'pendiente', responsable: 'Maite'));
    await bd.guardarTarea(TareaMantenimiento(
        fincaId: fincaId, titulo: 'B', estado: 'hecha', responsable: 'Iñaki'));

    expect((await bd.listarTareas(estado: 'pendiente')).single.titulo, 'A');
    expect((await bd.listarTareas(responsable: 'Iñaki')).single.titulo, 'B');
    expect((await bd.listarTareas()).length, 2);
    expect(await bd.contarTareasAbiertas(), 1);
  });

  test('borrar finca arrastra sus puntos y tareas (CASCADE)', () async {
    final bd = await abrirBdEnMemoria();
    final fincaId = await bd.guardarFinca(Finca(nombre: 'Zunbeltz'));
    final puntoId =
        await bd.guardarPunto(PuntoInfraestructura(fincaId: fincaId));
    await bd.guardarTarea(
        TareaMantenimiento(fincaId: fincaId, puntoId: puntoId, titulo: 'T'));

    await bd.borrarFinca(fincaId);

    expect(await bd.listarFincas(), isEmpty);
    expect(await bd.listarPuntos(fincaId: fincaId), isEmpty);
    expect(await bd.listarTareas(fincaId: fincaId), isEmpty);
  });

  test('borrar punto deja sus tareas huérfanas, no las borra (SET NULL)',
      () async {
    final bd = await abrirBdEnMemoria();
    final fincaId = await bd.guardarFinca(Finca(nombre: 'Zunbeltz'));
    final puntoId =
        await bd.guardarPunto(PuntoInfraestructura(fincaId: fincaId));
    final tareaId = await bd.guardarTarea(
        TareaMantenimiento(fincaId: fincaId, puntoId: puntoId, titulo: 'T'));

    await bd.borrarPunto(puntoId);

    final tarea = await bd.obtenerTarea(tareaId);
    expect(tarea, isNotNull);
    expect(tarea!.puntoId, isNull, reason: 'la tarea sobrevive sin punto');
    expect(tarea.fincaId, fincaId);
  });

  test('sembrarFincasDemoSiVacia siembra solo una vez', () async {
    final bd = await abrirBdEnMemoria();
    expect(await bd.sembrarFincasDemoSiVacia(), isTrue);
    expect((await bd.listarFincas()).length, 2);
    // Segunda llamada no duplica.
    expect(await bd.sembrarFincasDemoSiVacia(), isFalse);
    expect((await bd.listarFincas()).length, 2);
  });
}
