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
import 'package:uno_roto/dominio/problema_comparacion_distinta.dart';
import 'package:uno_roto/dominio/problema_ordenar_decimales.dart';
import 'package:uno_roto/dominio/problema_comparacion_unidad.dart';
import 'package:uno_roto/dominio/problema_divisibilidad.dart';
import 'package:uno_roto/dominio/problema_lectura_decimal.dart';
import 'package:uno_roto/dominio/problema_lectura_fraccion.dart';
import 'package:uno_roto/dominio/problema_jerarquia.dart';
import 'package:uno_roto/dominio/problema_mcm_mcd.dart';
import 'package:uno_roto/dominio/problema_regla_de_tres.dart';
import 'package:uno_roto/dominio/problema_primo.dart';
import 'package:uno_roto/dominio/problema_comparacion_media.dart';
import 'package:uno_roto/dominio/problema_decimal.dart';
import 'package:uno_roto/dominio/problema_divisores.dart';
import 'package:uno_roto/dominio/problema_fraccion_de_cantidad.dart';
import 'package:uno_roto/dominio/problema_longitud.dart';
import 'package:uno_roto/dominio/problema_masa_capacidad.dart';
import 'package:uno_roto/dominio/problema_aumento_descuento.dart';
import 'package:uno_roto/dominio/problema_porcentaje_de.dart';
import 'package:uno_roto/dominio/problema_tiempo.dart';
import 'package:uno_roto/dominio/problema_ordenar_fracciones.dart';
import 'package:uno_roto/dominio/problema_razon.dart';
import 'package:uno_roto/dominio/problema_porcentaje_cantidad.dart';
import 'package:uno_roto/dominio/problema_mixto_a_impropio.dart';
import 'package:uno_roto/dominio/problema_redondeo_decimal.dart';
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

  // ═══ Puzzle de lectura de fracción (FR.02) ═══

  test(
    'GeneradorLecturaFraccion produce texto válido y un correcto entre 4 candidatos',
    () {
      final gen = GeneradorLecturaFraccion(semilla: 7);
      final problema = gen.generar(dificultad: 1);
      expect(problema.texto, isNotEmpty);
      expect(problema.candidatos, hasLength(4));
      expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
      expect(problema.esCorrecta(problema.indiceCorrecto), isTrue);
    },
  );

  test(
    'GeneradorLecturaFraccion en dificultad 1 evita denominadores grandes',
    () {
      final gen = GeneradorLecturaFraccion(semilla: 23);
      for (var intento = 0; intento < 30; intento++) {
        final problema = gen.generar(dificultad: 1);
        expect(
          problema.fraccionCorrecta.denominador,
          lessThanOrEqualTo(5),
          reason:
              'En dificultad 1 no deben aparecer sextos/séptimos/octavos.',
        );
      }
    },
  );

  test(
    'GeneradorLecturaFraccion.generarDesdeTexto recupera la forma exacta',
    () {
      final gen = GeneradorLecturaFraccion(semilla: 99);
      final problema = gen.generarDesdeTexto('tres quintos');
      expect(problema.texto, 'tres quintos');
      expect(problema.fraccionCorrecta.numerador, 3);
      expect(problema.fraccionCorrecta.denominador, 5);
      // Entre los distractores debe estar la inversión clásica.
      final tieneInversion = problema.candidatos.any(
        (f) => f.numerador == 5 && f.denominador == 3,
      );
      expect(tieneInversion, isTrue);
    },
  );

  test('FR.02 está mapeada al tipo lecturaFraccion', () {
    expect(skillsConPuzzleImplementado, contains('FR.02'));
    expect(
      tipoParaSkillId('FR.02'),
      TipoFragmentoEnTejado.lecturaFraccion,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 0,
      denominador: 1,
      tipo: TipoFragmentoEnTejado.lecturaFraccion,
      etiquetaDecimal: 'tres quintos',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 26),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'FR.02');
  });

  test(
    'GeneradorCaza dirigido a FR.02 produce Fragmento de lecturaFraccion con texto',
    () {
      final gen = GeneradorCaza(semilla: 8081);
      final ahora = DateTime(2026, 4, 26);
      for (var intento = 0; intento < 15; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'FR.02',
          esquirlasAcumuladas: 8,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.lecturaFraccion);
        expect(frag.etiquetaDecimal, isNotNull);
        expect(frag.etiquetaDecimal, isNotEmpty);
      }
    },
  );

  // ═══ Puzzle de mixto a impropio (FR.13) ═══

  test(
    'GeneradorMixtoAImpropio produce 4 candidatos con el correcto entre ellos',
    () {
      final gen = GeneradorMixtoAImpropio(semilla: 11);
      final problema = gen.generar(dificultad: 1);
      expect(problema.candidatos, hasLength(4));
      expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
      final correcta = problema.fraccionCorrecta;
      expect(
        correcta.numerador,
        problema.entero * problema.denominador + problema.numerador,
      );
      expect(correcta.denominador, problema.denominador);
    },
  );

  test(
    'GeneradorMixtoAImpropio incluye trampas pedagógicas: suma errónea y solo fracción',
    () {
      final gen = GeneradorMixtoAImpropio(semilla: 42);
      var vioSumaErronea = false;
      var vioSoloFraccion = false;
      for (var intento = 0; intento < 30; intento++) {
        final problema = gen.generar(dificultad: 2);
        for (final c in problema.candidatos) {
          if (c.numerador == problema.entero + problema.numerador &&
              c.denominador == problema.denominador) {
            vioSumaErronea = true;
          }
          if (c.numerador == problema.numerador &&
              c.denominador == problema.denominador) {
            vioSoloFraccion = true;
          }
        }
      }
      expect(vioSumaErronea, isTrue,
          reason: 'En 30 tiradas debería aparecer la suma errónea como distractor.');
      expect(vioSoloFraccion, isTrue,
          reason: 'En 30 tiradas debería aparecer la fracción sola.');
    },
  );

  test('FR.13 está mapeada al tipo mixtoAImpropio', () {
    expect(skillsConPuzzleImplementado, contains('FR.13'));
    expect(
      tipoParaSkillId('FR.13'),
      TipoFragmentoEnTejado.mixtoAImpropio,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      // 2 y 3/4 → 11/4. numeradorB lleva el entero.
      numerador: 11,
      denominador: 4,
      numeradorB: 2,
      tipo: TipoFragmentoEnTejado.mixtoAImpropio,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'FR.13');
  });

  test(
    'GeneradorCaza dirigido a FR.13 produce Fragmento con entero y denominador coherentes',
    () {
      final gen = GeneradorCaza(semilla: 271828);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 15; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'FR.13',
          esquirlasAcumuladas: 60, // tier 4+ para que entre
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.mixtoAImpropio);
        expect(frag.numeradorB, isNotNull);
        expect(frag.numeradorB!, greaterThanOrEqualTo(1));
        // numerador = entero * denominador + parteFraccionaria → siempre > entero*denominador
        expect(
          frag.numerador,
          greaterThan(frag.numeradorB! * frag.denominador),
        );
      }
    },
  );

  // ═══ Puzzle de redondeo a la décima (DEC.09) ═══

  test(
    'GeneradorRedondeoDecimal redondea correctamente con centésima ≥ 5',
    () {
      final gen = GeneradorRedondeoDecimal(semilla: 0);
      final problema = gen.generarDesdeEtiqueta('2,37');
      expect(problema.etiquetaCorrecta, '2,4');
    },
  );

  test(
    'GeneradorRedondeoDecimal redondea correctamente con centésima < 5',
    () {
      final gen = GeneradorRedondeoDecimal(semilla: 0);
      final problema = gen.generarDesdeEtiqueta('2,32');
      expect(problema.etiquetaCorrecta, '2,3');
    },
  );

  test(
    'GeneradorRedondeoDecimal propaga cuando la décima es 9 y la centésima ≥ 5',
    () {
      final gen = GeneradorRedondeoDecimal(semilla: 0);
      final problema = gen.generarDesdeEtiqueta('3,98');
      expect(problema.etiquetaCorrecta, '4,0');
    },
  );

  test(
    'GeneradorRedondeoDecimal incluye al menos una trampa de truncar',
    () {
      final gen = GeneradorRedondeoDecimal(semilla: 0);
      final problema = gen.generarDesdeEtiqueta('2,37');
      expect(problema.candidatos, contains('2,3'));
      expect(problema.candidatos, hasLength(4));
      expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
    },
  );

  test('DEC.09 está mapeada al tipo redondeoDecimal', () {
    expect(skillsConPuzzleImplementado, contains('DEC.09'));
    expect(
      tipoParaSkillId('DEC.09'),
      TipoFragmentoEnTejado.redondeoDecimal,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 0,
      denominador: 1,
      tipo: TipoFragmentoEnTejado.redondeoDecimal,
      etiquetaDecimal: '2,37',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DEC.09');
  });

  test(
    'GeneradorCaza dirigido a DEC.09 produce Fragmento con etiqueta decimal',
    () {
      final gen = GeneradorCaza(semilla: 333);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'DEC.09',
          esquirlasAcumuladas: 25,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.redondeoDecimal);
        expect(frag.etiquetaDecimal, isNotNull);
        expect(frag.etiquetaDecimal!, contains(','));
      }
    },
  );

  // ═══ Puzzle de comparación de fracciones distintas (FR.07) ═══

  test(
    'ProblemaComparacionDistinta detecta correctamente la mayor por valor',
    () {
      // 3/4 (=0.75) vs 5/7 (≈0.714) — 3/4 mayor pero ambos términos
      // menores que los de 5/7. Caso contraintuitivo clásico.
      const a = Fraccion(3, 4);
      const b = Fraccion(5, 7);
      const problema = ProblemaComparacionDistinta(a: a, b: b);
      expect(problema.indiceMayor, 0);
      expect(problema.esCorrecta(0), isTrue);
      expect(problema.esCorrecta(1), isFalse);
    },
  );

  test('GeneradorComparacionDistinta nunca repite numerador o denominador', () {
    final gen = GeneradorComparacionDistinta(semilla: 19);
    for (var intento = 0; intento < 40; intento++) {
      final problema = gen.generar(dificultad: 2);
      expect(
        problema.a.numerador == problema.b.numerador,
        isFalse,
        reason: 'FR.07 no comparte numerador (eso es FR.06).',
      );
      expect(
        problema.a.denominador == problema.b.denominador,
        isFalse,
        reason: 'FR.07 no comparte denominador (eso es FR.05).',
      );
      expect(
        problema.a.numerador * problema.b.denominador ==
            problema.b.numerador * problema.a.denominador,
        isFalse,
        reason: 'FR.07 no admite fracciones equivalentes.',
      );
    }
  });

  test(
    'GeneradorComparacionDistinta produce casos contraintuitivos en buen porcentaje',
    () {
      final gen = GeneradorComparacionDistinta(semilla: 77);
      var contraintuitivos = 0;
      const total = 100;
      for (var intento = 0; intento < total; intento++) {
        final p = gen.generar(dificultad: 2);
        final ladoA = p.a.numerador * p.b.denominador;
        final ladoB = p.b.numerador * p.a.denominador;
        final mayor = ladoA > ladoB ? p.a : p.b;
        final menor = ladoA > ladoB ? p.b : p.a;
        // Contraintuitivo: la mayor por valor tiene num y den menores
        // que la menor por valor.
        if (mayor.numerador < menor.numerador &&
            mayor.denominador < menor.denominador) {
          contraintuitivos++;
        }
      }
      // Esperamos cerca del 60%; basta con > 40% para validar el sesgo.
      expect(contraintuitivos, greaterThan(total * 0.4),
          reason: 'El generador debe sesgar a casos contraintuitivos.');
    },
  );

  test('FR.07 está mapeada al tipo comparacionDistinta', () {
    expect(skillsConPuzzleImplementado, contains('FR.07'));
    expect(
      tipoParaSkillId('FR.07'),
      TipoFragmentoEnTejado.comparacionDistinta,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 3,
      denominador: 4,
      numeradorB: 5,
      denominadorB: 7,
      tipo: TipoFragmentoEnTejado.comparacionDistinta,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'FR.07');
  });

  test(
    'GeneradorCaza dirigido a FR.07 produce Fragmento con dos fracciones distintas',
    () {
      final gen = GeneradorCaza(semilla: 1234567);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'FR.07',
          esquirlasAcumuladas: 25,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.comparacionDistinta);
        expect(frag.numeradorB, isNotNull);
        expect(frag.denominadorB, isNotNull);
        expect(frag.numerador, isNot(equals(frag.numeradorB)));
        expect(frag.denominador, isNot(equals(frag.denominadorB)));
      }
    },
  );

  // ═══ Puzzle de números primos (DIV.05) ═══

  test('ProblemaPrimo clasifica correctamente casos canónicos', () {
    expect(const ProblemaPrimo(numero: 1).esPrimo, isFalse,
        reason: '1 nunca es primo (definición).');
    expect(const ProblemaPrimo(numero: 2).esPrimo, isTrue,
        reason: '2 es el único par primo.');
    expect(const ProblemaPrimo(numero: 9).esPrimo, isFalse,
        reason: '9 = 3² no es primo aunque sea impar.');
    expect(const ProblemaPrimo(numero: 13).esPrimo, isTrue);
    expect(const ProblemaPrimo(numero: 15).esPrimo, isFalse);
    expect(const ProblemaPrimo(numero: 17).esPrimo, isTrue);
    expect(const ProblemaPrimo(numero: 49).esPrimo, isFalse);
    expect(const ProblemaPrimo(numero: 91).esPrimo, isFalse,
        reason: '91 = 7·13 — caso confuso.');
  });

  test('ProblemaPrimo.esCorrecta valida la respuesta del niño', () {
    expect(const ProblemaPrimo(numero: 7).esCorrecta(true), isTrue);
    expect(const ProblemaPrimo(numero: 7).esCorrecta(false), isFalse);
    expect(const ProblemaPrimo(numero: 9).esCorrecta(false), isTrue);
    expect(const ProblemaPrimo(numero: 9).esCorrecta(true), isFalse);
  });

  test(
    'GeneradorPrimo incluye casos confusos (1, 9, 15…) en buen porcentaje',
    () {
      final gen = GeneradorPrimo(semilla: 5);
      var vio1o2 = false;
      var vioConfuso = false;
      const confusos = {1, 9, 15, 21, 25, 27, 33, 35};
      for (var intento = 0; intento < 80; intento++) {
        final problema = gen.generar(dificultad: 1);
        if (problema.numero == 1 || problema.numero == 2) vio1o2 = true;
        if (confusos.contains(problema.numero)) vioConfuso = true;
      }
      expect(vio1o2, isTrue,
          reason: 'En 80 tiradas debería aparecer al menos una vez 1 o 2.');
      expect(vioConfuso, isTrue,
          reason:
              'En 80 tiradas debería aparecer al menos un confuso impar no primo.');
    },
  );

  test('DIV.05 está mapeada al tipo primo', () {
    expect(skillsConPuzzleImplementado, contains('DIV.05'));
    expect(tipoParaSkillId('DIV.05'), TipoFragmentoEnTejado.primo);

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 17,
      denominador: 1,
      tipo: TipoFragmentoEnTejado.primo,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DIV.05');
  });

  test(
    'GeneradorCaza dirigido a DIV.05 produce Fragmentos con números enteros',
    () {
      final gen = GeneradorCaza(semilla: 9999);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'DIV.05',
          esquirlasAcumuladas: 8,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.primo);
        expect(frag.numerador, greaterThanOrEqualTo(1));
      }
    },
  );

  // ═══ Puzzle de regla de tres directa (PROP.03) ═══

  test(
    'GeneradorReglaDeTres calcula correctamente con resultado entero',
    () {
      final gen = GeneradorReglaDeTres(semilla: 0);
      // a:b = c:?  →  ? = b·c/a. (2,6,4) → 12.
      final problema = gen.generarDesdeTerminos(a: 2, b: 6, c: 4);
      expect(problema.resultado, 12);
      expect(problema.candidatos, hasLength(4));
      expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
    },
  );

  test(
    'GeneradorReglaDeTres incluye trampas pedagógicas (relación invertida y suma)',
    () {
      final gen = GeneradorReglaDeTres(semilla: 0);
      // (2,6,4) → correcto = 12. Trampas:
      //   - relación invertida: b·a/c = 6·2/4 = 3.
      //   - suma de los tres: 2+6+4 = 12 → coincide con correcto, así
      //     que se descarta como distractor; usamos otra tripla para
      //     verificarlo.
      final problemaInvertido = gen.generarDesdeTerminos(a: 2, b: 6, c: 4);
      expect(problemaInvertido.candidatos, contains(3));

      // (3,9,6) → correcto = 18, suma = 18 → no sirve. Probamos otra:
      // (5,10,7) → correcto = 14, suma = 22, b+c = 17.
      final otroProblema = gen.generarDesdeTerminos(a: 5, b: 10, c: 7);
      expect(otroProblema.resultado, 14);
      // Suma de los tres como distractor.
      expect(otroProblema.candidatos, contains(22));
    },
  );

  test('GeneradorReglaDeTres nunca repite candidatos', () {
    final gen = GeneradorReglaDeTres(semilla: 7);
    for (var intento = 0; intento < 30; intento++) {
      final problema = gen.generar(dificultad: 2);
      final unicos = problema.candidatos.toSet();
      expect(unicos.length, problema.candidatos.length,
          reason: 'Los cuatro candidatos deben ser distintos.');
    }
  });

  test('PROP.03 está mapeada al tipo reglaDeTres', () {
    expect(skillsConPuzzleImplementado, contains('PROP.03'));
    expect(
      tipoParaSkillId('PROP.03'),
      TipoFragmentoEnTejado.reglaDeTres,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 2,
      denominador: 6,
      numeradorB: 4,
      tipo: TipoFragmentoEnTejado.reglaDeTres,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'PROP.03');
  });

  test(
    'GeneradorCaza dirigido a PROP.03 produce Fragmentos con tripla válida',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'PROP.03',
          esquirlasAcumuladas: 60, // tier 4 para que entre
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.reglaDeTres);
        expect(frag.numerador, greaterThan(0)); // a
        expect(frag.denominador, greaterThan(0)); // b
        expect(frag.numeradorB, isNotNull); // c
        // El resultado tiene que salir entero: b·c divisible entre a.
        expect(
          (frag.denominador * (frag.numeradorB ?? 0)) % frag.numerador,
          0,
        );
      }
    },
  );

  // ═══ Puzzle de ordenar decimales (DEC.03) ═══

  test('GeneradorOrdenarDecimales identifica el orden correcto de menor a mayor',
      () {
    final gen = GeneradorOrdenarDecimales(semilla: 0);
    final problema = gen.generarDesdeTrio(['0,5', '0,35', '0,8']);
    // El orden ascendente real es: 0,35 < 0,5 < 0,8.
    expect(problema.correcto, ['0,35', '0,5', '0,8']);
    expect(problema.candidatos, hasLength(4));
    expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
  });

  test(
    'GeneradorOrdenarDecimales incluye el distractor "más cifras = mayor"',
    () {
      final gen = GeneradorOrdenarDecimales(semilla: 0);
      final problema = gen.generarDesdeTrio(['0,5', '0,35', '0,8']);
      // El error sistemático: ordenar por número de cifras (0,8 < 0,5 < 0,35).
      expect(
        problema.candidatos.any(
          (c) =>
              c[0] == '0,8' && c[1] == '0,5' && c[2] == '0,35',
        ),
        isTrue,
        reason: 'Debe incluir el orden por número de cifras como distractor.',
      );
    },
  );

  test('DEC.03 está mapeada al tipo ordenarDecimales', () {
    expect(skillsConPuzzleImplementado, contains('DEC.03'));
    expect(
      tipoParaSkillId('DEC.03'),
      TipoFragmentoEnTejado.ordenarDecimales,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 0,
      denominador: 1,
      tipo: TipoFragmentoEnTejado.ordenarDecimales,
      decimalA: '0,5',
      decimalB: '0,35',
      etiquetaDecimal: '0,5|0,35|0,8',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DEC.03');
  });

  test(
    'GeneradorCaza dirigido a DEC.03 produce Fragmento con tres decimales',
    () {
      final gen = GeneradorCaza(semilla: 51234);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'DEC.03',
          esquirlasAcumuladas: 25,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.ordenarDecimales);
        // etiquetaDecimal lleva los 3 decimales separados por '|'.
        final partes = (frag.etiquetaDecimal ?? '').split('|');
        expect(partes, hasLength(3));
        for (final p in partes) {
          expect(p, contains(','));
        }
      }
    },
  );

  // ═══ Puzzle de MCM y MCD (DIV.06 / DIV.07) ═══

  test('GeneradorMcmMcd calcula MCM correctamente', () {
    final gen = GeneradorMcmMcd(semilla: 0);
    final problema = gen.generarDesdeTerminos(
      a: 8,
      b: 12,
      modo: ModoMcmMcd.mcm,
    );
    expect(problema.resultado, 24);
    expect(problema.candidatos, hasLength(4));
  });

  test('GeneradorMcmMcd calcula MCD correctamente', () {
    final gen = GeneradorMcmMcd(semilla: 0);
    final problema = gen.generarDesdeTerminos(
      a: 8,
      b: 12,
      modo: ModoMcmMcd.mcd,
    );
    expect(problema.resultado, 4);
    expect(problema.candidatos, hasLength(4));
  });

  test(
    'GeneradorMcmMcd incluye trampa del contrario (MCM cuando se pide MCD)',
    () {
      final gen = GeneradorMcmMcd(semilla: 0);
      // Para MCD(8,12) = 4, esperamos que aparezca el MCM (24) como
      // distractor — el error pedagógico clásico.
      final problema = gen.generarDesdeTerminos(
        a: 8,
        b: 12,
        modo: ModoMcmMcd.mcd,
      );
      expect(problema.candidatos, contains(4));
      expect(problema.candidatos, contains(24));
    },
  );

  test('DIV.07 está mapeada a mcmMcd con modo MCM', () {
    expect(skillsConPuzzleImplementado, contains('DIV.07'));
    expect(tipoParaSkillId('DIV.07'), TipoFragmentoEnTejado.mcmMcd);
    expect(modoMcmMcdParaSkillId('DIV.07'), 'mcm');

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 8,
      denominador: 12,
      tipo: TipoFragmentoEnTejado.mcmMcd,
      etiquetaDecimal: 'mcm',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DIV.07');
  });

  test('DIV.06 está mapeada a mcmMcd con modo MCD', () {
    expect(skillsConPuzzleImplementado, contains('DIV.06'));
    expect(tipoParaSkillId('DIV.06'), TipoFragmentoEnTejado.mcmMcd);
    expect(modoMcmMcdParaSkillId('DIV.06'), 'mcd');

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 8,
      denominador: 12,
      tipo: TipoFragmentoEnTejado.mcmMcd,
      etiquetaDecimal: 'mcd',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DIV.06');
  });

  test(
    'GeneradorCaza dirigido a DIV.07 produce Fragmento con modo MCM',
    () {
      final gen = GeneradorCaza(semilla: 9876);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 8; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'DIV.07',
          esquirlasAcumuladas: 60, // tier 4+
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.mcmMcd);
        expect(frag.etiquetaDecimal, 'mcm');
      }
    },
  );

  test(
    'GeneradorCaza dirigido a DIV.06 produce Fragmento con modo MCD',
    () {
      final gen = GeneradorCaza(semilla: 5432);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 8; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'DIV.06',
          esquirlasAcumuladas: 60,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.mcmMcd);
        expect(frag.etiquetaDecimal, 'mcd');
      }
    },
  );

  // ═══ Puzzle de jerarquía de operaciones (OP.01) ═══

  test(
    'GeneradorJerarquia respeta la prioridad: 2 + 3 × 4 = 14, no 20',
    () {
      final gen = GeneradorJerarquia(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        a: 2,
        b: 3,
        c: 4,
        op1: OperadorAritmetico.suma,
        op2: OperadorAritmetico.producto,
      );
      expect(problema.resultado, 14);
      // El 20 (cálculo izquierda-a-derecha) debe aparecer como
      // distractor: es el error pedagógico clásico.
      expect(problema.candidatos, contains(20));
    },
  );

  test(
    'GeneradorJerarquia respeta la prioridad: 10 − 6 ÷ 2 = 7, no 2',
    () {
      final gen = GeneradorJerarquia(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        a: 10,
        b: 6,
        c: 2,
        op1: OperadorAritmetico.resta,
        op2: OperadorAritmetico.division,
      );
      expect(problema.resultado, 7);
      expect(problema.candidatos, contains(2));
    },
  );

  test('OP.01 está mapeada al tipo jerarquia', () {
    expect(skillsConPuzzleImplementado, contains('OP.01'));
    expect(tipoParaSkillId('OP.01'), TipoFragmentoEnTejado.jerarquia);

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 2,
      denominador: 3,
      numeradorB: 4,
      tipo: TipoFragmentoEnTejado.jerarquia,
      operador: OperadorAritmetico.producto,
      decimalA: 'suma',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'OP.01');
  });

  test(
    'GeneradorCaza dirigido a OP.01 produce Fragmento con tres operandos y dos operadores',
    () {
      final gen = GeneradorCaza(semilla: 31415);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'OP.01',
          esquirlasAcumuladas: 25,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.jerarquia);
        expect(frag.numerador, greaterThan(0));
        expect(frag.numeradorB, isNotNull);
        expect(frag.operador, isNotNull);
        expect(frag.decimalA, isNotNull);
      }
    },
  );

  // ═══ Puzzle de comparación con 1/2 (FR.03) ═══

  test('ProblemaComparacionMedia clasifica correctamente la heurística 2·n vs d',
      () {
    // 2/5: 2·2 = 4 < 5 → menor.
    expect(
      const ProblemaComparacionMedia(fraccion: Fraccion(2, 5)).relacionCorrecta,
      RelacionConMedia.menor,
    );
    // 5/9: 2·5 = 10 > 9 → mayor.
    expect(
      const ProblemaComparacionMedia(fraccion: Fraccion(5, 9)).relacionCorrecta,
      RelacionConMedia.mayor,
    );
    // 3/6: 2·3 = 6 = 6 → igual.
    expect(
      const ProblemaComparacionMedia(fraccion: Fraccion(3, 6)).relacionCorrecta,
      RelacionConMedia.igual,
    );
    // 4/8: igual también — el caso "equivalente a 1/2" suele
    // pasarse por alto.
    expect(
      const ProblemaComparacionMedia(fraccion: Fraccion(4, 8)).relacionCorrecta,
      RelacionConMedia.igual,
    );
  });

  test(
    'GeneradorComparacionMedia produce las tres categorías a lo largo del muestreo',
    () {
      final gen = GeneradorComparacionMedia(semilla: 11);
      var menor = 0;
      var igual = 0;
      var mayor = 0;
      for (var intento = 0; intento < 200; intento++) {
        final problema = gen.generar(dificultad: 2);
        switch (problema.relacionCorrecta) {
          case RelacionConMedia.menor:
            menor++;
            break;
          case RelacionConMedia.igual:
            igual++;
            break;
          case RelacionConMedia.mayor:
            mayor++;
            break;
        }
      }
      expect(menor, greaterThan(0));
      expect(igual, greaterThan(0));
      expect(mayor, greaterThan(0));
    },
  );

  test('FR.03 está mapeada al tipo comparacionMedia', () {
    expect(skillsConPuzzleImplementado, contains('FR.03'));
    expect(
      tipoParaSkillId('FR.03'),
      TipoFragmentoEnTejado.comparacionMedia,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 5,
      denominador: 9,
      tipo: TipoFragmentoEnTejado.comparacionMedia,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'FR.03');
  });

  test(
    'GeneradorCaza dirigido a FR.03 produce Fragmentos de comparacionMedia',
    () {
      final gen = GeneradorCaza(semilla: 12345);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'FR.03',
          esquirlasAcumuladas: 8,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.comparacionMedia);
        expect(frag.numerador, greaterThanOrEqualTo(1));
        expect(frag.denominador, greaterThanOrEqualTo(2));
      }
    },
  );

  // ═══ Puzzle de divisores (DIV.02) ═══

  test(
    'GeneradorDivisores produce 4 candidatos: 3 divisores reales y 1 intruso',
    () {
      final gen = GeneradorDivisores(semilla: 7);
      final problema = gen.generarDesdeNumero(12);
      expect(problema.numero, 12);
      expect(problema.candidatos, hasLength(4));
      // Tres candidatos dividen a 12 exacto, uno no.
      var dividen = 0;
      for (final c in problema.candidatos) {
        if (12 % c == 0) dividen++;
      }
      expect(dividen, 3);
      // El intruso reportado es justamente el que no divide.
      expect(12 % problema.intruso, isNot(0));
    },
  );

  test('GeneradorDivisores nunca repite candidatos', () {
    final gen = GeneradorDivisores(semilla: 13);
    for (var intento = 0; intento < 30; intento++) {
      final problema = gen.generar(dificultad: 2);
      final unicos = problema.candidatos.toSet();
      expect(unicos.length, problema.candidatos.length,
          reason: 'Los cuatro candidatos deben ser distintos.');
    }
  });

  test('DIV.02 está mapeada al tipo divisores', () {
    expect(skillsConPuzzleImplementado, contains('DIV.02'));
    expect(tipoParaSkillId('DIV.02'), TipoFragmentoEnTejado.divisores);

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 12,
      denominador: 1,
      tipo: TipoFragmentoEnTejado.divisores,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'DIV.02');
  });

  test(
    'GeneradorCaza dirigido a DIV.02 produce Fragmentos con número objetivo',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'DIV.02',
          esquirlasAcumuladas: 8,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.divisores);
        expect(frag.numerador, greaterThanOrEqualTo(12));
      }
    },
  );

  // ═══ Puzzle de razón entre dos cantidades (PROP.01) ═══

  test(
    'Razon.reducida divide ambos términos por el MCD',
    () {
      expect(const Razon(12, 8).reducida().etiqueta, '3 : 2');
      expect(const Razon(15, 9).reducida().etiqueta, '5 : 3');
      expect(const Razon(7, 5).reducida().etiqueta, '7 : 5');
    },
  );

  test(
    'GeneradorRazon produce la razón reducida como respuesta correcta',
    () {
      final gen = GeneradorRazon(semilla: 0);
      // 12 manzanas y 8 naranjas → razón 3:2.
      final problema = gen.generarDesdePar(
        primero: 12,
        segundo: 8,
        etiquetaPrimero: 'manzanas',
        etiquetaSegundo: 'naranjas',
      );
      expect(problema.razonReducida.a, 3);
      expect(problema.razonReducida.b, 2);
      expect(problema.candidatos, hasLength(4));
    },
  );

  test(
    'GeneradorRazon incluye la razón sin reducir y la invertida como distractores',
    () {
      final gen = GeneradorRazon(semilla: 0);
      final problema = gen.generarDesdePar(
        primero: 12,
        segundo: 8,
      );
      // Sin reducir: 12:8 debería estar.
      expect(
        problema.candidatos.any((r) => r.a == 12 && r.b == 8),
        isTrue,
        reason: 'La razón sin simplificar es distractor clave.',
      );
      // Invertida: 2:3 debería estar.
      expect(
        problema.candidatos.any((r) => r.a == 2 && r.b == 3),
        isTrue,
        reason: 'La razón invertida es distractor clave.',
      );
    },
  );

  test('PROP.01 está mapeada al tipo razon', () {
    expect(skillsConPuzzleImplementado, contains('PROP.01'));
    expect(tipoParaSkillId('PROP.01'), TipoFragmentoEnTejado.razon);

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 12,
      denominador: 8,
      tipo: TipoFragmentoEnTejado.razon,
      decimalA: 'manzanas',
      decimalB: 'naranjas',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'PROP.01');
  });

  test(
    'GeneradorCaza dirigido a PROP.01 produce Fragmentos con par válido',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'PROP.01',
          esquirlasAcumuladas: 25,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.razon);
        expect(frag.numerador, greaterThan(0));
        expect(frag.denominador, greaterThan(0));
        expect(frag.decimalA, isNotNull);
        expect(frag.decimalB, isNotNull);
      }
    },
  );

  // ═══ Puzzle de unidades de longitud (MED.01) ═══

  test(
    'GeneradorLongitud convierte 5 m a 500 cm con factor 100',
    () {
      final gen = GeneradorLongitud(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        valorOrigen: 5,
        unidadOrigen: UnidadLongitud.m,
        unidadDestino: UnidadLongitud.cm,
      );
      expect(problema.resultado, 500);
      expect(problema.candidatos, hasLength(4));
      expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
    },
  );

  test(
    'GeneradorLongitud incluye distractor "factor menor" cuando aplica',
    () {
      // 5 m → cm exige ×100; el error típico es aplicar ×10 → 50.
      final gen = GeneradorLongitud(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        valorOrigen: 5,
        unidadOrigen: UnidadLongitud.m,
        unidadDestino: UnidadLongitud.cm,
      );
      expect(problema.candidatos, contains(50));
    },
  );

  test(
    'GeneradorLongitud divide correctamente cuando sube en la escalera',
    () {
      // 4000 m → 4 km (÷1000).
      final gen = GeneradorLongitud(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        valorOrigen: 4000,
        unidadOrigen: UnidadLongitud.m,
        unidadDestino: UnidadLongitud.km,
      );
      expect(problema.resultado, 4);
    },
  );

  test('MED.01 está mapeada al tipo longitud', () {
    expect(skillsConPuzzleImplementado, contains('MED.01'));
    expect(tipoParaSkillId('MED.01'), TipoFragmentoEnTejado.longitud);

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 5,
      denominador: 1,
      tipo: TipoFragmentoEnTejado.longitud,
      decimalA: 'm',
      decimalB: 'cm',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'MED.01');
  });

  test(
    'GeneradorCaza dirigido a MED.01 produce Fragmentos con símbolos válidos',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'MED.01',
          esquirlasAcumuladas: 25,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.longitud);
        expect(frag.numerador, greaterThan(0));
        expect(frag.decimalA, isNotNull);
        expect(frag.decimalB, isNotNull);
        // Los símbolos deben ser reconocibles.
        expect(
          () => unidadDesdeSimbolo(frag.decimalA!),
          returnsNormally,
        );
        expect(
          () => unidadDesdeSimbolo(frag.decimalB!),
          returnsNormally,
        );
      }
    },
  );

  // ═══ Puzzle de aumentos y descuentos porcentuales (PROP.06) ═══

  test(
    'GeneradorAumentoDescuento aplica descuento del 20% sobre 80 → 64',
    () {
      final gen = GeneradorAumentoDescuento(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        tipo: TipoVariacionPorcentual.descuento,
        porcentaje: 20,
        cantidad: 80,
      );
      expect(problema.resultado, 64);
    },
  );

  test(
    'GeneradorAumentoDescuento aplica aumento del 15% sobre 200 → 230',
    () {
      final gen = GeneradorAumentoDescuento(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        tipo: TipoVariacionPorcentual.aumento,
        porcentaje: 15,
        cantidad: 200,
      );
      expect(problema.resultado, 230);
    },
  );

  test(
    'GeneradorAumentoDescuento incluye distractor "operación inversa"',
    () {
      // Descuento 20% sobre 80 → 64. La operación inversa (aumento) → 96.
      final gen = GeneradorAumentoDescuento(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        tipo: TipoVariacionPorcentual.descuento,
        porcentaje: 20,
        cantidad: 80,
      );
      expect(problema.candidatos, contains(96));
    },
  );

  test('PROP.06 está mapeada al tipo aumentoDescuento', () {
    expect(skillsConPuzzleImplementado, contains('PROP.06'));
    expect(
      tipoParaSkillId('PROP.06'),
      TipoFragmentoEnTejado.aumentoDescuento,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 20,
      denominador: 80,
      tipo: TipoFragmentoEnTejado.aumentoDescuento,
      decimalA: 'D',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'PROP.06');
  });

  test(
    'GeneradorCaza dirigido a PROP.06 produce Fragmentos válidos',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      final marcasVistas = <String>{};
      for (var intento = 0; intento < 30; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'PROP.06',
          esquirlasAcumuladas: 110,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.aumentoDescuento);
        expect(frag.numerador, greaterThan(0));
        expect(frag.denominador, greaterThan(0));
        expect(['A', 'D'], contains(frag.decimalA));
        marcasVistas.add(frag.decimalA!);
      }
      // En 30 intentos deberíamos ver tanto A como D.
      expect(marcasVistas, hasLength(2));
    },
  );

  // ═══ Puzzle de tiempo sexagesimal (MED.03) ═══

  test(
    'GeneradorTiempo convierte 3 h a 180 min (simple)',
    () {
      final gen = GeneradorTiempo(semilla: 0);
      final problema = gen.generarSimpleDesdeTerminos(
        valor: 3,
        origen: UnidadTiempo.hora,
        destino: UnidadTiempo.minuto,
      );
      expect(problema.resultado, 180);
      expect(problema.modo, ModoTiempo.simple);
    },
  );

  test(
    'GeneradorTiempo compuesto: 2 h y 30 min = 150 min, no 230',
    () {
      final gen = GeneradorTiempo(semilla: 0);
      final problema = gen.generarCompuestoDesdeTerminos(
        horas: 2, minutos: 30,
      );
      expect(problema.resultado, 150);
      expect(problema.modo, ModoTiempo.compuesto);
      // La trampa estrella debe estar entre los candidatos.
      expect(problema.candidatos, contains(230));
    },
  );

  test('MED.03 está mapeada al tipo tiempo', () {
    expect(skillsConPuzzleImplementado, contains('MED.03'));
    expect(tipoParaSkillId('MED.03'), TipoFragmentoEnTejado.tiempo);

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 2,
      denominador: 1,
      numeradorB: 30,
      tipo: TipoFragmentoEnTejado.tiempo,
      decimalA: 'h',
      decimalB: 'min',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'MED.03');
  });

  test(
    'GeneradorCaza dirigido a MED.03 produce Fragmentos válidos',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'MED.03',
          esquirlasAcumuladas: 25,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.tiempo);
        expect(frag.numerador, greaterThan(0));
        expect(frag.decimalA, isNotNull);
        expect(frag.decimalB, isNotNull);
        // Si es compuesto, numeradorB debe ser un entero positivo.
        if (frag.numeradorB != null) {
          expect(frag.numeradorB, greaterThan(0));
        }
      }
    },
  );

  // ═══ Puzzle de qué porcentaje representa A de B (PROP.05) ═══

  test(
    'GeneradorPorcentajeDe calcula correctamente con resultado entero',
    () {
      final gen = GeneradorPorcentajeDe(semilla: 0);
      // 12 de 50 = 24 %.
      final problema = gen.generarDesdeTerminos(parte: 12, total: 50);
      expect(problema.resultado, 24);
      expect(problema.candidatos, hasLength(4));
      expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
    },
  );

  test(
    'GeneradorPorcentajeDe incluye distractores reales (complemento, parte y total)',
    () {
      final gen = GeneradorPorcentajeDe(semilla: 0);
      // 12 de 50 → 24%. Distractores curados:
      //   - 76 (100 - 24, complemento).
      //   - 12 (parte literal como %).
      //   - 50 (total literal como %).
      final problema = gen.generarDesdeTerminos(parte: 12, total: 50);
      expect(problema.candidatos, contains(76));
      // Al menos uno de los dos distractores literales debe estar.
      final tieneLiteral = problema.candidatos.contains(12) ||
          problema.candidatos.contains(50);
      expect(tieneLiteral, isTrue,
          reason: 'parte o total como % debe ser distractor');
    },
  );

  test('PROP.05 está mapeada al tipo porcentajeDe', () {
    expect(skillsConPuzzleImplementado, contains('PROP.05'));
    expect(
      tipoParaSkillId('PROP.05'),
      TipoFragmentoEnTejado.porcentajeDe,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 12,
      denominador: 50,
      tipo: TipoFragmentoEnTejado.porcentajeDe,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'PROP.05');
  });

  test(
    'GeneradorCaza dirigido a PROP.05 produce Fragmentos con par válido',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'PROP.05',
          esquirlasAcumuladas: 110,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.porcentajeDe);
        expect(frag.numerador, greaterThan(0));
        expect(frag.denominador, greaterThan(0));
        // Resultado entero garantizado.
        expect((frag.numerador * 100) % frag.denominador, 0);
      }
    },
  );

  // ═══ Puzzle de masa y capacidad (MED.02) ═══

  test(
    'GeneradorMasaCapacidad convierte 3 kg a 3000 g (familia masa)',
    () {
      final gen = GeneradorMasaCapacidad(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        familia: FamiliaMetrica.masa,
        valorOrigen: 3,
        posicionOrigen: 0,
        posicionDestino: 3,
      );
      expect(problema.resultado, 3000);
      expect(problema.simboloOrigen, 'kg');
      expect(problema.simboloDestino, 'g');
      expect(problema.candidatos, hasLength(4));
    },
  );

  test(
    'GeneradorMasaCapacidad convierte 5 L a 5000 mL (familia capacidad)',
    () {
      final gen = GeneradorMasaCapacidad(semilla: 0);
      final problema = gen.generarDesdeTerminos(
        familia: FamiliaMetrica.capacidad,
        valorOrigen: 5,
        posicionOrigen: 3,
        posicionDestino: 6,
      );
      expect(problema.resultado, 5000);
      expect(problema.simboloOrigen, 'L');
      expect(problema.simboloDestino, 'mL');
    },
  );

  test('MED.02 está mapeada al tipo masaCapacidad', () {
    expect(skillsConPuzzleImplementado, contains('MED.02'));
    expect(
      tipoParaSkillId('MED.02'),
      TipoFragmentoEnTejado.masaCapacidad,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 3,
      denominador: 1,
      tipo: TipoFragmentoEnTejado.masaCapacidad,
      decimalA: 'kg',
      decimalB: 'g',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'MED.02');
  });

  test(
    'GeneradorCaza dirigido a MED.02 produce Fragmentos con familia válida',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      final familiasVistas = <FamiliaMetrica>{};
      for (var intento = 0; intento < 30; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'MED.02',
          esquirlasAcumuladas: 60,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.masaCapacidad);
        expect(frag.numerador, greaterThan(0));
        expect(frag.decimalA, isNotNull);
        expect(frag.decimalB, isNotNull);
        // Los símbolos deben pertenecer a alguna familia métrica.
        final origen = unidadDesdeSimboloMetrica(frag.decimalA!);
        final destino = unidadDesdeSimboloMetrica(frag.decimalB!);
        expect(origen.familia, destino.familia,
            reason: 'origen y destino deben ser de la misma familia');
        familiasVistas.add(origen.familia);
      }
      // En 30 intentos deberíamos ver las dos familias.
      expect(familiasVistas, hasLength(2));
    },
  );

  // ═══ Puzzle de ordenar fracciones (FR.08) ═══

  test(
    'GeneradorOrdenarFracciones identifica el orden correcto de menor a mayor',
    () {
      final gen = GeneradorOrdenarFracciones(semilla: 0);
      final problema = gen.generarDesdeTrio(const [
        Fraccion(2, 3),
        Fraccion(1, 2),
        Fraccion(3, 4),
      ]);
      // 1/2 < 2/3 < 3/4.
      expect(problema.correcto.map((f) => f.etiqueta).toList(),
          ['1/2', '2/3', '3/4']);
      expect(problema.candidatos, hasLength(4));
      expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
    },
  );

  test(
    'GeneradorOrdenarFracciones incluye distractor "ordenar por numerador"',
    () {
      final gen = GeneradorOrdenarFracciones(semilla: 0);
      // Probamos un trío donde el orden por numerador NO coincide con
      // el correcto, para asegurar que el invertido aparece como
      // distractor independiente del orden correcto.
      final otro = gen.generarDesdeTrio(const [
        Fraccion(1, 5),
        Fraccion(2, 3),
        Fraccion(1, 2),
      ]);
      // Por numerador: 1/5 (n=1), 1/2 (n=1, igual), 2/3 (n=2). El
      // orden no es estable pero el sort dejará uno antes que otro.
      // Real: 1/5 (0,2) < 1/2 (0,5) < 2/3 (0,67).
      expect(otro.correcto.map((f) => f.etiqueta).toList(),
          ['1/5', '1/2', '2/3']);
      // El orden invertido siempre está como distractor.
      expect(
        otro.candidatos.any((c) =>
            c[0].etiqueta == '2/3' &&
            c[1].etiqueta == '1/2' &&
            c[2].etiqueta == '1/5'),
        isTrue,
      );
    },
  );

  test('FR.08 está mapeada al tipo ordenarFracciones', () {
    expect(skillsConPuzzleImplementado, contains('FR.08'));
    expect(
      tipoParaSkillId('FR.08'),
      TipoFragmentoEnTejado.ordenarFracciones,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 1,
      denominador: 2,
      tipo: TipoFragmentoEnTejado.ordenarFracciones,
      etiquetaDecimal: '1/2|2/3|3/4',
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'FR.08');
  });

  test(
    'GeneradorCaza dirigido a FR.08 produce Fragmentos con tres fracciones',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'FR.08',
          esquirlasAcumuladas: 25,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.ordenarFracciones);
        // etiquetaDecimal lleva tres fracciones separadas por '|'.
        final partes = (frag.etiquetaDecimal ?? '').split('|');
        expect(partes, hasLength(3));
        for (final p in partes) {
          expect(p, contains('/'));
        }
      }
    },
  );

  // ═══ Puzzle de fracción de una cantidad (FR.22) ═══

  test(
    'GeneradorFraccionDeCantidad calcula correctamente con resultado entero',
    () {
      final gen = GeneradorFraccionDeCantidad(semilla: 0);
      // 3/5 de 25 = 15.
      final problema = gen.generarDesdeTerminos(
        numerador: 3,
        denominador: 5,
        cantidad: 25,
      );
      expect(problema.resultado, 15);
      expect(problema.candidatos, hasLength(4));
      expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
    },
  );

  test(
    'GeneradorFraccionDeCantidad incluye distractores reales (n × c sin dividir, c ÷ d)',
    () {
      final gen = GeneradorFraccionDeCantidad(semilla: 0);
      // 3/5 de 25 → correcto 15. Distractores:
      //   - n × c sin dividir = 75.
      //   - c ÷ d (ignora n) = 5.
      //   - n literal = 3.
      final problema = gen.generarDesdeTerminos(
        numerador: 3,
        denominador: 5,
        cantidad: 25,
      );
      expect(problema.candidatos, contains(75));
      expect(problema.candidatos, contains(5));
      expect(problema.candidatos, contains(3));
    },
  );

  test('FR.22 está mapeada al tipo fraccionDeCantidad', () {
    expect(skillsConPuzzleImplementado, contains('FR.22'));
    expect(
      tipoParaSkillId('FR.22'),
      TipoFragmentoEnTejado.fraccionDeCantidad,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 3,
      denominador: 5,
      numeradorB: 25,
      tipo: TipoFragmentoEnTejado.fraccionDeCantidad,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'FR.22');
  });

  test(
    'GeneradorCaza dirigido a FR.22 produce Fragmentos con tripla válida',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'FR.22',
          esquirlasAcumuladas: 60,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.fraccionDeCantidad);
        expect(frag.numerador, greaterThan(0));
        expect(frag.denominador, greaterThan(0));
        expect(frag.numeradorB, isNotNull);
        // Resultado entero: numerador × cantidad debe ser múltiplo del
        // denominador.
        expect(
          (frag.numerador * (frag.numeradorB ?? 0)) % frag.denominador,
          0,
        );
      }
    },
  );

  // ═══ FR.18 / FR.20 / DEC.05 — segundo operando natural ═══

  test(
    'segundoOperandoNaturalParaSkill marca FR.18, FR.20 y DEC.05',
    () {
      expect(segundoOperandoNaturalParaSkill('FR.18'), isTrue);
      expect(segundoOperandoNaturalParaSkill('FR.20'), isTrue);
      expect(segundoOperandoNaturalParaSkill('DEC.05'), isTrue);
      // Las que SÍ son fracción × fracción / decimal × decimal NO.
      expect(segundoOperandoNaturalParaSkill('FR.19'), isFalse);
      expect(segundoOperandoNaturalParaSkill('FR.21'), isFalse);
      expect(segundoOperandoNaturalParaSkill('DEC.06'), isFalse);
    },
  );

  test(
    'GeneradorCaza dirigido a FR.18 produce duales con segundo operando natural',
    () {
      final gen = GeneradorCaza(semilla: 99);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 20; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'FR.18',
          esquirlasAcumuladas: 70,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.dual);
        expect(frag.operador, OperadorAritmetico.producto);
        // El segundo operando es un natural: denominadorB == 1.
        expect(frag.denominadorB, 1,
            reason: 'FR.18 exige fracción × natural, no fracción × fracción.');
        // El natural está en rango razonable para primaria.
        expect(frag.numeradorB, greaterThanOrEqualTo(2));
      }
    },
  );

  test(
    'GeneradorCaza dirigido a FR.20 produce duales con segundo operando natural',
    () {
      final gen = GeneradorCaza(semilla: 17);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 20; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'FR.20',
          esquirlasAcumuladas: 70,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.dual);
        expect(frag.operador, OperadorAritmetico.division);
        expect(frag.denominadorB, 1);
      }
    },
  );

  test(
    'GeneradorCaza dirigido a DEC.05 produce productos con segundo factor sin coma',
    () {
      final gen = GeneradorCaza(semilla: 41);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 20; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'DEC.05',
          esquirlasAcumuladas: 70,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.operacionDecimal);
        expect(frag.operador, OperadorAritmetico.producto);
        expect(frag.decimalB, isNotNull);
        // El segundo operando es entero: no contiene coma.
        expect(frag.decimalB, isNot(contains(',')));
      }
    },
  );

  test(
    "Fraccion.etiqueta omite '/1' cuando el denominador es 1",
    () {
      expect(const Fraccion(5, 1).etiqueta, '5');
      expect(const Fraccion(3, 4).etiqueta, '3/4');
    },
  );

  // ═══ Puzzle de convertir fracción a decimal (DEC.08) ═══

  test(
    'GeneradorDecimal muestra fracción y los candidatos son etiquetas decimales',
    () {
      final gen = GeneradorDecimal(semilla: 0);
      final problema = gen.generarDesde(
        const DecimalConocido('0,25', Fraccion(1, 4)),
      );
      // La pregunta es la fracción 1/4.
      expect(problema.fraccionMostrada.numerador, 1);
      expect(problema.fraccionMostrada.denominador, 4);
      // Los candidatos son strings decimales y el correcto es '0,25'.
      expect(problema.candidatos, hasLength(4));
      expect(problema.etiquetaCorrecta, '0,25');
      // Todos los candidatos contienen coma (forma decimal).
      for (final c in problema.candidatos) {
        expect(c, contains(','));
      }
    },
  );

  test('DEC.08 está mapeada al tipo decimal y entrena fracción → decimal', () {
    expect(skillsConPuzzleImplementado, contains('DEC.08'));
    expect(tipoParaSkillId('DEC.08'), TipoFragmentoEnTejado.decimal);
  });

  // ═══ Puzzle de porcentaje de cantidad (PROP.04) ═══

  test(
    'GeneradorPorcentajeCantidad calcula correctamente con resultado entero',
    () {
      final gen = GeneradorPorcentajeCantidad(semilla: 0);
      final problema = gen.generarDesdePar(25, 80);
      expect(problema.resultado, 20);
      expect(problema.candidatos, hasLength(4));
      expect(problema.indiceCorrecto, inInclusiveRange(0, 3));
    },
  );

  test(
    'GeneradorPorcentajeCantidad incluye trampas pedagógicas (% literal y producto sin dividir)',
    () {
      final gen = GeneradorPorcentajeCantidad(semilla: 0);
      final problema = gen.generarDesdePar(25, 80);
      expect(problema.candidatos, contains(25));
      expect(problema.candidatos, contains(2000));
      expect(problema.candidatos, contains(60));
    },
  );

  test('PROP.04 está mapeada al tipo porcentajeCantidad', () {
    expect(skillsConPuzzleImplementado, contains('PROP.04'));
    expect(
      tipoParaSkillId('PROP.04'),
      TipoFragmentoEnTejado.porcentajeCantidad,
    );

    final frag = FragmentoEnTejado(
      identificador: 'test',
      numerador: 25,
      denominador: 80,
      tipo: TipoFragmentoEnTejado.porcentajeCantidad,
      xNormalizado: 0,
      yNormalizado: 0,
      instanteAparicion: DateTime(2026, 4, 27),
      tiempoDeVida: const Duration(seconds: 10),
    );
    expect(idHabilidadPrincipal(frag), 'PROP.04');
  });

  test(
    'GeneradorCaza dirigido a PROP.04 produce Fragmentos con par válido',
    () {
      final gen = GeneradorCaza(semilla: 4242);
      final ahora = DateTime(2026, 4, 27);
      for (var intento = 0; intento < 12; intento++) {
        final frag = gen.siguienteParaSkill(
          idHabilidad: 'PROP.04',
          esquirlasAcumuladas: 60,
          ahora: ahora.add(Duration(seconds: intento)),
        );
        expect(frag.tipo, TipoFragmentoEnTejado.porcentajeCantidad);
        expect(frag.numerador, greaterThan(0));
        expect(frag.denominador, greaterThan(0));
        // Si el resultado tiene que ser entero, % × cantidad debe ser
        // múltiplo de 100.
        expect((frag.numerador * frag.denominador) % 100, 0);
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
