import 'package:flutter_test/flutter_test.dart';
import 'package:demo_navigasi_pageroute/main.dart';

void main() {
  testWidgets('Navigasi demo_navigasi_pageroute smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Halaman Home'), findsOneWidget);
    expect(find.text('Ini adalah halaman Home'), findsOneWidget);
  });
}
