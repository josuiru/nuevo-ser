/// Simulación de trazabilidad — ejercicio obligatorio APPCC.
///
/// Un inspector (o el quesero) selecciona un lote o una materia prima
/// al azar y reconstruye la cadena completa:
///
/// - **Hacia atrás**: de un lote de queso a las partidas de leche
/// - **Hacia adelante**: de una partida de leche a los lotes fabricados
///   y sus clientes
/// - **Interna**: verificación de que existen todos los registros
///   intermedios (fermentos, analíticas, curación)
///
/// `resultadoJson` almacena el JSON completo del árbol de trazabilidad
/// para poder regenerar informes sin tener que consultar la BD viva.
class SimulacionTrazabilidad {
  final int? id;
  final int fechaMs;
  final String tipo; // atras / adelante / completa
  final String elementoSimulado; // "Lote 20260511-001" o "Partida #3" o "Aleatorio: lote 20260511-001"
  final bool aleatorio; // true si el elemento fue seleccionado al azar
  final bool completa; // true si no se encontraron roturas en la cadena
  final String resumen; // texto legible del resultado
  final String resultadoJson; // JSON completo del árbol
  final int tiempoSegundos; // tiempo que tomó la simulación
  final String realizadaPor;
  final String firmaInspector; // nombre de quien verificó (inspector real o simulado)
  final String notas;
  final int fechaCreacionMs;

  SimulacionTrazabilidad({
    this.id,
    required this.fechaMs,
    required this.tipo,
    required this.elementoSimulado,
    this.aleatorio = false,
    this.completa = false,
    this.resumen = '',
    this.resultadoJson = '{}',
    this.tiempoSegundos = 0,
    this.realizadaPor = '',
    this.firmaInspector = '',
    this.notas = '',
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'elemento_simulado': elementoSimulado,
        'aleatorio': aleatorio ? 1 : 0,
        'completa': completa ? 1 : 0,
        'resumen': resumen,
        'resultado_json': resultadoJson,
        'tiempo_segundos': tiempoSegundos,
        'realizada_por': realizadaPor,
        'firma_inspector': firmaInspector,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory SimulacionTrazabilidad.fromMap(Map<String, Object?> mapa) =>
      SimulacionTrazabilidad(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        tipo: (mapa['tipo'] as String?) ?? '',
        elementoSimulado: (mapa['elemento_simulado'] as String?) ?? '',
        aleatorio: (mapa['aleatorio'] as int?) == 1,
        completa: (mapa['completa'] as int?) == 1,
        resumen: (mapa['resumen'] as String?) ?? '',
        resultadoJson: (mapa['resultado_json'] as String?) ?? '{}',
        tiempoSegundos: (mapa['tiempo_segundos'] as int?) ?? 0,
        realizadaPor: (mapa['realizada_por'] as String?) ?? '',
        firmaInspector: (mapa['firma_inspector'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
