import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasbih_app/main.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

void main() {
  testWidgets(
    'Tasbih App lifecycle: kondisi awal 0, kenaikan bertahap, batas 33, dan reset',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // 1. Kondisi awal: counter 0
      expect(
        find.text('0'),
        findsNWidgets(2),
      ); // Satu di atas, satu di dalam lingkaran
      expect(find.byType(SimpleCircularProgressBar), findsOneWidget);
      expect(find.byIcon(Icons.fingerprint), findsOneWidget);
      expect(find.byIcon(Icons.refresh_outlined), findsOneWidget);

      final fingerprintFinder = find.byIcon(Icons.fingerprint);
      final refreshFinder = find.byIcon(Icons.refresh_outlined);

      // 2. Kenaikan satu kali (counter = 1)
      await tester.tap(fingerprintFinder);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsNWidgets(2));

      // Kenaikan beberapa kali hingga 17
      for (int i = 2; i <= 17; i++) {
        await tester.tap(fingerprintFinder);
        await tester.pumpAndSettle();
      }
      expect(find.text('17'), findsNWidgets(2));

      // 3. Reset dari nilai bukan nol (17 -> 0)
      await tester.tap(refreshFinder);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsNWidgets(2));

      // 4. Kenaikan hingga batas maksimal 33
      for (int i = 1; i <= 33; i++) {
        await tester.tap(fingerprintFinder);
        await tester.pumpAndSettle();
      }
      expect(find.text('33'), findsNWidgets(2));

      // 5. Coba tekan lagi saat sudah 33 (tidak boleh bertambah)
      await tester.tap(fingerprintFinder);
      await tester.pumpAndSettle();
      expect(find.text('33'), findsNWidgets(2));
      expect(find.text('34'), findsNothing);

      // 6. Reset dari 33 kembali ke 0
      await tester.tap(refreshFinder);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsNWidgets(2));
    },
  );
}
