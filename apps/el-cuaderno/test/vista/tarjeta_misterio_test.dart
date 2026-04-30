import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_cuaderno/tarjeta_misterio.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Misterio crear({String id = 'm-1'}) => Misterio(
        id: id,
        pregunta: '¿Qué seres vivos aparecen tras la lluvia?',
        descripcionCorta: 'pista corta',
        estado: NivelConfianza.hipotesisActiva,
        abierto: true,
      );

  Future<void> bombear(WidgetTester tester, TarjetaMisterio tarjeta) async {
    await tester.binding.setSurfaceSize(const Size(800, 400));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: tarjeta,
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'sin evidencias (null): muestra "todavía no has anotado nada"',
    (tester) async {
      await bombear(tester, TarjetaMisterio(misterio: crear()));
      expect(
        find.text('hipótesis activa · todavía no has anotado nada'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'con evidencias = 0: equivalente a null',
    (tester) async {
      await bombear(
        tester,
        TarjetaMisterio(misterio: crear(), evidencias: 0),
      );
      expect(
        find.text('hipótesis activa · todavía no has anotado nada'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'con 1 evidencia: singular',
    (tester) async {
      await bombear(
        tester,
        TarjetaMisterio(misterio: crear(), evidencias: 1),
      );
      expect(
        find.text('hipótesis activa · 1 evidencia anotada'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'con N>1 evidencias: plural',
    (tester) async {
      await bombear(
        tester,
        TarjetaMisterio(misterio: crear(), evidencias: 4),
      );
      expect(
        find.text('hipótesis activa · 4 evidencias anotadas'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'pulsar invoca alPulsar',
    (tester) async {
      var llamadas = 0;
      await bombear(
        tester,
        TarjetaMisterio(
          misterio: crear(),
          alPulsar: () => llamadas++,
        ),
      );
      await tester.tap(find.text('¿Qué seres vivos aparecen tras la lluvia?'));
      await tester.pumpAndSettle();
      expect(llamadas, 1);
    },
  );
}
