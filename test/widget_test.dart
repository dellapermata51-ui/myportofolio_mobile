
import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';
 
void main() {
  testWidgets('Halaman utama menampilkan InfoCard dan SnackBar saat tombol ditekan',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
 
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
}
