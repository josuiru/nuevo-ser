// Tests de navegación end-to-end con bundle in-memory.
//
// Los tests que antes estaban aparcados en smoke_test.dart se
// reactivan aquí, ahora deterministas porque inyectamos un
// CargadorCorpus con BundleEnMemoria — sin tocar rootBundle.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/cargador_corpus.dart';
import 'package:el_descifrador/datos/repositorio_familiaridad.dart';
import 'package:el_descifrador/dominio/voz_remitente.dart';
import 'package:el_descifrador/l10n/app_localizations.dart';
import 'package:el_descifrador/vista/pantalla_mesa.dart';

import 'soporte/bundle_en_memoria.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget _app({
    CargadorCorpus? cargador,
    RepositorioFamiliaridad? repo,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      home: PantallaMesa(
        cargadorInyectado: cargador,
        repositorioFamiliaridadInyectado: repo,
      ),
    );
  }

  testWidgets('Pieza sin identificar muestra panel y oculta decisiones',
      (tester) async {
    final cargador = CargadorCorpus(bundle: bundleConPiezasReales());
    await tester.pumpWidget(_app(cargador: cargador));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('pieza-carta-ines-bacalao-001')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Texto visible.
    expect(find.textContaining('Caro João'), findsOneWidget);
    // Panel de identificación visible.
    expect(find.text('¿En qué lengua viene?'), findsOneWidget);
    // Decisiones NO visibles aún.
    expect(find.text('Archivar'), findsNothing);
    expect(find.text('Entregar al destinatario'), findsNothing);
  });

  testWidgets('Tras identificar la lengua aparecen las decisiones',
      (tester) async {
    final cargador = CargadorCorpus(bundle: bundleConPiezasReales());
    await tester.pumpWidget(_app(cargador: cargador));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('pieza-carta-ines-bacalao-001')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Identificar como Portugués (lengua correcta de la carta de Inês).
    await tester.tap(find.text('Portugués'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Decisiones válidas para la pieza de Inês.
    expect(find.text('Archivar'), findsOneWidget);
    expect(find.text('Entregar al destinatario'), findsOneWidget);
    expect(find.text('Publicar en el Boletín'), findsOneWidget);

    // No válidas para esta pieza.
    expect(find.text('Devolver al remitente'), findsNothing);
    expect(find.text('Esperar'), findsNothing);

    // Panel ya no debe estar.
    expect(find.text('¿En qué lengua viene?'), findsNothing);
  });

  testWidgets('Fallar identificación mantiene panel con pista', (tester) async {
    final cargador = CargadorCorpus(bundle: bundleConPiezasReales());
    await tester.pumpWidget(_app(cargador: cargador));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('pieza-carta-ines-bacalao-001')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Elegir Castellano (es de familia romance, igual que portugués →
    // debe disparar la pista "Cerca. La familia es la misma.").
    await tester.tap(find.text('Castellano'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // El panel sigue.
    expect(find.text('¿En qué lengua viene?'), findsOneWidget);
    // Mensaje del maestro con pista por familia.
    expect(find.textContaining('familia es la misma'), findsOneWidget);
    // Decisiones siguen ocultas.
    expect(find.text('Archivar'), findsNothing);
  });

  testWidgets('Decidir archivar mueve pieza a resuelto', (tester) async {
    final cargador = CargadorCorpus(bundle: bundleConPiezasReales());
    await tester.pumpWidget(_app(cargador: cargador));
    await tester.pumpAndSettle();

    // Estado inicial.
    expect(find.text('Archivo: nada hoy'), findsOneWidget);

    // Abrir Inês, identificar portugués, archivar.
    await tester.tap(
      find.byKey(const ValueKey('pieza-carta-ines-bacalao-001')),
      warnIfMissed: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Portugués'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Archivar'));
    // Tras decidir hay await + Navigator.pop. Pump discreto.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Una pieza menos en bandeja, archivo a 1.
    expect(find.text('Archivo: 1 pieza'), findsOneWidget);
    expect(find.textContaining('ines cocinera lisboa'), findsNothing);
    // Niko sigue.
    expect(find.textContaining('aprendiz-companero-niko'), findsOneWidget);
  });

  testWidgets('Decidir registra familiaridad con remitente recurrente', (
    tester,
  ) async {
    final cargador = CargadorCorpus(bundle: bundleConPiezasReales());
    final repo = RepositorioFamiliaridad(idPerfil: 'test-familiaridad');
    await tester.pumpWidget(_app(cargador: cargador, repo: repo));
    await tester.pumpAndSettle();

    // Estado inicial: Inês desconocida.
    final estadoInicial = await repo.cargar();
    expect(
      estadoInicial.piezasTrabajadasCon(VozRemitente.inesCocineraLisboa),
      0,
    );

    // Abrir, identificar portugués, archivar la carta de Inês.
    await tester.tap(find.textContaining('ines cocinera lisboa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portugués'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Archivar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Inês ahora sube a 1 pieza trabajada (= "saludando").
    final estadoTras = await repo.cargar();
    expect(
      estadoTras.piezasTrabajadasCon(VozRemitente.inesCocineraLisboa),
      1,
    );
  });

  testWidgets(
    'Decidir sobre voz puntual (Niko) NO incrementa familiaridad de nadie',
    (tester) async {
      final cargador = CargadorCorpus(bundle: bundleConPiezasReales());
      final repo = RepositorioFamiliaridad(idPerfil: 'test-niko');
      await tester.pumpWidget(_app(cargador: cargador, repo: repo));
      await tester.pumpAndSettle();

      // Abrir, identificar euskara, archivar la nota de Niko (voz
      // puntual no recurrente).
      await tester.tap(
        find.byKey(const ValueKey('pieza-nota-companero-aprendiz-026')),
        warnIfMissed: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Euskara'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Archivar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Ningún remitente recurrente debe haber subido.
      final estado = await repo.cargar();
      expect(estado.remitentesConocidos(), isEmpty);
    },
  );
}
