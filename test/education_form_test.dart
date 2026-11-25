import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';


void useMobileScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(412, 892);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> openFormFromCard(WidgetTester tester) async {
  await tester.pumpWidget(MyApp(apiClient: ApiClient()));
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

Future<void> tapSave(WidgetTester tester) async {
  final button = find.text('Simpan');
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> openDrawer(WidgetTester tester) async {
  tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Kartu Tambah Education membuka halaman formulir',
          (WidgetTester tester) async {
        useMobileScreen(tester);
        await openFormFromCard(tester);

        expect(find.text('Add Education Form'), findsOneWidget);
        expect(find.text('Nama Institusi'), findsOneWidget);
        expect(find.text('Tanggal Mulai'), findsOneWidget);
        expect(find.text('Simpan'), findsOneWidget);
      });

  testWidgets('Drawer membuka formulir Education dan Home kembali ke utama',
          (WidgetTester tester) async {
        useMobileScreen(tester);
        await tester.pumpWidget(MyApp(apiClient: ApiClient()));

        await openDrawer(tester);
        await tester.tap(find.text('Add Education'));
        await tester.pumpAndSettle();
        expect(find.text('Add Education Form'), findsOneWidget);

        await openDrawer(tester);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Add Project'), findsOneWidget);
        expect(find.text('Add Education'), findsOneWidget);

        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();
        expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
      });

  testWidgets('Input kosong menampilkan pesan error dan tidak membuka dialog',
          (WidgetTester tester) async {
        useMobileScreen(tester);
        await openFormFromCard(tester);

        await tapSave(tester);

        expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
        expect(find.text('Bidang studi tidak boleh kosong!'), findsOneWidget);
        expect(find.text('Tanggal mulai wajib dipilih!'), findsOneWidget);
        expect(find.textContaining('Pilih tanggal selesai atau aktifkan'),
            findsOneWidget);
        expect(find.byType(AlertDialog), findsNothing);
      });

  testWidgets('Input valid menampilkan dialog ringkasan lalu bisa ditutup',
          (WidgetTester tester) async {
        useMobileScreen(tester);
        await openFormFromCard(tester);

        await enterField(tester, 'Nama Institusi', 'Universitas Indonesia');
        await enterField(tester, 'Bidang Studi / Jurusan', 'Sistem Informasi');
        await pickDate(tester, 'Tanggal Mulai');
        await pickDate(tester, 'Tanggal Selesai');
        await tapSave(tester);

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Data pendidikan berhasil disimpan!'), findsOneWidget);
        expect(find.text('Institusi: Universitas Indonesia'), findsOneWidget);
        expect(find.text('Bidang Studi: Sistem Informasi'), findsOneWidget);

        await tester.tap(find.text('Tutup'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('Add Education Form'), findsOneWidget);
      });

  testWidgets('Switch masih menempuh pendidikan melewati tanggal selesai',
          (WidgetTester tester) async {
        useMobileScreen(tester);
        await openFormFromCard(tester);

        await enterField(tester, 'Nama Institusi', 'Universitas Indonesia');
        await enterField(tester, 'Bidang Studi / Jurusan', 'Sistem Informasi');
        await pickDate(tester, 'Tanggal Mulai');

        final toggle = find.byType(SwitchListTile);
        await tester.ensureVisible(toggle);
        await tester.pumpAndSettle();
        await tester.tap(toggle);
        await tester.pumpAndSettle();

        await tapSave(tester);

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Tanggal Selesai: Sekarang (masih menempuh pendidikan)'),
            findsOneWidget);
      });

  testWidgets('Isian hanya spasi atau terlalu pendek ditolak',
          (WidgetTester tester) async {
        useMobileScreen(tester);
        await openFormFromCard(tester);

        await enterField(tester, 'Nama Institusi', '     ');
        await enterField(tester, 'Bidang Studi / Jurusan', 'ab');
        await tapSave(tester);

        expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
        expect(find.text('Bidang studi minimal 3 karakter!'), findsOneWidget);
        expect(find.byType(AlertDialog), findsNothing);
      });
}