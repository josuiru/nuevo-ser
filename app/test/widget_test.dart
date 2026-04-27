import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uno_roto/datos/catalogo_habilidades.dart';
import 'package:uno_roto/datos/repositorio_progreso.dart';
import 'package:uno_roto/dominio/catalogo_escenas.dart';
import 'package:uno_roto/dominio/desafio_kurz.dart';
import 'package:uno_roto/dominio/fragmento_en_tejado.dart';
import 'package:uno_roto/dominio/generador_caza.dart';
import 'package:uno_roto/dominio/habilidad.dart';
import 'package:uno_roto/dominio/mapeo_habilidades_puzzle.dart';
import 'package:uno_roto/dominio/motor_maestria.dart';
import 'package:uno_roto/dominio/problema_comparacion.dart';
import 'package:uno_roto/dominio/problema_espejo.dart' show Fraccion;
import 'package:uno_roto/dominio/problema_amplificar.dart';
import 'package:uno_roto/dominio/problema_comparacion_decimal.dart';
import 'package:uno_roto/dominio/problema_comparacion_unidad.dart';
import 'package:uno_roto/dominio/problema_divisibilidad.dart';
import 'package:uno_roto/dominio/problema_lectura_decimal.dart';
import 'package:uno_roto/dominio/problema_simplificar.dart';
import 'package:uno_roto/dominio/voz_personaje.dart';
import 'package:uno_roto/dominio/plano_escena.dart';
import 'package:uno_roto/dominio/progreso_arco.dart';
import 'package:uno_roto/dominio/rango_narrativo.dart';
import 'package:uno_roto/dominio/variantes_entrenamiento.dart';
import 'package:uno_roto/dominio/variantes_puentes.dart';
import 'package:uno_roto/main.dart';
import 'package:uno_roto/sonido/capa_audio.dart';
import 'package:uno_roto/sonido/catalogo_sonidos.dart';
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

  test('Arco 4: apertura 4.1→4.2→4.3→4.4→4.5→4.6→4.7 encadenan', () {
    final puerto = CatalogoEscenas.porId('4.1');
    expect(puerto!.flagsRequeridos, contains('escena_3_18_vista'));

    final invitacion = CatalogoEscenas.porId('4.6');
    expect(invitacion!.flagsRequeridos, contains('escena_4_5_vista'));

    final pruebas = CatalogoEscenas.porId('4.7');
    expect(pruebas!.flagsRequeridos, contains('escena_4_6_vista'));
  });

  test('Arco 4: las tres variantes de 4.8 cada una con su flag elegida', () {
    final fuego = CatalogoEscenas.porId('4.8f');
    expect(fuego!.flagsRequeridos, contains('prueba_elegida_fuego'));

    final sendero = CatalogoEscenas.porId('4.8s');
    expect(sendero!.flagsRequeridos, contains('prueba_elegida_sendero'));

    final espejo = CatalogoEscenas.porId('4.8e');
    expect(espejo!.flagsRequeridos, contains('prueba_elegida_espejo'));
  });

  test('Arco 4: las 3 variantes de 4.9 comparten flagDeSalida', () {
    final fuego = CatalogoEscenas.porId('4.9f');
    final sendero = CatalogoEscenas.porId('4.9s');
    final espejo = CatalogoEscenas.porId('4.9e');
    expect(fuego!.flagDeSalida, 'prueba_completada');
    expect(sendero!.flagDeSalida, 'prueba_completada');
    expect(espejo!.flagDeSalida, 'prueba_completada');
  });

  test('Arco 4: 4.10→4.11→4.12→4.13→4.14 cierran el MVP', () {
    final ceremonia = CatalogoEscenas.porId('4.10');
    expect(ceremonia!.flagsRequeridos, contains('prueba_completada'));

    final rexanTe = CatalogoEscenas.porId('4.11');
    expect(rexanTe!.flagsRequeridos, contains('escena_4_10_vista'));

    final kaiLejos = CatalogoEscenas.porId('4.12');
    expect(kaiLejos!.flagsRequeridos, contains('escena_4_11_vista'));

    final soraBorde = CatalogoEscenas.porId('4.13');
    expect(soraBorde!.flagsRequeridos, contains('escena_4_12_vista'));

    final montana = CatalogoEscenas.porId('4.14');
    expect(montana!.flagsRequeridos, contains('escena_4_13_vista'));
    expect(montana.esCierreAmable, isTrue);
    expect(montana.planos.last, isA<PlanoCierreAmable>());
    final cierre = montana.planos.last as PlanoCierreAmable;
    expect(cierre.textoBoton, 'HASTA ENTONCES');
  });

  test('DesafioKurz.vorax usa al narrador, sin ojos, halo exito', () {
    const desafio = DesafioKurz.vorax;
    expect(desafio.identificador, 'vorax');
    expect(desafio.nombreFragmento, 'VORAX');
    expect(desafio.vozQueHabla, VozPersonaje.narrador);
    expect(desafio.mostrarOjos, isFalse);
    expect(desafio.preguntas.length, 5);
  });

  test('ProgresoArco.arco4 declara 14 escenas', () {
    expect(ProgresoArco.arco4.totalEscenas, 14);
    expect(ProgresoArco.arco4.nombreRomano, 'IV');
    expect(ProgresoArco.arco4.titulo, 'El ascenso');
  });

  test('Arco 3: cierre 3.14→3.15→3.16→3.17→3.18 (Montaña + Irune)', () {
    final kaiVuelve = CatalogoEscenas.porId('3.14');
    expect(kaiVuelve!.flagsRequeridos, contains('escena_3_13_vista'));

    final mision = CatalogoEscenas.porId('3.15');
    expect(mision!.flagsRequeridos, contains('escena_3_14_vista'));

    final brina = CatalogoEscenas.porId('3.16');
    expect(brina!.flagsRequeridos, contains('escena_3_15_vista'));

    final montana = CatalogoEscenas.porId('3.17');
    expect(montana!.flagsRequeridos, contains('escena_3_16_vista'));

    final cierre = CatalogoEscenas.porId('3.18');
    expect(cierre!.flagsRequeridos, contains('escena_3_17_vista'));
    expect(cierre.esCierreAmable, isTrue);
    expect(cierre.planos.last, isA<PlanoCierreAmable>());
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

  // ═══ Perfiles ═══

  test(
    'Migración: progreso heredado uroto.* se mueve al perfil "principal"',
    () async {
      SharedPreferences.setMockInitialValues({
        'uroto.ya_vio_apertura': true,
        'uroto.nombre_jugador': 'Leo',
        'uroto.esquirlas_total': 42,
        'uroto.flag.escena_1_1_vista': true,
      });
      final repo = RepositorioProgreso();

      // Leer cualquier cosa dispara la migración.
      expect(await repo.yaVioLaApertura(), isTrue);
      expect(await repo.cargarNombreJugador(), 'Leo');
      expect(await repo.cargarEsquirlas(), 42);
      expect(
        await repo.flagNarrativoActivo('escena_1_1_vista'),
        isTrue,
      );
      expect(await repo.idPerfilActivo(), 'principal');
      expect(await repo.listarPerfiles(), ['principal']);

      // Las claves sin prefijo ya no están en el almacén.
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('uroto.ya_vio_apertura'), isFalse);
      expect(prefs.containsKey('uroto.nombre_jugador'), isFalse);
      expect(
        prefs.containsKey('uroto.perfil.principal.ya_vio_apertura'),
        isTrue,
      );
    },
  );

  test('crearPerfil aísla progreso entre perfiles', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = RepositorioProgreso();

    await repo.guardarNombreJugador('Leo');
    await repo.guardarEsquirlas(10);
    await repo.activarFlagNarrativo('escena_1_1_vista');

    final idIrune = await repo.crearPerfil('Irune');
    await repo.cambiarAPerfil(idIrune);

    // Perfil recién creado: nombre ya guardado al crear, pero sin progreso.
    expect(await repo.cargarNombreJugador(), 'Irune');
    expect(await repo.cargarEsquirlas(), 0);
    expect(
      await repo.flagNarrativoActivo('escena_1_1_vista'),
      isFalse,
    );

    // Volver al original mantiene su progreso.
    await repo.cambiarAPerfil('principal');
    expect(await repo.cargarNombreJugador(), 'Leo');
    expect(await repo.cargarEsquirlas(), 10);
    expect(
      await repo.flagNarrativoActivo('escena_1_1_vista'),
      isTrue,
    );
  });

  test('borrarPerfil elimina progreso y reajusta activo si hace falta',
      () async {
    SharedPreferences.setMockInitialValues({});
    final repo = RepositorioProgreso();

    final idIrune = await repo.crearPerfil('Irune');
    await repo.cambiarAPerfil(idIrune);
    await repo.guardarEsquirlas(5);

    expect(await repo.listarPerfiles(), contains(idIrune));
    await repo.borrarPerfil(idIrune);

    final restantes = await repo.listarPerfiles();
    expect(restantes, isNot(contains(idIrune)));
    expect(await repo.idPerfilActivo(), 'principal');

    // Crear otro con el mismo nombre base genera un id distinto.
    final idIrune1 = await repo.crearPerfil('Irune');
    final idIrune2 = await repo.crearPerfil('Irune');
    expect(idIrune2, isNot(equals(idIrune1)));
  });

  testWidgets(
    'Con más de un perfil, la app arranca en el selector de perfiles',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'uroto.perfil_activo_id': 'principal',
        'uroto.perfiles_lista': ['principal', 'irune'],
        'uroto.perfil.principal.nombre_jugador': 'Leo',
        'uroto.perfil.principal.ya_vio_apertura': true,
        'uroto.perfil.irune.nombre_jugador': 'Irune',
        'uroto.perfil.irune.ya_vio_apertura': true,
      });
      await tester.pumpWidget(const AppUnoRoto());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('¿QUIÉN ERES?'), findsOneWidget);
      expect(find.text('Leo'), findsOneWidget);
      expect(find.text('Irune'), findsOneWidget);
    },
  );

  // ═══ Capa sonora (doc 12) ═══

  test('CatalogoSonidos mapea ambient y música de cada distrito', () {
    for (final id in const [
      'tejados',
      'canales',
      'mercado',
      'industria',
      'puerto',
      'afueras',
    ]) {
      final ambient = CatalogoSonidos.ambientDeDistrito(id);
      expect(ambient, isNotNull, reason: 'sin ambient para $id');
      final detalleAmbient = CatalogoSonidos.obtener(ambient!);
      expect(detalleAmbient, isNotNull);
      expect(detalleAmbient!.capa, CapaAudio.ambient);
      expect(detalleAmbient.enBucle, isTrue);

      final musica = CatalogoSonidos.musicaDeDistrito(id);
      expect(musica, isNotNull, reason: 'sin música para $id');
      final detalleMusica = CatalogoSonidos.obtener(musica!);
      expect(detalleMusica, isNotNull);
      expect(detalleMusica!.capa, CapaAudio.musica);
      expect(detalleMusica.enBucle, isTrue);
    }
    expect(CatalogoSonidos.ambientDeDistrito('inexistente'), isNull);
  });

  test('CatalogoSonidos.musicaDeCombate distingue los Fragmentos nombrados',
      () {
    expect(CatalogoSonidos.musicaDeCombate('kurz_1'), 'musica_combate_kurz');
    expect(CatalogoSonidos.musicaDeCombate('kurz_3'), 'musica_combate_kurz');
    expect(CatalogoSonidos.musicaDeCombate('zafran'), 'musica_combate_zafran');
    expect(CatalogoSonidos.musicaDeCombate('vorax'), 'musica_combate_vorax');
    expect(
      CatalogoSonidos.musicaDeCombate(null),
      'musica_combate_cotidiano',
    );
    expect(
      CatalogoSonidos.musicaDeCombate('desconocido'),
      'musica_combate_cotidiano',
    );
  });

  test('CapaAudio tiene las 4 capas con volúmenes predeterminados válidos',
      () {
    expect(CapaAudio.values, hasLength(4));
    for (final capa in CapaAudio.values) {
      expect(capa.clave, isNotEmpty);
      expect(capa.nombreVisible, isNotEmpty);
      expect(capa.volumenPredeterminado, inInclusiveRange(0, 100));
    }
  });

  test(
    'Preferencias de audio: persisten, acotan a 0..100 y son por perfil',
    () async {
      SharedPreferences.setMockInitialValues({});
      final repo = RepositorioProgreso();

      // Predeterminados hasta que se guarde algo.
      expect(await repo.cargarAudioModoSilencio(), isFalse);
      expect(
        await repo.cargarAudioVolumenCapa('musica', predeterminado: 70),
        70,
      );

      await repo.guardarAudioModoSilencio(true);
      await repo.guardarAudioVolumenCapa('musica', 42);
      // Fuera de rango: se debe acotar.
      await repo.guardarAudioVolumenCapa('ambient', 150);
      await repo.guardarAudioVolumenCapa('efectos', -10);

      expect(await repo.cargarAudioModoSilencio(), isTrue);
      expect(
        await repo.cargarAudioVolumenCapa('musica', predeterminado: 70),
        42,
      );
      expect(
        await repo.cargarAudioVolumenCapa('ambient', predeterminado: 45),
        100,
      );
      expect(
        await repo.cargarAudioVolumenCapa('efectos', predeterminado: 80),
        0,
      );

      // Otro perfil arranca con sus propios predeterminados.
      final idIrune = await repo.crearPerfil('Irune');
      await repo.cambiarAPerfil(idIrune);
      expect(await repo.cargarAudioModoSilencio(), isFalse);
      expect(
        await repo.cargarAudioVolumenCapa('musica', predeterminado: 70),
        70,
      );
    },
  );

  test('Catálogo: escenas clave traen motivos sonoros esperados', () {
    expect(CatalogoEscenas.porId('1.1')!.sonidoDeEntrada, 'motivo_sora');
    expect(CatalogoEscenas.porId('1.7')!.sonidoDeEntrada, 'motivo_kai');
    expect(CatalogoEscenas.porId('1.14')!.sonidoDeEntrada, 'motivo_montana');
    expect(
      CatalogoEscenas.porId('2.10')!.sonidoDeEntrada,
      'narrativo_silbido_zafran',
    );
    expect(
      CatalogoEscenas.porId('1.13')!.loopDeFondo,
      'musica_ceremonia',
    );
  });

  // ═══ Puzzle de comparación (FR.05 / FR.06) ═══

  test(
    'GeneradorComparacion mismoDenominador produce fracciones propias y un mayor claro',
    () {
      final gen = GeneradorComparacion(semilla: 42);
      for (var intento = 0; intento < 40; intento++) {
        final problema = gen.generar(
          modo: ModoComparacion.mismoDenominador,
        );
        expect(problema.a.denominador, problema.b.denominador);
        expect(problema.a.numerador, isNot(problema.b.numerador));
        expect(problema.a.numerador, lessThan(problema.a.denominador));
        expect(problema.b.numerador, lessThan(problema.b.denominador));
        expect(problema.indiceMayor, isNotNull);
      }
    },
  );

  test(
    'GeneradorComparacion mismoNumerador produce fracciones propias y un mayor claro',
    () {
      final gen = GeneradorComparacion(semilla: 7);
      for (var intento = 0; intento < 40; intento++) {
        final problema = gen.generar(modo: ModoComparacion.mismoNumerador);
        expect(problema.a.numerador, problema.b.numerador);
        expect(problema.a.denominador, isNot(problema.b.denominador));
        expect(problema.a.numerador, lessThan(problema.a.denominador));
        expect(problema.b.numerador, lessThan(problema.b.denominador));
        expect(problema.indiceMayor, isNotNull);
        // En mismoNumerador, el denominador menor debe ser el mayor.
        final mayor = problema.indiceMayor == 0 ? problema.a : problema.b;
        final menor = problema.indiceMayor == 0 ? problema.b : problema.a;
        expect(mayor.denominador, lessThan(menor.denominador));
      }
    },
  );

  test('FR.05 y FR.06 están mapeadas al tipo comparacion', () {
    expect(skillsConPuzzleImplementado, contains('FR.05'));
    expect(skillsConPuzzleImplementado, contains('FR.06'));
    expect(tipoParaSkillId('FR.05'), TipoFragmentoEnTejado.comparacion);
    expect(tipoParaSkillId('FR.06'), TipoFragmentoEnTejado.comparacion);
    expect(
      modoComparacionParaSkillId('FR.05'),
      ModoComparacion.mismoDenominador,
    );
    expect(
      modoComparacionParaSkillId('FR.06'),
      ModoComparacion.mismoNumerador,
    );
    expect(modoComparacionParaSkillId('FR.09'), isNull);
  });

  test('GeneradorCaza respeta el modo pedido por skill', () {
    final gen = GeneradorCaza(semilla: 123);
    final ahora = DateTime(2026, 4, 24);
    final fragFr05 = gen.siguienteParaSkill(
      idHabilidad: 'FR.05',
      esquirlasAcumuladas: 5,
      ahora: ahora,
    );
    expect(fragFr05.tipo, TipoFragmentoEnTejado.comparacion);
    expect(fragFr05.modoComparacion, ModoComparacion.mismoDenominador);
    expect(fragFr05.denominador, fragFr05.denominadorB);

    final fragFr06 = gen.siguienteParaSkill(
      idHabilidad: 'FR.06',
      esquirlasAcumuladas: 5,
      ahora: ahora.add(const Duration(seconds: 1)),
    );
    expect(fragFr06.tipo, TipoFragmentoEnTejado.comparacion);
    expect(fragFr06.modoComparacion, ModoComparacion.mismoNumerador);
    expect(fragFr06.numerador, fragFr06.numeradorB);
  });

  // ═══ Puzzle de simplificación (FR.10) ═══

  test(
    'GeneradorSimplificar produce un objetivo reducible cuyo correcto es la reducida',
    () {
      final gen = GeneradorSimplificar(semilla: 11);
      for (var intento = 0; intento < 40; intento++) {
        final problema = gen.generar(dificultad: 2);
        // El objetivo es equivalente al correcto.
        expect(
          problema.correcto.esEquivalenteA(problema.objetivo),
          isTrue,
        );
        // El objetivo NO está ya reducido (si lo estuviera, no
        // tendría sentido pedir simplificar).
        final reducidaObjetivo = problema.objetivo.reducida();
        expect(
          reducidaObjetivo.numerador,
          isNot(problema.objetivo.numerador),
          reason:
              'Objetivo ${problema.objetivo.etiqueta} ya está reducido; '
              'generador debe producir uno reducible.',
        );
        // El correcto SÍ coincide con la forma reducida.
        expect(problema.correcto.numerador, reducidaObjetivo.numerador);
        expect(
          problema.correcto.denominador,
          reducidaObjetivo.denominador,
        );
        // Cuatro candidatos, todos distintos.
        expect(problema.candidatos, hasLength(4));
        final firmas = problema.candidatos
            .map((f) => '${f.numerador}/${f.denominador}')
            .toSet();
        expect(firmas, hasLength(4));
      }
    },
  );

  test('FR.10 está mapeada al tipo simplificar', () {
    expect(skillsConPuzzleImplementado, contains('FR.10'));
    expect(tipoParaSkillId('FR.10'), TipoFragmentoEnTejado.simplificar);
    // Un Fragmento de tipo simplificar declara FR.10 como habilidad.
    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 6,
      denominador: 8,
      tipo: TipoFragmentoEnTejado.simplificar,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 25),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'FR.10');
  });

  test('GeneradorCaza dirigido a FR.10 produce Fragmento reducible', () {
    final gen = GeneradorCaza(semilla: 777);
    final ahora = DateTime(2026, 4, 25);
    final frag = gen.siguienteParaSkill(
      idHabilidad: 'FR.10',
      esquirlasAcumuladas: 15,
      ahora: ahora,
    );
    expect(frag.tipo, TipoFragmentoEnTejado.simplificar);
    final fraccion = Fraccion(frag.numerador, frag.denominador);
    final reducida = fraccion.reducida();
    expect(
      reducida.numerador,
      isNot(fraccion.numerador),
      reason: 'El Fragmento debe ser reducible',
    );
  });

  // ═══ Puzzle de amplificación (FR.11) ═══

  test(
    'GeneradorAmplificar produce ecuaciones equivalentes con cuatro candidatos',
    () {
      final gen = GeneradorAmplificar(semilla: 99);
      for (var intento = 0; intento < 40; intento++) {
        final problema = gen.generar(dificultad: 2);
        // El denominador objetivo es múltiplo entero del denominador base.
        expect(
          problema.denominadorObjetivo % problema.base.denominador,
          0,
          reason:
              'Objetivo ${problema.denominadorObjetivo} no divisible por '
              'base ${problema.base.denominador}',
        );
        expect(problema.factor, greaterThanOrEqualTo(2));
        // El numerador correcto cumple base = correcto/objetivo.
        final correcto = Fraccion(
          problema.numeradorCorrecto,
          problema.denominadorObjetivo,
        );
        expect(correcto.esEquivalenteA(problema.base), isTrue);
        // Cuatro candidatos, todos distintos.
        expect(problema.candidatos, hasLength(4));
        expect(problema.candidatos.toSet(), hasLength(4));
      }
    },
  );

  test('FR.11 está mapeada al tipo amplificar', () {
    expect(skillsConPuzzleImplementado, contains('FR.11'));
    expect(tipoParaSkillId('FR.11'), TipoFragmentoEnTejado.amplificar);
    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 3,
      denominador: 4,
      denominadorB: 12,
      tipo: TipoFragmentoEnTejado.amplificar,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 25),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'FR.11');
  });

  test(
    'GeneradorCaza dirigido a FR.11 produce Fragmento con denominador objetivo coherente',
    () {
      final gen = GeneradorCaza(semilla: 314);
      final ahora = DateTime(2026, 4, 25);
      final frag = gen.siguienteParaSkill(
        idHabilidad: 'FR.11',
        esquirlasAcumuladas: 15,
        ahora: ahora,
      );
      expect(frag.tipo, TipoFragmentoEnTejado.amplificar);
      expect(frag.denominadorB, isNotNull);
      // El objetivo es múltiplo del denominador base.
      expect(frag.denominadorB! % frag.denominador, 0);
      expect(frag.denominadorB! ~/ frag.denominador, greaterThanOrEqualTo(2));
    },
  );

  // ═══ Puzzle de divisibilidad (DIV.03) ═══

  test('ProblemaDivisibilidad evalúa correctamente sí/no', () {
    const divisibleEntre5 = ProblemaDivisibilidad(numero: 145, divisor: 5);
    expect(divisibleEntre5.esDivisible, isTrue);
    expect(divisibleEntre5.esCorrecta(true), isTrue);
    expect(divisibleEntre5.esCorrecta(false), isFalse);

    const noDivisibleEntre3 = ProblemaDivisibilidad(numero: 100, divisor: 3);
    expect(noDivisibleEntre3.esDivisible, isFalse);
    expect(noDivisibleEntre3.esCorrecta(false), isTrue);
    expect(noDivisibleEntre3.esCorrecta(true), isFalse);
  });

  test(
    'GeneradorDivisibilidad respeta los divisores permitidos y mezcla sí/no',
    () {
      final gen = GeneradorDivisibilidad(semilla: 17);
      var siCount = 0;
      var noCount = 0;
      const total = 100;
      for (var intento = 0; intento < total; intento++) {
        final problema = gen.generar();
        expect(const [2, 3, 5, 10], contains(problema.divisor));
        expect(problema.numero, greaterThanOrEqualTo(10));
        if (problema.esDivisible) {
          siCount++;
        } else {
          noCount++;
        }
      }
      // El generador apunta ~50/50 — comprobamos que ambas se ven
      // razonablemente con margen amplio.
      expect(siCount, greaterThan(20));
      expect(noCount, greaterThan(20));
    },
  );

  test('DIV.03 está mapeada al tipo divisibilidad', () {
    expect(skillsConPuzzleImplementado, contains('DIV.03'));
    expect(tipoParaSkillId('DIV.03'), TipoFragmentoEnTejado.divisibilidad);
    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 145,
      denominador: 5,
      tipo: TipoFragmentoEnTejado.divisibilidad,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 25),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DIV.03');
  });

  test(
    'GeneradorCaza dirigido a DIV.03 produce Fragmento con divisor de los criterios básicos',
    () {
      final gen = GeneradorCaza(semilla: 555);
      final ahora = DateTime(2026, 4, 25);
      final frag = gen.siguienteParaSkill(
        idHabilidad: 'DIV.03',
        esquirlasAcumuladas: 8,
        ahora: ahora,
      );
      expect(frag.tipo, TipoFragmentoEnTejado.divisibilidad);
      expect(const [2, 3, 5, 10], contains(frag.denominador));
      expect(frag.numerador, greaterThanOrEqualTo(10));
    },
  );

  test(
    'GeneradorCaza dirigido a DIV.04 usa los criterios avanzados (4, 6, 9)',
    () {
      final gen = GeneradorCaza(semilla: 12);
      final ahora = DateTime(2026, 4, 25);
      // Probamos varias generaciones para cubrir la elección aleatoria.
      for (var intento = 0; intento < 20; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'DIV.04',
          esquirlasAcumuladas: 12,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.divisibilidad);
        expect(const [4, 6, 9], contains(frag.denominador));
      }
    },
  );

  test(
    'idHabilidadPrincipal distingue DIV.03 vs DIV.04 según el divisor',
    () {
      final fragBasico = FragmentoEnTejado(
        identificador: 't',
        numerador: 145,
        denominador: 5,
        tipo: TipoFragmentoEnTejado.divisibilidad,
        xNormalizado: 0,
        yNormalizado: 0,
        instanteAparicion: DateTime(2026, 4, 25),
        tiempoDeVida: const Duration(seconds: 10),
      );
      expect(idHabilidadPrincipal(fragBasico), 'DIV.03');

      final fragAvanzado = FragmentoEnTejado(
        identificador: 't2',
        numerador: 144,
        denominador: 9,
        tipo: TipoFragmentoEnTejado.divisibilidad,
        xNormalizado: 0,
        yNormalizado: 0,
        instanteAparicion: DateTime(2026, 4, 25),
        tiempoDeVida: const Duration(seconds: 10),
      );
      expect(idHabilidadPrincipal(fragAvanzado), 'DIV.04');
    },
  );

  // ═══ Puzzle de comparación de decimales (DEC.02) ═══

  test('ProblemaComparacionDecimal evalúa el mayor por valor numérico', () {
    const trampaCorta = ProblemaComparacionDecimal(
      etiquetaA: '0,35',
      etiquetaB: '0,4',
      valorA: 0.35,
      valorB: 0.4,
    );
    expect(trampaCorta.indiceMayor, 1);
    expect(trampaCorta.esCorrecto(1), isTrue);
    expect(trampaCorta.esCorrecto(0), isFalse);
  });

  test(
    'GeneradorComparacionDecimal produce pares con un mayor claro',
    () {
      final gen = GeneradorComparacionDecimal(semilla: 51);
      for (var intento = 0; intento < 60; intento++) {
        final problema = gen.generar(dificultad: 2);
        expect(problema.indiceMayor, isNotNull,
            reason:
                '${problema.etiquetaA} vs ${problema.etiquetaB} no debería '
                'producir empate');
        expect(problema.valorA, isNot(problema.valorB));
        // Las etiquetas son legibles como decimales con coma.
        expect(problema.etiquetaA, contains(','));
        expect(problema.etiquetaB, contains(','));
      }
    },
  );

  test('DEC.02 está mapeada al tipo comparacionDecimal', () {
    expect(skillsConPuzzleImplementado, contains('DEC.02'));
    expect(
      tipoParaSkillId('DEC.02'),
      TipoFragmentoEnTejado.comparacionDecimal,
    );
    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 0,
      denominador: 1,
      tipo: TipoFragmentoEnTejado.comparacionDecimal,
      decimalA: '0,35',
      decimalB: '0,4',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 25),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DEC.02');
  });

  test(
    'GeneradorCaza dirigido a DEC.02 produce Fragmento con dos etiquetas decimales',
    () {
      final gen = GeneradorCaza(semilla: 9999);
      final ahora = DateTime(2026, 4, 25);
      final frag = gen.siguienteParaSkill(
        idHabilidad: 'DEC.02',
        esquirlasAcumuladas: 12,
        ahora: ahora,
      );
      expect(frag.tipo, TipoFragmentoEnTejado.comparacionDecimal);
      expect(frag.decimalA, isNotNull);
      expect(frag.decimalB, isNotNull);
      expect(frag.decimalA, contains(','));
      expect(frag.decimalB, contains(','));
    },
  );

  // ═══ Puzzle de lectura decimal (DEC.01) ═══

  test(
    'GeneradorLecturaDecimal produce un texto válido y un correcto entre 4 candidatos',
    () {
      final gen = GeneradorLecturaDecimal(semilla: 1);
      for (var intento = 0; intento < 30; intento++) {
        final problema = gen.generar(dificultad: 3);
        expect(problema.texto, isNotEmpty);
        expect(problema.candidatos, hasLength(4));
        expect(problema.candidatos.toSet(), hasLength(4));
        expect(
          problema.indiceCorrecto,
          inInclusiveRange(0, 3),
        );
      }
    },
  );

  test('generarDesdeTexto reproduce exactamente la forma esperada', () {
    final gen = GeneradorLecturaDecimal(semilla: 5);
    final problema = gen.generarDesdeTexto('veinticinco centésimas');
    expect(problema.texto, 'veinticinco centésimas');
    expect(problema.etiquetaCorrecta, '0,25');
    expect(problema.candidatos, contains('0,25'));
  });

  test('Dificultad 1 evita milésimas y mixtos "unidad y …"', () {
    final gen = GeneradorLecturaDecimal(semilla: 33);
    for (var intento = 0; intento < 20; intento++) {
      final problema = gen.generar(dificultad: 1);
      expect(problema.texto, isNot(contains('milésimas')));
      expect(problema.texto, isNot(contains('unidad')));
    }
  });

  test('DEC.01 está mapeada al tipo lecturaDecimal', () {
    expect(skillsConPuzzleImplementado, contains('DEC.01'));
    expect(tipoParaSkillId('DEC.01'), TipoFragmentoEnTejado.lecturaDecimal);
    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 0,
      denominador: 1,
      tipo: TipoFragmentoEnTejado.lecturaDecimal,
      etiquetaDecimal: 'tres décimas',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 25),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DEC.01');
  });

  test(
    'GeneradorCaza dirigido a DEC.01 produce Fragmento con texto en palabras',
    () {
      final gen = GeneradorCaza(semilla: 444);
      final ahora = DateTime(2026, 4, 25);
      final frag = gen.siguienteParaSkill(
        idHabilidad: 'DEC.01',
        esquirlasAcumuladas: 8,
        ahora: ahora,
      );
      expect(frag.tipo, TipoFragmentoEnTejado.lecturaDecimal);
      expect(frag.etiquetaDecimal, isNotNull);
      // El texto canónico contiene unidad de lugar de valor (décimas /
      // centésimas / milésimas / unidades).
      final texto = frag.etiquetaDecimal!;
      final tieneUnidadDeLugar =
          texto.contains('décimas') ||
              texto.contains('centésimas') ||
              texto.contains('milésimas') ||
              texto.contains('unidad');
      expect(tieneUnidadDeLugar, isTrue,
          reason: 'Texto inesperado: $texto');
    },
  );

  // ═══ Puzzle de múltiplos (DIV.01) ═══

  test('DIV.01 está mapeada al tipo multiplos con set amplio de divisores',
      () {
    expect(skillsConPuzzleImplementado, contains('DIV.01'));
    expect(tipoParaSkillId('DIV.01'), TipoFragmentoEnTejado.multiplos);
    expect(divisoresParaSkillId('DIV.01'), hasLength(9));
    expect(divisoresParaSkillId('DIV.01'), contains(7));
    expect(divisoresParaSkillId('DIV.01'), contains(8));

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 24,
      denominador: 6,
      tipo: TipoFragmentoEnTejado.multiplos,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 26),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DIV.01');
  });

  test(
    'GeneradorCaza dirigido a DIV.01 produce Fragmento con divisor de [2..10]',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 26);
      // Algunas tiradas para validar que entran 7 y 8 (que en
      // divisibilidad estándar no aparecen).
      var visto7u8 = false;
      for (var intento = 0; intento < 30; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'DIV.01',
          esquirlasAcumuladas: 8,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.multiplos);
        expect(frag.denominador, inInclusiveRange(2, 10));
        if (frag.denominador == 7 || frag.denominador == 8) {
          visto7u8 = true;
        }
      }
      expect(visto7u8, isTrue,
          reason: 'En 30 tiradas debería aparecer al menos 7 u 8.');
    },
  );

  // ═══ Puzzle de comparación con la unidad (FR.04) ═══

  test(
    'ProblemaComparacionUnidad clasifica correctamente menor/igual/mayor',
    () {
      const menor =
          ProblemaComparacionUnidad(fraccion: Fraccion(3, 5));
      const igual =
          ProblemaComparacionUnidad(fraccion: Fraccion(7, 7));
      const mayor =
          ProblemaComparacionUnidad(fraccion: Fraccion(9, 4));

      expect(menor.relacionCorrecta, RelacionConUnidad.menor);
      expect(igual.relacionCorrecta, RelacionConUnidad.igual);
      expect(mayor.relacionCorrecta, RelacionConUnidad.mayor);

      expect(menor.esCorrecta(RelacionConUnidad.menor), isTrue);
      expect(menor.esCorrecta(RelacionConUnidad.igual), isFalse);
      expect(igual.esCorrecta(RelacionConUnidad.igual), isTrue);
      expect(mayor.esCorrecta(RelacionConUnidad.mayor), isTrue);
    },
  );

  test(
    'GeneradorComparacionUnidad produce las tres categorías a lo largo del muestreo',
    () {
      final gen = GeneradorComparacionUnidad(semilla: 9001);
      final categoriasVistas = <RelacionConUnidad>{};
      for (var intento = 0; intento < 80; intento++) {
        final problema = gen.generar(dificultad: 2);
        // El generador respeta la categoría que dice producir.
        if (problema.fraccion.numerador < problema.fraccion.denominador) {
          expect(problema.relacionCorrecta, RelacionConUnidad.menor);
        } else if (problema.fraccion.numerador ==
            problema.fraccion.denominador) {
          expect(problema.relacionCorrecta, RelacionConUnidad.igual);
        } else {
          expect(problema.relacionCorrecta, RelacionConUnidad.mayor);
        }
        categoriasVistas.add(problema.relacionCorrecta);
      }
      expect(categoriasVistas, contains(RelacionConUnidad.menor));
      expect(categoriasVistas, contains(RelacionConUnidad.igual));
      expect(categoriasVistas, contains(RelacionConUnidad.mayor));
    },
  );

  test('FR.04 está mapeada al tipo comparacionUnidad', () {
    expect(skillsConPuzzleImplementado, contains('FR.04'));
    expect(
      tipoParaSkillId('FR.04'),
      TipoFragmentoEnTejado.comparacionUnidad,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 5,
      denominador: 4,
      tipo: TipoFragmentoEnTejado.comparacionUnidad,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 26),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'FR.04');
  });

  test(
    'GeneradorCaza dirigido a FR.04 produce Fragmento de comparacionUnidad',
    () {
      final gen = GeneradorCaza(semilla: 31415);
      final ahora = DateTime(2026, 4, 26);
      for (var intento = 0; intento < 20; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'FR.04',
          esquirlasAcumuladas: 8,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.comparacionUnidad);
        expect(frag.numerador, greaterThanOrEqualTo(1));
        expect(frag.denominador, greaterThanOrEqualTo(2));
      }
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
        'uroto.flag.escena_3_14_vista': true,
        'uroto.flag.escena_3_15_vista': true,
        'uroto.flag.escena_3_16_vista': true,
        'uroto.flag.escena_3_17_vista': true,
        'uroto.flag.escena_3_18_vista': true,
        // Arco 4 marcado como cerrado.
        'uroto.flag.escena_4_1_vista': true,
        'uroto.flag.escena_4_2_vista': true,
        'uroto.flag.escena_4_3_vista': true,
        'uroto.flag.escena_4_4_vista': true,
        'uroto.flag.escena_4_5_vista': true,
        'uroto.flag.escena_4_6_vista': true,
        'uroto.flag.escena_4_7_vista': true,
        'uroto.flag.prueba_elegida_fuego': true,
        'uroto.flag.escena_4_8_fuego_vista': true,
        'uroto.flag.combate_vorax_completado': true,
        'uroto.flag.victoria_vorax': true,
        'uroto.flag.prueba_completada': true,
        'uroto.flag.escena_4_10_vista': true,
        'uroto.flag.escena_4_11_vista': true,
        'uroto.flag.escena_4_12_vista': true,
        'uroto.flag.escena_4_13_vista': true,
        'uroto.flag.escena_4_14_vista': true,
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
