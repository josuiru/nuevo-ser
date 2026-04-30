import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_ajustes/pantalla_ajustes.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late RepositorioMemoria repositorio;
  late RepositorioIdiomaApp repoIdioma;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.idioma_app': 'es',
    });
    repositorio = RepositorioMemoria();
    repoIdioma = RepositorioIdiomaApp(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.elcuaderno.idioma_app',
    );
  });

  Future<void> bombear(
    WidgetTester tester, {
    Future<void> Function()? alCambiarIdioma,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaAjustes(
          repositorio: repositorio,
          repoIdioma: repoIdioma,
          locale: const Locale('es'),
          alCambiarIdioma: alCambiarIdioma ?? () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renderiza las cuatro acciones principales', (tester) async {
    await bombear(tester);
    expect(find.text('Idioma del cuaderno: castellano'), findsOneWidget);
    expect(find.text('Vista del cuidador'), findsOneWidget);
    expect(find.text('Exportar mi cuaderno'), findsOneWidget);
    expect(find.text('Borrar mi cuaderno'), findsOneWidget);
  });

  testWidgets('cambiar idioma invoca el callback', (tester) async {
    var llamado = false;
    await bombear(tester, alCambiarIdioma: () async {
      llamado = true;
    });
    await tester.tap(find.text('Cambiar idioma'));
    await tester.pumpAndSettle();
    expect(llamado, isTrue);
  });

  testWidgets('exportar abre dialog con SelectableText del JSON', (tester) async {
    await repositorio.guardarObservacion(Observacion(
      id: 'obs-1',
      cuandoCreada: DateTime(2026, 4, 30),
      cuandoOcurrio: DateTime(2026, 4, 30),
      dondeNombre: 'parque',
      queVio: 'cosa',
      confianza: NivelConfianza.hipotesisActiva,
    ));
    await bombear(tester);
    await tester.tap(find.text('Exportar mi cuaderno'));
    await tester.pumpAndSettle();
    expect(find.text('Tu cuaderno como texto'), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);
    // El JSON contiene la observación serializada.
    expect(find.textContaining('obs-1'), findsOneWidget);
  });

  testWidgets('borrar requiere doble confirmación + palabra clave', (tester) async {
    await repositorio.guardarObservacion(Observacion(
      id: 'obs-1',
      cuandoCreada: DateTime(2026, 4, 30),
      cuandoOcurrio: DateTime(2026, 4, 30),
      dondeNombre: 'parque',
      queVio: 'cosa',
      confianza: NivelConfianza.hipotesisActiva,
    ));
    await repositorio.guardarMisterio(Misterio(
      id: 'mist-1',
      pregunta: '¿?',
      descripcionCorta: '',
      estado: NivelConfianza.consenso,
      abierto: true,
    ));
    await bombear(tester);
    await tester.tap(find.text('Borrar mi cuaderno'));
    await tester.pumpAndSettle();
    // Primer dialog: explica el reparto.
    expect(find.text('¿Borrar todo?'), findsOneWidget);
    expect(find.textContaining('1 observaciones'), findsOneWidget);
    await tester.tap(find.text('Seguir'));
    await tester.pumpAndSettle();
    // Segundo dialog: pide la palabra-clave. Botón confirmar
    // deshabilitado hasta que coincida.
    expect(find.text('¿Estás segura?'), findsOneWidget);
    final botonConfirmar = find.widgetWithText(TextButton, 'Borrar todo');
    expect(tester.widget<TextButton>(botonConfirmar).onPressed, isNull);
    // Palabra mal: sigue deshabilitado.
    await tester.enterText(find.byType(TextField), 'no');
    await tester.pump();
    expect(tester.widget<TextButton>(botonConfirmar).onPressed, isNull);
    // Palabra correcta: habilita.
    await tester.enterText(find.byType(TextField), 'borrar');
    await tester.pump();
    expect(tester.widget<TextButton>(botonConfirmar).onPressed, isNotNull);
    await tester.tap(botonConfirmar);
    await tester.pumpAndSettle();
    // Repositorio queda vacío.
    expect(await repositorio.obtenerObservaciones(), isEmpty);
    expect(await repositorio.obtenerMisteriosAbiertos(), isEmpty);
  });

  testWidgets('cancelar el primer dialog NO borra nada', (tester) async {
    await repositorio.guardarObservacion(Observacion(
      id: 'obs-1',
      cuandoCreada: DateTime(2026, 4, 30),
      cuandoOcurrio: DateTime(2026, 4, 30),
      dondeNombre: 'parque',
      queVio: 'cosa',
      confianza: NivelConfianza.hipotesisActiva,
    ));
    await bombear(tester);
    await tester.tap(find.text('Borrar mi cuaderno'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(await repositorio.obtenerObservaciones(), hasLength(1));
  });
}
