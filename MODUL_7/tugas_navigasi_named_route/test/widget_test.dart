import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_navigasi_named_route/main.dart';

void main() {
  testWidgets('Tugas navigasi smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Ini Halaman Home'), findsOneWidget);
    expect(find.text('Ke halaman tujuan'), findsOneWidget);
  });
}
