import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Daftar Education tampil publik tanpa login', (tester) async {
    final client = MockClient(
      (_) async => jsonResponse([educationJson()], 200),
    );
    await tester.pumpWidget(
      buildTestApp(httpClient: client, home: const EducationListScreen()),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Universitas Indonesia'), findsOneWidget);
    expect(find.text('S1 • Sistem Informasi'), findsOneWidget);
    expect(find.text('Aug 2023 – Sekarang'), findsOneWidget);
  });

  testWidgets('Kartu Lihat Education membuka daftar dan detail', (
    tester,
  ) async {
    final client = MockClient(
      (_) async => jsonResponse([educationJson()], 200),
    );
    await tester.pumpWidget(buildTestApp(httpClient: client));

    final card = find.text('Lihat Education');
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('Achievements: Education'), findsOneWidget);

    await tester.tap(find.text('Universitas Indonesia'));
    await tester.pumpAndSettle();

    expect(find.text('Program'), findsOneWidget);
    expect(find.text('Sistem Informasi'), findsOneWidget);
    expect(find.text('Started At'), findsOneWidget);
    expect(find.text('1 Agustus 2023'), findsOneWidget);
    expect(find.text('Sekarang'), findsOneWidget);
    expect(find.text('owner, regular'), findsOneWidget);
  });

  testWidgets('Daftar kosong menampilkan pesan empty', (tester) async {
    final client = MockClient((_) async => jsonResponse([], 200));
    await tester.pumpWidget(
      buildTestApp(httpClient: client, home: const EducationListScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('No education found.'), findsOneWidget);
  });

  testWidgets('Error menampilkan tombol Retry yang memuat ulang data', (
    tester,
  ) async {
    var calls = 0;
    final client = MockClient((_) async {
      calls++;
      if (calls == 1) {
        return http.Response('gagal', 500);
      }
      return jsonResponse([educationJson()], 200);
    });
    await tester.pumpWidget(
      buildTestApp(httpClient: client, home: const EducationListScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to load education'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Universitas Indonesia'), findsOneWidget);
    expect(calls, 2);
  });
}
