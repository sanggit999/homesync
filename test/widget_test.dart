import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_sync/main.dart';

void main() {
  testWidgets('HomeSyncApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeSyncApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
