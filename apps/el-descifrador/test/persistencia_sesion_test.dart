// Tests end-to-end de persistencia de sesión.
//
// Verifica que al cerrar y reabrir la app, las decisiones quedan
// persistidas y la pieza ya no aparece en bandeja de entrada.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/cargador_corpus.dart';
import 'package:el_descifrador/datos/repositorio_familiaridad.dart';
import 'package:el_descifrador/datos/repositorio_sesion.dart';
import 'package:el_descifrador/dominio/decision_documento.dart';
import 'package:el_descifrador/l10n/app_localizations.dart';
import 'package:el_descifrador/vista/pantalla_mesa.dart';

import 'soporte/bundle_en_memoria.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget _app({
    required CargadorCorpus cargador,
    required RepositorioFamiliaridad famRepo,
    required RepositorioSesion sesRepo,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      home: PantallaMesa(
        cargadorInyectado: cargador,
        repositorioFamiliaridadInyectado: famRepo,
        repositorioSesionInyectado: sesRepo,
      ),
    );
  }

  testWidgets(
    'Decisión persiste — al reabrir la app, la pieza no vuelve a bandeja',
    (tester) async {
      final cargador = CargadorCorpus(bundle: bundleConPiezasReales());
      final famRepo = RepositorioFamiliaridad(idPerfil: 'persistencia');
      final sesRepo = RepositorioSesion(idPerfil: 'persistencia');

      // Primera sesión: abrir mesa, archivar Inês, cerrar.
      await tester.pumpWidget(
        _app(cargador: cargador, famRepo: famRepo, sesRepo: sesRepo),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('pieza-carta-ines-bacalao-001')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      // Identificar lengua antes de archivar (mecánica nuclear §3.1).
      await tester.tap(find.text('Portugués'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Archivar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Confirmar que la decisión se persistió.
      final sesion = await sesRepo.cargar();
      expect(
        sesion.decisionesPorPieza['carta-ines-bacalao-001'],
        DecisionDocumento.archivar,
      );

      // Segunda sesión: recrear la app desde cero. Inês ya no está
      // en bandeja, Niko sí.
      await tester.pumpWidget(
        _app(cargador: cargador, famRepo: famRepo, sesRepo: sesRepo),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('ines cocinera lisboa'), findsNothing);
      expect(find.textContaining('aprendiz-companero-niko'), findsOneWidget);
      expect(find.text('Archivo: 1 pieza'), findsOneWidget);
    },
  );
}
