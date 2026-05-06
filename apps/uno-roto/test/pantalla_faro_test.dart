import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uno_roto/datos/banco_ediciones_faro.dart';
import 'package:uno_roto/datos/repositorio_faro.dart';
import 'package:uno_roto/dominio/faro_de_azula.dart';
import 'package:uno_roto/vista/pantalla_faro.dart';

/// Tests de la pantalla del Faro:
///
/// - parser de markdown ligero (`**` y `*`).
/// - smoke test que monta la pantalla con la E1 real y verifica
///   que aparecen los textos clave.
/// - envío de respuesta al acertijo persiste en el repositorio del
///   perfil activo.
void main() {
  group('parsearMarkdownLigero', () {
    const base = TextStyle(fontSize: 14);

    test('texto plano produce un único span con el estilo base', () {
      final spans = parsearMarkdownLigero('hola mundo', base);
      expect(spans.length, 1);
      final span = spans.first as TextSpan;
      expect(span.text, 'hola mundo');
      expect(span.style?.fontWeight, isNull);
      expect(span.style?.fontStyle, isNull);
    });

    test('negrita con ** envuelve el texto', () {
      final spans = parsearMarkdownLigero('antes **fuerte** después', base);
      // antes / fuerte / después → 3 spans
      expect(spans.length, 3);
      final medio = spans[1] as TextSpan;
      expect(medio.text, 'fuerte');
      expect(medio.style?.fontWeight, FontWeight.w700);
    });

    test('cursiva con * envuelve el texto', () {
      final spans = parsearMarkdownLigero('antes *suave* después', base);
      expect(spans.length, 3);
      final medio = spans[1] as TextSpan;
      expect(medio.text, 'suave');
      expect(medio.style?.fontStyle, FontStyle.italic);
    });

    test('negrita y cursiva no se mezclan accidentalmente', () {
      // **bold** *italic* — bold no debe heredar italic.
      final spans = parsearMarkdownLigero('**A** *B*', base);
      final boldSpan = spans.firstWhere(
        (s) => (s as TextSpan).text == 'A',
      ) as TextSpan;
      final italicSpan = spans.firstWhere(
        (s) => (s as TextSpan).text == 'B',
      ) as TextSpan;
      expect(boldSpan.style?.fontWeight, FontWeight.w700);
      expect(boldSpan.style?.fontStyle, isNull);
      expect(italicSpan.style?.fontStyle, FontStyle.italic);
      expect(italicSpan.style?.fontWeight, isNull);
    });

    test('texto vacío produce lista vacía', () {
      expect(parsearMarkdownLigero('', base), isEmpty);
    });

    test('marcadores sin cerrar no rompen el render', () {
      // Si el doc tiene un asterisco huérfano, queda en estado
      // cursivo hasta el final pero no lanza ni pinta nada raro.
      final spans = parsearMarkdownLigero('hola *mundo', base);
      expect(spans.length, 2);
      final segundo = spans[1] as TextSpan;
      expect(segundo.text, 'mundo');
      expect(segundo.style?.fontStyle, FontStyle.italic);
    });
  });

  group('PantallaFaro', () {
    late GestorPerfiles gestor;
    late RepositorioFaro repo;
    late List<EdicionFaro> banco;

    setUpAll(() {
      final crudo =
          File('assets/data/faro_banco_v0_2.json').readAsStringSync();
      banco = parseBancoDesdeJson(crudo);
    });

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      gestor = GestorPerfiles(
        namespace: 'uroto',
        sufijoNombreVisible: 'nombre_jugador',
      );
      repo = RepositorioFaro(gestor: gestor);
    });

    testWidgets('primer arranque muestra la edición 1 con sus secciones',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      // Bombea los Future del initState.
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Cabecera: número canónico de la edición 1.
      expect(find.textContaining('Edición 1234'), findsOneWidget);
      expect(find.textContaining('Año 412 de la Orden'), findsOneWidget);

      // Portada: el titular de la E1.
      expect(
        find.text('Tres lunas previstas para el equinoccio'),
        findsOneWidget,
      );

      // Crónica: el título de Liana Verde.
      expect(find.text('Estampas de mi mostrador'), findsOneWidget);
      expect(find.text('por Liana Verde'), findsOneWidget);

      // Acertijo: el título y el botón de envío.
      expect(find.text('El reparto de las naranjas'), findsOneWidget);
      expect(find.text('ENVIAR'), findsOneWidget);
    });

    testWidgets('marca primera_vista_ms al primer arranque (idempotente)',
        (tester) async {
      expect(await repo.cargarPrimeraVistaMs(), isNull);
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      final primeraVez = await repo.cargarPrimeraVistaMs();
      expect(primeraVez, isNotNull);
      expect(await repo.cargarUltimaEdicionVista(), 1,
          reason: 'abrir el Faro debería marcar la edición actual como vista');
    });

    testWidgets('enviar respuesta del acertijo la persiste',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // El acertijo está al final del scroll — bajamos hasta él
      // antes de teclear y pulsar (en la pantalla real cabe abajo,
      // pero el viewport del test es de ~600px y la pantalla es
      // larga).
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '20 naranjas');
      // pumpAndSettle propaga el setState del listener del TextField
      // al widget, habilitando el botón ENVIAR antes del tap.
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('ENVIAR'));
      await tester.tap(find.text('ENVIAR'));
      await tester.pumpAndSettle();

      expect(
        await repo.cargarRespuestaAcertijo(1),
        '20 naranjas',
      );
      // Tras enviar, aparece el aviso de "queda anotada en el buzón".
      expect(
        find.text('Tu respuesta queda anotada en el buzón.'),
        findsOneWidget,
      );
    });

    testWidgets('respuesta vacía o solo espacios no se envía',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '   ');
      await tester.ensureVisible(find.text('ENVIAR'));
      await tester.tap(find.text('ENVIAR'));
      await tester.pumpAndSettle();

      expect(await repo.cargarRespuestaAcertijo(1), isNull);
    });

    testWidgets('botón ENVIAR deshabilitado cuando el TextField está vacío',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Sin escribir todavía: ENVIAR deshabilitado.
      var boton = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('ENVIAR'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(boton.onPressed, isNull,
          reason: 'el botón debe arrancar deshabilitado sin texto');

      // Escribimos: se habilita.
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '20');
      await tester.pumpAndSettle();
      boton = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('ENVIAR'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(boton.onPressed, isNotNull);

      // Vaciamos: se deshabilita otra vez.
      await tester.enterText(find.byType(TextField), '   ');
      await tester.pumpAndSettle();
      boton = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('ENVIAR'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(boton.onPressed, isNull,
          reason: 'sólo espacios cuenta como vacío para ENVIAR');
    });

    testWidgets('TextField capitaliza frases automáticamente',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      final campo = tester.widget<TextField>(find.byType(TextField));
      expect(campo.textCapitalization, TextCapitalization.sentences,
          reason: 'la primera letra de cada frase debe entrar en '
              'mayúscula automática (más natural en castellano)');
    });

    testWidgets('al reabrir, la respuesta previa rellena el TextField',
        (tester) async {
      // Primera apertura: enviamos respuesta.
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'mi propuesta');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('ENVIAR'));
      await tester.tap(find.text('ENVIAR'));
      await tester.pumpAndSettle();

      // Segunda apertura: pantalla nueva, mismo repositorio.
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // La respuesta debe estar en el TextField y aparecer el aviso
      // tras volver a hacer scroll al acertijo.
      await tester.ensureVisible(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.text('mi propuesta'), findsOneWidget);
      expect(
        find.text('Tu respuesta queda anotada en el buzón.'),
        findsOneWidget,
      );
    });
  });

  group('PantallaFaro — navegación entre ediciones', () {
    late GestorPerfiles gestor;
    late RepositorioFaro repo;
    late List<EdicionFaro> banco;

    setUpAll(() {
      final crudo =
          File('assets/data/faro_banco_v0_2.json').readAsStringSync();
      banco = parseBancoDesdeJson(crudo);
    });

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      gestor = GestorPerfiles(
        namespace: 'uroto',
        sufijoNombreVisible: 'nombre_jugador',
      );
      repo = RepositorioFaro(gestor: gestor);
      // Pre-fija la primera vista hace 4 semanas + 1 día → semana
      // actual = 5 (4·7 = 28 días, ~4 semanas completas + 1).
      final ahora = DateTime.now();
      await repo.guardarPrimeraVistaMs(
        ahora
            .subtract(const Duration(days: 29))
            .millisecondsSinceEpoch,
      );
    });

    /// Helper: verifica que un IconButton encontrado por su icono
    /// tiene onPressed según se espera (null = deshabilitado).
    bool estaDeshabilitado(WidgetTester tester, IconData icono) {
      final boton =
          tester.widget<IconButton>(find.ancestor(
        of: find.byIcon(icono),
        matching: find.byType(IconButton),
      ));
      return boton.onPressed == null;
    }

    testWidgets('subtítulo muestra "Semana 5 de 5" y → deshabilitada',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(find.text('Semana 5 de 5'), findsOneWidget);
      expect(estaDeshabilitado(tester, Icons.chevron_right), isTrue,
          reason: 'estando en la última semana, → no debe poder pulsarse');
      expect(estaDeshabilitado(tester, Icons.chevron_left), isFalse,
          reason: 'desde semana 5 sí se puede ir hacia atrás');
    });

    testWidgets('← navega a la edición anterior y cambia el contenido',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // En semana 5: la portada incluye "Aciertos de las manzanas y
      // las uvas" (solución de E4 publicada en E5).
      expect(
        find.text('Aciertos de las manzanas y las uvas'),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      // Ahora en semana 4: el titular cambia.
      expect(find.text('Semana 4 de 5'), findsOneWidget);
      expect(
        find.text('Aciertos de los tres aprendices'),
        findsOneWidget,
        reason: 'la portada de E4 publica la solución del acertijo de E3',
      );
    });

    testWidgets('en semana 1 ← se deshabilita', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Bajamos hasta semana 1 con cuatro taps.
      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();
      }
      expect(find.text('Semana 1 de 5'), findsOneWidget);
      expect(estaDeshabilitado(tester, Icons.chevron_left), isTrue);
      expect(estaDeshabilitado(tester, Icons.chevron_right), isFalse);
    });

    testWidgets('respuesta de cada edición se conserva al navegar',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repo, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // En semana 5, escribe respuesta del acertijo de la 5
      // ("El pago al constructor", solución 200).
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '200 monedas');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('ENVIAR'));
      await tester.tap(find.text('ENVIAR'));
      await tester.pumpAndSettle();

      // Vamos a la 4 — debería estar vacía.
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(TextField));
      final campoEnE4 =
          tester.widget<TextField>(find.byType(TextField));
      expect(campoEnE4.controller!.text, isEmpty,
          reason: 'cada edición tiene su propia respuesta');

      // Volvemos a la 5 — sigue ahí.
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(TextField));
      final campoEnE5 =
          tester.widget<TextField>(find.byType(TextField));
      expect(campoEnE5.controller!.text, '200 monedas');

      // Y persistido en el repo.
      expect(await repo.cargarRespuestaAcertijo(5), '200 monedas');
      expect(await repo.cargarRespuestaAcertijo(4), isNull);
    });

    testWidgets('semana 1 sin progreso no muestra subtítulo',
        (tester) async {
      // Repositorio sin primera_vista — fuerza semana_maxima=1.
      SharedPreferences.setMockInitialValues({});
      final repoLimpio = RepositorioFaro(
        gestor: GestorPerfiles(
          namespace: 'uroto',
          sufijoNombreVisible: 'nombre_jugador',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaFaro(repositorioFaro: repoLimpio, banco: banco),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Con una sola semana visible no tiene sentido mostrar
      // "Semana 1 de 1" — más limpio omitirlo.
      expect(find.textContaining('Semana 1 de'), findsNothing);
      expect(estaDeshabilitado(tester, Icons.chevron_left), isTrue);
      expect(estaDeshabilitado(tester, Icons.chevron_right), isTrue);
    });
  });
}
