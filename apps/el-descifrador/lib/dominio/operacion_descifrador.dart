// Las seis operaciones del oficio del descifrador.
//
// Sobre cualquier documento que el niño abre, puede hacer alguna
// combinación de estas seis. No hay orden obligatorio — el oficio
// admite caminos. Ver `el-descifrador-03-mecanica-nuclear.md` §3.
//
// Cada pieza del corpus declara una "operación central" — la que la
// pieza ejercita principalmente — pero el niño puede ejecutar todas
// las que quiera sobre cualquier pieza.

enum OperacionDescifrador {
  /// Identificar la lengua del documento entre candidatas plausibles.
  /// Se infiere de marcadores visuales (terminaciones, artículos,
  /// dígrafos, signos diacríticos, alfabeto).
  identificar('identificar'),

  /// Marcar palabras con verde (conocida), amarillo (sospechosa con
  /// hipótesis) o rojo (desconocida). Las palabras marcadas pasan al
  /// cuaderno propio.
  marcar('marcar'),

  /// Anotar libremente al cuaderno propio. Sin plantilla, sin
  /// validación, sin corrección. El cuaderno es del niño.
  anotar('anotar'),

  /// Proponer una interpretación o traducción del documento. "Lo que
  /// yo creo que dice." No tiene que ser palabra por palabra — puede
  /// ser síntesis. La hipótesis es estado válido (biblia §2.3).
  proponer('proponer'),

  /// Pedir pistas progresivas en tres niveles: tono (te dirige a tu
  /// material), comparación (texto paralelo), traducción (la pieza
  /// concreta). Pedir ayuda es parte del oficio, no penaliza.
  verificar('verificar'),

  /// Decidir qué hacer con el documento: archivar, devolver al
  /// remitente, entregar al destinatario, publicar en el Boletín, o
  /// esperar a tener más contexto. La decisión tiene consecuencia
  /// narrativa (biblia §2.8).
  decidir('decidir');

  const OperacionDescifrador(this.identificadorTecnico);

  /// Identificador en snake_case usado en el JSON del corpus.
  final String identificadorTecnico;

  /// Construye desde identificador. Lanza ArgumentError si no existe.
  /// Tolera variantes compuestas como "interpretar_y_decidir" devolviendo
  /// la primera operación nombrada — los compuestos se mantienen como
  /// metadata documental pero el motor trabaja con la operación primaria.
  static OperacionDescifrador desdeIdentificador(String identificador) {
    final primera = identificador.split('_').first;
    for (final operacion in OperacionDescifrador.values) {
      if (operacion.identificadorTecnico == primera) return operacion;
    }
    throw ArgumentError(
      'Operación desconocida en corpus: "$identificador" (primera parte: "$primera")',
    );
  }
}
