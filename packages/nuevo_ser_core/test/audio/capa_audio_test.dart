import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  test('CapaAudio expone las cuatro capas con sus claves canónicas', () {
    expect(
      CapaAudio.values.map((c) => c.clave).toList(),
      ['ambient', 'musica', 'efectos', 'narrativos'],
    );
  });

  test('CapaAudio: volúmenes predeterminados sensatos por capa', () {
    expect(CapaAudio.ambient.volumenPredeterminado, 45);
    expect(CapaAudio.musica.volumenPredeterminado, 70);
    expect(CapaAudio.efectos.volumenPredeterminado, 80);
    expect(CapaAudio.narrativos.volumenPredeterminado, 85);
  });

  test('CapaAudio: nombreVisible es lo que se muestra en UI', () {
    expect(CapaAudio.ambient.nombreVisible, 'Ambiente');
    expect(CapaAudio.musica.nombreVisible, 'Música');
    expect(CapaAudio.efectos.nombreVisible, 'Efectos');
    expect(CapaAudio.narrativos.nombreVisible, 'Narrativos');
  });

  test('defaultsPorClave produce el mapa que espera RepositorioPreferenciasAudio',
      () {
    final defaults = CapaAudio.defaultsPorClave();
    expect(defaults, {
      'ambient': 45,
      'musica': 70,
      'efectos': 80,
      'narrativos': 85,
    });
  });

  test('narrativos es la capa que dispara el ducking en consumidores',
      () {
    // Documenta el invariante: cualquier consumidor que aplique ducking
    // compara contra `CapaAudio.narrativos`. Si esto cambia, el test
    // falla y obliga a revisar todos los call sites.
    expect(CapaAudio.narrativos.clave, 'narrativos');
  });
}
