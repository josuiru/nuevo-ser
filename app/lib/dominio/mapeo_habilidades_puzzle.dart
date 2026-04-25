import 'fragmento_en_tejado.dart';

/// Conjunto de skill_ids del doc 02 que el MVP sí sabe plantear hoy
/// (tiene algún TipoFragmentoEnTejado mapeado). El selector solo
/// elige entre estos; los demás están documentados pero pendientes de
/// diseño de puzzle.
const Set<String> skillsConPuzzleImplementado = {
  'FR.01',
  'FR.05',
  'FR.06',
  'FR.09',
  'FR.10',
  'FR.11',
  'FR.12',
  'FR.14',
  'FR.15',
  'FR.16',
  'FR.17',
  'FR.18',
  'FR.19',
  'FR.20',
  'FR.21',
  'DEC.04',
  'DEC.05',
  'DEC.06',
  'DEC.07',
  'DEC.08',
  'PROP.02',
  'PROP.04',
  'DIV.03',
};

/// Dado un skill_id, devuelve el tipo de Fragmento que lo ejercita.
/// Si no hay mapeo, devuelve null (no debería ocurrir si el selector
/// filtra por [skillsConPuzzleImplementado]).
TipoFragmentoEnTejado? tipoParaSkillId(String skillId) {
  if (skillId == 'FR.05' || skillId == 'FR.06') {
    return TipoFragmentoEnTejado.comparacion;
  }
  if (skillId == 'FR.09') return TipoFragmentoEnTejado.espejo;
  if (skillId == 'FR.10') return TipoFragmentoEnTejado.simplificar;
  if (skillId == 'FR.11') return TipoFragmentoEnTejado.amplificar;
  if (skillId == 'DIV.03') return TipoFragmentoEnTejado.divisibilidad;
  if (skillId == 'FR.12' || skillId == 'FR.13') {
    return TipoFragmentoEnTejado.impropio;
  }
  if (skillId == 'FR.16' ||
      skillId == 'FR.17' ||
      skillId == 'FR.19' ||
      skillId == 'FR.21') {
    return TipoFragmentoEnTejado.dual;
  }
  if (skillId == 'DEC.08') return TipoFragmentoEnTejado.decimal;
  if (skillId == 'DEC.04' ||
      skillId == 'DEC.05' ||
      skillId == 'DEC.06' ||
      skillId == 'DEC.07') {
    return TipoFragmentoEnTejado.operacionDecimal;
  }
  if (skillId == 'PROP.04') return TipoFragmentoEnTejado.porcentaje;
  if (skillId == 'PROP.01' ||
      skillId == 'PROP.02' ||
      skillId == 'PROP.03') {
    return TipoFragmentoEnTejado.proporcional;
  }
  if (skillId.startsWith('FR.')) return TipoFragmentoEnTejado.unitario;
  return null;
}

/// Para Fragmentos de comparación, el modo concreto según skill.
/// Null si la skill no es una de comparación.
ModoComparacion? modoComparacionParaSkillId(String skillId) {
  switch (skillId) {
    case 'FR.05':
      return ModoComparacion.mismoDenominador;
    case 'FR.06':
      return ModoComparacion.mismoNumerador;
    default:
      return null;
  }
}

/// Para Duales y OpDecimal, el operador concreto a forzar según
/// skill_id. Null si la skill no exige operador específico.
OperadorAritmetico? operadorParaSkillId(String skillId) {
  switch (skillId) {
    case 'FR.16':
    case 'DEC.04':
      return OperadorAritmetico.suma;
    case 'FR.17':
      return OperadorAritmetico.resta;
    case 'FR.19':
    case 'FR.18':
    case 'DEC.05':
    case 'DEC.06':
      return OperadorAritmetico.producto;
    case 'FR.21':
    case 'FR.20':
    case 'DEC.07':
      return OperadorAritmetico.division;
    default:
      return null;
  }
}

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
    case TipoFragmentoEnTejado.comparacion:
      switch (fragmento.modoComparacion) {
        case ModoComparacion.mismoNumerador:
          return 'FR.06';
        case ModoComparacion.mismoDenominador:
        case null:
          return 'FR.05';
      }
    case TipoFragmentoEnTejado.simplificar:
      return 'FR.10';
    case TipoFragmentoEnTejado.amplificar:
      return 'FR.11';
    case TipoFragmentoEnTejado.divisibilidad:
      return 'DIV.03';
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
    case TipoFragmentoEnTejado.comparacion:
      // Comparar mismo numerador es más contraintuitivo que mismo
      // denominador: pesa un poco más.
      return fragmento.modoComparacion == ModoComparacion.mismoNumerador
          ? 1.0
          : 0.8;
    case TipoFragmentoEnTejado.simplificar:
      // Simplificar pide reconocer una forma mínima entre varias
      // equivalencias — un escalón más que espejo.
      return 1.1;
    case TipoFragmentoEnTejado.amplificar:
      // Amplificar a denominador dado: igual de exigente que
      // simplificar, pero con la mecánica de rellenar.
      return 1.1;
    case TipoFragmentoEnTejado.divisibilidad:
      // Decisión binaria con criterios memorizables: muy ligero,
      // pero la métrica del motor lo registra igual.
      return 0.7;
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
