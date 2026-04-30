import 'package:el_cuaderno/datos/selector_imagen.dart';
import 'package:el_cuaderno/datos_simulados/seed.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_observacion/pantalla_observacion.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Selector fake para los tests "estáticos" de la pantalla de
/// observación: confirman que cuando se cabla un selector, los dos
/// botones aparecen, y cuando no, se ve el placeholder informativo.
///
/// El flujo end-to-end (tap "tomar foto" → I/O real al directorio
/// privado → miniatura) no se prueba aquí porque el flutter tester
/// cuelga al alternar `runAsync` con `File.copy`. El almacenador
/// queda cubierto por `test/datos/almacenador_medios_test.dart` (9
/// tests sobre I/O puro), y el flujo completo se verifica en el
/// smoke manual de A9 sobre APK debug.
class _SelectorImagenFake implements SelectorImagen {
  @override
  Future<String?> desdeCamara() async => null;

  @override
  Future<String?> desdeGaleria() async => null;
}

void main() {
  late RepositorioMemoria repositorio;

  setUp(() async {
    repositorio = RepositorioMemoria();
    await sembrarDatosDesarrollo(repositorio);
  });

  Future<void> bombearPantalla(
    WidgetTester tester, {
    SelectorImagen? selector,
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
          selectorImagen: selector,
          proveedorAhora: () => DateTime.utc(2026, 4, 30, 17, 48),
          proveedorIds: () => 'obs-test-foto',
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'sin selectorImagen cableado → muestra placeholder informativo, sin botones',
    (tester) async {
      await bombearPantalla(tester);
      expect(find.text('tomar foto'), findsNothing);
      expect(find.text('elegir foto'), findsNothing);
      expect(
        find.text('Si quieres, añade una foto o un dibujo.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'con selectorImagen cableado → muestra los dos botones de foto',
    (tester) async {
      await bombearPantalla(tester, selector: _SelectorImagenFake());
      expect(find.text('tomar foto'), findsOneWidget);
      expect(find.text('elegir foto'), findsOneWidget);
    },
  );
}
