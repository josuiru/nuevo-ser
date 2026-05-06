import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_preguntas_brecha.dart';

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

  group('RepositorioPreguntasBrecha', () {
    test('cargar en almacén limpio devuelve lista vacía', () async {
      final repositorio = RepositorioPreguntasBrecha(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('1.1'), isEmpty);
    });

    test('guardar y cargar conserva orden y contenido', () async {
      final repositorio = RepositorioPreguntasBrecha(gestor: _gestorDePrueba());
      const preguntas = ['¿Qué pasó aquí?', '¿Por qué importa?'];
      await repositorio.guardar('1.1', preguntas);
      final cargadas = await repositorio.cargar('1.1');
      expect(cargadas, equals(preguntas));
    });

    test('aislamiento por id de Brecha', () async {
      final repositorio = RepositorioPreguntasBrecha(gestor: _gestorDePrueba());
      await repositorio.guardar('1.1', ['¿una?']);
      await repositorio.guardar('1.2', ['¿dos?', '¿tres?']);
      expect(await repositorio.cargar('1.1'), equals(['¿una?']));
      expect(await repositorio.cargar('1.2'), equals(['¿dos?', '¿tres?']));
    });

    test(
        'clave persistida sigue el namespace '
        'nuevoser.lasversiones.perfil.principal.brecha.<id>.preguntas',
        () async {
      final repositorio = RepositorioPreguntasBrecha(gestor: _gestorDePrueba());
      await repositorio.guardar('1.1', ['¿una?']);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(
          'nuevoser.lasversiones.perfil.principal.brecha.1.1.preguntas',
        ),
        isNotNull,
      );
    });

    test('blob corrupto → lista vacía sin propagar excepción', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.brecha.1.1.preguntas':
            '{ no es JSON }',
      });
      final repositorio = RepositorioPreguntasBrecha(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('1.1'), isEmpty);
    });

    test('JSON con tipo inesperado (objeto, no lista) → lista vacía',
        () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.brecha.1.1.preguntas':
            '{"clave":"valor"}',
      });
      final repositorio = RepositorioPreguntasBrecha(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('1.1'), isEmpty);
    });

    test('JSON con elementos no-string los filtra silenciosamente',
        () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.brecha.1.1.preguntas':
            '["¿una?", 42, "¿dos?"]',
      });
      final repositorio = RepositorioPreguntasBrecha(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('1.1'), equals(['¿una?', '¿dos?']));
    });

    test('borrar quita el blob', () async {
      final repositorio = RepositorioPreguntasBrecha(gestor: _gestorDePrueba());
      await repositorio.guardar('1.1', ['¿una?']);
      await repositorio.borrar('1.1');
      expect(await repositorio.cargar('1.1'), isEmpty);
    });
  });
}
