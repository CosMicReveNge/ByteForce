import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testflutter/main.dart'; // Importing your main app

void main() {
  testWidgets('HomeScreen loads and shows expected UI elements', (
    WidgetTester tester,
  ) async {
    // Load the app
    await tester.pumpWidget(const MyApp());

    // Let animations or async UI load
    await tester.pumpAndSettle();

    // Verify something from HomeScreen — change this if needed
    expect(find.text('Manga Reader'), findsWidgets);

    // You can add more checks here depending on what's in your HomeScreen
    // Example: check if a FloatingActionButton exists
    // expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
