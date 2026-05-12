import 'package:flutter_test/flutter_test.dart';
import 'package:solera_apicola/modelos/apiario.dart';
import 'package:solera_apicola/modelos/apicultor.dart';
import 'package:solera_apicola/modelos/apunte_gasto.dart';
import 'package:solera_apicola/modelos/apunte_ingreso.dart';
import 'package:solera_apicola/modelos/colmena.dart';
import 'package:solera_apicola/modelos/configuracion_fiscal.dart';
import 'package:solera_apicola/modelos/cosecha_miel.dart';
import 'package:solera_apicola/modelos/incidencia_apicola.dart';
import 'package:solera_apicola/modelos/movimiento.dart';
import 'package:solera_apicola/modelos/revision.dart';
import 'package:solera_apicola/modelos/tercero.dart';
import 'package:solera_apicola/modelos/tratamiento_varroa.dart';

/// Tests POJO ida-y-vuelta toMap/fromMap para los 8 modelos del
/// dominio apícola. Validan que el shape sqflite es preservado.
void main() {
  group('Apiario', () {
    test('round-trip mínimo', () {
      final original = Apiario(
        id: 1,
        nombre: 'Brezal Norte',
        colorEntero: 0xFFB8860B,
        fechaCreacionMs: 1700000000000,
      );
      final ida = Apiario.fromMap(original.toMap());
      expect(ida.nombre, 'Brezal Norte');
      expect(ida.codigoSitran, '');
    });

    test('round-trip con SITRAN-AP + superficie', () {
      final original = Apiario(
        nombre: 'Carrasca Vieja',
        colorEntero: 0,
        fechaCreacionMs: 1700000000000,
        codigoSitran: 'ES-26-008-AP-0042',
        superficieHectareas: 0.25,
      );
      final ida = Apiario.fromMap(original.toMap());
      expect(ida.codigoSitran, 'ES-26-008-AP-0042');
      expect(ida.superficieHectareas, 0.25);
    });
  });

  group('Colmena', () {
    test('round-trip de colmena viva con matrícula', () {
      final original = Colmena(
        matricula: 'IB-2024-042',
        tipoColmenaId: 'layens',
        razaId: 'iberica',
        anoReina: 2024,
        fechaCreacionMs: 1700000000000,
      );
      final ida = Colmena.fromMap(original.toMap());
      expect(ida.matricula, 'IB-2024-042');
      expect(ida.tipoColmenaId, 'layens');
      expect(ida.estado, EstadoColmena.viva);
      expect(ida.anoReina, 2024);
    });

    test('estado preserva enum descolmenada', () {
      final original = Colmena(
        matricula: 'IB-2024-001',
        estado: EstadoColmena.descolmenada,
        fechaCreacionMs: 1700000000000,
      );
      final ida = Colmena.fromMap(original.toMap());
      expect(ida.estado, EstadoColmena.descolmenada);
    });

    test('color marca reina por ciclo de 5 años', () {
      // Ciclo internacional: blanco-amarillo-rojo-verde-azul.
      Colmena conReina(int ano) => Colmena(
            matricula: 'X',
            anoReina: ano,
            fechaCreacionMs: 0,
          );
      // 2025 mod 5 == 0 → azul
      expect(conReina(2025).colorMarcaReina, 'azul');
      // 2024 mod 5 == 4 → verde
      expect(conReina(2024).colorMarcaReina, 'verde');
      // 2023 mod 5 == 3 → rojo
      expect(conReina(2023).colorMarcaReina, 'rojo');
      // 2022 mod 5 == 2 → amarillo
      expect(conReina(2022).colorMarcaReina, 'amarillo');
      // 2021 mod 5 == 1 → blanco
      expect(conReina(2021).colorMarcaReina, 'blanco');
    });

    test('sin año reina → color null', () {
      final c = Colmena(matricula: 'X', fechaCreacionMs: 0);
      expect(c.colorMarcaReina, isNull);
    });
  });

  group('Revisión', () {
    test('round-trip con todos los niveles', () {
      final original = Revision(
        colmenaId: 5,
        fechaMs: 1700000000000,
        presenciaReina: 'presente',
        nivelPostura: 4,
        nivelCriaOperculada: 4,
        nivelMiel: 3,
        nivelPolen: 2,
        varroaCaidaDiaria: 12,
        notas: 'Buena postura, vigilar varroa',
      );
      final ida = Revision.fromMap(original.toMap());
      expect(ida.presenciaReina, 'presente');
      expect(ida.varroaCaidaDiaria, 12);
      expect(ida.nivelPostura, 4);
    });
  });

  group('Cosecha de miel', () {
    test('round-trip con varios productos', () {
      final original = CosechaMiel(
        colmenaId: 5,
        fechaMs: 1700000000000,
        kilosMiel: 18.5,
        kilosCera: 0.4,
        kilosPolen: 0.8,
        numeroAlza: 2,
      );
      final ida = CosechaMiel.fromMap(original.toMap());
      expect(ida.kilosMiel, 18.5);
      expect(ida.kilosCera, 0.4);
      expect(ida.numeroAlza, 2);
    });
  });

  group('Tratamiento varroa', () {
    test('round-trip ácido oxálico sublimación', () {
      final original = TratamientoVarroa(
        colmenaId: 5,
        fechaAplicacionMs: 1700000000000,
        fechaRetiradaMs: 1700200000000,
        sustanciaActivaId: 'acido_oxalico',
        dosis: '2 g/colmena',
        vehiculo: 'sublimacion',
        plazoSeguridadDias: 0,
        loteProducto: 'L2024-08-A1',
        numeroFactura: 'FACT-2024-1234',
      );
      final ida = TratamientoVarroa.fromMap(original.toMap());
      expect(ida.sustanciaActivaId, 'acido_oxalico');
      expect(ida.vehiculo, 'sublimacion');
      expect(ida.loteProducto, 'L2024-08-A1');
    });
  });

  group('Incidencia apícola', () {
    test('vespa velutina con resolución', () {
      final original = IncidenciaApicola(
        colmenaId: 5,
        fechaMs: 1700000000000,
        tipo: 'vespa_velutina',
        diagnostico: 'Predación intensa en piquera',
        severidad: 4,
        resuelta: true,
        fechaResolucionMs: 1701000000000,
      );
      final ida = IncidenciaApicola.fromMap(original.toMap());
      expect(ida.tipo, 'vespa_velutina');
      expect(ida.resuelta, true);
    });
  });

  group('Movimiento', () {
    test('trashumancia entre apiarios fijos', () {
      final original = Movimiento(
        apiarioOrigenId: 1,
        apiarioDestinoId: 2,
        fechaMovimientoMs: 1700000000000,
        motivo: 'mielada',
        numeroColmenas: 30,
      );
      final ida = Movimiento.fromMap(original.toMap());
      expect(ida.motivo, 'mielada');
      expect(ida.numeroColmenas, 30);
      expect(ida.apiarioOrigenId, 1);
      expect(ida.apiarioDestinoId, 2);
    });

    test('captura de enjambre (origen null)', () {
      final original = Movimiento(
        colmenaId: 5,
        apiarioDestinoId: 1,
        fechaMovimientoMs: 1700000000000,
        motivo: 'recogida_enjambre',
      );
      final ida = Movimiento.fromMap(original.toMap());
      expect(ida.apiarioOrigenId, isNull);
      expect(ida.motivo, 'recogida_enjambre');
    });

    test('mielada a ubicación puntual con coords', () {
      final original = Movimiento(
        apiarioOrigenId: 1,
        fechaMovimientoMs: 1700000000000,
        motivo: 'mielada',
        latitudDestino: 43.05,
        longitudDestino: -7.55,
      );
      final ida = Movimiento.fromMap(original.toMap());
      expect(ida.apiarioDestinoId, isNull);
      expect(ida.latitudDestino, 43.05);
      expect(ida.longitudDestino, -7.55);
    });
  });

  group('Apicultor (REGA)', () {
    test('estaConfigurado false sin nif/nombre/rega', () {
      expect(Apicultor().estaConfigurado, false);
      expect(Apicultor(nif: '12345678Z', nombre: 'X').estaConfigurado, false);
      expect(Apicultor(nif: '12345678Z', numeroRega: 'ES-26-008-AP-1234').estaConfigurado, false);
    });

    test('estaConfigurado true con los 3 mínimos', () {
      final a = Apicultor(
        nif: '12345678Z',
        nombre: 'Antonio Beltrán',
        numeroRega: 'ES-26-008-AP-1234',
      );
      expect(a.estaConfigurado, true);
    });

    test('round-trip preserva veterinario asesor', () {
      final original = Apicultor(
        nif: '12345678Z',
        nombre: 'Antonio Beltrán',
        numeroRega: 'ES-26-008-AP-1234',
        numeroExplotacionApicola: 'AP-26-2024-042',
        nombreVeterinario: 'Dra. Lúa Pereira',
        nifVeterinario: '87654321A',
        numeroColegiadoVeterinario: 'COL-LU-2345',
      );
      final ida = Apicultor.fromMap(original.toMap());
      expect(ida.numeroRega, 'ES-26-008-AP-1234');
      expect(ida.nombreVeterinario, 'Dra. Lúa Pereira');
      expect(ida.numeroColegiadoVeterinario, 'COL-LU-2345');
      expect(ida.estaConfigurado, true);
    });
  });

  group('Tercero', () {
    test('round-trip mínimo con NIF + tipo cliente', () {
      final original = Tercero(
        nif: 'B12345678',
        nombre: 'Cooperativa Apícola del Norte',
        tipo: 'cliente',
      );
      final ida = Tercero.fromMap(original.toMap());
      expect(ida.nif, 'B12345678');
      expect(ida.nombre, 'Cooperativa Apícola del Norte');
      expect(ida.tipo, 'cliente');
      expect(ida.esCliente, true);
      expect(ida.esProveedor, false);
      expect(ida.tieneNif, true);
    });

    test('tipo ambos cubre cliente y proveedor a la vez', () {
      final cooperativa = Tercero(nif: 'F87654321', nombre: 'Coop', tipo: 'ambos');
      expect(cooperativa.esCliente, true);
      expect(cooperativa.esProveedor, true);
    });

    test('NIF vacío detecta venta informal de mercadillo', () {
      final particular = Tercero(nombre: 'Particular del mercadillo', tipo: 'cliente');
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

    test('REAGP activa compensación 12% y anula IVA en venta de miel', () {
      final cf = ConfiguracionFiscal(
        regimenIrpf: 'estimacion_directa_simplificada',
        regimenIva: 'reagp',
      );
      expect(cf.estaConfigurado, true);
      expect(cf.tieneCompensacionReagp, true);
      expect(cf.tipoIvaVentaProducto, 0.0);
      expect(cf.tipoCompensacionReagp, 0.12);
      // El servicio de polinización va al 21% incluso en REAGP.
      expect(cf.tipoIvaPolinizacion, 0.21);
    });

    test('régimen general aplica IVA 4% en miel y nada de compensación', () {
      final cf = ConfiguracionFiscal(
        regimenIrpf: 'estimacion_directa_normal',
        regimenIva: 'general',
      );
      expect(cf.tipoIvaVentaProducto, 0.04);
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
    test('round-trip de venta de miel con compensación REAGP', () {
      final original = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: 'Venta 30 kg miel mil flores',
        tipoIngreso: 'venta_miel',
        importeBaseCentimos: 21000, // 210€
        compensacionReagpCentimos: 2520, // 12% sobre base
        cantidad: 30.0,
        unidad: 'kg',
        terceroId: 7,
        apiarioId: 2,
        numeroFactura: '2026/A/001',
      );
      final ida = ApunteIngreso.fromMap(original.toMap());
      expect(ida.tipoIngreso, 'venta_miel');
      expect(ida.cantidad, 30.0);
      expect(ida.unidad, 'kg');
      expect(ida.importeTotalCentimos, 21000 + 2520);
      expect(ida.esAyudaOSubvencion, false);
      expect(ida.esPolinizacion, false);
    });

    test('alquiler de polinización lleva IVA 21% y se marca polinización', () {
      final original = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: 'Polinización almendro 4 semanas',
        tipoIngreso: 'alquiler_polinizacion',
        importeBaseCentimos: 80000, // 800€
        ivaRepercutidoCentimos: 16800, // 21% IVA general
        cantidad: 40.0,
        unidad: 'colmenas',
        terceroId: 3,
      );
      final ida = ApunteIngreso.fromMap(original.toMap());
      expect(ida.esPolinizacion, true);
      expect(ida.importeTotalCentimos, 80000 + 16800);
      expect(ida.unidad, 'colmenas');
    });

    test('ayuda PAC se distingue del ingreso ordinario', () {
      final pac = ApunteIngreso(
        fechaMs: 1700000000000,
        concepto: 'Ayuda PAC apicultura ecológica 2026',
        tipoIngreso: 'ayuda_pac',
        importeBaseCentimos: 150000,
      );
      expect(pac.esAyudaOSubvencion, true);
      // Las ayudas no llevan IVA ni compensación.
      expect(pac.importeTotalCentimos, 150000);
    });

    test('subvención autonómica también es ayuda', () {
      final sub = ApunteIngreso(
        fechaMs: 1700000000000,
        tipoIngreso: 'subvencion_autonomica',
      );
      expect(sub.esAyudaOSubvencion, true);
    });
  });

  group('ApunteGasto', () {
    test('round-trip de gasto sanidad varroa imputado a colmenar concreto', () {
      final original = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Apivar 10 tiras',
        tipoGasto: 'sanidad_varroa',
        importeBaseCentimos: 4500,
        ivaSoportadoCentimos: 945, // 21% IVA producto veterinario
        imputacion: 'colmenar_concreto',
        apiarioId: 5,
        terceroId: 11,
        tratamientoVarroaId: 42,
        numeroFactura: 'PROV/2026/187',
      );
      final ida = ApunteGasto.fromMap(original.toMap());
      expect(ida.tipoGasto, 'sanidad_varroa');
      expect(ida.imputacion, 'colmenar_concreto');
      expect(ida.apiarioId, 5);
      expect(ida.tratamientoVarroaId, 42);
      expect(ida.esColmenarConcreto, true);
      expect(ida.tieneRepartoProporcional, false);
      expect(ida.importeTotalCentimos, 4500 + 945);
    });

    test('transporte trashumancia con reparto proporcional entre colmenares', () {
      final original = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Transporte 80 colmenas brezal → almendro',
        tipoGasto: 'transporte_trashumancia',
        importeBaseCentimos: 32000,
        imputacion: 'reparto_proporcional',
      );
      final ida = ApunteGasto.fromMap(original.toMap());
      expect(ida.tieneRepartoProporcional, true);
      expect(ida.esColmenarConcreto, false);
      expect(ida.apiarioId, isNull);
    });

    test('imputacion colmenar_concreto sin apiarioId no es válida', () {
      // Borde: si la imputación dice colmenar_concreto pero no hay
      // apiarioId, esColmenarConcreto debe ser false (la pantalla
      // se encarga de obligar a elegir uno antes de guardar).
      final raro = ApunteGasto(
        fechaMs: 1700000000000,
        imputacion: 'colmenar_concreto',
      );
      expect(raro.esColmenarConcreto, false);
    });

    test('gasto general sin imputación es lo normal para seguros', () {
      final seguros = ApunteGasto(
        fechaMs: 1700000000000,
        concepto: 'Seguro responsabilidad civil apícola',
        tipoGasto: 'seguros',
        importeBaseCentimos: 12000,
      );
      expect(seguros.imputacion, 'general');
      expect(seguros.esColmenarConcreto, false);
      expect(seguros.tieneRepartoProporcional, false);
    });
  });
}
