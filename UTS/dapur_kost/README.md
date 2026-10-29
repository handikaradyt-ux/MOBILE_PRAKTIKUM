# 🍳 DapurKost — Aplikasi Resep Masak Praktis Anak Kos

> **Tugas Ujian Tengah Semester (UTS) — Pemrograman Mobile (Mobile Programming)**
> Semester Ganjil 2025/2026 | Framework: Flutter 3.47+ (Dart 3.13+)

---

## 📌 1. Tema & Latar Belakang

**DapurKost** adalah aplikasi mobile inovatif yang dirancang khusus untuk memecahkan dilema harian mahasiswa atau anak kos: *"Mau masak apa hari ini yang murah, cepat, dan bahannya ada di kosan?"*.

Banyak anak kos terjebak dalam pola konsumsi makanan luar yang boros, atau kesulitan memasak karena keterbatasan peralatan (hanya memiliki rice cooker/dispenser tanpa kompor gas). **DapurKost** menyajikan 12 contoh resep masakan rumahan sederhana dengan estimasi biaya hingga Rp 15.000 dan waktu memasak hingga 20 menit. Biaya dan durasi adalah data ilustratif.

---

## 🎯 2. Tujuan Aplikasi

1. **Efisiensi Anggaran Kos**: Menyediakan contoh menu makanan ramah kantong dengan estimasi biaya ilustratif (Rp 7.000 – Rp 15.000).
2. **Efisiensi Waktu**: Membantu pengguna memilih hidangan berdasarkan kecepatan memasak (5 – 20 menit).
3. **Fleksibilitas Alat**: Menyediakan kategori khusus *Tanpa Kompor* untuk kosan dengan fasilitas minim (cukup rice cooker atau tanpa pemanas).
4. **Pengalaman Pengguna Bersih & Interaktif**: Menerapkan arsitektur UI/UX yang intuitif, pencarian cepat, filter instan, dan navigasi mulus.

---

## 📱 3. Struktur Halaman & Fitur Utama

Aplikasi memiliki minimal 3 halaman utama yang terhubung erat melalui navigasi terpadu:

### A. Halaman Beranda (`HomeScreen`)
* **Header Identitas**: Sapaan personal (*"Halo, Mahasiswa Kos! 👋"*) dan logo branding *DapurKost*.
* **Hero Banner**: Kartu pengantar bertema hangat dengan nilai proposisi aplikasi.
* **Pilihan Kategori Cepat**:
  * 💰 **Hemat**: Menu masakan yang diberi tag ramah kantong; estimasi biaya tiap menu terlihat pada kartu dan halaman detail.
  * ⚡ **Cepat**: Menu masakan kilat siap santap dalam waktu $\le$ 15 menit.
  * 🔌 **Tanpa Kompor**: Menu aman tanpa kompor gas (berbasis rice cooker / salad / sarapan dingin).
  * *Interaksi*: Mengetuk salah satu kartu kategori akan langsung mengalihkan tab ke **Katalog Resep** dengan filter kategori tersebut otomatis aktif.
* **Resep Pilihan Hari Ini (Featured)**: Kartu showcase visual resep unggulan (*isFeatured: true*) dengan metrik durasi dan biaya.
* **Tips Dapur Kos**: Kotak wawasan praktis (*life hacks*) memasak hemat untuk mahasiswa.

### B. Halaman Katalog Resep (`CatalogScreen`)
* **Kolom Pencarian Real-Time (`TextField`)**: Pengguna dapat mencari resep berdasarkan nama atau bahan (misal: "mie", "telur", "nasi"). Hasil langsung terfilter saat pengguna mengetik.
* **Baris Tombol Filter Kategori (Pill Chips)**: Pilihan kategori *Semua*, *Hemat*, *Cepat*, dan *Tanpa Kompor*.
* **Indikator Jumlah Hasil**: Badge dinamis yang menampilkan total resep yang cocok (*"X Resep"*).
* **Daftar Kartu Resep (`RecipeCatalogCard`)**: Menampilkan thumbnail ilustrasi, badge tag, nama resep, durasi masak, dan estimasi biaya. Mengetuk kartu akan membuka halaman Detail Resep.
* **Kondisi Kosong (`EmptyStateView`)**: Bila pencarian tidak menemukan resep yang cocok (misalnya mencari "pizza"), aplikasi menampilkan ikon ilustrasi, pesan informatif, dan tombol **"Reset Pencarian & Filter"** yang dapat diklik untuk mengembalikan daftar ke kondisi awal.

### C. Halaman Detail Resep (`DetailScreen`)
* **Konten Dinamis**: Menampilkan data spesifik dari resep yang dipilih pengguna (bukan template statis).
* **Ilustrasi Hero & Tag Kategori**: Gambar representatif resep dengan badge kategori dan porsi.
* **3 Metrik Utama (Metric Cards)**:
  * ⏱️ **Durasi Memasak** (contoh: 15 Menit)
  * 💵 **Estimasi Biaya** (contoh: Rp 12.000)
  * 🍳 **Tingkat Kesulitan** (contoh: Mudah / Sangat Mudah)
* **Daftar Bahan Lengkap**: Disajikan dengan ikon checklist hijau untuk memudahkan persiapan belanja.
* **Langkah Memasak Bernomor**: Instruksi langkah demi langkah dengan nomor urut yang terstruktur dan mudah diikuti.
* **Tombol Interaktif "Mulai Memasak Sekarang"**: Menampilkan umpan balik visual SnackBar responsif.
* **Navigasi Kembali**: Tombol kembali pada AppBar yang memanggil `Navigator.pop(context)` secara mulus.

---

## 🗄️ 4. Struktur Data & Desain Arsitektur

Data aplikasi disimpan dalam berkas lokal `assets/data/recipes.json` yang memuat 12 resep lengkap.

### Model `Recipe` (`lib/models/recipe.dart`)
Setiap objek resep memiliki atribut:
```dart
class Recipe {
  final String id;
  final String name;
  final String category;
  final List<String> tags;
  final int durationMinutes;
  final int estimatedCost;
  final String difficulty;
  final String portion;
  final String description;
  final String image;
  final bool isFeatured;
  final List<String> ingredients;
  final List<String> steps;
  // Factory fromJson, toJson, formattedCost, formattedDuration, matchesCategory, matchesQuery
}
```

### Abstraksi Data Layer (`lib/services/recipe_service.dart`)
Lapisan service memisahkan logika pengambilan data dari lapisan tampilan (UI):
* `getAllRecipes()`: Memuat JSON lokal dengan in-memory caching.
* `getFeaturedRecipes()`: Menyaring resep unggulan untuk Beranda.
* `filterRecipes()`: Logika pencarian dan penyaringan multi-kriteria.
* **Kesiapan API**: Struktur ini dirancang agar saat beralih ke remote REST API (misal `http.get('https://api.dapurkost.com/recipes')`), cukup memperbarui metode pada `RecipeService` tanpa perlu merombak kode halaman UI.

---

## 🎨 5. Skema Warna & Desain UI

* **Krem Lembut (`#FDFBF7` / `#FAF7F2`)**: Latar belakang aplikasi yang hangat, bersih, dan nyaman di mata.
* **Oranye Hangat (`#E05A2B` / `#FF7A45`)**: Aksen primer yang membangkitkan selera makan, antusiasme, dan kehangatan masakan rumahan.
* **Hijau Tua Segar (`#1B4D3E` / `#2C6B57`)**: Aksen sekunder yang mencerminkan kesegaran bahan sayuran, kesehatan, dan kestabilan.
* **Surface Putih (`#FFFFFF`)**: Kartu konten dengan border tipis teratur dan elevasi bayangan halus.

---

## 📂 6. Struktur Direktori Proyek

```text
dapur_kost/
├── assets/
│   ├── data/
│   │   └── recipes.json             # 12 Dataset resep JSON
│   └── images/                      # 12 Gambar ilustrasi visual hidangan
│       ├── nasi_gila.png
│       ├── omelet_mie.png
│       ├── salad_telur.png
│       └── ...
├── lib/
│   ├── main.dart                    # Entry point aplikasi & inisialisasi service
│   ├── models/
│   │   └── recipe.dart              # Model Recipe & parser JSON
│   ├── services/
│   │   └── recipe_service.dart      # Lapisan repository & filtering data
│   ├── theme/
│   │   └── app_theme.dart           # Konfigurasi warna, tipografi, dan tema Material 3
│   ├── screens/
│   │   ├── main_screen.dart         # Kontainer BottomNavigationBar & router antar tab
│   │   ├── home_screen.dart         # Halaman Beranda (Home)
│   │   ├── catalog_screen.dart      # Halaman Katalog & Pencarian Resep
│   │   └── detail_screen.dart       # Halaman Detail Resep interaktif
│   └── widgets/
│       ├── category_chip.dart       # Widget chip & kartu kategori
│       ├── recipe_card.dart         # Widget kartu resep (Catalog & Featured)
│       └── empty_state.dart         # Widget kondisi kosong (Empty State)
├── test/
│   ├── recipe_model_test.dart       # Unit testing model JSON & formatting
│   └── widget_test.dart             # Widget testing navigasi, search, & detail
└── pubspec.yaml                     # Konfigurasi dependensi dan aset Flutter
```

---

## 🚀 7. Langkah Menjalankan Aplikasi

### Prasyarat
* Flutter SDK versi 3.24+ (atau versi 3.47+)
* Dart SDK versi 3.5+ (atau versi 3.13+)
* Google Chrome, Microsoft Edge, Windows Desktop, atau Android Emulator.

### Langkah Instalasi & Menjalankan
1. **Buka terminal** di dalam direktori proyek `dapur_kost`:
   ```bash
   cd "C:\SEMESTER 5\MOBILE PROGRAMMING PRAK\UTS\dapur_kost"
   ```
2. **Unduh dependensi**:
   ```bash
   flutter pub get
   ```
3. **Verifikasi kualitas kode**:
   ```bash
   dart format --output=none --set-exit-if-changed .
   flutter analyze
   flutter test
   ```
4. **Jalankan aplikasi**:
   * *Di Chrome (Web Preview)*:
     ```bash
     flutter run -d chrome
     ```
   * *Di Windows Desktop*:
     ```bash
     flutter run -d windows
     ```
   * *Di Android Emulator / Perangkat*:
     ```bash
     flutter run
     ```

---

## 🧪 8. Hasil Pengujian Otomatis

Seluruh 10 skenario pengujian unit dan pengujian widget telah terverifikasi sukses:
* ✅ `Recipe.fromJson` validasi parsing JSON.
* ✅ `Recipe.toJson` serialisasi Map.
* ✅ `formattedCost` pemformatan mata uang Rupiah.
* ✅ `formattedDuration` pemformatan durasi menit.
* ✅ `matchesCategory` filter multi-kategori dan tags.
* ✅ `matchesQuery` pencarian teks case-insensitive.
* ✅ `DapurKostApp` inisialisasi widget root & BottomNavigationBar.
* ✅ Navigasi antar tab Beranda dan Katalog Resep.
* ✅ Penyaringan resep dan aktivasi tampilan *Empty State*.
* ✅ Penyajian data dinamis dan interaksi tombol aksi pada Halaman Detail.
