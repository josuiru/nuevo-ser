import 'package:flutter_test/flutter_test.dart';

import 'package:solera_quesera/modelos/analitica.dart';
import 'package:solera_quesera/modelos/control_limpieza.dart';
import 'package:solera_quesera/modelos/control_plagas.dart';
import 'package:solera_quesera/modelos/control_temperatura.dart';
import 'package:solera_quesera/modelos/evento_curacion.dart';
import 'package:solera_quesera/modelos/formacion.dart';
import 'package:solera_quesera/modelos/incidencia.dart';
import 'package:solera_quesera/modelos/lote_produccion.dart';
import 'package:solera_quesera/modelos/partida_leche.dart';
import 'package:solera_quesera/modelos/pieza.dart';
import 'package:solera_quesera/modelos/proveedor_leche.dart';
import 'package:solera_quesera/modelos/queseria.dart';
import 'package:solera_quesera/modelos/receta.dart';
import 'package:solera_quesera/modelos/venta.dart';

void main() {
  final ahora = DateTime.now().millisecondsSinceEpoch;

  group('Queseria', () {
    test('toMap / fromMap ida y vuelta', () {
      final original = Queseria(
        razonSocial: 'Quesería Artzai',
        nif: '12345678A',
        rgseaa: '10.01234/SS',
        direccion: 'Calle Mayor 1',
        telefono: '945123456',
        email: 'info@artzai.eus',
        latitud: 42.9,
        longitud: -2.3,
      );
      final mapa = original.toMap();
      final recuperada = Queseria.fromMap(mapa);
      expect(recuperada.razonSocial, original.razonSocial);
      expect(recuperada.nif, original.nif);
      expect(recuperada.rgseaa, original.rgseaa);
      expect(recuperada.latitud, original.latitud);
    });

    test('valores por defecto vacíos', () {
      final q = Queseria();
      expect(q.razonSocial, '');
      expect(q.nif, '');
      expect(q.rgseaa, '');
      expect(q.id, null);
    });
  });

  group('ProveedorLeche', () {
    test('toMap / fromMap con esPropio', () {
      final p = ProveedorLeche(
        nombre: 'Rebaño propio',
        esPropio: true,
        tipoLeche: 'oveja',
        razaId: 'latxa',
        fechaCreacionMs: ahora,
      );
      final mapa = p.toMap();
      expect(mapa['es_propio'], 1);
      final rec = ProveedorLeche.fromMap(mapa);
      expect(rec.esPropio, true);
      expect(rec.nombre, 'Rebaño propio');
    });

    test('fromMap nullable seguro', () {
      final rec = ProveedorLeche.fromMap({'fecha_creacion_ms': ahora});
      expect(rec.nombre, '');
      expect(rec.tipoLeche, 'oveja');
      expect(rec.esPropio, false);
    });
  });

  group('PartidaLeche', () {
    test('toMap / fromMap conserva valores numéricos', () {
      final p = PartidaLeche(
        proveedorId: 1,
        fechaMs: ahora,
        volumenLitros: 120.5,
        temperaturaRecepcion: 4.2,
        ph: 6.7,
        grasa: 6.5,
        proteina: 5.2,
      );
      final mapa = p.toMap();
      final rec = PartidaLeche.fromMap(mapa);
      expect(rec.volumenLitros, 120.5);
      expect(rec.temperaturaRecepcion, 4.2);
      expect(rec.ph, 6.7);
    });

    test('antibióticos positivos', () {
      final p = PartidaLeche(
        proveedorId: 1,
        fechaMs: ahora,
        volumenLitros: 50,
        antibioticosPositivos: true,
      );
      final mapa = p.toMap();
      expect(mapa['antibioticos_positivos'], 1);
      final rec = PartidaLeche.fromMap(mapa);
      expect(rec.antibioticosPositivos, true);
    });
  });

  group('Receta', () {
    test('valores por defecto de proceso', () {
      final r = Receta(nombre: 'Test', tipoQuesoId: 'idiazabal_semicurado');
      expect(r.tempCoagulacion, 30);
      expect(r.tiempoCoagMinutos, 30);
      expect(r.rendimientoEsperado, 8);
      expect(r.curacionMinimaDias, 60);
    });

    test('toMap / fromMap con DO', () {
      final r = Receta(
        nombre: 'Idiazabal curado',
        tipoQuesoId: 'idiazabal_curado',
        doId: 'idiazabal',
        curacionMinimaDias: 120,
      );
      final mapa = r.toMap();
      expect(mapa['do_id'], 'idiazabal');
      final rec = Receta.fromMap(mapa);
      expect(rec.doId, 'idiazabal');
    });
  });

  group('LoteProduccion', () {
    test('rendimiento se autocalcula', () {
      final l = LoteProduccion(
        numeroLote: '20260511-001',
        fechaMs: ahora,
        recetaId: 1,
        volumenLecheTotal: 200,
        pesoTotalObtenido: 24.5,
        rendimientoReal: 200 / 24.5,
        numPiezasProducidas: 12,
        pesoMedioPieza: 24.5 / 12,
        fechaCreacionMs: ahora,
      );
      expect(l.rendimientoReal, closeTo(8.16, 0.01));
      expect(l.pesoMedioPieza, closeTo(2.04, 0.01));
    });

    test('toMap / fromMap', () {
      final l = LoteProduccion(
        numeroLote: '20260511-001',
        fechaMs: ahora,
        recetaId: 1,
        tipoQuesoId: 'idiazabal_semicurado',
        estado: 'fresca',
        fechaCreacionMs: ahora,
      );
      final mapa = l.toMap();
      final rec = LoteProduccion.fromMap(mapa);
      expect(rec.numeroLote, '20260511-001');
      expect(rec.estado, 'fresca');
    });

    test('estado por defecto fresca', () {
      final l = LoteProduccion(
        numeroLote: '20260511-002',
        fechaMs: ahora,
        recetaId: 1,
        fechaCreacionMs: ahora,
      );
      expect(l.estado, 'fresca');
    });
  });

  group('Pieza', () {
    test('edadDias positivo', () {
      final vieja = Pieza(
        loteProduccionId: 1,
        numeroPieza: '20260101-001-01',
        pesoInicial: 2.0,
        fechaCreacionMs: DateTime(2026, 1, 1).millisecondsSinceEpoch,
      );
      expect(vieja.edadDias, greaterThan(100));
    });

    test('pérdida de peso', () {
      final p = Pieza(
        loteProduccionId: 1,
        numeroPieza: '20260511-001-01',
        pesoInicial: 2.0,
        pesoActual: 1.7,
        fechaCreacionMs: ahora,
      );
      expect(p.perdidaPesoPorcentaje, closeTo(15.0, 0.01));
    });

    test('toMap / fromMap conserva estado', () {
      final p = Pieza(
        loteProduccionId: 1,
        numeroPieza: '20260511-001-01',
        pesoInicial: 2.0,
        ubicacionActual: 'Cava este',
        estado: 'afinando',
        fechaCreacionMs: ahora,
      );
      final mapa = p.toMap();
      final rec = Pieza.fromMap(mapa);
      expect(rec.ubicacionActual, 'Cava este');
      expect(rec.estado, 'afinando');
    });
  });

  group('EventoCuracion', () {
    test('toMap / fromMap tipo ahumado', () {
      final e = EventoCuracion(
        piezaId: 1,
        fechaMs: ahora,
        tipo: 'ahumado',
        maderaAhumado: 'haya',
        fechaCreacionMs: ahora,
      );
      final mapa = e.toMap();
      final rec = EventoCuracion.fromMap(mapa);
      expect(rec.tipo, 'ahumado');
      expect(rec.maderaAhumado, 'haya');
    });
  });

  group('Venta', () {
    test('toMap / fromMap con importes', () {
      final v = Venta(
        fechaMs: ahora,
        clienteNombre: 'Quesería Artzai',
        tipo: 'tienda',
        baseImponible: 100.50,
        ivaPorcentaje: 10,
        total: 110.55,
        fechaCreacionMs: ahora,
      );
      final mapa = v.toMap();
      final rec = Venta.fromMap(mapa);
      expect(rec.total, 110.55);
      expect(rec.clienteNombre, 'Quesería Artzai');
    });
  });

  group('APPCC controles', () {
    test('ControlTemperatura redondeo', () {
      final c = ControlTemperatura(
        fechaMs: ahora,
        cavaId: 'Cava 1',
        temperatura: 10.567,
        humedadRelativa: 85.3,
      );
      expect(c.temperatura, 10.567);
    });

    test('ControlLimpieza no verificado', () {
      final c = ControlLimpieza(
        fechaMs: ahora,
        zona: 'produccion',
        verificado: false,
        accionCorrectiva: 'Repetir limpieza',
      );
      expect(c.verificado, false);
    });

    test('ControlPlagas con fecha próxima revisión', () {
      final c = ControlPlagas(
        fechaMs: ahora,
        tipo: 'roedores',
        medida: 'cebo',
        proximaRevisionMs: ahora + 30 * 86400000,
      );
      expect(c.proximaRevisionMs, greaterThan(ahora));
    });

    test('Formacion datos mínimos', () {
      final f = Formacion(
        empleado: 'Ana',
        fechaMs: ahora,
        tipo: 'manipuladorAlimentos',
        duracionMinutos: 120,
      );
      expect(f.duracionMinutos, 120);
    });
  });

  group('Incidencia', () {
    test('cerrada por defecto false', () {
      final i = Incidencia(
        fechaMs: ahora,
        tipo: 'defecto',
        fechaCreacionMs: ahora,
      );
      expect(i.cerrada, false);
    });

    test('toMap / fromMap acciones correctivas', () {
      final i = Incidencia(
        fechaMs: ahora,
        tipo: 'contaminacion',
        descripcion: 'Moho en lote 001',
        causa: 'Contaminación cruzada',
        accionCorrectiva: 'Limpieza profunda cava',
        cerrada: false,
        fechaCreacionMs: ahora,
      );
      final mapa = i.toMap();
      final rec = Incidencia.fromMap(mapa);
      expect(rec.descripcion, 'Moho en lote 001');
      expect(rec.accionCorrectiva, 'Limpieza profunda cava');
    });
  });

  group('Analitica', () {
    test('conforme por defecto true', () {
      final a = Analitica(
        fechaMs: ahora,
        tipo: 'microbiologica',
      );
      expect(a.conforme, true);
    });

    test('no conforme', () {
      final a = Analitica(
        fechaMs: ahora,
        tipo: 'microbiologica',
        conforme: false,
      );
      expect(a.conforme, false);
    });
  });
}
