/// Resultado económico agregado de un proyecto de test: ingresos (de
/// comercialización + otros apuntes), gastos, balance y margen. Es la base
/// del análisis de resultados y de la extrapolación.
class RentabilidadProyecto {
  const RentabilidadProyecto({
    this.ingresosComercializacionCentimos = 0,
    this.ingresosApuntesCentimos = 0,
    this.gastosCentimos = 0,
  });

  /// Ingresos por ventas registradas en comercialización.
  final int ingresosComercializacionCentimos;

  /// Otros ingresos anotados en el libro económico (primas, ayudas…).
  final int ingresosApuntesCentimos;

  /// Costes anotados en el libro económico.
  final int gastosCentimos;

  int get ingresosTotalesCentimos =>
      ingresosComercializacionCentimos + ingresosApuntesCentimos;

  /// Beneficio (o pérdida) del periodo.
  int get balanceCentimos => ingresosTotalesCentimos - gastosCentimos;

  /// Margen sobre ingresos (%). 0 si no hay ingresos.
  double get margenPorcentaje => ingresosTotalesCentimos == 0
      ? 0
      : balanceCentimos / ingresosTotalesCentimos * 100;

  /// Extrapola el balance a un periodo anual a partir de los días cubiertos.
  /// Devuelve `null` si no hay días suficientes para extrapolar.
  int? balanceAnualExtrapoladoCentimos(int diasPeriodo) {
    if (diasPeriodo <= 0) return null;
    return (balanceCentimos * 365 / diasPeriodo).round();
  }
}
