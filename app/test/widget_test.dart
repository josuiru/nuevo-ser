import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uno_roto/dominio/catalogo_escenas.dart';
import 'package:uno_roto/dominio/plano_escena.dart';
import 'package:uno_roto/main.dart';
import 'package:uno_roto/vista/pantalla_cinematica.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
      'La app arranca y, la primera vez, muestra el título de apertura',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AppUnoRoto());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('UNO'), findsOneWidget);
    expect(find.text('ROTO'), findsOneWidget);
  });

  test('El catálogo contiene la escena 1.1 "El tejado"', () {
    final tejado = CatalogoEscenas.porId('1.1');
    expect(tejado, isNotNull);
    expect(tejado!.titulo, 'El tejado');
    expect(tejado.flagDeSalida, 'escena_1_1_vista');
    expect(tejado.planos, isNotEmpty);
  });

  test('aplicarTokens sustituye {nombre} por el nombre real', () {
    expect(aplicarTokens('Hola, {nombre}.', 'Leo'), 'Hola, Leo.');
    expect(
      aplicarTokens('{nombre}, {nombre}, {nombre}.', 'Lía'),
      'Lía, Lía, Lía.',
    );
    expect(aplicarTokens('Sin token.', 'Leo'), 'Sin token.');
    expect(aplicarTokens('{nombre}', ''), '{nombre}');
  });

  test('Las escenas 1.2/1.3/1.4 encadenan prerrequisitos', () {
    final ventana = CatalogoEscenas.porId('1.2');
    expect(ventana!.flagsRequeridos, contains('escena_1_1_vista'));

    final callejon = CatalogoEscenas.porId('1.3');
    expect(callejon!.flagsRequeridos, contains('escena_1_2_vista'));

    final irune = CatalogoEscenas.porId('1.4');
    expect(irune!.flagsRequeridos, contains('escena_1_3_vista'));
  });

  test('La escena 1.1 alterna ambientes y diálogos', () {
    final planos = CatalogoEscenas.llegada.planos;
    final hayAmbiente = planos.any((p) => p is PlanoAmbiente);
    final hayDialogo = planos.any((p) => p is PlanoDialogo);
    expect(hayAmbiente, isTrue);
    expect(hayDialogo, isTrue);
  });

  testWidgets(
    'Tras la apertura, si la escena 1.1 no se ha visto, se reproduce',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'uroto.ya_vio_apertura': true,
        'uroto.nombre_jugador': 'Leo',
      });
      await tester.pumpWidget(const AppUnoRoto());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('saltar'), findsOneWidget);
    },
  );

  testWidgets(
    'Si la apertura ha pasado pero falta el nombre, se pide el nombre',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'uroto.ya_vio_apertura': true,
      });
      await tester.pumpWidget(const AppUnoRoto());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('¿Cómo te llamas?'), findsOneWidget);
    },
  );

  testWidgets(
    'Si todas las escenas del Arco 1 abierto están vistas, va al mapa',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'uroto.ya_vio_apertura': true,
        'uroto.nombre_jugador': 'Leo',
        'uroto.flag.escena_1_1_vista': true,
        'uroto.flag.escena_1_2_vista': true,
        'uroto.flag.escena_1_3_vista': true,
        'uroto.flag.escena_1_4_vista': true,
        'uroto.flag.escena_1_5_vista': true,
      });
      await tester.pumpWidget(const AppUnoRoto());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('UNO ROTO'), findsOneWidget);
      expect(find.text('LA MONTAÑA'), findsOneWidget);
    },
  );

  testWidgets(
    'Tras la 1.1, si la 1.2 no está vista, se dispara la 1.2',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'uroto.ya_vio_apertura': true,
        'uroto.nombre_jugador': 'Leo',
        'uroto.flag.escena_1_1_vista': true,
      });
      await tester.pumpWidget(const AppUnoRoto());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 400));

      // La cinemática 1.2 se reproduce: indicador "saltar" presente.
      expect(find.text('saltar'), findsOneWidget);
    },
  );
}
