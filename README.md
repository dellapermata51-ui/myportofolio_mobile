# MyPortfolio Mobile - Della Permata Prasilda - 2506656614 - A


# Tugas 7
## Deskripsi Proyek
Tugas 7 mulai dikembangkan menjadi aplikasi mobile menggunakan Flutter. Aplikasi ini memiliki halaman utama MyHomePage yang menampilkan informasi pemilik portofolio melalui tiga InfoCard, yaitu NPM, nama, dan kelas. Selain itu, terdapat enam tombol menu (ItemCard) untuk mengakses Education, Skills, Experience, Proyek, Tambah Proyek, dan Logout. Setiap tombol memiliki ikon dan warna yang berbeda serta menampilkan SnackBar ketika ditekan. Tampilan halaman juga dibuat agar bisa di-scroll sehingga seluruh elemen tetap dapat ditampilkan dengan rapi.

## Pertanyaan Reflektif
### Tugas 7

1. **Widget tree dan hubungan parent-child**

    Widget Tree adalah susunan widget yang membentuk tampilan aplikasi. Setiap widget bisa menjadi parent yang membungkus widget lain (child). Parent mengatur batas ukuran dan posisi child, sedangkan child menentukan ukurannya sesuai batas tersebut. Jika tampilan berubah, Flutter akan membangun ulang bagian widget yang diperlukan. Pada proyek ini, MyApp menjadi widget utama yang membungkus MaterialApp, lalu MyHomePage, Scaffold, dan widget lainnya.

2. **Widget yang digunakan dan fungsinya**

   - `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard`: widget buatan sendiri (semuanya `StatelessWidget`) untuk memecah tampilan menjadi bagian-bagian yang bisa dipakai ulang. `ItemHomepage` bukan widget, melainkan kelas model data (nama, ikon, warna) untuk setiap tombol.
   - `MaterialApp`: widget root yang menyediakan tema Material, navigasi, dan `ScaffoldMessenger`, serta menentukan halaman awal lewat `home`.
   - `Scaffold`: kerangka dasar halaman Material (tempat `AppBar`, body, dan `SnackBar` ditampilkan).
   - `AppBar`: bar bagian atas halaman yang memuat judul "MyPortfolio".
   - `SingleChildScrollView`: membuat isi halaman bisa di-scroll agar tidak overflow ketika tombol banyak.
   - `Padding`: memberi jarak di sekeliling child.
   - `Column` dan `Row`: menyusun child secara vertikal dan horizontal. `Row` dipakai untuk menjajarkan tiga `InfoCard`.
   - `Center`: memusatkan child.
   - `SizedBox`: ruang kosong dengan ukuran tertentu sebagai pemisah antar elemen.
   - `Card`: kartu dengan bayangan (elevasi) sebagai dasar `InfoCard`.
   - `Container`: kotak serbaguna untuk mengatur lebar, padding, dan dekorasi isi kartu.
   - `Text`: menampilkan teks.
   - `Icon`: menampilkan ikon pada tombol menu.
   - `GridView.count`: menata `ItemCard` dalam kisi dengan 3 kolom.
   - `Material`: permukaan Material yang memberi warna latar dan sudut membulat pada `ItemCard` serta menjadi tempat efek ripple.
   - `InkWell`: membuat area bisa disentuh (`onTap`) sekaligus memberi efek ripple.
   - `SnackBar`: pesan singkat di bagian bawah layar ("Kamu telah menekan tombol ...!"), ditampilkan melalui `ScaffoldMessenger`.
   - `ScaffoldMessenger`: pengelola `SnackBar` yang dipanggil dengan `ScaffoldMessenger.of(context)`.

3. **Fungsi `MaterialApp` dan alasan dipakai sebagai root**

    `MaterialApp` adalah widget yang menjadi dasar aplikasi dengan desain Material. Widget ini mengatur tema, halaman utama, navigasi, dan fitur seperti `ScaffoldMessenger` untuk menampilkan `SnackBar`.

    MaterialApp diletakkan sebagai root karena widget lain seperti `Scaffold` dan `AppBar` membutuhkan pengaturan yang disediakan olehnya. Dengan begitu, pengaturan aplikasi cukup dibuat satu kali dan bisa digunakan oleh seluruh halaman.


4. **Perbedaan `StatelessWidget` dan `StatefulWidget`**

   `StatelessWidget` tidak memiliki state internal yang berubah. Tampilannya sepenuhnya ditentukan oleh data yang diberikan lewat constructor, sehingga hasil `build()` selalu sama untuk masukan yang sama. `StatefulWidget` memiliki objek `State` terpisah yang menyimpan data yang bisa berubah selama aplikasi berjalan, dan tampilan dibangun ulang ketika `setState()` dipanggil. `StatefulWidget` juga punya siklus hidup seperti `initState()` dan `dispose()`.

   Pilih `StatelessWidget` jika tampilan hanya bergantung pada data yang diterima dan tidak berubah dari dalam, seperti `InfoCard`, `ItemCard`, dan `MyHomePage` pada proyek ini. Pilih `StatefulWidget` jika widget perlu mengingat dan mengubah data sendiri, misalnya input form, counter, checkbox atau toggle, animasi, atau data yang dimuat lalu ditampilkan secara bertahap.

5. **`BuildContext`**

   `BuildContext` adalah penunjuk lokasi sebuah widget di dalam widget tree. Setiap widget punya context-nya sendiri, dan lewat context itu kita bisa mencari ancestor di atasnya, misalnya `Theme.of(context)`, `MediaQuery.of(context)`, `Navigator.of(context)`, dan `ScaffoldMessenger.of(context)`. Karena itu `BuildContext` penting: ia menjadi cara widget mengambil data dan layanan yang disediakan widget di atasnya tanpa harus meneruskannya manual lewat constructor.

   Di dalam `build(BuildContext context)`, context itu milik widget yang sedang dibangun. Pada proyek ini kita memakainya untuk `Theme.of(context).colorScheme.primary` (warna `AppBar`), `MediaQuery.of(context).size.width / 3.5` (lebar `InfoCard`), dan `ScaffoldMessenger.of(context)` (menampilkan `SnackBar` saat `ItemCard` ditekan).

6. **Hot reload, hot restart, dan kapan perlu restart penuh**

   - *Hot reload* menyuntikkan kode Dart yang baru ke Dart VM yang sedang berjalan, lalu membangun ulang widget tree tanpa menghapus state aplikasi. Prosesnya cepat, sehingga cocok untuk mengubah tampilan, warna, atau teks. 
   - *Hot restart* memuat ulang seluruh kode dan menjalankan `main()` dari awal, sehingga semua state kembali ke nilai awal. Prosesnya lebih lama daripada hot reload, tetapi lebih cepat daripada menjalankan ulang aplikasi dari awal (*full restart*), yaitu menutup aplikasi lalu `flutter run` lagi, yang juga mem-build ulang bagian native.

   Hot reload tidak cukup ketika:
   - perubahan menyangkut `main()` atau inisialisasi awal aplikasi, serta variabel global dan field `static` (nilai awalnya hanya dihitung sekali), atau logika `initState()` yang sudah terlanjur dijalankan;
   - mengubah state yang sudah ada dengan cara yang tidak ikut ter-update, misalnya mengubah tipe sebuah kelas atau `enum`, atau mengubah generic type;
   - menambah atau mengubah dependency di `pubspec.yaml` (jalankan `flutter pub get`, lalu restart) atau menambah asset;
   - mengubah kode native atau konfigurasi platform (Android/iOS), seperti `AndroidManifest.xml`, `Info.plist`, atau menambah plugin native. Untuk ini diperlukan *full restart*, yaitu menghentikan aplikasi lalu menjalankannya lagi.
