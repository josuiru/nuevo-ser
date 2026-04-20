import 'package:flutter_test/flutter_test.dart';

import 'package:uno_roto/main.dart';

void main() {
  testWidgets('La app arranca mostrando el título de apertura',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AppUnoRoto());
    await tester.pump();

    expect(find.text('UNO'), findsOneWidget);
    expect(find.text('ROTO'), findsOneWidget);
  });
}
