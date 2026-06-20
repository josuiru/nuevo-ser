// Smoke test de FZ-1: la app monta, resuelve el primer arranque y navega.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:solera_zunbeltz/main.dart';

void main() {
  testWidgets('Primer arranque: muestra la bienvenida', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const AppSoleraZunbeltz());
    await tester.pumpAndSettle();
    // Sin idioma elegido cae a castellano; la bienvenida lleva "Empezar".
    expect(find.text('Empezar'), findsOneWidget);
  });

  testWidgets('Onboarding ya visto: muestra la navegación principal',
      (tester) async {
    SharedPreferences.setMockInitialValues({'zunbeltz.onboarding_visto': true});
    await tester.pumpWidget(const AppSoleraZunbeltz());
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
