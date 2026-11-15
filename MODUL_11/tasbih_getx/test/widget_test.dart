import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tasbih_getx/main.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  testWidgets('Tasbih Digital smoke and interaction test', (
    WidgetTester tester,
  ) async {
    // Build widget
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Pastikan angka awal adalah 0
    expect(find.text('0'), findsOneWidget);

    // Temukan tombol fingerprint dan tekan
    final fingerprintFinder = find.byIcon(Icons.fingerprint);
    expect(fingerprintFinder, findsOneWidget);

    await tester.tap(fingerprintFinder);
    await tester.pumpAndSettle();

    // Angka bertambah menjadi 1
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);

    // Tekan tombol reset
    final resetFinder = find.byIcon(Icons.refresh_outlined);
    expect(resetFinder, findsOneWidget);

    await tester.tap(resetFinder);
    await tester.pumpAndSettle();

    // Angka kembali ke 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
