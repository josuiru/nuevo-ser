import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_sit_spot/pantalla_pagina_sit_spot_jubilado.dart';
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
    List<SitSpot> jubilados, {
    RepositorioMemoria? repositorio,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: PantallaSitSpotsJubilados(
        jubilados: jubilados,
        repositorio: repositorio,
      ),
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

  testWidgets(
    'con repositorio: cada tarjeta muestra el contador de observaciones',
    (tester) async {
      final repo = RepositorioMemoria();
      // Tres observaciones contra sit-1, ninguna contra sit-2.
      for (var i = 0; i < 3; i++) {
        await repo.guardarObservacion(Observacion(
          id: 'obs-$i',
          cuandoCreada: DateTime.utc(2026, 1, 15 + i),
          cuandoOcurrio: DateTime.utc(2026, 1, 15 + i),
          dondeNombre: 'el banco',
          sitSpotId: 'sit-1',
          queVio: 'algo $i',
          confianza: NivelConfianza.hipotesisActiva,
        ));
      }
      await bombearPantalla(
        tester,
        [
          _crear(
            id: 'sit-1',
            nombre: 'banco viejo',
            creadoEn: DateTime.utc(2026, 1, 1),
            retiradoEn: DateTime.utc(2026, 4, 30),
          ),
          _crear(
            id: 'sit-2',
            nombre: 'roble del parque',
            creadoEn: DateTime.utc(2026, 5, 1),
            retiradoEn: DateTime.utc(2026, 6, 1),
          ),
        ],
        repositorio: repo,
      );

      expect(find.text('3 observaciones guardadas'), findsOneWidget);
      expect(find.text('Sin observaciones guardadas.'), findsOneWidget);
    },
  );

  testWidgets(
    'con repositorio: pulsar tarjeta abre PantallaPaginaSitSpotJubilado',
    (tester) async {
      final repo = RepositorioMemoria();
      await repo.guardarObservacion(Observacion(
        id: 'obs-1',
        cuandoCreada: DateTime.utc(2026, 1, 15),
        cuandoOcurrio: DateTime.utc(2026, 1, 15),
        dondeNombre: 'el banco',
        sitSpotId: 'sit-1',
        queVio: 'una hoja con borde rojizo',
        creesQueEs: 'roble',
        confianza: NivelConfianza.consenso,
      ));
      await bombearPantalla(
        tester,
        [
          _crear(
            id: 'sit-1',
            nombre: 'banco viejo',
            creadoEn: DateTime.utc(2026, 1, 1),
            retiradoEn: DateTime.utc(2026, 4, 30),
          ),
        ],
        repositorio: repo,
      );

      await tester.tap(find.text('banco viejo'));
      await tester.pumpAndSettle();

      expect(find.byType(PantallaPaginaSitSpotJubilado), findsOneWidget);
      // Cabecera del sit spot.
      expect(find.text('banco viejo'), findsAtLeastNWidgets(1));
      expect(
        find.text('Estuvo activo del 01/01/2026 al 30/04/2026.'),
        findsOneWidget,
      );
      // Listado de observaciones.
      expect(find.text('1 observación guardada'), findsOneWidget);
      expect(find.text('una hoja con borde rojizo'), findsOneWidget);
      expect(find.textContaining('roble'), findsOneWidget);
    },
  );

  testWidgets(
    'pantalla detalle sin observaciones: mensaje amable',
    (tester) async {
      final repo = RepositorioMemoria();
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      await tester.pumpWidget(MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaPaginaSitSpotJubilado(
          sitSpot: _crear(
            id: 'sit-vacío',
            nombre: 'paseo del río',
            creadoEn: DateTime.utc(2026, 2, 1),
            retiradoEn: DateTime.utc(2026, 3, 1),
          ),
          repositorio: repo,
        ),
      ));
      await tester.pumpAndSettle();
      expect(
        find.text('No hay observaciones guardadas en esta página.'),
        findsOneWidget,
      );
    },
  );
}
