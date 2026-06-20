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
    // No usamos pumpAndSettle: el mapa (FlutterMap) reprograma frames y
    // nunca asienta. Pumpeamos lo justo para resolver el future del
    // orquestador (lee shared_preferences) y comprobamos la navegación.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(NavigationBar), findsOneWidget);
    // Desmontamos para cancelar los timers del mapa antes de terminar.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
