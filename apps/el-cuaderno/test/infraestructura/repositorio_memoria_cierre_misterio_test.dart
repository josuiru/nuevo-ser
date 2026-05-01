import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  Misterio misterioBase({
    String id = 'm1',
    String pregunta = '¿qué insectos visitan las flores azules?',
  }) {
    return Misterio(
      id: id,
      pregunta: pregunta,
      descripcionCorta: 'mira con calma',
      estado: NivelConfianza.hipotesisActiva,
      abierto: true,
    );
  }

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  group('cerrarMisterioParaNino', () {
    test(
      'cerrar misterio inexistente lanza StateError',
      () {
        expect(
          () => repositorio.cerrarMisterioParaNino('inexistente', 'algo'),
          throwsStateError,
        );
      },
    );

    test(
      'cerrar persiste fecha + respuesta y lo saca de obtenerMisteriosAbiertos',
      () async {
        await repositorio.guardarMisterio(misterioBase());
        await repositorio.cerrarMisterioParaNino(
          'm1',
          'vi tres mariposas blancas en abril',
        );
        final abiertos = await repositorio.obtenerMisteriosAbiertos();
        expect(abiertos, isEmpty,
            reason: 'cerrado por niño no aparece como abierto');
        final cerrado = await repositorio.obtenerMisterioPorId('m1');
        expect(cerrado, isNotNull);
        expect(cerrado!.estaCerradoPorNino, isTrue);
        expect(cerrado.respuestaDelNino, 'vi tres mariposas blancas en abril');
      },
    );

    test(
      'cerrar dos veces el mismo misterio lanza StateError',
      () async {
        await repositorio.guardarMisterio(misterioBase());
        await repositorio.cerrarMisterioParaNino('m1', 'primera respuesta');
        expect(
          () => repositorio.cerrarMisterioParaNino('m1', 'segunda respuesta'),
          throwsStateError,
        );
      },
    );

    test(
      'cerrar con respuesta vacía lanza ArgumentError',
      () async {
        await repositorio.guardarMisterio(misterioBase());
        expect(
          () => repositorio.cerrarMisterioParaNino('m1', '   '),
          throwsArgumentError,
        );
      },
    );

    test(
      'el [estado] canónico del consenso no se mueve al cerrar',
      () async {
        await repositorio.guardarMisterio(
          Misterio(
            id: 'm1',
            pregunta: '¿pregunta?',
            descripcionCorta: 'd',
            estado: NivelConfianza.hipotesisActiva,
            abierto: true,
          ),
        );
        await repositorio.cerrarMisterioParaNino('m1', 'mi respuesta');
        final misterio = await repositorio.obtenerMisterioPorId('m1');
        expect(misterio!.estado, NivelConfianza.hipotesisActiva,
            reason: 'el cierre del niño no toca el consenso del catálogo');
      },
    );
  });

  group('obtenerMisteriosCerradosPorNino', () {
    test(
      'lista vacía si nadie ha cerrado nada',
      () async {
        await repositorio.guardarMisterio(misterioBase());
        expect(await repositorio.obtenerMisteriosCerradosPorNino(), isEmpty);
      },
    );

    test(
      'devuelve los más recientemente cerrados primero',
      () async {
        await repositorio.guardarMisterio(misterioBase(id: 'a'));
        await repositorio.guardarMisterio(misterioBase(id: 'b'));
        await repositorio.cerrarMisterioParaNino('a', 'respuesta a');
        await Future<void>.delayed(const Duration(milliseconds: 5));
        await repositorio.cerrarMisterioParaNino('b', 'respuesta b');
        final cerrados = await repositorio.obtenerMisteriosCerradosPorNino();
        expect(cerrados.map((misterio) => misterio.id).toList(), ['b', 'a']);
      },
    );

    test(
      'no incluye misterios retirados',
      () async {
        await repositorio.guardarMisterio(
          Misterio(
            id: 'a',
            pregunta: 'p',
            descripcionCorta: 'd',
            estado: NivelConfianza.hipotesisActiva,
            abierto: true,
            cerradoPorNino: DateTime(2026, 5, 1),
            respuestaDelNino: 'antigua respuesta',
            retiradoEn: DateTime(2026, 5, 2),
          ),
        );
        expect(await repositorio.obtenerMisteriosCerradosPorNino(), isEmpty);
      },
    );
  });

  group('reabrirMisterioParaNino', () {
    test(
      'reabrir un cerrado limpia campos y vuelve a abiertos',
      () async {
        await repositorio.guardarMisterio(misterioBase());
        await repositorio.cerrarMisterioParaNino('m1', 'mi respuesta');
        await repositorio.reabrirMisterioParaNino('m1');
        final misterio = await repositorio.obtenerMisterioPorId('m1');
        expect(misterio!.estaCerradoPorNino, isFalse);
        expect(misterio.respuestaDelNino, isNull);
        final abiertos = await repositorio.obtenerMisteriosAbiertos();
        expect(abiertos.map((misterio) => misterio.id), contains('m1'));
      },
    );

    test(
      'reabrir un misterio ya abierto no hace nada (idempotente)',
      () async {
        await repositorio.guardarMisterio(misterioBase());
        await repositorio.reabrirMisterioParaNino('m1');
        final misterio = await repositorio.obtenerMisterioPorId('m1');
        expect(misterio!.estaCerradoPorNino, isFalse);
      },
    );

    test(
      'reabrir un misterio inexistente lanza StateError',
      () {
        expect(
          () => repositorio.reabrirMisterioParaNino('inexistente'),
          throwsStateError,
        );
      },
    );
  });
}
