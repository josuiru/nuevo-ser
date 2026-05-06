import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_mosaico.dart';
import 'package:las_versiones/dominio/mosaico_arco_1.dart';
import 'package:las_versiones/vista/pantalla_mosaico_arco_1.dart';

GestorPerfiles _gestorDePrueba() => GestorPerfiles(
      namespace: 'nuevoser.lasversiones',
      sufijoNombreVisible: 'nombre_jugador',
      clavesGlobalesNoMigrables: const {
        'nuevoser.lasversiones.idioma_app',
        'nuevoser.lasversiones.token_backend',
        'nuevoser.lasversiones.email_backend',
      },
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> bombear(
    WidgetTester tester, {
    required Future<void> Function() alEntregar,
  }) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: PantallaMosaicoArco1(
          alEntregar: alEntregar,
          repoMosaico: RepositorioMosaico(gestor: _gestorDePrueba()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> marcarVineta(
    WidgetTester tester,
    int indice,
    String etiquetaNivel,
  ) async {
    final vineta = MosaicoArco1.vinetas[indice];
    final hallazgoVineta = find.text(vineta.pieDescriptivo);
    await tester.scrollUntilVisible(
      hallazgoVineta,
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(hallazgoVineta);
    await tester.pumpAndSettle();
    await tester.tap(find.text(etiquetaNivel.toUpperCase()).last);
    await tester.pumpAndSettle();
  }

  testWidgets('arranque sin viñetas marcadas → CTA "ENTREGAR" bloqueado',
      (tester) async {
    await bombear(tester, alEntregar: () async {});
    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('ENTREGAR EL MOSAICO'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNull);
  });

  testWidgets('contador inicial muestra "0 de 8 marcadas — faltan 6 para '
      'entregar"', (tester) async {
    await bombear(tester, alEntregar: () async {});
    expect(
      find.textContaining('0 de 8 marcadas'),
      findsOneWidget,
    );
    expect(
      find.textContaining('faltan 6'),
      findsOneWidget,
    );
  });

  testWidgets('marcar 5 viñetas no desbloquea aún el CTA — falta 1',
      (tester) async {
    await bombear(tester, alEntregar: () async {});
    for (var i = 0; i < 5; i++) {
      await marcarVineta(tester, i, 'Sólido');
    }
    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('ENTREGAR EL MOSAICO'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNull,
        reason: 'el mínimo es 6 viñetas marcadas');
    expect(find.textContaining('faltan 1'), findsOneWidget);
  });

  testWidgets('marcar 6 viñetas desbloquea el CTA y al pulsarlo entrega + '
      'persiste', (tester) async {
    var entregasInvocadas = 0;
    await bombear(tester, alEntregar: () async {
      entregasInvocadas++;
    });

    await marcarVineta(tester, 0, 'Sólido');
    await marcarVineta(tester, 1, 'Probable');
    await marcarVineta(tester, 2, 'Disputado');
    await marcarVineta(tester, 3, 'Sólido');
    await marcarVineta(tester, 4, 'Probable');
    await marcarVineta(tester, 5, 'Disputado');

    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('ENTREGAR EL MOSAICO'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNotNull);

    await tester.tap(find.text('ENTREGAR EL MOSAICO'));
    await tester.pumpAndSettle();
    expect(entregasInvocadas, 1);

    final prefs = await SharedPreferences.getInstance();
    final blob = prefs.getString(
      'nuevoser.lasversiones.perfil.principal.mosaico.arco_1',
    );
    expect(blob, isNotNull);
    expect(blob, contains('solido'));
    expect(blob, contains('probable'));
    expect(blob, contains('disputado'));
  });

  testWidgets('marcas persistidas reaparecen al volver a abrir',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.perfil_activo_id': 'principal',
      'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
      'nuevoser.lasversiones.perfil.principal.mosaico.arco_1':
          '{"aralar_dolmen_visita":"solido","cromlech_banquete":'
          '"probable","irulegi_la_mano":"disputado"}',
    });
    await bombear(tester, alEntregar: () async {});
    // El contador refleja las 3 marcas precargadas — falta 3 para entregar.
    expect(find.textContaining('3 de 8 marcadas'), findsOneWidget);
    expect(find.textContaining('faltan 3'), findsOneWidget);
    // Las etiquetas de nivel aparecen como cabecera de su viñeta.
    expect(find.text('SÓLIDO'), findsOneWidget);
    expect(find.text('PROBABLE'), findsOneWidget);
    expect(find.text('DISPUTADO'), findsOneWidget);
  });

  testWidgets('valores del shape v1 (texto libre) se descartan '
      'silenciosamente al cargar', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.perfil_activo_id': 'principal',
      'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
      'nuevoser.lasversiones.perfil.principal.mosaico.arco_1':
          '{"que_te_llevas":"Que el oficio empieza con preguntas.",'
          '"que_te_queda":"Por qué el sitio se llamaba así."}',
    });
    await bombear(tester, alEntregar: () async {});
    expect(find.textContaining('0 de 8 marcadas'), findsOneWidget);
  });
}
