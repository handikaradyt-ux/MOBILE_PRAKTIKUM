# Panduan video penjelasan source code DapurKost

## Gambaran aplikasi

DapurKost adalah aplikasi Flutter dengan tiga tampilan: Beranda, Katalog Resep, dan Detail Resep. Dua tampilan pertama dipilih melalui navigasi bawah; Detail dibuka dengan `Navigator.push` ketika kartu resep ditekan. Semua informasi berasal dari 12 objek pada `assets/data/recipes.json`. Data biaya dan durasi bersifat ilustratif. Aplikasi belum mengambil data dari server.

Alur data yang perlu dijelaskan dalam video:

```text
recipes.json → RecipeService → Recipe.fromJson → HomeScreen/CatalogScreen
                                               └→ DetailScreen (resep terpilih)
```

## Peta source code buatan sendiri

| File | Penjelasan singkat untuk video |
| --- | --- |
| `lib/main.dart` | Titik masuk aplikasi. Membuat satu `RecipeService`, memasangnya pada `DapurKostApp`, lalu membuka `MainScreen` dengan tema dari `AppTheme`. |
| `lib/models/recipe.dart` | Model satu resep: identitas, kategori dan tag, waktu, estimasi biaya, deskripsi, gambar, bahan, serta langkah. `fromJson` mengubah JSON menjadi objek; `toJson` melakukan kebalikannya. Getter memformat biaya/durasi; `matchesCategory` dan `matchesQuery` memeriksa kecocokan filter. |
| `lib/services/recipe_service.dart` | Membaca JSON lokal melalui `rootBundle`, mengubahnya menjadi daftar `Recipe`, dan menyimpannya dalam cache memori. Menyediakan resep unggulan, filter, pencarian berdasarkan ID, dan daftar kategori. Sumber data kelak dapat diganti dengan API di lapisan ini. |
| `lib/screens/main_screen.dart` | Menyimpan indeks tab Beranda/Katalog dalam `State`. `IndexedStack` mempertahankan keadaan tiap tab. `GlobalKey` dan callback sesudah frame mengirim kategori yang ditekan di Beranda ke Katalog. |
| `lib/screens/home_screen.dart` | Memuat resep unggulan, menampilkan pengantar, tiga kartu kategori, kartu resep pilihan, serta tips. Kartu resep membuka Detail; kartu kategori berpindah ke Katalog dengan filter aktif. |
| `lib/screens/catalog_screen.dart` | Menyimpan teks pencarian, kategori terpilih, dan daftar hasil. `_filterRecipes` menggabungkan syarat kategori dan kata kunci; `_applyFilter` memperbarui tampilan. Kartu resep membuka Detail dan kondisi tanpa hasil memakai `EmptyStateView`. |
| `lib/screens/detail_screen.dart` | Menerima objek `Recipe` dari halaman sebelumnya, lalu membangun gambar, informasi utama, daftar bahan, dan langkah sesuai resep tersebut. Tombol di kanan atas menyalin isi resep ke clipboard. Tombol “Mulai Memasak Sekarang” hanya menampilkan pesan, belum menjadi mode memasak khusus. |
| `lib/theme/app_theme.dart` | Menetapkan palet krem, oranye, hijau dan gaya AppBar, input, kartu, navigasi bawah, serta tombol agar tiga halaman konsisten. |
| `lib/widgets/category_chip.dart` | Komponen chip filter di Katalog dan kartu kategori di Beranda. Keduanya menerima callback sehingga ketukan pengguna mengubah halaman/filter. |
| `lib/widgets/recipe_card.dart` | Dua bentuk kartu berbasis data `Recipe`: kartu daftar Katalog dan kartu unggulan Beranda. Keduanya memanggil callback untuk membuka Detail. |
| `lib/widgets/empty_state.dart` | Pesan saat hasil pencarian kosong serta tombol untuk menghapus pencarian dan mengembalikan kategori ke “Semua”. |
| `test/recipe_model_test.dart` | Menguji parsing/serialisasi JSON, format biaya dan durasi, serta pencocokan kategori dan kata kunci. |
| `test/widget_test.dart` | Menguji tampilan awal, navigasi tab, pencarian/keadaan kosong, dan informasi/tombol pada halaman Detail memakai service tiruan. |
| `assets/data/recipes.json` | Dua belas data resep dummy. `id` unik, `tags` dapat berisi lebih dari satu kategori, dan `image` menunjuk ke gambar lokal di `assets/images/`. |
| `pubspec.yaml` | Nama proyek, batas versi Dart, dependensi Flutter, serta pendaftaran JSON dan folder gambar sebagai aset. |

Folder `android/`, `web/`, dan `windows/` sebagian besar berisi kerangka platform yang dibuat oleh Flutter. Dalam video cukup sebut bahwa folder ini diperlukan untuk menjalankan aplikasi pada platform masing-masing; fokus penjelasan logika ada pada `lib/`, data pada `assets/`, dan pengujian pada `test/`.

## Naskah video sekitar 5–7 menit

1. **Pembukaan (±30 detik).** “Saya membuat DapurKost, aplikasi katalog resep praktis untuk anak kos. Aplikasi mempunyai Beranda, Katalog, dan Detail. Data yang digunakan masih dummy dalam JSON lokal.” Tunjukkan tiga halaman secara singkat.
2. **Struktur proyek dan data (±60 detik).** Buka `pubspec.yaml`, tunjukkan aset yang didaftarkan. Buka `recipes.json`, tunjukkan satu resep beserta `id`, kategori, tag, biaya, bahan, dan langkah. Jelaskan bahwa 12 resep memakai struktur yang sama.
3. **Model dan service (±75 detik).** Buka `recipe.dart` dan jelaskan `fromJson`, `matchesCategory`, serta `matchesQuery`. Buka `recipe_service.dart`: `rootBundle.loadString` membaca JSON, `json.decode` mem-parsing data, `Recipe.fromJson` membangun objek, cache mencegah pembacaan berulang. Ini titik yang bisa diganti dengan API pada pengembangan berikutnya.
4. **Masuk aplikasi dan navigasi (±60 detik).** Buka `main.dart` lalu `main_screen.dart`. Tunjukkan `MaterialApp`, tema, `IndexedStack`, `BottomNavigationBar`, serta callback kategori dari Beranda ke Katalog. Jelaskan bahwa Detail merupakan route baru yang dibuka dengan `Navigator.push`.
5. **Tiga halaman dan widget (±90 detik).** Buka `home_screen.dart`, `catalog_screen.dart`, dan `detail_screen.dart`. Perlihatkan `Row`, `Column`, `ListView`, `Card`/kartu kustom, `SafeArea`, serta `SingleChildScrollView`. Jelaskan data resep yang sama dipakai di kartu dan Detail, bukan tulisan statis pada tiap halaman.
6. **Demo fitur (±90 detik).** Di aplikasi, tekan kategori “Hemat” dari Beranda; tunjukkan Katalog yang sudah terfilter. Pilih “Semua”, cari “mie”, lalu cari “pizza” untuk menunjukkan kondisi kosong dan tombol reset. Buka satu resep dari Katalog, tunjukkan bahan dan langkah, lalu tekan tombol salin resep dan tombol “Mulai Memasak Sekarang”. Kembali ke tab Beranda.
7. **Pengujian dan penutup (±30 detik).** Tunjukkan hasil `flutter analyze` dan `flutter test` hanya jika perintah tersebut benar-benar berhasil dijalankan di perangkatmu. Tutup dengan menyebut data masih lokal dan API merupakan rencana pengembangan berikutnya.

## Hal yang harus dijelaskan secara jujur

- “Hemat” adalah tag kurasi ramah kantong; beberapa resep bertag ini lebih dari Rp 10.000. Lihat nominal masing-masing pada kartu/detail.
- “Tanpa Kompor” berarti tidak memakai kompor gas; beberapa resep memakai rice cooker, toaster, atau bahan yang sudah dimasak sebelumnya.
- Tombol salin menyalin teks resep, **bukan** tautan internet.
- Tombol “Mulai Memasak Sekarang” memberi umpan balik melalui `SnackBar`; belum ada timer atau panduan langkah interaktif.
- `RecipeService` mengembalikan daftar kosong jika pembacaan JSON gagal. Saat merekam, pastikan aset terpasang dan 12 resep tampil.
- Screenshot pada laporan berada di `UTS/screenshots`, sedangkan rancangan awal berada di `UTS/design`; kedua folder tersebut berada di luar folder proyek yang diminta untuk diunggah ke GitHub.
