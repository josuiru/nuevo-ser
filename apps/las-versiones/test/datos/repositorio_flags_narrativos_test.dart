import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_flags_narrativos.dart';

GestorPerfiles _gestor() => GestorPerfiles(
      namespace: 'nuevoser.lasversiones',
      sufijoNombreVisible: 'nombre_jugador',
      clavesGlobalesNoMigrables: const {
        'nuevoser.lasversiones.idioma_app',
      },
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('RepositorioFlagsNarrativos', () {
    test('estaActivo devuelve false en almacén limpio', () async {
      final repo = RepositorioFlagsNarrativos(gestor: _gestor());
      expect(await repo.estaActivo('met_isaura'), isFalse);
    });

    test('activar y leer un flag', () async {
      final repo = RepositorioFlagsNarrativos(gestor: _gestor());
      await repo.activar('escena_1_0_1_vista');
      expect(await repo.estaActivo('escena_1_0_1_vista'), isTrue);
    });

    test('activar es idempotente — segundo activar no rompe ni desactiva',
        () async {
      final repo = RepositorioFlagsNarrativos(gestor: _gestor());
      await repo.activar('met_begona');
      await repo.activar('met_begona');
      expect(await repo.estaActivo('met_begona'), isTrue);
    });

    test('activos() devuelve el conjunto de flags activos sin el prefijo',
        () async {
      final repo = RepositorioFlagsNarrativos(gestor: _gestor());
      await repo.activar('met_isaura');
      await repo.activar('met_begona');
      await repo.activar('evaluation_passed');
      final activos = await repo.activos();
      expect(activos, {'met_isaura', 'met_begona', 'evaluation_passed'});
    });

    test('activos() ignora claves de otros namespaces — el repositorio '
        'sólo ve los flags propios del perfil activo', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.flag.met_isaura': true,
        'uroto.flag.escena_1_1_vista': true,
        'nuevoser.lasversiones.idioma_app': 'es',
      });
      final repo = RepositorioFlagsNarrativos(gestor: _gestor());
      final activos = await repo.activos();
      expect(activos, {'met_isaura'});
    });

    test(
        'clave persistida lleva el prefijo del perfil activo: '
        'nuevoser.lasversiones.perfil.principal.flag.*',
        () async {
      final repo = RepositorioFlagsNarrativos(gestor: _gestor());
      await repo.activar('accepted_aspirante');
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool(
          'nuevoser.lasversiones.perfil.principal.flag.accepted_aspirante',
        ),
        isTrue,
      );
    });

    test(
        'migración silenciosa: nuevoser.lasversiones.flag.X heredada se '
        'mueve a nuevoser.lasversiones.perfil.principal.flag.X', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.flag.met_isaura': true,
        'nuevoser.lasversiones.idioma_app': 'es',
      });
      final repo = RepositorioFlagsNarrativos(gestor: _gestor());
      expect(await repo.estaActivo('met_isaura'), isTrue);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool('nuevoser.lasversiones.flag.met_isaura'),
        isNull,
        reason: 'la clave legada se borra tras migrar',
      );
      expect(prefs.getString('nuevoser.lasversiones.idioma_app'), 'es',
          reason: 'el idioma es global y NO se migra');
    });

    test('borrarTodos quita los flags propios y respeta otros namespaces',
        () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.flag.met_isaura': true,
        'nuevoser.lasversiones.perfil.principal.flag.evaluation_passed': true,
        'nuevoser.lasversiones.idioma_app': 'es',
      });
      final repo = RepositorioFlagsNarrativos(gestor: _gestor());
      await repo.borrarTodos();
      expect(await repo.activos(), isEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('nuevoser.lasversiones.idioma_app'), 'es',
          reason: 'el idioma no es un flag y no debe borrarse');
    });

    test('isolamiento entre perfiles: cambiar a "ander" no ve flags '
        'activados en "principal"', () async {
      final gestor = _gestor();
      final repo = RepositorioFlagsNarrativos(gestor: gestor);
      await repo.activar('escena_1_0_1_vista');
      expect(await repo.estaActivo('escena_1_0_1_vista'), isTrue);

      final idAnder = await gestor.crearPerfil('Ander');
      await gestor.cambiarAPerfil(idAnder);

      expect(await repo.estaActivo('escena_1_0_1_vista'), isFalse);
    });
  });
}
