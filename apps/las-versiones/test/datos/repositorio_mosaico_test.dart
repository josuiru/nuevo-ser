import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_mosaico.dart';
import 'package:las_versiones/dominio/mosaico_arco_1.dart';

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

  group('RepositorioMosaico (v2 — códigos de confianza)', () {
    test('cargar en almacén limpio devuelve mapa vacío', () async {
      final repositorio = RepositorioMosaico(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('arco_1'), isEmpty);
    });

    test('guardar y cargar conserva las marcas de confianza por viñeta',
        () async {
      final repositorio = RepositorioMosaico(gestor: _gestorDePrueba());
      await repositorio.guardar('arco_1', const {
        'aralar_dolmen_visita': NivelConfianza.solido,
        'cromlech_banquete': NivelConfianza.probable,
        'irulegi_la_mano': NivelConfianza.disputado,
      });
      final cargado = await repositorio.cargar('arco_1');
      expect(cargado.length, 3);
      expect(cargado['aralar_dolmen_visita'], NivelConfianza.solido);
      expect(cargado['cromlech_banquete'], NivelConfianza.probable);
      expect(cargado['irulegi_la_mano'], NivelConfianza.disputado);
    });

    test('aislamiento entre arcos distintos', () async {
      final repositorio = RepositorioMosaico(gestor: _gestorDePrueba());
      await repositorio.guardar(
        'arco_1',
        const {'aralar_dolmen_visita': NivelConfianza.solido},
      );
      await repositorio.guardar(
        'arco_2',
        const {'pompaelo_foro': NivelConfianza.probable},
      );
      expect(
        (await repositorio.cargar('arco_1')).keys,
        equals({'aralar_dolmen_visita'}),
      );
      expect(
        (await repositorio.cargar('arco_2')).keys,
        equals({'pompaelo_foro'}),
      );
    });

    test(
        'clave persistida sigue el namespace '
        'nuevoser.lasversiones.perfil.principal.mosaico.<idArco>', () async {
      final repositorio = RepositorioMosaico(gestor: _gestorDePrueba());
      await repositorio.guardar(
        'arco_1',
        const {'aralar_dolmen_visita': NivelConfianza.solido},
      );
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(
          'nuevoser.lasversiones.perfil.principal.mosaico.arco_1',
        ),
        isNotNull,
      );
    });

    test('blob corrupto → mapa vacío sin propagar excepción', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.mosaico.arco_1':
            '{ no es JSON }',
      });
      final repositorio = RepositorioMosaico(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('arco_1'), isEmpty);
    });

    test('valores no-string se filtran silenciosamente', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.mosaico.arco_1':
            '{"aralar_dolmen_visita":"solido","mal":42,"cromlech_banquete":'
            '"probable"}',
      });
      final repositorio = RepositorioMosaico(gestor: _gestorDePrueba());
      final cargado = await repositorio.cargar('arco_1');
      expect(
        cargado.keys,
        equals({'aralar_dolmen_visita', 'cromlech_banquete'}),
      );
    });

    test(
        'valores string que no son una clave de NivelConfianza '
        'reconocible se filtran silenciosamente — protege migración del '
        'shape v1 (texto libre de los 3 prompts antiguos)', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.mosaico.arco_1': '{'
            '"que_te_llevas":"Que el oficio empieza con preguntas.",'
            '"aralar_dolmen_visita":"solido",'
            '"que_te_queda":"Por qué el sitio se llamaba así."'
            '}',
      });
      final repositorio = RepositorioMosaico(gestor: _gestorDePrueba());
      final cargado = await repositorio.cargar('arco_1');
      expect(
        cargado.keys,
        equals({'aralar_dolmen_visita'}),
        reason: 'sólo "aralar_dolmen_visita":"solido" se reconoce; las dos '
            'entradas con texto libre del shape v1 se descartan',
      );
      expect(cargado['aralar_dolmen_visita'], NivelConfianza.solido);
    });

    test('borrar quita el blob', () async {
      final repositorio = RepositorioMosaico(gestor: _gestorDePrueba());
      await repositorio.guardar(
        'arco_1',
        const {'aralar_dolmen_visita': NivelConfianza.solido},
      );
      await repositorio.borrar('arco_1');
      expect(await repositorio.cargar('arco_1'), isEmpty);
    });

    test('aislamiento entre perfiles: cambiar a "ander" no ve marcas '
        'guardadas en "principal"', () async {
      final gestor = _gestorDePrueba();
      final repositorio = RepositorioMosaico(gestor: gestor);
      await repositorio.guardar(
        'arco_1',
        const {'aralar_dolmen_visita': NivelConfianza.solido},
      );
      expect(await repositorio.cargar('arco_1'), isNotEmpty);

      final idAnder = await gestor.crearPerfil('Ander');
      await gestor.cambiarAPerfil(idAnder);

      expect(await repositorio.cargar('arco_1'), isEmpty);
    });
  });
}
