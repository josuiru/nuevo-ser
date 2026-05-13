// Tests del modelo Localizacion + RepositorioLocalizacion.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_localizacion.dart';
import 'package:el_descifrador/dominio/localizacion.dart';

void main() {
  group('Localizacion (mapa del puerto)', () {
    test('identificadorTecnico es único por localización', () {
      final ids =
          Localizacion.values.map((l) => l.identificadorTecnico).toSet();
      expect(ids.length, Localizacion.values.length);
    });

    test('rutaFondo usa convención assets/escenarios/<id>.png', () {
      expect(
        Localizacion.oficina.rutaFondo,
        'assets/escenarios/oficina.png',
      );
      expect(
        Localizacion.calleMayor.rutaFondo,
        'assets/escenarios/calle_mayor.png',
      );
    });

    test('desdeIdentificador parsea correctamente', () {
      expect(
        Localizacion.desdeIdentificador('muelle'),
        Localizacion.muelle,
      );
    });

    test('desdeIdentificador lanza ArgumentError en desconocida', () {
      expect(
        () => Localizacion.desdeIdentificador('inexistente'),
        throwsArgumentError,
      );
    });

    test('Calle Mayor conecta con 4 destinos (es el hub)', () {
      expect(
        destinosDesde(Localizacion.calleMayor),
        {
          Localizacion.oficina,
          Localizacion.despachoMaestro,
          Localizacion.muelle,
          Localizacion.boletin,
        },
      );
    });

    test('Oficina solo conecta con Calle Mayor', () {
      expect(
        destinosDesde(Localizacion.oficina),
        {Localizacion.calleMayor},
      );
    });

    test('Despacho, Muelle y Boletín solo conectan con Calle Mayor', () {
      for (final loc in [
        Localizacion.despachoMaestro,
        Localizacion.muelle,
        Localizacion.boletin,
      ]) {
        expect(
          destinosDesde(loc),
          {Localizacion.calleMayor},
          reason: 'falla para $loc',
        );
      }
    });

    test('todas las conexiones son bidireccionales', () {
      for (final origen in Localizacion.values) {
        for (final destino in destinosDesde(origen)) {
          expect(
            destinosDesde(destino),
            contains(origen),
            reason: 'rota: $origen → $destino sin vuelta',
          );
        }
      }
    });

    test('todos los nodos están conectados al grafo (no hay islas)', () {
      // BFS desde oficina debe alcanzar todos.
      final alcanzados = <Localizacion>{Localizacion.oficina};
      final cola = <Localizacion>[Localizacion.oficina];
      while (cola.isNotEmpty) {
        final actual = cola.removeAt(0);
        for (final destino in destinosDesde(actual)) {
          if (alcanzados.add(destino)) cola.add(destino);
        }
      }
      expect(alcanzados, Localizacion.values.toSet());
    });
  });

  group('RepositorioLocalizacion', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve oficina (default)', () async {
      final repo = RepositorioLocalizacion(idPerfil: 'test-1');
      expect(await repo.cargar(), Localizacion.oficina);
    });

    test('guardar y recuperar persiste', () async {
      final repo = RepositorioLocalizacion(idPerfil: 'test-2');
      await repo.guardar(Localizacion.muelle);
      final reabierto = RepositorioLocalizacion(idPerfil: 'test-2');
      expect(await reabierto.cargar(), Localizacion.muelle);
    });

    test('valor corrupto: cargar cae a oficina con seguridad', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.descifrador.perfil.test-3.localizacion': 'no-existe',
      });
      final repo = RepositorioLocalizacion(idPerfil: 'test-3');
      expect(await repo.cargar(), Localizacion.oficina);
    });

    test('perfiles distintos no se contaminan', () async {
      final ana = RepositorioLocalizacion(idPerfil: 'ana');
      final luis = RepositorioLocalizacion(idPerfil: 'luis');
      await ana.guardar(Localizacion.boletin);
      expect(await ana.cargar(), Localizacion.boletin);
      expect(await luis.cargar(), Localizacion.oficina);
    });
  });
}
