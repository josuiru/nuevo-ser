import 'dart:async';
import 'dart:convert';

import 'package:el_cuaderno/datos/repositorio_aula_profesor.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_profesor/pantalla_aula_profesor.dart';
import 'package:el_cuaderno/vista/pantalla_profesor/pantalla_login_profesor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests del modo profesor (B7 — fallback de experto pendiente de
/// policy escolar). El cliente HTTP del companion y el de auth se
/// sustituyen por `MockClient` para que los tests no toquen red.
void main() {
  RepositorioCuentaBackend crearRepoCuentaProfesor() {
    return RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'nuevoser.elcuaderno.token_profesor',
      claveEmail: 'nuevoser.elcuaderno.email_profesor',
    );
  }

  RepositorioAulaProfesor crearRepoAulaProfesor() {
    return RepositorioAulaProfesor(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.elcuaderno.profesor.aula_activa',
    );
  }

  Widget envolver(Widget pantalla) {
    return MaterialApp(
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: pantalla,
    );
  }

  group('PantallaLoginProfesor', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('muestra título, descripción y los dos campos de entrada',
        (tester) async {
      await tester.pumpWidget(envolver(PantallaLoginProfesor(
        clienteAuth: companion.ClienteAuthAdulto(
          urlBase: 'https://ejemplo.test',
          cliente: MockClient((_) async => http.Response('ko', 500)),
        ),
        clienteCompanion: companion.ClienteCompanion(
          urlBase: 'https://ejemplo.test',
        ),
        repoCuentaProfesor: crearRepoCuentaProfesor(),
        repoAulaProfesor: crearRepoAulaProfesor(),
      )));
      await tester.pumpAndSettle();

      expect(find.text('Acceso del profesor'), findsAtLeastNWidgets(1));
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Iniciar sesión'), findsOneWidget);
    });

    testWidgets('campos vacíos: muestra error sin tocar la red',
        (tester) async {
      var huboPeticion = false;
      await tester.pumpWidget(envolver(PantallaLoginProfesor(
        clienteAuth: companion.ClienteAuthAdulto(
          urlBase: 'https://ejemplo.test',
          cliente: MockClient((_) async {
            huboPeticion = true;
            return http.Response('no debería llamarse', 500);
          }),
        ),
        clienteCompanion: companion.ClienteCompanion(
          urlBase: 'https://ejemplo.test',
        ),
        repoCuentaProfesor: crearRepoCuentaProfesor(),
        repoAulaProfesor: crearRepoAulaProfesor(),
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(huboPeticion, isFalse);
      expect(
        find.text(
          'Escribe el correo y la contraseña antes de continuar.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('401 → mensaje de credenciales incorrectas', (tester) async {
      await tester.pumpWidget(envolver(PantallaLoginProfesor(
        clienteAuth: companion.ClienteAuthAdulto(
          urlBase: 'https://ejemplo.test',
          cliente: MockClient((_) async => http.Response(
                jsonEncode({'error': 'Credenciales incorrectas.'}),
                401,
              )),
        ),
        clienteCompanion: companion.ClienteCompanion(
          urlBase: 'https://ejemplo.test',
        ),
        repoCuentaProfesor: crearRepoCuentaProfesor(),
        repoAulaProfesor: crearRepoAulaProfesor(),
      )));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(TextField).at(0), 'maestra@cole.org');
      await tester.enterText(find.byType(TextField).at(1), 'mal');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'El correo o la contraseña no coinciden con ninguna cuenta de profesor.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('200 con token válido: persiste token+email y navega al dashboard',
        (tester) async {
      final repoCuenta = crearRepoCuentaProfesor();
      final repoAula = crearRepoAulaProfesor();
      await tester.pumpWidget(envolver(PantallaLoginProfesor(
        clienteAuth: companion.ClienteAuthAdulto(
          urlBase: 'https://ejemplo.test',
          cliente: MockClient((_) async => http.Response(
                jsonEncode({
                  'token': 'jwt-profe',
                  'user_id': 17,
                  'rol': 'profesor',
                }),
                200,
              )),
        ),
        clienteCompanion: companion.ClienteCompanion(
          urlBase: 'https://ejemplo.test',
          // Mock que devuelve "k mínimo no alcanzado" para que la
          // pantalla de aula caiga en el formulario de creación sin
          // romperse — eso es ortogonal a lo que probamos aquí.
          cliente: MockClient((_) async => http.Response(
                jsonEncode({'error': 'k mínimo'}),
                403,
              )),
        ),
        repoCuentaProfesor: repoCuenta,
        repoAulaProfesor: repoAula,
      )));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(TextField).at(0), 'maestra@cole.org');
      await tester.enterText(find.byType(TextField).at(1), 'tarima');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(await repoCuenta.cargarToken(), 'jwt-profe');
      expect(await repoCuenta.cargarEmail(), 'maestra@cole.org');
      expect(find.byType(PantallaAulaProfesor), findsOneWidget);
    });

    testWidgets('403 → "no tiene perfil de profesor"', (tester) async {
      await tester.pumpWidget(envolver(PantallaLoginProfesor(
        clienteAuth: companion.ClienteAuthAdulto(
          urlBase: 'https://ejemplo.test',
          cliente: MockClient((_) async => http.Response(
                jsonEncode({'error': 'El usuario no tiene el rol solicitado.'}),
                403,
              )),
        ),
        clienteCompanion: companion.ClienteCompanion(
          urlBase: 'https://ejemplo.test',
        ),
        repoCuentaProfesor: crearRepoCuentaProfesor(),
        repoAulaProfesor: crearRepoAulaProfesor(),
      )));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(TextField).at(0), 'tutor@familia.org');
      await tester.enterText(find.byType(TextField).at(1), 'p');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Esta cuenta no tiene perfil de profesor. Si eres cuidador, busca ese acceso aparte.',
        ),
        findsOneWidget,
      );
    });
  });

  group('PantallaAulaProfesor', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('sin aula persistida + sesión válida: muestra formulario de creación',
        (tester) async {
      final repoCuenta = crearRepoCuentaProfesor();
      await repoCuenta.guardarToken('jwt-profe');
      await tester.pumpWidget(envolver(PantallaAulaProfesor(
        clienteCompanion: companion.ClienteCompanion(
          urlBase: 'https://ejemplo.test',
        ),
        repoCuentaProfesor: repoCuenta,
        repoAulaProfesor: crearRepoAulaProfesor(),
      )));
      await tester.pumpAndSettle();

      expect(find.text('Crea tu primera aula'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('El Cuaderno'), findsOneWidget);
      expect(find.text('Uno Roto'), findsOneWidget);
      expect(find.text('Las Versiones'), findsOneWidget);
      expect(find.text('Crear aula'), findsOneWidget);
    });

    testWidgets('crear aula con nombre vacío → error sin tocar la red',
        (tester) async {
      var huboPeticion = false;
      final repoCuenta = crearRepoCuentaProfesor();
      await repoCuenta.guardarToken('jwt-profe');
      await tester.pumpWidget(envolver(PantallaAulaProfesor(
        clienteCompanion: companion.ClienteCompanion(
          urlBase: 'https://ejemplo.test',
          cliente: MockClient((_) async {
            huboPeticion = true;
            return http.Response('ko', 500);
          }),
        ),
        repoCuentaProfesor: repoCuenta,
        repoAulaProfesor: crearRepoAulaProfesor(),
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Crear aula'));
      await tester.pumpAndSettle();

      expect(huboPeticion, isFalse);
      expect(
        find.text('Pon un nombre al aula y elige al menos un juego.'),
        findsOneWidget,
      );
    });

    testWidgets('aula persistida + 200 con datos: muestra cabecera y agregados',
        (tester) async {
      final repoCuenta = crearRepoCuentaProfesor();
      final repoAula = crearRepoAulaProfesor();
      await repoCuenta.guardarToken('jwt-profe');
      await repoAula.guardar(42);

      await tester.pumpWidget(envolver(PantallaAulaProfesor(
        clienteCompanion: companion.ClienteCompanion(
          urlBase: 'https://ejemplo.test',
          cliente: MockClient((request) async {
            expect(request.url.path,
                '/wp-json/nuevo-ser/v1/classrooms/42/aggregates');
            return http.Response(
              jsonEncode({
                'classroom_id': 42,
                'code': 'BOSQUE7',
                'name': '6º A · curso 2026/27',
                'language': 'es',
                'iso_week': '2026-W18',
                'member_count': 7,
                'reporting_count': 6,
                'aggregates': {
                  'el-cuaderno': {
                    'observaciones_total': 23,
                  },
                },
              }),
              200,
            );
          }),
        ),
        repoCuentaProfesor: repoCuenta,
        repoAulaProfesor: repoAula,
      )));
      await tester.pumpAndSettle();

      expect(find.text('6º A · curso 2026/27'), findsOneWidget);
      expect(find.text('Código del aula: BOSQUE7'), findsOneWidget);
      expect(find.text('Semana 2026-W18 · 6 de 7 con datos'), findsOneWidget);
      expect(find.text('el-cuaderno'), findsOneWidget);
      expect(find.text('observaciones_total'), findsOneWidget);
      expect(find.text('23'), findsOneWidget);
    });

    testWidgets('aula persistida + 403 k mínimo: muestra mensaje sin culpar',
        (tester) async {
      final repoCuenta = crearRepoCuentaProfesor();
      final repoAula = crearRepoAulaProfesor();
      await repoCuenta.guardarToken('jwt-profe');
      await repoAula.guardar(42);

      // El FutureBuilder consume la `ExcepcionApi` que devuelve el
      // companion (k mínimo no alcanzado) y la convierte en estado de
      // UI. Pero el Zone del test la recoge como "error fuera de zone"
      // porque el handler se adjunta tras la propagación inicial.
      // Filtramos sólo esa excepción esperada — cualquier otra falla
      // el test.
      final erroresInesperados = <Object>[];
      await runZonedGuarded(() async {
        await tester.pumpWidget(envolver(PantallaAulaProfesor(
          clienteCompanion: companion.ClienteCompanion(
            urlBase: 'https://ejemplo.test',
            cliente: MockClient((_) async => http.Response(
                  jsonEncode({'error': 'k mínimo no alcanzado'}),
                  403,
                )),
          ),
          repoCuentaProfesor: repoCuenta,
          repoAulaProfesor: repoAula,
        )));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('al menos cinco niños con datos esta semana'),
          findsOneWidget,
        );
        // Sin nombres, sin culpas — la voz "no humillar".
        expect(find.textContaining('falta'), findsNothing);
      }, (error, _) {
        if (error is! ExcepcionApi) erroresInesperados.add(error);
      });
      expect(erroresInesperados, isEmpty);
    });

    testWidgets('cerrar sesión: borra token+aula y vuelve al login',
        (tester) async {
      final repoCuenta = crearRepoCuentaProfesor();
      final repoAula = crearRepoAulaProfesor();
      await repoCuenta.guardarToken('jwt-profe');
      await repoCuenta.guardarEmail('maestra@cole.org');
      await repoAula.guardar(42);

      await tester.pumpWidget(envolver(PantallaAulaProfesor(
        clienteCompanion: companion.ClienteCompanion(
          urlBase: 'https://ejemplo.test',
          cliente: MockClient((_) async => http.Response(
                jsonEncode({
                  'classroom_id': 42,
                  'code': 'BOSQUE7',
                  'name': '6º A',
                  'language': 'es',
                  'iso_week': '2026-W18',
                  'member_count': 6,
                  'reporting_count': 5,
                  'aggregates': <String, dynamic>{},
                }),
                200,
              )),
        ),
        repoCuentaProfesor: repoCuenta,
        repoAulaProfesor: repoAula,
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('cerrar sesión'));
      await tester.pumpAndSettle();

      expect(await repoCuenta.cargarToken(), isNull);
      expect(await repoCuenta.cargarEmail(), isNull);
      expect(await repoAula.cargar(), isNull);
      expect(find.byType(PantallaLoginProfesor), findsOneWidget);
    });
  });
}
