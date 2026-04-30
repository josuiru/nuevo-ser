import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_cuidador/pantalla_cuidador.dart';
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
    DateTime? semanaPivote,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaCuidador(
          repositorio: repositorio,
          semanaPivote: semanaPivote,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'cuaderno vacío: pregunta de "descansó" + cero observaciones',
    (tester) async {
      await bombear(tester, semanaPivote: DateTime(2026, 4, 30));
      expect(find.textContaining('Semana 2026-W18'), findsOneWidget);
      expect(find.textContaining('descansó'), findsOneWidget);
      expect(find.text('Sin observaciones'), findsOneWidget);
      expect(find.text('Sin Misterios anclados'), findsOneWidget);
      expect(find.text('Sin visitas al sit spot'), findsOneWidget);
    },
  );

  testWidgets(
    'tres observaciones en la semana del pivote alimentan el plural',
    (tester) async {
      // Pivote: jueves 30 abril 2026 → semana ISO 18 (lun 27 → dom 3 may).
      final fechaSemana = DateTime(2026, 4, 28, 12, 0);
      for (var indice = 0; indice < 3; indice++) {
        await repositorio.guardarObservacion(Observacion(
          id: 'obs-$indice',
          cuandoCreada: fechaSemana,
          cuandoOcurrio: fechaSemana,
          dondeNombre: 'parque',
          queVio: 'cosa $indice',
          confianza: NivelConfianza.hipotesisActiva,
          misterioId: 'MIST.X',
          sitSpotId: 'sp-1',
        ));
      }
      // Sit spot existe (las visitas se cuentan por sitSpotId en
      // observaciones, no por la presencia del sit spot en sí).
      await repositorio.establecerSitSpot(SitSpot(
        id: 'sp-1',
        nombre: 'Mi banco',
        dondeNombre: 'parque',
        creadoEn: DateTime(2026, 3, 1),
      ));

      await bombear(tester, semanaPivote: DateTime(2026, 4, 30));
      expect(find.text('3 observaciones'), findsOneWidget);
      expect(find.text('Un Misterio'), findsOneWidget);
      expect(find.text('3 visitas al sit spot'), findsOneWidget);
    },
  );

  testWidgets(
    'aviso de privacidad siempre visible (nunca el texto del niño)',
    (tester) async {
      await bombear(tester, semanaPivote: DateTime(2026, 4, 30));
      expect(
        find.textContaining('única vista que comparte el juego'),
        findsOneWidget,
      );
      // El texto libre del niño no aparece en esta vista — no hay
      // observaciones cargadas, pero la regla aplica también con
      // observaciones presentes (verificado en agregado_semanal_test).
    },
  );
}
