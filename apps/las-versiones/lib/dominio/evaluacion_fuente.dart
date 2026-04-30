import 'brecha.dart';

/// Respuesta que la Cronista da a la evaluación de una fuente en la
/// Mesa de Trabajo (Fase 3 de Brecha). En esta v0.1 sólo se le piden
/// dos elecciones cerradas: tipo (primaria/secundaria) y sesgo. Los
/// otros seis campos del oficio (autor, fecha, público, intereses,
/// omisiones, corrobora/contradice) se le presentan como **lectura
/// del oficio** —respuestas modelo del cronista experto— sin pedirle
/// que las escriba ni elija. Esa decisión está apuntada en
/// `BLOQUEOS-PENDIENTES.md` (Mecánicas pedagógicas F6.3): el sistema
/// de elección múltiple textual con distractores requiere validación
/// del comité asesor antes de afirmar contenido histórico concreto.
class RespuestaEvaluacionFuente {
  /// Tipo declarado por la Cronista. `null` si aún no respondió.
  final TipoFuente? tipoElegido;

  /// Sesgo declarado por la Cronista. `null` si aún no respondió.
  final SesgoFuente? sesgoElegido;

  const RespuestaEvaluacionFuente({
    this.tipoElegido,
    this.sesgoElegido,
  });

  /// `true` si la respuesta tiene las dos elecciones declaradas.
  /// Una respuesta a medias no es "evaluada" todavía.
  bool get estaCompleta => tipoElegido != null && sesgoElegido != null;

  RespuestaEvaluacionFuente copiarCon({
    TipoFuente? tipoElegido,
    SesgoFuente? sesgoElegido,
  }) {
    return RespuestaEvaluacionFuente(
      tipoElegido: tipoElegido ?? this.tipoElegido,
      sesgoElegido: sesgoElegido ?? this.sesgoElegido,
    );
  }
}

/// Resultado de comparar la respuesta con las propiedades canónicas
/// de la fuente. Inmutable.
class ResultadoEvaluacionFuente {
  final bool aciertoTipo;
  final bool aciertoSesgo;

  const ResultadoEvaluacionFuente({
    required this.aciertoTipo,
    required this.aciertoSesgo,
  });

  /// Cuántas elecciones acertaron — útil para mostrar el resumen
  /// "2 de 2 aciertos en esta fuente".
  int get aciertos => (aciertoTipo ? 1 : 0) + (aciertoSesgo ? 1 : 0);

  /// Total de campos evaluados — fijo en 2 mientras la mecánica MVP
  /// se mantenga así, pero expuesto por si crece la rúbrica.
  int get total => 2;
}

/// Evaluador puro: compara una respuesta cronista con las propiedades
/// canónicas de la fuente. No persiste nada — la persistencia vive
/// en `RepositorioEvaluacionFuente`.
class EvaluadorFuente {
  const EvaluadorFuente();

  ResultadoEvaluacionFuente comparar({
    required RespuestaEvaluacionFuente respuesta,
    required PropiedadesFuente canonicas,
  }) {
    return ResultadoEvaluacionFuente(
      aciertoTipo: respuesta.tipoElegido == canonicas.tipo,
      aciertoSesgo: respuesta.sesgoElegido == canonicas.sesgo,
    );
  }
}
