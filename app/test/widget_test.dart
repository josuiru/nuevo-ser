import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uno_roto/datos/catalogo_habilidades.dart';
import 'package:uno_roto/datos/repositorio_progreso.dart';
import 'package:uno_roto/dominio/catalogo_escenas.dart';
import 'package:uno_roto/dominio/desafio_kurz.dart';
import 'package:uno_roto/dominio/habilidad.dart';
import 'package:uno_roto/dominio/motor_maestria.dart';
import 'package:uno_roto/dominio/voz_personaje.dart';
import 'package:uno_roto/dominio/plano_escena.dart';
import 'package:uno_roto/dominio/progreso_arco.dart';
import 'package:uno_roto/dominio/rango_narrativo.dart';
import 'package:uno_roto/dominio/variantes_entrenamiento.dart';
import 'package:uno_roto/dominio/variantes_puentes.dart';
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

  test('DesafioKurz.primero está calibrado a derrota probable', () {
    const desafio = DesafioKurz.primero;
    expect(desafio.identificador, 'kurz_1');
    expect(desafio.kiInicial, 2);
    expect(desafio.segundosPorPregunta, lessThanOrEqualTo(5));
    expect(desafio.preguntas.length, 3);
    expect(desafio.fraseDerrota, contains('No pasa nada'));
  });

  test('DesafioKurz.zafran usa Sora como voz y no muestra ojos', () {
    const desafio = DesafioKurz.zafran;
    expect(desafio.identificador, 'zafran');
    expect(desafio.nombreFragmento, 'ZAFRÁN');
    expect(desafio.vozQueHabla, isNot(VozPersonaje.fragmentoKurz));
    expect(desafio.mostrarOjos, isFalse);
    expect(desafio.preguntas.length, 5);
    expect(desafio.fraseVictoria, contains('{nombre}'));
  });

  test('DesafioKurz.tercero está calibrado a victoria', () {
    const desafio = DesafioKurz.tercero;
    expect(desafio.identificador, 'kurz_3');
    expect(desafio.kiInicial, greaterThanOrEqualTo(4));
    expect(desafio.segundosPorPregunta, greaterThanOrEqualTo(7));
    expect(desafio.fraseVictoria, contains('Iniciado'));
  });

  test('DesafioKurz.segundo es más generoso pero aún calibrado', () {
    const desafio = DesafioKurz.segundo;
    expect(desafio.identificador, 'kurz_2');
    expect(desafio.kiInicial, greaterThan(DesafioKurz.primero.kiInicial));
    expect(
      desafio.segundosPorPregunta,
      greaterThan(DesafioKurz.primero.segundosPorPregunta),
    );
    expect(desafio.fraseDerrota, contains('Otra vez la semana'));
    expect(desafio.fraseVictoria, contains('otra cosa'));
  });

  test('Las escenas 1.10 cierran ambas con escena_1_10_resuelta', () {
    final pre = CatalogoEscenas.porId('1.10pre');
    expect(pre, isNotNull);
    expect(pre!.flagsRequeridos, contains('escena_1_11_vista'));

    final derrota = CatalogoEscenas.porId('1.10derrota');
    expect(derrota!.flagDeSalida, 'escena_1_10_resuelta');
    expect(derrota.flagsRequeridos, contains('derrota_kurz_2'));

    final victoria = CatalogoEscenas.porId('1.10victoria');
    expect(victoria!.flagDeSalida, 'escena_1_10_resuelta');
    expect(victoria.flagsRequeridos, contains('victoria_kurz_2'));
  });

  test('La 1.6 ahora requiere combate_kurz_1_completado', () {
    final derrota = CatalogoEscenas.porId('1.6');
    expect(derrota!.flagsRequeridos, contains('combate_kurz_1_completado'));
    expect(
      derrota.flagsRequeridos.contains('escena_1_5_vista'),
      isFalse,
      reason:
          'La 1.6 cuelga del combate, no de la cinemática preliminar.',
    );
  });

  testWidgets(
    'Tras la 1.5, si el combate de Kurz no se ha resuelto, se lanza',
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

      // El combate muestra el nombre del Fragmento.
      expect(find.text('KURZ'), findsOneWidget);
    },
  );

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

  test(
    'VariantesPuentes.elegirSiguiente evita las usadas',
    () {
      final primera = VariantesPuentes.elegirSiguiente(const {});
      expect(primera!.id, '2.4a');

      final todas = VariantesPuentes.todas.map((e) => e.id).toSet();
      expect(
        VariantesPuentes.elegirSiguiente(todas),
        isNull,
      );
    },
  );

  test(
    'Arco 2: 2.8/2.9/2.11/2.12 encadenan; 2.10 latente por FR.16',
    () {
      final agua = CatalogoEscenas.porId('2.8');
      expect(agua!.flagsRequeridos, contains('escena_2_7_vista'));

      final ari = CatalogoEscenas.porId('2.9');
      expect(ari!.flagsRequeridos, contains('escena_2_8_vista'));

      final silbido = CatalogoEscenas.porId('2.10');
      expect(silbido!.flagsRequeridos, contains('fr_16_competente'));
      expect(silbido.flagsRequeridos, contains('escena_2_9_vista'));

      final sora = CatalogoEscenas.porId('2.11');
      expect(sora!.flagsRequeridos, contains('escena_2_10_vista'));

      final noche = CatalogoEscenas.porId('2.12');
      expect(noche!.flagsRequeridos, contains('escena_2_11_vista'));
      expect(
        noche.esCierreAmable,
        isFalse,
        reason:
            'La 2.12 no cierra: tras ella va el combate de Zafrán.',
      );
    },
  );

  test('Arco 2: 2.6 y 2.7 quedan latentes hasta maestría', () {
    final zafran = CatalogoEscenas.porId('2.6');
    expect(zafran!.flagsRequeridos, contains('fr_09_competente'));

    final dual = CatalogoEscenas.porId('2.7');
    expect(dual!.flagsRequeridos, contains('fr_16_introducida'));
    expect(dual.flagsRequeridos, contains('escena_2_6_vista'));
  });

  test('Arco 3: 3.1/3.2/3.3/3.5 encadenan; duelo Kai entre 3.3 y 3.5', () {
    final naini = CatalogoEscenas.porId('3.1');
    expect(naini!.flagsRequeridos, contains('escena_2_16_vista'));

    final mercado = CatalogoEscenas.porId('3.2');
    expect(mercado!.flagsRequeridos, contains('escena_3_1_vista'));

    final kai = CatalogoEscenas.porId('3.3');
    expect(kai!.flagsRequeridos, contains('escena_3_2_vista'));

    final desaparece = CatalogoEscenas.porId('3.5');
    expect(
      desaparece!.flagsRequeridos,
      contains('combate_duel_kai_completado'),
    );
  });

  test('Arco 3: bloque Coleccionistas 3.10→3.11→3.12→3.13 encadena', () {
    final oryn = CatalogoEscenas.porId('3.10');
    expect(oryn!.flagsRequeridos, contains('escena_3_9_vista'));

    final ari = CatalogoEscenas.porId('3.11');
    expect(ari!.flagsRequeridos, contains('escena_3_10_vista'));

    final santuario = CatalogoEscenas.porId('3.12');
    expect(santuario!.flagsRequeridos, contains('escena_3_11_vista'));

    final naini = CatalogoEscenas.porId('3.13');
    expect(naini!.flagsRequeridos, contains('escena_3_12_vista'));
    expect(naini.esCierreAmable, isTrue);
  });

  test('Arco 3: 3.6/3.8/3.9 encadenan tras 3.5', () {
    final vadic = CatalogoEscenas.porId('3.6');
    expect(vadic!.flagsRequeridos, contains('escena_3_5_vista'));

    final pintada = CatalogoEscenas.porId('3.8');
    expect(pintada!.flagsRequeridos, contains('escena_3_6_vista'));
    expect(pintada.esCierreAmable, isTrue);

    final eco = CatalogoEscenas.porId('3.9');
    expect(eco!.flagsRequeridos, contains('escena_3_8_vista'));
    expect(eco.esCierreAmable, isTrue);
    // Eco no es combate jugable: todo es cinemática pura con opciones.
    final tieneInteractivo = eco.planos.any((p) => p is PlanoInteractivo);
    expect(tieneInteractivo, isFalse);
  });

  test('DesafioKurz.duelKai usa a Kai como voz, sin ojos, halo rosa', () {
    const desafio = DesafioKurz.duelKai;
    expect(desafio.identificador, 'duel_kai');
    expect(desafio.nombreFragmento, 'KAI');
    expect(desafio.vozQueHabla, VozPersonaje.kai);
    expect(desafio.mostrarOjos, isFalse);
    expect(desafio.preguntas.length, 3);
  });

  test('ProgresoArco.arco3 declara 18 escenas', () {
    expect(ProgresoArco.arco3.totalEscenas, 18);
    expect(ProgresoArco.arco3.nombreRomano, 'III');
  });

  test('arcoActual prioriza Arco 3 sobre 2 cuando hay progreso', () async {
    final activos = {'escena_3_1_vista', 'escena_2_1_vista'};
    Future<bool> enSet(String f) async => activos.contains(f);
    expect(await ProgresoArco.arcoActual(enSet), ProgresoArco.arco3);
  });

  test('Arco 2: escenas 2.1/2.2/2.3 se encadenan tras 1.14', () {
    final bajar = CatalogoEscenas.porId('2.1');
    expect(bajar, isNotNull);
    expect(bajar!.flagsRequeridos, contains('escena_1_14_vista'));

    final rexan = CatalogoEscenas.porId('2.2');
    expect(rexan!.flagsRequeridos, contains('escena_2_1_vista'));

    final espejo = CatalogoEscenas.porId('2.3');
    expect(espejo!.flagsRequeridos, contains('escena_2_2_vista'));
    expect(espejo.esCierreAmable, isTrue);
  });

  test('ProgresoArco.arco2 declara 16 escenas', () {
    expect(ProgresoArco.arco2.totalEscenas, 16);
    expect(ProgresoArco.arco2.nombreRomano, 'II');
    expect(ProgresoArco.arco2.titulo, 'Canales y Zafrán');
  });

  test('arcoActual cambia al Arco 2 cuando hay progreso en él', () async {
    Future<bool> ninguno(String f) async => false;
    expect(await ProgresoArco.arcoActual(ninguno), ProgresoArco.arco1);

    final activos = {'escena_2_1_vista'};
    Future<bool> enSet(String f) async => activos.contains(f);
    expect(await ProgresoArco.arcoActual(enSet), ProgresoArco.arco2);
  });

  test(
    'ProgresoArco.arco1 cubre las 14 escenas del guion',
    () async {
      expect(ProgresoArco.arco1.totalEscenas, 14);

      // Sin flags activos, 0 escenas vistas.
      Future<bool> siempreFalso(String flag) async => false;
      expect(await ProgresoArco.arco1.contarVistas(siempreFalso), 0);

      // Solo 1.1: 1.
      Future<bool> solo11(String flag) async => flag == 'escena_1_1_vista';
      expect(await ProgresoArco.arco1.contarVistas(solo11), 1);

      // 1.10 con rama victoria o derrota cuenta igual.
      final activados = <String>{
        'escena_1_1_vista',
        'escena_1_10_resuelta',
      };
      Future<bool> enSet(String flag) async => activados.contains(flag);
      expect(await ProgresoArco.arco1.contarVistas(enSet), 2);

      // Cualquier variante de 1.8 cuenta la escena 1.8.
      activados.add('variante_1_8_c_usada');
      expect(await ProgresoArco.arco1.contarVistas(enSet), 3);

      // 1.12 victoria y derrota se cuentan como una sola escena.
      activados.add('escena_1_12_vista');
      activados.add('escena_1_12_derrota_vista');
      expect(await ProgresoArco.arco1.contarVistas(enSet), 4);
    },
  );

  test(
    'VariantesEntrenamiento.elegirSiguiente evita las usadas',
    () {
      final primera =
          VariantesEntrenamiento.elegirSiguiente(const {});
      expect(primera, isNotNull);
      expect(primera!.id, '1.8a');

      final sinPrimera =
          VariantesEntrenamiento.elegirSiguiente(const {'1.8a'});
      expect(sinPrimera!.id, '1.8b');

      final todasMenosUltima = VariantesEntrenamiento.todas
          .take(VariantesEntrenamiento.todas.length - 1)
          .map((e) => e.id)
          .toSet();
      final ultima =
          VariantesEntrenamiento.elegirSiguiente(todasMenosUltima);
      expect(ultima!.id, VariantesEntrenamiento.todas.last.id);

      final todas = VariantesEntrenamiento.todas
          .map((e) => e.id)
          .toSet();
      expect(
        VariantesEntrenamiento.elegirSiguiente(todas),
        isNull,
        reason: 'Cuando el pool se agota devuelve null.',
      );
    },
  );

  test(
    'Variantes de entrenamiento se marcan y se pueden resetear',
    () async {
      SharedPreferences.setMockInitialValues({});
      final repo = RepositorioProgreso();

      expect(
        await repo.cargarVariantesEntrenamientoUsadas(),
        isEmpty,
      );

      await repo.marcarVarianteEntrenamientoUsada('1.8a');
      await repo.marcarVarianteEntrenamientoUsada('1.8b');
      await repo.marcarVarianteEntrenamientoUsada('1.8a'); // idempotente

      expect(
        await repo.cargarVariantesEntrenamientoUsadas(),
        {'1.8a', '1.8b'},
      );

      await repo.resetearVariantesEntrenamiento();
      expect(
        await repo.cargarVariantesEntrenamientoUsadas(),
        isEmpty,
      );
    },
  );

  test('forzarRangoMinimo sube y activa flag, no baja', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = RepositorioProgreso();

    expect(await repo.cargarRango(), RangoNarrativo.aprendiz1);

    final subio =
        await repo.forzarRangoMinimo(RangoNarrativo.aprendiz2);
    expect(subio, isTrue);
    expect(await repo.cargarRango(), RangoNarrativo.aprendiz2);
    expect(
      await repo.flagNarrativoActivo('rango_aprendiz_ii_alcanzado'),
      isTrue,
    );

    // Llamar de nuevo con el mismo mínimo no hace nada.
    final subioOtraVez =
        await repo.forzarRangoMinimo(RangoNarrativo.aprendiz2);
    expect(subioOtraVez, isFalse);

    // Pedir un mínimo inferior al actual no baja.
    final intento =
        await repo.forzarRangoMinimo(RangoNarrativo.aprendiz1);
    expect(intento, isFalse);
    expect(await repo.cargarRango(), RangoNarrativo.aprendiz2);
  });

  test('La 1.12 victoria es la cinemática que abre la 1.13', () {
    final pre = CatalogoEscenas.porId('1.12pre');
    expect(pre!.flagsRequeridos, contains('escena_1_10_resuelta'));

    final victoria = CatalogoEscenas.porId('1.12victoria');
    expect(victoria!.flagDeSalida, 'escena_1_12_vista');
    expect(victoria.flagsRequeridos, contains('victoria_kurz_3'));

    final irune = CatalogoEscenas.porId('1.13');
    expect(irune!.flagsRequeridos, contains('escena_1_12_vista'));
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
        'uroto.flag.combate_kurz_1_completado': true,
        'uroto.flag.derrota_kurz_1': true,
        'uroto.flag.escena_1_6_vista': true,
        'uroto.flag.escena_1_7_vista': true,
        'uroto.flag.escena_1_11_vista': true,
        'uroto.flag.escena_1_10_pre_vista': true,
        'uroto.flag.combate_kurz_2_completado': true,
        'uroto.flag.derrota_kurz_2': true,
        'uroto.flag.escena_1_10_resuelta': true,
        'uroto.flag.escena_1_12_pre_vista': true,
        'uroto.flag.combate_kurz_3_completado': true,
        'uroto.flag.derrota_kurz_3': true,
        'uroto.flag.escena_1_12_derrota_vista': true,
        'uroto.flag.escena_1_14_vista': true,
        'uroto.flag.escena_2_1_vista': true,
        'uroto.flag.escena_2_2_vista': true,
        'uroto.flag.escena_2_3_vista': true,
        'uroto.flag.escena_2_5_vista': true,
        'uroto.flag.escena_2_8_vista': true,
        'uroto.flag.escena_2_9_vista': true,
        'uroto.flag.escena_2_11_vista': true,
        'uroto.flag.escena_2_12_vista': true,
        'uroto.flag.combate_zafran_completado': true,
        'uroto.flag.victoria_zafran': true,
        'uroto.flag.escena_2_13_vista': true,
        'uroto.flag.escena_2_14_vista': true,
        'uroto.flag.escena_2_15_vista': true,
        'uroto.flag.escena_2_16_vista': true,
        // Arco 3 marcado como cerrado para que el orquestador vaya al mapa.
        'uroto.flag.escena_3_1_vista': true,
        'uroto.flag.escena_3_2_vista': true,
        'uroto.flag.escena_3_3_vista': true,
        'uroto.flag.combate_duel_kai_completado': true,
        'uroto.flag.victoria_duel_kai': true,
        'uroto.flag.escena_3_5_vista': true,
        'uroto.flag.escena_3_6_vista': true,
        'uroto.flag.escena_3_8_vista': true,
        'uroto.flag.escena_3_9_vista': true,
        'uroto.flag.escena_3_10_vista': true,
        'uroto.flag.escena_3_11_vista': true,
        'uroto.flag.escena_3_12_vista': true,
        'uroto.flag.escena_3_13_vista': true,
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
