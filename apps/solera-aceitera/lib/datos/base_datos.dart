import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../modelos/analitica.dart';
import '../modelos/campania.dart';
import '../modelos/incidencia.dart';
import '../modelos/lote_aceite.dart';
import '../modelos/molturacion.dart';
import '../modelos/movimiento.dart';
import '../modelos/olivar.dart';
import '../modelos/olivo.dart';
import '../modelos/parcela.dart';
import '../modelos/partida_aceituna.dart';
import '../modelos/recoleccion.dart';
import '../modelos/titular.dart';
import '../modelos/tratamiento.dart';
import '../modelos/venta.dart';

/// Acceso a la base de datos local de Solera Aceitera. Singleton con
/// inicialización perezosa: la primera lectura crea/migra la BD.
///
/// **Convención**: las migraciones nunca son destructivas (heredada
/// de la suite Solera). Cualquier almazara en campaña lleva años de
/// recolecciones, molturaciones y lotes de aceite registrados —
/// perder un dato por una actualización es inaceptable y, en el caso
/// del libro de movimientos, ilegal por AICA. Cada subida de versión
/// es un paso aditivo en `_aplicarMigraciones`.
///
/// v1 arranca con esquema completo (titular + olivar + parcelas +
/// olivos + campañas + recolecciones + partidas + molturaciones +
/// lotes_aceite + movimientos + ventas + tratamientos + incidencias +
/// analíticas).
class BaseDatosSoleraAceitera {
  static final BaseDatosSoleraAceitera instancia =
      BaseDatosSoleraAceitera._interno();
  factory BaseDatosSoleraAceitera() => instancia;
  BaseDatosSoleraAceitera._interno();

  Database? _basedatos;

  Future<Database> get basedatos async {
    if (_basedatos != null) return _basedatos!;
    final directorio = await getApplicationDocumentsDirectory();
    final ruta = path_lib.join(directorio.path, 'solera_aceitera.db');
    _basedatos = await openDatabase(
      ruta,
      version: 1,
      onConfigure: (db) async {
        // Activar Foreign Keys. SQLite las desactiva por defecto en cada
        // conexión — sin esto, las cascadas FK no se respetan.
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _crearEsquemaV1(db);
      },
      onUpgrade: (db, anterior, actual) async {
        await _aplicarMigraciones(db, anterior, actual);
      },
    );
    return _basedatos!;
  }

  /// Esquema completo de la versión 1. Si necesitas cambiar tablas,
  /// añade un paso en `_aplicarMigraciones` y bumpea `version` en
  /// `openDatabase` — nunca modifiques este método para no romper
  /// instalaciones existentes.
  Future<void> _crearEsquemaV1(Database db) async {
    // ─── Titular (single-row en v0.1) ───
    await db.execute('''
      CREATE TABLE titulares (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        razon_social TEXT NOT NULL DEFAULT '',
        nif TEXT NOT NULL DEFAULT '',
        rgseaa TEXT NOT NULL DEFAULT '',
        numero_aica TEXT NOT NULL DEFAULT '',
        direccion TEXT NOT NULL DEFAULT '',
        telefono TEXT NOT NULL DEFAULT '',
        email TEXT NOT NULL DEFAULT '',
        iban_reagp TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        rutas_fotos_json TEXT NOT NULL DEFAULT '[]'
      )
    ''');

    // ─── Olivar (single-row en v0.1) ───
    await db.execute('''
      CREATE TABLE olivares (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL DEFAULT '',
        titular_id INTEGER NOT NULL,
        municipio TEXT NOT NULL DEFAULT '',
        provincia TEXT NOT NULL DEFAULT '',
        comarca TEXT NOT NULL DEFAULT '',
        certificacion_ecologico INTEGER NOT NULL DEFAULT 0,
        certificacion_integrada INTEGER NOT NULL DEFAULT 0,
        dop_id TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        rutas_fotos_json TEXT NOT NULL DEFAULT '[]',
        FOREIGN KEY (titular_id) REFERENCES titulares(id) ON DELETE RESTRICT
      )
    ''');

    // ─── Parcelas ───
    await db.execute('''
      CREATE TABLE parcelas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        olivar_id INTEGER NOT NULL,
        nombre TEXT NOT NULL DEFAULT '',
        codigo_sigpac TEXT NOT NULL DEFAULT '',
        superficie_ha REAL NOT NULL DEFAULT 0,
        variedad_mayoritaria_id TEXT NOT NULL DEFAULT '',
        marco_plantacion TEXT NOT NULL DEFAULT '',
        edad_media_anyos INTEGER NOT NULL DEFAULT 0,
        sistema_riego TEXT NOT NULL DEFAULT 'secano',
        latitud REAL,
        longitud REAL,
        poligono_geojson TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        rutas_fotos_json TEXT NOT NULL DEFAULT '[]',
        fecha_creacion_ms INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (olivar_id) REFERENCES olivares(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('CREATE INDEX idx_parcelas_olivar ON parcelas(olivar_id)');

    // ─── Olivos (pie individual; granularidad opcional) ───
    await db.execute('''
      CREATE TABLE olivos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parcela_id INTEGER NOT NULL,
        identificador_interno TEXT NOT NULL DEFAULT '',
        variedad_id TEXT NOT NULL DEFAULT '',
        edad_anyos INTEGER NOT NULL DEFAULT 0,
        estado TEXT NOT NULL DEFAULT 'productivo',
        fecha_plantacion_ms INTEGER,
        notas TEXT NOT NULL DEFAULT '',
        fecha_creacion_ms INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (parcela_id) REFERENCES parcelas(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('CREATE INDEX idx_olivos_parcela ON olivos(parcela_id)');

    // ─── Campañas ───
    await db.execute('''
      CREATE TABLE campanias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        olivar_id INTEGER NOT NULL,
        anyo_comercial INTEGER NOT NULL,
        fecha_inicio_ms INTEGER NOT NULL,
        fecha_fin_ms INTEGER,
        produccion_total_kg_aceituna REAL NOT NULL DEFAULT 0,
        produccion_total_kg_aceite REAL NOT NULL DEFAULT 0,
        rendimiento_medio_porcentaje REAL NOT NULL DEFAULT 0,
        observaciones_meteorologicas TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (olivar_id) REFERENCES olivares(id) ON DELETE CASCADE
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_campanias_olivar ON campanias(olivar_id)');
    await db.execute(
        'CREATE INDEX idx_campanias_anyo ON campanias(anyo_comercial)');

    // ─── Recolecciones (parte diario de aceituna en olivar) ───
    await db.execute('''
      CREATE TABLE recolecciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parcela_id INTEGER NOT NULL,
        campania_id INTEGER NOT NULL,
        fecha_ms INTEGER NOT NULL,
        kg_estimados REAL NOT NULL DEFAULT 0,
        tipo_aceituna TEXT NOT NULL DEFAULT 'envero',
        metodo TEXT NOT NULL DEFAULT 'vibrador',
        cuadrilla TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        rutas_fotos_json TEXT NOT NULL DEFAULT '[]',
        FOREIGN KEY (parcela_id) REFERENCES parcelas(id) ON DELETE CASCADE,
        FOREIGN KEY (campania_id) REFERENCES campanias(id) ON DELETE CASCADE
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_recolecciones_campania ON recolecciones(campania_id)');
    await db.execute(
        'CREATE INDEX idx_recolecciones_parcela ON recolecciones(parcela_id)');
    await db.execute(
        'CREATE INDEX idx_recolecciones_fecha ON recolecciones(fecha_ms)');

    // ─── Partidas de aceituna (recepción en almazara) ───
    await db.execute('''
      CREATE TABLE partidas_aceituna (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        campania_id INTEGER NOT NULL,
        recoleccion_id INTEGER,
        fecha_ms INTEGER NOT NULL,
        kg_netos_bascula REAL NOT NULL DEFAULT 0,
        porcentaje_aceituna_defectuosa REAL NOT NULL DEFAULT 0,
        catador TEXT NOT NULL DEFAULT '',
        numero_albaran TEXT NOT NULL DEFAULT '',
        origen_es_socio INTEGER NOT NULL DEFAULT 0,
        socio_externo TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        rutas_fotos_json TEXT NOT NULL DEFAULT '[]',
        FOREIGN KEY (campania_id) REFERENCES campanias(id) ON DELETE CASCADE,
        FOREIGN KEY (recoleccion_id) REFERENCES recolecciones(id) ON DELETE SET NULL
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_partidas_campania ON partidas_aceituna(campania_id)');
    await db.execute(
        'CREATE INDEX idx_partidas_recoleccion ON partidas_aceituna(recoleccion_id)');
    await db.execute(
        'CREATE INDEX idx_partidas_fecha ON partidas_aceituna(fecha_ms)');

    // ─── Molturaciones ───
    await db.execute('''
      CREATE TABLE molturaciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        campania_id INTEGER NOT NULL,
        fecha_ms INTEGER NOT NULL,
        kg_molturados REAL NOT NULL DEFAULT 0,
        rendimiento_porcentaje REAL NOT NULL DEFAULT 0,
        aceite_obtenido_kg REAL NOT NULL DEFAULT 0,
        lote_aceite_id INTEGER,
        alperujo_kg REAL NOT NULL DEFAULT 0,
        batidora_referencia TEXT NOT NULL DEFAULT '',
        decanter_referencia TEXT NOT NULL DEFAULT '',
        partidas_usadas_json TEXT NOT NULL DEFAULT '[]',
        notas TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (campania_id) REFERENCES campanias(id) ON DELETE CASCADE,
        FOREIGN KEY (lote_aceite_id) REFERENCES lotes_aceite(id) ON DELETE SET NULL
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_molturaciones_campania ON molturaciones(campania_id)');
    await db.execute(
        'CREATE INDEX idx_molturaciones_lote ON molturaciones(lote_aceite_id)');

    // ─── Lotes de aceite (entidad central libro de movimientos) ───
    await db.execute('''
      CREATE TABLE lotes_aceite (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        campania_id INTEGER NOT NULL,
        identificador_lote TEXT NOT NULL,
        fecha_creacion_ms INTEGER NOT NULL,
        kg_netos REAL NOT NULL DEFAULT 0,
        acidez REAL,
        peroxidos REAL,
        k232 REAL,
        k270 REAL,
        polifenoles_mg_kg REAL,
        panel_test_puntuacion REAL,
        panel_test_notas TEXT NOT NULL DEFAULT '',
        categoria TEXT NOT NULL DEFAULT 'por_clasificar',
        dop_id TEXT NOT NULL DEFAULT '',
        ubicacion_fisica TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (campania_id) REFERENCES campanias(id) ON DELETE CASCADE
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_lotes_campania ON lotes_aceite(campania_id)');
    // Identificador único: dos lotes con el mismo identificador en la
    // misma campaña son ambiguos.
    await db.execute(
        'CREATE UNIQUE INDEX idx_lotes_identificador ON lotes_aceite(campania_id, identificador_lote)');

    // ─── Movimientos (libro de movimientos del aceite) ───
    await db.execute('''
      CREATE TABLE movimientos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lote_aceite_id INTEGER NOT NULL,
        fecha_ms INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        kg_movidos REAL NOT NULL DEFAULT 0,
        ubicacion_destino TEXT NOT NULL DEFAULT '',
        venta_id INTEGER,
        lote_destino_mezcla_id INTEGER,
        notas TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (lote_aceite_id) REFERENCES lotes_aceite(id) ON DELETE CASCADE,
        FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE SET NULL,
        FOREIGN KEY (lote_destino_mezcla_id) REFERENCES lotes_aceite(id) ON DELETE SET NULL
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_movimientos_lote ON movimientos(lote_aceite_id)');
    await db.execute(
        'CREATE INDEX idx_movimientos_fecha ON movimientos(fecha_ms)');
    await db.execute('CREATE INDEX idx_movimientos_tipo ON movimientos(tipo)');

    // ─── Ventas ───
    await db.execute('''
      CREATE TABLE ventas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha_ms INTEGER NOT NULL,
        tipo_cliente TEXT NOT NULL DEFAULT 'particular',
        nombre_cliente TEXT NOT NULL DEFAULT '',
        identificador_fiscal_cliente TEXT NOT NULL DEFAULT '',
        numero_factura TEXT NOT NULL DEFAULT '',
        lineas_json TEXT NOT NULL DEFAULT '[]',
        total_sin_iva REAL NOT NULL DEFAULT 0,
        iva_porcentaje REAL NOT NULL DEFAULT 0,
        total_con_iva REAL NOT NULL DEFAULT 0,
        destino_pais_iso TEXT NOT NULL DEFAULT 'ES',
        notas TEXT NOT NULL DEFAULT ''
      )
    ''');
    await db.execute('CREATE INDEX idx_ventas_fecha ON ventas(fecha_ms)');

    // ─── Tratamientos fitosanitarios ───
    await db.execute('''
      CREATE TABLE tratamientos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parcela_id INTEGER NOT NULL,
        fecha_ms INTEGER NOT NULL,
        producto_comercial_referencia TEXT NOT NULL DEFAULT '',
        sustancia_activa_id TEXT NOT NULL DEFAULT '',
        dosis_litros_por_ha REAL NOT NULL DEFAULT 0,
        plaga_objetivo_id TEXT NOT NULL DEFAULT '',
        aplicador_nombre TEXT NOT NULL DEFAULT '',
        carnet_aplicador_numero TEXT NOT NULL DEFAULT '',
        observaciones TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        rutas_fotos_json TEXT NOT NULL DEFAULT '[]',
        FOREIGN KEY (parcela_id) REFERENCES parcelas(id) ON DELETE CASCADE
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_tratamientos_parcela ON tratamientos(parcela_id)');
    await db.execute(
        'CREATE INDEX idx_tratamientos_fecha ON tratamientos(fecha_ms)');

    // ─── Incidencias ───
    await db.execute('''
      CREATE TABLE incidencias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha_ms INTEGER NOT NULL,
        ambito TEXT NOT NULL DEFAULT 'olivar',
        parcela_id INTEGER,
        lote_aceite_id INTEGER,
        tipo TEXT NOT NULL DEFAULT 'otro',
        descripcion TEXT NOT NULL DEFAULT '',
        severidad TEXT NOT NULL DEFAULT 'leve',
        accion_correctiva TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        rutas_fotos_json TEXT NOT NULL DEFAULT '[]',
        FOREIGN KEY (parcela_id) REFERENCES parcelas(id) ON DELETE SET NULL,
        FOREIGN KEY (lote_aceite_id) REFERENCES lotes_aceite(id) ON DELETE SET NULL
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_incidencias_fecha ON incidencias(fecha_ms)');
    await db.execute(
        'CREATE INDEX idx_incidencias_ambito ON incidencias(ambito)');

    // ─── Analíticas ───
    await db.execute('''
      CREATE TABLE analiticas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lote_aceite_id INTEGER NOT NULL,
        fecha_ms INTEGER NOT NULL,
        acidez REAL,
        peroxidos REAL,
        k232 REAL,
        k270 REAL,
        polifenoles_mg_kg REAL,
        color REAL,
        humedad REAL,
        panel_test_puntuacion REAL,
        panel_test_notas TEXT NOT NULL DEFAULT '',
        laboratorio TEXT NOT NULL DEFAULT '',
        notas TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (lote_aceite_id) REFERENCES lotes_aceite(id) ON DELETE CASCADE
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_analiticas_lote ON analiticas(lote_aceite_id)');
    await db.execute(
        'CREATE INDEX idx_analiticas_fecha ON analiticas(fecha_ms)');
  }

  /// Cadena de migraciones aditivas — nunca destructivas. Cada subida
  /// añade ALTER TABLE o tablas nuevas. Si se necesita renombrar o
  /// dropear, se hace por copia (tabla nueva + INSERT desde la vieja
  /// + DROP de la vieja DESPUÉS de verificar).
  Future<void> _aplicarMigraciones(
    Database db,
    int versionAnterior,
    int versionActual,
  ) async {
    // v1 → futuras migraciones aquí.
  }

  // ──────────────────────── CRUD básico ────────────────────────
  // Métodos mínimos para que F1-A3 (pantallas) pueda anclar.

  Future<int> insertarTitular(Titular t) async {
    final db = await basedatos;
    return db.insert('titulares', t.toMap()..remove('id'));
  }

  Future<Titular?> obtenerTitular() async {
    final db = await basedatos;
    final filas = await db.query('titulares', limit: 1);
    if (filas.isEmpty) return null;
    return Titular.fromMap(filas.first);
  }

  Future<int> insertarOlivar(Olivar o) async {
    final db = await basedatos;
    return db.insert('olivares', o.toMap()..remove('id'));
  }

  Future<Olivar?> obtenerOlivar() async {
    final db = await basedatos;
    final filas = await db.query('olivares', limit: 1);
    if (filas.isEmpty) return null;
    return Olivar.fromMap(filas.first);
  }

  Future<int> insertarParcela(Parcela p) async {
    final db = await basedatos;
    return db.insert('parcelas', p.toMap()..remove('id'));
  }

  Future<List<Parcela>> listarParcelas({int? olivarId}) async {
    final db = await basedatos;
    final filas = olivarId == null
        ? await db.query('parcelas', orderBy: 'nombre ASC')
        : await db.query('parcelas',
            where: 'olivar_id = ?',
            whereArgs: [olivarId],
            orderBy: 'nombre ASC');
    return filas.map(Parcela.fromMap).toList(growable: false);
  }

  Future<int> insertarOlivo(Olivo o) async {
    final db = await basedatos;
    return db.insert('olivos', o.toMap()..remove('id'));
  }

  Future<int> insertarCampania(Campania c) async {
    final db = await basedatos;
    return db.insert('campanias', c.toMap()..remove('id'));
  }

  Future<List<Campania>> listarCampanias() async {
    final db = await basedatos;
    final filas =
        await db.query('campanias', orderBy: 'anyo_comercial DESC');
    return filas.map(Campania.fromMap).toList(growable: false);
  }

  Future<int> insertarRecoleccion(Recoleccion r) async {
    final db = await basedatos;
    return db.insert('recolecciones', r.toMap()..remove('id'));
  }

  Future<List<Recoleccion>> listarRecolecciones({int? campaniaId}) async {
    final db = await basedatos;
    final filas = campaniaId == null
        ? await db.query('recolecciones', orderBy: 'fecha_ms DESC')
        : await db.query('recolecciones',
            where: 'campania_id = ?',
            whereArgs: [campaniaId],
            orderBy: 'fecha_ms DESC');
    return filas.map(Recoleccion.fromMap).toList(growable: false);
  }

  Future<int> insertarPartidaAceituna(PartidaAceituna p) async {
    final db = await basedatos;
    return db.insert('partidas_aceituna', p.toMap()..remove('id'));
  }

  Future<int> insertarMolturacion(Molturacion m) async {
    final db = await basedatos;
    return db.insert('molturaciones', m.toMap()..remove('id'));
  }

  Future<int> insertarLoteAceite(LoteAceite l) async {
    final db = await basedatos;
    return db.insert('lotes_aceite', l.toMap()..remove('id'));
  }

  Future<List<LoteAceite>> listarLotesAceite({int? campaniaId}) async {
    final db = await basedatos;
    final filas = campaniaId == null
        ? await db.query('lotes_aceite', orderBy: 'fecha_creacion_ms DESC')
        : await db.query('lotes_aceite',
            where: 'campania_id = ?',
            whereArgs: [campaniaId],
            orderBy: 'fecha_creacion_ms DESC');
    return filas.map(LoteAceite.fromMap).toList(growable: false);
  }

  Future<int> insertarMovimiento(Movimiento m) async {
    final db = await basedatos;
    return db.insert('movimientos', m.toMap()..remove('id'));
  }

  Future<List<Movimiento>> listarMovimientos({int? loteAceiteId}) async {
    final db = await basedatos;
    final filas = loteAceiteId == null
        ? await db.query('movimientos', orderBy: 'fecha_ms DESC')
        : await db.query('movimientos',
            where: 'lote_aceite_id = ?',
            whereArgs: [loteAceiteId],
            orderBy: 'fecha_ms DESC');
    return filas.map(Movimiento.fromMap).toList(growable: false);
  }

  Future<int> insertarVenta(Venta v) async {
    final db = await basedatos;
    return db.insert('ventas', v.toMap()..remove('id'));
  }

  Future<int> insertarTratamiento(Tratamiento t) async {
    final db = await basedatos;
    return db.insert('tratamientos', t.toMap()..remove('id'));
  }

  Future<List<Tratamiento>> listarTratamientos({int? parcelaId}) async {
    final db = await basedatos;
    final filas = parcelaId == null
        ? await db.query('tratamientos', orderBy: 'fecha_ms DESC')
        : await db.query('tratamientos',
            where: 'parcela_id = ?',
            whereArgs: [parcelaId],
            orderBy: 'fecha_ms DESC');
    return filas.map(Tratamiento.fromMap).toList(growable: false);
  }

  Future<int> insertarIncidencia(Incidencia i) async {
    final db = await basedatos;
    return db.insert('incidencias', i.toMap()..remove('id'));
  }

  Future<int> insertarAnalitica(Analitica a) async {
    final db = await basedatos;
    return db.insert('analiticas', a.toMap()..remove('id'));
  }

  Future<List<Analitica>> listarAnaliticas({int? loteAceiteId}) async {
    final db = await basedatos;
    final filas = loteAceiteId == null
        ? await db.query('analiticas', orderBy: 'fecha_ms DESC')
        : await db.query('analiticas',
            where: 'lote_aceite_id = ?',
            whereArgs: [loteAceiteId],
            orderBy: 'fecha_ms DESC');
    return filas.map(Analitica.fromMap).toList(growable: false);
  }

  /// Cierra la conexión. Usado por tests para forzar reapertura.
  Future<void> cerrar() async {
    await _basedatos?.close();
    _basedatos = null;
  }
}
