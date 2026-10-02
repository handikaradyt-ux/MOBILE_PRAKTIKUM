import 'package:flutter_test/flutter_test.dart';
import 'package:music_card/main.dart';

void main() {
  testWidgets('App starts and displays AppBar title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Sedang memutar'), findsOneWidget);
  });
}
