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
  'DIV.01',
  'DIV.03',
  'DIV.04',
  'DEC.01',
  'DEC.02',
  'FR.04',
  'FR.02',
  'FR.13',
  'DEC.09',
  'FR.07',
  'DIV.05',
  'PROP.03',
  'DEC.03',
  'DIV.06',
  'DIV.07',
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
  if (skillId == 'DIV.01') return TipoFragmentoEnTejado.multiplos;
  if (skillId == 'DIV.03' || skillId == 'DIV.04') {
    return TipoFragmentoEnTejado.divisibilidad;
  }
  if (skillId == 'DEC.01') return TipoFragmentoEnTejado.lecturaDecimal;
  if (skillId == 'DEC.02') return TipoFragmentoEnTejado.comparacionDecimal;
  if (skillId == 'FR.04') return TipoFragmentoEnTejado.comparacionUnidad;
  if (skillId == 'FR.02') return TipoFragmentoEnTejado.lecturaFraccion;
  if (skillId == 'FR.13') return TipoFragmentoEnTejado.mixtoAImpropio;
  if (skillId == 'DEC.09') return TipoFragmentoEnTejado.redondeoDecimal;
  if (skillId == 'FR.07') return TipoFragmentoEnTejado.comparacionDistinta;
  if (skillId == 'DIV.05') return TipoFragmentoEnTejado.primo;
  if (skillId == 'PROP.03') return TipoFragmentoEnTejado.porcentajeCantidad;
  if (skillId == 'DEC.03') return TipoFragmentoEnTejado.comparacionMixta;
  if (skillId == 'DIV.06' || skillId == 'DIV.07') {
    return TipoFragmentoEnTejado.mcmMcd;
  }
  if (skillId == 'FR.12') return TipoFragmentoEnTejado.impropio;
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
  if (skillId == 'PROP.01' || skillId == 'PROP.02') {
    return TipoFragmentoEnTejado.proporcional;
  }
  if (skillId.startsWith('FR.')) return TipoFragmentoEnTejado.unitario;
  return null;
}

/// Para Fragmentos de divisibilidad/múltiplos, el conjunto de divisores
/// que se pueden plantear según la skill objetivo.
/// - DIV.01: cualquier divisor pequeño {2, 3, 4, 5, 6, 7, 8, 9, 10},
///   porque la habilidad es entender el concepto de múltiplo, no
///   memorizar criterios.
/// - DIV.03: criterios básicos {2, 3, 5, 10}.
/// - DIV.04: criterios avanzados {4, 6, 9}.
/// Null si la skill no es de divisibilidad — el generador caerá en el
/// set predeterminado.
List<int>? divisoresParaSkillId(String skillId) {
  switch (skillId) {
    case 'DIV.01':
      return const [2, 3, 4, 5, 6, 7, 8, 9, 10];
    case 'DIV.03':
      return const [2, 3, 5, 10];
    case 'DIV.04':
      return const [4, 6, 9];
    default:
      return null;
  }
}

/// Para Fragmentos de MCM/MCD, qué calcular según skill.
/// - DIV.07 → MCM (`'mcm'`).
/// - DIV.06 → MCD (`'mcd'`).
/// Null si la skill no es de esta familia.
String? modoMcmMcdParaSkillId(String skillId) {
  switch (skillId) {
    case 'DIV.07':
      return 'mcm';
    case 'DIV.06':
      return 'mcd';
    default:
      return null;
  }
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
      // El divisor concreto distingue qué skill ejercita el Fragmento:
      // los criterios avanzados (4, 6, 9) son DIV.04; los básicos
      // (2, 3, 5, 10), DIV.03.
      const avanzados = {4, 6, 9};
      return avanzados.contains(fragmento.denominador)
          ? 'DIV.04'
          : 'DIV.03';
    case TipoFragmentoEnTejado.comparacionDecimal:
      return 'DEC.02';
    case TipoFragmentoEnTejado.lecturaDecimal:
      return 'DEC.01';
    case TipoFragmentoEnTejado.multiplos:
      return 'DIV.01';
    case TipoFragmentoEnTejado.comparacionUnidad:
      return 'FR.04';
    case TipoFragmentoEnTejado.lecturaFraccion:
      return 'FR.02';
    case TipoFragmentoEnTejado.mixtoAImpropio:
      return 'FR.13';
    case TipoFragmentoEnTejado.redondeoDecimal:
      return 'DEC.09';
    case TipoFragmentoEnTejado.comparacionDistinta:
      return 'FR.07';
    case TipoFragmentoEnTejado.primo:
      return 'DIV.05';
    case TipoFragmentoEnTejado.porcentajeCantidad:
      return 'PROP.03';
    case TipoFragmentoEnTejado.comparacionMixta:
      return 'DEC.03';
    case TipoFragmentoEnTejado.mcmMcd:
      // El modo lo lleva etiquetaDecimal: 'mcm' → DIV.07, 'mcd' → DIV.06.
      return fragmento.etiquetaDecimal == 'mcd' ? 'DIV.06' : 'DIV.07';
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
      // Criterios avanzados (4, 6, 9) son menos automáticos que los
      // básicos (2, 3, 5, 10) y pesan un escalón más.
      const avanzados = {4, 6, 9};
      return avanzados.contains(fragmento.denominador) ? 0.95 : 0.7;
    case TipoFragmentoEnTejado.comparacionDecimal:
      // El error sistemático de "más dígitos = mayor" cuesta de superar
      // — pesa como una comparación de fracciones del lado difícil.
      return 1.0;
    case TipoFragmentoEnTejado.lecturaDecimal:
      // Lectura "texto → número": traducción ligera, parecida a
      // espejo o decimal.
      return 0.9;
    case TipoFragmentoEnTejado.multiplos:
      // Concepto de múltiplo, decisión binaria: ligero como DIV.03.
      return 0.7;
    case TipoFragmentoEnTejado.comparacionUnidad:
      // Tres opciones, pero la decisión sale casi a la vista. Más
      // exigente que una binaria, menos que comparar dos fracciones.
      return 0.85;
    case TipoFragmentoEnTejado.lecturaFraccion:
      // Mecánica texto→fracción, similar a DEC.01 lectura decimal.
      return 0.9;
    case TipoFragmentoEnTejado.mixtoAImpropio:
      // Conversión con cálculo aritmético — un escalón sobre simple
      // identificación, similar a impropio inverso.
      return 1.2;
    case TipoFragmentoEnTejado.redondeoDecimal:
      // Decisión sobre la centésima + escribir bien la décima — más
      // exigente que comparación decimal por la propagación.
      return 1.0;
    case TipoFragmentoEnTejado.comparacionDistinta:
      // FR.07 pide multiplicación cruzada o cálculo de valor — un
      // escalón claramente sobre FR.05/FR.06.
      return 1.2;
    case TipoFragmentoEnTejado.primo:
      // Decisión binaria pura, pero memoria + casos confusos pesan
      // como una divisibilidad media.
      return 0.85;
    case TipoFragmentoEnTejado.porcentajeCantidad:
      // Cálculo directo con dos pasos (multiplicar y dividir entre
      // 100). Más exigente que conversión simple, menos que duales.
      return 1.2;
    case TipoFragmentoEnTejado.comparacionMixta:
      // Comparar formatos cruzados — exige convertir mentalmente uno
      // de los dos. Pesa como una comparación distinta (FR.07).
      return 1.1;
    case TipoFragmentoEnTejado.mcmMcd:
      // Cálculo con dos descomposiciones — más exigente que la
      // mecánica binaria de divisibilidad.
      return 1.3;
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
