import 'package:flutter_test/flutter_test.dart';

import 'package:uno_roto/main.dart';

void main() {
  testWidgets('La app arranca y muestra el título del prototipo',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AppUnoRoto());
    await tester.pump();

    expect(find.text('UNO ROTO'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('1/5'), findsOneWidget);
  });
}
