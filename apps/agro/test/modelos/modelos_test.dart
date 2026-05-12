import 'package:agro/modelos/apunte_gasto.dart';
import 'package:agro/modelos/apunte_ingreso.dart';
import 'package:agro/modelos/configuracion_fiscal.dart';
import 'package:agro/modelos/tercero.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests POJO ida-y-vuelta toMap/fromMap para los modelos del libro
/// económico (F3.5). Validan que el shape sqflite es preservado y
/// que los getters derivados (esAyudaOSubvencion, esVentaCosecha,
/// esFincaConcreta…) clasifican correctamente los apuntes para el
/// extracto fiscal.
void main() {
  group('Tercero', () {
    test('round-trip mínimo con NIF + tipo cliente', () {
      final original = Tercero(
        nif: 'B12345678',
        nombre: 'Almazara Sierra de Gata',
        tipo: 'cliente',
      );
      final ida = Tercero.fromMap(original.toMap());
      expect(ida.nif, 'B12345678');
      expect(ida.nombre, 'Almazara Sierra de Gata');
      expect(ida.tipo, 'cliente');
      expect(ida.esCliente, true);
      expect(ida.esProveedor, false);
      expect(ida.tieneNif, true);
    });

    test('tipo ambos cubre la cooperativa que vende y compra', () {
      final coop = Tercero(nif: 'F87654321', nombre: 'Coop. del Valle', tipo: 'ambos');
      expect(coop.esCliente, true);
      expect(coop.esProveedor, true);
    });

    test('NIF vacío detecta venta informal en mercado local', () {
      final particular = Tercero(nombre: 'Vecino del pueblo', tipo: 'cliente');
      expect(particular.tieneNif, false);
      expect(particular.esCliente, true);
    });

    test('NIF con espacios cuenta como vacío', () {
      final basura = Tercero(nif: '   ', nombre: 'X');
      expect(basura.tieneNif, false);
    });
  });

  group('ConfiguracionFiscal', () {
    test('round-trip mínimo con valores por defecto', () {
      final original = ConfiguracionFiscal();
      final ida = ConfiguracionFiscal.fromMap(original.toMap());
      expect(ida.regimenIrpf, 'sin_elegir');
      expect(ida.regimenIva, 'sin_elegir');
      expect(ida.estaConfigurado, false);
    });

    test('REAGP activa compensación 12% y anula IVA en venta cosecha', () {
      final cf = ConfiguracionFiscal(
        regimenIrpf: 'estimacion_directa_simplificada',
        regimenIva: 'reagp',
      );
      expect(cf.estaConfigurado, true);
      expect(cf.tieneCompensacionReagp, true);
      expect(cf.tipoIvaVentaCosecha, 0.0);
      expect(cf.tipoCompensacionReagp, 0.12);
      // El alquiler de terreno con uso agrícola está exento.
      expect(cf.tipoIvaAlquilerTerreno, 0.0);
    });

    test('régimen general aplica IVA 4% por defecto en venta cosecha', () {
      final cf = ConfiguracionFiscal(
        regimenIrpf: 'estimacion_directa_normal',
        regimenIva: 'general',
      );
      expect(cf.tipoIvaVentaCosecha, 0.04);
      expect(cf.tipoCompensacionReagp, 0.0);
      expect(cf.tieneCompensacionReagp, false);
    });

    test('round-trip preserva año fiscal activo', () {
      final original = ConfiguracionFiscal(
        regimenIrpf: 'estimacion_directa_simplificada',
        regimenIva: 'reagp',
        anoFiscalActivo: 2026,
      );
      final ida = ConfiguracionFiscal.fromMap(original.toMap());
      expect(ida.anoFiscalActivo, 2026);
    });
  });

  group('ApunteIngreso', () {
    test('round-trip de venta de aceituna con compensación REAGP', () {
      final original = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: 'Venta 2.500 kg aceituna picual',
        tipoIngreso: 'venta_cosecha',
        importeBaseCentimos: 175000, // 1.750€
        compensacionReagpCentimos: 21000, // 12% sobre base
        cantidad: 2500.0,
        unidad: 'kg',
        terceroId: 7,
        fincaId: 2,
        cultivoId: 'oleoso',
        numeroFactura: '2026/001',
      );
      final ida = ApunteIngreso.fromMap(original.toMap());
      expect(ida.tipoIngreso, 'venta_cosecha');
      expect(ida.cantidad, 2500.0);
      expect(ida.unidad, 'kg');
      expect(ida.cultivoId, 'oleoso');
      expect(ida.importeTotalCentimos, 175000 + 21000);
      expect(ida.esVentaCosecha, true);
      expect(ida.esAyudaOSubvencion, false);
      expect(ida.esAlquilerTerreno, false);
    });

    test('alquiler de terreno preserva fincaId y se marca alquiler', () {
      final original = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: 'Alquiler 8 ha pastoreo ovino',
        tipoIngreso: 'alquiler_terreno',
        importeBaseCentimos: 60000, // 600€/año
        cantidad: 8.0,
        unidad: 'ha',
        terceroId: 3,
        fincaId: 5,
      );
      final ida = ApunteIngreso.fromMap(original.toMap());
      expect(ida.esAlquilerTerreno, true);
      expect(ida.fincaId, 5);
    });

    test('ayuda PAC se distingue del ingreso ordinario', () {
      final pac = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: 'Pago básico PAC 2026',
        tipoIngreso: 'ayuda_pac',
        importeBaseCentimos: 320000, // 3.200€
      );
      expect(pac.esAyudaOSubvencion, true);
      // Las ayudas no llevan IVA ni compensación.
      expect(pac.importeTotalCentimos, 320000);
    });

    test('subvención autonómica también es ayuda', () {
      final sub = ApunteIngreso(
        fechaMs: 1700000000000,
        tipoIngreso: 'subvencion_autonomica',
      );
      expect(sub.esAyudaOSubvencion, true);
    });

    test('venta de leña preserva m³ como unidad', () {
      final lena = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: 'Venta leña encina dehesa',
        tipoIngreso: 'venta_lena_madera',
        importeBaseCentimos: 45000, // 450€
        ivaRepercutidoCentimos: 9450, // 21% IVA general
        cantidad: 5.0,
        unidad: 'm3',
      );
      final ida = ApunteIngreso.fromMap(lena.toMap());
      expect(ida.tipoIngreso, 'venta_lena_madera');
      expect(ida.unidad, 'm3');
      expect(ida.esVentaCosecha, false);
    });
  });

  group('ApunteGasto', () {
    test('gasto fitosanitario imputado a finca con sinergia tratamiento MAPA', () {
      final original = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Caldo bordelés WP cobre',
        tipoGasto: 'tratamientos_fitosanitarios',
        importeBaseCentimos: 8000,
        ivaSoportadoCentimos: 1680, // 21% IVA
        imputacion: 'finca_concreta',
        fincaId: 5,
        terceroId: 11,
        tratamientoId: 42,
        numeroFactura: 'PROV/2026/187',
      );
      final ida = ApunteGasto.fromMap(original.toMap());
      expect(ida.tipoGasto, 'tratamientos_fitosanitarios');
      expect(ida.imputacion, 'finca_concreta');
      expect(ida.fincaId, 5);
      expect(ida.tratamientoId, 42);
      expect(ida.esFincaConcreta, true);
      expect(ida.esCultivoGeneral, false);
      expect(ida.importeTotalCentimos, 8000 + 1680);
    });

    test('insumos imputados a cultivo general (frutal_pepita)', () {
      final original = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Abono NPK granel para todos los manzanos',
        tipoGasto: 'insumos',
        importeBaseCentimos: 35000,
        imputacion: 'cultivo_general',
        cultivoId: 'frutal_pepita',
      );
      final ida = ApunteGasto.fromMap(original.toMap());
      expect(ida.esCultivoGeneral, true);
      expect(ida.esFincaConcreta, false);
      expect(ida.cultivoId, 'frutal_pepita');
      expect(ida.fincaId, isNull);
    });

    test('imputacion finca_concreta sin fincaId no es válida', () {
      final raro = ApunteGasto(
        fechaMs: 1700000000000,
        imputacion: 'finca_concreta',
      );
      expect(raro.esFincaConcreta, false);
    });

    test('imputacion cultivo_general sin cultivoId no es válida', () {
      final raro = ApunteGasto(
        fechaMs: 1700000000000,
        imputacion: 'cultivo_general',
      );
      expect(raro.esCultivoGeneral, false);
    });

    test('seguro agrario sin imputación es lo normal', () {
      final seguro = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Seguro Agroseguro multicultivo',
        tipoGasto: 'seguros',
        importeBaseCentimos: 45000,
      );
      expect(seguro.imputacion, 'general');
      expect(seguro.esFincaConcreta, false);
      expect(seguro.esCultivoGeneral, false);
    });

    test('certificación ecológica como gasto recurrente anual', () {
      final cert = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Cuota anual CAEM ecológico',
        tipoGasto: 'certificacion',
        importeBaseCentimos: 35000,
        ivaSoportadoCentimos: 7350,
      );
      final ida = ApunteGasto.fromMap(cert.toMap());
      expect(ida.tipoGasto, 'certificacion');
      expect(ida.importeTotalCentimos, 35000 + 7350);
    });
  });
}
