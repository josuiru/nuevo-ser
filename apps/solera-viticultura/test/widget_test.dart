import 'package:flutter_test/flutter_test.dart';
import 'package:solera_viticultura/main.dart';

void main() {
  testWidgets('App arranca y muestra el orquestador inicial',
      (WidgetTester tester) async {
    // Smoke test minimalista. El orquestador resuelve si mostrar
    // onboarding o pasar al mapa según el flag persistido. En el
    // primer pump se ve el spinner; tras settle se ve onboarding o
    // mapa. SharedPreferences no está mockeado en este test, así que
    // no asumimos qué pantalla concreta sale — solo que el árbol no
    // explota al construirse.
    await tester.pumpWidget(const SoleraViticulturaApp());
    expect(tester.takeException(), isNull);
  });
}
