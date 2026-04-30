import 'package:nuevo_ser_core/src/calibration/evaluador_calibracion.dart'
    as core;

import 'brecha.dart';

/// Wrapper delgado sobre el módulo de calibración del core
/// (`packages/nuevo_ser_core/lib/src/calibration/`). El cálculo
/// Brier multiclass vive en la plataforma para que cualquier juego
/// de la Colección pueda usarlo; aquí se mantiene el tipo
/// `EvaluadorCalibracion` con la firma específica del juego — recibe
/// la lista de [AfirmacionCanonica] declaradas + el mapa
/// `idAfirmacion → nivel` y produce el [ResultadoCalibracionBrecha]
/// que la pantalla de Concilio pinta.
///
/// Re-exportamos los tipos del core como aliases para que las
/// pantallas y tests existentes no necesiten cambiar imports.

/// Resultado individual — alias del tipo del core. Mantengo el
/// nombre histórico `CalibracionAfirmacion` que las pantallas usan.
typedef CalibracionAfirmacion = core.CalibracionAfirmacion;

/// Resultado agregado — alias del tipo del core. Mantengo el nombre
/// específico `ResultadoCalibracionBrecha` que la pantalla de
/// Concilio referencia.
typedef ResultadoCalibracionBrecha = core.ResultadoCalibracion;

/// Evaluador específico del juego. Internamente delega al
/// `EvaluadorCalibracion` del core para el cálculo, pero expone la
/// firma cómoda para Las Versiones (recibe afirmaciones + mapa de
/// niveles, no la lista de pares ya emparejados).
class EvaluadorCalibracion {
  final core.EvaluadorCalibracion _delegado;

  const EvaluadorCalibracion()
      : _delegado = const core.EvaluadorCalibracion();

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
    return _delegado.evaluar(calibraciones);
  }
}
