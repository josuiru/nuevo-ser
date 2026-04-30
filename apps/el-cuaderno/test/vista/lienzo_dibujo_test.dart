import 'package:el_cuaderno/vista/pantalla_observacion/lienzo_dibujo.dart';
import 'package:flutter/material.dart';
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

  // El IconButton "borrar" usa Icons.refresh; el "guardar dibujo" es
  // un TextButton con ese texto.
  Finder botonBorrar() => find.widgetWithIcon(IconButton, Icons.refresh);
  Finder botonGuardar() =>
      find.widgetWithText(TextButton, 'guardar dibujo');

  testWidgets('estado inicial: botones de borrar y guardar deshabilitados',
      (tester) async {
    await bombearLienzo(tester);

    expect(tester.widget<IconButton>(botonBorrar()).onPressed, isNull);
    expect(tester.widget<TextButton>(botonGuardar()).onPressed, isNull);
  });

  testWidgets('un pan habilita los botones', (tester) async {
    await bombearLienzo(tester);

    final gestureDetector = find.byType(GestureDetector).first;
    await tester.drag(gestureDetector, const Offset(60, 60));
    await tester.pump();

    expect(tester.widget<IconButton>(botonBorrar()).onPressed, isNotNull);
    expect(tester.widget<TextButton>(botonGuardar()).onPressed, isNotNull);
  });

  testWidgets('"borrar y empezar otra vez" vacía los trazos', (tester) async {
    await bombearLienzo(tester);

    final gestureDetector = find.byType(GestureDetector).first;
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
