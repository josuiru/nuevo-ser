/// Tres niveles de confianza con que un juego puede pedirle a la
/// persona usuaria que ancle una afirmación. Genérico — no presupone
/// historia ni matemáticas, lo usan tanto Las Versiones (AH.03 sobre
/// el oficio del cronista) como cualquier juego futuro que necesite
/// declaración explícita de incertidumbre.
///
/// El cálculo Brier (`EvaluadorCalibracion`) compara el nivel
/// declarado con el nivel canónicamente correcto del catálogo.
enum NivelConfianza {
  solido,
  probable,
  disputado,
}
