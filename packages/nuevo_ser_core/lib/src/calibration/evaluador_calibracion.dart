import 'nivel_confianza.dart';

/// Cálculo de calibración epistémica genérico (perfil P4 Brier del
/// motor adaptativo). Se usa cuando un juego pide a la persona
/// usuaria que ancle afirmaciones declarando un [NivelConfianza] y
/// quiere comparar lo declarado con la calibración canónica para
/// puntuar la metacognición — corazón pedagógico de Las Versiones
/// (AH.03) y susceptible de uso en otros juegos de la Colección.
///
/// Este módulo NO está cableado al motor adaptativo `MasteryProfile`
/// todavía. Vive en el core como utilitario genérico para que cada
/// juego lo use desde su pantalla de "concilio" o equivalente. La
/// integración con `P4Calibration.compute()` es trabajo posterior
/// — antes hay que extender `SessionPayload` con la metadata
/// necesaria (nivel declarado / nivel canónico por intento).
///
/// Modelo: para cada afirmación tratamos los tres [NivelConfianza]
/// como una distribución de probabilidad. La elección de la persona
/// usuaria equivale a una predicción "dura" (1 en el nivel elegido,
/// 0 en los otros); la calibración correcta del catálogo equivale a
/// la observación dura. El score Brier multiclass es:
///
///     B = Σ_i (predicción_i - observación_i)²
///
/// que con predicciones duras y 3 niveles está en {0, 2}. Lo
/// normalizamos a [0, 1] dividiendo por el máximo posible (2):
///
///     score = 1 - (B / 2)
///
/// 1 = calibración perfecta (acertó el nivel), 0 = calibración mala.
/// El espejo PHP del plugin (`NS_Calibracion::score_brier_normalizado`)
/// usa exactamente esta fórmula. Ver fixture
/// `nuevo_ser_core/test/fixtures/calibracion_brier.json`.

/// Resultado de comparar una predicción individual con su observación.
class CalibracionAfirmacion {
  final NivelConfianza nivelCorrecto;
  final NivelConfianza nivelDeclarado;

  const CalibracionAfirmacion({
    required this.nivelCorrecto,
    required this.nivelDeclarado,
  });

  /// Score Brier normalizado en [0, 1] — `1.0` si acierta, `0.0` si
  /// declara un nivel distinto del correcto. Con la formulación
  /// hard-vs-hard sólo hay dos resultados, pero la fórmula está
  /// preparada para que cuando se admita predicción suave (mapas
  /// de probabilidad explícitos) el cálculo siga siendo el mismo.
  double get scoreNormalizado {
    const brierMax = 2.0;
    var brier = 0.0;
    for (final nivel in NivelConfianza.values) {
      final prediccion = nivel == nivelDeclarado ? 1.0 : 0.0;
      final observacion = nivel == nivelCorrecto ? 1.0 : 0.0;
      final diferencia = prediccion - observacion;
      brier += diferencia * diferencia;
    }
    return 1.0 - (brier / brierMax);
  }

  bool get acierta => nivelCorrecto == nivelDeclarado;
}

/// Resultado agregado sobre un conjunto de afirmaciones — útil para
/// presentar el cierre de una "Brecha" o equivalente.
class ResultadoCalibracion {
  final List<CalibracionAfirmacion> porAfirmacion;

  const ResultadoCalibracion({required this.porAfirmacion});

  int get totalAfirmaciones => porAfirmacion.length;

  int get aciertos => porAfirmacion.where((c) => c.acierta).length;

  /// Promedio del score normalizado en [0, 1]. Si la lista está
  /// vacía devuelve `0.0` — el llamante debe interpretar ese caso
  /// como "todavía no hay datos".
  double get scoreMedio {
    if (porAfirmacion.isEmpty) return 0.0;
    var suma = 0.0;
    for (final calibracion in porAfirmacion) {
      suma += calibracion.scoreNormalizado;
    }
    return suma / porAfirmacion.length;
  }
}

/// Evaluador puro. Consume pares (correcto, declarado) ya emparejados
/// — el juego que llama es responsable de filtrar las afirmaciones
/// sin nivel asignado antes de invocarlo.
class EvaluadorCalibracion {
  const EvaluadorCalibracion();

  ResultadoCalibracion evaluar(List<CalibracionAfirmacion> calibraciones) {
    return ResultadoCalibracion(porAfirmacion: calibraciones);
  }
}
