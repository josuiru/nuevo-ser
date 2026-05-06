import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:uno_roto/dominio/problema_amplificar.dart';
import 'package:uno_roto/dominio/problema_angulo.dart';
import 'package:uno_roto/dominio/problema_area_rectangulo.dart';
import 'package:uno_roto/dominio/problema_area_triangulo.dart';
import 'package:uno_roto/dominio/problema_aumento_descuento.dart';
import 'package:uno_roto/dominio/problema_circulo.dart';
import 'package:uno_roto/dominio/problema_decimal.dart';
import 'package:uno_roto/dominio/problema_dual.dart';
import 'package:uno_roto/dominio/problema_ecuacion_lineal.dart';
import 'package:uno_roto/dominio/fragmento_en_tejado.dart' show OperadorAritmetico;
import 'package:uno_roto/dominio/problema_escala.dart';
import 'package:uno_roto/dominio/problema_impropio.dart';
import 'package:uno_roto/dominio/problema_operacion_decimal.dart';
import 'package:uno_roto/dominio/problema_porcentaje.dart';
import 'package:uno_roto/dominio/problema_proporcional.dart';
import 'package:uno_roto/dominio/problema_espejo.dart';
import 'package:uno_roto/dominio/problema_fraccion_de_cantidad.dart';
import 'package:uno_roto/dominio/problema_grafico_barras.dart';
import 'package:uno_roto/dominio/problema_grafico_circular.dart';
import 'package:uno_roto/dominio/problema_jerarquia.dart';
import 'package:uno_roto/dominio/problema_jerarquia_fracciones.dart';
import 'package:uno_roto/dominio/problema_mcm_mcd.dart';
import 'package:uno_roto/dominio/problema_media.dart';
import 'package:uno_roto/dominio/problema_moda_mediana.dart';
import 'package:uno_roto/dominio/problema_operacion_mixta.dart';
import 'package:uno_roto/dominio/problema_ordenar_fracciones.dart';
import 'package:uno_roto/dominio/problema_perimetro.dart';
import 'package:uno_roto/dominio/problema_porcentaje_cantidad.dart';
import 'package:uno_roto/dominio/problema_porcentaje_de.dart';
import 'package:uno_roto/dominio/problema_probabilidad.dart';
import 'package:uno_roto/dominio/problema_probabilidad_porcentaje.dart';
import 'package:uno_roto/dominio/problema_razon.dart';
import 'package:uno_roto/dominio/problema_regla_de_tres.dart';
import 'package:uno_roto/dominio/problema_simplificar.dart';
import 'package:uno_roto/dominio/problema_suma_basica.dart';
import 'package:uno_roto/dominio/problema_volumen.dart';

/// Verifica las invariantes de un problema con candidatos:
///   1. Hay exactamente [esperados] candidatos.
///   2. [indiceCorrecto] está en rango.
///   3. Ningún par de candidatos colisiona por igualdad de valor —
///      eso rompería la validación, porque dos botones con el mismo
///      valor matemático y solo uno aceptado como correcto frustra
///      al niño matemáticamente correcto que toca el "otro".
void verificarParidad<T>({
  required List<T> candidatos,
  required int indiceCorrecto,
  required bool Function(T a, T b) sonIgualesPorValor,
  int esperados = 4,
  String contexto = '',
}) {
  expect(candidatos.length, esperados,
      reason: 'Número incorrecto de candidatos en $contexto');
  expect(indiceCorrecto, inInclusiveRange(0, candidatos.length - 1),
      reason: 'indiceCorrecto fuera de rango en $contexto');
  for (var i = 0; i < candidatos.length; i++) {
    for (var j = i + 1; j < candidatos.length; j++) {
      expect(
        sonIgualesPorValor(candidatos[i], candidatos[j]),
        isFalse,
        reason: 'Candidatos $i y $j colisionan por valor en $contexto: '
            '${candidatos[i]} ≡ ${candidatos[j]}',
      );
    }
  }
}

bool intIguales(int a, int b) => a == b;
bool doubleIguales(double a, double b) => (a - b).abs() < 1e-9;
bool stringIguales(String a, String b) => a == b;
bool fraccionEquivalente(Fraccion a, Fraccion b) =>
    a.numerador * b.denominador == b.numerador * a.denominador;
bool listaFraccionMismoOrden(List<Fraccion> a, List<Fraccion> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!fraccionEquivalente(a[i], b[i])) return false;
  }
  return true;
}

void main() {
  // --------------------------------------------------------------
  // Bloque 1 — generadores con casos curados expuestos. Recorre
  // todos los índices del pool y verifica cada problema.
  // --------------------------------------------------------------

  group('paridad por índice — pool curado completo', () {
    test('perimetro (GEO.02)', () {
      for (var i = 0;
          i < GeneradorPerimetro.cantidadDeCasosCurados;
          i++) {
        final p = GeneradorPerimetro(semilla: 1).generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: intIguales,
          contexto: 'perímetro caso $i (lados=${p.lados})',
        );
      }
    });

    test('area_rectangulo (GEO.03)', () {
      for (var i = 0;
          i < GeneradorAreaRectangulo.cantidadDeCasosCurados;
          i++) {
        final p = GeneradorAreaRectangulo(semilla: 1).generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: intIguales,
          contexto: 'área rectángulo caso $i',
        );
      }
    });

    test('area_triangulo (GEO.04)', () {
      for (var i = 0;
          i < GeneradorAreaTriangulo.cantidadDeCasosCurados;
          i++) {
        final p = GeneradorAreaTriangulo(semilla: 1).generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: intIguales,
          contexto: 'área triángulo caso $i',
        );
      }
    });

    test('volumen (GEO.06)', () {
      for (var i = 0;
          i < GeneradorVolumen.cantidadDeCasosCurados;
          i++) {
        final p = GeneradorVolumen(semilla: 1).generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: intIguales,
          contexto: 'volumen caso $i',
        );
      }
    });

    test('grafico_barras (EST.01)', () {
      for (var i = 0;
          i < GeneradorGraficoBarras.cantidadDeCasosCurados;
          i++) {
        for (final modo in ModoGraficoBarras.values) {
          final p = GeneradorGraficoBarras(semilla: 1)
              .generarPorIndiceYModo(i, modo);
          verificarParidad(
            candidatos: p.candidatos,
            indiceCorrecto: p.indiceCorrecto,
            sonIgualesPorValor: intIguales,
            contexto: 'barras caso $i modo $modo',
          );
        }
      }
    });

    test('grafico_circular (EST.02)', () {
      for (var i = 0;
          i < GeneradorGraficoCircular.cantidadDeCasosCurados;
          i++) {
        final p =
            GeneradorGraficoCircular(semilla: 1).generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: intIguales,
          contexto: 'circular caso $i',
        );
      }
    });

    test('media (EST.03) — recorrido por índices 0..19', () {
      // GeneradorMedia no expone `cantidadDeCasosCurados`, pero
      // generarPorIndice acepta cualquier int (con clamp interno).
      // Recorremos un rango amplio para cubrir el pool real.
      for (var i = 0; i < 20; i++) {
        final p = GeneradorMedia(semilla: 1).generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: intIguales,
          contexto: 'media caso $i',
        );
      }
    });

    test('moda_mediana (EST.04)', () {
      for (final modo in ModoEstadistico.values) {
        final cantidad = modo == ModoEstadistico.moda
            ? GeneradorModaMediana.cantidadModaCurada
            : GeneradorModaMediana.cantidadMedianaCurada;
        for (var i = 0; i < cantidad; i++) {
          final p =
              GeneradorModaMediana(semilla: 1).generarPorIndice(modo, i);
          verificarParidad(
            candidatos: p.candidatos,
            indiceCorrecto: p.indiceCorrecto,
            sonIgualesPorValor: intIguales,
            contexto: 'moda/mediana modo $modo caso $i',
          );
        }
      }
    });

    test('jerarquia_fracciones (OP.02)', () {
      for (var i = 0;
          i < GeneradorJerarquiaFracciones.cantidadDeCasosCurados;
          i++) {
        final p =
            GeneradorJerarquiaFracciones(semilla: 1).generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: fraccionEquivalente,
          contexto: 'jerarquía fracciones caso $i',
        );
      }
    });

    test('operacion_mixta (OP.03)', () {
      for (var i = 0;
          i < GeneradorOperacionMixta.cantidadDeCasosCurados;
          i++) {
        final p = GeneradorOperacionMixta(semilla: 1).generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatosDecimales,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: doubleIguales,
          contexto: 'operación mixta caso $i',
        );
      }
    });

    test('probabilidad (PROB)', () {
      for (var i = 0;
          i < GeneradorProbabilidad.cantidadCurada;
          i++) {
        final p =
            GeneradorProbabilidad(semilla: 1).generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: fraccionEquivalente,
          contexto: 'probabilidad caso $i',
        );
      }
    });

    test('probabilidad_porcentaje (PROB%)', () {
      for (var i = 0;
          i < GeneradorProbabilidadPorcentaje.cantidadCurada;
          i++) {
        final p = GeneradorProbabilidadPorcentaje(semilla: 1)
            .generarPorIndice(i);
        verificarParidad(
          candidatos: p.candidatosPorcentaje,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: intIguales,
          contexto: 'probabilidad % caso $i',
        );
      }
    });
  });

  // --------------------------------------------------------------
  // Bloque 2 — generadores fuzz con semillas. Especialmente los
  // arreglados en la auditoría: si una colisión vuelve, el test
  // la pilla en una de las 200 tiradas.
  // --------------------------------------------------------------

  void fuzzInt(
    String nombre,
    List<int> Function(int semilla) generarCandidatos,
    int Function(int semilla) generarIndiceCorrecto,
  ) {
    test('$nombre — 200 semillas sin colisión', () {
      for (var s = 0; s < 200; s++) {
        verificarParidad<int>(
          candidatos: generarCandidatos(s),
          indiceCorrecto: generarIndiceCorrecto(s),
          sonIgualesPorValor: intIguales,
          contexto: '$nombre semilla=$s',
        );
      }
    });
  }

  group('paridad fuzz por semillas', () {
    fuzzInt(
      'jerarquia (OP.01) dif 1',
      (s) => GeneradorJerarquia(semilla: s).generar(dificultad: 1).candidatos,
      (s) =>
          GeneradorJerarquia(semilla: s).generar(dificultad: 1).indiceCorrecto,
    );
    fuzzInt(
      'jerarquia (OP.01) dif 2',
      (s) => GeneradorJerarquia(semilla: s).generar(dificultad: 2).candidatos,
      (s) =>
          GeneradorJerarquia(semilla: s).generar(dificultad: 2).indiceCorrecto,
    );
    fuzzInt(
      'mcm_mcd modo MCM',
      (s) => GeneradorMcmMcd(semilla: s)
          .generar(modo: ModoMcmMcd.mcm, dificultad: 2)
          .candidatos,
      (s) => GeneradorMcmMcd(semilla: s)
          .generar(modo: ModoMcmMcd.mcm, dificultad: 2)
          .indiceCorrecto,
    );
    fuzzInt(
      'mcm_mcd modo MCD',
      (s) => GeneradorMcmMcd(semilla: s)
          .generar(modo: ModoMcmMcd.mcd, dificultad: 2)
          .candidatos,
      (s) => GeneradorMcmMcd(semilla: s)
          .generar(modo: ModoMcmMcd.mcd, dificultad: 2)
          .indiceCorrecto,
    );
    fuzzInt(
      'regla_de_tres dif 1',
      (s) => GeneradorReglaDeTres(semilla: s)
          .generar(dificultad: 1)
          .candidatos,
      (s) => GeneradorReglaDeTres(semilla: s)
          .generar(dificultad: 1)
          .indiceCorrecto,
    );
    fuzzInt(
      'porcentaje_cantidad',
      (s) => GeneradorPorcentajeCantidad(semilla: s)
          .generar(dificultad: 1)
          .candidatos,
      (s) => GeneradorPorcentajeCantidad(semilla: s)
          .generar(dificultad: 1)
          .indiceCorrecto,
    );
    fuzzInt(
      'porcentaje_de',
      (s) =>
          GeneradorPorcentajeDe(semilla: s).generar(dificultad: 1).candidatos,
      (s) => GeneradorPorcentajeDe(semilla: s)
          .generar(dificultad: 1)
          .indiceCorrecto,
    );
    fuzzInt(
      'escala',
      (s) => GeneradorEscala(semilla: s).generar(dificultad: 1).candidatos,
      (s) => GeneradorEscala(semilla: s)
          .generar(dificultad: 1)
          .indiceCorrecto,
    );
    fuzzInt(
      'aumento_descuento',
      (s) => GeneradorAumentoDescuento(semilla: s)
          .generar(dificultad: 1)
          .candidatos,
      (s) => GeneradorAumentoDescuento(semilla: s)
          .generar(dificultad: 1)
          .indiceCorrecto,
    );
    // Ángulo: candidatos son TipoAngulo (enum). Igualdad directa.
    test('angulo dif 1 — 200 semillas sin colisión', () {
      for (var s = 0; s < 200; s++) {
        final p = GeneradorAngulo(semilla: s).generar(dificultad: 1);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: (a, b) => a == b,
          contexto: 'angulo semilla=$s',
        );
      }
    });
    fuzzInt(
      'fraccion_de_cantidad',
      (s) => GeneradorFraccionDeCantidad(semilla: s)
          .generar(dificultad: 1)
          .candidatos,
      (s) => GeneradorFraccionDeCantidad(semilla: s)
          .generar(dificultad: 1)
          .indiceCorrecto,
    );

    // Círculo: candidatos son double con dos decimales.
    test('circulo — 200 semillas sin colisión', () {
      for (var s = 0; s < 200; s++) {
        final p = GeneradorCirculo(semilla: s).generar(dificultad: 1);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: doubleIguales,
          contexto: 'circulo semilla=$s',
        );
      }
    });

    // Razón: candidatos son Razon. Equivalencia por cross-mult.
    test('razon — 200 semillas sin colisión', () {
      for (var s = 0; s < 200; s++) {
        final p = GeneradorRazon(semilla: s).generar(dificultad: 1);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          // Razon expone esEquivalenteA pero PROP.01 distingue
          // formas reducidas vs sin reducir, así que aquí la
          // igualdad relevante es por (a, b) exactos: dos botones
          // con el mismo par no se distinguen visualmente.
          sonIgualesPorValor: (x, y) => x.a == y.a && x.b == y.b,
          contexto: 'razon semilla=$s',
        );
      }
    });

    // Simplificar: candidatos Fraccion. La mecánica de FR.10 PIDE
    // explícitamente "la forma más reducida"; los distractores SON
    // por diseño equivalentes (objetivo sin simplificar, otra
    // amplificación) — el niño tiene que distinguir "la mínima" del
    // resto de equivalentes. Por eso aquí la igualdad relevante es
    // por num/den exactos (dos tarjetas idénticas visualmente sería
    // bug; dos tarjetas equivalentes pero distintas en escritura,
    // no).
    test('simplificar — 200 semillas sin tarjetas duplicadas', () {
      for (var s = 0; s < 200; s++) {
        final p = GeneradorSimplificar(semilla: s).generar(dificultad: 2);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: (a, b) =>
              a.numerador == b.numerador && a.denominador == b.denominador,
          contexto: 'simplificar semilla=$s',
        );
      }
    });

    // Amplificar: candidatos son numeradores int para un denominador
    // común (denominadorObjetivo). Convertimos a Fraccion para
    // verificar paridad por valor.
    test('amplificar — 200 semillas sin colisión', () {
      for (var s = 0; s < 200; s++) {
        final p = GeneradorAmplificar(semilla: s).generar(dificultad: 2);
        final candidatosComoFraccion = p.candidatos
            .map((n) => Fraccion(n, p.denominadorObjetivo))
            .toList();
        verificarParidad(
          candidatos: candidatosComoFraccion,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: fraccionEquivalente,
          contexto: 'amplificar semilla=$s',
        );
      }
    });

    // Dual: necesita pares de fracciones de entrada. Sembramos
    // pares aleatorios con denominadores 2..10 y numeradores
    // 1..den-1 (fracciones propias) — el grueso del pool del juego.
    test('dual — 200 pares aleatorios sin colisión', () {
      for (var s = 0; s < 200; s++) {
        final azar = math.Random(s);
        for (final operador in OperadorAritmetico.values) {
          final denA = 2 + azar.nextInt(8);
          final numA = 1 + azar.nextInt(denA - 1);
          final denB = operador == OperadorAritmetico.resta
              ? denA + 1 + azar.nextInt(3) // garantiza denA<denB
              : 2 + azar.nextInt(8);
          final numB = 1 + azar.nextInt(denB - 1);
          // En resta queremos numA/denA > numB/denB para que el
          // resultado sea positivo (igual que hace el juego).
          final a = Fraccion(numA, denA);
          final b = Fraccion(numB, denB);
          final ordenados = (operador == OperadorAritmetico.resta &&
                  a.numerador * b.denominador <
                      b.numerador * a.denominador)
              ? (b, a)
              : (a, b);
          final p = GeneradorDual(semilla: s).generarDesde(
            sumandoA: ordenados.$1,
            sumandoB: ordenados.$2,
            operador: operador,
          );
          verificarParidad(
            candidatos: p.candidatos,
            indiceCorrecto: p.indiceCorrecto,
            sonIgualesPorValor: fraccionEquivalente,
            contexto: 'dual semilla=$s op=$operador a=$a b=$b',
          );
        }
      }
    });

    // Espejo (FR.09): la mecánica permite que candidatos sean
    // equivalentes al objetivo (cualquier equivalente vale como
    // correcto). Solo verificamos que no haya dos candidatos
    // idénticos por num/den exactos (entonces el grid duplicaría
    // visualmente la misma tarjeta).
    test('espejo — 200 fracciones sin tarjetas duplicadas', () {
      for (var s = 0; s < 200; s++) {
        final azar = math.Random(s);
        // Construimos una fracción reducible: numerador 1..5 ×
        // factor 2..4, denominador correlativo.
        final den0 = 2 + azar.nextInt(5);
        final num0 = 1 + azar.nextInt(den0 - 1);
        final factor = 2 + azar.nextInt(3);
        final p = GeneradorEspejo(semilla: s).generar(
          numeradorBase: num0 * factor,
          denominadorBase: den0 * factor,
        );
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: (a, b) =>
              a.numerador == b.numerador && a.denominador == b.denominador,
          contexto:
              'espejo semilla=$s objetivo=${num0 * factor}/${den0 * factor}',
        );
      }
    });

    // Listas-de-fracciones (FR.08 ordenar).
    test('ordenar_fracciones — 200 semillas sin permutación duplicada', () {
      for (var s = 0; s < 200; s++) {
        final p = GeneradorOrdenarFracciones(semilla: s)
            .generar(dificultad: 1);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: listaFraccionMismoOrden,
          contexto: 'ordenar fracciones semilla=$s',
        );
      }
    });

    // Cubre los generadores que faltaban (con fallbacks `while` o
    // listas curadas) — la pareja del bug "tres respuestas iguales,
    // pulsé la correcta y dio error" descubierto en pruebas con niño.

    test('simplificar dif 1 — 200 semillas sin tarjetas duplicadas', () {
      for (var s = 0; s < 200; s++) {
        final p = GeneradorSimplificar(semilla: s).generar(dificultad: 1);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: (a, b) =>
              a.numerador == b.numerador && a.denominador == b.denominador,
          contexto: 'simplificar dif 1 semilla=$s',
        );
      }
    });

    test('simplificar generarDesde — toda la base reducible', () {
      // Recorre denominadores 2..6 y numeradores propios, multiplica
      // por factores 2..4 y verifica el problema generado desde el
      // cazadero (donde el Fragmento trae datos concretos).
      for (var den = 2; den <= 6; den++) {
        for (var num = 1; num < den; num++) {
          for (var factor = 2; factor <= 4; factor++) {
            final p = GeneradorSimplificar(semilla: 1).generarDesde(
              numerador: num * factor,
              denominador: den * factor,
            );
            verificarParidad(
              candidatos: p.candidatos,
              indiceCorrecto: p.indiceCorrecto,
              sonIgualesPorValor: (a, b) =>
                  a.numerador == b.numerador &&
                  a.denominador == b.denominador,
              contexto:
                  'simplificar desde ${num * factor}/${den * factor}',
            );
          }
        }
      }
    });

    test('impropio — 200 semillas sin tarjetas duplicadas', () {
      for (var s = 0; s < 200; s++) {
        final azar = math.Random(s);
        final den = 2 + azar.nextInt(8); // 2..9
        final num = den + 1 + azar.nextInt(20); // > den
        final p =
            GeneradorImpropio(semilla: s).generarDesde(
          numerador: num,
          denominador: den,
        );
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: (a, b) => a.esIgualA(b),
          contexto: 'impropio semilla=$s objetivo=$num/$den',
        );
      }
    });

    test('decimal — 200 semillas sin etiquetas duplicadas', () {
      for (var s = 0; s < 200; s++) {
        final p = GeneradorDecimal(semilla: s).generar();
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: stringIguales,
          contexto: 'decimal semilla=$s',
        );
      }
    });

    test('porcentaje — todo el pool curado', () {
      for (final objetivo in porcentajesConocidos) {
        final p =
            GeneradorPorcentaje(semilla: 1).generarDesde(objetivo);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: fraccionEquivalente,
          contexto: 'porcentaje objetivo=${objetivo.etiqueta}',
        );
      }
    });

    test('operacion_decimal — 200 semillas sin etiquetas duplicadas', () {
      for (var s = 0; s < 200; s++) {
        final p = GeneradorOperacionDecimal(semilla: s).generar();
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: stringIguales,
          contexto: 'operacion_decimal semilla=$s',
        );
      }
    });

    test('ecuacion_lineal — 200 semillas × 4 dificultades sin colisión', () {
      for (var dif = 1; dif <= 4; dif++) {
        for (var s = 0; s < 200; s++) {
          final p = GeneradorEcuacionLineal(semilla: s)
              .generar(dificultad: dif);
          verificarParidad(
            candidatos: p.candidatos,
            indiceCorrecto: p.indiceCorrecto,
            sonIgualesPorValor: intIguales,
            contexto:
                'ecuacion_lineal dif=$dif semilla=$s ${p.etiqueta} → x=${p.correcto}',
          );
        }
      }
    });

    test('suma_basica — 200 semillas × 4 dificultades sin colisión', () {
      for (var dif = 1; dif <= 4; dif++) {
        for (var s = 0; s < 200; s++) {
          final p = GeneradorSumaBasica(semilla: s).generar(dificultad: dif);
          verificarParidad(
            candidatos: p.candidatos,
            indiceCorrecto: p.indiceCorrecto,
            sonIgualesPorValor: intIguales,
            contexto:
                'suma_basica dif=$dif semilla=$s ${p.a}+${p.b}=${p.correcto}',
          );
        }
      }
    });

    test('proporcional — 200 pares aleatorios sin colisión', () {
      for (var s = 0; s < 200; s++) {
        final azar = math.Random(s);
        final a = 1 + azar.nextInt(15);
        final b = 1 + azar.nextInt(15);
        final p = GeneradorProporcional(semilla: s).generarDesde(a: a, b: b);
        verificarParidad(
          candidatos: p.candidatos,
          indiceCorrecto: p.indiceCorrecto,
          sonIgualesPorValor: intIguales,
          contexto: 'proporcional semilla=$s a=$a b=$b',
        );
      }
    });
  });
}
