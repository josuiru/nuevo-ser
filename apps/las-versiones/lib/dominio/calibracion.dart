import 'brecha.dart';

/// Cálculo de calibración epistémica (perfil P4 del motor adaptativo)
/// para AH.03 — declaración de niveles de confianza. Es el corazón
/// pedagógico del juego (doc 14 §1 y §3): no se premia tener razón,
/// se premia haber juzgado bien con lo disponible.
///
/// Esta versión local del cálculo Brier vive aquí mientras P4 sigue
/// como stub en `nuevo_ser_core`. Cuando F7 extraiga el motor real,
/// este cálculo se moverá al core y este fichero quedará como
/// adaptador delgado. Mantenemos por ahora la independencia para que
/// la Fase 4 funcione end-to-end sin esperar a F7.
///
/// Modelo: para cada afirmación tratamos los tres niveles de
/// confianza como una distribución de probabilidad simulada. La
/// elección de la Cronista equivale a una predicción "dura" (1 en el
/// nivel elegido, 0 en los otros); la calibración correcta del
/// catálogo equivale a la observación dura. El score Brier
/// multiclass clásico es:
///
///     B = Σ_i (predicción_i - observación_i)²
///
/// que con predicciones duras y 3 niveles está en {0, 2}. Lo
/// normalizamos a [0, 1] dividiendo por el máximo posible (2):
///
///     score = 1 - (B / 2)
///
/// Ese score por afirmación promediado sobre todas las que la
/// Cronista declara da el resultado de la Brecha. 1 = calibración
/// perfecta, 0 = todas mal calibradas.
class CalibracionAfirmacion {
  /// Nivel correcto según el catálogo.
  final NivelConfianza nivelCorrecto;

  /// Nivel que declaró la Cronista.
  final NivelConfianza nivelDeclarado;

  const CalibracionAfirmacion({
    required this.nivelCorrecto,
    required this.nivelDeclarado,
  });

  /// `1.0` si acierta, `0.0` si predice un nivel completamente
  /// distinto. Con esta variante hard-vs-hard sólo hay dos
  /// resultados posibles (0 o 1), pero la fórmula está preparada
  /// para que cuando se admita predicción suave (probabilidades
  /// declaradas) el cálculo siga siendo el mismo.
  double get scoreNormalizado {
    final brierMax = 2.0;
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

/// Resultado agregado de la calibración de toda una Brecha. La
/// pantalla de Concilio lo usa para presentar el feedback final.
class ResultadoCalibracionBrecha {
  /// Calibraciones individuales — útil para mostrar qué afirmaciones
  /// la Cronista calibró mal y dar feedback específico.
  final List<CalibracionAfirmacion> porAfirmacion;

  const ResultadoCalibracionBrecha({required this.porAfirmacion});

  int get totalAfirmaciones => porAfirmacion.length;

  int get aciertos => porAfirmacion.where((c) => c.acierta).length;

  /// Promedio del score normalizado en [0, 1]. Si no hay
  /// afirmaciones declaradas, devuelve `0.0` — la pantalla
  /// debe interpretar ese caso como "todavía no hay datos".
  double get scoreMedio {
    if (porAfirmacion.isEmpty) return 0.0;
    var suma = 0.0;
    for (final calibracion in porAfirmacion) {
      suma += calibracion.scoreNormalizado;
    }
    return suma / porAfirmacion.length;
  }
}

class EvaluadorCalibracion {
  const EvaluadorCalibracion();

  /// Calcula el resultado dado:
  /// - `afirmacionesDeclaradas`: lista de afirmaciones del catálogo
  ///   que la Cronista incluyó en su versión.
  /// - `nivelDeclaradoPorId`: el nivel que asignó a cada una.
  ///
  /// Las afirmaciones declaradas sin nivel asignado (caso teórico —
  /// la pantalla no debería permitirlo) se ignoran silenciosamente.
  ResultadoCalibracionBrecha evaluar({
    required List<AfirmacionCanonica> afirmacionesDeclaradas,
    required Map<String, NivelConfianza> nivelDeclaradoPorId,
  }) {
    final calibraciones = <CalibracionAfirmacion>[];
    for (final afirmacion in afirmacionesDeclaradas) {
      final nivel = nivelDeclaradoPorId[afirmacion.id];
      if (nivel == null) continue;
      calibraciones.add(
        CalibracionAfirmacion(
          nivelCorrecto: afirmacion.calibracionCorrecta,
          nivelDeclarado: nivel,
        ),
      );
    }
    return ResultadoCalibracionBrecha(porAfirmacion: calibraciones);
  }
}
