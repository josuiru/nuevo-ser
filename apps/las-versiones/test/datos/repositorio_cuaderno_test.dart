import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_cuaderno.dart';

GestorPerfiles _gestorDePrueba() => GestorPerfiles(
      namespace: 'nuevoser.lasversiones',
      sufijoNombreVisible: 'nombre_jugador',
      clavesGlobalesNoMigrables: const {
        'nuevoser.lasversiones.idioma_app',
        'nuevoser.lasversiones.token_backend',
        'nuevoser.lasversiones.email_backend',
      },
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RepositorioCuaderno', () {
    test('tieneEntrada devuelve false en almacén limpio', () async {
      final repositorio = RepositorioCuaderno(gestor: _gestorDePrueba());
      expect(await repositorio.tieneEntrada('cuaderno.1.0.3'), isFalse);
    });

    test('registrarEntrada y leer la marca', () async {
      final repositorio = RepositorioCuaderno(gestor: _gestorDePrueba());
      await repositorio.registrarEntrada('cuaderno.1.0.3');
      expect(await repositorio.tieneEntrada('cuaderno.1.0.3'), isTrue);
    });

    test('registrarEntrada es idempotente', () async {
      final repositorio = RepositorioCuaderno(gestor: _gestorDePrueba());
      await repositorio.registrarEntrada('cuaderno.1.0.3');
      await repositorio.registrarEntrada('cuaderno.1.0.3');
      expect(await repositorio.tieneEntrada('cuaderno.1.0.3'), isTrue);
      expect(
        (await repositorio.idsRegistrados()).length,
        1,
        reason: 'una sola entrada aunque se registre dos veces',
      );
    });

    test('idsRegistrados devuelve sólo entradas con bool true', () async {
      // Seed con prefijo del perfil activo (multi-perfil F2-26).
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.cuaderno.entrada.cuaderno.1.0.3':
            true,
        'nuevoser.lasversiones.perfil.principal.cuaderno.entrada.cuaderno.1.1.7':
            true,
        'nuevoser.lasversiones.perfil.principal.cuaderno.entrada.cuaderno.X':
            false,
      });
      final repositorio = RepositorioCuaderno(gestor: _gestorDePrueba());
      final ids = await repositorio.idsRegistrados();
      expect(ids, equals({'cuaderno.1.0.3', 'cuaderno.1.1.7'}));
    });

    test(
        'clave persistida lleva el prefijo del perfil activo: '
        'nuevoser.lasversiones.perfil.principal.cuaderno.entrada.*',
        () async {
      final repositorio = RepositorioCuaderno(gestor: _gestorDePrueba());
      await repositorio.registrarEntrada('cuaderno.1.0.3');
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool(
          'nuevoser.lasversiones.perfil.principal.cuaderno.entrada.cuaderno.1.0.3',
        ),
        isTrue,
      );
    });

    test(
        'migración silenciosa: claves heredadas pre-perfiles '
        '(nuevoser.lasversiones.cuaderno.entrada.X) se mueven al '
        'perfil principal en el primer arranque', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.cuaderno.entrada.cuaderno.1.0.3': true,
      });
      final repositorio = RepositorioCuaderno(gestor: _gestorDePrueba());
      // Una llamada cualquiera dispara prefsInicializadas() → migración.
      expect(await repositorio.tieneEntrada('cuaderno.1.0.3'), isTrue);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool(
          'nuevoser.lasversiones.perfil.principal.cuaderno.entrada.cuaderno.1.0.3',
        ),
        isTrue,
      );
      expect(
        prefs.getBool('nuevoser.lasversiones.cuaderno.entrada.cuaderno.1.0.3'),
        isNull,
        reason: 'la clave legada se borra tras migrar',
      );
    });

    test('claves de otros namespaces no se mezclan con las del cuaderno',
        () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.cuaderno.entrada.cuaderno.1.0.3':
            true,
        'nuevoser.lasversiones.perfil.principal.flag.escena_1_0_3_vista': true,
        'uroto.cuaderno.entrada.X': true,
      });
      final repositorio = RepositorioCuaderno(gestor: _gestorDePrueba());
      final ids = await repositorio.idsRegistrados();
      expect(ids, equals({'cuaderno.1.0.3'}),
          reason: 'sólo claves bajo nuestro prefijo concreto');
    });

    test('borrarTodas vacía las entradas del cuaderno y respeta otros '
        'namespaces', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.cuaderno.entrada.cuaderno.1.0.3':
            true,
        'nuevoser.lasversiones.perfil.principal.cuaderno.entrada.cuaderno.1.1.7':
            true,
        'nuevoser.lasversiones.perfil.principal.flag.escena_1_0_3_vista': true,
      });
      final repositorio = RepositorioCuaderno(gestor: _gestorDePrueba());
      await repositorio.borrarTodas();
      expect(await repositorio.idsRegistrados(), isEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool(
          'nuevoser.lasversiones.perfil.principal.flag.escena_1_0_3_vista',
        ),
        isTrue,
        reason: 'flags narrativos viven en otro sufijo y no se tocan',
      );
    });

    test(
        'isolamiento entre perfiles: cambiar al perfil "ander" no ve las '
        'entradas registradas en el perfil "principal"', () async {
      final gestor = _gestorDePrueba();
      final repositorio = RepositorioCuaderno(gestor: gestor);
      await repositorio.registrarEntrada('cuaderno.1.0.3');
      expect(await repositorio.tieneEntrada('cuaderno.1.0.3'), isTrue);

      final idAnder = await gestor.crearPerfil('Ander');
      await gestor.cambiarAPerfil(idAnder);

      expect(await repositorio.tieneEntrada('cuaderno.1.0.3'), isFalse,
          reason: 'el nuevo perfil arranca con el cuaderno vacío');
    });
  });
}
