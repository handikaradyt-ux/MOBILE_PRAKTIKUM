import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screen_arguments.dart';
import 'tujuan.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? title, thumbnail, shortDescription, description;
  String? genre, platform, release, cover, gameid, publisher;
  bool isLoading = true;
  String? errorMessage;

  Future<void> getGame(String gameid) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      debugPrint('[Home] Mengambil data game dari API dengan ID: $gameid');
      final uri = Uri.parse('https://www.freetogame.com/api/game?id=$gameid');

      // Request langsung tanpa header autentikasi ke endpoint FreeToGame
      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception(
              'Koneksi timeout (15 detik). Server FreeToGame tidak merespons.');
        },
      );

      debugPrint('[Home] HTTP Status Code: ${response.statusCode}');

      // Periksa status HTTP dan isi respons sebelum jsonDecode
      if (response.statusCode != 200) {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage =
                'Gagal memuat data dari server (HTTP status: ${response.statusCode})';
          });
        }
        return;
      }

      final responseBody = response.body.trim();
      if (responseBody.isEmpty) {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = 'Respons dari server FreeToGame kosong.';
          });
        }
        return;
      }

      final dynamic results = jsonDecode(responseBody);
      if (results is! Map<String, dynamic>) {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = 'Format respons API bukan objek JSON yang valid.';
          });
        }
        return;
      }

      // Periksa jika API mengembalikan respons gagal
      if (results['status'] == 0) {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = results['status_message']?.toString() ??
                'Data game tidak ditemukan.';
          });
        }
        return;
      }

      // Tangani screenshots yang kosong agar screenshots[0] tidak crash
      String resolvedCover = '';
      if (results['screenshots'] is List &&
          (results['screenshots'] as List).isNotEmpty &&
          results['screenshots'][0] is Map &&
          results['screenshots'][0]['image'] != null) {
        resolvedCover = results['screenshots'][0]['image'].toString();
      } else {
        // Fallback ke thumbnail jika screenshots kosong atau null
        resolvedCover = results['thumbnail']?.toString() ?? '';
      }

      if (mounted) {
        setState(() {
          this.gameid = gameid;
          title = results['title']?.toString() ?? 'Tanpa Judul';
          thumbnail = results['thumbnail']?.toString() ?? '';
          shortDescription = results['short_description']?.toString() ?? '';
          description = results['description']?.toString() ?? '';
          genre = results['genre']?.toString() ?? '-';
          platform = results['platform']?.toString() ?? '-';
          publisher = results['publisher']?.toString() ?? '-';
          release = results['release_date']?.toString() ?? '-';
          cover = resolvedCover;
          isLoading = false;
          errorMessage = null;
        });
        debugPrint('[Home] Data game "$title" berhasil dimuat dari API.');
        debugPrint('[Home] Thumbnail URL: $thumbnail');
        debugPrint('[Home] Cover URL: $cover');
      }
    } catch (e) {
      debugPrint('[Home] Error saat getGame: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Terjadi kesalahan saat memuat data: $e';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getGame('475'); // ambil 1 game default
  }

  Widget _buildHomeThumbnail(String? url) {
    final cleanUrl = url?.trim() ?? '';
    if (cleanUrl.isNotEmpty) {
      return Image.network(
        cleanUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint(
              '[Home] Gagal memuat thumbnail dari URL ($cleanUrl): $error');
          debugPrint(
              '[Home] Menggunakan aset lokal genshin_thumbnail.jpg sebagai fallback');
          return Image.asset(
            'assets/images/genshin_thumbnail.jpg',
            fit: BoxFit.cover,
          );
        },
      );
    }
    return Image.asset(
      'assets/images/genshin_thumbnail.jpg',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0081c9),
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : errorMessage != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0081c9),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              getGame('475');
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              'Coba Lagi',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: _buildHomeThumbnail(thumbnail),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  title ?? '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Genre: $genre"),
                                        Text("Platform: $platform"),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Publisher: $publisher"),
                                        Text("Release: $release"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Tujuan.routeName,
                              arguments: ScreenArguments(
                                cover ?? '',
                                title ?? '',
                                description ?? '',
                                shortDescription ?? '',
                                thumbnail ?? '',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}