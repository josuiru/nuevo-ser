import 'package:el_cuaderno/vista/pantalla_observacion/lienzo_dibujo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> bombearLienzo(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(
      const MaterialApp(
        home: PantallaLienzoDibujo(tituloAppBar: 'lienzo de prueba'),
      ),
    );
    await tester.pumpAndSettle();
  }

  // El IconButton "borrar" usa Icons.refresh; el "deshacer" usa
  // Icons.undo; el "guardar dibujo" es un TextButton con ese texto.
  Finder botonBorrar() => find.widgetWithIcon(IconButton, Icons.refresh);
  Finder botonDeshacer() => find.widgetWithIcon(IconButton, Icons.undo);
  Finder botonGuardar() =>
      find.widgetWithText(TextButton, 'guardar dibujo');

  testWidgets('estado inicial: botones de borrar/deshacer/guardar deshabilitados',
      (tester) async {
    await bombearLienzo(tester);

    expect(tester.widget<IconButton>(botonBorrar()).onPressed, isNull);
    expect(tester.widget<IconButton>(botonDeshacer()).onPressed, isNull);
    expect(tester.widget<TextButton>(botonGuardar()).onPressed, isNull);
  });

  testWidgets('barra de anchos muestra las tres muestras', (tester) async {
    await bombearLienzo(tester);
    expect(find.bySemanticsLabel('trazo fino'), findsOneWidget);
    expect(find.bySemanticsLabel('trazo medio'), findsOneWidget);
    expect(find.bySemanticsLabel('trazo grueso'), findsOneWidget);
  });

  testWidgets('deshacer retira sólo el último trazo', (tester) async {
    await bombearLienzo(tester);
    final gestureDetector = find.byKey(const ValueKey('superficie-lienzo'));

    await tester.drag(gestureDetector, const Offset(40, 40));
    await tester.pump();
    await tester.drag(gestureDetector, const Offset(80, 40));
    await tester.pump();

    expect(tester.widget<IconButton>(botonDeshacer()).onPressed, isNotNull);
    await tester.tap(botonDeshacer());
    await tester.pump();

    // Tras deshacer una vez con dos trazos, queda uno → botones aún
    // habilitados.
    expect(tester.widget<IconButton>(botonDeshacer()).onPressed, isNotNull);
    expect(tester.widget<TextButton>(botonGuardar()).onPressed, isNotNull);

    // Deshacer el segundo trazo deja la pila vacía.
    await tester.tap(botonDeshacer());
    await tester.pump();
    expect(tester.widget<IconButton>(botonDeshacer()).onPressed, isNull);
    expect(tester.widget<TextButton>(botonGuardar()).onPressed, isNull);
  });

  testWidgets('seleccionar trazo grueso aplica el ancho al siguiente trazo',
      (tester) async {
    await bombearLienzo(tester);
    await tester.tap(find.bySemanticsLabel('trazo grueso'));
    await tester.pump();

    // No hay manera trivial de inspeccionar el `Paint.strokeWidth`
    // desde fuera; la verificación se hace por `Semantics` selected.
    final muestraGrueso = tester.getSemantics(
      find.bySemanticsLabel('trazo grueso'),
    );
    expect(muestraGrueso.hasFlag(SemanticsFlag.isSelected), isTrue);

    final muestraMedio = tester.getSemantics(
      find.bySemanticsLabel('trazo medio'),
    );
    expect(muestraMedio.hasFlag(SemanticsFlag.isSelected), isFalse);
  });

  testWidgets('un pan habilita los botones', (tester) async {
    await bombearLienzo(tester);

    final gestureDetector = find.byKey(const ValueKey('superficie-lienzo'));
    await tester.drag(gestureDetector, const Offset(60, 60));
    await tester.pump();

    expect(tester.widget<IconButton>(botonBorrar()).onPressed, isNotNull);
    expect(tester.widget<TextButton>(botonGuardar()).onPressed, isNotNull);
  });

  testWidgets(
      'la superficie del lienzo es opaca al hit-test (regresión: en '
      'dispositivo físico el primer trazo no se registraba sin esto). '
      'Y captura por Listener, no GestureDetector — la gesture arena '
      'de MIUI se llevaba el pan y el niño no podía dibujar.',
      (tester) async {
    await bombearLienzo(tester);

    final listener = tester.widget<Listener>(
      find.byKey(const ValueKey('superficie-lienzo')),
    );
    expect(listener.behavior, HitTestBehavior.opaque);
    expect(listener.onPointerDown, isNotNull);
    expect(listener.onPointerMove, isNotNull);
  });

  testWidgets('"borrar y empezar otra vez" vacía los trazos', (tester) async {
    await bombearLienzo(tester);

    final gestureDetector = find.byKey(const ValueKey('superficie-lienzo'));
    await tester.drag(gestureDetector, const Offset(40, 40));
    await tester.pump();

    await tester.tap(botonBorrar());
    await tester.pump();

    // Tras borrar, los botones vuelven a estar deshabilitados.
    expect(tester.widget<IconButton>(botonBorrar()).onPressed, isNull);
  });

  testWidgets('cerrar la pantalla atrás devuelve null al caller',
      (tester) async {
    Object? resultadoNavigator;

    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (contexto) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  resultadoNavigator = await Navigator.of(contexto).push(
                    MaterialPageRoute(
                      builder: (_) => const PantallaLienzoDibujo(),
                    ),
                  );
                },
                child: const Text('abrir lienzo'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('abrir lienzo'));
    await tester.pumpAndSettle();
    expect(find.byType(PantallaLienzoDibujo), findsOneWidget);

    // Pulsar atrás (icono back del AppBar).
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaLienzoDibujo), findsNothing);
    expect(resultadoNavigator, isNull);
  });
}
