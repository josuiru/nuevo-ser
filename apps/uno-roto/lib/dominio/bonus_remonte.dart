/// Bonus de "remonte": una esquirla extra cuando el niño captura un
/// Fragmento de una habilidad que históricamente le costaba (precisión
/// previa < 0.5).
///
/// Doc 01 §1: motivación, no gamificación. El bonus refuerza el
/// remonte real, no la chiripa, ni se acumula sin freno:
///
/// 1. **Capturó de verdad**: solo aplica si las esquirlas base son > 0.
///    Si capturó por descarte (último intento posible) `esquirlasGanadas`
///    es 0 — eso ya no es razonamiento, no merece bonus.
/// 2. **Costaba**: la `precisionPrevia` de la habilidad debe estar por
///    debajo del 50%. Si nunca la había tocado (`null`), tampoco hay
///    bonus — no había nada que remontar.
/// 3. **No repetir**: una habilidad solo paga bonus la primera vez que
///    se remonta en una sesión. La pantalla mantiene un `Set<String>`
///    de habilidades ya remontadas y lo pasa como `yaRemontada`.
///
/// El umbral 0.5 coincide con el límite del nivel `enDesarrollo` del
/// motor de maestría (doc 02 §16), así "remonte" significa cruzar el
/// punto donde la habilidad pasa de costar a soltarse.
const double _umbralPrecisionDificil = 0.5;

bool aplicaBonusRemonte({
  required int esquirlasGanadas,
  required double? precisionPrevia,
  required bool yaRemontada,
}) {
  if (esquirlasGanadas <= 0) return false;
  if (yaRemontada) return false;
  if (precisionPrevia == null) return false;
  return precisionPrevia < _umbralPrecisionDificil;
}
