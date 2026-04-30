import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/vista/pantalla_sit_spot/pantalla_sit_spots_jubilados.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

SitSpot _crear({
  required String id,
  required String nombre,
  String dondeNombre = '',
  required DateTime creadoEn,
  DateTime? retiradoEn,
}) {
  return SitSpot(
    id: id,
    nombre: nombre,
    dondeNombre: dondeNombre,
    creadoEn: creadoEn,
    retiradoEn: retiradoEn,
  );
}

void main() {
  Future<void> bombearPantalla(
    WidgetTester tester,
    List<SitSpot> jubilados,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      home: PantallaSitSpotsJubilados(jubilados: jubilados),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('lista vacía: muestra el mensaje explicativo, sin tarjetas',
      (tester) async {
    await bombearPantalla(tester, const []);
    expect(
      find.textContaining('Aquí aparecerán los sit spots que jubiles'),
      findsOneWidget,
    );
  });

  testWidgets(
    'con un sit spot jubilado: muestra nombre, dondeNombre y periodo activo',
    (tester) async {
      await bombearPantalla(tester, [
        _crear(
          id: 'sit-1',
          nombre: 'El Roble Grande',
          dondeNombre: 'al final del parque',
          creadoEn: DateTime.utc(2025, 9, 1),
          retiradoEn: DateTime.utc(2026, 4, 30),
        ),
      ]);

      expect(find.text('El Roble Grande'), findsOneWidget);
      expect(find.text('al final del parque'), findsOneWidget);
      expect(
        find.text('Estuvo activo del 01/09/2025 al 30/04/2026.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'sit spot sin dondeNombre: la línea descriptiva no se renderiza',
    (tester) async {
      await bombearPantalla(tester, [
        _crear(
          id: 'sit-1',
          nombre: 'mi banco',
          creadoEn: DateTime.utc(2026, 1, 15),
          retiradoEn: DateTime.utc(2026, 4, 30),
        ),
      ]);
      expect(find.text('mi banco'), findsOneWidget);
      expect(find.text('Estuvo activo del 15/01/2026 al 30/04/2026.'),
          findsOneWidget);
    },
  );

  testWidgets('varios jubilados: aparecen todos como tarjetas separadas',
      (tester) async {
    await bombearPantalla(tester, [
      _crear(
        id: 'sit-1',
        nombre: 'El Roble Grande',
        creadoEn: DateTime.utc(2025, 9, 1),
        retiradoEn: DateTime.utc(2026, 4, 30),
      ),
      _crear(
        id: 'sit-2',
        nombre: 'mi banco del parque',
        creadoEn: DateTime.utc(2026, 4, 30),
        retiradoEn: DateTime.utc(2026, 6, 1),
      ),
    ]);

    expect(find.text('El Roble Grande'), findsOneWidget);
    expect(find.text('mi banco del parque'), findsOneWidget);
  });
}
