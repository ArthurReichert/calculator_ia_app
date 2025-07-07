import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_ia_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts correctly
    expect(find.byType(MyApp), findsOneWidget);

    // Since the app might show either ApiSetupPage or ChatPage depending on
    // whether API key is configured, we just verify the app loads
    await tester.pump();

    // The app should load without errors
    expect(tester.takeException(), isNull);
  });
}
