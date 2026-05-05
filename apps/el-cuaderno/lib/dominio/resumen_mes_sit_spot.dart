import 'observacion.dart';

/// Resumen cualitativo del mes en curso para un sit spot — alimenta
/// el bloque "Este mes aquí" de [PantallaPaginaSitSpot] (biblia §3.5
/// *"si vuelves al mismo sitio, ves cómo cambia"*).
///
/// **Visitas, no anotaciones**. La unidad pedagógica es el día
/// distinto: si el niño anota tres cosas en una mañana, eso es **una**
/// visita. Lo que cuenta es volver al lugar.
///
/// El resumen es del mes **calendárico** en curso (1 al último día del
/// mes). Si el niño abre el cuaderno el 1 del mes nuevo, el bloque
/// arrancará vacío y se irá llenando con cada visita — eso es el
/// punto: ver el mes que está ocurriendo, no un sliding window de 30
/// días que oculta el corte natural.
///
/// Inmutable. Se calcula bajo demanda en cada apertura de la página
/// del sit spot — coste lineal en la cantidad de observaciones del
/// sit spot, cardinalidad muy baja por diseño.
class ResumenMesSitSpot {
  const ResumenMesSitSpot({
    required this.visitas,
    required this.primera,
    required this.ultima,
  });

  /// Cuántos días distintos del mes en curso ha venido el niño a este
  /// sit spot. Cero si no ha venido todavía.
  final int visitas;

  /// La observación más antigua del mes en este sit spot, si la hay.
  /// Útil para articular "la primera fue el DD/MM, …".
  final Observacion? primera;

  /// La observación más reciente del mes en este sit spot, si la hay.
  /// Si visitas == 1 coincide con [primera] — la pantalla decide si
  /// pinta una sola línea o dos en consecuencia.
  final Observacion? ultima;

  /// Atajo: `true` si el niño aún no ha venido este mes. Las pantallas
  /// usan esta propiedad como gate para decidir si montar el bloque.
  bool get vacio => visitas == 0;

  /// Calcula el resumen para un sit spot dado. Filtra observaciones
  /// con [Observacion.sitSpotId] coincidente y `cuandoOcurrio` dentro
  /// del mes calendárico de [ahora]. Las visitas se cuentan por días
  /// distintos (year/month/day). [primera] y [ultima] se eligen del
  /// orden cronológico, no del orden de inserción.
  static ResumenMesSitSpot calcular({
    required List<Observacion> observaciones,
    required String sitSpotId,
    required DateTime ahora,
  }) {
    final inicioDelMes = DateTime(ahora.year, ahora.month, 1);
    // Inicio del mes siguiente — `month + 1` se normaliza solo (mes
    // 13 → enero del año siguiente), así no necesitamos lógica
    // calendárica especial.
    final inicioMesSiguiente = DateTime(ahora.year, ahora.month + 1, 1);
    final delMes = observaciones.where((obs) {
      if (obs.sitSpotId != sitSpotId) return false;
      final cuando = obs.cuandoOcurrio;
      return !cuando.isBefore(inicioDelMes) &&
          cuando.isBefore(inicioMesSiguiente);
    }).toList()
      ..sort((a, b) => a.cuandoOcurrio.compareTo(b.cuandoOcurrio));
    if (delMes.isEmpty) {
      return const ResumenMesSitSpot(
        visitas: 0,
        primera: null,
        ultima: null,
      );
    }
    final diasDistintos = <DateTime>{
      for (final obs in delMes)
        DateTime(
          obs.cuandoOcurrio.year,
          obs.cuandoOcurrio.month,
          obs.cuandoOcurrio.day,
        ),
    };
    return ResumenMesSitSpot(
      visitas: diasDistintos.length,
      primera: delMes.first,
      ultima: delMes.last,
    );
  }
}
