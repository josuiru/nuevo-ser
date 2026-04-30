import 'package:el_cuaderno/datos_simulados/seed.dart';
import 'package:el_cuaderno/dominio/geolocalizacion_privacy_first.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_observacion/pantalla_observacion.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake en línea del contrato de geolocalización para los tests del
/// flujo opt-in "anclar mi posición a esta página" (B5).
class _ServicioGeoFake implements ServicioGeolocalizacion {
  _ServicioGeoFake({
    this.permisoInicial = PermisoGeo.noSolicitado,
    this.permisoTrasPedir = PermisoGeo.concedido,
    this.coordenadas = const Coordenadas(lat: 42.81234, lng: -1.64321),
  });

  PermisoGeo permisoInicial;
  PermisoGeo permisoTrasPedir;
  Coordenadas? coordenadas;
  int vecesPedidas = 0;
  int vecesLeidas = 0;

  @override
  Future<PermisoGeo> permiso() async => permisoInicial;

  @override
  Future<PermisoGeo> pedirPermiso() async {
    vecesPedidas++;
    permisoInicial = permisoTrasPedir;
    return permisoTrasPedir;
  }

  @override
  Future<Coordenadas?> coordenadasActuales({
    Duration tiempoEspera = const Duration(seconds: 8),
  }) async {
    vecesLeidas++;
    return coordenadas;
  }
}

void main() {
  late RepositorioMemoria repositorio;

  setUp(() async {
    repositorio = RepositorioMemoria();
    await sembrarDatosDesarrollo(repositorio);
  });

  Future<void> bombearPantalla(
    WidgetTester tester, {
    ServicioGeolocalizacion? servicio,
    Future<bool> Function(BuildContext)? confirmarPrePermisoOverride,
    Future<void> Function(Observacion)? alGuardarObservacion,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    final misteriosAbiertos = await repositorio.obtenerMisteriosAbiertos();
    final sitSpot = await repositorio.obtenerSitSpot();

    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaObservacion(
          repositorio: repositorio,
          misteriosAbiertos: misteriosAbiertos,
          sitSpotActivo: sitSpot,
          alGuardarObservacion: alGuardarObservacion,
          servicioGeolocalizacion: servicio,
          confirmarPrePermisoGeoOverride: confirmarPrePermisoOverride,
          proveedorAhora: () => DateTime.utc(2026, 4, 30, 17, 48),
          proveedorIds: () => 'obs-test-id',
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('sin servicio inyectado: el bloque "anclar posición" no aparece',
      (tester) async {
    await bombearPantalla(tester);

    expect(find.text('Posición no anclada'), findsNothing);
    expect(find.text('anclar mi posición'), findsNothing);
  });

  testWidgets(
    'con servicio inyectado: el bloque aparece con texto "Posición no anclada"',
    (tester) async {
      await bombearPantalla(tester, servicio: _ServicioGeoFake());

      expect(find.text('Posición no anclada'), findsOneWidget);
      expect(find.text('anclar mi posición'), findsOneWidget);
    },
  );

  testWidgets(
    'cancelar pre-permiso: no llama al servicio, no se anclan coords',
    (tester) async {
      final servicio = _ServicioGeoFake();
      await bombearPantalla(
        tester,
        servicio: servicio,
        confirmarPrePermisoOverride: (_) async => false,
      );

      await tester.tap(find.text('anclar mi posición'));
      await tester.pumpAndSettle();

      expect(servicio.vecesPedidas, 0);
      expect(servicio.vecesLeidas, 0);
      expect(find.text('Posición no anclada'), findsOneWidget);
    },
  );

  testWidgets(
    'aceptar pre-permiso + permiso concedido + coords: muestra coords y persiste al guardar',
    (tester) async {
      final servicio = _ServicioGeoFake(
        coordenadas: const Coordenadas(lat: 42.81234, lng: -1.64321),
      );
      Observacion? observacionGuardada;
      await bombearPantalla(
        tester,
        servicio: servicio,
        confirmarPrePermisoOverride: (_) async => true,
        alGuardarObservacion: (obs) async {
          observacionGuardada = obs;
        },
      );

      await tester.tap(find.text('anclar mi posición'));
      await tester.pumpAndSettle();

      expect(servicio.vecesPedidas, 1);
      expect(servicio.vecesLeidas, 1);
      expect(find.text('Posición anclada a esta página'), findsOneWidget);
      expect(find.text('42.81234, -1.64321'), findsOneWidget);

      // Rellenar campo obligatorio para habilitar Guardar.
      await tester.enterText(
        find.byType(TextField).first,
        'una hoja amarilla con borde rojo',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar en el cuaderno'));
      await tester.pumpAndSettle();

      expect(observacionGuardada, isNotNull);
      expect(
        observacionGuardada!.dondeCoordenadas,
        const Coordenadas(lat: 42.81234, lng: -1.64321),
      );
    },
  );

  testWidgets(
    'permiso denegado: muestra aviso amable, no persiste coords',
    (tester) async {
      final servicio = _ServicioGeoFake(
        permisoInicial: PermisoGeo.noSolicitado,
        permisoTrasPedir: PermisoGeo.denegado,
      );
      await bombearPantalla(
        tester,
        servicio: servicio,
        confirmarPrePermisoOverride: (_) async => true,
      );

      await tester.tap(find.text('anclar mi posición'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Sin permiso de ubicación'),
        findsOneWidget,
      );
      expect(find.text('Posición no anclada'), findsOneWidget);
      expect(servicio.vecesLeidas, 0);
    },
  );

  testWidgets(
    'permiso denegado permanente: aviso dirige a ajustes del teléfono',
    (tester) async {
      final servicio = _ServicioGeoFake(
        permisoInicial: PermisoGeo.denegadoPermanente,
        permisoTrasPedir: PermisoGeo.denegadoPermanente,
      );
      await bombearPantalla(
        tester,
        servicio: servicio,
        confirmarPrePermisoOverride: (_) async => true,
      );

      await tester.tap(find.text('anclar mi posición'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('cámbialo en los ajustes del teléfono'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'GPS sin coords: muestra aviso "puedes seguir sin ella" sin persistir',
    (tester) async {
      final servicio = _ServicioGeoFake(coordenadas: null);
      Observacion? observacionGuardada;
      await bombearPantalla(
        tester,
        servicio: servicio,
        confirmarPrePermisoOverride: (_) async => true,
        alGuardarObservacion: (obs) async {
          observacionGuardada = obs;
        },
      );

      await tester.tap(find.text('anclar mi posición'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('No se ha podido localizar la posición'),
        findsOneWidget,
      );

      await tester.enterText(
        find.byType(TextField).first,
        'cualquier cosa',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar en el cuaderno'));
      await tester.pumpAndSettle();

      expect(observacionGuardada, isNotNull);
      expect(observacionGuardada!.dondeCoordenadas, isNull);
    },
  );

  testWidgets(
    'quitar posición tras anclarla: vuelve al estado "no anclada"',
    (tester) async {
      final servicio = _ServicioGeoFake();
      await bombearPantalla(
        tester,
        servicio: servicio,
        confirmarPrePermisoOverride: (_) async => true,
      );

      await tester.tap(find.text('anclar mi posición'));
      await tester.pumpAndSettle();
      expect(find.text('Posición anclada a esta página'), findsOneWidget);

      await tester.tap(find.text('quitar posición'));
      await tester.pumpAndSettle();

      expect(find.text('Posición no anclada'), findsOneWidget);
      expect(find.text('anclar mi posición'), findsOneWidget);
    },
  );
}
