import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/dominio/mosaico_arco_2.dart';
import 'package:las_versiones/vista/pantalla_mosaico_arco_2.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> bombear(
    WidgetTester tester, {
    required Future<void> Function() alEntregar,
  }) async {
    // Viewport amplio para que los 8 fragmentos del ListView entren
    // sin scroll en la prueba.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: PantallaMosaicoArco2(alEntregar: alEntregar),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> marcarFragmento(
    WidgetTester tester,
    int indice,
    String etiquetaNivel,
  ) async {
    final fragmento = MosaicoArco2.fragmentos[indice];
    final hallazgoFragmento = find.text(fragmento.textoLeido);
    await tester.scrollUntilVisible(
      hallazgoFragmento,
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(hallazgoFragmento);
    await tester.pumpAndSettle();
    await tester.tap(find.text(etiquetaNivel.toUpperCase()).last);
    await tester.pumpAndSettle();
  }

  testWidgets('arranque sin fragmentos marcados → CTA "ENTREGAR LA '
      'AUDIO-GUÍA" bloqueado', (tester) async {
    await bombear(tester, alEntregar: () async {});
    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('ENTREGAR LA AUDIO-GUÍA'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNull);
  });

  testWidgets('contador inicial muestra "0 de 8 marcados — faltan 6 para '
      'entregar"', (tester) async {
    await bombear(tester, alEntregar: () async {});
    expect(
      find.textContaining('0 de 8 marcados'),
      findsOneWidget,
    );
    expect(
      find.textContaining('faltan 6'),
      findsOneWidget,
    );
  });

  testWidgets('marcar 5 fragmentos no desbloquea aún el CTA — falta 1',
      (tester) async {
    await bombear(tester, alEntregar: () async {});
    for (var indice = 0; indice < 5; indice++) {
      await marcarFragmento(tester, indice, 'Sólido');
    }
    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('ENTREGAR LA AUDIO-GUÍA'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNull,
        reason: 'el mínimo es 6 fragmentos marcados');
    expect(find.textContaining('faltan 1'), findsOneWidget);
  });

  testWidgets('marcar 6 fragmentos desbloquea el CTA y al pulsarlo '
      'entrega + persiste con clave del Arco 2', (tester) async {
    var entregasInvocadas = 0;
    await bombear(tester, alEntregar: () async {
      entregasInvocadas++;
    });

    await marcarFragmento(tester, 0, 'Sólido');
    await marcarFragmento(tester, 1, 'Disputado');
    await marcarFragmento(tester, 2, 'Sólido');
    await marcarFragmento(tester, 3, 'Probable');
    await marcarFragmento(tester, 4, 'Sólido');
    await marcarFragmento(tester, 5, 'Sólido');

    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('ENTREGAR LA AUDIO-GUÍA'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNotNull);

    await tester.tap(find.text('ENTREGAR LA AUDIO-GUÍA'));
    await tester.pumpAndSettle();
    expect(entregasInvocadas, 1);

    final prefs = await SharedPreferences.getInstance();
    final blob = prefs.getString('nuevoser.lasversiones.mosaico.arco_2');
    expect(
      blob,
      isNotNull,
      reason: 'el blob persiste bajo la clave del Arco 2, no del Arco 1',
    );
    expect(blob, contains('solido'));
    expect(blob, contains('probable'));
    expect(blob, contains('disputado'));
  });

  testWidgets('marcas persistidas reaparecen al volver a abrir',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.mosaico.arco_2':
          '{"pompelo_ara_dos_caras":"solido",'
          '"calagurris_lo_que_quintiliano_omite":"probable",'
          '"domus_la_familia_que_no_aparece":"solido"}',
    });
    await bombear(tester, alEntregar: () async {});
    expect(find.textContaining('3 de 8 marcados'), findsOneWidget);
    expect(find.textContaining('faltan 3'), findsOneWidget);
    expect(find.text('SÓLIDO'), findsNWidgets(2));
    expect(find.text('PROBABLE'), findsOneWidget);
  });

  testWidgets('clave de prefs sigue el namespace nuevoser.lasversiones.* '
      'con sufijo arco_2 distinto del arco_1 del Mosaico M1', (tester) async {
    var entregaInvocada = false;
    await bombear(tester, alEntregar: () async {
      entregaInvocada = true;
    });
    await marcarFragmento(tester, 0, 'Sólido');
    await marcarFragmento(tester, 1, 'Sólido');
    await marcarFragmento(tester, 2, 'Sólido');
    await marcarFragmento(tester, 3, 'Sólido');
    await marcarFragmento(tester, 4, 'Sólido');
    await marcarFragmento(tester, 5, 'Sólido');
    await tester.tap(find.text('ENTREGAR LA AUDIO-GUÍA'));
    await tester.pumpAndSettle();
    expect(entregaInvocada, isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString('nuevoser.lasversiones.mosaico.arco_2'),
      isNotNull,
    );
    expect(
      prefs.getString('nuevoser.lasversiones.mosaico.arco_1'),
      isNull,
      reason: 'el M2 no debe escribir sobre la clave del M1',
    );
  });
}
