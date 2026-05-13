/// Contador en memoria del intento actual del niño dentro del puzzle
/// que tiene abierto. Vive una sola sesión de captura de Fragmento:
/// `pantalla_caza` lo reinicia antes de abrir el puzzle y lo lee tras
/// la captura para escalar las esquirlas.
///
/// Diseño "motivación, no castigo":
/// - 1 = primera vez (recompensa completa)
/// - 2 = segundo intento (una esquirla menos)
/// - 3 = tercero (dos menos), etc.
/// - El mínimo NUNCA baja de 1 — capturar al Fragmento siempre vale
///   algo. La idea es premiar acertar a la primera, no penalizar al
///   niño que tarda en encontrarlo.
///
/// Cada `HapticFeedback.vibrate()` de las pantallas de puzzle llama a
/// [contarFalloPuzzle]; los puzzles no necesitan saber nada más.
int _intentosPuzzleActual = 1;

/// Vuelve el contador a 1 (primera vez). Llamar antes de empujar la
/// pantalla del puzzle.
void reiniciarIntentosPuzzle() {
  _intentosPuzzleActual = 1;
}

/// Suma uno al contador de intentos. Lo invocan las pantallas de
/// puzzle al detectar respuesta incorrecta.
void contarFalloPuzzle() {
  _intentosPuzzleActual++;
}

/// El intento actual (1, 2, 3...). Lo lee `pantalla_caza` tras el
/// pop del puzzle para escalar las esquirlas.
int get intentosPuzzleActual => _intentosPuzzleActual;

/// Reduce las esquirlas a entregar según [intentosPuzzleActual]. Cada
/// reintento resta una esquirla del valor [base].
///
/// **Regla del último intento posible.** Si el niño llega al último
/// intento que el puzzle permite (p. ej. 4.º de 4 opciones, 3.º de 3),
/// ya no demuestra razonamiento — está eligiendo por descarte. En ese
/// caso devuelve **0**, sin importar [base]. Esto motiva pensar antes
/// de tocar.
///
/// **Excepción binarios (2 opciones).** Para sí/no la regla del
/// descarte no aplica: fallar una vez y acertar a la segunda sigue
/// siendo razonamiento legítimo (no hay alternativa entre la primera y
/// la del descarte), así que se mantiene el mínimo de 1 esquirla en
/// todos los intentos.
///
/// Para los intentos intermedios mantiene un mínimo de 1 esquirla — el
/// niño aún razonó algo y atrapó al Fragmento.
///
/// Ejemplos con 4 opciones:
///   base=4 → 4 / 3 / 2 / 0
///   base=3 → 3 / 2 / 1 / 0
///   base=2 → 2 / 1 / 1 / 0
/// Ejemplos con 3 opciones:
///   base=3 → 3 / 2 / 0
///   base=2 → 2 / 1 / 0
/// Ejemplos con 2 opciones (binarios):
///   base=1 → 1 / 1 (sin descarte)
int esquirlasSegunIntentos({
  required int base,
  required int totalOpciones,
}) {
  if (totalOpciones >= 3 && _intentosPuzzleActual >= totalOpciones) {
    return 0;
  }
  if (base <= 1) return 1;
  final reduccion = (_intentosPuzzleActual - 1).clamp(0, base - 1);
  return (base - reduccion).clamp(1, base);
}
