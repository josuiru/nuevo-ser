import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_sit_spot/pantalla_comparar_visitas.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;
  late SitSpot sitSpot;

  setUp(() {
    repositorio = RepositorioMemoria();
    sitSpot = SitSpot(
      id: 'sit-spot-1',
      nombre: 'El Roble Grande',
      dondeNombre: 'parque del barrio',
      creadoEn: DateTime(2026, 3, 1),
    );
    repositorio.establecerSitSpot(sitSpot);
  });

  Future<void> bombear(WidgetTester tester) async {
    // Surface ancha para que el comparador use el layout de fila.
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaCompararVisitas(
          repositorio: repositorio,
          sitSpot: sitSpot,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> guardar({
    required String id,
    required DateTime cuando,
    required String queVio,
    String? creesQueEs,
  }) async {
    await repositorio.guardarObservacion(Observacion(
      id: id,
      cuandoCreada: cuando,
      cuandoOcurrio: cuando,
      dondeNombre: 'parque del barrio',
      queVio: queVio,
      confianza: NivelConfianza.hipotesisActiva,
      creesQueEs: creesQueEs,
      sitSpotId: 'sit-spot-1',
    ));
  }

  testWidgets(
    '0 observaciones → mensaje "necesitas dos visitas para comparar"',
    (tester) async {
      await bombear(tester);
      expect(
        find.text('Necesitas dos visitas para comparar.'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Cuando vuelvas a tu sit spot otro día'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    '1 observación → sigue mostrando "necesitas dos visitas"',
    (tester) async {
      await guardar(
        id: 'obs-1',
        cuando: DateTime(2026, 4, 10),
        queVio: 'una hormiga',
      );
      await bombear(tester);
      expect(
        find.text('Necesitas dos visitas para comparar.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    '2 observaciones → comparador con dos columnas y la más antigua a la '
    'izquierda + la más reciente a la derecha por defecto',
    (tester) async {
      await guardar(
        id: 'obs-vieja',
        cuando: DateTime(2026, 4, 1),
        queVio: 'el roble en flor',
        creesQueEs: 'roble',
      );
      await guardar(
        id: 'obs-nueva',
        cuando: DateTime(2026, 5, 1),
        queVio: 'el roble con hojas verdes',
        creesQueEs: 'roble',
      );
      await bombear(tester);

      // El nombre del sit spot aparece como cabecera del comparador.
      expect(find.text('El Roble Grande'), findsAtLeastNWidgets(1));
      // Los dos textos de las observaciones aparecen — uno por
      // columna.
      expect(find.text('el roble en flor'), findsOneWidget);
      expect(find.text('el roble con hojas verdes'), findsOneWidget);
      // Las dos etiquetas de columna.
      expect(find.text('primer momento'), findsOneWidget);
      expect(find.text('segundo momento'), findsOneWidget);
    },
  );

  testWidgets(
    'cambiar la elección del dropdown actualiza el panel de la columna',
    (tester) async {
      await guardar(
        id: 'a',
        cuando: DateTime(2026, 4, 1),
        queVio: 'observación primera',
      );
      await guardar(
        id: 'b',
        cuando: DateTime(2026, 4, 15),
        queVio: 'observación intermedia',
      );
      await guardar(
        id: 'c',
        cuando: DateTime(2026, 5, 1),
        queVio: 'observación tercera',
      );
      await bombear(tester);

      // Por defecto izquierda = más antigua (a) y derecha = más
      // reciente (c). La intermedia (b) NO aparece como panel
      // mostrado.
      expect(find.text('observación primera'), findsOneWidget);
      expect(find.text('observación tercera'), findsOneWidget);
      expect(find.text('observación intermedia'), findsNothing);

      // Abrir el primer dropdown y elegir "observación intermedia".
      // Hay dos DropdownButton<String> en pantalla — el primero es
      // la columna izquierda.
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      // En el menú abierto aparece la opción intermedia.
      await tester.tap(find.textContaining('observación intermedia').last);
      await tester.pumpAndSettle();

      // La intermedia ahora ocupa la columna izquierda y la primera
      // ya no se muestra (sólo en el dropdown como opción, no en el
      // panel).
      expect(find.text('observación intermedia'), findsOneWidget);
    },
  );
}
