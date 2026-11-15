import os
import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement
from docx.oxml.ns import qn

def create_report():
    doc = Document()

    # Margin 1 inch (2.54 cm)
    for section in doc.sections:
        section.top_margin = Inches(1.0)
        section.bottom_margin = Inches(1.0)
        section.left_margin = Inches(1.0)
        section.right_margin = Inches(1.0)

    # Palette
    C_PRIMARY = RGBColor(27, 94, 32)      # Deep Green #1B5E20
    C_SECONDARY = RGBColor(46, 125, 50)  # Forest Green #2E7D32
    C_DARK = RGBColor(33, 33, 33)         # Dark Body
    C_MUTED = RGBColor(117, 117, 117)     # Gray Caption

    # Default Font
    normal_style = doc.styles['Normal']
    normal_style.font.name = 'Calibri'
    normal_style.font.size = Pt(11)
    normal_style.font.color.rgb = C_DARK

    def set_cell_background(cell, fill_hex):
        tcPr = cell._tc.get_or_add_tcPr()
        shd = OxmlElement('w:shd')
        shd.set(qn('w:val'), 'clear')
        shd.set(qn('w:color'), 'auto')
        shd.set(qn('w:fill'), fill_hex)
        tcPr.append(shd)

    def set_cell_margins(cell, top=100, bottom=100, left=150, right=150):
        tcPr = cell._tc.get_or_add_tcPr()
        tcMar = OxmlElement('w:tcMar')
        for m, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
            node = OxmlElement(f'w:{m}')
            node.set(qn('w:w'), str(val))
            node.set(qn('w:type'), 'dxa')
            tcMar.append(node)
        tcPr.append(tcMar)

    def set_table_borders(table, color="D0D7D3"):
        tblPr = table._tbl.tblPr
        tblBorders = OxmlElement('w:tblBorders')
        for b_name in ['top', 'left', 'bottom', 'right', 'insideH']:
            b = OxmlElement(f'w:{b_name}')
            b.set(qn('w:val'), 'single')
            b.set(qn('w:sz'), '4')
            b.set(qn('w:space'), '0')
            b.set(qn('w:color'), color)
            tblBorders.append(b)
        b_v = OxmlElement('w:insideV')
        b_v.set(qn('w:val'), 'none')
        tblBorders.append(b_v)
        tblPr.append(tblBorders)

    def add_h1(text):
        h = doc.add_paragraph()
        h.paragraph_format.space_before = Pt(16)
        h.paragraph_format.space_after = Pt(6)
        h.paragraph_format.keep_with_next = True
        run = h.add_run(text)
        run.bold = True
        run.font.size = Pt(15)
        run.font.color.rgb = C_PRIMARY
        return h

    def add_h2(text):
        h = doc.add_paragraph()
        h.paragraph_format.space_before = Pt(12)
        h.paragraph_format.space_after = Pt(4)
        h.paragraph_format.keep_with_next = True
        run = h.add_run(text)
        run.bold = True
        run.font.size = Pt(12.5)
        run.font.color.rgb = C_SECONDARY
        return h

    def add_p(text, bold_prefix=None, space_after=5):
        p = doc.add_paragraph()
        p.paragraph_format.space_after = Pt(space_after)
        p.paragraph_format.line_spacing = 1.15
        if bold_prefix:
            r_b = p.add_run(bold_prefix)
            r_b.bold = True
            r_b.font.color.rgb = C_DARK
        r = p.add_run(text)
        r.font.color.rgb = C_DARK
        return p

    def add_bullet(text, bold_prefix=None):
        p = doc.add_paragraph(style='List Bullet')
        p.paragraph_format.space_after = Pt(3)
        p.paragraph_format.line_spacing = 1.15
        if bold_prefix:
            r_b = p.add_run(bold_prefix)
            r_b.bold = True
            r_b.font.color.rgb = C_DARK
        r = p.add_run(text)
        r.font.color.rgb = C_DARK
        return p

    def add_code_block(code_text):
        tbl = doc.add_table(rows=1, cols=1)
        tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
        cell = tbl.cell(0, 0)
        cell.width = Inches(6.5)
        set_cell_background(cell, 'F4F6F4')
        set_cell_margins(cell, top=120, bottom=120, left=180, right=180)
        
        tcPr = cell._tc.get_or_add_tcPr()
        tcBorders = OxmlElement('w:tcBorders')
        for b_name in ['top', 'left', 'bottom', 'right']:
            b = OxmlElement(f'w:{b_name}')
            b.set(qn('w:val'), 'single')
            b.set(qn('w:sz'), '4')
            b.set(qn('w:space'), '0')
            b.set(qn('w:color'), 'C5D4C7')
            tcBorders.append(b)
        tcPr.append(tcBorders)

        p = cell.paragraphs[0]
        p.paragraph_format.space_before = Pt(2)
        p.paragraph_format.space_after = Pt(2)
        p.paragraph_format.line_spacing = 1.05
        run = p.add_run(code_text.strip())
        run.font.name = 'Consolas'
        run.font.size = Pt(9.0)
        run.font.color.rgb = RGBColor(35, 35, 35)

    def add_image_with_caption(img_path, caption_text, width_inch=2.3):
        if not os.path.exists(img_path):
            add_p(f"[Gambar tidak ditemukan: {img_path}]")
            return
        p_img = doc.add_paragraph()
        p_img.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img.paragraph_format.space_before = Pt(8)
        p_img.paragraph_format.space_after = Pt(3)
        run_img = p_img.add_run()
        run_img.add_picture(img_path, width=Inches(width_inch))

        p_cap = doc.add_paragraph()
        p_cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_cap.paragraph_format.space_after = Pt(10)
        run_cap = p_cap.add_run(caption_text)
        run_cap.font.size = Pt(9.5)
        run_cap.font.italic = True
        run_cap.font.color.rgb = C_MUTED

    # ==========================
    # COVER / HEADER
    # ==========================
    title_p = doc.add_paragraph()
    title_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    title_p.paragraph_format.space_before = Pt(0)
    title_p.paragraph_format.space_after = Pt(2)
    r1 = title_p.add_run("LAPORAN PRAKTIKUM PEMROGRAMAN MOBILE\n")
    r1.font.size = Pt(16)
    r1.bold = True
    r1.font.color.rgb = C_PRIMARY

    r2 = title_p.add_run("MODUL 11: MANAJEMEN STATE DENGAN GETX\n")
    r2.font.size = Pt(13)
    r2.bold = True
    r2.font.color.rgb = C_SECONDARY

    r3 = title_p.add_run("Aplikasi Tasbih Digital (tasbih_getx)")
    r3.font.size = Pt(12)
    r3.font.color.rgb = C_DARK

    doc.add_paragraph().paragraph_format.space_after = Pt(6)

    # Identitas Table Box
    info_table = doc.add_table(rows=4, cols=2)
    info_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    fields = [
        ("Nama Praktikan", ": [Nama]"),
        ("NIM", ": [NIM]"),
        ("Kelas", ": [Kelas]"),
        ("Tanggal Praktikum", ": [Tanggal praktikum]")
    ]
    set_table_borders(info_table, color="B2D8B6")
    for i, (label, val) in enumerate(fields):
        row = info_table.rows[i]
        c0, c1 = row.cells[0], row.cells[1]
        c0.width, c1.width = Inches(2.2), Inches(4.3)
        set_cell_background(c0, "E8F5E9" if i % 2 == 0 else "F1F8F1")
        set_cell_background(c1, "FFFFFF" if i % 2 == 0 else "F9FBF9")
        set_cell_margins(c0, top=60, bottom=60, left=100, right=100)
        set_cell_margins(c1, top=60, bottom=60, left=100, right=100)
        
        p0 = c0.paragraphs[0]
        p0.paragraph_format.space_after = Pt(1)
        r_l = p0.add_run(label)
        r_l.bold = True
        r_l.font.size = Pt(10.5)

        p1 = c1.paragraphs[0]
        p1.paragraph_format.space_after = Pt(1)
        r_v = p1.add_run(val)
        r_v.font.size = Pt(10.5)

    doc.add_paragraph().paragraph_format.space_after = Pt(10)

    # ==========================
    # 1. TUJUAN
    # ==========================
    add_h1("1. Tujuan Praktikum")
    add_p("Berdasarkan pedoman Modul 11 (Bagian 11.1 dan 11.5.b), tujuan praktikum ini mencakup:")
    add_bullet(" Memahami konsep dasar arsitektur manajemen state dalam ekosistem Flutter menggunakan library GetX.", "1. Konsep State:")
    add_bullet(" Menganalisis perbedaan teknis antara setState() pada StatefulWidget dan pendekatan reaktif terdistribusi GetX.", "2. Komparasi Mekanisme:")
    add_bullet(" Mengimplementasikan kelas controller terpisah (TasbihController) serta variabel reaktif berakhiran .obs (RxDouble).", "3. Controller & Reaktivitas:")
    add_bullet(" Menggunakan widget Obx untuk memantau aliran perubahan data reaktif dan merender ulang hanya bagian antarmuka yang relevan.", "4. Listener Obx:")
    add_bullet(" Membangun aplikasi Tasbih Digital (tasbih_getx) yang fungsional, responsif terhadap orientasi layar, serta lulus pengujian otomatis.", "5. Implementasi Nyata:")

    # ==========================
    # 2. DASAR TEORI
    # ==========================
    add_h1("2. Dasar Teori")
    add_h2("2.1 Manajemen State dan Keterbatasan setState()")
    add_p("State merupakan informasi yang tersimpan dalam aplikasi yang dapat berubah seiring berjalannya interaksi pengguna maupun proses asinkron. Pada mekanisme bawaan Flutter, pembaruan antarmuka lokal umumnya menggunakan StatefulWidget dan memanggil fungsi setState(). Saat setState() dieksekusi, Flutter menandai elemen tersebut dirty dan menjadwalkan pembangunan ulang seluruh metode build() dari widget tersebut.")
    add_p("Meskipun mudah untuk aplikasi satu halaman sederhana, pendekatan ini memiliki kekurangan fundamental saat aplikasi berkembang:")
    add_bullet("Kode tampilan antarmuka dan manipulasi data bercampur menjadi satu, melanggar prinsip Separation of Concerns.", "Pencampuran Peran:")
    add_bullet("Seluruh pohon widget di dalam build() ikut dibangun ulang, termasuk widget statis yang tidak mengalami perubahan data.", "Rebuild yang Luas:")
    add_bullet("Mengirimkan state ke widget turunan yang lebih dalam memerlukan prop drilling atau InheritedWidget yang rumit.", "Pewarisan Rumit:")

    add_h2("2.2 Solusi Reaktif GetX")
    add_p("GetX menyediakan manajemen state berbasis reaktif yang sangat efisien dan memisahkan tampilan dengan logika aplikasi secara bersih:")
    add_bullet("Setiap variabel primitif (int, double, String) dapat dijadikan observable secara instan dengan membubuhkan ekstensi .obs (misalnya 0.0.obs). Variabel ini otomatis dibungkus menjadi tipe RxDouble.", "Variabel Reaktif (.obs):")
    add_bullet("Kelas turunan GetxController bertindak sebagai pengelola state dan logika bisnis murni tanpa ketergantungan pada BuildContext Flutter.", "Controller / ViewModel:")
    add_bullet("Widget Obx bertindak sebagai observer pintar yang otomatis mendeteksi variabel .obs yang dipanggil di dalamnya. Hanya widget di dalam Obx yang direbuild ketika nilai .value diperbarui.", "Widget Obx:")

    # ==========================
    # 3. LANGKAH KERJA SINGKAT
    # ==========================
    add_h1("3. Langkah Kerja Singkat")
    add_p("Langkah-langkah pengerjaan praktikum dilaksanakan secara runut sesuai spesifikasi modul:")
    add_bullet("Membuat proyek baru dengan nama tasbih_getx menggunakan perintah terminal: flutter create --org com.example --project-name tasbih_getx tasbih_getx.", "1. Inisialisasi Proyek:")
    add_bullet("Menambahkan pustaka get (^4.7.3) dan simple_circular_progress_bar (^1.0.2) ke dalam berkas pubspec.yaml, kemudian mengeksekusi flutter pub get.", "2. Konfigurasi Dependensi:")
    add_bullet("Membagi folder lib/ menjadi tiga direktori: model/ (disiapkan untuk data model), view/ (antarmuka UI), dan viewmodel/ (logika controller GetX).", "3. Penataan Struktur Folder:")
    add_bullet("Membuat berkas lib/viewmodel/tasbih_controller.dart yang memuat kelas TasbihController dengan variabel counter dan progress reaktif, batas hitungan 33, serta fungsi incrementCounter() dan resetCounter().", "4. Pembuatan Controller:")
    add_bullet("Membuat berkas lib/view/home.dart turunan StatelessWidget. Menghubungkan controller dengan Get.put(TasbihController()), membungkus teks angka dan LinearProgressIndicator dengan Obx, serta menghubungkan tombol fingerprint dan floating action button.", "5. Pembuatan Antarmuka View:")
    add_bullet("Mengonfigurasi lib/main.dart menggunakan GetMaterialApp dengan tema hijau Material 3 dan mematikan banner debug.", "6. Konfigurasi Main App:")
    add_bullet("Melakukan formatting kode (dart format), analisis statis tanpa peringatan (flutter analyze), pembuatan unit test controller dan widget test (flutter test), serta menjalankan aplikasi riil untuk mengambil bukti tangkapan layar.", "7. Verifikasi dan Pengujian:")

    # ==========================
    # 4. PENJELASAN KODE PROGRAM UTAMA
    # ==========================
    add_h1("4. Penjelasan Kode Program Utama")

    add_h2("4.1 Inisialisasi Aplikasi (lib/main.dart)")
    add_p("Berkas main.dart menjadi gerbang masuk utama yang mendefinisikan aplikasi menggunakan GetMaterialApp:")
    add_code_block("""import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasbih Digital GetX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}""")
    add_p("GetMaterialApp menggantikan MaterialApp konvensional untuk menyediakan engine GetX seperti routing terpadu dan injeksi konteks global tanpa perlu passing BuildContext secara berantai. debugShowCheckedModeBanner disetel false agar layar bersih, dan tema disesuaikan dengan tema hijau Material 3.")

    add_h2("4.2 Logika State Reaktif (lib/viewmodel/tasbih_controller.dart)")
    add_p("Seluruh logika bisnis aplikasi zikir dikapsulasi ke dalam kelas TasbihController:")
    add_code_block("""import 'package:get/get.dart';

class TasbihController extends GetxController {
  var counter = 0.0.obs;
  var progress = 0.0.obs;
  final double maxCount = 33.0;

  void incrementCounter() {
    if (counter.value < maxCount) {
      counter.value++;
      progress.value = (counter.value / maxCount) * 100;
    }
  }

  void resetCounter() {
    counter.value = 0.0;
    progress.value = 0.0;
  }
}""")
    add_p("Penjelasan teknis komponen controller:")
    add_bullet("counter dan progress dideklarasikan dengan .obs, sehingga tipe datanya adalah RxDouble. Perubahan nilai dilakukan melalui properti .value agar memicu notifikasi stream reaktif.", "Variabel Reaktif:")
    add_bullet("Ditetapkan sebesar 33.0 sesuai tradisi hitungan tasbih (Subhanallah 33x, Alhamdulillah 33x, Allahu Akbar 33x).", "Batas Maksimum (maxCount):")
    add_bullet("Memeriksa apakah counter.value < maxCount. Jika ya, hitungan ditambah satu dan progress dihitung secara proporsional: progress = (counter / 33) * 100. Contohnya pada ketukan ke-17, progress bernilai 51.52%, dan pada ketukan ke-33, progress tepat 100%. Ketukan berikutnya di atas 33 tidak akan menambah nilai.", "Fungsi incrementCounter():")
    add_bullet("Mengembalikan counter.value dan progress.value ke nilai 0.0 secara instan.", "Fungsi resetCounter():")

    add_h2("4.3 Tampilan Antarmuka dan Reaktivitas (lib/view/home.dart)")
    add_p("Halaman Home mengimplementasikan tampilan antarmuka secara deklaratif menggunakan StatelessWidget:")
    add_code_block("""class Home extends StatelessWidget {
  Home({super.key});

  final TasbihController controller = Get.put(TasbihController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 119, 210, 145),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        '${controller.counter.value.round()}',
                        style: const TextStyle(
                          fontSize: 220,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: LinearProgressIndicator(
                      value: controller.progress.value / 100,
                      backgroundColor: Colors.white54,
                      color: Colors.amberAccent.shade400,
                      minHeight: 15,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: InkWell(
                    onTap: controller.incrementCounter,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: const EdgeInsets.all(30),
                      child: const Icon(Icons.fingerprint, size: 100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.resetCounter,
        backgroundColor: Colors.white,
        child: const Icon(Icons.refresh_outlined, color: Colors.black),
      ),
    );
  }
}""")
    add_p("Widget Obx membungkus widget teks angka dan LinearProgressIndicator. Nilai LinearProgressIndicator menerima nilai dalam rentang 0.0 sampai 1.0, sehingga nilai progress controller dibagi dengan 100 (controller.progress.value / 100). Komponen dibungkus FittedBox dan SingleChildScrollView agar layout fleksibel dan bebas dari masalah overflow pada berbagai dimensi layar.")

    # ==========================
    # 5. PERBANDINGAN SETSTATE DENGAN GETX
    # ==========================
    add_h1("5. Perbandingan setState() dengan GetX")
    add_p("Berikut adalah perbandingan mendalam antara pendekatan state konvensional setState() dengan manajemen state reaktif GetX:")

    cmp_table = doc.add_table(rows=6, cols=3)
    cmp_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_table_borders(cmp_table, color="B2D8B6")

    headers = ["Kriteria Evaluasi", "Pendekatan setState()", "Pendekatan Reaktif GetX"]
    hdr_row = cmp_table.rows[0]
    for j, h_text in enumerate(headers):
        c = hdr_row.cells[j]
        set_cell_background(c, "1B5E20")
        set_cell_margins(c, top=80, bottom=80, left=100, right=100)
        p = c.paragraphs[0]
        r = p.add_run(h_text)
        r.bold = True
        r.font.color.rgb = RGBColor(255, 255, 255)
        r.font.size = Pt(10)

    rows_data = [
        ("Mekanisme Pembaruan UI", "Menandai elemen dirty dan memanggil ulang fungsi build() pada State.", "Menggunakan Stream; listener Obx otomatis mendeteksi pembaruan Rx .value."),
        ("Pemisahan Peran (SoC)", "Logika bisnis dan representasi UI bercampur dalam kelas State.", "Terpisah bersih: logika di ViewModel/Controller, tampilan di StatelessWidget."),
        ("Cakupan Rebuild", "Membangun ulang seluruh subtree di dalam build(), termasuk widget statis.", "Granular: hanya widget di dalam callback Obx spesifik yang dibangun ulang."),
        ("Siklus Hidup (Lifecycle)", "Memerlukan penanganan manual pada initState() dan dispose().", "Dikelola otomatis oleh GetX Dependency Injection (onInit, onClose)."),
        ("Kemudahan Pengujian", "Sulit diuji secara unit test tanpa rendering widget secara penuh.", "Sangat mudah diuji secara terisolasi (Unit Testable) sebagai kelas Dart murni.")
    ]

    for i, (k, s, g) in enumerate(rows_data):
        row = cmp_table.rows[i + 1]
        col_widths = [Inches(1.8), Inches(2.3), Inches(2.4)]
        bg = "F4F9F4" if i % 2 == 0 else "FFFFFF"
        for j, text in enumerate([k, s, g]):
            c = row.cells[j]
            c.width = col_widths[j]
            set_cell_background(c, bg)
            set_cell_margins(c, top=60, bottom=60, left=90, right=90)
            p = c.paragraphs[0]
            p.paragraph_format.space_after = Pt(2)
            p.paragraph_format.line_spacing = 1.1
            r = p.add_run(text)
            r.font.size = Pt(9.5)
            if j == 0:
                r.bold = True

    add_p("Alasan Pendekatan GetX pada Aplikasi Tasbih Digital:", bold_prefix="\n")
    add_p("Pada aplikasi tasbih, frekuensi ketukan pengguna berlangsung intensif dan berulang. Menggunakan GetX memastikan bahwa ketika tombol fingerprint ditekan berulang kali, scaffold, background, dan tombol tidak perlu dirender ulang sama sekali. Hanya angka teks dan progress bar yang direfresh. Selain itu, logika zikir 33 kali dan persentase progress dapat diuji secara mandiri dalam unit test tanpa memerlukan context Flutter.")

    # ==========================
    # 6. HASIL UJI DAN BUKTI SCREENSHOT ASLI
    # ==========================
    add_h1("6. Hasil Uji dan Bukti Screenshot Asli")
    add_p("Aplikasi tasbih_getx telah dikompilasi dan dijalankan secara langsung pada lingkungan runtime riil. Seluruh proses pengujian menghasilkan bukti tangkapan layar nyata berikut:")

    base_dir = r"C:\SEMESTER 5\MOBILE PROGRAMMING PRAK\MODUL_11\screenshots"
    img1 = os.path.join(base_dir, "01_keadaan_awal.png")
    img2 = os.path.join(base_dir, "02_hitungan_17.png")
    img3 = os.path.join(base_dir, "03_hitungan_penuh_33.png")
    img4 = os.path.join(base_dir, "04_setelah_reset.png")

    add_h2("6.1 Keadaan Awal (Nilai 0 dan Progress 0%)")
    add_p("Saat aplikasi pertama kali dibuka, controller.counter bernilai 0.0 dan controller.progress bernilai 0.0. Angka di tengah layar menampilkan 0 dan LinearProgressIndicator berwarna abu-abu kosong.")
    add_image_with_caption(img1, "Gambar 6.1: Tampilan awal aplikasi tasbih digital saat dijalankan (0 ketukan, progress 0%).", width_inch=2.3)

    add_h2("6.2 Hitungan Bertambah (Nilai 17 dan Progress ~51.5%)")
    add_p("Setelah pengguna menekan tombol fingerprint sebanyak 17 kali, nilai counter bertambah menjadi 17 dan indikator progress horizontal terisi kuning sebesar 51.52% (proporsi 17/33).")
    add_image_with_caption(img2, "Gambar 6.2: Tampilan aplikasi setelah 17 ketukan (angka 17, progress bar terisi ~51.5%).", width_inch=2.3)

    add_h2("6.3 Hitungan Penuh Batas Maksimal (Nilai 33 dan Progress 100%)")
    add_p("Setelah tombol ditekan hingga 33 kali, angka menunjukkan 33 dan progress bar terisi penuh 100% berwarna kuning emas. Ketika tombol fingerprint terus ditekan (ketukan ke-34 dan seterusnya), angka tetap tertahan di 33 dan tidak mengalami overflow.")
    add_image_with_caption(img3, "Gambar 6.3: Tampilan aplikasi saat mencapai batas 33 (angka 33, progress bar penuh 100%).", width_inch=2.3)

    add_h2("6.4 Pengaturan Ulang / Reset (Nilai Kembali ke 0 dan Progress 0%)")
    add_p("Saat tombol FloatingActionButton refresh di pojok kanan bawah ditekan, fungsi controller.resetCounter() dieksekusi, mengembalikan counter dan progress kembali ke nol.")
    add_image_with_caption(img4, "Gambar 6.4: Tampilan aplikasi setelah tombol reset ditekan (angka kembali ke 0, progress kembali 0%).", width_inch=2.3)

    add_h2("6.5 Bukti Hasil Verifikasi Otomatis (Automated Test)")
    add_p("Seluruh kode program telah diuji melalui automated testing dengan hasil sebagai berikut:")
    add_code_block("""$ flutter analyze
Analyzing tasbih_getx...
No issues found! (ran in 1.1s)

$ flutter test
00:00 +0: loading test/tasbih_controller_test.dart
00:00 +0: TasbihController Unit Tests Nilai awal counter dan progress harus bernilai 0
00:00 +1: TasbihController Unit Tests Increment satu kali menambah counter menjadi 1 dan progress proporsional
00:00 +2: TasbihController Unit Tests 17 ketukan menghasilkan nilai 17 dan progress sekitar 51.5%
00:00 +3: TasbihController Unit Tests 33 ketukan mencapai batas maksimum 33 dan progress 100%
00:00 +4: TasbihController Unit Tests Ketukan setelah batas 33 tidak boleh menambah nilai (tetap 33 dan 100%)
00:00 +5: TasbihController Unit Tests Reset mengembalikan counter dan progress kembali ke 0
00:00 +6: widget_test.dart: Tasbih Digital smoke and interaction test
00:00 +7: All tests passed!""")
    add_p("Hasil pengujian menunjukkan 100% lulus (7 tes berhasil), membuktikan integritas logika bisnis controller dan interaksi widget UI.")

    # ==========================
    # 7. KESIMPULAN
    # ==========================
    add_h1("7. Kesimpulan")
    add_p("Berdasarkan hasil praktikum dan pengujian pada Modul 11, dapat disimpulkan bahwa:")
    add_bullet("GetX menyederhanakan manajemen state pada Flutter secara signifikan melalui pendekatan reaktif (.obs dan Obx) tanpa perlu memanggil setState().", "1. Kemudahan State Reaktif:")
    add_bullet("Variabel reaktif RxDouble menjamin sinkronisasi otomatis antara nilai numerik zikir dengan representasi grafis LinearProgressIndicator.", "2. Sinkronisasi Data dan UI:")
    add_bullet("Pemisahan logika bisnis ke dalam TasbihController menghasilkan arsitektur kode yang bersih, mudah dipelihara, dan sangat mudah diuji melalui unit test.", "3. Arsitektur Terstruktur:")
    add_bullet("Widget Obx hanya merender ulang elemen yang nilainya berubah, menjaga efisiensi rendering antarmuka saat tombol ditekan berulang-ulang.", "4. Efisiensi Granular Rebuild:")

    # Save DOCX
    out_path = r"C:\SEMESTER 5\MOBILE PROGRAMMING PRAK\MODUL_11\LAPORAN_MODUL_11.docx"
    doc.save(out_path)
    print(f"Laporan DOCX berhasil dibuat di: {out_path}")

if __name__ == "__main__":
    create_report()
