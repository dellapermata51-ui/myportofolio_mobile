# MyPortfolio Mobile - Della Permata Prasilda - 2506656614 - A

[![CI](https://github.com/<USERNAME>/<REPO>/actions/workflows/main.yaml/badge.svg)](https://github.com/<USERNAME>/<REPO>/actions/workflows/main.yaml)

## Setup
Backend: repositori Django `myportofolio` (https://github.com/dellapermata51-ui/myportofolio) yang sudah di-deploy di https://della-permata51-myportofolio.pws.cs.ui.ac.id. 

1. Pasang dependency dan hasilkan kode JSON (`*.g.dart` tidak ikut di-commit karena ada di `.gitignore`):
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```
2. Jalankan backend lokal (opsional): `pip install -r requirements.txt`, `python manage.py migrate`, `python manage.py createsuperuser`, lalu `python manage.py runserver`.
3. Jalankan aplikasi dengan `API_BASE_URL` yang sesuai:
   ```bash
   # Emulator Android (default: http://10.0.2.2:8000)
   flutter run

   # Chrome terhadap server lokal
   flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000

   # Terhadap backend yang sudah di-deploy
   flutter run --dart-define=API_BASE_URL=https://della-permata51-myportofolio.pws.cs.ui.ac.id
   ```
4. Login memakai akun **superuser** Django. Membaca daftar Education bersifat publik, tetapi menambah Education (`POST`) hanya diizinkan untuk pemilik portofolio; akun biasa akan menerima `403`.
5. Pemeriksaan kualitas yang sama dengan CI: `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, dan `flutter test`.
6. Agar artefak APK di CI memakai backend yang benar, isi variabel repositori GitHub `API_BASE_URL` (Settings → Secrets and variables → Actions → Variables).

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
   Untuk membuka formulir dari kartu aksi, proyek ini memakai Navigator.push() (di ItemCard), sehingga halaman utama tetap berada di bawah formulir dan pengguna bisa kembali dengan tombol kembali. Opsi Home di LeftDrawer memakai Navigator.pushReplacement() ke MyHomePage, halaman formulir yang sedang tampil diganti dengan halaman utama, sehingga pengguna langsung sampai di halaman utama.

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
   Contoh nilai yang ditolak: nama institusi " " (hanya spasi, kosong setelah trim()) atau "UI" (kurang dari 3 karakter). Tanggal selesai juga bisa ditolak: pengguna memilih tanggal selesai lebih dulu, lalu menggeser tanggal mulai ke tanggal setelahnya. Jenis input atau papan ketik hanya mengatur tampilan dan cara mengetik, bukan kebenaran isinya. Pengguna tetap bisa mengetik spasi atau memilih kombinasi tanggal yang tidak masuk akal. Hanya validator yang memeriksa aturan tersebut saat validate() dipanggil.

## AI Disclosure
- Dalam pengerjaan tugas ini, saya menggunakan Claude (Anthropic) sebagai alat bantu untuk memahami instruksi Tugas 8, mempelajari konsep yang diperlukan, dan mencari referensi solusi teknis. AI membantu memberikan arahan dan kode, namun saya tetap menyesuaikan seluruh saran dengan struktur kode proyek `myportofolio_mobile` yang saya kerjakan di Tutorial 09.
- AI membantu memberikan penjelasan dan arahan untuk beberapa bagian, seperti formulir Add Education, validasi input, date picker, hasil ringkasan, navigasi, dan pengujian. Namun, saya tetap mengerjakan dan menyesuaikan implementasinya secara mandiri dengan memahami fungsi setiap bagian serta menyesuaikannya dengan struktur kode proyek.
- Saya memeriksa dan menguji hasil pengerjaan secara mandiri menggunakan `flutter analyze`, `flutter test`, dan `flutter run -d chrome`. Saya juga mencoba langsung alur navigasi, pengisian formulir, validasi, dan hasil ringkasan untuk memastikan seluruh fitur berjalan sesuai instruksi tugas, termasuk pada ukuran layar yang berbeda.
- Prompt yang saya gunakan:
"apa bedanya validate(), save(), dan reset() pada FormState, dan kenapa GlobalKey<FormState> dibutuhkan?"
"bagaimana cara kerja showDatePicker(), dan kenapa perlu mengecek mounted setelah await sebelum memanggil setState?"
"apa bedanya Navigator.push(), pushReplacement(), dan pop() terhadap tombol kembali, dengan contoh alur kartu ke formulir ke home?"

# Tugas 9
## Deskripsi Proyek
Aplikasi kini terintegrasi dengan backend Django REST Framework untuk fitur **Education**. Pengguna dapat melihat daftar dan detail Education secara publik, sedangkan penambahan data Education memerlukan login dan autentikasi menggunakan token. Daftar Education ditampilkan dengan fitur *loading, error, dan empty state*, serta dapat diperbarui melalui tombol **Retry** atau dengan menarik layar ke bawah (*pull-to-refresh*). Pengguna juga dapat membuka detail Education untuk melihat informasi lengkapnya. Formulir **Add Education** dari Tugas 8 kini terhubung ke API, sehingga data yang diisi akan dikirim ke server setelah validasi dan autentikasi berhasil. Jika login sudah tidak valid, aplikasi akan meminta pengguna login kembali, sedangkan error lain ditampilkan melalui `SnackBar`. Selain itu, ditambahkan pengujian otomatis untuk API, `model`, `daftar`, `detail`, dan `formulir`, serta **CI/CD** menggunakan **GitHub Actions** untuk memeriksa kode dan membangun APK *release* secara otomatis.

## Pertanyaan Reflektif
### Assignment 9
1. **Mengapa kita menggunakan `@JsonSerializable(fieldRename: FieldRename.snake)` dan `@JsonKey(includeToJson: false)` alih-alih mengirim objek `Map<String, dynamic>` mentah langsung dari widget? Jelaskan satu bug yang dicegah atau dapat dicegah oleh pendekatan ini pada model bagianmu.**

   `@JsonSerializable(fieldRename: FieldRename.snake)` membantu mengubah nama variabel Dart menjadi format yang sesuai dengan API, misalnya `startedAt` menjadi `started_at`. Dengan model `Education`, proses mengubah data JSON menjadi objek Dart dan sebaliknya dilakukan secara otomatis, sehingga kode lebih rapi dan mengurangi kesalahan penulisan key atau tipe data.

   `@JsonKey(includeToJson: false)` digunakan untuk field yang berasal dari server, seperti `id`, `star_count`, dan `is_starred`, agar tidak ikut dikirim ketika membuat Education baru. Berbeda dengan `Map<String, dynamic>` yang key dan tipe datanya harus diatur secara manual, penggunaan model membuat struktur data lebih konsisten dan kesalahan lebih mudah diketahui.

   Contohnya, API menggunakan nama field `program`, bukan `field_of_study`. Jika menggunakan `Map` dengan nama key yang salah, data bidang studi bisa tidak tersimpan tanpa disadari. Dengan model Education, nama field yang digunakan lebih terarah dan sesuai dengan struktur API.

2. **Mengapa Future yang diteruskan ke `FutureBuilder` harus diinisialisasi di dalam `initState()` alih-alih langsung di dalam `build()`, dan mengapa `ApiClient` sebaiknya melempar `ApiException` daripada mengembalikan `null` pada respons HTTP non-2xx?**

   `build()` bisa dipanggil berkali-kali, misalnya saat keyboard atau orientasi layar berubah, tema berubah, atau `setState()` dipanggil. Jika `getEducations()` dipanggil langsung di `build()`, setiap rebuild membuat `Future` baru sehingga `FutureBuilder` kembali ke status loading, request jaringan dikirim berulang, dan layar berkedip. Dengan membuat `Future` sekali di `initState()` dan menggantinya hanya saat Retry atau tarik-untuk-segarkan (`_reload`), request hanya terjadi saat memang diperlukan.

   `ApiClient` melempar `ApiException` (berisi `statusCode`) karena `null` tidak bisa membedakan penyebab kegagalan: daftar kosong, `401` (token tidak valid), `403` (tidak punya izin), `400` (data tidak valid), atau `500`. Penanganan yang berbeda hanya mungkin jika status kodenya sampai ke UI, misalnya `401` menghapus sesi lalu membuka login, `403` menampilkan pesan izin, dan error dari `FutureBuilder` menampilkan tombol Retry. Mengembalikan `null` juga membuat kegagalan mudah terlewat dan baru muncul sebagai error `Null check operator` atau tampilan kosong di tempat lain.

3. **Bandingkan `SessionAuthentication` milik Django (dari Tutorial 04/07) dengan `TokenAuthentication` milik DRF (dari Tutorial 10). Mengapa `myportfolio_mobile` menggunakan `TokenAuthentication` sementara `SessionAuthentication` tetap diaktifkan pada backend Django?**

   `SessionAuthentication` menggunakan `sessionId` dan cookie yang biasanya disimpan oleh browser. Untuk request yang mengubah data, autentikasi ini membutuhkan CSRF token sebagai perlindungan tambahan. Sementara itu, `TokenAuthentication `menggunakan token yang dikirim melalui header Authorization, sehingga klien harus menyertakan token pada request yang membutuhkan autentikasi.

   Pada aplikasi Flutter, `TokenAuthentication` lebih sesuai karena aplikasi mobile tidak bergantung pada `sessionId` dan cookie seperti browser. Token disimpan di `AuthState` dan digunakan saat mengirim request, misalnya untuk menambahkan Education. `SessionAuthentication` tetap digunakan karena website Django masih membutuhkan session untuk proses login dan request dari browser. Jadi, keduanya tetap aktif karena digunakan oleh klien yang berbeda.

4. **Jelaskan peran job `build` (`very_good_workflows`) dan `build_apk` dalam pipeline `.github/workflows/main.yaml` milikmu (termasuk pemeriksaan apa saja yang dijalankan `very_good_workflows` di balik layar). Mengapa berkas `*.g.dart` dimasukkan ke `.gitignore` meskipun CI membutuhkannya untuk menganalisis dan membangun aplikasi?**

   Job `build` pada **GitHub Actions** berfungsi untuk memeriksa kualitas kode, mulai dari mengunduh dependency, menjalankan `build_runner`, memeriksa format kode, menjalankan `flutter analyze`, hingga menjalankan test dan mengecek coverage. Jika semua proses berhasil, job `build_apk` akan dijalankan untuk membuat APK release yang dapat diunduh sebagai artefak.

   File `*.g.dart` dimasukkan ke `.gitignore` karena merupakan file hasil generate yang dapat dibuat kembali menggunakan `build_runner`. Dengan tidak memasukkannya ke Git, repository menjadi lebih rapi dan mengurangi risiko file hasil generate yang sudah tidak sesuai dengan model terbaru. CI tetap dapat berjalan karena file tersebut dibuat ulang sebelum proses **analisis, testing, maupun build APK dilakukan.**

## AI Disclosure
- Dalam pengerjaan tugas ini, saya menggunakan Claude (Anthropic) sebagai alat bantu untuk memahami instruksi Tugas 9, membaca struktur backend Django, serta menyusun kode integrasi Education di proyek `myportofolio_mobile` yang sudah memiliki pola dari Tutorial 10.
- AI membantu memberikan arahan pengerjaan secara bertahap, mulai dari memahami `model`, `serializer`, dan `permission` pada backend, hingga mengimplementasikan API, halaman daftar dan detail Education, autentikasi, formulir, serta pengujian otomatis. Saya juga menggunakan AI untuk membantu memahami konsep.
- Saya menyesuaikan kode dan saran yang diberikan AI dengan struktur proyek, serta memeriksa kembali fungsi setiap bagian. Saya juga menjalankan pengujian secara mandiri untuk memastikan fitur berjalan sesuai instruksi tugas, termasuk alur login, melihat daftar Education, menambahkan data, dan menangani error autentikasi.
- Prompt yang saya gunakan:
"di ApiClient.createEducation(), kenapa bodynya jsonEncode(education.toJson()) dan kenapa header Authorization memakai format Token <key>?"
"kenapa Future untuk FutureBuilder harus dibuat di initState(), bukan di build()?"
"kenapa pumpAndSettle bisa timeout kalau ada CircularProgressIndicator yang masih tampil?"
