import 'package:flutter_test/flutter_test.dart';
import 'package:solera_viticultura/modelos/apunte_gasto.dart';
import 'package:solera_viticultura/modelos/apunte_ingreso.dart';
import 'package:solera_viticultura/modelos/configuracion_fiscal.dart';
import 'package:solera_viticultura/modelos/tercero.dart';

/// Tests POJO ida-y-vuelta toMap/fromMap para los modelos del libro
/// económico (F1-12). Validan el shape sqflite y los getters
/// derivados (esVentaUva/esVentaVino, esVinedoConcreto/
/// esVariedadGeneral) que clasifican apuntes para el extracto.
void main() {
  group('Tercero (viticultura)', () {
    test('round-trip mínimo con NIF + tipo cliente', () {
      final original = Tercero(
        nif: 'B12345678',
        nombre: 'Distribuidora Vinos del Duero',
        tipo: 'cliente',
      );
      final ida = Tercero.fromMap(original.toMap());
      expect(ida.nif, 'B12345678');
      expect(ida.tipo, 'cliente');
      expect(ida.esCliente, true);
      expect(ida.tieneNif, true);
    });

    test('NIF vacío detecta venta directa en bodega a particular', () {
      final particular = Tercero(nombre: 'Visitante de bodega');
      expect(particular.tieneNif, false);
    });
  });

  group('ConfiguracionFiscal (viticultura)', () {
    test('REAGP activa compensación 12% sobre uva pero no sobre vino', () {
      final cf = ConfiguracionFiscal(
        regimenIrpf: 'estimacion_directa_simplificada',
        regimenIva: 'reagp',
      );
      expect(cf.estaConfigurado, true);
      expect(cf.tieneCompensacionReagp, true);
      expect(cf.tipoIvaVentaUva, 0.0);
      expect(cf.tipoCompensacionReagpUva, 0.12);
      // El vino es producto transformado: NO entra en REAGP, IVA 21%.
      expect(cf.tipoIvaVentaVino, 0.21);
      // Alquiler agrícola exento.
      expect(cf.tipoIvaAlquilerTerreno, 0.0);
    });

    test('régimen general aplica 4% en uva y 21% en vino siempre', () {
      final cf = ConfiguracionFiscal(
        regimenIrpf: 'estimacion_directa_normal',
        regimenIva: 'general',
      );
      expect(cf.tipoIvaVentaUva, 0.04);
      expect(cf.tipoIvaVentaVino, 0.21);
      expect(cf.tipoCompensacionReagpUva, 0.0);
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

  group('ApunteIngreso (viticultura)', () {
    test('round-trip de venta de uva con compensación REAGP', () {
      final original = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: '2.500 kg tempranillo a cooperativa',
        tipoIngreso: 'venta_uva',
        importeBaseCentimos: 175000, // 1.750€
        compensacionReagpCentimos: 21000, // 12% sobre base
        cantidad: 2500.0,
        unidad: 'kg',
        terceroId: 7,
        vinedoId: 2,
        variedadId: 'tempranillo',
        numeroFactura: '2026/V/001',
      );
      final ida = ApunteIngreso.fromMap(original.toMap());
      expect(ida.tipoIngreso, 'venta_uva');
      expect(ida.cantidad, 2500.0);
      expect(ida.variedadId, 'tempranillo');
      expect(ida.importeTotalCentimos, 175000 + 21000);
      expect(ida.esVentaUva, true);
      expect(ida.esVentaVino, false);
    });

    test('venta de vino en botella con lote DOP', () {
      final original = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: '300 botellas crianza 2022',
        tipoIngreso: 'venta_vino_botella',
        importeBaseCentimos: 270000, // 2.700€
        ivaRepercutidoCentimos: 56700, // 21% IVA
        cantidad: 300.0,
        unidad: 'botellas',
        loteVino: 'L2022-CR-08',
      );
      final ida = ApunteIngreso.fromMap(original.toMap());
      expect(ida.esVentaVino, true);
      expect(ida.esVentaUva, false);
      expect(ida.loteVino, 'L2022-CR-08');
      expect(ida.importeTotalCentimos, 270000 + 56700);
    });

    test('venta de vino a granel también es venta de vino', () {
      final granel = ApunteIngreso(
        fechaMs: 1700000000000,
        tipoIngreso: 'venta_vino_granel',
      );
      expect(granel.esVentaVino, true);
    });

    test('ayuda PAC se distingue del ingreso ordinario', () {
      final pac = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: 'Reestructuración viñedo PAC 2026',
        tipoIngreso: 'ayuda_pac',
        importeBaseCentimos: 450000,
      );
      expect(pac.esAyudaOSubvencion, true);
      expect(pac.importeTotalCentimos, 450000);
    });
  });

  group('ApunteGasto (viticultura)', () {
    test('vendimia imputada a viñedo concreto con sinergia tratamiento', () {
      final original = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Cuadrilla vendimia 8 jornales',
        tipoGasto: 'vendimia',
        importeBaseCentimos: 80000, // 800€
        imputacion: 'vinedo_concreto',
        vinedoId: 5,
        terceroId: 11,
        numeroFactura: 'PROV/2026/187',
      );
      final ida = ApunteGasto.fromMap(original.toMap());
      expect(ida.tipoGasto, 'vendimia');
      expect(ida.imputacion, 'vinedo_concreto');
      expect(ida.esVinedoConcreto, true);
      expect(ida.esVariedadGeneral, false);
    });

    test('insumos imputados a variedad general (tempranillo)', () {
      final original = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Sulfato de cobre para todos los tempranillos',
        tipoGasto: 'tratamientos_fitosanitarios',
        importeBaseCentimos: 12000,
        imputacion: 'variedad_general',
        variedadId: 'tempranillo',
      );
      final ida = ApunteGasto.fromMap(original.toMap());
      expect(ida.esVariedadGeneral, true);
      expect(ida.esVinedoConcreto, false);
      expect(ida.variedadId, 'tempranillo');
    });

    test('imputacion vinedo_concreto sin vinedoId no es válida', () {
      final raro = ApunteGasto(
        fechaMs: 1700000000000,
        imputacion: 'vinedo_concreto',
      );
      expect(raro.esVinedoConcreto, false);
    });

    test('barricas como gasto imputable o no imputable', () {
      // Las barricas son inversión amortizable; el asesor decide
      // si va como gasto del ejercicio o se amortiza. v1 lo deja
      // como gasto general — el extracto lo lista por categoría.
      final barricas = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Compra 5 barricas roble americano',
        tipoGasto: 'barricas',
        importeBaseCentimos: 250000,
        ivaSoportadoCentimos: 52500, // 21%
      );
      expect(barricas.imputacion, 'general');
      expect(barricas.importeTotalCentimos, 250000 + 52500);
    });

    test('certificación DOP/IGP recurrente anual', () {
      final cert = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Cuota anual Consejo Regulador Rioja',
        tipoGasto: 'certificacion',
        importeBaseCentimos: 60000,
      );
      expect(cert.tipoGasto, 'certificacion');
    });
  });
}
