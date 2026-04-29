/// Las cuatro capas de la guía sonora (doc 12 §Arquitectura).
/// Se ordenan por prioridad: cuando la capa narrativa entra en escena
/// (silbido de Zafrán, voz de Eco, mundo que baja de volumen), el motor
/// atenúa las demás ("ducking").
enum CapaAudio {
  /// Viento, ruido rosa, agua, murmullos lejanos. Casi nunca se apaga.
  ambient(
    clave: 'ambient',
    nombreVisible: 'Ambiente',
    volumenPredeterminado: 45,
  ),

  /// Loops por distrito, combate, motivos narrativos. Puede silenciarse.
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
  /// del resto (silbido de Zafrán, voz de Eco). Atenúan capas 1-3.
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
}
