/// Mapea cada una de las 14 escenas del Arco 1 a uno o varios flags
/// equivalentes. La 1.10 y la 1.12 tienen ramas según victoria/derrota,
/// la 1.8 agrupa variantes — cualquiera de sus flags vale como "escena
/// completada" a efectos del contador.
///
/// El contador se muestra en el HUD del mapa para que el niño sepa en
/// qué punto del arco está sin tener que acordarse.
class ProgresoArco {
  final String nombreRomano;
  final String titulo;
  final List<List<String>> flagsPorEscena;

  const ProgresoArco({
    required this.nombreRomano,
    required this.titulo,
    required this.flagsPorEscena,
  });

  int get totalEscenas => flagsPorEscena.length;

  /// Cuenta cuántas escenas han sido completadas consultando los flags
  /// persistidos. Tolera cualquier capa de persistencia (tests pueden
  /// pasar una función in-memory).
  Future<int> contarVistas(
    Future<bool> Function(String flag) flagActivo,
  ) async {
    var vistas = 0;
    for (final alternativas in flagsPorEscena) {
      for (final flag in alternativas) {
        if (await flagActivo(flag)) {
          vistas++;
          break;
        }
      }
    }
    return vistas;
  }

  /// Arco 1 — El Reclutamiento (doc 07).
  static const ProgresoArco arco1 = ProgresoArco(
    nombreRomano: 'I',
    titulo: 'El Reclutamiento',
    flagsPorEscena: [
      ['escena_1_1_vista'],
      ['escena_1_2_vista'],
      ['escena_1_3_vista'],
      ['escena_1_4_vista'],
      ['escena_1_5_vista'],
      ['escena_1_6_vista'],
      ['escena_1_7_vista'],
      [
        // 1.8: cualquier variante vale.
        'variante_1_8_a_usada',
        'variante_1_8_b_usada',
        'variante_1_8_c_usada',
        'variante_1_8_d_usada',
        'variante_1_8_e_usada',
      ],
      ['escena_1_9_vista'],
      ['escena_1_10_resuelta'],
      ['escena_1_11_vista'],
      ['escena_1_12_vista', 'escena_1_12_derrota_vista'],
      ['escena_1_13_vista'],
      ['escena_1_14_vista'],
    ],
  );
}
