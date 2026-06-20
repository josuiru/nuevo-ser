import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../modelos/finca.dart';
import '../modelos/punto_infraestructura.dart';
import '../modelos/tarea_mantenimiento.dart';

/// Acceso a la base de datos local de Solera Zunbeltz. Singleton con
/// inicialización perezosa: la primera lectura crea la BD.
///
/// **Convención de la suite Solera**: las migraciones nunca son
/// destructivas. Cada subida de versión es un paso aditivo en `onUpgrade`.
///
/// v1 arranca con el módulo de gestión de fincas (FZ-2/FZ-3): `fincas`,
/// `puntos_infraestructura` y `tareas_mantenimiento`. El cuaderno ganadero y
/// el resto de tablas llegan en fases posteriores como migraciones aditivas.
class BaseDatosSoleraZunbeltz {
  static final BaseDatosSoleraZunbeltz instancia =
      BaseDatosSoleraZunbeltz._interno();
  factory BaseDatosSoleraZunbeltz() => instancia;
  BaseDatosSoleraZunbeltz._interno();

  /// Constructor para tests: inyecta una BD ya abierta (p. ej. ffi en
  /// memoria) con el esquema aplicado vía [crearEsquemaV1].
  @visibleForTesting
  BaseDatosSoleraZunbeltz.paraTests(Database db) : _basedatos = db;

  Database? _basedatos;

  Future<Database> get basedatos async {
    if (_basedatos != null) return _basedatos!;
    final directorio = await getApplicationDocumentsDirectory();
    final ruta = path_lib.join(directorio.path, 'solera_zunbeltz.db');
    _basedatos = await openDatabase(
      ruta,
      version: 1,
      onConfigure: (db) async {
        // ON DELETE CASCADE / SET NULL requieren FKs activas.
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await crearEsquemaV1(db);
      },
    );
    return _basedatos!;
  }

  /// Crea el esquema v1. Público y estático para reutilizarlo en tests con
  /// una BD ffi en memoria.
  @visibleForTesting
  static Future<void> crearEsquemaV1(Database db) async {
    await db.execute('''
      CREATE TABLE fincas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL DEFAULT '',
        latitud REAL,
        longitud REAL,
        superficie_ha REAL NOT NULL DEFAULT 0,
        recintos_sigpac TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        rutas_fotos_json TEXT NOT NULL DEFAULT '[]'
      )
    ''');

    await db.execute('''
      CREATE TABLE puntos_infraestructura (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        finca_id INTEGER NOT NULL,
        tipo TEXT NOT NULL DEFAULT 'abrevadero',
        nombre TEXT NOT NULL DEFAULT '',
        latitud REAL,
        longitud REAL,
        estado TEXT NOT NULL DEFAULT 'operativo',
        notas TEXT NOT NULL DEFAULT '',
        rutas_fotos_json TEXT NOT NULL DEFAULT '[]',
        fecha_creacion_ms INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (finca_id) REFERENCES fincas(id) ON DELETE CASCADE
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_puntos_finca ON puntos_infraestructura(finca_id)');

    await db.execute('''
      CREATE TABLE tareas_mantenimiento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        finca_id INTEGER NOT NULL,
        punto_id INTEGER,
        titulo TEXT NOT NULL DEFAULT '',
        descripcion TEXT NOT NULL DEFAULT '',
        responsable TEXT NOT NULL DEFAULT '',
        prioridad TEXT NOT NULL DEFAULT 'media',
        estado TEXT NOT NULL DEFAULT 'pendiente',
        fecha_objetivo_ms INTEGER,
        rutas_fotos_antes_json TEXT NOT NULL DEFAULT '[]',
        rutas_fotos_despues_json TEXT NOT NULL DEFAULT '[]',
        coste_centimos INTEGER,
        fecha_creacion_ms INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (finca_id) REFERENCES fincas(id) ON DELETE CASCADE,
        FOREIGN KEY (punto_id) REFERENCES puntos_infraestructura(id) ON DELETE SET NULL
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_tareas_finca ON tareas_mantenimiento(finca_id)');
    await db.execute(
        'CREATE INDEX idx_tareas_punto ON tareas_mantenimiento(punto_id)');
  }

  // ─── Fincas ─────────────────────────────────────────────

  Future<int> guardarFinca(Finca finca) async {
    final db = await basedatos;
    return db.insert('fincas', finca.toMap()..remove('id'));
  }

  Future<void> actualizarFinca(int id, Map<String, Object?> cambios) async {
    final db = await basedatos;
    await db.update('fincas', cambios, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Finca>> listarFincas() async {
    final db = await basedatos;
    final filas = await db.query('fincas', orderBy: 'nombre ASC');
    return filas.map(Finca.fromMap).toList();
  }

  Future<Finca?> obtenerFinca(int id) async {
    final db = await basedatos;
    final filas =
        await db.query('fincas', where: 'id = ?', whereArgs: [id], limit: 1);
    if (filas.isEmpty) return null;
    return Finca.fromMap(filas.first);
  }

  Future<void> borrarFinca(int id) async {
    final db = await basedatos;
    await db.delete('fincas', where: 'id = ?', whereArgs: [id]);
  }

  // ─── Puntos de infraestructura ──────────────────────────

  Future<int> guardarPunto(PuntoInfraestructura punto) async {
    final db = await basedatos;
    return db.insert('puntos_infraestructura', punto.toMap()..remove('id'));
  }

  Future<void> actualizarPunto(int id, Map<String, Object?> cambios) async {
    final db = await basedatos;
    await db.update('puntos_infraestructura', cambios,
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> actualizarPuntoCoords(
      int id, double latitud, double longitud) async {
    await actualizarPunto(id, {'latitud': latitud, 'longitud': longitud});
  }

  Future<List<PuntoInfraestructura>> listarPuntos({int? fincaId}) async {
    final db = await basedatos;
    final filas = fincaId == null
        ? await db.query('puntos_infraestructura',
            orderBy: 'fecha_creacion_ms DESC')
        : await db.query('puntos_infraestructura',
            where: 'finca_id = ?',
            whereArgs: [fincaId],
            orderBy: 'fecha_creacion_ms DESC');
    return filas.map(PuntoInfraestructura.fromMap).toList();
  }

  Future<PuntoInfraestructura?> obtenerPunto(int id) async {
    final db = await basedatos;
    final filas = await db.query('puntos_infraestructura',
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (filas.isEmpty) return null;
    return PuntoInfraestructura.fromMap(filas.first);
  }

  Future<void> borrarPunto(int id) async {
    final db = await basedatos;
    await db.delete('puntos_infraestructura', where: 'id = ?', whereArgs: [id]);
  }

  // ─── Tareas de mantenimiento ────────────────────────────

  Future<int> guardarTarea(TareaMantenimiento tarea) async {
    final db = await basedatos;
    return db.insert('tareas_mantenimiento', tarea.toMap()..remove('id'));
  }

  Future<void> actualizarTarea(int id, Map<String, Object?> cambios) async {
    final db = await basedatos;
    await db.update('tareas_mantenimiento', cambios,
        where: 'id = ?', whereArgs: [id]);
  }

  /// Lista tareas con filtros opcionales acumulables (finca, punto, estado,
  /// responsable). Sin filtros devuelve todas, las más recientes primero.
  Future<List<TareaMantenimiento>> listarTareas({
    int? fincaId,
    int? puntoId,
    String? estado,
    String? responsable,
  }) async {
    final db = await basedatos;
    final condiciones = <String>[];
    final args = <Object?>[];
    if (fincaId != null) {
      condiciones.add('finca_id = ?');
      args.add(fincaId);
    }
    if (puntoId != null) {
      condiciones.add('punto_id = ?');
      args.add(puntoId);
    }
    if (estado != null) {
      condiciones.add('estado = ?');
      args.add(estado);
    }
    if (responsable != null) {
      condiciones.add('responsable = ?');
      args.add(responsable);
    }
    final filas = await db.query(
      'tareas_mantenimiento',
      where: condiciones.isEmpty ? null : condiciones.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'fecha_creacion_ms DESC',
    );
    return filas.map(TareaMantenimiento.fromMap).toList();
  }

  Future<TareaMantenimiento?> obtenerTarea(int id) async {
    final db = await basedatos;
    final filas = await db.query('tareas_mantenimiento',
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (filas.isEmpty) return null;
    return TareaMantenimiento.fromMap(filas.first);
  }

  Future<void> borrarTarea(int id) async {
    final db = await basedatos;
    await db.delete('tareas_mantenimiento', where: 'id = ?', whereArgs: [id]);
  }

  /// Cuenta las tareas que no están hechas (pendiente / en curso / bloqueada).
  Future<int> contarTareasAbiertas() async {
    final db = await basedatos;
    final resultado = await db.rawQuery(
        "SELECT COUNT(*) AS n FROM tareas_mantenimiento WHERE estado != 'hecha'");
    return Sqflite.firstIntValue(resultado) ?? 0;
  }

  // ─── Semilla de ejemplo ─────────────────────────────────

  /// Inserta las dos fincas de Zunbeltz si la BD está vacía. **Son datos de
  /// ejemplo** con superficies públicas y centroides aproximados; las fincas,
  /// recintos e infraestructuras reales se cargan con el equipo de Zunbeltz
  /// (ver BLOQUEOS-PENDIENTES, A4/A5). Devuelve true si sembró.
  Future<bool> sembrarFincasDemoSiVacia() async {
    final existentes = await listarFincas();
    if (existentes.isNotEmpty) return false;
    await guardarFinca(Finca(
      nombre: 'Zunbeltz',
      latitud: 42.7872,
      longitud: -1.9450,
      superficieHa: 231,
      notas: 'Datos de ejemplo · superficie pública, centroide aproximado.',
    ));
    await guardarFinca(Finca(
      nombre: 'La Planilla',
      latitud: 42.8010,
      longitud: -1.9720,
      superficieHa: 197,
      notas: 'Datos de ejemplo · superficie pública, centroide aproximado.',
    ));
    return true;
  }
}
