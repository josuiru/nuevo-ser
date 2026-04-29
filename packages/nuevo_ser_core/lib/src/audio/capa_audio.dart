/// Las cuatro capas de la guía sonora multi-capa de la Colección.
///
/// Se ordenan por prioridad: cuando la capa narrativa entra (efectos
/// especiales que el niño debe oír siempre, p. ej. la voz de un
/// Fragmento), el motor atenúa las demás ("ducking") para que no se
/// pisen.
///
/// Cada juego de la Colección puede usar las capas que necesite — el
/// contrato es el mismo para todos. El catálogo de sonidos concretos
/// (qué id mapea a qué archivo) es responsabilidad de cada juego.
enum CapaAudio {
  /// Viento, ruido rosa, agua, murmullos lejanos. Casi nunca se apaga.
  ambient(
    clave: 'ambient',
    nombreVisible: 'Ambiente',
    volumenPredeterminado: 45,
  ),

  /// Loops por escenario, combate, motivos narrativos. Puede silenciarse.
  musica(
    clave: 'musica',
    nombreVisible: 'Música',
    volumenPredeterminado: 70,
  ),

  /// Taps, aciertos/errores, gestos, UI. Feedback de interacción.
  efectos(
    clave: 'efectos',
    nombreVisible: 'Efectos',
    volumenPredeterminado: 80,
  ),

  /// Efectos narrativos especiales que deben oírse siempre por encima
  /// del resto. Atenúan capas 1-3 cuando suenan ("ducking").
  narrativos(
    clave: 'narrativos',
    nombreVisible: 'Narrativos',
    volumenPredeterminado: 85,
  );

  final String clave;
  final String nombreVisible;
  final int volumenPredeterminado;

  const CapaAudio({
    required this.clave,
    required this.nombreVisible,
    required this.volumenPredeterminado,
  });

  /// Mapa `clave → volumen predeterminado` para alimentar a
  /// `RepositorioPreferenciasAudio` sin que cada juego tenga que
  /// duplicar los defaults. La clave es la string que viaja a
  /// SharedPreferences (`<ns>.perfil.<id>.audio.volumen.<clave>`).
  static Map<String, int> defaultsPorClave() {
    return <String, int>{
      for (final c in CapaAudio.values) c.clave: c.volumenPredeterminado,
    };
  }
}
