import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen_arguments.dart';

class Tujuan extends StatelessWidget {
  const Tujuan({super.key});
  static const routeName = '/extractArguments';

  Widget _buildDetailImage(ScreenArguments args) {
    final coverUrl = args.cover.trim();
    final thumbUrl = args.thumbnail.trim();

    // 1. Coba muat dari coverUrl (screenshots[0].image dari API)
    if (coverUrl.isNotEmpty) {
      return Image.network(
        coverUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('[Tujuan] Gagal memuat cover dari URL ($coverUrl): $error');

          // 2. Jika cover gagal, coba thumbnail dari API
          if (thumbUrl.isNotEmpty && thumbUrl != coverUrl) {
            return Image.network(
              thumbUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint(
                    '[Tujuan] Gagal memuat thumbnail dari URL ($thumbUrl): $error');
                // 3. Jika kedua URL API gagal, gunakan aset lokal resmi
                debugPrint(
                    '[Tujuan] Menggunakan aset lokal genshin_cover.jpg sebagai fallback');
                return Image.asset(
                  'assets/images/genshin_cover.jpg',
                  fit: BoxFit.cover,
                );
              },
            );
          }

          // Fallback ke aset lokal jika thumbnail tidak tersedia
          debugPrint(
              '[Tujuan] Menggunakan aset lokal genshin_cover.jpg sebagai fallback');
          return Image.asset(
            'assets/images/genshin_cover.jpg',
            fit: BoxFit.cover,
          );
        },
      );
    }

    // Jika coverUrl kosong, coba thumbnail dari API
    if (thumbUrl.isNotEmpty) {
      return Image.network(
        thumbUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint(
              '[Tujuan] Menggunakan aset lokal genshin_cover.jpg sebagai fallback');
          return Image.asset(
            'assets/images/genshin_cover.jpg',
            fit: BoxFit.cover,
          );
        },
      );
    }

    // Fallback aset lokal jika kedua URL kosong
    return Image.asset(
      'assets/images/genshin_cover.jpg',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      backgroundColor: const Color(0xFFF94A29),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F8FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildDetailImage(args),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        args.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 47, 72),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        args.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 47, 72),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0081c9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios_outlined,
                              size: 15,
                              color: Color(0xFFF4F8FB),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Kembali ke game',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFF4F8FB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
