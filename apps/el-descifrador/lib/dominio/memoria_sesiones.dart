// Memoria de sesiones del jugador. Doc 03 §1 + doc 06 §4.
//
// Persiste: cuándo se abrió el cuaderno por primera vez, cuándo se
// visitó la última vez, cuántas sesiones ha habido, y qué hitos de
// cumpleaños del cuaderno ya se han mostrado.
//
// Se usa para:
//   - Saludo variable del maestro según contexto.
//   - Cumpleaños del cuaderno a los 30, 100, 365 días reales de uso
//     (manifiesto Kids §7: memoria amable que sustituye las rachas).
//
// La memoria NO mide racha consecutiva ni alerta sobre ausencias.
// Solo registra que el cuaderno está vivo y le pesa el tiempo.

/// Estado inmutable de la memoria de sesiones.
class MemoriaSesiones {
  const MemoriaSesiones({
    required this.fechaApertura,
    required this.fechaUltimaVisita,
    required this.cantidadVisitas,
    required this.hitosCumpleanyosMostrados,
  });

  /// Fecha de la primera vez que el niño abrió la app.
  final DateTime fechaApertura;

  /// Fecha de la sesión más reciente (incluye la actual cuando se
  /// registra al cargar).
  final DateTime fechaUltimaVisita;

  /// Cantidad total de sesiones registradas. Solo cuenta una vez por
  /// día calendario.
  final int cantidadVisitas;

  /// Hitos de cumpleaños del cuaderno ya mostrados al niño. Marcadores
  /// `30`, `100`, `365`. Una vez mostrados no se vuelven a anunciar.
  final Set<int> hitosCumpleanyosMostrados;

  /// Días reales (calendario) transcurridos entre apertura y ahora.
  int diasDesdeApertura(DateTime ahora) {
    final aperturaSoloDia =
        DateTime(fechaApertura.year, fechaApertura.month, fechaApertura.day);
    final ahoraSoloDia = DateTime(ahora.year, ahora.month, ahora.day);
    return ahoraSoloDia.difference(aperturaSoloDia).inDays;
  }

  /// Días desde la última visita registrada hasta `ahora`.
  int diasDesdeUltimaVisita(DateTime ahora) {
    final ultimaSoloDia = DateTime(
      fechaUltimaVisita.year,
      fechaUltimaVisita.month,
      fechaUltimaVisita.day,
    );
    final ahoraSoloDia = DateTime(ahora.year, ahora.month, ahora.day);
    return ahoraSoloDia.difference(ultimaSoloDia).inDays;
  }

  /// Devuelve nueva memoria reflejando que el niño ha entrado ahora.
  /// La fecha de apertura no cambia; la última visita se actualiza
  /// si el día calendario es distinto; la cuenta de visitas sube en
  /// ese mismo caso. (Abrir varias veces el mismo día cuenta como una
  /// sesión.)
  MemoriaSesiones conVisitaRegistrada(DateTime ahora) {
    final esMismoDia = ahora.year == fechaUltimaVisita.year &&
        ahora.month == fechaUltimaVisita.month &&
        ahora.day == fechaUltimaVisita.day;
    if (esMismoDia) {
      return MemoriaSesiones(
        fechaApertura: fechaApertura,
        fechaUltimaVisita: ahora,
        cantidadVisitas: cantidadVisitas,
        hitosCumpleanyosMostrados: hitosCumpleanyosMostrados,
      );
    }
    return MemoriaSesiones(
      fechaApertura: fechaApertura,
      fechaUltimaVisita: ahora,
      cantidadVisitas: cantidadVisitas + 1,
      hitosCumpleanyosMostrados: hitosCumpleanyosMostrados,
    );
  }

  MemoriaSesiones conHitoMostrado(int hito) {
    if (hitosCumpleanyosMostrados.contains(hito)) return this;
    return MemoriaSesiones(
      fechaApertura: fechaApertura,
      fechaUltimaVisita: fechaUltimaVisita,
      cantidadVisitas: cantidadVisitas,
      hitosCumpleanyosMostrados: {...hitosCumpleanyosMostrados, hito},
    );
  }

  /// Memoria de un perfil que entra por primera vez: la apertura y la
  /// última visita coinciden, y se cuenta como una visita.
  factory MemoriaSesiones.aperturaInicial(DateTime ahora) {
    return MemoriaSesiones(
      fechaApertura: ahora,
      fechaUltimaVisita: ahora,
      cantidadVisitas: 1,
      hitosCumpleanyosMostrados: const {},
    );
  }

  Map<String, dynamic> serializar() {
    return {
      'fecha_apertura': fechaApertura.toIso8601String(),
      'fecha_ultima_visita': fechaUltimaVisita.toIso8601String(),
      'cantidad_visitas': cantidadVisitas,
      'hitos_cumpleanyos_mostrados': hitosCumpleanyosMostrados.toList()..sort(),
    };
  }

  factory MemoriaSesiones.deserializar(Map<String, dynamic> mapa) {
    final hitos = <int>{};
    final listaHitos = mapa['hitos_cumpleanyos_mostrados'];
    if (listaHitos is List) {
      for (final valor in listaHitos) {
        if (valor is int) hitos.add(valor);
      }
    }
    return MemoriaSesiones(
      fechaApertura: DateTime.parse(mapa['fecha_apertura'] as String),
      fechaUltimaVisita: DateTime.parse(mapa['fecha_ultima_visita'] as String),
      cantidadVisitas: mapa['cantidad_visitas'] as int? ?? 1,
      hitosCumpleanyosMostrados: hitos,
    );
  }
}
