import 'dart:convert';

import 'package:el_cuaderno/datos/sincronizador_agregados.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_cuidador/pantalla_cuidador.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late RepositorioMemoria repositorio;

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombear(
    WidgetTester tester, {
    DateTime? semanaPivote,
    SincronizadorAgregadosCuaderno? sincronizador,
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
          sincronizador: sincronizador,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  SincronizadorAgregadosCuaderno crearSincronizadorConRespuesta(
    http.Response respuesta, {
    String? token,
  }) {
    SharedPreferences.setMockInitialValues(token == null
        ? {}
        : {'nuevoser.elcuaderno.token_backend': token});
    final repoCuenta = RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'nuevoser.elcuaderno.token_backend',
      claveEmail: 'nuevoser.elcuaderno.email_backend',
    );
    final mock = MockClient((_) async => respuesta);
    final clienteCompanion = companion.ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );
    return SincronizadorAgregadosCuaderno(
      repositorio: repositorio,
      repoCuenta: repoCuenta,
      clienteCompanion: clienteCompanion,
    );
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

  testWidgets(
    'sin sincronizador: el botón "Compartir resumen" no aparece',
    (tester) async {
      await bombear(tester, semanaPivote: DateTime(2026, 4, 30));
      expect(find.text('Compartir resumen con el adulto'), findsNothing);
    },
  );

  testWidgets(
    'con sincronizador y sin token: pulsar muestra aviso "sin cuenta vinculada"',
    (tester) async {
      final sincronizador = crearSincronizadorConRespuesta(
        http.Response('', 500),
        token: null,
      );
      await bombear(
        tester,
        semanaPivote: DateTime(2026, 4, 30),
        sincronizador: sincronizador,
      );
      expect(find.text('Compartir resumen con el adulto'), findsOneWidget);
      await tester.tap(find.text('Compartir resumen con el adulto'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Aún no hay cuenta vinculada'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'con sincronizador y respuesta del backend: muestra summary y prompt',
    (tester) async {
      final sincronizador = crearSincronizadorConRespuesta(
        http.Response(
          jsonEncode({
            'game_id': 'el-cuaderno',
            'iso_week': '2026-W18',
            'aggregates_hash': 'h',
            'summary_text': 'Esta semana ha vuelto al banco a escuchar.',
            'conversation_prompt': '¿Qué le ha sonado distinto?',
            'generated_at': '2026-04-29 22:30:00',
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
        token: 'jwt-niño',
      );
      await bombear(
        tester,
        semanaPivote: DateTime(2026, 4, 30),
        sincronizador: sincronizador,
      );
      // Antes de pulsar: pregunta offline.
      expect(find.textContaining('descansó'), findsOneWidget);
      await tester.tap(find.text('Compartir resumen con el adulto'));
      await tester.pumpAndSettle();
      // Tras pulsar: cabecera del resumen + summary + prompt del LLM.
      expect(find.text('Esta semana, en una frase'), findsOneWidget);
      expect(
        find.text('Esta semana ha vuelto al banco a escuchar.'),
        findsOneWidget,
      );
      expect(find.text('¿Qué le ha sonado distinto?'), findsOneWidget);
      // La pregunta offline ya no se muestra cuando el LLM dio prompt.
      expect(find.textContaining('descansó'), findsNothing);
    },
  );

  testWidgets(
    'con sincronizador y 5xx: muestra aviso de error sin romper la vista',
    (tester) async {
      final sincronizador = crearSincronizadorConRespuesta(
        http.Response(
          jsonEncode({'message': 'tutor IA no disponible'}),
          500,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
        token: 'jwt-niño',
      );
      await bombear(
        tester,
        semanaPivote: DateTime(2026, 4, 30),
        sincronizador: sincronizador,
      );
      await tester.tap(find.text('Compartir resumen con el adulto'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Hoy no se ha podido conectar'),
        findsOneWidget,
      );
      // La pregunta offline sigue visible — el cuidador tiene algo que decir.
      expect(find.textContaining('descansó'), findsOneWidget);
    },
  );
}
