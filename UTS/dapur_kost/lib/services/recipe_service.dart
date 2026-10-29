import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/recipe.dart';

/// Lapisan repository / service untuk mengelola data resep.
///
/// Memuat data dummy dari `assets/data/recipes.json` dengan struktur
/// terisolasi sehingga kelak dapat dialihkan ke HTTP REST API tanpa
/// mengubah tampilan layar atau komponen UI.
class RecipeService {
  static const String _assetPath = 'assets/data/recipes.json';

  // Cache in-memory untuk efisiensi performa
  List<Recipe>? _cachedRecipes;

  /// Memuat seluruh daftar resep dari sumber data.
  Future<List<Recipe>> getAllRecipes({bool forceRefresh = false}) async {
    if (_cachedRecipes != null && !forceRefresh) {
      return _cachedRecipes!;
    }

    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final dynamic decoded = json.decode(jsonString);

      if (decoded is List) {
        _cachedRecipes = decoded
            .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _cachedRecipes = [];
      }
      return _cachedRecipes!;
    } catch (e) {
      // Jika terjadi kendala pembacaan data, kembalikan daftar kosong secara aman
      return [];
    }
  }

  /// Mengambil daftar resep pilihan / unggulan (isFeatured == true) untuk Beranda.
  Future<List<Recipe>> getFeaturedRecipes() async {
    final all = await getAllRecipes();
    final featured = all.where((r) => r.isFeatured).toList();
    if (featured.isEmpty) {
      return all.take(3).toList();
    }
    return featured;
  }

  /// Menyaring daftar resep berdasarkan kata kunci dan kategori.
  Future<List<Recipe>> filterRecipes({String? query, String? category}) async {
    final all = await getAllRecipes();
    return all.where((recipe) {
      final matchesCat = recipe.matchesCategory(category);
      final matchesQ = recipe.matchesQuery(query);
      return matchesCat && matchesQ;
    }).toList();
  }

  /// Mengambil resep berdasarkan ID unik.
  Future<Recipe?> getRecipeById(String id) async {
    final all = await getAllRecipes();
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Mendapatkan daftar kategori unik untuk tombol filter.
  Future<List<String>> getCategories() async {
    final all = await getAllRecipes();
    final set = <String>{'Semua'};
    for (final r in all) {
      set.add(r.category);
    }
    return set.toList();
  }
}
