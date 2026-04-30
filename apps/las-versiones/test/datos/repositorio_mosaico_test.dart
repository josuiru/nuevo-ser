import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_mosaico.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RepositorioMosaico', () {
    test('cargar en almacén limpio devuelve mapa vacío', () async {
      final repositorio = const RepositorioMosaico();
      expect(await repositorio.cargar('arco_1'), isEmpty);
    });

    test('guardar y cargar conserva las respuestas', () async {
      final repositorio = const RepositorioMosaico();
      await repositorio.guardar('arco_1', const {
        'que_te_llevas': 'Que el oficio empieza con preguntas.',
        'que_te_queda': 'Por qué el sitio se llamaba así.',
      });
      final cargado = await repositorio.cargar('arco_1');
      expect(cargado.length, 2);
      expect(cargado['que_te_llevas'], contains('preguntas'));
    });

    test('aislamiento entre arcos distintos', () async {
      final repositorio = const RepositorioMosaico();
      await repositorio.guardar('arco_1', const {'a': 'uno'});
      await repositorio.guardar('arco_2', const {'b': 'dos'});
      expect((await repositorio.cargar('arco_1')).keys, equals({'a'}));
      expect((await repositorio.cargar('arco_2')).keys, equals({'b'}));
    });

    test('clave persistida sigue el namespace '
        'nuevoser.lasversiones.mosaico.<idArco>', () async {
      final repositorio = const RepositorioMosaico();
      await repositorio.guardar('arco_1', const {'q': 'r'});
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString('nuevoser.lasversiones.mosaico.arco_1'),
        isNotNull,
      );
    });

    test('blob corrupto → mapa vacío sin propagar excepción', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.mosaico.arco_1': '{ no es JSON }',
      });
      final repositorio = const RepositorioMosaico();
      expect(await repositorio.cargar('arco_1'), isEmpty);
    });

    test('valores no-string se filtran silenciosamente', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.mosaico.arco_1':
            '{"a":"texto","b":42,"c":"otro"}',
      });
      final repositorio = const RepositorioMosaico();
      final cargado = await repositorio.cargar('arco_1');
      expect(cargado.keys, equals({'a', 'c'}));
    });

    test('borrar quita el blob', () async {
      final repositorio = const RepositorioMosaico();
      await repositorio.guardar('arco_1', const {'a': 'x'});
      await repositorio.borrar('arco_1');
      expect(await repositorio.cargar('arco_1'), isEmpty);
    });
  });
}
