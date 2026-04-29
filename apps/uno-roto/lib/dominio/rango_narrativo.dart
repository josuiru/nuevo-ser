/// Rangos narrativos del jugador en el MVP. Cada rango entrega
/// responsabilidades nuevas: Aprendiz II abre los Canales (doc 07
/// §1.13), etc. La escala completa de la biblia (Aprendiz → Iniciado →
/// Cazador → Maestro → Fraccionista Mayor) se introducirá según los
/// arcos lo requieran.
enum RangoNarrativo {
  aprendiz1,
  aprendiz2,
  aprendiz3,
  iniciado,
}

extension MetadatosRango on RangoNarrativo {
  int get valor => index;

  String get nombreVisible {
    switch (this) {
      case RangoNarrativo.aprendiz1:
        return 'Aprendiz I';
      case RangoNarrativo.aprendiz2:
        return 'Aprendiz II';
      case RangoNarrativo.aprendiz3:
        return 'Aprendiz III';
      case RangoNarrativo.iniciado:
        return 'Iniciado';
    }
  }

  /// Flag narrativo activado en el momento exacto en el que el jugador
  /// alcanza este rango. Permite a las escenas reaccionar — por ejemplo,
  /// la 1.13 "Las palabras de Irune" requiere
  /// `rango_aprendiz_ii_alcanzado`.
  String get flagAlcanzado {
    switch (this) {
      case RangoNarrativo.aprendiz1:
        return 'rango_aprendiz_i_alcanzado';
      case RangoNarrativo.aprendiz2:
        return 'rango_aprendiz_ii_alcanzado';
      case RangoNarrativo.aprendiz3:
        return 'rango_aprendiz_iii_alcanzado';
      case RangoNarrativo.iniciado:
        return 'rango_iniciado_alcanzado';
    }
  }
}

/// Disparador provisional: convierte un total acumulado de esquirlas en
/// el rango correspondiente. Es un proxy hasta que conectemos disparadores
/// pedagógicos (motor de maestría) y narrativos (combate de Kurz vencido).
RangoNarrativo rangoSegunEsquirlas(int esquirlas) {
  if (esquirlas >= 250) return RangoNarrativo.iniciado;
  if (esquirlas >= 100) return RangoNarrativo.aprendiz3;
  if (esquirlas >= 30) return RangoNarrativo.aprendiz2;
  return RangoNarrativo.aprendiz1;
}
