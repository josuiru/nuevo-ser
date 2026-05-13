// Tests de familiaridad con remitentes.
//
// Cubren el modelo puro (NivelFamiliaridad, FamiliaridadRemitente) y
// el repositorio con SharedPreferences inyectable.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_familiaridad.dart';
import 'package:el_descifrador/dominio/familiaridad_remitente.dart';
import 'package:el_descifrador/dominio/voz_remitente.dart';

void main() {
  group('NivelFamiliaridad', () {
    test('cero piezas → desconocido', () {
      expect(
        NivelFamiliaridad.desdePiezas(0),
        NivelFamiliaridad.desconocido,
      );
    });

    test('una pieza → saludando', () {
      expect(
        NivelFamiliaridad.desdePiezas(1),
        NivelFamiliaridad.saludando,
      );
    });

    test('umbrales documentados: 3 conocido, 7 familiar, 15 cercano', () {
      expect(NivelFamiliaridad.desdePiezas(3), NivelFamiliaridad.conocido);
      expect(NivelFamiliaridad.desdePiezas(7), NivelFamiliaridad.familiar);
      expect(NivelFamiliaridad.desdePiezas(15), NivelFamiliaridad.cercano);
    });

    test('umbrales intermedios mantienen nivel anterior', () {
      // 5 piezas todavía es "conocido" (umbral familiar es 7).
      expect(NivelFamiliaridad.desdePiezas(5), NivelFamiliaridad.conocido);
      // 14 piezas todavía es "familiar" (umbral cercano es 15).
      expect(NivelFamiliaridad.desdePiezas(14), NivelFamiliaridad.familiar);
    });

    test('por encima de 15 sigue siendo cercano (techo)', () {
      expect(NivelFamiliaridad.desdePiezas(100), NivelFamiliaridad.cercano);
    });
  });

  group('FamiliaridadRemitente', () {
    test('estado inicial: ningún remitente conocido', () {
      final inicial = FamiliaridadRemitente.inicial();

      expect(inicial.remitentesConocidos(), isEmpty);
      for (final remitente in VozRemitente.values) {
        expect(inicial.piezasTrabajadasCon(remitente), 0);
        expect(inicial.nivelCon(remitente), NivelFamiliaridad.desconocido);
      }
    });

    test('una pieza trabajada con Inês la convierte en "saludando"', () {
      final inicial = FamiliaridadRemitente.inicial();
      final tras = inicial.conPiezaTrabajadaCon(VozRemitente.inesCocineraLisboa);

      expect(
        tras.piezasTrabajadasCon(VozRemitente.inesCocineraLisboa),
        1,
      );
      expect(
        tras.nivelCon(VozRemitente.inesCocineraLisboa),
        NivelFamiliaridad.saludando,
      );
      expect(
        tras.remitentesConocidos(),
        {VozRemitente.inesCocineraLisboa},
      );
    });

    test('siete piezas con Inês la convierten en "familiar"', () {
      FamiliaridadRemitente estado = FamiliaridadRemitente.inicial();
      for (var i = 0; i < 7; i++) {
        estado = estado.conPiezaTrabajadaCon(VozRemitente.inesCocineraLisboa);
      }

      expect(
        estado.piezasTrabajadasCon(VozRemitente.inesCocineraLisboa),
        7,
      );
      expect(
        estado.nivelCon(VozRemitente.inesCocineraLisboa),
        NivelFamiliaridad.familiar,
      );
    });

    test('el incremento solo afecta al remitente correspondiente', () {
      final inicial = FamiliaridadRemitente.inicial();
      final tras = inicial.conPiezaTrabajadaCon(VozRemitente.iriaCapitana);

      // Iria sube.
      expect(tras.piezasTrabajadasCon(VozRemitente.iriaCapitana), 1);
      // Las demás siguen a cero.
      expect(tras.piezasTrabajadasCon(VozRemitente.inesCocineraLisboa), 0);
      expect(tras.piezasTrabajadasCon(VozRemitente.mansfieldMedicoBristol), 0);
    });

    test(
      'pieza con remitente null (voz puntual como Niko) no produce cambio',
      () {
        final inicial = FamiliaridadRemitente.inicial();
        final tras = inicial.conPiezaTrabajadaCon(null);

        // Mismo estado: nadie ha subido.
        expect(tras.remitentesConocidos(), isEmpty);
        // Niveles invariables.
        for (final remitente in VozRemitente.values) {
          expect(tras.nivelCon(remitente), NivelFamiliaridad.desconocido);
        }
      },
    );

    test('serialización ida y vuelta preserva el estado', () {
      FamiliaridadRemitente estado = FamiliaridadRemitente.inicial();
      // Tres piezas con Inês, una con Iria, ninguna con los demás.
      for (var i = 0; i < 3; i++) {
        estado = estado.conPiezaTrabajadaCon(VozRemitente.inesCocineraLisboa);
      }
      estado = estado.conPiezaTrabajadaCon(VozRemitente.iriaCapitana);

      final serializado = estado.serializar();
      final reconstruido = FamiliaridadRemitente.deserializar(serializado);

      expect(
        reconstruido.piezasTrabajadasCon(VozRemitente.inesCocineraLisboa),
        3,
      );
      expect(
        reconstruido.piezasTrabajadasCon(VozRemitente.iriaCapitana),
        1,
      );
      expect(reconstruido.remitentesConocidos().length, 2);
    });

    test(
      'deserialización tolera identificadores desconocidos sin reventar',
      () {
        // Simula un mapa que contiene un identificador que ya no existe
        // (por ejemplo, un remitente eliminado entre versiones).
        final mapaConDesconocido = {
          'ines_cocinera_lisboa': 2,
          'remitente_que_ya_no_existe': 5,
        };

        final reconstruido = FamiliaridadRemitente.deserializar(
          mapaConDesconocido,
        );

        // El conocido sí se conserva.
        expect(
          reconstruido.piezasTrabajadasCon(VozRemitente.inesCocineraLisboa),
          2,
        );
        // El desconocido se ignora silenciosamente (no rompe nada).
        expect(reconstruido.remitentesConocidos().length, 1);
      },
    );
  });

  group('RepositorioFamiliaridad', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve estado inicial', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = RepositorioFamiliaridad(idPerfil: 'test-1');

      final estado = await repo.cargar();

      expect(estado.remitentesConocidos(), isEmpty);
    });

    test('registrarPiezaTrabajada persiste y permite recargar', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = RepositorioFamiliaridad(idPerfil: 'test-2');

      await repo.registrarPiezaTrabajada(VozRemitente.beaMaestraEscuela);
      await repo.registrarPiezaTrabajada(VozRemitente.beaMaestraEscuela);
      await repo.registrarPiezaTrabajada(VozRemitente.joanBoticarioPuerto);

      // Otro repositorio para mismo perfil — simula cierre/reapertura.
      final repoReabierto = RepositorioFamiliaridad(idPerfil: 'test-2');
      final estado = await repoReabierto.cargar();

      expect(
        estado.piezasTrabajadasCon(VozRemitente.beaMaestraEscuela),
        2,
      );
      expect(
        estado.piezasTrabajadasCon(VozRemitente.joanBoticarioPuerto),
        1,
      );
    });

    test('perfiles distintos no se contaminan entre sí', () async {
      SharedPreferences.setMockInitialValues({});

      final repoAna = RepositorioFamiliaridad(idPerfil: 'ana');
      final repoLuis = RepositorioFamiliaridad(idPerfil: 'luis');

      await repoAna.registrarPiezaTrabajada(VozRemitente.iriaCapitana);
      await repoAna.registrarPiezaTrabajada(VozRemitente.iriaCapitana);
      await repoLuis.registrarPiezaTrabajada(VozRemitente.iriaCapitana);

      final estadoAna = await repoAna.cargar();
      final estadoLuis = await repoLuis.cargar();

      expect(estadoAna.piezasTrabajadasCon(VozRemitente.iriaCapitana), 2);
      expect(estadoLuis.piezasTrabajadasCon(VozRemitente.iriaCapitana), 1);
    });

    test('borrar deja el perfil a estado inicial', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = RepositorioFamiliaridad(idPerfil: 'test-3');

      await repo.registrarPiezaTrabajada(VozRemitente.manuelEditorBoletin);
      await repo.borrar();

      final estado = await repo.cargar();
      expect(estado.remitentesConocidos(), isEmpty);
    });

    test('voz puntual no recurrente (null) no escribe nada', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = RepositorioFamiliaridad(idPerfil: 'test-4');

      // Niko el compañero aprendiz es voz puntual, no recurrente —
      // VozRemitente.desdeIdentificador('aprendiz-companero-niko') devuelve
      // null. El registro con null no debe escribir nada.
      await repo.registrarPiezaTrabajada(null);

      final estado = await repo.cargar();
      expect(estado.remitentesConocidos(), isEmpty);
    });
  });
}
