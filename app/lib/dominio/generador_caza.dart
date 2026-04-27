import 'dart:math' as math;

import 'distrito.dart';
import 'fragmento_en_tejado.dart';
import 'mapeo_habilidades_puzzle.dart'
    show
        divisoresParaSkillId,
        modoComparacionParaSkillId,
        modoMcmMcdParaSkillId,
        operadorParaSkillId,
        segundoOperandoNaturalParaSkill,
        tipoParaSkillId;
import 'problema_amplificar.dart' show GeneradorAmplificar;
import 'problema_comparacion.dart' show GeneradorComparacion;
import 'problema_comparacion_decimal.dart'
    show GeneradorComparacionDecimal;
import 'problema_comparacion_unidad.dart'
    show GeneradorComparacionUnidad;
import 'problema_decimal.dart' show decimalesConocidos;
import 'problema_divisibilidad.dart' show GeneradorDivisibilidad;
import 'problema_lectura_decimal.dart' show GeneradorLecturaDecimal;
import 'problema_lectura_fraccion.dart' show GeneradorLecturaFraccion;
import 'problema_mixto_a_impropio.dart' show GeneradorMixtoAImpropio;
import 'problema_comparacion_distinta.dart'
    show GeneradorComparacionDistinta;
import 'problema_ordenar_decimales.dart' show GeneradorOrdenarDecimales;
import 'problema_jerarquia.dart' show GeneradorJerarquia;
import 'problema_comparacion_media.dart' show GeneradorComparacionMedia;
import 'problema_porcentaje_cantidad.dart' show GeneradorPorcentajeCantidad;
import 'problema_mcm_mcd.dart' show GeneradorMcmMcd, ModoMcmMcd;
import 'problema_regla_de_tres.dart' show GeneradorReglaDeTres;
import 'problema_primo.dart' show GeneradorPrimo;
import 'problema_redondeo_decimal.dart' show GeneradorRedondeoDecimal;
import 'problema_porcentaje.dart' show porcentajesConocidos;
import 'problema_simplificar.dart' show GeneradorSimplificar;

/// Genera Fragmentos que aparecen en el tejado a lo largo de una
/// sesión de caza. La dificultad sube **continuamente** con el número
/// de esquirlas acumuladas: denominadores más altos, aparición de
/// primos, compuestos más exigentes y tiempos de vida más cortos.
///
/// Biblia §6.2: un niño de 12 años que domina rápido no debe quedarse
/// con contenido de su edad; aquí no hay tope.
class GeneradorCaza {
  final math.Random _azar;

  /// Si viene un distrito, el generador usa su mezcla de puzzles como
  /// sesgo fuerte. Si es null, cae al reparto general por dificultad.
  final Distrito? distrito;

  GeneradorCaza({int? semilla, this.distrito}) : _azar = math.Random(semilla);

  /// Variante dirigida por skill_id: el motor adaptativo decide qué
  /// habilidad tocar y este generador produce un Fragmento del tipo
  /// correspondiente. Si el skill no tiene tipo mapeado, cae al
  /// comportamiento normal.
  FragmentoEnTejado siguienteParaSkill({
    required String idHabilidad,
    required int esquirlasAcumuladas,
    required DateTime ahora,
  }) {
    final tipoObjetivo = tipoParaSkillId(idHabilidad);
    if (tipoObjetivo == null) {
      return siguiente(
        esquirlasAcumuladas: esquirlasAcumuladas,
        ahora: ahora,
      );
    }
    final dificultad = _nivelDificultadSegunEsquirlas(esquirlasAcumuladas);
    return _generarDeTipo(
      tipo: tipoObjetivo,
      dificultad: dificultad,
      ahora: ahora,
      operadorPreferido: operadorParaSkillId(idHabilidad),
      modoComparacionPreferido: modoComparacionParaSkillId(idHabilidad),
      divisoresPermitidos: divisoresParaSkillId(idHabilidad),
      modoMcmMcdPreferido: modoMcmMcdParaSkillId(idHabilidad),
      segundoOperandoNatural:
          segundoOperandoNaturalParaSkill(idHabilidad),
    );
  }

  FragmentoEnTejado siguiente({
    required int esquirlasAcumuladas,
    required DateTime ahora,
  }) {
    final dificultad = _nivelDificultadSegunEsquirlas(esquirlasAcumuladas);
    final tipo = distrito != null
        ? _elegirTipoSegunDistrito(distrito!, dificultad)
        : _elegirTipo(dificultad);
    return _generarDeTipo(
      tipo: tipo,
      dificultad: dificultad,
      ahora: ahora,
    );
  }

  FragmentoEnTejado _generarDeTipo({
    required TipoFragmentoEnTejado tipo,
    required int dificultad,
    required DateTime ahora,
    OperadorAritmetico? operadorPreferido,
    ModoComparacion? modoComparacionPreferido,
    List<int>? divisoresPermitidos,
    String? modoMcmMcdPreferido,
    bool segundoOperandoNatural = false,
  }) {

    if (tipo == TipoFragmentoEnTejado.lecturaDecimal) {
      final problema = GeneradorLecturaDecimal(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        // numerador/denominador no aplican: el contenido pedagógico
        // viaja en `etiquetaDecimal` (texto en palabras).
        numerador: 0,
        denominador: 1,
        tipo: tipo,
        etiquetaDecimal: problema.texto,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.comparacionDecimal) {
      final problema = GeneradorComparacionDecimal(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        // numerador/denominador no aplican para decimales puros, pero
        // mantenemos el contrato del struct con valores neutros.
        numerador: 0,
        denominador: 1,
        tipo: tipo,
        decimalA: problema.etiquetaA,
        decimalB: problema.etiquetaB,
        etiquetaDecimal: '${problema.etiquetaA} · ${problema.etiquetaB}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.multiplos) {
      final problema = GeneradorDivisibilidad(
        semilla: _azar.nextInt(1 << 30),
        divisoresPermitidos:
            divisoresPermitidos ?? const [2, 3, 4, 5, 6, 7, 8, 9, 10],
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: problema.numero,
        denominador: problema.divisor,
        tipo: tipo,
        // Etiqueta visual: "24·múlt 6" — al estilo del fragmento
        // divisibilidad pero indicando el fraseado.
        etiquetaDecimal: '${problema.numero}·m${problema.divisor}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.porcentajeCantidad) {
      final problema = GeneradorPorcentajeCantidad(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        // Empaquetamos % en numerador y cantidad en denominador.
        numerador: problema.porcentaje,
        denominador: problema.cantidad,
        tipo: tipo,
        etiquetaDecimal: '${problema.porcentaje}%·${problema.cantidad}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.comparacionMedia) {
      final problema = GeneradorComparacionMedia(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: problema.fraccion.numerador,
        denominador: problema.fraccion.denominador,
        tipo: tipo,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.jerarquia) {
      final problema = GeneradorJerarquia(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      // Empaquetamos los tres operandos en numerador (a), denominador
      // (b), numeradorB (c), y los dos operadores en el campo
      // operador (op2) y decimalA con el símbolo de op1.
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: problema.a,
        denominador: problema.b,
        numeradorB: problema.c,
        tipo: tipo,
        operador: problema.op2,
        decimalA: problema.op1.name,
        etiquetaDecimal:
            '${problema.a}${problema.op1.simbolo}${problema.b}'
            '${problema.op2.simbolo}${problema.c}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.mcmMcd) {
      final modo = modoMcmMcdPreferido == 'mcd'
          ? ModoMcmMcd.mcd
          : ModoMcmMcd.mcm;
      final problema = GeneradorMcmMcd(
        semilla: _azar.nextInt(1 << 30),
      ).generar(modo: modo, dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        // numerador y denominador llevan los dos números a comparar.
        // etiquetaDecimal lleva el modo ('mcm' | 'mcd') para que
        // idHabilidadPrincipal y la pantalla puedan reconstruir.
        numerador: problema.a,
        denominador: problema.b,
        tipo: tipo,
        etiquetaDecimal: modo == ModoMcmMcd.mcd ? 'mcd' : 'mcm',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.ordenarDecimales) {
      final problema = GeneradorOrdenarDecimales(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      // Empaquetamos los tres decimales en decimalA/decimalB/
      // etiquetaDecimal para reconstruir el problema al abrir el
      // Fragmento.
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: 0,
        denominador: 1,
        tipo: tipo,
        decimalA: problema.presentados[0],
        decimalB: problema.presentados[1],
        etiquetaDecimal: '${problema.presentados[0]}|'
            '${problema.presentados[1]}|'
            '${problema.presentados[2]}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.reglaDeTres) {
      final problema = GeneradorReglaDeTres(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      // Empaquetamos los tres términos: a en numerador, b en
      // denominador y c en numeradorB para reconstruir el problema al
      // abrir el Fragmento.
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: problema.a,
        denominador: problema.b,
        numeradorB: problema.c,
        tipo: tipo,
        etiquetaDecimal: '${problema.a}:${problema.b}·${problema.c}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.primo) {
      final problema = GeneradorPrimo(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        // numerador = el número candidato; denominador placeholder.
        numerador: problema.numero,
        denominador: 1,
        tipo: tipo,
        etiquetaDecimal: '${problema.numero}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.comparacionDistinta) {
      final problema = GeneradorComparacionDistinta(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: problema.a.numerador,
        denominador: problema.a.denominador,
        numeradorB: problema.b.numerador,
        denominadorB: problema.b.denominador,
        tipo: tipo,
        etiquetaDecimal:
            '${problema.a.etiqueta} · ${problema.b.etiqueta}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.redondeoDecimal) {
      final problema = GeneradorRedondeoDecimal(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        // numerador/denominador no aplican; el contenido viaja en
        // etiquetaDecimal con el decimal original "e,cc".
        numerador: 0,
        denominador: 1,
        tipo: tipo,
        etiquetaDecimal: problema.etiquetaOriginal,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.mixtoAImpropio) {
      final problema = GeneradorMixtoAImpropio(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        // Empaquetamos el mixto en numerador/denominador como (e*d+n)/d
        // y dejamos el entero en numeradorB para reconstruirlo.
        numerador: problema.entero * problema.denominador + problema.numerador,
        denominador: problema.denominador,
        numeradorB: problema.entero,
        tipo: tipo,
        etiquetaDecimal: '${problema.entero} ${problema.numerador}/'
            '${problema.denominador}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.lecturaFraccion) {
      final problema = GeneradorLecturaFraccion(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        // numerador/denominador no aplican: el contenido pedagógico
        // viaja en `etiquetaDecimal` (texto en palabras). Mantenemos la
        // simetría con [TipoFragmentoEnTejado.lecturaDecimal].
        numerador: 0,
        denominador: 1,
        tipo: tipo,
        etiquetaDecimal: problema.texto,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.comparacionUnidad) {
      final problema = GeneradorComparacionUnidad(
        semilla: _azar.nextInt(1 << 30),
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: problema.fraccion.numerador,
        denominador: problema.fraccion.denominador,
        tipo: tipo,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.divisibilidad) {
      final problema = GeneradorDivisibilidad(
        semilla: _azar.nextInt(1 << 30),
        divisoresPermitidos:
            divisoresPermitidos ?? const [2, 3, 5, 10],
      ).generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        // Reusamos numerador/denominador como contenedores: numerador
        // = número candidato, denominador = divisor.
        numerador: problema.numero,
        denominador: problema.divisor,
        tipo: tipo,
        etiquetaDecimal: '${problema.numero}÷${problema.divisor}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.amplificar) {
      final problema = GeneradorAmplificar(semilla: _azar.nextInt(1 << 30))
          .generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: problema.base.numerador,
        denominador: problema.base.denominador,
        // Reutilizamos denominadorB para llevar el denominador objetivo
        // hasta la pantalla — no hay segunda fracción aquí.
        denominadorB: problema.denominadorObjetivo,
        tipo: tipo,
        etiquetaDecimal:
            '${problema.base.etiqueta}=?/${problema.denominadorObjetivo}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.simplificar) {
      final problema = GeneradorSimplificar(semilla: _azar.nextInt(1 << 30))
          .generar(dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: problema.objetivo.numerador,
        denominador: problema.objetivo.denominador,
        tipo: tipo,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.comparacion) {
      final modo = modoComparacionPreferido ??
          (_azar.nextBool()
              ? ModoComparacion.mismoDenominador
              : ModoComparacion.mismoNumerador);
      final problema = GeneradorComparacion(semilla: _azar.nextInt(1 << 30))
          .generar(modo: modo, dificultad: dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: problema.a.numerador,
        denominador: problema.a.denominador,
        numeradorB: problema.b.numerador,
        denominadorB: problema.b.denominador,
        tipo: tipo,
        modoComparacion: modo,
        etiquetaDecimal:
            '${problema.a.etiqueta} · ${problema.b.etiqueta}',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.decimal) {
      final decimalElegido =
          decimalesConocidos[_azar.nextInt(decimalesConocidos.length)];
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: decimalElegido.fraccionEquivalente.numerador,
        denominador: decimalElegido.fraccionEquivalente.denominador,
        tipo: tipo,
        etiquetaDecimal: decimalElegido.etiqueta,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.porcentaje) {
      final porcentajeElegido =
          porcentajesConocidos[_azar.nextInt(porcentajesConocidos.length)];
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: porcentajeElegido.fraccionEquivalente.numerador,
        denominador: porcentajeElegido.fraccionEquivalente.denominador,
        tipo: tipo,
        etiquetaDecimal: porcentajeElegido.etiqueta,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.impropio) {
      final denominadorImp = _elegirDenominadorImpropio(dificultad);
      final numeradorImp = _elegirNumeradorImpropio(denominadorImp, dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: numeradorImp,
        denominador: denominadorImp,
        tipo: tipo,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.proporcional) {
      // Una razón "a:b" con a,b pequeños; el numerador/denominador del
      // Fragmento almacenan esos valores para que la pantalla use la
      // misma razón mostrada en el tejado.
      final a = 2 + _azar.nextInt(6);
      final b = 3 + _azar.nextInt(7);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: a,
        denominador: b,
        tipo: tipo,
        etiquetaDecimal: '$a:$b',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.operacionDecimal) {
      final (textoA, textoB, operador) = _elegirOperacionDecimal(
        dificultad,
        operadorPreferido: operadorPreferido,
        segundoNatural: segundoOperandoNatural,
      );
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: 0,
        denominador: 1,
        tipo: tipo,
        operador: operador,
        decimalA: textoA,
        decimalB: textoB,
        etiquetaDecimal: '$textoA${operador.simbolo}$textoB',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.dual) {
      final operador = operadorPreferido ?? _elegirOperadorDual(dificultad);
      final (numA, denA, numB, denB) = _elegirSumandosDual(
        dificultad,
        operador,
        segundoNatural: segundoOperandoNatural,
      );
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: numA,
        denominador: denA,
        numeradorB: numB,
        denominadorB: denB,
        tipo: tipo,
        operador: operador,
        etiquetaDecimal:
            '$numA/$denA${operador.simbolo}$numB/$denB',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    final denominador = tipo == TipoFragmentoEnTejado.espejo
        ? _elegirDenominadorEspejo(dificultad)
        : _elegirDenominador(dificultad);
    final numerador = tipo == TipoFragmentoEnTejado.espejo
        ? _elegirNumeradorEspejo(denominador, dificultad)
        : _elegirNumerador(denominador, dificultad);

    return FragmentoEnTejado(
      identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
          '${_azar.nextInt(9999)}',
      numerador: numerador,
      denominador: denominador,
      tipo: tipo,
      xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
      yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
      instanteAparicion: ahora,
      tiempoDeVida: _tiempoDeVida(dificultad),
    );
  }

  /// Decide qué tipo de Fragmento aparece según el nivel.
  ///
  /// - Dificultad < 2: solo unitarios (el niño aún se hace al gesto).
  /// - Dificultad 2-3: aparecen Espejos.
  /// - Dificultad 3+: también aparecen Decimales.
  TipoFragmentoEnTejado _elegirTipo(int dificultad) {
    if (dificultad < 2) return TipoFragmentoEnTejado.unitario;

    final probEspejo = switch (dificultad) {
      2 => 0.18,
      3 => 0.2,
      4 => 0.22,
      5 => 0.22,
      6 => 0.24,
      _ => 0.26,
    };
    final probDecimal = dificultad < 3
        ? 0.0
        : switch (dificultad) {
            3 => 0.12,
            4 => 0.14,
            5 => 0.15,
            6 => 0.17,
            _ => 0.18,
          };
    final probPorcentaje = dificultad < 3
        ? 0.0
        : switch (dificultad) {
            3 => 0.1,
            4 => 0.12,
            5 => 0.13,
            6 => 0.14,
            _ => 0.15,
          };
    final probImpropio = dificultad < 4
        ? 0.0
        : switch (dificultad) {
            4 => 0.1,
            5 => 0.11,
            6 => 0.12,
            _ => 0.13,
          };
    final probProporcional = dificultad < 5
        ? 0.0
        : switch (dificultad) {
            5 => 0.07,
            6 => 0.09,
            _ => 0.1,
          };
    final probDual = dificultad < 5
        ? 0.0
        : switch (dificultad) {
            5 => 0.08,
            6 => 0.09,
            _ => 0.1,
          };
    final probOperacionDecimal = dificultad < 5
        ? 0.0
        : switch (dificultad) {
            5 => 0.06,
            6 => 0.08,
            _ => 0.1,
          };

    final tirada = _azar.nextDouble();
    var umbral = probEspejo;
    if (tirada < umbral) return TipoFragmentoEnTejado.espejo;
    umbral += probDecimal;
    if (tirada < umbral) return TipoFragmentoEnTejado.decimal;
    umbral += probPorcentaje;
    if (tirada < umbral) return TipoFragmentoEnTejado.porcentaje;
    umbral += probImpropio;
    if (tirada < umbral) return TipoFragmentoEnTejado.impropio;
    umbral += probProporcional;
    if (tirada < umbral) return TipoFragmentoEnTejado.proporcional;
    umbral += probDual;
    if (tirada < umbral) return TipoFragmentoEnTejado.dual;
    umbral += probOperacionDecimal;
    if (tirada < umbral) return TipoFragmentoEnTejado.operacionDecimal;
    return TipoFragmentoEnTejado.unitario;
  }

  /// Elige una operación decimal al azar: dos decimales amigables
  /// y un operador. Los resultados son decimales limpios por diseño
  /// (el generador de la pantalla re-evalúa desde los valores dados).
  (String, String, OperadorAritmetico) _elegirOperacionDecimal(
    int dificultad, {
    OperadorAritmetico? operadorPreferido,
    bool segundoNatural = false,
  }) {
    final operadoresPorDificultad = <OperadorAritmetico>[
      OperadorAritmetico.suma,
      OperadorAritmetico.resta,
      if (dificultad >= 5) OperadorAritmetico.producto,
      if (dificultad >= 6) OperadorAritmetico.division,
    ];
    final operador = operadorPreferido != null &&
            operadoresPorDificultad.contains(operadorPreferido)
        ? operadorPreferido
        : operadoresPorDificultad[
            _azar.nextInt(operadoresPorDificultad.length)];

    // Curado corto de casos por operador.
    switch (operador) {
      case OperadorAritmetico.suma:
        const pares = [
          ('0,5', '0,3'),
          ('0,25', '0,75'),
          ('0,1', '0,9'),
          ('1,2', '0,8'),
          ('0,6', '0,3'),
          ('1,5', '2,5'),
        ];
        final par = pares[_azar.nextInt(pares.length)];
        return (par.$1, par.$2, operador);
      case OperadorAritmetico.resta:
        const pares = [
          ('0,8', '0,3'),
          ('1,0', '0,25'),
          ('2,5', '1,2'),
          ('0,75', '0,25'),
          ('1,5', '0,3'),
        ];
        final par = pares[_azar.nextInt(pares.length)];
        return (par.$1, par.$2, operador);
      case OperadorAritmetico.producto:
        // Pares decimal × decimal (caso general DEC.06).
        const paresDecimal = [
          ('0,5', '0,4'),
          ('0,3', '0,6'),
          ('0,2', '0,5'),
          ('1,5', '0,2'),
          ('2,5', '0,4'),
        ];
        // Pares decimal × natural (DEC.05) — el segundo factor es
        // un entero sin coma, como pide el catálogo.
        const paresConNatural = [
          ('0,25', '4'),
          ('0,5', '6'),
          ('1,5', '3'),
          ('0,2', '7'),
          ('2,3', '5'),
          ('0,75', '2'),
        ];
        final pool = segundoNatural ? paresConNatural : paresDecimal;
        final par = pool[_azar.nextInt(pool.length)];
        return (par.$1, par.$2, operador);
      case OperadorAritmetico.division:
        const pares = [
          ('1,5', '3'),
          ('2,4', '2'),
          ('4,5', '5'),
          ('0,8', '4'),
          ('1,2', '0,4'),
          ('2,0', '0,5'),
        ];
        final par = pares[_azar.nextInt(pares.length)];
        return (par.$1, par.$2, operador);
    }
  }

  /// Elige un tipo respetando la mezcla del [Distrito]. Si el distrito
  /// pide un tipo que aún no se ha desbloqueado por dificultad (p. ej.
  /// el Mercado pide porcentajes pero estamos en dificultad 1), caemos
  /// al reparto general para que el niño no se quede sin Fragmentos en
  /// sus primeras visitas.
  TipoFragmentoEnTejado _elegirTipoSegunDistrito(
    Distrito distritoElegido,
    int dificultad,
  ) {
    final pesoTotal = distritoElegido.mezclaPuzzles.values
        .fold<double>(0, (acum, peso) => acum + peso);
    if (pesoTotal <= 0) return _elegirTipo(dificultad);

    final tirada = _azar.nextDouble() * pesoTotal;
    var acumulado = 0.0;
    for (final entrada in distritoElegido.mezclaPuzzles.entries) {
      acumulado += entrada.value;
      if (tirada < acumulado) {
        // Comprobamos que el tipo esté disponible por dificultad; si no,
        // nos quedamos con unitario en su lugar.
        if (_tipoDisponibleEnDificultad(entrada.key, dificultad)) {
          return entrada.key;
        }
        return TipoFragmentoEnTejado.unitario;
      }
    }
    return TipoFragmentoEnTejado.unitario;
  }

  bool _tipoDisponibleEnDificultad(
    TipoFragmentoEnTejado tipo,
    int dificultad,
  ) {
    switch (tipo) {
      case TipoFragmentoEnTejado.unitario:
        return true;
      case TipoFragmentoEnTejado.comparacion:
        // FR.05/FR.06 se introducen pronto (Aprendiz II); disponible
        // desde el primer tier adaptativo.
        return dificultad >= 1;
      case TipoFragmentoEnTejado.simplificar:
        // FR.10 entra al principio del Iniciado I — un pelín más tarde
        // que la equivalencia libre de FR.09.
        return dificultad >= 2;
      case TipoFragmentoEnTejado.amplificar:
        // FR.11 acompaña a FR.09 (equivalencia) — disponible cuando ya
        // se conoce la mecánica de equivalencia básica.
        return dificultad >= 2;
      case TipoFragmentoEnTejado.divisibilidad:
        // DIV.03 entra antes (Aprendiz III): mecánica binaria muy
        // accesible aunque sea la primera vez.
        return dificultad >= 1;
      case TipoFragmentoEnTejado.multiplos:
        // DIV.01 (concepto de múltiplo) entra a la vez que DIV.03 —
        // misma mecánica, sin necesidad de criterios memorizados.
        return dificultad >= 1;
      case TipoFragmentoEnTejado.comparacionDecimal:
        // DEC.02 entra a partir del Iniciado I.
        return dificultad >= 2;
      case TipoFragmentoEnTejado.lecturaDecimal:
        // DEC.01 es la primera habilidad de decimales — entra antes,
        // a tier 1 (Aprendiz III).
        return dificultad >= 1;
      case TipoFragmentoEnTejado.comparacionUnidad:
        // FR.04 entra cuando ya entiende fracciones simples — más fácil
        // que comparar dos fracciones, le abre los ojos a las impropias.
        return dificultad >= 1;
      case TipoFragmentoEnTejado.lecturaFraccion:
        // FR.02 es la primera habilidad de fracciones después de FR.01;
        // entra desde el primer tier para que aparezca pronto.
        return dificultad >= 1;
      case TipoFragmentoEnTejado.mixtoAImpropio:
        // FR.13 va a la par que FR.12 (impropio → mixto, ya en tier 3).
        return dificultad >= 3;
      case TipoFragmentoEnTejado.redondeoDecimal:
        // DEC.09 entra cuando el niño ya domina lectura y comparación
        // de decimales — antes le pides redondear sin saber leer.
        return dificultad >= 2;
      case TipoFragmentoEnTejado.comparacionDistinta:
        // FR.07 va después de FR.05/FR.06 — pide cálculo, no atajos.
        return dificultad >= 2;
      case TipoFragmentoEnTejado.primo:
        // DIV.05 entra pronto — mecánica binaria muy accesible aunque
        // los casos confusos exigen memoria.
        return dificultad >= 1;
      case TipoFragmentoEnTejado.reglaDeTres:
        // PROP.03 entra cuando el niño ya domina razón básica
        // (PROP.02). Es el segundo escalón de proporcionalidad.
        return dificultad >= 3;
      case TipoFragmentoEnTejado.ordenarDecimales:
        // DEC.03 entra cuando el niño ya domina la comparación
        // binaria (DEC.02, tier 2).
        return dificultad >= 2;
      case TipoFragmentoEnTejado.mcmMcd:
        // DIV.06/DIV.07 son Iniciado II — entran tras dominar
        // divisibilidad y primos.
        return dificultad >= 3;
      case TipoFragmentoEnTejado.jerarquia:
        // OP.01 introduce la prioridad de operaciones en Aprendiz III.
        return dificultad >= 2;
      case TipoFragmentoEnTejado.comparacionMedia:
        // FR.03 es de las primeras habilidades de fracciones — entra
        // desde el primer tier para que aparezca pronto.
        return dificultad >= 1;
      case TipoFragmentoEnTejado.porcentajeCantidad:
        // PROP.04 entra cuando el niño ya tiene base de fracciones y
        // decimales — cálculo, no reconocimiento.
        return dificultad >= 3;
      case TipoFragmentoEnTejado.espejo:
        return dificultad >= 1;
      case TipoFragmentoEnTejado.decimal:
      case TipoFragmentoEnTejado.porcentaje:
        return dificultad >= 2;
      case TipoFragmentoEnTejado.impropio:
        return dificultad >= 3;
      case TipoFragmentoEnTejado.proporcional:
      case TipoFragmentoEnTejado.dual:
      case TipoFragmentoEnTejado.operacionDecimal:
        return dificultad >= 4;
    }
  }

  /// Elige un operador para el Dual según la dificultad: en niveles
  /// medios solo suma y resta; producto y división aparecen cuando el
  /// niño ya domina las bases.
  OperadorAritmetico _elegirOperadorDual(int dificultad) {
    final candidatos = <OperadorAritmetico>[
      OperadorAritmetico.suma,
      OperadorAritmetico.suma,
    ];
    if (dificultad >= 4) candidatos.add(OperadorAritmetico.resta);
    if (dificultad >= 5) candidatos.add(OperadorAritmetico.producto);
    if (dificultad >= 6) candidatos.add(OperadorAritmetico.division);
    return candidatos[_azar.nextInt(candidatos.length)];
  }

  /// Dos fracciones para una operación dual. Los denominadores suelen
  /// ser distintos (aunque producto y división no lo exigen) y los
  /// numeradores menores que sus denominadores para mantener el
  /// problema en rango de primaria.
  (int, int, int, int) _elegirSumandosDual(
    int dificultad,
    OperadorAritmetico operador, {
    bool segundoNatural = false,
  }) {
    final denominadoresPosibles = dificultad < 6
        ? const [2, 3, 3, 4, 4, 5, 6]
        : const [3, 4, 5, 6, 6, 8, 10, 12];
    final denA =
        denominadoresPosibles[_azar.nextInt(denominadoresPosibles.length)];
    int denB;
    final debeSerDistinto =
        operador == OperadorAritmetico.suma ||
            operador == OperadorAritmetico.resta;
    if (segundoNatural) {
      // FR.18 / FR.20: el segundo operando es un natural pequeño
      // (numB en [2,5]), denB = 1 — la pantalla detecta denB==1 y
      // muestra el natural sin barra de fracción.
      denB = 1;
    } else if (debeSerDistinto) {
      do {
        denB = denominadoresPosibles[
            _azar.nextInt(denominadoresPosibles.length)];
      } while (denB == denA);
    } else {
      denB = denominadoresPosibles[
          _azar.nextInt(denominadoresPosibles.length)];
    }
    final numA = 1 + _azar.nextInt(math.max(1, denA - 1));
    var numB = segundoNatural
        ? 2 + _azar.nextInt(4)
        : 1 + _azar.nextInt(math.max(1, denB - 1));
    // Si es resta, nos aseguramos que el minuendo sea mayor que el
    // sustraendo para no entrar en negativos.
    if (operador == OperadorAritmetico.resta) {
      final valorA = numA / denA;
      final valorB = numB / denB;
      if (valorA < valorB) {
        // Intercambiamos.
        return (numB, denB, numA, denA);
      }
    }
    return (numA, denA, numB, denB);
  }

  int _elegirDenominadorImpropio(int dificultad) {
    final candidatos = <int>[2, 3, 3, 4, 4, 5];
    if (dificultad >= 5) candidatos.addAll([6, 7]);
    if (dificultad >= 6) candidatos.addAll([8, 9]);
    return candidatos[_azar.nextInt(candidatos.length)];
  }

  int _elegirNumeradorImpropio(int denominador, int dificultad) {
    // Impropia: numerador > denominador. Cota superior más modesta para
    // que la parte entera no sea demasiado grande (1-3).
    final minimo = denominador + 1;
    final maximoBase = denominador * 3;
    final maximo = maximoBase - (_azar.nextInt(2));
    return minimo + _azar.nextInt(math.max(1, maximo - minimo));
  }

  /// Para Espejos interesa más variedad de denominadores pequeños
  /// (2, 3, 4, 5, 6, 8, 10) — equivalencias claras.
  int _elegirDenominadorEspejo(int dificultad) {
    final candidatos = <int>[2, 3, 4, 4, 5, 6, 6, 8];
    if (dificultad >= 3) candidatos.addAll([10, 10, 12]);
    if (dificultad >= 5) candidatos.addAll([9, 15]);
    return candidatos[_azar.nextInt(candidatos.length)];
  }

  /// En Espejos el numerador puede ser cualquiera < denominador. Al
  /// mostrar la fracción objetivo queremos que sea reducible y llamativa.
  int _elegirNumeradorEspejo(int denominador, int dificultad) {
    if (denominador <= 2) return 1;
    return 1 + _azar.nextInt(denominador - 1);
  }

  /// Nivel de dificultad creciente sin tope. Cada "tier" mete
  /// denominadores más grandes, primos más frecuentes y compuestos
  /// más cerca de 1 (7/8, 11/12) para el niño avanzado.
  int _nivelDificultadSegunEsquirlas(int esquirlas) {
    if (esquirlas < 4) return 0;
    if (esquirlas < 10) return 1;
    if (esquirlas < 20) return 2;
    if (esquirlas < 35) return 3;
    if (esquirlas < 55) return 4;
    if (esquirlas < 80) return 5;
    if (esquirlas < 120) return 6;
    return 7;
  }

  int _elegirDenominador(int dificultad) {
    final candidatos = <int>[];
    switch (dificultad) {
      case 0:
        candidatos.addAll([2, 2, 3]);
        break;
      case 1:
        candidatos.addAll([2, 3, 3, 4, 5]);
        break;
      case 2:
        candidatos.addAll([2, 3, 4, 4, 5, 5, 6, 7]);
        break;
      case 3:
        candidatos.addAll([3, 4, 5, 5, 6, 6, 7, 8, 9]);
        break;
      case 4:
        candidatos.addAll([4, 5, 6, 7, 7, 8, 9, 10, 11]);
        break;
      case 5:
        candidatos.addAll([5, 6, 7, 8, 9, 10, 11, 11, 12]);
        break;
      case 6:
        candidatos.addAll([7, 8, 9, 10, 11, 12, 12]);
        break;
      case 7:
      default:
        // Territorio del Fraccionista avanzado: solo denominadores
        // grandes, muchos primos.
        candidatos.addAll([7, 9, 11, 11, 12, 13]);
    }
    return candidatos[_azar.nextInt(candidatos.length)];
  }

  int _elegirNumerador(int denominador, int dificultad) {
    if (denominador <= 2) return 1;
    if (dificultad < 2) return 1;

    // Probabilidad creciente de compuesto con el nivel.
    final probCompuesto = switch (dificultad) {
      2 => 0.33,
      3 => 0.42,
      4 => 0.5,
      5 => 0.58,
      6 => 0.65,
      _ => 0.7,
    };
    if (_azar.nextDouble() >= probCompuesto) return 1;

    // Compuesto: a niveles altos el numerador tiende al máximo
    // (7/8, 11/12) para que el compuesto se sienta casi-entero.
    final maximoNumerador = denominador - 1;
    if (dificultad >= 5 && _azar.nextInt(3) == 0) {
      return maximoNumerador; // caso extremo 7/8, 11/12
    }
    return 2 + _azar.nextInt(maximoNumerador - 1);
  }

  /// Tiempo de vida del Fragmento antes de empezar a escapar.
  /// A mayor dificultad, menos margen — el Fraccionista avanzado
  /// tiene que ser más rápido.
  Duration _tiempoDeVida(int dificultad) {
    const msBase = 16000;
    final msVariacion = 7000 - dificultad * 500;
    const msMinimo = 7000;
    final msDisponibles = math.max(msMinimo, msBase - dificultad * 1200);
    final ms = msDisponibles + _azar.nextInt(math.max(1, msVariacion));
    return Duration(milliseconds: ms);
  }
}
