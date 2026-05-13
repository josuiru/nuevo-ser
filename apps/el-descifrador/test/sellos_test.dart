// Tests del modelo Sellos + RepositorioSellos + ServicioSellos.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_sellos.dart';
import 'package:el_descifrador/dominio/decision_documento.dart';
import 'package:el_descifrador/dominio/identificaciones_lengua.dart';
import 'package:el_descifrador/dominio/lengua.dart';
import 'package:el_descifrador/dominio/sellos.dart';
import 'package:el_descifrador/dominio/servicio_sellos.dart';

void main() {
  group('Sellos', () {
    test('estado inicial: vacío', () {
      final sellos = Sellos.inicial();
      expect(sellos.vacio, isTrue);
      expect(sellos.cantidad, 0);
      expect(sellos.tieneSello('cualquiera'), isFalse);
    });

    test('conSello añade y no duplica', () {
      var sellos = Sellos.inicial();
      sellos = sellos.conSello(
        clave: 'a',
        ahora: DateTime.utc(2026, 5, 13),
      );
      sellos = sellos.conSello(
        clave: 'a',
        ahora: DateTime.utc(2026, 5, 14),
      );
      expect(sellos.cantidad, 1);
      expect(sellos.fechaDe('a'), DateTime.utc(2026, 5, 13));
    });

    test('ordenadosPorFecha: más recientes primero', () {
      var sellos = Sellos.inicial();
      sellos = sellos.conSello(
        clave: 'viejo',
        ahora: DateTime.utc(2026, 1, 1),
      );
      sellos = sellos.conSello(
        clave: 'nuevo',
        ahora: DateTime.utc(2026, 5, 13),
      );
      final lista = sellos.ordenadosPorFecha();
      expect(lista.first.clave, 'nuevo');
      expect(lista.last.clave, 'viejo');
    });

    test('texto canónico de lengua_descubierta', () {
      expect(
        textoCanonicoDeClave('lengua_descubierta:pt'),
        contains('portugués'),
      );
      expect(
        textoCanonicoDeClave('lengua_descubierta:pt').toLowerCase(),
        contains('cuaderno'),
      );
    });

    test('texto canónico de lengua_descifrada', () {
      expect(
        textoCanonicoDeClave('lengua_descifrada:eu').toLowerCase(),
        contains('primera pieza descifrada'),
      );
    });

    test('texto canónico de publicacion_boletin', () {
      expect(
        textoCanonicoDeClave(clavePublicacionBoletin).toLowerCase(),
        contains('boletín'),
      );
    });

    test('serialización ida y vuelta preserva contenido', () {
      var sellos = Sellos.inicial();
      sellos = sellos.conSello(
        clave: 'lengua_descubierta:pt',
        ahora: DateTime.utc(2026, 5, 13),
      );
      sellos = sellos.conSello(
        clave: clavePublicacionBoletin,
        ahora: DateTime.utc(2026, 5, 14),
      );
      final reconstruido = Sellos.deserializar(sellos.serializar());
      expect(reconstruido.cantidad, 2);
      expect(reconstruido.fechaDe('lengua_descubierta:pt'),
          DateTime.utc(2026, 5, 13));
    });

    test('deserialización tolera valores mal formados', () {
      final mapaConBasura = {
        'a': '2026-05-13T00:00:00.000Z',
        'b': 42,
        'c': 'no-es-fecha-iso',
      };
      final sellos = Sellos.deserializar(mapaConBasura);
      expect(sellos.tieneSello('a'), isTrue);
      expect(sellos.tieneSello('b'), isFalse);
      expect(sellos.tieneSello('c'), isFalse);
    });
  });

  group('RepositorioSellos', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve vacío', () async {
      final repo = RepositorioSellos(idPerfil: 'test-1');
      final sellos = await repo.cargar();
      expect(sellos.vacio, isTrue);
    });

    test('registrarSelloSiNuevo devuelve true la primera vez, false luego',
        () async {
      final repo = RepositorioSellos(
        idPerfil: 'test-2',
        relojInyectado: () => DateTime.utc(2026, 5, 13),
      );
      final (_, primeraVez) = await repo.registrarSelloSiNuevo('a');
      final (_, segundaVez) = await repo.registrarSelloSiNuevo('a');
      expect(primeraVez, isTrue);
      expect(segundaVez, isFalse);
    });

    test('perfiles distintos no se contaminan', () async {
      final ana = RepositorioSellos(
        idPerfil: 'ana',
        relojInyectado: () => DateTime.utc(2026, 5, 13),
      );
      final luis = RepositorioSellos(idPerfil: 'luis');
      await ana.registrarSelloSiNuevo('a');
      expect((await ana.cargar()).cantidad, 1);
      expect((await luis.cargar()).vacio, isTrue);
    });
  });

  group('ServicioSellos — identificación', () {
    const servicio = ServicioSellos();

    test('primera vez que se identifica una lengua: concede sello', () {
      final sellos = servicio.sellosTrasIdentificacionExitosa(
        lenguaIdentificada: Lengua.portugues,
        identificacionesPrevias: IdentificacionesPiezas.inicial(),
        sellosPrevios: Sellos.inicial(),
      );
      expect(sellos, [claveLenguaDescubierta(Lengua.portugues)]);
    });

    test('sello ya concedido: no se vuelve a conceder', () {
      final sellosPrevios = Sellos.inicial().conSello(
        clave: claveLenguaDescubierta(Lengua.portugues),
        ahora: DateTime.utc(2026, 5, 13),
      );
      final sellos = servicio.sellosTrasIdentificacionExitosa(
        lenguaIdentificada: Lengua.portugues,
        identificacionesPrevias: IdentificacionesPiezas.inicial(),
        sellosPrevios: sellosPrevios,
      );
      expect(sellos, isEmpty);
    });

    test('si ya hubo otra identificación correcta en esa lengua: no sello',
        () {
      // El niño ya identificó portugués en p1; ahora identifica en p2.
      final identificacionesPrevias =
          IdentificacionesPiezas.inicial().conIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.portugues,
        lenguaCorrecta: Lengua.portugues,
        ahora: DateTime.utc(2026, 5, 10),
      );
      final sellos = servicio.sellosTrasIdentificacionExitosa(
        lenguaIdentificada: Lengua.portugues,
        identificacionesPrevias: identificacionesPrevias,
        sellosPrevios: Sellos.inicial(),
      );
      expect(sellos, isEmpty);
    });
  });

  group('ServicioSellos — decisión', () {
    const servicio = ServicioSellos();

    test('primera decisión en una lengua: concede sello "descifrada"', () {
      final sellos = servicio.sellosTrasDecision(
        lenguaDePieza: Lengua.portugues,
        decisionTomada: DecisionDocumento.archivar,
        sellosPrevios: Sellos.inicial(),
      );
      expect(sellos, [claveLenguaDescifrada(Lengua.portugues)]);
    });

    test('publicar en Boletín: concede sello "primera publicación" además',
        () {
      final sellos = servicio.sellosTrasDecision(
        lenguaDePieza: Lengua.portugues,
        decisionTomada: DecisionDocumento.publicarEnBoletin,
        sellosPrevios: Sellos.inicial(),
      );
      expect(sellos, containsAll([
        claveLenguaDescifrada(Lengua.portugues),
        clavePublicacionBoletin,
      ]));
    });

    test('segunda publicación: no vuelve a sellar el Boletín', () {
      final sellosPrevios = Sellos.inicial()
          .conSello(
            clave: claveLenguaDescifrada(Lengua.portugues),
            ahora: DateTime.utc(2026, 5, 10),
          )
          .conSello(
            clave: clavePublicacionBoletin,
            ahora: DateTime.utc(2026, 5, 10),
          );
      final sellos = servicio.sellosTrasDecision(
        lenguaDePieza: Lengua.portugues,
        decisionTomada: DecisionDocumento.publicarEnBoletin,
        sellosPrevios: sellosPrevios,
      );
      expect(sellos, isEmpty);
    });
  });
}
