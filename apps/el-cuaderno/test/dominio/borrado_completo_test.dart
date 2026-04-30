import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepositorioLocal.borrarTodoLoLocal', () {
    test('repositorio vacío: total = 0', () async {
      final repositorio = RepositorioMemoria();
      final resultado = await repositorio.borrarTodoLoLocal();
      expect(resultado.total, 0);
      expect(resultado.observacionesBorradas, 0);
      expect(resultado.misteriosBorrados, 0);
      expect(resultado.sitSpotsBorrados, 0);
    });

    test('cuenta observaciones, sit spot activo y misterios borrados',
        () async {
      final repositorio = RepositorioMemoria();
      await repositorio.guardarObservacion(Observacion(
        id: 'obs-1',
        cuandoCreada: DateTime(2026, 4, 30),
        cuandoOcurrio: DateTime(2026, 4, 30),
        dondeNombre: 'parque',
        queVio: 'algo',
        confianza: NivelConfianza.hipotesisActiva,
      ));
      await repositorio.guardarObservacion(Observacion(
        id: 'obs-2',
        cuandoCreada: DateTime(2026, 4, 30),
        cuandoOcurrio: DateTime(2026, 4, 30),
        dondeNombre: 'parque',
        queVio: 'otra cosa',
        confianza: NivelConfianza.hipotesisActiva,
      ));
      await repositorio.establecerSitSpot(SitSpot(
        id: 'sp-1',
        nombre: 'roble',
        dondeNombre: 'parque',
        creadoEn: DateTime(2026, 3, 1),
      ));
      await repositorio.guardarMisterio(Misterio(
        id: 'mist-1',
        pregunta: '¿qué?',
        descripcionCorta: '',
        estado: NivelConfianza.consenso,
        abierto: true,
      ));

      final resultado = await repositorio.borrarTodoLoLocal();
      expect(resultado.observacionesBorradas, 2);
      expect(resultado.misteriosBorrados, 1);
      expect(resultado.sitSpotsBorrados, 1);
      expect(resultado.total, 4);

      // Verificación del estado final.
      expect(await repositorio.obtenerObservaciones(), isEmpty);
      expect(await repositorio.obtenerMisteriosAbiertos(), isEmpty);
      expect(await repositorio.obtenerSitSpot(), isNull);
    });

    test('cuenta también sit spots retirados', () async {
      final repositorio = RepositorioMemoria();
      // Sit spot activo.
      await repositorio.establecerSitSpot(SitSpot(
        id: 'sp-1',
        nombre: 'primero',
        dondeNombre: 'parque',
        creadoEn: DateTime(2026, 1, 1),
      ));
      // Cambio de sit spot → el primero queda como retirado.
      await repositorio.establecerSitSpot(SitSpot(
        id: 'sp-2',
        nombre: 'segundo',
        dondeNombre: 'monte',
        creadoEn: DateTime(2026, 4, 1),
      ));
      final resultado = await repositorio.borrarTodoLoLocal();
      // 1 retirado + 1 activo = 2.
      expect(resultado.sitSpotsBorrados, 2);
    });

    test('borrado es idempotente: llamar dos veces no rompe', () async {
      final repositorio = RepositorioMemoria();
      await repositorio.guardarObservacion(Observacion(
        id: 'obs-1',
        cuandoCreada: DateTime(2026, 4, 30),
        cuandoOcurrio: DateTime(2026, 4, 30),
        dondeNombre: 'parque',
        queVio: 'algo',
        confianza: NivelConfianza.hipotesisActiva,
      ));
      final primero = await repositorio.borrarTodoLoLocal();
      final segundo = await repositorio.borrarTodoLoLocal();
      expect(primero.observacionesBorradas, 1);
      expect(segundo.observacionesBorradas, 0);
      expect(segundo.total, 0);
    });
  });
}
