import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('Halaman utama menampilkan InfoCard dan SnackBar saat tombol ditekan',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    // InfoCard tampil.
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Class'), findsOneWidget);

    // Tekan salah satu tombol, SnackBar harus muncul.
    await tester.tap(find.text('Lihat Education'));
    await tester.pump();
    expect(find.text('Kamu telah menekan tombol Lihat Education!'),
        findsOneWidget);
  });

  testWidgets('Tambah Proyek mengarahkan ke layar login saat belum login',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    final card = find.text('Tambah Proyek');
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
