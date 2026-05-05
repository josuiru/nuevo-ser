import 'observacion.dart';

/// Tipo de eco — qué ventana del pasado mira.
///
/// Los tres rangos están elegidos para cumplir el ritmo del oficio
/// natural: 1 mes recoge cambios fenológicos rápidos (insectos
/// estacionales, brotes), 6 meses cierra el ciclo equinoccio →
/// equinoccio o solsticio → solsticio, y 1 año es la memoria
/// completa del lugar (biblia §3.5 *"si vuelves al mismo sitio, ves
/// cómo cambia"*).
enum VentanaEco {
  haceUnMes,
  haceSeisMeses,
  haceUnAno;

  /// Días antes/después del aniversario exacto que se consideran
  /// dentro de la ventana. ±3 días absorbe la realidad: la niña no
  /// anota siempre el mismo día de la semana.
  static const int toleranciaDias = 3;

  /// Aniversario teórico restando la cantidad correcta de la fecha
  /// actual. Se calcula respetando los meses (no son 30 días
  /// uniformes) — `DateTime` se encarga de la aritmética calendárica.
  DateTime aniversarioDesde(DateTime ahora) {
    return switch (this) {
      VentanaEco.haceUnMes => DateTime(ahora.year, ahora.month - 1, ahora.day),
      VentanaEco.haceSeisMeses =>
        DateTime(ahora.year, ahora.month - 6, ahora.day),
      VentanaEco.haceUnAno =>
        DateTime(ahora.year - 1, ahora.month, ahora.day),
    };
  }
}

/// Una observación que el cuaderno considera un "eco" del pasado:
/// algo anotado hace aproximadamente 1 mes / 6 meses / 1 año, y que
/// merece volver a aparecer en el home como ritual del oficio del
/// lugar.
///
/// Inmutable. Se calcula en runtime por [EcoTemporal.calcular] cada
/// vez que el home se monta — barato (lineal en el número de
/// observaciones, densidad textual baja por diseño).
class Eco {
  const Eco({required this.ventana, required this.observacion});

  final VentanaEco ventana;
  final Observacion observacion;
}

/// Calculadora de ecos del cuaderno. Sin estado, sin disco, sin red:
/// recibe las observaciones y la fecha actual, devuelve hasta 3
/// ecos.
///
/// **Reglas**:
/// - Para cada ventana (1 mes, 6 meses, 1 año) buscamos observaciones
///   con `cuandoOcurrio` dentro de ±3 días del aniversario teórico.
/// - Si una ventana tiene varias candidatas, gana la más cercana al
///   aniversario exacto (en valor absoluto de días).
/// - Si una ventana no tiene candidatas, simplemente no aparece — el
///   bloque del home omite esa fila. **Sin presión**: el cuaderno no
///   inventa ecos donde no los hay (biblia §2.7 ritmo respetuoso).
/// - Las tres ventanas pueden coincidir en la misma observación
///   (raro, pero posible si el niño anotó algo hace exactamente 1
///   año y vuelve a anotarlo cada 6 meses). Para evitar duplicados
///   visuales en el home, [calcular] devuelve **observaciones
///   distintas** — si la misma observación cae en dos ventanas, gana
///   la de mayor antigüedad (1 año > 6 meses > 1 mes), pero las
///   ventanas más cortas pueden seguir teniendo otra observación
///   distinta.
class EcoTemporal {
  const EcoTemporal._();

  /// Calcula los ecos. Devuelve una lista ordenada por ventana
  /// (haceUnMes, haceSeisMeses, haceUnAno) con sólo las que tengan
  /// candidata, sin duplicar observaciones.
  static List<Eco> calcular({
    required List<Observacion> observaciones,
    required DateTime ahora,
  }) {
    final candidatasPorVentana = <VentanaEco, Observacion>{};

    for (final ventana in VentanaEco.values) {
      final aniversario = ventana.aniversarioDesde(ahora);
      Observacion? mejor;
      int? mejorDistancia;
      for (final obs in observaciones) {
        final distanciaDias = obs.cuandoOcurrio.difference(aniversario).inDays;
        final distanciaAbs = distanciaDias.abs();
        if (distanciaAbs > VentanaEco.toleranciaDias) continue;
        if (mejorDistancia == null || distanciaAbs < mejorDistancia) {
          mejor = obs;
          mejorDistancia = distanciaAbs;
        }
      }
      if (mejor != null) {
        candidatasPorVentana[ventana] = mejor;
      }
    }

    // Eliminamos duplicados: si una observación cae en varias
    // ventanas, gana la más antigua (1 año). Procesamos en orden
    // descendente de antigüedad y vamos marcando ids consumidos.
    final ordenAntiguedadDesc = [
      VentanaEco.haceUnAno,
      VentanaEco.haceSeisMeses,
      VentanaEco.haceUnMes,
    ];
    final consumidos = <String>{};
    final resultadoPorVentana = <VentanaEco, Eco>{};
    for (final ventana in ordenAntiguedadDesc) {
      final obs = candidatasPorVentana[ventana];
      if (obs == null) continue;
      if (consumidos.contains(obs.id)) {
        // Ya está usada en una ventana más antigua — buscamos otra
        // candidata distinta para esta ventana.
        final aniversario = ventana.aniversarioDesde(ahora);
        Observacion? alternativa;
        int? mejorDistancia;
        for (final candidata in observaciones) {
          if (consumidos.contains(candidata.id)) continue;
          final distanciaDias =
              candidata.cuandoOcurrio.difference(aniversario).inDays;
          final distanciaAbs = distanciaDias.abs();
          if (distanciaAbs > VentanaEco.toleranciaDias) continue;
          if (mejorDistancia == null || distanciaAbs < mejorDistancia) {
            alternativa = candidata;
            mejorDistancia = distanciaAbs;
          }
        }
        if (alternativa == null) continue;
        consumidos.add(alternativa.id);
        resultadoPorVentana[ventana] = Eco(
          ventana: ventana,
          observacion: alternativa,
        );
      } else {
        consumidos.add(obs.id);
        resultadoPorVentana[ventana] = Eco(
          ventana: ventana,
          observacion: obs,
        );
      }
    }

    // Devolvemos en orden de presentación: 1 mes → 6 meses → 1 año
    // (lo más reciente arriba, como el resto del cuaderno).
    return [
      for (final v in VentanaEco.values)
        if (resultadoPorVentana.containsKey(v)) resultadoPorVentana[v]!,
    ];
  }
}
