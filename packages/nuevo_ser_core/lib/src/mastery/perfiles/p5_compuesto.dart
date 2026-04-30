import '../habilidad.dart';

/// Componente del perfil P5. Cada habilidad usa un subconjunto de los
/// cuatro: la mezcla concreta + pesos viven en el catálogo de
/// habilidades del juego (`content/el-cuaderno/skills-mvp.json`).
enum ComponenteP5 {
  /// Aciertos vs intentos en preguntas con respuesta única correcta —
  /// las habilidades TAX y CIC del catálogo de El Cuaderno.
  precision,

  /// Evaluación cualitativa muestreada por el tutor IA en escala 0-3
  /// (normalizada a [0, 1]). Pedagogía de OBS y REG.
  rubrica,

  /// Variedad de contextos en los que apareció la habilidad respecto a
  /// los esperados. Se usa en HAB, REL y TEJ — no basta saber: hay que
  /// haberlo visto en contextos distintos.
  cobertura,

  /// Indicadores indirectos del comportamiento — regularidad de
  /// visitas al sit spot, persistencia con un Misterio, etc. Aplicado
  /// por habilidades del dominio PRE.
  proxy,
}

/// Mediciones brutas para una habilidad concreta. Cada valor está en
/// el rango natural de su componente (los valores se normalizan
/// dentro del perfil); `componentesPresentes` declara cuáles de los
/// cuatro están realmente medidos.
///
/// El llamante construye este objeto a partir del estado persistido
/// del niño (intentos puzzle, evaluaciones del tutor, registros de
/// presencia) en el momento de calcular el nivel.
class MedicionesP5 {
  /// Precisión bruta — proporción de aciertos ponderada por dificultad,
  /// rango [0, 1]. Se reusa el cálculo de P1.
  final double? precision;

  /// Media de la rúbrica del tutor en escala 0-3.
  final double? rubricaMedia;

  /// Contextos distintos vistos por el niño. Se normaliza dividiendo
  /// por [coberturaContextosEsperados].
  final int? coberturaContextosVistos;
  final int? coberturaContextosEsperados;

  /// Indicador proxy en rango [0, 1] (la habilidad concreta decide qué
  /// significa). Por ejemplo, regularidad temporal de visitas al sit
  /// spot a lo largo de las últimas semanas.
  final double? proxy;

  /// Histórico abreviado para los umbrales adaptativos.
  final HistoricoP5 historico;

  const MedicionesP5({
    required this.historico,
    this.precision,
    this.rubricaMedia,
    this.coberturaContextosVistos,
    this.coberturaContextosEsperados,
    this.proxy,
  });

  /// Componentes con dato útil para el cálculo. El perfil ignora los
  /// que la habilidad declara aplicables pero el niño no ha tocado
  /// todavía — equivalen a un score 0 en ese componente.
  Set<ComponenteP5> get componentesPresentes => {
        if (precision != null) ComponenteP5.precision,
        if (rubricaMedia != null) ComponenteP5.rubrica,
        if (coberturaContextosVistos != null &&
            coberturaContextosEsperados != null &&
            coberturaContextosEsperados! > 0)
          ComponenteP5.cobertura,
        if (proxy != null) ComponenteP5.proxy,
      };
}

/// Indicadores que alimentan los umbrales adaptativos: cuántas
/// sesiones lleva, cuántas semanas distintas, retención (estaciones
/// distintas que han atravesado el aprendizaje), transferencia (casos
/// fuera del contexto de entrenamiento original).
class HistoricoP5 {
  final int sesiones;
  final int semanasDistintas;
  final int estacionesDistintas;
  final bool transferenciaConfirmada;

  const HistoricoP5({
    this.sesiones = 0,
    this.semanasDistintas = 0,
    this.estacionesDistintas = 0,
    this.transferenciaConfirmada = false,
  });
}

/// Pesos de cada componente para una habilidad concreta. Deben sumar
/// (con tolerancia eps=1e-6) 1.0; el constructor lo verifica.
class PesosP5 {
  final Map<ComponenteP5, double> _pesos;

  PesosP5(Map<ComponenteP5, double> pesos)
      : _pesos = Map.unmodifiable(pesos) {
    if (_pesos.isEmpty) {
      throw ArgumentError('PesosP5 necesita al menos un componente');
    }
    for (final peso in _pesos.values) {
      if (peso < 0 || peso > 1) {
        throw ArgumentError.value(
          peso,
          'pesos',
          'cada peso debe estar en [0, 1]',
        );
      }
    }
    final suma = _pesos.values.fold<double>(0, (a, b) => a + b);
    if ((suma - 1.0).abs() > 1e-6) {
      throw ArgumentError.value(
        suma,
        'pesos',
        'los pesos deben sumar 1.0 (suman $suma)',
      );
    }
  }

  Set<ComponenteP5> get componentesAplicables => _pesos.keys.toSet();

  double pesoDe(ComponenteP5 componente) => _pesos[componente] ?? 0.0;
}

/// Resultado del cálculo P5: nivel + score compuesto + breakdown por
/// componente. La UI puede usar el breakdown para explicar al
/// didacta/cuidador POR QUÉ está el niño donde está, sin enseñárselo
/// al propio niño (biblia §2: maestría observable, no declarada).
class ResultadoP5 {
  final NivelMaestria nivel;
  final double scoreCompuesto;
  final Map<ComponenteP5, double> scoresNormalizados;

  const ResultadoP5({
    required this.nivel,
    required this.scoreCompuesto,
    required this.scoresNormalizados,
  });
}

/// Umbrales del perfil P5 (doc 03 §4.2). Adaptativos: además del
/// score compuesto, exigen volumen mínimo de práctica + retención +
/// transferencia para los niveles altos.
class UmbralesP5 {
  final double scoreIntroducida;
  final int sesionesIntroducida;

  final double scoreEnDesarrollo;
  final int sesionesEnDesarrollo;
  final int semanasDistintasEnDesarrollo;

  final double scoreCompetente;
  final int estacionesCompetente;

  final double scoreMaestria;
  final int estacionesMaestria;
  final bool exigeTransferenciaMaestria;

  const UmbralesP5({
    this.scoreIntroducida = 0.30,
    this.sesionesIntroducida = 3,
    this.scoreEnDesarrollo = 0.50,
    this.sesionesEnDesarrollo = 7,
    this.semanasDistintasEnDesarrollo = 2,
    this.scoreCompetente = 0.75,
    this.estacionesCompetente = 1,
    this.scoreMaestria = 0.90,
    this.estacionesMaestria = 2,
    this.exigeTransferenciaMaestria = true,
  });

  static const UmbralesP5 elCuadernoMvp = UmbralesP5();
}

/// Perfil de medición compuesto. **Doc 03 §4** (El Cuaderno):
/// combina hasta cuatro componentes con pesos por habilidad y
/// umbrales adaptativos.
///
/// Esta clase es **pura**: no toca reloj ni almacenamiento. La
/// integración con el motor adaptativo (que sí persiste) la hará el
/// orquestador del juego — P5 no encaja del todo con `MasteryProfile`
/// porque su unidad de entrada no es un intento individual sino el
/// estado completo de las cuatro mediciones agregadas.
class PerfilP5Compuesto {
  final UmbralesP5 umbrales;

  const PerfilP5Compuesto({this.umbrales = UmbralesP5.elCuadernoMvp});

  /// Calcula el nivel y el score compuesto a partir de las mediciones
  /// y los pesos declarados por la habilidad.
  ///
  /// Componentes que estén en [pesos] pero ausentes de
  /// [mediciones.componentesPresentes] se cuentan como score 0 en ese
  /// componente — el niño todavía no ha demostrado nada en esa
  /// dimensión. El llamante puede filtrar antes si prefiere otra
  /// política.
  ResultadoP5 calcular({
    required MedicionesP5 mediciones,
    required PesosP5 pesos,
  }) {
    final scoresNormalizados = <ComponenteP5, double>{};
    var scoreCompuesto = 0.0;

    for (final componente in pesos.componentesAplicables) {
      final crudo = _normalizar(componente, mediciones);
      scoresNormalizados[componente] = crudo;
      scoreCompuesto += crudo * pesos.pesoDe(componente);
    }

    final nivel = _nivelDesdeScore(scoreCompuesto, mediciones.historico);

    return ResultadoP5(
      nivel: nivel,
      scoreCompuesto: scoreCompuesto,
      scoresNormalizados: Map.unmodifiable(scoresNormalizados),
    );
  }

  double _normalizar(ComponenteP5 componente, MedicionesP5 m) {
    switch (componente) {
      case ComponenteP5.precision:
        return _clamp01(m.precision ?? 0);
      case ComponenteP5.rubrica:
        // Rúbrica viene en escala 0-3 → normalizamos a [0, 1].
        final media = m.rubricaMedia ?? 0;
        return _clamp01(media / 3);
      case ComponenteP5.cobertura:
        final vistos = m.coberturaContextosVistos ?? 0;
        final esperados = m.coberturaContextosEsperados ?? 0;
        if (esperados <= 0) return 0;
        return _clamp01(vistos / esperados);
      case ComponenteP5.proxy:
        return _clamp01(m.proxy ?? 0);
    }
  }

  NivelMaestria _nivelDesdeScore(double score, HistoricoP5 hist) {
    if (score >= umbrales.scoreMaestria &&
        hist.estacionesDistintas >= umbrales.estacionesMaestria &&
        (!umbrales.exigeTransferenciaMaestria ||
            hist.transferenciaConfirmada)) {
      return NivelMaestria.maestria;
    }
    if (score >= umbrales.scoreCompetente &&
        hist.estacionesDistintas >= umbrales.estacionesCompetente) {
      return NivelMaestria.competente;
    }
    if (score >= umbrales.scoreEnDesarrollo &&
        hist.sesiones >= umbrales.sesionesEnDesarrollo &&
        hist.semanasDistintas >= umbrales.semanasDistintasEnDesarrollo) {
      return NivelMaestria.enDesarrollo;
    }
    if (score >= umbrales.scoreIntroducida &&
        hist.sesiones >= umbrales.sesionesIntroducida) {
      return NivelMaestria.introducida;
    }
    return NivelMaestria.inexplorada;
  }

  static double _clamp01(double valor) {
    if (valor.isNaN) return 0;
    if (valor < 0) return 0;
    if (valor > 1) return 1;
    return valor;
  }
}
