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

## AI Disclosure
- Dalam pengerjaan tugas ini, saya menggunakan Claude (Anthropic) sebagai alat bantu untuk memahami instruksi Tugas 7 dan mencari solusi teknis. AI membantu memberikan arahan dan kode, namun saya tetap menyesuaikan seluruh saran dengan struktur kode proyek `myportofolio_mobile` yang saya kerjakan di Tutorial 08.
- Saya menggunakan AI secara bertahap berdasarkan checklist tugas, kemudian memeriksa, menyesuaikan, dan menguji hasilnya sendiri dengan `flutter analyze`, `flutter test`, dan `flutter run`. Perubahan juga saya kerjakan dan commit secara bertahap agar proses pengerjaan tetap terdokumentasi di Git.
- AI tidak bisa menjalankan Flutter maupun emulator, sehingga hasil `flutter analyze`, `flutter test`, serta tampilan kartu, warna, dan `SnackBar` di aplikasi tetap saya cek sendiri. Nama lengkap dan kelas pada `InfoCard` juga saya konfirmasi sendiri. Test bawaan template (tes counter) saya ganti karena tidak sesuai lagi dengan aplikasi ini.
- Prompt yang saya gunakan:
"kenapa GridView di dalam SingleChildScrollView butuh `primary: false`?"
"kenapa `ScaffoldMessenger.of(context)` bisa menemukan Scaffold-nya?"

# Tugas 8
## Deskripsi Proyek
Aplikasi kini memiliki halaman **Add Education** yang menyediakan berbagai input, seperti nama institusi, jenjang pendidikan, bidang studi, tanggal mulai dan selesai, status pendidikan, serta deskripsi. Formulir dilengkapi validasi untuk memastikan data yang dimasukkan sesuai dengan ketentuan, termasuk validasi isian wajib, dan tanggal pendidikan. Selain itu, ditambahkan hasil ringkasan yang menampilkan data setelah seluruh input berhasil divalidasi. Pengguna dapat mengakses formulir melalui tombol **Tambah Education** pada halaman utama maupun melalui `LeftDrawer`, yang juga menyediakan navigasi kembali ke halaman utama dan halaman tambah proyek.

## Pertanyaan Reflektif
### Tugas 8
1. **Perbedaan `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`**

   - `Navigator.push()` menambahkan halaman baru di atas halaman saat ini. Halaman lama tetap ada di bawahnya sehingga pengguna bisa kembali dengan tombol kembali.
   - `Navigator.pushReplacement()` mengganti halaman paling atas dengan halaman baru. Halaman lama dibuang dari tumpukan, jadi pengguna tidak bisa kembali ke halaman tersebut.
   - `Navigator.pop()` menutup halaman paling atas dan kembali ke halaman di bawahnya. Metode ini juga dipakai untuk menutup hasil, seperti pada tombol **Tutup**.

2. **Peran `Scaffold`, `AppBar`, dan `Drawer` dalam menjaga struktur halaman tetap konsisten**

   `Scaffold` menyediakan kerangka halaman Material dengan slot yang sudah baku: `appBar` di atas, `drawer` di sisi kiri, `body` untuk isi, dan area untuk `SnackBar`. Setiap halaman (`MyHomePage`, `ProjectFormPage`, `EducationFormPage`) memakai susunan yang sama, sehingga pengguna selalu menemukan judul di bagian atas dan menu navigasi di tempat yang sama. `LeftDrawer` dibuat sebagai satu widget terpisah dan dipakai ulang di semua halaman, jadi opsi menu dan tampilan drawer selalu sama dan perubahan cukup dilakukan di satu tempat.

   Contoh penggunaan warna tema: `Theme.of(context).colorScheme.primary` (berasal dari `ColorScheme.fromSeed(seedColor: Colors.indigo)` pada `MaterialApp`) dipakai sebagai warna latar `AppBar` di `MyHomePage` dan di `EducationFormPage`, serta sebagai warna tombol **Simpan**. Header `LeftDrawer` memakai warna indigo yang sama, sehingga seluruh halaman terlihat seragam.

3. **Alasan tata letak formulir dan peran widget pengatur jarak serta widget penggulir**

   Formulir disusun vertikal dalam satu kolom (`Column`) karena input diisi berurutan dan mudah dipakai dengan satu tangan di layar ponsel. `Column` dibungkus `SingleChildScrollView`, lalu `ConstrainedBox` dengan `maxWidth: 600` membatasi lebar agar formulir tetap nyaman dibaca di layar lebar seperti Chrome.

   Widget pengatur jarak (`Padding` dan `SizedBox`) memberi ruang antarinput supaya tidak menempel dan mudah disentuh. Namun jarak ini juga menambah tinggi total formulir. Karena itu widget penggulir (`SingleChildScrollView`) diperlukan: ketika ruang layar terbatas atau papan ketik tampil dan mengecilkan area yang tersedia, isi tidak terpotong (*overflow*), melainkan bisa digulir sehingga semua input dan tombol **Simpan** tetap dapat dijangkau. Pengaturan `keyboardDismissBehavior: onDrag` juga membuat papan ketik tertutup saat formulir digeser.

4. **Peran `GlobalKey<FormState>`, `validator`, dan `validate()`**

   - `GlobalKey<FormState>` adalah kunci yang dipasang pada widget `Form` agar kita bisa mengakses `FormState` dari luar `Form`, yaitu dari fungsi tombol **Simpan**, untuk memanggil `validate()`, `save()`, dan `reset()`.
   - `validator` adalah fungsi pada tiap field (misalnya `TextFormField`) yang menerima nilai input dan mengembalikan teks pesan kesalahan jika nilainya tidak valid, atau `null` jika valid.
   - `validate()` menjalankan seluruh `validator` di dalam `Form`, menampilkan pesan error pada kolom yang tidak valid, dan mengembalikan `true` hanya jika semua field valid. Pada proyek ini, hasil ringkasan baru ditampilkan setelah `validate()` bernilai `true` dan `save()` menyimpan nilai tiap field lewat `onSaved`.

## AI Disclosure
- Dalam pengerjaan tugas ini, saya menggunakan Claude (Anthropic) sebagai alat bantu untuk memahami instruksi Tugas 8, mempelajari konsep yang diperlukan, dan mencari referensi solusi teknis. AI membantu memberikan arahan dan kode, namun saya tetap menyesuaikan seluruh saran dengan struktur kode proyek `myportofolio_mobile` yang saya kerjakan di Tutorial 09.
- AI membantu memberikan penjelasan dan arahan untuk beberapa bagian, seperti formulir Add Education, validasi input, date picker, hasil ringkasan, navigasi, dan pengujian. Namun, saya tetap mengerjakan dan menyesuaikan implementasinya secara mandiri dengan memahami fungsi setiap bagian serta menyesuaikannya dengan struktur kode proyek.
- Saya memeriksa dan menguji hasil pengerjaan secara mandiri menggunakan `flutter analyze`, `flutter test`, dan `flutter run -d chrome`. Saya juga mencoba langsung alur navigasi, pengisian formulir, validasi, dan hasil ringkasan untuk memastikan seluruh fitur berjalan sesuai instruksi tugas, termasuk pada ukuran layar yang berbeda.
- Prompt yang saya gunakan:
"apa bedanya validate(), save(), dan reset() pada FormState, dan kenapa GlobalKey<FormState> dibutuhkan?"
"bagaimana cara kerja showDatePicker(), dan kenapa perlu mengecek mounted setelah await sebelum memanggil setState?"
"apa bedanya Navigator.push(), pushReplacement(), dan pop() terhadap tombol kembali, dengan contoh alur kartu ke formulir ke home?"
