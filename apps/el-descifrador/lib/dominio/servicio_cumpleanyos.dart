// Cumpleaños del cuaderno. Doc 06 §4 + manifiesto Kids §7.
//
// A los 30, 100, 365 días reales desde la apertura del cuaderno, una
// frase breve. No es comparativa, no se gana nada, no se enseña a
// otros niños. Es del niño consigo mismo.
//
// Idempotente: el mismo hito no vuelve a anunciarse. PantallaMesa
// llama a marcarHitoMostrado tras presentarlo.

import 'memoria_sesiones.dart';

/// Hito de cumpleaños que está activo hoy y aún no se mostró.
class HitoCumpleanyos {
  const HitoCumpleanyos({required this.dias, required this.texto});

  final int dias;
  final String texto;
}

class ServicioCumpleanyos {
  const ServicioCumpleanyos();

  /// Hitos en días desde la apertura. Orden ascendente.
  static const List<int> umbralesDias = [30, 100, 365];

  /// Devuelve el hito activo más alto cruzado pero aún no mostrado,
  /// o null si no hay ninguno.
  ///
  /// Si el niño no abre la app durante el día del hito y entra una
  /// semana después, el hito se sigue mostrando — el cuaderno espera
  /// (manifiesto Kids §7).
  HitoCumpleanyos? hitoActivo({
    required MemoriaSesiones memoria,
    required DateTime ahora,
  }) {
    final diasUso = memoria.diasDesdeApertura(ahora);
    HitoCumpleanyos? mejor;
    for (final umbral in umbralesDias) {
      if (diasUso >= umbral &&
          !memoria.hitosCumpleanyosMostrados.contains(umbral)) {
        mejor = HitoCumpleanyos(dias: umbral, texto: _textoPara(umbral));
      }
    }
    return mejor;
  }

  String _textoPara(int dias) {
    switch (dias) {
      case 30:
        return 'Un mes con el cuaderno. Va pesando.';
      case 100:
        return 'Cien días con el cuaderno. La oficina te conoce.';
      case 365:
        return 'Un año con el cuaderno. Has hecho oficio.';
      default:
        return 'Cumpleaños del cuaderno: $dias días.';
    }
  }
}
