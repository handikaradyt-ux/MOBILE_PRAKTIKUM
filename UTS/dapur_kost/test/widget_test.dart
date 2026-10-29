import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dapur_kost/main.dart';
import 'package:dapur_kost/models/recipe.dart';
import 'package:dapur_kost/screens/catalog_screen.dart';
import 'package:dapur_kost/screens/detail_screen.dart';
import 'package:dapur_kost/services/recipe_service.dart';
import 'package:dapur_kost/widgets/category_chip.dart';

/// Service tiruan untuk pengujian widget terisolasi
class TestRecipeService extends RecipeService {
  final List<Recipe> mockRecipes;

  TestRecipeService(this.mockRecipes);

  @override
  Future<List<Recipe>> getAllRecipes({bool forceRefresh = false}) async {
    return mockRecipes;
  }

  @override
  Future<List<Recipe>> getFeaturedRecipes() async {
    return mockRecipes.where((r) => r.isFeatured).toList();
  }

  @override
  Future<List<Recipe>> filterRecipes({String? query, String? category}) async {
    return mockRecipes.where((r) {
      return r.matchesCategory(category) && r.matchesQuery(query);
    }).toList();
  }
}

void main() {
  final sampleRecipes = [
    const Recipe(
      id: 'test-01',
      name: 'Nasi Gila Sosis Bakso',
      category: 'Cepat',
      tags: ['Cepat', 'Hemat'],
      durationMinutes: 15,
      estimatedCost: 12000,
      difficulty: 'Mudah',
      portion: '1 Porsi',
      description: 'Nasi campur orak arik sosis bakso nikmat',
      image: 'assets/images/nasi_gila.png',
      isFeatured: true,
      ingredients: ['Nasi', 'Telur', 'Sosis', 'Bakso'],
      steps: ['Tumis bumbu', 'Masukkan telur', 'Sajikan'],
    ),
    const Recipe(
      id: 'test-02',
      name: 'Omelet Mie Telur Crispy',
      category: 'Hemat',
      tags: ['Hemat'],
      durationMinutes: 10,
      estimatedCost: 7000,
      difficulty: 'Sangat Mudah',
      portion: '1 Porsi',
      description: 'Omelet mie gurih renyah',
      image: 'assets/images/omelet_mie.png',
      isFeatured: false,
      ingredients: ['Mie', 'Telur', 'Bawang'],
      steps: ['Rebus mie', 'Kocok telur', 'Goreng'],
    ),
  ];

  testWidgets('DapurKostApp renders title and BottomNavigationBar correctly', (
    WidgetTester tester,
  ) async {
    final testService = TestRecipeService(sampleRecipes);
    await tester.pumpWidget(DapurKostApp(recipeService: testService));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Pastikan teks judul aplikasi Dapur dan Kost muncul
    expect(find.text('Dapur'), findsOneWidget);
    expect(find.text('Kost'), findsOneWidget);

    // Pastikan item navigasi bawah tersedia
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Katalog Resep'), findsOneWidget);

    // Pastikan kartu kategori utama muncul di Beranda
    expect(find.text('Kategori Pilihan'), findsOneWidget);
    expect(find.widgetWithText(HomeCategoryCard, 'Hemat'), findsOneWidget);
    expect(find.widgetWithText(HomeCategoryCard, 'Cepat'), findsOneWidget);
    expect(
      find.widgetWithText(HomeCategoryCard, 'Tanpa Kompor'),
      findsOneWidget,
    );
  });

  testWidgets('Bottom navigation switches between Beranda and Katalog', (
    WidgetTester tester,
  ) async {
    final testService = TestRecipeService(sampleRecipes);
    await tester.pumpWidget(DapurKostApp(recipeService: testService));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Ketuk tab Katalog Resep pada navigasi bawah
    await tester.tap(find.text('Katalog Resep'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verifikasi berada di halaman Katalog Resep
    expect(find.text('Katalog Resep Kos'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('CatalogScreen filters recipes by category and search text', (
    WidgetTester tester,
  ) async {
    final testService = TestRecipeService(sampleRecipes);
    await tester.pumpWidget(
      MaterialApp(home: CatalogScreen(recipeService: testService)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Awalnya menampilkan kedua resep
    expect(find.text('Nasi Gila Sosis Bakso'), findsOneWidget);
    expect(find.text('Omelet Mie Telur Crispy'), findsOneWidget);

    // Masukkan kata kunci pencarian 'mie'
    await tester.enterText(find.byType(TextField), 'mie');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Hanya Omelet Mie yang tersisa
    expect(find.text('Omelet Mie Telur Crispy'), findsOneWidget);
    expect(find.text('Nasi Gila Sosis Bakso'), findsNothing);

    // Bersihkan pencarian dan cari kata yang tidak ada
    await tester.enterText(find.byType(TextField), 'pizza');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Menampilkan Empty State
    expect(find.text('Resep Tidak Ditemukan'), findsOneWidget);
  });

  testWidgets(
    'DetailScreen displays recipe details correctly and handles action button',
    (WidgetTester tester) async {
      const testRecipe = Recipe(
        id: 'test-detail-01',
        name: 'Omelet Mie Telur Spesial',
        category: 'Hemat',
        tags: ['Hemat', 'Cepat'],
        durationMinutes: 10,
        estimatedCost: 7000,
        difficulty: 'Sangat Mudah',
        portion: '1 Porsi',
        description: 'Omelet mie lezat bergizi untuk anak kos.',
        image: 'assets/images/omelet_mie.png',
        isFeatured: true,
        ingredients: [
          '1 bks mie instan',
          '2 butir telur ayam',
          '1 batang daun bawang',
        ],
        steps: ['Rebus mie', 'Campur telur', 'Goreng hingga keemasan'],
      );

      // Gunakan viewport yang proporsional untuk pengujian
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(home: DetailScreen(recipe: testRecipe)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verifikasi teks judul, metrik, bahan, dan langkah
      expect(find.text('Detail Resep'), findsOneWidget);
      expect(find.text('Omelet Mie Telur Spesial'), findsOneWidget);
      expect(find.text('10 Menit'), findsOneWidget);
      expect(find.text('Rp 7.000'), findsOneWidget);
      expect(find.text('Sangat Mudah'), findsOneWidget);
      expect(find.text('1 bks mie instan'), findsOneWidget);
      expect(find.text('Rebus mie'), findsOneWidget);

      final actionBtn = find.text('Mulai Memasak Sekarang');
      expect(actionBtn, findsOneWidget);

      await tester.ensureVisible(actionBtn);
      await tester.pumpAndSettle();
      await tester.tap(actionBtn);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);

      String? copiedRecipe;
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') {
          copiedRecipe = (call.arguments as Map)['text'] as String?;
        }
        return null;
      });
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );

      await tester.tap(find.byTooltip('Salin Resep'));
      await tester.pump();
      expect(copiedRecipe, contains('Omelet Mie Telur Spesial'));
      expect(copiedRecipe, contains('1. Rebus mie'));
    },
  );
}
