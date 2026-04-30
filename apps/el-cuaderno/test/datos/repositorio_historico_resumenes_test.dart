import 'package:el_cuaderno/datos/repositorio_historico_resumenes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  RepositorioHistoricoResumenes crear({int maximoEntradas = 3}) {
    return RepositorioHistoricoResumenes(
      prefs: SharedPreferences.getInstance,
      maximoEntradas: maximoEntradas,
    );
  }

  EntradaHistoricoResumen entrada(
    String isoWeek, {
    String summary = 'lorem ipsum',
    String? prompt = '¿pregunta de la semana?',
    DateTime? archivedAt,
  }) {
    return EntradaHistoricoResumen(
      isoWeek: isoWeek,
      summaryText: summary,
      conversationPrompt: prompt,
      archivedAt: archivedAt ?? DateTime.utc(2026, 4, 30),
    );
  }

  test('cargar() en primer arranque devuelve lista vacía', () async {
    expect(await crear().cargar(), isEmpty);
  });

  test('archivar() persiste y cargar() devuelve la entrada', () async {
    final repo = crear();
    await repo.archivar(entrada('2026-W17'));
    final cargadas = await repo.cargar();
    expect(cargadas, hasLength(1));
    expect(cargadas.first.isoWeek, '2026-W17');
    expect(cargadas.first.summaryText, 'lorem ipsum');
  });

  test('archivar() respeta el máximo de entradas (rotación FIFO)',
      () async {
    final repo = crear(maximoEntradas: 3);
    await repo.archivar(entrada('2026-W14',
        archivedAt: DateTime.utc(2026, 4, 1)));
    await repo.archivar(entrada('2026-W15',
        archivedAt: DateTime.utc(2026, 4, 8)));
    await repo.archivar(entrada('2026-W16',
        archivedAt: DateTime.utc(2026, 4, 15)));
    await repo.archivar(entrada('2026-W17',
        archivedAt: DateTime.utc(2026, 4, 22)));
    final cargadas = await repo.cargar();
    expect(cargadas, hasLength(3));
    // La más reciente primero; la más vieja (W14) descartada.
    expect(
      cargadas.map((e) => e.isoWeek),
      ['2026-W17', '2026-W16', '2026-W15'],
    );
  });

  test('archivar() de la misma isoWeek sustituye la entrada existente',
      () async {
    final repo = crear();
    await repo.archivar(entrada('2026-W17', summary: 'primera versión'));
    await repo.archivar(entrada('2026-W17', summary: 'segunda versión'));
    final cargadas = await repo.cargar();
    expect(cargadas, hasLength(1));
    expect(cargadas.first.summaryText, 'segunda versión');
  });

  test('archivar() preserva el orden por archivado descendente', () async {
    final repo = crear();
    await repo.archivar(entrada('2026-W14',
        archivedAt: DateTime.utc(2026, 4, 1)));
    await repo.archivar(entrada('2026-W15',
        archivedAt: DateTime.utc(2026, 4, 8)));
    final cargadas = await repo.cargar();
    expect(cargadas.map((e) => e.isoWeek), ['2026-W15', '2026-W14']);
  });

  test('borrar() vacía el histórico', () async {
    final repo = crear();
    await repo.archivar(entrada('2026-W17'));
    await repo.borrar();
    expect(await repo.cargar(), isEmpty);
  });

  test('borrar() es idempotente — sin entries previas no rompe',
      () async {
    final repo = crear();
    await repo.borrar();
    expect(await repo.cargar(), isEmpty);
  });

  test('JSON corrupto en prefs: cargar() devuelve vacío sin lanzar',
      () async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.cuidador.historico_resumenes':
          'esto-no-es-json',
    });
    expect(await crear().cargar(), isEmpty);
  });

  test('una entrada corrupta dentro de la lista no descarta las demás',
      () async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.cuidador.historico_resumenes':
          '[{"iso_week":"2026-W17","summary_text":"ok","archived_at":"2026-04-30T00:00:00Z"},{"foo":"bar"}]',
    });
    final cargadas = await crear().cargar();
    expect(cargadas, hasLength(1));
    expect(cargadas.first.isoWeek, '2026-W17');
  });

  test('conversationPrompt null se serializa y deserializa fielmente',
      () async {
    final repo = crear();
    await repo.archivar(entrada('2026-W17', prompt: null));
    final cargadas = await repo.cargar();
    expect(cargadas.first.conversationPrompt, isNull);
  });
}
