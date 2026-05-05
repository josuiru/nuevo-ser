import 'dart:io';

import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_lectura/pantalla_lectura_cuaderno.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombear(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: PantallaLecturaCuaderno(
        repositorio: repositorio,
        // Stub que evita el decode async de Image.file en tests.
        constructorImagen: (File _) =>
            const SizedBox(key: ValueKey('imagen-stub')),
      ),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> sembrar(
    String id,
    DateTime cuando,
    String queVio, {
    String? creesQueEs,
  }) async {
    await repositorio.guardarObservacion(Observacion(
      id: id,
      cuandoCreada: cuando,
      cuandoOcurrio: cuando,
      dondeNombre: 'jardín',
      queVio: queVio,
      confianza: creesQueEs != null
          ? NivelConfianza.hipotesisActiva
          : NivelConfianza.noSegura,
      creesQueEs: creesQueEs,
    ));
  }

  testWidgets(
    'cuaderno vacío → cuerpo de estado vacío con voz adulta amable',
    (tester) async {
      await bombear(tester);
      expect(
        find.textContaining('podrás abrir tu cuaderno como un libro'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la primera página muestra la observación más reciente '
    '(orden descendente)',
    (tester) async {
      await sembrar('vieja', DateTime(2026, 4, 1), 'algo de abril');
      await sembrar('nueva', DateTime(2026, 5, 10), 'lo más reciente');
      await bombear(tester);

      // PageView arranca en página 0 = la más reciente.
      expect(find.text('lo más reciente'), findsOneWidget);
      expect(find.text('algo de abril'), findsNothing);
    },
  );

  testWidgets(
    'cabecera muestra fecha + lugar y página tiene queVio en serif',
    (tester) async {
      await sembrar('o1', DateTime(2026, 5, 12), 'una golondrina');
      await bombear(tester);

      expect(find.text('12/05/2026 · jardín'), findsOneWidget);
      expect(find.text('una golondrina'), findsOneWidget);
      // Indicador "1 de 1" al pie.
      expect(find.text('1 de 1'), findsOneWidget);
    },
  );

  testWidgets(
    'línea creesQueEs · confianza aparece sólo si creesQueEs no es vacío',
    (tester) async {
      await sembrar(
        'o1',
        DateTime(2026, 5, 12),
        'algo verde',
        creesQueEs: 'helecho',
      );
      await sembrar('o2', DateTime(2026, 5, 1), 'algo azul');
      await bombear(tester);

      // Página 0: helecho con confianza.
      expect(find.textContaining('helecho · '), findsOneWidget);
    },
  );

  testWidgets(
    'pasar página actualiza el indicador "X de N"',
    (tester) async {
      await sembrar('a', DateTime(2026, 5, 1), 'primera');
      await sembrar('b', DateTime(2026, 5, 2), 'segunda');
      await sembrar('c', DateTime(2026, 5, 3), 'tercera');
      await bombear(tester);

      expect(find.text('1 de 3'), findsOneWidget);

      // Drag hacia la izquierda para avanzar a la siguiente página.
      await tester.drag(
        find.text('tercera'),
        const Offset(-400, 0),
      );
      await tester.pumpAndSettle();

      expect(find.text('2 de 3'), findsOneWidget);
      expect(find.text('segunda'), findsOneWidget);
    },
  );
}
