import 'package:el_cuaderno/dominio/geolocalizacion_privacy_first.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_sit_spot/pantalla_crear_sit_spot.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake en línea del contrato de geolocalización (idéntico al usado
/// en pantalla_observacion_geo_test.dart — duplicado a propósito para
/// que cada test sea autocontenido).
class _ServicioGeoFake implements ServicioGeolocalizacion {
  _ServicioGeoFake({
    this.permisoInicial = PermisoGeo.noSolicitado,
    this.permisoTrasPedir = PermisoGeo.concedido,
    this.coordenadas = const Coordenadas(lat: 42.81234, lng: -1.64321),
  });

  PermisoGeo permisoInicial;
  PermisoGeo permisoTrasPedir;
  Coordenadas? coordenadas;

  @override
  Future<PermisoGeo> permiso() async => permisoInicial;

  @override
  Future<PermisoGeo> pedirPermiso() async {
    permisoInicial = permisoTrasPedir;
    return permisoTrasPedir;
  }

  @override
  Future<Coordenadas?> coordenadasActuales({
    Duration tiempoEspera = const Duration(seconds: 8),
  }) async => coordenadas;
}

void main() {
  Future<void> bombearPantalla(
    WidgetTester tester, {
    required Future<void> Function(SitSpot) alConfirmar,
    ServicioGeolocalizacion? servicio,
    Future<bool> Function(BuildContext)? confirmarPrePermisoOverride,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: PantallaCrearSitSpot(
        alConfirmar: alConfirmar,
        servicioGeolocalizacion: servicio,
        confirmarPrePermisoGeoOverride: confirmarPrePermisoOverride,
        proveedorAhora: () => DateTime.utc(2026, 4, 30, 17, 48),
        proveedorIds: () => 'sit-spot-test-id',
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('botón guardar deshabilitado mientras el nombre está vacío',
      (tester) async {
    var llamado = false;
    await bombearPantalla(
      tester,
      alConfirmar: (_) async => llamado = true,
    );

    final boton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'guardar sit spot'),
    );
    expect(boton.onPressed, isNull);
    expect(llamado, isFalse);
  });

  testWidgets(
    'rellenar nombre + pulsar guardar: confirma con SitSpot y persiste nombre+donde',
    (tester) async {
      SitSpot? sitSpotConfirmado;
      await bombearPantalla(
        tester,
        alConfirmar: (sitSpot) async {
          sitSpotConfirmado = sitSpot;
        },
      );

      await tester.enterText(find.byType(TextField).at(0), 'el roble grande');
      await tester.enterText(
        find.byType(TextField).at(1),
        'al final del parque',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('guardar sit spot'));
      await tester.pumpAndSettle();

      expect(sitSpotConfirmado, isNotNull);
      expect(sitSpotConfirmado!.id, 'sit-spot-test-id');
      expect(sitSpotConfirmado!.nombre, 'el roble grande');
      expect(sitSpotConfirmado!.dondeNombre, 'al final del parque');
      expect(sitSpotConfirmado!.coordenadas, isNull);
      expect(sitSpotConfirmado!.creadoEn, DateTime.utc(2026, 4, 30, 17, 48));
    },
  );

  testWidgets('sin servicio inyectado: bloque de posición no aparece',
      (tester) async {
    await bombearPantalla(tester, alConfirmar: (_) async {});

    expect(find.text('Posición no anclada'), findsNothing);
    expect(find.text('anclar mi posición'), findsNothing);
  });

  testWidgets(
    'con servicio + permiso concedido: ancla coords y las pasa al SitSpot guardado',
    (tester) async {
      SitSpot? sitSpotConfirmado;
      await bombearPantalla(
        tester,
        alConfirmar: (sitSpot) async {
          sitSpotConfirmado = sitSpot;
        },
        servicio: _ServicioGeoFake(
          coordenadas: const Coordenadas(lat: 43.123, lng: -2.456),
        ),
        confirmarPrePermisoOverride: (_) async => true,
      );

      await tester.tap(find.text('anclar mi posición'));
      await tester.pumpAndSettle();
      expect(find.text('Posición anclada al sit spot'), findsOneWidget);
      expect(find.text('43.12300, -2.45600'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'mi banco');
      await tester.pumpAndSettle();
      await tester.tap(find.text('guardar sit spot'));
      await tester.pumpAndSettle();

      expect(sitSpotConfirmado, isNotNull);
      expect(
        sitSpotConfirmado!.coordenadas,
        const Coordenadas(lat: 43.123, lng: -2.456),
      );
    },
  );

  testWidgets(
    'cancelar pre-permiso: no llama al servicio, guarda sin coords',
    (tester) async {
      SitSpot? sitSpotConfirmado;
      await bombearPantalla(
        tester,
        alConfirmar: (sitSpot) async {
          sitSpotConfirmado = sitSpot;
        },
        servicio: _ServicioGeoFake(),
        confirmarPrePermisoOverride: (_) async => false,
      );

      await tester.tap(find.text('anclar mi posición'));
      await tester.pumpAndSettle();
      expect(find.text('Posición no anclada'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'aquí');
      await tester.pumpAndSettle();
      await tester.tap(find.text('guardar sit spot'));
      await tester.pumpAndSettle();

      expect(sitSpotConfirmado, isNotNull);
      expect(sitSpotConfirmado!.coordenadas, isNull);
    },
  );

  testWidgets(
    'permiso denegado: aviso amable, sin coords, guardar sigue funcionando',
    (tester) async {
      SitSpot? sitSpotConfirmado;
      await bombearPantalla(
        tester,
        alConfirmar: (sitSpot) async {
          sitSpotConfirmado = sitSpot;
        },
        servicio: _ServicioGeoFake(
          permisoInicial: PermisoGeo.noSolicitado,
          permisoTrasPedir: PermisoGeo.denegado,
        ),
        confirmarPrePermisoOverride: (_) async => true,
      );

      await tester.tap(find.text('anclar mi posición'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Sin permiso de ubicación'),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextField).at(0), 'el banco');
      await tester.pumpAndSettle();
      await tester.tap(find.text('guardar sit spot'));
      await tester.pumpAndSettle();

      expect(sitSpotConfirmado, isNotNull);
      expect(sitSpotConfirmado!.coordenadas, isNull);
    },
  );
}
