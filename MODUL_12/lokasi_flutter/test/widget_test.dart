import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokasi_flutter/main.dart';

void main() {
  testWidgets('Tampilan awal Lokasi Saya smoke test', (
    WidgetTester tester,
  ) async {
    // Build aplikasi dan render frame pertama
    await tester.pumpWidget(const MyApp());

    // Verifikasi judul AppBar
    expect(find.text('Lokasi Saya'), findsOneWidget);

    // Verifikasi teks placeholder awal pada Card
    expect(find.text('Tekan tombol untuk menampilkan lokasi.'), findsOneWidget);

    // Verifikasi tombol TAMPILKAN LOKASI SAAT INI
    expect(find.text('TAMPILKAN LOKASI SAAT INI'), findsOneWidget);

    // Verifikasi tombol aktif secara default (onPressed tidak null)
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });
}
