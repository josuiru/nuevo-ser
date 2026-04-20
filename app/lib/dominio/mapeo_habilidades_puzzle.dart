import 'fragmento_en_tejado.dart';

/// Dado un [FragmentoEnTejado], devuelve el id de la habilidad
/// principal que el puzzle asociado ejercita, según el mapa
/// pedagógico (docs/02).
///
/// Mapeo del MVP:
/// - Unitario (cortar en partes iguales) → FR.01.
/// - Espejo (elegir equivalente) → FR.09.
/// - Decimal (decimal → fracción) → DEC.08.
/// - Porcentaje (% → fracción) → PROP.04.
/// - Impropio (impropia → mixta) → FR.12.
/// - Proporcional (completar a:b = c:?) → PROP.02.
/// - Dual con suma → FR.16; resta → FR.17; producto → FR.19; división → FR.21.
/// - Operación decimal con suma/resta → DEC.04; producto → DEC.06;
///   división → DEC.07.
String idHabilidadPrincipal(FragmentoEnTejado fragmento) {
  switch (fragmento.tipo) {
    case TipoFragmentoEnTejado.unitario:
      return 'FR.01';
    case TipoFragmentoEnTejado.espejo:
      return 'FR.09';
    case TipoFragmentoEnTejado.decimal:
      return 'DEC.08';
    case TipoFragmentoEnTejado.porcentaje:
      return 'PROP.04';
    case TipoFragmentoEnTejado.impropio:
      return 'FR.12';
    case TipoFragmentoEnTejado.proporcional:
      return 'PROP.02';
    case TipoFragmentoEnTejado.dual:
      switch (fragmento.operador) {
        case OperadorAritmetico.suma:
          return 'FR.16';
        case OperadorAritmetico.resta:
          return 'FR.17';
        case OperadorAritmetico.producto:
          return 'FR.19';
        case OperadorAritmetico.division:
          return 'FR.21';
        case null:
          return 'FR.16';
      }
    case TipoFragmentoEnTejado.operacionDecimal:
      switch (fragmento.operador) {
        case OperadorAritmetico.suma:
        case OperadorAritmetico.resta:
          return 'DEC.04';
        case OperadorAritmetico.producto:
          return 'DEC.06';
        case OperadorAritmetico.division:
          return 'DEC.07';
        case null:
          return 'DEC.04';
      }
  }
}

/// Dificultad aproximada entre 0.5 y 2.0 para las métricas del motor.
double dificultadEstimadaDelPuzzle(FragmentoEnTejado fragmento) {
  switch (fragmento.tipo) {
    case TipoFragmentoEnTejado.unitario:
      final n = fragmento.numerador;
      final d = fragmento.denominador;
      // Denominadores mayores y compuestos pesan más.
      final base = (d / 3).clamp(0.5, 1.6);
      final porCompuesto = n > 1 ? 0.2 : 0.0;
      return (base + porCompuesto).clamp(0.5, 2.0);
    case TipoFragmentoEnTejado.espejo:
    case TipoFragmentoEnTejado.decimal:
    case TipoFragmentoEnTejado.porcentaje:
      return 1.0;
    case TipoFragmentoEnTejado.impropio:
    case TipoFragmentoEnTejado.proporcional:
      return 1.3;
    case TipoFragmentoEnTejado.dual:
      return fragmento.operador == OperadorAritmetico.division ? 1.8 : 1.5;
    case TipoFragmentoEnTejado.operacionDecimal:
      return 1.5;
  }
}
