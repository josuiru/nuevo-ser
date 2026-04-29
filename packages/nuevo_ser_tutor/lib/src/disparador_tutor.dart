/// Política de cuándo ofrecer el Tutor IA al niño.
///
/// El tutor NO es un botón siempre visible. Eso violaría doc 01 §1
/// (el niño es la medida) — convertiría la pantalla en un asistente
/// permanente que el niño usaría como muleta. La regla:
///
/// - Solo ofrecemos tutor cuando el niño se está **atascando** de
///   verdad en una habilidad concreta (varios fallos seguidos).
/// - Después de ofrecerlo, hay un cooldown mínimo antes de volver
///   a ofrecerlo aunque siga fallando — para que la oferta sea un
///   gesto cariñoso, no una persecución.
/// - Resetear el contador en cuanto acierta: el atasco era puntual.
///
/// Esto es dominio puro. El estado se persiste fuera (repositorio).
/// El motor de combate llama a `registrarFallo` / `registrarAcierto`
/// y consulta `deberiaOfrecer` antes de mostrar el botón.
library;

/// Umbral de fallos consecutivos en la misma habilidad para que el
/// tutor aparezca. Por debajo no aparece — preferimos que el niño
/// lo intente otra vez antes de ofrecerle ayuda externa.
const int fallosConsecutivosParaOfrecer = 3;

/// Tiempo mínimo entre ofertas consecutivas del tutor para una misma
/// habilidad. Aunque el niño falle 3-3-3 seguidos no queremos
/// martillearle con la misma sugerencia.
const Duration cooldownEntreOfertas = Duration(minutes: 10);

/// Estado del tutor para una habilidad concreta. Pequeño, serializable.
/// El repositorio lo guarda como JSON bajo
/// `uroto.perfil.<id>.tutor.<idHabilidad>`.
class EstadoTutorHabilidad {
  final int fallosConsecutivos;
  final DateTime? ultimaOferta;
  final int vecesUsado;

  const EstadoTutorHabilidad({
    this.fallosConsecutivos = 0,
    this.ultimaOferta,
    this.vecesUsado = 0,
  });

  EstadoTutorHabilidad registrandoFallo() {
    return EstadoTutorHabilidad(
      fallosConsecutivos: fallosConsecutivos + 1,
      ultimaOferta: ultimaOferta,
      vecesUsado: vecesUsado,
    );
  }

  EstadoTutorHabilidad registrandoAcierto() {
    return EstadoTutorHabilidad(
      fallosConsecutivos: 0,
      ultimaOferta: ultimaOferta,
      vecesUsado: vecesUsado,
    );
  }

  EstadoTutorHabilidad registrandoOferta(DateTime ahora) {
    return EstadoTutorHabilidad(
      fallosConsecutivos: fallosConsecutivos,
      ultimaOferta: ahora,
      vecesUsado: vecesUsado,
    );
  }

  EstadoTutorHabilidad registrandoUso(DateTime ahora) {
    return EstadoTutorHabilidad(
      fallosConsecutivos: 0,
      ultimaOferta: ahora,
      vecesUsado: vecesUsado + 1,
    );
  }

  Map<String, dynamic> aJson() => {
        'fallos': fallosConsecutivos,
        'ultimaOferta': ultimaOferta?.toIso8601String(),
        'vecesUsado': vecesUsado,
      };

  static EstadoTutorHabilidad desdeJson(Map<String, dynamic> json) {
    final ultima = json['ultimaOferta'] as String?;
    return EstadoTutorHabilidad(
      fallosConsecutivos: (json['fallos'] as int?) ?? 0,
      ultimaOferta: ultima == null ? null : DateTime.parse(ultima),
      vecesUsado: (json['vecesUsado'] as int?) ?? 0,
    );
  }
}

class DisparadorTutor {
  const DisparadorTutor();

  /// Decide si el tutor debe ofrecerse para una habilidad dado su
  /// estado actual y el momento presente.
  ///
  /// Reglas:
  /// 1. Si los fallos consecutivos no llegan al umbral → no ofrecer.
  /// 2. Si llega al umbral pero hay una oferta reciente dentro del
  ///    cooldown → no volver a ofrecer todavía.
  /// 3. En cualquier otro caso → ofrecer.
  bool deberiaOfrecer(EstadoTutorHabilidad estado, DateTime ahora) {
    if (estado.fallosConsecutivos < fallosConsecutivosParaOfrecer) {
      return false;
    }
    final ultimaOferta = estado.ultimaOferta;
    if (ultimaOferta != null) {
      final transcurrido = ahora.difference(ultimaOferta);
      if (transcurrido < cooldownEntreOfertas) {
        return false;
      }
    }
    return true;
  }
}
