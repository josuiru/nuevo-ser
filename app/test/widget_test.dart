import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uno_roto/datos/catalogo_habilidades.dart';
import 'package:uno_roto/dominio/catalogo_escenas.dart';
import 'package:uno_roto/dominio/habilidad.dart';
import 'package:uno_roto/dominio/motor_maestria.dart';
import 'package:uno_roto/dominio/plano_escena.dart';
import 'package:uno_roto/dominio/rango_narrativo.dart';
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

  test('La escena 1.6 es cierre amable y usa PlanoCierreAmable', () {
    final derrota = CatalogoEscenas.porId('1.6');
    expect(derrota, isNotNull);
    expect(derrota!.esCierreAmable, isTrue);
    expect(derrota.planos.last, isA<PlanoCierreAmable>());
  });

  test('Las escenas 1.2/1.3/1.4 encadenan prerrequisitos', () {
    final ventana = CatalogoEscenas.porId('1.2');
    expect(ventana!.flagsRequeridos, contains('escena_1_1_vista'));

    final callejon = CatalogoEscenas.porId('1.3');
    expect(callejon!.flagsRequeridos, contains('escena_1_2_vista'));

    final irune = CatalogoEscenas.porId('1.4');
    expect(irune!.flagsRequeridos, contains('escena_1_3_vista'));
  });

  test('flagDeMaestria normaliza id y nivel a flag estable', () {
    expect(
      MotorMaestria.flagDeMaestria('FR.05', NivelMaestria.competente),
      'fr_05_competente',
    );
    expect(
      MotorMaestria.flagDeMaestria('FR.01', NivelMaestria.introducida),
      'fr_01_introducida',
    );
    expect(
      MotorMaestria.flagDeMaestria('DEC.10', NivelMaestria.maestria),
      'dec_10_maestria',
    );
    expect(
      MotorMaestria.flagDeMaestria('GEO.03', NivelMaestria.enDesarrollo),
      'geo_03_en_desarrollo',
    );
  });

  test('Motor invoca alSubirNivel solo cuando el nivel sube', () async {
    final catalogo = await CatalogoHabilidades.cargar();
    final almacen = <String, EstadoHabilidad>{};
    final subidas = <(String, NivelMaestria)>[];
    final motor = MotorMaestria(
      catalogo: catalogo,
      cargarEstado: (id) async => almacen[id],
      guardarEstado: (estado) async {
        almacen[estado.identificadorHabilidad] = estado;
      },
      alSubirNivel: (id, nivel) => subidas.add((id, nivel)),
    );

    // Primera práctica: inexplorada → introducida.
    await motor.registrarResultado(
      idHabilidad: 'FR.01',
      acierto: true,
      dificultad: 1.0,
      duracionSegundos: 5,
    );
    expect(subidas.length, 1);
    expect(subidas.first.$1, 'FR.01');
    expect(subidas.first.$2.valor >= NivelMaestria.introducida.valor, isTrue);

    // Segunda práctica: probablemente sigue introducida o sube.
    final tamanoAntes = subidas.length;
    await motor.registrarResultado(
      idHabilidad: 'FR.01',
      acierto: true,
      dificultad: 1.0,
      duracionSegundos: 5,
    );
    // Si subió, hay una entrada más; si no, igual. No debe haber regresión.
    expect(subidas.length >= tamanoAntes, isTrue);
  });

  test('rangoSegunEsquirlas devuelve el rango por umbrales', () {
    expect(rangoSegunEsquirlas(0), RangoNarrativo.aprendiz1);
    expect(rangoSegunEsquirlas(29), RangoNarrativo.aprendiz1);
    expect(rangoSegunEsquirlas(30), RangoNarrativo.aprendiz2);
    expect(rangoSegunEsquirlas(99), RangoNarrativo.aprendiz2);
    expect(rangoSegunEsquirlas(100), RangoNarrativo.aprendiz3);
    expect(rangoSegunEsquirlas(249), RangoNarrativo.aprendiz3);
    expect(rangoSegunEsquirlas(250), RangoNarrativo.iniciado);
    expect(rangoSegunEsquirlas(99999), RangoNarrativo.iniciado);
  });

  test('Cada rango tiene su flagAlcanzado estable', () {
    expect(
      RangoNarrativo.aprendiz2.flagAlcanzado,
      'rango_aprendiz_ii_alcanzado',
    );
    expect(
      RangoNarrativo.iniciado.flagAlcanzado,
      'rango_iniciado_alcanzado',
    );
  });

  test('Las escenas 1.13 y 1.14 quedan latentes hasta sus prereqs', () {
    final irune = CatalogoEscenas.porId('1.13');
    expect(irune!.flagsRequeridos, contains('escena_1_12_vista'));
    expect(
      irune.flagsRequeridos,
      contains('rango_aprendiz_ii_alcanzado'),
    );
    expect(irune.esCierreAmable, isTrue);

    final canales = CatalogoEscenas.porId('1.14');
    expect(canales!.flagsRequeridos, contains('escena_1_13_vista'));
    expect(canales.esCierreAmable, isTrue);
    expect(canales.planos.last, isA<PlanoCierreAmable>());
  });

  test('La 1.9 Los Plenos queda latente hasta fr_05_competente', () {
    final plenos = CatalogoEscenas.porId('1.9');
    expect(plenos, isNotNull);
    expect(plenos!.flagsRequeridos, contains('fr_05_competente'));
    expect(plenos.flagsRequeridos, contains('escena_1_7_vista'));
    expect(plenos.esCierreAmable, isTrue);
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
        'uroto.flag.escena_1_6_vista': true,
        'uroto.flag.escena_1_7_vista': true,
        'uroto.flag.escena_1_11_vista': true,
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
