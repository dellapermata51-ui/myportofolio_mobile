import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

import 'test_helpers.dart';

void useMobileScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(412, 892);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> openForm(WidgetTester tester, {http.Client? httpClient}) async {
  await tester.pumpWidget(
    buildTestApp(
      httpClient: httpClient,
      token: 'tok',
      home: const EducationFormPage(),
    ),
  );
}

Future<void> openFormFromCard(WidgetTester tester, {String? token}) async {
  await tester.pumpWidget(buildTestApp(token: token));
  final card = find.text('Tambah Education');
  await tester.ensureVisible(card);
  await tester.pumpAndSettle();
  await tester.tap(card);
  await tester.pumpAndSettle();
}

Future<void> enterField(WidgetTester tester, String label, String text) async {
  final field = find.widgetWithText(TextFormField, label);
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, text);
}

Future<void> pickDate(WidgetTester tester, String label) async {
  final field = find.widgetWithText(TextFormField, label);
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> tapSave(WidgetTester tester, {bool settle = true}) async {
  final button = find.text('Simpan');
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    // SnackBar hilang sendiri setelah beberapa detik, jadi jangan di-settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> fillValidForm(WidgetTester tester) async {
  await enterField(tester, 'Nama Institusi', 'Universitas Indonesia');
  await enterField(tester, 'Bidang Studi / Jurusan', 'Sistem Informasi');
  await pickDate(tester, 'Tanggal Mulai');
}

Future<void> openDrawer(WidgetTester tester) async {
  tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
  await tester.pumpAndSettle();
}

MockClient echoClient(List<http.Request> requests) {
  return MockClient((request) async {
    requests.add(request);
    if (request.method == 'GET') {
      return jsonResponse([], 200);
    }
    final body = jsonDecode(request.body) as Map<String, dynamic>;
    return jsonResponse({
      ...body,
      'id': '22222222-2222-2222-2222-222222222222',
      'level_display': (body['level'] as String).toUpperCase(),
      'period': 'Aug 2023 – Sekarang',
      'is_ongoing': body['ended_at'] == null,
      'star_count': 0,
      'is_starred': false,
      'starred_by_names': '',
    }, 201);
  });
}

void main() {
  testWidgets('Kartu Tambah Education mengarah ke login saat belum login', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    await openFormFromCard(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Add Education Form'), findsNothing);
  });

  testWidgets('Kartu Tambah Education membuka formulir saat sudah login', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    await openFormFromCard(tester, token: 'tok');

    expect(find.text('Add Education Form'), findsOneWidget);
    expect(find.text('Nama Institusi'), findsOneWidget);
    expect(find.text('Tanggal Mulai'), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);
  });

  testWidgets('Drawer membuka formulir Education dan Home kembali ke utama', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    await tester.pumpWidget(buildTestApp(token: 'tok'));

    await openDrawer(tester);
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    expect(find.text('Add Education Form'), findsOneWidget);

    await openDrawer(tester);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    expect(find.text('Add Education'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('Drawer Add Education mengarah ke login saat belum login', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    await tester.pumpWidget(buildTestApp());

    await openDrawer(tester);
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Input kosong menampilkan pesan error dan tidak mengirim', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    final requests = <http.Request>[];
    await openForm(tester, httpClient: echoClient(requests));

    await tapSave(tester);

    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Bidang studi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tanggal mulai wajib dipilih!'), findsOneWidget);
    expect(
      find.textContaining('Pilih tanggal selesai atau aktifkan'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
    expect(requests, isEmpty);
  });

  testWidgets('Input valid dikirim lewat POST dan menampilkan ringkasan', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    final requests = <http.Request>[];
    await openForm(tester, httpClient: echoClient(requests));

    await fillValidForm(tester);
    await pickDate(tester, 'Tanggal Selesai');
    await tapSave(tester);

    expect(requests, hasLength(1));
    final request = requests.single;
    final body = jsonDecode(request.body) as Map<String, dynamic>;
    expect(request.method, 'POST');
    expect(request.url.path, '/api/v1/education/');
    expect(request.headers['Authorization'], 'Token tok');
    expect(body['institution'], 'Universitas Indonesia');
    expect(body['program'], 'Sistem Informasi');
    expect(body['level'], 's1');
    expect(body['started_at'], endsWith('Z'));
    expect(body['ended_at'], isNotNull);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Data pendidikan berhasil disimpan!'), findsOneWidget);
    expect(find.text('Institusi: Universitas Indonesia'), findsOneWidget);
    expect(find.text('Bidang Studi: Sistem Informasi'), findsOneWidget);

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Add Education Form'), findsOneWidget);
  });

  testWidgets('Lihat Daftar membuka daftar Education setelah berhasil', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    final requests = <http.Request>[];
    await openForm(tester, httpClient: echoClient(requests));

    await fillValidForm(tester);
    await pickDate(tester, 'Tanggal Selesai');
    await tapSave(tester);

    await tester.tap(find.text('Lihat Daftar'));
    await tester.pumpAndSettle();

    expect(find.byType(EducationListScreen), findsOneWidget);
    expect(requests.map((r) => r.method), ['POST', 'GET']);
  });

  testWidgets('Switch masih menempuh pendidikan mengirim ended_at null', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    final requests = <http.Request>[];
    await openForm(tester, httpClient: echoClient(requests));

    await fillValidForm(tester);

    final toggle = find.byType(SwitchListTile);
    await tester.ensureVisible(toggle);
    await tester.pumpAndSettle();
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    await tapSave(tester);

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(body['ended_at'], isNull);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.text('Tanggal Selesai: Sekarang (masih menempuh pendidikan)'),
      findsOneWidget,
    );
  });

  testWidgets('Isian hanya spasi atau terlalu pendek ditolak', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    await openForm(tester);

    await enterField(tester, 'Nama Institusi', '     ');
    await enterField(tester, 'Bidang Studi / Jurusan', 'ab');
    await tapSave(tester);

    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Bidang studi minimal 3 karakter!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Status 401 menghapus sesi dan meminta login ulang', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/auth/logout/')) {
        return http.Response('', 204);
      }
      return jsonResponse({'detail': 'Invalid token.'}, 401);
    });
    await openForm(tester, httpClient: client);

    await fillValidForm(tester);
    await pickDate(tester, 'Tanggal Selesai');
    await tapSave(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
    final context = tester.element(find.byType(LoginScreen));
    expect(context.read<AuthState>().isLoggedIn, isFalse);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Status 403 menampilkan pesan izin tanpa logout', (
    WidgetTester tester,
  ) async {
    useMobileScreen(tester);
    final client = MockClient(
      (_) async => jsonResponse({'detail': 'Forbidden'}, 403),
    );
    await openForm(tester, httpClient: client);

    await fillValidForm(tester);
    await pickDate(tester, 'Tanggal Selesai');
    await tapSave(tester, settle: false);

    expect(find.textContaining('tidak memiliki izin'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    final context = tester.element(find.byType(EducationFormPage));
    expect(context.read<AuthState>().isLoggedIn, isTrue);
  });
}
