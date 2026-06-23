// Tests de la base de datos (FZ-2) con sqflite_common_ffi en memoria.
// Cubren el contrato CRUD y, sobre todo, las cascadas de borrado: borrar
// una finca arrastra sus puntos y tareas; borrar un punto deja sus tareas
// huérfanas (punto_id = NULL) sin perderlas.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:solera_zunbeltz/datos/base_datos.dart';
import 'package:solera_zunbeltz/modelos/apunte_economico.dart';
import 'package:solera_zunbeltz/modelos/finca.dart';
import 'package:solera_zunbeltz/modelos/proyecto_test.dart';
import 'package:solera_zunbeltz/modelos/punto_infraestructura.dart';
import 'package:solera_zunbeltz/modelos/registro_actividad.dart';
import 'package:solera_zunbeltz/modelos/registro_comercializacion.dart';
import 'package:solera_zunbeltz/modelos/tarea_mantenimiento.dart';
import 'package:solera_zunbeltz/modelos/validacion_producto.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  Future<BaseDatosSoleraZunbeltz> abrirBdEnMemoria() async {
    final db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 3,
        // BD nueva por test: sin esto, todas las llamadas comparten la
        // misma BD en memoria y el estado se filtra entre tests.
        singleInstance: false,
        onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
        onCreate: (d, v) async {
          await BaseDatosSoleraZunbeltz.crearEsquemaV1(d);
          await BaseDatosSoleraZunbeltz.aplicarMigracionV2(d);
          await BaseDatosSoleraZunbeltz.aplicarMigracionV3(d);
        },
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

  test('seguimiento: registros y agregados de actividad', () async {
    final bd = await abrirBdEnMemoria();
    final fincaId = await bd.guardarFinca(Finca(nombre: 'Zunbeltz'));
    await bd.guardarRegistro(RegistroActividad(
        fincaId: fincaId, tipo: 'alimentacion', cantidad: 100, fechaMs: 10));
    await bd.guardarRegistro(RegistroActividad(
        fincaId: fincaId, tipo: 'alimentacion', cantidad: 50, fechaMs: 20));
    await bd.guardarRegistro(RegistroActividad(
        fincaId: fincaId, tipo: 'paricion', cantidad: 3, fechaMs: 30));

    expect(await bd.sumarCantidadActividad('alimentacion', fincaId: fincaId), 150);
    expect(await bd.sumarCantidadActividad('paricion', fincaId: fincaId), 3);
    expect(await bd.sumarCantidadActividad('producto', fincaId: fincaId), 0);
    expect((await bd.listarRegistros(fincaId: fincaId)).length, 3);
    // Filtro por rango de fechas.
    expect(
        await bd.sumarCantidadActividad('alimentacion',
            fincaId: fincaId, desdeMs: 15),
        50);
  });

  test('seguimiento: apuntes económicos y balance', () async {
    final bd = await abrirBdEnMemoria();
    final fincaId = await bd.guardarFinca(Finca(nombre: 'Zunbeltz'));
    await bd.guardarApunte(ApunteEconomico(
        fincaId: fincaId, tipo: 'ingreso', importeCentimos: 50000, fechaMs: 1));
    await bd.guardarApunte(ApunteEconomico(
        fincaId: fincaId, tipo: 'gasto', importeCentimos: 18000, fechaMs: 2));

    expect(await bd.sumarImporteEconomico('ingreso', fincaId: fincaId), 50000);
    expect(await bd.sumarImporteEconomico('gasto', fincaId: fincaId), 18000);
    expect((await bd.listarApuntes(fincaId: fincaId)).length, 2);
  });

  test('migración v1 → v3 (cadena completa) conserva datos y habilita seguimiento',
      () async {
    final dir = await Directory.systemTemp.createTemp('zunbeltz_mig');
    final ruta = '${dir.path}/migracion.db';
    // Abrimos en v1 (solo gestión de fincas) y metemos una finca.
    final v1 = await databaseFactoryFfi.openDatabase(
      ruta,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
        onCreate: (d, v) => BaseDatosSoleraZunbeltz.crearEsquemaV1(d),
      ),
    );
    await v1.insert('fincas', Finca(nombre: 'Zunbeltz').toMap()..remove('id'));
    await v1.close();

    // Reabrimos en v3: las migraciones v2 y v3 deben correr en cadena y
    // conservar la finca.
    final v3 = await databaseFactoryFfi.openDatabase(
      ruta,
      options: OpenDatabaseOptions(
        version: 3,
        onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
        onUpgrade: (d, anterior, actual) async {
          if (anterior < 2) await BaseDatosSoleraZunbeltz.aplicarMigracionV2(d);
          if (anterior < 3) await BaseDatosSoleraZunbeltz.aplicarMigracionV3(d);
        },
      ),
    );
    final bd = BaseDatosSoleraZunbeltz.paraTests(v3);
    expect((await bd.listarFincas()).single.nombre, 'Zunbeltz');
    // El seguimiento existe y funciona (incluida la columna proyecto_id de v3).
    final fincaId = (await bd.listarFincas()).single.id!;
    await bd.guardarRegistro(RegistroActividad(
        fincaId: fincaId, tipo: 'alimentacion', cantidad: 10));
    expect(await bd.sumarCantidadActividad('alimentacion'), 10);
    await v3.close();
    await dir.delete(recursive: true);
  });

  test('proceso de test: proyecto + comercialización + validación', () async {
    final bd = await abrirBdEnMemoria();
    final proyectoId = await bd.guardarProyecto(
        ProyectoTest(nombre: 'Quesería test', persona: 'Maite'));
    await bd.guardarComercializacion(RegistroComercializacion(
        proyectoId: proyectoId,
        producto: 'Queso',
        canal: 'directa',
        cantidad: 10,
        precioUnitarioCentimos: 1200,
        ingresoCentimos: 12000));
    await bd.guardarValidacion(ValidacionProducto(
        proyectoId: proyectoId,
        descripcion: 'Curación 60 días',
        resultado: 'validado',
        valoracion: 4));

    expect((await bd.listarProyectos()).single.persona, 'Maite');
    expect((await bd.listarComercializacion(proyectoId: proyectoId)).single.producto, 'Queso');
    expect(await bd.sumarIngresoComercializacion(proyectoId: proyectoId), 12000);
    expect((await bd.listarValidaciones(proyectoId: proyectoId)).single.resultado, 'validado');
  });

  test('rentabilidad por proyecto = ingresos (comercial+apuntes) − gastos',
      () async {
    final bd = await abrirBdEnMemoria();
    final fincaId = await bd.guardarFinca(Finca(nombre: 'Zunbeltz'));
    final proyectoId = await bd.guardarProyecto(
        ProyectoTest(nombre: 'P', persona: 'Iñaki', fincaId: fincaId));
    await bd.guardarComercializacion(RegistroComercializacion(
        proyectoId: proyectoId, ingresoCentimos: 30000));
    await bd.guardarApunte(ApunteEconomico(
        fincaId: fincaId,
        proyectoId: proyectoId,
        tipo: 'ingreso',
        importeCentimos: 5000));
    await bd.guardarApunte(ApunteEconomico(
        fincaId: fincaId,
        proyectoId: proyectoId,
        tipo: 'gasto',
        importeCentimos: 12000));

    final r = await bd.rentabilidadProyecto(proyectoId);
    expect(r.ingresosComercializacionCentimos, 30000);
    expect(r.ingresosApuntesCentimos, 5000);
    expect(r.gastosCentimos, 12000);
    expect(r.balanceCentimos, 23000); // 35000 - 12000
    expect(r.balanceAnualExtrapoladoCentimos(73), 115000); // 23000 * 365/73
  });

  test('borrar proyecto arrastra su comercialización y validaciones (CASCADE)',
      () async {
    final bd = await abrirBdEnMemoria();
    final proyectoId =
        await bd.guardarProyecto(ProyectoTest(nombre: 'P', persona: 'A'));
    await bd.guardarComercializacion(
        RegistroComercializacion(proyectoId: proyectoId, ingresoCentimos: 100));
    await bd.guardarValidacion(ValidacionProducto(proyectoId: proyectoId));

    await bd.borrarProyecto(proyectoId);

    expect(await bd.listarProyectos(), isEmpty);
    expect(await bd.listarComercializacion(proyectoId: proyectoId), isEmpty);
    expect(await bd.listarValidaciones(proyectoId: proyectoId), isEmpty);
  });

  test('migración v2 → v3 conserva datos y habilita proceso de test', () async {
    final dir = await Directory.systemTemp.createTemp('zunbeltz_mig3');
    final ruta = '${dir.path}/m3.db';
    final v2 = await databaseFactoryFfi.openDatabase(
      ruta,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
        onCreate: (d, v) async {
          await BaseDatosSoleraZunbeltz.crearEsquemaV1(d);
          await BaseDatosSoleraZunbeltz.aplicarMigracionV2(d);
        },
      ),
    );
    await v2.insert('fincas', Finca(nombre: 'Zunbeltz').toMap()..remove('id'));
    await v2.close();

    final v3 = await databaseFactoryFfi.openDatabase(
      ruta,
      options: OpenDatabaseOptions(
        version: 3,
        onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
        onUpgrade: (d, anterior, actual) async {
          if (anterior < 3) await BaseDatosSoleraZunbeltz.aplicarMigracionV3(d);
        },
      ),
    );
    final bd = BaseDatosSoleraZunbeltz.paraTests(v3);
    expect((await bd.listarFincas()).single.nombre, 'Zunbeltz');
    // La tabla nueva funciona y el seguimiento ya admite proyecto_id.
    final proyectoId =
        await bd.guardarProyecto(ProyectoTest(nombre: 'P', persona: 'A'));
    final fincaId = (await bd.listarFincas()).single.id!;
    await bd.guardarApunte(ApunteEconomico(
        fincaId: fincaId,
        proyectoId: proyectoId,
        tipo: 'gasto',
        importeCentimos: 999));
    expect(await bd.sumarImporteEconomico('gasto', proyectoId: proyectoId), 999);
    await v3.close();
    await dir.delete(recursive: true);
  });
}
