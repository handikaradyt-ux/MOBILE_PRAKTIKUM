import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const indigo = Color(0xFF1A237E);

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  final DateTime createdAt;
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json, {DateTime? createdAt}) {
    if (json['id'] is! int ||
        json['title'] is! String ||
        json['body'] is! String ||
        (json['userId'] != null && json['userId'] is! int)) {
      throw const FormatException('Format post tidak valid');
    }
    return Post(
      id: json['id'] as int,
      userId: (json['userId'] as int?) ?? 1,
      title: json['title'] as String,
      body: json['body'] as String,
      // JSONPlaceholder tidak menyediakan createdAt; waktu dicatat di client.
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
}

class PostApi {
  PostApi(this.client);
  final http.Client client;
  static const baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  static const headers = {'Content-type': 'application/json; charset=UTF-8'};
  static const timeout = Duration(seconds: 15);

  Post _decode(http.Response response, {DateTime? createdAt}) {
    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Respons bukan objek JSON');
    }
    return Post.fromJson(data, createdAt: createdAt);
  }

  Future<Post> create(String title, String body) async {
    final response = await client
        .post(
          Uri.parse(baseUrl),
          headers: headers,
          body: jsonEncode({'title': title, 'body': body, 'userId': 1}),
        )
        .timeout(timeout);
    if (response.statusCode != 201) {
      throw ApiException(
        'Gagal menambahkan post (HTTP ${response.statusCode}).',
      );
    }
    return _decode(response);
  }

  Future<Post> update(Post current, String title, String body) async {
    // Sesuai modul: gunakan resource 1 karena POST demo tidak menyimpan ID 101.
    final response = await client
        .put(
          Uri.parse('$baseUrl/1'),
          headers: headers,
          body: jsonEncode({
            'id': 1,
            'title': title,
            'body': body,
            'userId': 1,
          }),
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      throw ApiException(
        'Gagal mengupdate post (HTTP ${response.statusCode}).',
      );
    }
    return _decode(response, createdAt: current.createdAt);
  }

  Future<void> delete(int id) async {
    final response = await client
        .delete(Uri.parse('$baseUrl/$id'), headers: headers)
        .timeout(timeout);
    if (response.statusCode != 200) {
      throw ApiException('Gagal menghapus post (HTTP ${response.statusCode}).');
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.client});
  final http.Client? client;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter CRUD Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: false,
      primaryColor: indigo,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
          .copyWith(secondary: Colors.lightBlueAccent),
      scaffoldBackgroundColor: Colors.blueGrey[50],
      textTheme: GoogleFonts.openSansTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: indigo,
        foregroundColor: Colors.white,
        elevation: 4,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: indigo,
          foregroundColor: Colors.white,
        ),
      ),
    ),
    home: HomePage(client: client),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.client});
  final http.Client? client;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Post? createdPost;
  bool _isLoading = false;
  late final http.Client _client;
  late final PostApi _api;

  @override
  void initState() {
    super.initState();
    _client = widget.client ?? http.Client();
    _api = PostApi(_client);
  }

  @override
  void dispose() {
    if (widget.client == null) _client.close();
    super.dispose();
  }

  void _notify(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? Colors.red[700] : Colors.green[700],
          duration: const Duration(seconds: 5),
        ),
      );
  }

  Future<void> _runOperation(Future<void> Function() operation) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await operation();
    } on ApiException catch (e) {
      _notify(e.message, error: true);
    } on TimeoutException {
      _notify('Permintaan terlalu lama. Silakan coba lagi.', error: true);
    } on FormatException {
      _notify('Respons server tidak valid. Silakan coba lagi.', error: true);
    } catch (_) {
      _notify('Tidak dapat terhubung. Periksa koneksi internet.', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> createPost(String title, String body) => _runOperation(() async {
    final post = await _api.create(title, body);
    if (!mounted) return;
    setState(() => createdPost = post);
    _notify('Post berhasil ditambahkan!');
  });
  Future<void> updatePost(int id, String title, String body) async {
    final current = createdPost;
    if (current == null || current.id != id) return;
    await _runOperation(() async {
      final post = await _api.update(current, title, body);
      if (!mounted) return;
      setState(() => createdPost = post);
      _notify('Post berhasil diupdate!');
    });
  }

  Future<void> deletePost(int id) => _runOperation(() async {
    await _api.delete(id);
    if (!mounted) return;
    setState(() => createdPost = null);
    _notify('Post berhasil dihapus!');
  });

  Future<void> showAddPostDialog() async {
    final input = await showDialog<({String title, String body})>(
      context: context,
      builder: (_) => const PostFormDialog(),
    );
    if (!mounted || input == null) return;
    await createPost(input.title, input.body);
  }

  Future<void> showUpdatePostDialog(Post currentPost) async {
    final input = await showDialog<({String title, String body})>(
      context: context,
      builder: (_) => PostFormDialog(post: currentPost),
    );
    if (!mounted || input == null) return;
    await updatePost(currentPost.id, input.title, input.body);
  }

  Future<void> showDeleteConfirmationDialog(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus post ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    await deletePost(id);
  }

  Widget _postCard(Post post) {
    final wib = post.createdAt.toUtc().add(const Duration(hours: 7));
    return Card(
      elevation: 8,
      shadowColor: Colors.indigo.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    post.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: indigo,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Aksi post',
                  enabled: !_isLoading,
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'update', child: Text('Update')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  onSelected: (value) {
                    if (value == 'update') {
                      showUpdatePostDialog(post);
                    } else if (value == 'delete') {
                      showDeleteConfirmationDialog(post.id);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.body,
              style: GoogleFonts.openSans(
                fontSize: 18,
                height: 1.5,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'id: ${post.id}',
              style: TextStyle(color: Colors.blueGrey[600]),
            ),
            const SizedBox(height: 12),
            Text(
              'userID: ${post.userId}',
              style: TextStyle(color: Colors.blueGrey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              DateFormat("dd MMMM yyyy, HH:mm 'WIB'", 'id_ID').format(wib),
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: Colors.blueGrey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = createdPost;
    return Scaffold(
      appBar: AppBar(title: const Text('Demo CRUD client-server')),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: post == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Demo CRUD client-server di Flutter',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: indigo,
                        ),
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                    children: [_postCard(post)],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah post',
        onPressed: _isLoading ? null : showAddPostDialog,
        backgroundColor: indigo,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'API demo: perubahan tidak tersimpan permanen.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.blueGrey[700]),
          ),
        ),
      ),
    );
  }
}

class PostFormDialog extends StatefulWidget {
  const PostFormDialog({super.key, this.post});
  final Post? post;
  @override
  State<PostFormDialog> createState() => _PostFormDialogState();
}

class _PostFormDialogState extends State<PostFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _body;
  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.post?.title);
    _body = TextEditingController(text: widget.post?.body);
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.post == null ? 'Tambah Post' : 'Update Post'),
    content: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Nama'),
              textInputAction: TextInputAction.next,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama harus diisi'
                  : null,
            ),
            TextFormField(
              controller: _body,
              decoration: const InputDecoration(labelText: 'Pekerjaan'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Pekerjaan harus diisi'
                  : null,
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(context, (
              title: _title.text.trim(),
              body: _body.text.trim(),
            ));
          }
        },
        child: Text(widget.post == null ? 'Simpan' : 'Update'),
      ),
    ],
  );
}
