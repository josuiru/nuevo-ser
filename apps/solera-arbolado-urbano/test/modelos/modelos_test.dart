import 'package:flutter_test/flutter_test.dart';

import 'package:solera_arbolado_urbano/modelos/arbol.dart';
import 'package:solera_arbolado_urbano/modelos/incidencia.dart';
import 'package:solera_arbolado_urbano/modelos/inspeccion.dart';
import 'package:solera_arbolado_urbano/modelos/poda.dart';
import 'package:solera_arbolado_urbano/modelos/tecnico.dart';
import 'package:solera_arbolado_urbano/modelos/tratamiento.dart';
import 'package:solera_arbolado_urbano/modelos/zona.dart';

void main() {
  group('Zona', () {
    test('round-trip preserva centroide y código municipal', () {
      final zona = Zona(
        nombre: 'Paseo Valle Osorio',
        codigoMunicipal: 'IRU-PASEO-VAL',
        latitudCentroide: 42.815,
        longitudCentroide: -1.640,
        fechaCreacionMs: 1700000000000,
      );
      final restaurada = Zona.fromMap(zona.toMap());
      expect(restaurada.nombre, 'Paseo Valle Osorio');
      expect(restaurada.codigoMunicipal, 'IRU-PASEO-VAL');
      expect(restaurada.latitudCentroide, 42.815);
      expect(restaurada.longitudCentroide, -1.640);
    });

    test('color por defecto es verde hoja', () {
      final zona = Zona(nombre: 'X', fechaCreacionMs: 0);
      expect(zona.colorEntero, 0xFF2E7D32);
    });
  });

  group('Arbol', () {
    test('estado por defecto es sano', () {
      final arbol = Arbol(
        identificadorMunicipal: 'IRU-001',
        fechaCreacionMs: 0,
      );
      expect(arbol.estado, EstadoArbol.sano);
    });

    test('round-trip preserva todos los campos cuantitativos', () {
      final arbol = Arbol(
        zonaId: 7,
        identificadorMunicipal: 'IRU-2024-PASEO-042',
        qrPayload: 'IRU:2024-PASEO-042',
        especieId: 'platanus_hispanica',
        edadEstimadaAnos: 35,
        fechaPlantacionMs: 1500000000000,
        perimetroTroncoCm: 85.5,
        alturaEstimadaMetros: 12.3,
        riesgoVta: 2,
        estado: EstadoArbol.observacion,
        tipoAlcorqueId: 'mineral',
        latitud: 42.815,
        longitud: -1.640,
        notas: 'Próximo a paso de cebra',
        fechaCreacionMs: 1700000000000,
      );
      final restaurado = Arbol.fromMap(arbol.toMap());
      expect(restaurado.zonaId, 7);
      expect(restaurado.identificadorMunicipal, 'IRU-2024-PASEO-042');
      expect(restaurado.qrPayload, 'IRU:2024-PASEO-042');
      expect(restaurado.especieId, 'platanus_hispanica');
      expect(restaurado.edadEstimadaAnos, 35);
      expect(restaurado.perimetroTroncoCm, 85.5);
      expect(restaurado.alturaEstimadaMetros, 12.3);
      expect(restaurado.riesgoVta, 2);
      expect(restaurado.estado, EstadoArbol.observacion);
      expect(restaurado.tipoAlcorqueId, 'mineral');
    });

    test('estado round-trip cubre los 5 valores', () {
      for (final estado in EstadoArbol.values) {
        final arbol = Arbol(
          identificadorMunicipal: 'X',
          estado: estado,
          fechaCreacionMs: 0,
        );
        final restaurado = Arbol.fromMap(arbol.toMap());
        expect(restaurado.estado, estado);
      }
    });

    test('estado desconocido en BD legacy cae a sano', () {
      final restaurado = Arbol.fromMap({
        'identificador_municipal': 'X',
        'estado': 'fantasma_legacy',
        'fecha_creacion_ms': 0,
      });
      expect(restaurado.estado, EstadoArbol.sano);
    });
  });

  group('Inspeccion', () {
    test('round-trip preserva riesgo VTA y fenología', () {
      final i = Inspeccion(
        arbolId: 42,
        tecnicoId: 3,
        fechaMs: 1700000000000,
        estado: 'observacion',
        riesgoVta: 3,
        fenologia: 'en hoja',
        notas: 'Mancha foliar puntual',
      );
      final restaurada = Inspeccion.fromMap(i.toMap());
      expect(restaurada.arbolId, 42);
      expect(restaurada.tecnicoId, 3);
      expect(restaurada.estado, 'observacion');
      expect(restaurada.riesgoVta, 3);
      expect(restaurada.fenologia, 'en hoja');
    });
  });

  group('Poda', () {
    test('round-trip preserva volumen restos y fotos antes/después', () {
      final p = Poda(
        arbolId: 42,
        tecnicoId: 3,
        fechaMs: 1700000000000,
        tipoPodaId: 'mantenimiento',
        volumenRestosM3: 0.85,
        motivo: 'Limpieza anual',
        rutasFotosAntesJson: '["antes1.jpg"]',
        rutasFotosDespuesJson: '["despues1.jpg","despues2.jpg"]',
      );
      final restaurada = Poda.fromMap(p.toMap());
      expect(restaurada.tipoPodaId, 'mantenimiento');
      expect(restaurada.volumenRestosM3, 0.85);
      expect(restaurada.rutasFotosAntesJson, '["antes1.jpg"]');
      expect(restaurada.rutasFotosDespuesJson, '["despues1.jpg","despues2.jpg"]');
    });
  });

  group('Tratamiento', () {
    test('round-trip preserva sustancia activa y trazabilidad', () {
      final t = Tratamiento(
        arbolId: 42,
        tecnicoId: 3,
        fechaMs: 1700000000000,
        sustanciaActivaId: 'bacillus_thuringiensis',
        dosis: '1 L/Ha',
        motivoIdPlaga: 'procesionaria',
        loteProducto: 'LOT-2024-12',
        numeroFactura: 'F-2024-117',
        plazoSeguridadDias: 0,
      );
      final restaurado = Tratamiento.fromMap(t.toMap());
      expect(restaurado.sustanciaActivaId, 'bacillus_thuringiensis');
      expect(restaurado.motivoIdPlaga, 'procesionaria');
      expect(restaurado.loteProducto, 'LOT-2024-12');
      expect(restaurado.numeroFactura, 'F-2024-117');
      expect(restaurado.plazoSeguridadDias, 0);
    });
  });

  group('Incidencia', () {
    test('por defecto está abierta', () {
      final i = Incidencia(arbolId: 1, fechaMs: 0);
      expect(i.resuelta, isFalse);
      expect(i.fechaResolucionMs, isNull);
    });

    test('round-trip de incidencia resuelta preserva fecha resolución', () {
      final i = Incidencia(
        arbolId: 1,
        fechaMs: 1700000000000,
        tipo: 'temporal',
        descripcion: 'Caída de rama por viento sur',
        severidad: 4,
        resuelta: true,
        fechaResolucionMs: 1700100000000,
      );
      final restaurada = Incidencia.fromMap(i.toMap());
      expect(restaurada.resuelta, isTrue);
      expect(restaurada.fechaResolucionMs, 1700100000000);
      expect(restaurada.tipo, 'temporal');
      expect(restaurada.severidad, 4);
    });
  });

  group('Tecnico', () {
    test('puedeAplicarFitosanitarios false sin carnet', () {
      final t = Tecnico(nif: '12345678A', nombre: 'Andrés');
      expect(t.puedeAplicarFitosanitarios, isFalse);
    });

    test('puedeAplicarFitosanitarios true con carnet completo', () {
      final t = Tecnico(
        nif: '12345678A',
        nombre: 'Andrés',
        carnetAplicador: 'NA-12345',
        nivelCarnetAplicador: 'cualificado',
      );
      expect(t.puedeAplicarFitosanitarios, isTrue);
    });

    test('round-trip preserva empresa contratista y CIF', () {
      final t = Tecnico(
        nif: '12345678A',
        nombre: 'Andrés',
        empresaContratista: 'Jardinería Norte SL',
        cifEmpresa: 'B12345678',
        carnetAplicador: 'NA-12345',
        nivelCarnetAplicador: 'cualificado',
      );
      final restaurado = Tecnico.fromMap(t.toMap());
      expect(restaurado.empresaContratista, 'Jardinería Norte SL');
      expect(restaurado.cifEmpresa, 'B12345678');
      expect(restaurado.activo, isTrue);
    });
  });

  group('Ayuntamiento', () {
    test('estaConfigurado false sin nombre/cif/municipio', () {
      expect(Ayuntamiento().estaConfigurado, isFalse);
      expect(
        Ayuntamiento(nombre: 'X', cif: 'P3120100A').estaConfigurado,
        isFalse,
      );
    });

    test('estaConfigurado true con los 3 mínimos', () {
      final a = Ayuntamiento(
        nombre: 'Ayuntamiento de Iruña',
        cif: 'P3120100A',
        municipio: 'Iruña',
      );
      expect(a.estaConfigurado, isTrue);
    });

    test('round-trip preserva concejal y concejalía', () {
      final a = Ayuntamiento(
        nombre: 'Ayuntamiento de Iruña',
        cif: 'P3120100A',
        municipio: 'Iruña',
        provincia: 'Navarra',
        nombreConcejal: 'María Etxeberría',
        concejalia: 'Medio Ambiente',
      );
      final restaurado = Ayuntamiento.fromMap(a.toMap());
      expect(restaurado.nombreConcejal, 'María Etxeberría');
      expect(restaurado.concejalia, 'Medio Ambiente');
    });
  });
}
