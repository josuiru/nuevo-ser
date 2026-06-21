/// Indicadores agregados del seguimiento de un periodo: lo que pide el
/// testaje (kg de alimentación, pariciones, productos comercializados,
/// ingresos, gastos y balance).
class IndicadoresSeguimiento {
  const IndicadoresSeguimiento({
    this.kgAlimentacion = 0,
    this.pariciones = 0,
    this.productos = 0,
    this.ingresosCentimos = 0,
    this.gastosCentimos = 0,
  });

  final double kgAlimentacion;
  final double pariciones;
  final double productos;
  final int ingresosCentimos;
  final int gastosCentimos;

  int get balanceCentimos => ingresosCentimos - gastosCentimos;
}

/// Formatea céntimos como euros con dos decimales (p. ej. 1234 → "12,34").
String eurosDesdeCentimos(int centimos) =>
    (centimos / 100).toStringAsFixed(2).replaceAll('.', ',');

/// Formatea una cantidad sin decimales sobrantes (3.0 → "3", 12.5 → "12,5").
String cantidadBonita(double valor) {
  final texto = valor.toStringAsFixed(valor.truncateToDouble() == valor ? 0 : 1);
  return texto.replaceAll('.', ',');
}
