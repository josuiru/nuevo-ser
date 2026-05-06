import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_evaluacion_fuente.dart';
import 'package:las_versiones/dominio/brecha.dart';
import 'package:las_versiones/dominio/evaluacion_fuente.dart';

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

  group('RepositorioEvaluacionFuente', () {
    test('cargar en almacén limpio devuelve null', () async {
      final repositorio =
          RepositorioEvaluacionFuente(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('1.1', 'A'), isNull);
    });

    test('guardar y cargar conserva tipo y sesgo', () async {
      final repositorio =
          RepositorioEvaluacionFuente(gestor: _gestorDePrueba());
      const respuesta = RespuestaEvaluacionFuente(
        tipoElegido: TipoFuente.secundaria,
        sesgoElegido: SesgoFuente.difusionista,
      );
      await repositorio.guardar('1.1', 'A', respuesta);
      final cargada = await repositorio.cargar('1.1', 'A');
      expect(cargada, isNotNull);
      expect(cargada!.tipoElegido, TipoFuente.secundaria);
      expect(cargada.sesgoElegido, SesgoFuente.difusionista);
    });

    test('guardar respuesta parcial — sólo tipo', () async {
      final repositorio =
          RepositorioEvaluacionFuente(gestor: _gestorDePrueba());
      const respuesta = RespuestaEvaluacionFuente(
        tipoElegido: TipoFuente.primaria,
      );
      await repositorio.guardar('1.1', 'A', respuesta);
      final cargada = await repositorio.cargar('1.1', 'A');
      expect(cargada!.tipoElegido, TipoFuente.primaria);
      expect(cargada.sesgoElegido, isNull);
      expect(cargada.estaCompleta, isFalse);
    });

    test(
        'clave persistida sigue el namespace nuevoser.lasversiones.perfil.'
        'principal.brecha.<id>.evaluacion.<idFuente>', () async {
      final repositorio =
          RepositorioEvaluacionFuente(gestor: _gestorDePrueba());
      await repositorio.guardar(
        '1.1',
        'A',
        const RespuestaEvaluacionFuente(tipoElegido: TipoFuente.primaria),
      );
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(
          'nuevoser.lasversiones.perfil.principal.brecha.1.1.evaluacion.A',
        ),
        isNotNull,
      );
    });

    test('aislamiento entre brechas y entre fuentes', () async {
      final repositorio =
          RepositorioEvaluacionFuente(gestor: _gestorDePrueba());
      await repositorio.guardar(
        '1.1',
        'A',
        const RespuestaEvaluacionFuente(tipoElegido: TipoFuente.primaria),
      );
      expect(await repositorio.cargar('1.1', 'B'), isNull);
      expect(await repositorio.cargar('1.2', 'A'), isNull);
    });

    test('cargarTodasDeBrecha mapea las evaluaciones por idFuente', () async {
      final repositorio =
          RepositorioEvaluacionFuente(gestor: _gestorDePrueba());
      await repositorio.guardar(
        '1.1',
        'A',
        const RespuestaEvaluacionFuente(
          tipoElegido: TipoFuente.primaria,
          sesgoElegido: SesgoFuente.ninguno,
        ),
      );
      await repositorio.guardar(
        '1.1',
        'B',
        const RespuestaEvaluacionFuente(
          tipoElegido: TipoFuente.secundaria,
          sesgoElegido: SesgoFuente.oficialista,
        ),
      );
      await repositorio.guardar(
        '1.2',
        'X',
        const RespuestaEvaluacionFuente(tipoElegido: TipoFuente.primaria),
      );
      final mapa = await repositorio.cargarTodasDeBrecha('1.1');
      expect(mapa.keys.toSet(), equals({'A', 'B'}));
      expect(mapa['A']!.sesgoElegido, SesgoFuente.ninguno);
      expect(mapa['B']!.sesgoElegido, SesgoFuente.oficialista);
    });

    test('blob corrupto → null sin propagar excepción', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.brecha.1.1.evaluacion.A':
            '{ no es JSON }',
      });
      final repositorio =
          RepositorioEvaluacionFuente(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('1.1', 'A'), isNull);
    });

    test('borrar quita las evaluaciones de la brecha', () async {
      final repositorio =
          RepositorioEvaluacionFuente(gestor: _gestorDePrueba());
      await repositorio.guardar(
        '1.1',
        'A',
        const RespuestaEvaluacionFuente(tipoElegido: TipoFuente.primaria),
      );
      await repositorio.guardar(
        '1.2',
        'X',
        const RespuestaEvaluacionFuente(tipoElegido: TipoFuente.primaria),
      );
      await repositorio.borrar('1.1');
      expect(await repositorio.cargar('1.1', 'A'), isNull);
      expect(await repositorio.cargar('1.2', 'X'), isNotNull,
          reason: 'borrar 1.1 no toca 1.2');
    });
  });
}
