# Praktikum Modul XIII

Nama: Radyt Guruh Handika  
NIM: 240605110117  
Mata kuliah: Mobile Programming Praktikum

## Menjalankan aplikasi

```powershell
cd flutter_crud_api
flutter pub get
flutter run
```

Target utama Android. Aplikasi memakai internet untuk permintaan ke JSONPlaceholder.
Font Montserrat dan Open Sans sudah dibundel beserta lisensi OFL agar tampilan tidak
bergantung pada pengunduhan font saat aplikasi berjalan.

## Alur sesuai modul

1. Tekan tombol `+`, isi Nama dan Pekerjaan, lalu Simpan.
2. `POST /posts` menerima sukses HTTP 201; respons ditampilkan di satu Card.
3. Buka menu tiga titik lalu Update. Dialog terisi data yang sedang aktif.
4. `PUT /posts/1` menerima sukses HTTP 200. Waktu pembuatan lokal dipertahankan.
5. Pilih Delete lalu Hapus untuk mengirim `DELETE /posts/{id aktif}`.
6. HTTP 200 menghapus Card dari state. Batal hanya menutup dialog.

JSONPlaceholder adalah API simulasi. POST, PUT, dan DELETE tidak menyimpan
perubahan secara permanen di server. POST biasanya mengembalikan ID 101;
contoh modul sengaja memakai ID 1 untuk update. Sesudah update, Card mengikuti
ID respons server. Read pada contoh ini adalah menampilkan respons di Card,
bukan mengambil daftar data dengan GET. State hilang saat proses aplikasi dimulai ulang.
`createdAt` dicatat oleh aplikasi, bukan berasal dari server. Label WIB memakai UTC+7.

## Pemeriksaan

```powershell
cd flutter_crud_api
flutter analyze
flutter test
flutter build apk --debug
```

Tes menggunakan `http.MockClient` untuk memeriksa kontrak HTTP, validasi respons,
alur CRUD, pembatalan hapus, input kosong, kegagalan update, serta request yang
belum selesai saat widget dilepas. Pengujian emulator dan screenshot menggunakan
aplikasi yang dijalankan dengan koneksi API sesungguhnya; lihat `docs/evidence/`.

## Berkas

- `flutter_crud_api/lib/main.dart`: model, komunikasi HTTP, state, dan UI.
- `flutter_crud_api/test/crud_test.dart`: pengujian otomatis.
- `docs/screenshots/`: screenshot hasil pengujian Android.
- `docs/`: laporan DOCX dan bukti verifikasi.
