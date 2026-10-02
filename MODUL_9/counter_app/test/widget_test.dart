import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:counter_app/main.dart';

void main() {
  group('Percobaan 1 — CounterPage Tests', () {
    testWidgets('Kondisi awal counter 0 dan tombol tambah/kurang bekerja', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CounterPage()));

      // Periksa tampilan awal
      expect(find.text('Counter App'), findsOneWidget);
      expect(find.text('Klik tombol tambah atau kurang:'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      // Tekan tombol Tambah
      await tester.tap(find.text('Tambah'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // Tekan tombol Tambah lagi
      await tester.tap(find.text('Tambah'));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Tekan tombol Kurang
      await tester.tap(find.text('Kurang'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // Tekan tombol Kurang lagi hingga 0 dan negatif
      await tester.tap(find.text('Kurang'));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);

      await tester.tap(find.text('Kurang'));
      await tester.pump();
      expect(find.text('-1'), findsOneWidget);
    });
  });

  group('Percobaan 2 — LikeButtonPage Tests', () {
    testWidgets(
      'Kondisi awal 10 likes, toggle ke 11 likes dan kembali ke 10 likes',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: LikeButtonPage()));

        // Periksa tampilan awal
        expect(find.text('Like Button'), findsOneWidget);
        expect(find.text('10 likes'), findsOneWidget);

        // Periksa ikon awal adalah favorite_border (abu-abu)
        final initialIconFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Icon &&
              widget.icon == Icons.favorite_border &&
              widget.color == Colors.grey,
        );
        expect(initialIconFinder, findsOneWidget);

        // Tekan tombol like pertama kali
        await tester.tap(find.byType(IconButton));
        await tester.pump();

        // Periksa perubahan: jumlah like jadi 11, icon jadi favorite (merah)
        expect(find.text('11 likes'), findsOneWidget);
        final likedIconFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Icon &&
              widget.icon == Icons.favorite &&
              widget.color == Colors.red,
        );
        expect(likedIconFinder, findsOneWidget);

        // Tekan tombol like kedua kali (unlike)
        await tester.tap(find.byType(IconButton));
        await tester.pump();

        // Periksa kembali ke kondisi semula: jumlah like 10, icon favorite_border (abu-abu)
        expect(find.text('10 likes'), findsOneWidget);
        expect(initialIconFinder, findsOneWidget);
      },
    );

    testWidgets('MyApp memuat LikeButtonPage sebagai halaman home utama', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Like Button'), findsOneWidget);
      expect(find.text('10 likes'), findsOneWidget);
    });
  });
}
