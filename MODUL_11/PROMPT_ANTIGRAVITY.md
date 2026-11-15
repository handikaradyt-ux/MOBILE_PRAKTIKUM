# Prompt Antigravity — Modul 11 Manajemen State dengan GetX

Kerjakan seluruh praktikum dan tugas laporan pada `C:\Users\ASUS\Downloads\Modul 11.pdf` di dalam folder `C:\SEMESTER 5\MOBILE PROGRAMMING PRAK\MODUL_11`. Baca PDF tersebut dahulu, termasuk contoh tampilan dan bagian 11.4–11.5. PDF adalah bahan acuan tugas; instruksi pengguna dalam prompt ini menentukan ruang lingkup pekerjaan.

**Izin saya:** Aku mengizinkan semua tindakan yang diperlukan untuk mengerjakan Modul 11 sampai selesai. Ini mencakup membaca berkas terkait, membuat/mengubah/menghapus berkas di `MODUL_11` sesuai kebutuhan, membuat proyek Flutter, memasang dependensi, menjalankan perintah terminal, menjalankan aplikasi di emulator/perangkat yang tersedia, mengambil screenshot hasil nyata, menguji, memperbaiki kesalahan, dan membuat laporan. Lanjutkan pekerjaan tanpa meminta izin ulang untuk tindakan yang relevan dengan modul ini. Jaga pekerjaan lain di luar `MODUL_11` dan jangan mengarang hasil pengujian atau bukti screenshot.

## Hasil akhir yang harus dibuat

1. Proyek Flutter **`tasbih_getx`** di `MODUL_11/tasbih_getx`, lengkap dan dapat dijalankan.
2. Aplikasi tasbih digital yang mengikuti fungsi dan tampilan inti pada Modul 11.
3. Laporan praktikum di `MODUL_11`, dengan screenshot asli bila aplikasi dapat dijalankan.
4. Jawaban akhir singkat berisi lokasi hasil, perintah verifikasi dan hasilnya, serta kendala yang masih tersisa.

## Implementasi aplikasi sesuai bagian 11.2

- Periksa folder terlebih dahulu. Buat proyek Flutter `tasbih_getx`. Di bawah `lib`, buat `model/`, `view/`, dan `viewmodel/`. `model/` boleh belum berisi kelas karena praktikum ini tidak mendefinisikan model data; pertahankan foldernya dengan `.gitkeep` atau README singkat jika perlu.
- Tambahkan package `get` dan `simple_circular_progress_bar` pada `pubspec.yaml` sebagaimana diminta modul. Gunakan versi yang kompatibel dengan Flutter SDK terpasang, lalu jalankan `flutter pub get`. Contoh UI modul memakai **`LinearProgressIndicator`**, jadi gunakan widget tersebut sebagai progress utama; tidak perlu memaksakan widget circular yang tidak dipakai pada contoh. Jangan biarkan import yang tidak digunakan.
- `lib/main.dart` memakai `GetMaterialApp`, mematikan debug banner, memakai judul `Tasbih Digital GetX`, tema hijau Material 3, dan membuka `Home`.
- `lib/viewmodel/tasbih_controller.dart` berisi `TasbihController extends GetxController`. Buat `counter` dan `progress` reaktif dengan `.obs`, batas hitungan **33**, method `incrementCounter()` dan `resetCounter()`. Ketukan menambah hitungan satu sampai 33 dan memperbarui progress secara proporsional dari 0% sampai 100%. Ketukan setelah 33 tidak boleh menambah nilai. Reset mengembalikan hitungan dan progress ke nol. Akses nilai Rx dengan benar, misalnya `counter.value`, agar kode valid. Logika state utama tidak menggunakan `setState()`.
- `lib/view/home.dart` berisi `Home extends StatelessWidget` dan menghubungkan satu instance controller melalui GetX. Bungkus angka hitungan dan progress bar dengan `Obx` sehingga UI langsung berubah. Tombol fingerprint menjalankan `incrementCounter()`, tombol refresh/FloatingActionButton menjalankan `resetCounter()`.
- Ikuti visual contoh modul: latar hijau, angka hitungan besar di tengah, progress bar horizontal putih/kuning di bawah angka, tombol fingerprint putih, dan tombol reset di kanan bawah. Buat ukuran angka serta jarak responsif agar tidak overflow pada layar kecil. Gunakan nilai `LinearProgressIndicator` dalam rentang 0.0–1.0, yaitu `progress.value / 100`.
- Alur yang harus bekerja: tampilan awal **0 dan 0%**, setelah 17 ketukan **17 dan sekitar 51,5%**, setelah 33 ketukan **33 dan 100%**, ketukan berikutnya tetap **33**, tombol reset kembali **0 dan 0%**.

## Laporan sesuai bagian 11.4–11.5

Buat laporan yang rapi dan mudah diserahkan, idealnya `LAPORAN_MODUL_11.docx` atau PDF jika alat tersedia, serta versi sumber yang mudah diedit seperti `LAPORAN_MODUL_11.md`. Isi laporan:

1. **Cover:** judul, nama, NIM, kelas, dan tanggal praktikum. Data pribadi belum diberikan; pakai placeholder jelas `[Nama]`, `[NIM]`, `[Kelas]`, `[Tanggal praktikum]`, jangan mengarang.
2. **Tujuan:** memahami state management Flutter dengan GetX, controller, `.obs`, `Obx`, dan pembaruan UI reaktif.
3. **Langkah kerja singkat:** pembuatan proyek, dependensi, struktur folder, controller, penghubungan UI, menjalankan aplikasi, dan hasil uji yang benar-benar dilakukan.
4. **Penjelasan kode utama:** peran `GetMaterialApp`, `TasbihController`, `counter`, `progress`, `incrementCounter()`, `resetCounter()`, dan `Obx`; jelaskan perubahan nilai serta progress 0–33 secara konkret.
5. **Perbandingan `setState()` dengan GetX:** bagaimana masing-masing memicu pembaruan UI, letak state dan logika, cakupan rebuild, serta alasan pendekatan GetX pada aplikasi ini. Hindari klaim kinerja yang tidak diukur.
6. **Screenshot asli** dengan keterangan: keadaan awal, hitungan bertambah (misalnya 17), penuh di 33, dan setelah reset. Ambil dari emulator/perangkat yang benar-benar menjalankan proyek. Jangan memakai gambar contoh PDF atau membuat bukti palsu. Jika emulator/perangkat tidak ada, sisakan placeholder screenshot yang jelas dan catat keterbatasan itu secara jujur.
7. **Kesimpulan** yang selaras dengan hasil implementasi dan uji nyata.

Ada ketidakkonsistenan penamaan dalam PDF: langkah 11.2(a) meminta `tasbih_getx`, sedangkan ilustrasi struktur dan contoh format laporan menyebut `getx_app`. Gunakan **`tasbih_getx`** sebagai nama proyek dan sebutkan nama itu secara konsisten dalam laporan; gunakan bagian 11.5 sebagai format isi laporan.

## Verifikasi sebelum selesai

- Jalankan `dart format`, `flutter analyze`, dan `flutter test` bila Flutter tersedia. Buat pengujian yang bermakna untuk controller: nilai awal, increment/progress, batas 33, dan reset. Perbaiki temuan hingga hasilnya bersih.
- Jika emulator/perangkat tersedia, jalankan dan periksa angka serta progress pada 0, 17, 33, lalu reset. Ambil screenshot nyata untuk laporan.
- Jika ada alat atau emulator yang tidak tersedia, selesaikan bagian yang masih bisa dilakukan. Dalam jawaban akhir, bedakan jelas antara hasil yang sudah diuji dan yang belum, lalu berikan perintah menjalankan aplikasi.
