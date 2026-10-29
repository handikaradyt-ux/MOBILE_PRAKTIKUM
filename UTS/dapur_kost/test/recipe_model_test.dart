import 'package:flutter_test/flutter_test.dart';
import 'package:dapur_kost/models/recipe.dart';

void main() {
  group('Recipe Model Tests', () {
    final sampleJson = {
      'id': 'test-01',
      'name': 'Nasi Gila Sosis Bakso',
      'category': 'Cepat',
      'tags': ['Cepat', 'Hemat'],
      'durationMinutes': 15,
      'estimatedCost': 12000,
      'difficulty': 'Mudah',
      'portion': '1 Porsi',
      'description': 'Nasi campur orak arik nikmat',
      'image': 'assets/images/nasi_gila.png',
      'isFeatured': true,
      'ingredients': ['Nasi', 'Telur', 'Sosis', 'Bakso'],
      'steps': ['Tumis bumbu', 'Masukkan telur', 'Sajikan'],
    };

    test('Recipe.fromJson creates a valid Recipe instance', () {
      final recipe = Recipe.fromJson(sampleJson);

      expect(recipe.id, 'test-01');
      expect(recipe.name, 'Nasi Gila Sosis Bakso');
      expect(recipe.category, 'Cepat');
      expect(recipe.tags, ['Cepat', 'Hemat']);
      expect(recipe.durationMinutes, 15);
      expect(recipe.estimatedCost, 12000);
      expect(recipe.difficulty, 'Mudah');
      expect(recipe.portion, '1 Porsi');
      expect(recipe.isFeatured, true);
      expect(recipe.ingredients.length, 4);
      expect(recipe.steps.length, 3);
    });

    test('Recipe.toJson produces correct Map structure', () {
      final recipe = Recipe.fromJson(sampleJson);
      final jsonMap = recipe.toJson();

      expect(jsonMap['id'], 'test-01');
      expect(jsonMap['name'], 'Nasi Gila Sosis Bakso');
      expect(jsonMap['estimatedCost'], 12000);
      expect(jsonMap['isFeatured'], true);
    });

    test('formattedCost formats currency correctly', () {
      final recipe1 = Recipe.fromJson(sampleJson);
      expect(recipe1.formattedCost, 'Rp 12.000');

      final sampleJson2 = Map<String, dynamic>.from(sampleJson);
      sampleJson2['estimatedCost'] = 7500;
      final recipe2 = Recipe.fromJson(sampleJson2);
      expect(recipe2.formattedCost, 'Rp 7.500');

      final sampleJson3 = Map<String, dynamic>.from(sampleJson);
      sampleJson3['estimatedCost'] = 150000;
      final recipe3 = Recipe.fromJson(sampleJson3);
      expect(recipe3.formattedCost, 'Rp 150.000');
    });

    test('formattedDuration returns minutes with suffix', () {
      final recipe = Recipe.fromJson(sampleJson);
      expect(recipe.formattedDuration, '15 Menit');
    });

    test('matchesCategory handles "Semua", direct category, and tags', () {
      final recipe = Recipe.fromJson(sampleJson);

      expect(recipe.matchesCategory('Semua'), true);
      expect(recipe.matchesCategory(null), true);
      expect(recipe.matchesCategory(''), true);
      expect(recipe.matchesCategory('Cepat'), true);
      expect(recipe.matchesCategory('cepat'), true); // Case-insensitive
      expect(recipe.matchesCategory('Hemat'), true); // In tags
      expect(recipe.matchesCategory('Tanpa Kompor'), false);
    });

    test('matchesQuery checks name, description, and ingredients', () {
      final recipe = Recipe.fromJson(sampleJson);

      expect(recipe.matchesQuery(null), true);
      expect(recipe.matchesQuery(''), true);
      expect(recipe.matchesQuery('nasi'), true);
      expect(recipe.matchesQuery('BAKSO'), true);
      expect(recipe.matchesQuery('orak arik'), true);
      expect(recipe.matchesQuery('sosis'), true);
      expect(recipe.matchesQuery('keju mozarella'), false);
    });
  });
}
