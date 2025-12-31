import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('switches between global and section bars', (tester) async {
    await tester.pumpWidget(const MyApp());

    // GLOBAL state
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('관심'), findsNothing);

    // Tap the global "티켓" item to enter SECTION state.
    await tester.tap(find.text('티켓'));
    await tester.pumpAndSettle();

    // SECTION state items
    expect(find.text('관심'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Tap leading back button to return to GLOBAL state.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('홈'), findsOneWidget);
    expect(find.text('관심'), findsNothing);
  });
}
