/// Model data resep untuk aplikasi DapurKost.
///
/// Menyimpan detail informasi resep makanan anak kos,
/// termasuk estimasi biaya, durasi memasak, bahan, dan langkah-langkah.
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

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.durationMinutes,
    required this.estimatedCost,
    required this.difficulty,
    required this.portion,
    required this.description,
    required this.image,
    required this.isFeatured,
    required this.ingredients,
    required this.steps,
  });

  /// Factory constructor untuk deserialisasi dari format JSON.
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'Umum',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      estimatedCost: json['estimatedCost'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'Mudah',
      portion: json['portion'] as String? ?? '1 Porsi',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  /// Serialisasi model Recipe ke Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tags': tags,
      'durationMinutes': durationMinutes,
      'estimatedCost': estimatedCost,
      'difficulty': difficulty,
      'portion': portion,
      'description': description,
      'image': image,
      'isFeatured': isFeatured,
      'ingredients': ingredients,
      'steps': steps,
    };
  }

  /// Format biaya estimasi ke string Rupiah yang rapi (contoh: "Rp 12.000").
  String get formattedCost {
    final costStr = estimatedCost.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < costStr.length; i++) {
      if (i > 0 && (costStr.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(costStr[i]);
    }
    return 'Rp $buffer';
  }

  /// Format durasi memasak dalam menit (contoh: "15 Menit").
  String get formattedDuration => '$durationMinutes Menit';

  /// Memeriksa apakah resep cocok dengan filter kategori yang dipilih.
  bool matchesCategory(String? selectedCategory) {
    if (selectedCategory == null ||
        selectedCategory.isEmpty ||
        selectedCategory == 'Semua') {
      return true;
    }
    if (category.toLowerCase() == selectedCategory.toLowerCase()) {
      return true;
    }
    return tags.any(
      (tag) => tag.toLowerCase() == selectedCategory.toLowerCase(),
    );
  }

  /// Memeriksa apakah resep cocok dengan kata kunci pencarian.
  bool matchesQuery(String? query) {
    if (query == null || query.trim().isEmpty) {
      return true;
    }
    final cleanQuery = query.trim().toLowerCase();
    return name.toLowerCase().contains(cleanQuery) ||
        description.toLowerCase().contains(cleanQuery) ||
        ingredients.any((ing) => ing.toLowerCase().contains(cleanQuery));
  }
}
