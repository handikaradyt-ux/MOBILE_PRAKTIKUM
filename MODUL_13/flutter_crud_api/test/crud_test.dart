import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_crud_api/main.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
    GoogleFonts.config.allowRuntimeFetching = false;
  });
  test('POST sends JSON and parses a 201 response', () async {
    final api = PostApi(
      MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/posts');
        expect(request.headers['Content-type'], contains('application/json'));
        expect(jsonDecode(request.body), {
          'title': 'Radyt',
          'body': 'Programmer',
          'userId': 1,
        });
        return http.Response(
          '{"id":101,"title":"Radyt","body":"Programmer"}',
          201,
        );
      }),
    );
    final post = await api.create('Radyt', 'Programmer');
    expect(post.id, 101);
    expect(post.userId, 1);
    expect(post.title, 'Radyt');
  });
  test('PUT targets demo ID 1 and preserves creation time', () async {
    final when = DateTime.utc(2026, 11, 6, 3);
    final original = Post(
      id: 101,
      userId: 1,
      title: 'Awal',
      body: 'Lama',
      createdAt: when,
    );
    final api = PostApi(
      MockClient((request) async {
        expect(request.method, 'PUT');
        expect(request.url.path, '/posts/1');
        expect(jsonDecode(request.body)['id'], 1);
        return http.Response(
          '{"id":1,"userId":1,"title":"Baru","body":"Developer"}',
          200,
        );
      }),
    );
    final updated = await api.update(original, 'Baru', 'Developer');
    expect(updated.id, 1);
    expect(updated.createdAt, when);
  });
  test('DELETE uses active ID and rejects HTTP errors', () async {
    final api = PostApi(
      MockClient((request) async {
        expect(request.method, 'DELETE');
        expect(request.url.path, '/posts/1');
        return http.Response('{}', 503);
      }),
    );
    await expectLater(api.delete(1), throwsA(isA<ApiException>()));
  });
  test('Invalid JSON is rejected instead of producing corrupt state', () async {
    final api = PostApi(
      MockClient((_) async => http.Response('{"id":"bad"}', 201)),
    );
    await expectLater(api.create('A', 'B'), throwsFormatException);
  });

  Future<void> start(WidgetTester tester, http.Client client) async {
    await tester.pumpWidget(MyApp(client: client));
    await tester.runAsync(() async => GoogleFonts.pendingFonts());
    await tester.pumpAndSettle();
  }

  Future<void> add(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Tambah post'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Radyt Guruh Handika',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Programmer');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
  }

  Future<void> menu(WidgetTester tester, String action) async {
    await tester.tap(find.byTooltip('Aksi post'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(action));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Complete CRUD flow with prefilled edit, cancel and confirmed delete',
    (tester) async {
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        if (request.method == 'DELETE') return http.Response('{}', 200);
        final data = jsonDecode(request.body) as Map<String, dynamic>;
        data['id'] = request.method == 'POST' ? 101 : 1;
        return http.Response(
          jsonEncode(data),
          request.method == 'POST' ? 201 : 200,
        );
      });
      await start(tester, client);
      expect(find.text('Demo CRUD client-server di Flutter'), findsOneWidget);
      await add(tester);
      expect(find.text('Radyt Guruh Handika'), findsOneWidget);
      expect(find.text('id: 101'), findsOneWidget);
      await menu(tester, 'Update');
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).at(0))
            .controller!
            .text,
        'Radyt Guruh Handika',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Flutter Developer',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
      await tester.pumpAndSettle();
      expect(find.text('Flutter Developer'), findsOneWidget);
      expect(find.text('id: 1'), findsOneWidget);
      await menu(tester, 'Delete');
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(requests.where((r) => r.method == 'DELETE'), isEmpty);
      expect(find.text('Flutter Developer'), findsOneWidget);
      await menu(tester, 'Delete');
      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();
      expect(find.text('Demo CRUD client-server di Flutter'), findsOneWidget);
      expect(find.text('Post berhasil dihapus!'), findsOneWidget);
      expect(requests.map((r) => r.method), ['POST', 'PUT', 'DELETE']);
    },
  );
  testWidgets('Empty fields are rejected without making a request', (
    tester,
  ) async {
    int requests = 0;
    await start(
      tester,
      MockClient((_) async {
        requests++;
        return http.Response('{}', 500);
      }),
    );
    await tester.tap(find.byTooltip('Tambah post'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Nama harus diisi'), findsOneWidget);
    expect(find.text('Pekerjaan harus diisi'), findsOneWidget);
    expect(requests, 0);
  });
  testWidgets('Failed update keeps existing data and displays red feedback', (
    tester,
  ) async {
    await start(
      tester,
      MockClient((request) async {
        if (request.method == 'PUT') throw http.ClientException('offline');
        return http.Response(
          '{"id":101,"userId":1,"title":"Radyt Guruh Handika","body":"Programmer"}',
          201,
        );
      }),
    );
    await add(tester);
    await menu(tester, 'Update');
    await tester.enterText(find.byType(TextFormField).at(1), 'Changed');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
    await tester.pumpAndSettle();
    expect(find.text('Programmer'), findsOneWidget);
    expect(find.text('Changed'), findsNothing);
    expect(
      find.text('Tidak dapat terhubung. Periksa koneksi internet.'),
      findsOneWidget,
    );
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      Colors.red[700],
    );
  });
  testWidgets('Pending request disables actions and is safe after disposal', (
    tester,
  ) async {
    final response = Completer<http.Response>();
    await start(tester, MockClient((_) => response.future));
    await tester.tap(find.byTooltip('Tambah post'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'A');
    await tester.enterText(find.byType(TextFormField).at(1), 'B');
    await tester.tap(find.text('Simpan'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(
      tester
          .widget<FloatingActionButton>(find.byType(FloatingActionButton))
          .onPressed,
      isNull,
    );
    await tester.pumpWidget(const SizedBox());
    response.complete(http.Response('{"id":101,"title":"A","body":"B"}', 201));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
