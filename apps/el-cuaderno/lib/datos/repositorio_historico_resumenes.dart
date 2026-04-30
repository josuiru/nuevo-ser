import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Una entrada del histórico — un resumen LLM ya archivado tras una
/// sincronización exitosa con `/companion/aggregates/weekly`. La
/// pantalla del cuidador la muestra bajo la sección "Resúmenes
/// anteriores" para dar continuidad a la pregunta para la cena.
///
/// Texto del LLM ya pasó por el filtro de PII server-side
/// (`NS_Filtro_Tutor::revisar_respuesta`); persistir local es
/// equivalente a guardar el `summary_text` que el adulto ya leyó.
class EntradaHistoricoResumen {
  const EntradaHistoricoResumen({
    required this.isoWeek,
    required this.summaryText,
    required this.conversationPrompt,
    required this.archivedAt,
  });

  /// Semana ISO 8601 a la que corresponde el resumen (formato
  /// `YYYY-Www`). Se usa para etiquetar la entrada visualmente —
  /// "semana del DD/MM" se calcula sobre este string.
  final String isoWeek;

  /// Texto agregado del resumen tal como lo devolvió el LLM. Puede
  /// estar vacío si el filtro server-side rechazó la respuesta.
  final String summaryText;

  /// Pregunta para la cena ("conversation_prompt") del LLM. Puede ser
  /// null si el filtro la rechazó.
  final String? conversationPrompt;

  /// Cuándo se archivó esta entrada localmente (la sincronización
  /// exitosa). Puede coincidir o no con la fecha del corte semanal —
  /// la pantalla la usa para ordenar y mostrar "hace N días".
  final DateTime archivedAt;

  Map<String, Object?> aJson() => {
        'iso_week': isoWeek,
        'summary_text': summaryText,
        'conversation_prompt': conversationPrompt,
        'archived_at': archivedAt.toIso8601String(),
      };

  static EntradaHistoricoResumen deJson(Map<String, Object?> json) {
    return EntradaHistoricoResumen(
      isoWeek: json['iso_week'] as String,
      summaryText: (json['summary_text'] as String?) ?? '',
      conversationPrompt: json['conversation_prompt'] as String?,
      archivedAt: DateTime.parse(json['archived_at'] as String),
    );
  }
}

/// Persistencia local del histórico de los últimos resúmenes
/// sincronizados. Guarda hasta [maximoEntradas] (default 3) y
/// rotacional: cada nueva entrada empuja la más antigua fuera de la
/// lista.
///
/// Por qué 3: la pantalla del cuidador es para mirar la pregunta para
/// la cena de la semana. Tres semanas son suficientes para dar
/// continuidad ("la semana pasada hablábamos de…") sin convertir la
/// pantalla en un dashboard que invite a la comparación cuantitativa
/// del ritmo del niño (biblia §2.7).
///
/// Por qué prefs y no Isar: tres entradas con dos strings y dos fechas
/// caben en una clave-valor sin overhead. Isar tendría sentido si el
/// histórico fuera unbounded o si quisiéramos consultas (filtrar por
/// rango de fechas, por ejemplo) — no es el caso.
///
/// Aislamiento por-perfil: clave global hoy. Si en el futuro entra
/// soporte multi-perfil real, basta con migrar al patrón
/// `<ns>.perfil.<id>.<sufijo>` reutilizando `GestorPerfiles` del core.
class RepositorioHistoricoResumenes {
  RepositorioHistoricoResumenes({
    required Future<SharedPreferences> Function() prefs,
    String clave = 'nuevoser.elcuaderno.cuidador.historico_resumenes',
    int maximoEntradas = 3,
  })  : _prefs = prefs,
        _clave = clave,
        _maximoEntradas = maximoEntradas;

  final Future<SharedPreferences> Function() _prefs;
  final String _clave;
  final int _maximoEntradas;

  /// Devuelve las entradas archivadas, las más recientes primero. Si
  /// la clave no existe, devuelve lista vacía. Si el JSON persistido
  /// está corrupto (formato cambió, edición a mano), auto-cura
  /// devolviendo lista vacía sin lanzar — evita que un cuaderno entero
  /// quede inutilizable por un parser fallido.
  Future<List<EntradaHistoricoResumen>> cargar() async {
    final prefs = await _prefs();
    final crudo = prefs.getString(_clave);
    if (crudo == null || crudo.isEmpty) return const [];
    try {
      final decoded = jsonDecode(crudo);
      if (decoded is! List) return const [];
      final entradas = <EntradaHistoricoResumen>[];
      for (final item in decoded) {
        if (item is! Map) continue;
        try {
          entradas.add(EntradaHistoricoResumen.deJson(
            item.cast<String, Object?>(),
          ));
        } catch (_) {
          // Una entrada corrupta no descarta el resto.
        }
      }
      return entradas;
    } catch (_) {
      return const [];
    }
  }

  /// Archiva una nueva entrada. Si ya hay [maximoEntradas], descarta
  /// la más antigua. Si ya existe una entrada con la misma `isoWeek`,
  /// la sustituye (re-sincronización de la misma semana — el LLM
  /// puede dar otro texto si el filtro cambia o si llegaron más
  /// observaciones a la semana antes del corte).
  Future<void> archivar(EntradaHistoricoResumen entrada) async {
    final actuales = await cargar();
    final filtradas = [
      for (final e in actuales)
        if (e.isoWeek != entrada.isoWeek) e,
    ];
    final nuevas = [entrada, ...filtradas];
    final recortadas = nuevas.length > _maximoEntradas
        ? nuevas.sublist(0, _maximoEntradas)
        : nuevas;
    final prefs = await _prefs();
    await prefs.setString(
      _clave,
      jsonEncode(recortadas.map((e) => e.aJson()).toList()),
    );
  }

  /// Borra el histórico entero. Lo invoca el flujo "borrar mi
  /// cuaderno" — sin esto, los resúmenes anteriores quedaban
  /// huérfanos en disco aunque las observaciones que los habían
  /// generado ya no existieran.
  Future<void> borrar() async {
    final prefs = await _prefs();
    await prefs.remove(_clave);
  }
}
