import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Ambiente atmosférico que pinta [PintorEscenario]. Se usa sobre todo en
/// las cinemáticas de entrenamiento (doc 07 §1.8) — cada variante tiene
/// un cielo distinto que el niño reconoce de memoria.
///
/// La clase lleva todos los parámetros pictóricos directamente para que
/// el pintor sea declarativo y los tests puedan instanciar valores
/// arbitrarios. Implementa el contrato genérico [AmbienteEscenaContrato]
/// del core para que el sistema de cinemáticas compartido sepa
/// transportarla sin conocer su pintura concreta.
class AmbienteCielo implements AmbienteEscenaContrato {
  /// Densidad relativa de estrellas (0..1.5). Multiplica la cantidad
  /// base. La niebla la reduce a casi cero.
  final double densidadEstrellas;

  /// Si se pintan dos lunas crecientes en el horizonte (biblia §lore —
  /// el cielo del juego tiene dos lunas). La niebla las oculta.
  final bool mostrarLunas;

  /// Niebla baja (0..1). 0 sin niebla, 1 cubre el horizonte por entero.
  final double intensidadNiebla;

  /// Lluvia ligera (0..1). 0 sin lluvia. Un valor moderado son hilos
  /// finos verticales. Implica suelo brillante.
  final double intensidadLluvia;

  /// Multiplicador de visibilidad de la Montaña (0..1.5). Por defecto 1.
  /// La 1.8d "Cielo muy limpio. La Montaña se ve entera" lo sube; la
  /// niebla lo baja.
  final double claridadMontana;

  const AmbienteCielo({
    this.densidadEstrellas = 1.0,
    this.mostrarLunas = false,
    this.intensidadNiebla = 0.0,
    this.intensidadLluvia = 0.0,
    this.claridadMontana = 1.0,
  });

  /// Cielo neutro — el que tienen escenas que no se quieren caracterizar
  /// (la mayor parte de las cinemáticas y el HUD de pantallas de puzzle).
  static const AmbienteCielo neutro = AmbienteCielo();

  /// 1.8a — Noche despejada con las dos lunas bajas, claras.
  static const AmbienteCielo nocheDespejada = AmbienteCielo(
    densidadEstrellas: 1.35,
    mostrarLunas: true,
  );

  /// 1.8b — Niebla baja. No se ven las lunas. Estrellas casi apagadas.
  static const AmbienteCielo niebla = AmbienteCielo(
    densidadEstrellas: 0.25,
    mostrarLunas: false,
    intensidadNiebla: 0.85,
    claridadMontana: 0.35,
  );

  /// 1.8c — Lluvia ligera. Sin lunas. Estrellas tenues.
  static const AmbienteCielo lluviaLigera = AmbienteCielo(
    densidadEstrellas: 0.55,
    mostrarLunas: false,
    intensidadLluvia: 0.7,
    claridadMontana: 0.7,
  );

  /// 1.8d — Cielo muy limpio. La Montaña se ve entera al horizonte.
  static const AmbienteCielo cieloLimpioMontana = AmbienteCielo(
    densidadEstrellas: 1.5,
    mostrarLunas: true,
    claridadMontana: 1.45,
  );

  /// Niebla suave — intermedia entre [neutro] y [niebla]. Estrellas
  /// algo apagadas pero las dos lunas siguen visibles. Útil para el
  /// clima dinámico de Tejados y Mercado, donde la niebla aparece de
  /// vez en cuando sin tomar la noche por completo.
  static const AmbienteCielo nieblaSuave = AmbienteCielo(
    densidadEstrellas: 0.75,
    mostrarLunas: true,
    intensidadNiebla: 0.30,
    claridadMontana: 0.65,
  );
}
