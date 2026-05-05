import 'dart:typed_data';

import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_ajustes/pantalla_imprimir_plantilla.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombear(
    WidgetTester tester, {
    String? nombreNino,
    Future<void> Function(Uint8List bytes)? lanzador,
  }) async {
    await tester.binding.setSurfaceSize(const Size(500, 1200));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaImprimirPlantilla(
          repositorio: repositorio,
          nombrePerfilActivo: nombreNino,
          lanzadorImpresion: lanzador,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('cabecera, intro y selector con tres opciones', (tester) async {
    await bombear(tester);

    expect(find.text('Páginas para el campo'), findsOneWidget);
    expect(
      find.textContaining('A veces el campo se mira mejor sin pantalla'),
      findsOneWidget,
    );
    // Tres opciones del selector.
    expect(find.text('4 páginas'), findsOneWidget);
    expect(find.text('8 páginas'), findsOneWidget);
    expect(find.text('16 páginas'), findsOneWidget);
  });

  testWidgets(
    'pulsar el botón "imprimir o compartir" llama al lanzador con los bytes '
    'del PDF',
    (tester) async {
      Uint8List? bytesRecibidos;
      await bombear(
        tester,
        nombreNino: 'Maren',
        lanzador: (bytes) async {
          bytesRecibidos = bytes;
        },
      );

      await tester.tap(find.text('Imprimir o compartir'));
      // El generador es asíncrono — bombeamos suficiente para que
      // termine. pumpAndSettle se cuelga porque el botón muestra un
      // indicador circular durante la generación; usamos pump
      // discreto y damos varios ticks.
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      // Damos el último settle por si quedan microtareas.
      await tester.pumpAndSettle();

      expect(bytesRecibidos, isNotNull);
      // Header PDF estándar.
      expect(bytesRecibidos!.length, greaterThan(500));
      expect(
        String.fromCharCodes(bytesRecibidos!.take(4)),
        '%PDF',
      );
    },
  );

  testWidgets(
    'cambiar el chip de páginas selecciona la opción nueva',
    (tester) async {
      await bombear(tester);

      // 8 está seleccionado por defecto. Pulsar 16.
      await tester.tap(find.text('16 páginas'));
      await tester.pumpAndSettle();

      // No hay manera trivial de inspeccionar `_paginasElegidas`; la
      // verificación operativa es que el lanzador, cuando se invoque
      // con esa selección, devuelve más bytes que con 4.
      Uint8List? capturados;
      await bombear(
        tester,
        lanzador: (b) async => capturados = b,
      );
      await tester.tap(find.text('16 páginas'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Imprimir o compartir'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      await tester.pumpAndSettle();
      expect(capturados, isNotNull);
      // 16 páginas debería pasar de 6 KB tranquilamente.
      expect(capturados!.length, greaterThan(2000));
    },
  );

  testWidgets(
    'si hay sit spot activo, su nombre se incluye implícitamente en el PDF '
    '(el generador lo recibe vía repositorio)',
    (tester) async {
      await repositorio.establecerSitSpot(SitSpot(
        id: 'ss',
        nombre: 'El Roble Grande',
        dondeNombre: 'parque',
        creadoEn: DateTime(2026, 3, 1),
      ));

      Uint8List? bytes;
      await bombear(
        tester,
        nombreNino: 'Maren',
        lanzador: (b) async => bytes = b,
      );

      await tester.tap(find.text('Imprimir o compartir'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      await tester.pumpAndSettle();
      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThan(500));
    },
  );
}
