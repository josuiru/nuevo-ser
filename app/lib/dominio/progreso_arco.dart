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

  /// Arco 2 — Canales y Zafrán (doc 08). 16 escenas en el guion —
  /// algunas aún no implementadas en el catálogo.
  static const ProgresoArco arco2 = ProgresoArco(
    nombreRomano: 'II',
    titulo: 'Canales y Zafrán',
    flagsPorEscena: [
      ['escena_2_1_vista'],
      ['escena_2_2_vista'],
      ['escena_2_3_vista'],
      [
        // 2.4: cualquier variante de puentes cuenta.
        'variante_2_4_a_usada',
        'variante_2_4_b_usada',
        'variante_2_4_c_usada',
        'variante_2_4_d_usada',
      ],
      ['escena_2_5_vista'],
      ['escena_2_6_vista'],
      ['escena_2_7_vista'],
      ['escena_2_8_vista'],
      ['escena_2_9_vista'],
      ['escena_2_10_vista'],
      ['escena_2_11_vista'],
      ['escena_2_12_vista'],
      ['escena_2_13_vista'],
      ['escena_2_14_vista'],
      ['escena_2_15_vista'],
      ['escena_2_16_vista'],
    ],
  );

  /// Arco 3 — La ciudad entera (doc 09). 18 escenas en el guion —
  /// parcialmente implementadas.
  static const ProgresoArco arco3 = ProgresoArco(
    nombreRomano: 'III',
    titulo: 'La ciudad entera',
    flagsPorEscena: [
      ['escena_3_1_vista'],
      ['escena_3_2_vista'],
      ['escena_3_3_vista'],
      ['escena_3_4_vista', 'combate_duel_kai_completado'],
      ['escena_3_5_vista'],
      ['escena_3_6_vista'],
      ['escena_3_7_vista'],
      ['escena_3_8_vista'],
      ['escena_3_9_vista'],
      ['escena_3_10_vista'],
      ['escena_3_11_vista'],
      ['escena_3_12_vista'],
      ['escena_3_13_vista'],
      ['escena_3_14_vista'],
      ['escena_3_15_vista'],
      ['escena_3_16_vista'],
      ['escena_3_17_vista'],
      ['escena_3_18_vista'],
    ],
  );

  /// Arcos disponibles, en orden canónico. El HUD elige el arco
  /// actual como el primero con al menos una escena completa cuyo
  /// predecesor esté cerrado — o el arco1 si no se ha empezado nada.
  static const List<ProgresoArco> todos = [arco1, arco2, arco3];

  /// Decide qué arco mostrar en el HUD: el más avanzado con al menos
  /// una escena vista. Sin flags → Arco 1.
  static Future<ProgresoArco> arcoActual(
    Future<bool> Function(String flag) flagActivo,
  ) async {
    final vistasArco3 = await arco3.contarVistas(flagActivo);
    if (vistasArco3 > 0) return arco3;
    final vistasArco2 = await arco2.contarVistas(flagActivo);
    if (vistasArco2 > 0) return arco2;
    return arco1;
  }
}
