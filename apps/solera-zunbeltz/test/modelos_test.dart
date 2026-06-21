// Tests POJO de los modelos de FZ-2: round-trip toMap/fromMap y defaults.

import 'package:flutter_test/flutter_test.dart';

import 'package:solera_zunbeltz/modelos/apunte_economico.dart';
import 'package:solera_zunbeltz/modelos/constantes.dart';
import 'package:solera_zunbeltz/modelos/finca.dart';
import 'package:solera_zunbeltz/modelos/indicadores_seguimiento.dart';
import 'package:solera_zunbeltz/modelos/punto_infraestructura.dart';
import 'package:solera_zunbeltz/modelos/registro_actividad.dart';
import 'package:solera_zunbeltz/modelos/tarea_mantenimiento.dart';

void main() {
  group('Finca', () {
    test('toMap / fromMap ida y vuelta', () {
      final original = Finca(
        nombre: 'Zunbeltz',
        latitud: 42.7872,
        longitud: -1.9450,
        superficieHa: 231,
        recintosSigpac: '31:123:0:0:1',
        notas: 'finca cedida',
      );
      final recuperada = Finca.fromMap(original.toMap());
      expect(recuperada.nombre, 'Zunbeltz');
      expect(recuperada.latitud, closeTo(42.7872, 1e-6));
      expect(recuperada.longitud, closeTo(-1.9450, 1e-6));
      expect(recuperada.superficieHa, 231);
      expect(recuperada.recintosSigpac, '31:123:0:0:1');
      expect(recuperada.notas, 'finca cedida');
    });

    test('valores por defecto', () {
      final f = Finca();
      expect(f.id, isNull);
      expect(f.nombre, '');
      expect(f.superficieHa, 0);
      expect(f.rutasFotosJson, '[]');
    });
  });

  group('PuntoInfraestructura', () {
    test('toMap / fromMap conserva tipo, estado y coords', () {
      final punto = PuntoInfraestructura(
        fincaId: 3,
        tipo: 'abrevadero',
        nombre: 'Abrevadero Norte',
        latitud: 42.79,
        longitud: -1.95,
        estado: 'revisar',
        fechaCreacionMs: 1000,
      );
      final recuperado = PuntoInfraestructura.fromMap(punto.toMap());
      expect(recuperado.fincaId, 3);
      expect(recuperado.tipo, 'abrevadero');
      expect(recuperado.estado, 'revisar');
      expect(recuperado.latitud, closeTo(42.79, 1e-6));
      expect(recuperado.nombre, 'Abrevadero Norte');
    });

    test('defaults usan los códigos por defecto', () {
      final p = PuntoInfraestructura(fincaId: 1);
      expect(p.tipo, tipoPuntoPorDefecto);
      expect(p.estado, estadoPuntoPorDefecto);
    });
  });

  group('TareaMantenimiento', () {
    test('toMap / fromMap conserva nullable y coste', () {
      final tarea = TareaMantenimiento(
        fincaId: 1,
        puntoId: 7,
        titulo: 'Tensar 200 m de alambrada',
        responsable: 'Aitor',
        prioridad: 'alta',
        estado: 'en_curso',
        fechaObjetivoMs: 5000,
        costeCentimos: 4500,
        fechaCreacionMs: 2000,
      );
      final recuperada = TareaMantenimiento.fromMap(tarea.toMap());
      expect(recuperada.puntoId, 7);
      expect(recuperada.titulo, 'Tensar 200 m de alambrada');
      expect(recuperada.estado, 'en_curso');
      expect(recuperada.prioridad, 'alta');
      expect(recuperada.fechaObjetivoMs, 5000);
      expect(recuperada.costeCentimos, 4500);
    });

    test('tarea de finca (sin punto) conserva punto_id nulo', () {
      final tarea = TareaMantenimiento(fincaId: 2, titulo: 'Desbroce general');
      final recuperada = TareaMantenimiento.fromMap(tarea.toMap());
      expect(recuperada.puntoId, isNull);
      expect(recuperada.costeCentimos, isNull);
      expect(recuperada.estado, estadoTareaPorDefecto);
    });
  });

  group('Catálogos', () {
    test('buscarOpcion encuentra por código y devuelve etiqueta bilingüe', () {
      final opcion = buscarOpcion(tiposPunto, 'manga');
      expect(opcion, isNotNull);
      expect(opcion!.etiqueta('es'), 'Manga de manejo');
      expect(opcion.etiqueta('eu'), isNotEmpty);
    });

    test('buscarOpcion devuelve null si el código no existe', () {
      expect(buscarOpcion(estadosTarea, 'inexistente'), isNull);
    });
  });

  group('RegistroActividad', () {
    test('toMap / fromMap conserva tipo y cantidad', () {
      final r = RegistroActividad(
        fincaId: 1,
        tipo: 'alimentacion',
        cantidad: 120.5,
        fechaMs: 9000,
        lote: 'Rebaño A',
      );
      final recuperado = RegistroActividad.fromMap(r.toMap());
      expect(recuperado.tipo, 'alimentacion');
      expect(recuperado.cantidad, closeTo(120.5, 1e-9));
      expect(recuperado.lote, 'Rebaño A');
    });
  });

  group('ApunteEconomico', () {
    test('toMap / fromMap conserva importe en céntimos', () {
      final a = ApunteEconomico(
        fincaId: 1,
        tipo: 'ingreso',
        concepto: 'Venta de corderos',
        importeCentimos: 45000,
        fechaMs: 1000,
      );
      final recuperado = ApunteEconomico.fromMap(a.toMap());
      expect(recuperado.tipo, 'ingreso');
      expect(recuperado.importeCentimos, 45000);
      expect(recuperado.concepto, 'Venta de corderos');
    });
  });

  group('IndicadoresSeguimiento', () {
    test('balance = ingresos - gastos', () {
      const ind = IndicadoresSeguimiento(
          ingresosCentimos: 50000, gastosCentimos: 18000);
      expect(ind.balanceCentimos, 32000);
    });

    test('eurosDesdeCentimos y cantidadBonita formatean bien', () {
      expect(eurosDesdeCentimos(45000), '450,00');
      expect(cantidadBonita(3), '3');
      expect(cantidadBonita(12.5), '12,5');
    });
  });
}
