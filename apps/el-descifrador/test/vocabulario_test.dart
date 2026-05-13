// Tests del modelo VocabularioJugador + RepositorioVocabulario.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_vocabulario.dart';
import 'package:el_descifrador/dominio/lengua.dart';
import 'package:el_descifrador/dominio/vocabulario_jugador.dart';

void main() {
  group('normalizarPalabra', () {
    test('a minúsculas sin tocar tildes', () {
      expect(normalizarPalabra('Más'), 'más');
      expect(normalizarPalabra('JOÃO'), 'joão');
      expect(normalizarPalabra('Eskerrik'), 'eskerrik');
    });

    test('quita puntuación periférica', () {
      expect(normalizarPalabra('Caro,'), 'caro');
      expect(normalizarPalabra('"Inês"'), 'inês');
      expect(normalizarPalabra('¿Qué?'), 'qué');
    });

    test('quita espacios alrededor', () {
      expect(normalizarPalabra('  bacalhau  '), 'bacalhau');
    });

    test('cadena vacía o solo puntuación → vacío', () {
      expect(normalizarPalabra(''), '');
      expect(normalizarPalabra('   '), '');
      expect(normalizarPalabra('...'), '');
    });

    test('"más" y "mas" no se igualan (las tildes son significativas)', () {
      expect(normalizarPalabra('más'), isNot(equals(normalizarPalabra('mas'))));
    });
  });

  group('VocabularioJugador', () {
    test('estado inicial: ninguna lengua, ninguna palabra', () {
      final v = VocabularioJugador.inicial();
      expect(v.lenguasConPalabrasMarcadas(), isEmpty);
      expect(v.marcaDe(Lengua.portugues, 'bacalhau'), isNull);
    });

    test('marcar una palabra la pone en su lengua', () {
      final v = VocabularioJugador.inicial().conPalabraMarcada(
        lengua: Lengua.portugues,
        palabra: 'bacalhau',
        marca: const MarcaPalabra(color: MarcaColor.verde),
      );
      expect(v.marcaDe(Lengua.portugues, 'bacalhau')?.color, MarcaColor.verde);
      expect(v.lenguasConPalabrasMarcadas(), {Lengua.portugues});
    });

    test('normaliza al guardar y al consultar', () {
      final v = VocabularioJugador.inicial().conPalabraMarcada(
        lengua: Lengua.portugues,
        palabra: 'Caro,',
        marca: const MarcaPalabra(color: MarcaColor.verde),
      );
      // Al consultar con otra forma: "caro", "CARO", "caro." todos deben
      // dar la misma marca.
      expect(v.marcaDe(Lengua.portugues, 'caro')?.color, MarcaColor.verde);
      expect(v.marcaDe(Lengua.portugues, 'CARO')?.color, MarcaColor.verde);
      expect(v.marcaDe(Lengua.portugues, 'caro.')?.color, MarcaColor.verde);
    });

    test('marcar de nuevo sustituye marca anterior', () {
      var v = VocabularioJugador.inicial().conPalabraMarcada(
        lengua: Lengua.portugues,
        palabra: 'embaraçada',
        marca: const MarcaPalabra(
          color: MarcaColor.amarillo,
          hipotesis: '¿embarazada?',
        ),
      );
      v = v.conPalabraMarcada(
        lengua: Lengua.portugues,
        palabra: 'embaraçada',
        marca: const MarcaPalabra(
          color: MarcaColor.verde,
          hipotesis: 'avergonzada — falso amigo',
        ),
      );
      final marca = v.marcaDe(Lengua.portugues, 'embaraçada')!;
      expect(marca.color, MarcaColor.verde);
      expect(marca.hipotesis, 'avergonzada — falso amigo');
    });

    test('sinMarcaDe elimina la marca', () {
      var v = VocabularioJugador.inicial().conPalabraMarcada(
        lengua: Lengua.portugues,
        palabra: 'bacalhau',
        marca: const MarcaPalabra(color: MarcaColor.verde),
      );
      v = v.sinMarcaDe(lengua: Lengua.portugues, palabra: 'bacalhau');
      expect(v.marcaDe(Lengua.portugues, 'bacalhau'), isNull);
      expect(v.lenguasConPalabrasMarcadas(), isEmpty);
    });

    test('palabras de distintas lenguas no se confunden', () {
      var v = VocabularioJugador.inicial();
      v = v.conPalabraMarcada(
        lengua: Lengua.portugues,
        palabra: 'largo',
        marca: const MarcaPalabra(color: MarcaColor.verde),
      );
      v = v.conPalabraMarcada(
        lengua: Lengua.italiano,
        palabra: 'largo',
        marca: const MarcaPalabra(
          color: MarcaColor.amarillo,
          hipotesis: 'ancho — no confundir',
        ),
      );
      expect(v.marcaDe(Lengua.portugues, 'largo')?.color, MarcaColor.verde);
      expect(v.marcaDe(Lengua.italiano, 'largo')?.color, MarcaColor.amarillo);
    });

    test('serialización ida y vuelta preserva contenido', () {
      var v = VocabularioJugador.inicial();
      v = v.conPalabraMarcada(
        lengua: Lengua.portugues,
        palabra: 'embaraçada',
        marca: const MarcaPalabra(
          color: MarcaColor.verde,
          hipotesis: 'avergonzada — falso amigo',
        ),
      );
      v = v.conPalabraMarcada(
        lengua: Lengua.italiano,
        palabra: 'pomodori',
        marca: const MarcaPalabra(color: MarcaColor.verde),
      );

      final reconstruido =
          VocabularioJugador.deserializar(v.serializar());

      expect(
        reconstruido.marcaDe(Lengua.portugues, 'embaraçada')?.hipotesis,
        'avergonzada — falso amigo',
      );
      expect(
        reconstruido.marcaDe(Lengua.italiano, 'pomodori')?.color,
        MarcaColor.verde,
      );
    });

    test('deserialización tolera lengua y color desconocidos', () {
      final mapaConBasura = {
        'pt': {
          'bacalhau': {'color': 'verde'},
          'rota': {'color': 'desconocido'},
        },
        'xx': {
          'algo': {'color': 'verde'},
        },
      };
      final v = VocabularioJugador.deserializar(mapaConBasura);
      // pt/bacalhau sí.
      expect(v.marcaDe(Lengua.portugues, 'bacalhau')?.color, MarcaColor.verde);
      // pt/rota tiene color desconocido → ignorada.
      expect(v.marcaDe(Lengua.portugues, 'rota'), isNull);
      // xx no es lengua válida → ignorada.
      expect(v.lenguasConPalabrasMarcadas(), {Lengua.portugues});
    });
  });

  group('RepositorioVocabulario', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve vocabulario inicial', () async {
      final repo = RepositorioVocabulario(idPerfil: 'test-1');
      final v = await repo.cargar();
      expect(v.lenguasConPalabrasMarcadas(), isEmpty);
    });

    test('registrarMarca persiste y se recupera al reabrir', () async {
      final repo = RepositorioVocabulario(idPerfil: 'test-2');
      await repo.registrarMarca(
        lengua: Lengua.portugues,
        palabra: 'bacalhau',
        marca: const MarcaPalabra(color: MarcaColor.verde),
      );

      final repoReabierto = RepositorioVocabulario(idPerfil: 'test-2');
      final v = await repoReabierto.cargar();
      expect(v.marcaDe(Lengua.portugues, 'bacalhau')?.color, MarcaColor.verde);
    });

    test('olvidarMarca elimina y persiste', () async {
      final repo = RepositorioVocabulario(idPerfil: 'test-3');
      await repo.registrarMarca(
        lengua: Lengua.portugues,
        palabra: 'bacalhau',
        marca: const MarcaPalabra(color: MarcaColor.verde),
      );
      await repo.olvidarMarca(
        lengua: Lengua.portugues,
        palabra: 'bacalhau',
      );

      final v = await repo.cargar();
      expect(v.marcaDe(Lengua.portugues, 'bacalhau'), isNull);
    });

    test('perfiles distintos no se contaminan', () async {
      final ana = RepositorioVocabulario(idPerfil: 'ana');
      final luis = RepositorioVocabulario(idPerfil: 'luis');

      await ana.registrarMarca(
        lengua: Lengua.portugues,
        palabra: 'bacalhau',
        marca: const MarcaPalabra(color: MarcaColor.verde),
      );

      final vAna = await ana.cargar();
      final vLuis = await luis.cargar();
      expect(vAna.marcaDe(Lengua.portugues, 'bacalhau'), isNotNull);
      expect(vLuis.marcaDe(Lengua.portugues, 'bacalhau'), isNull);
    });
  });
}
