import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import '../widgets/recipe_card.dart';
import 'detail_screen.dart';

/// Halaman Katalog Resep dengan fitur pencarian dan filter kategori aktif.
class CatalogScreen extends StatefulWidget {
  final RecipeService recipeService;
  final String initialCategory;

  const CatalogScreen({
    super.key,
    required this.recipeService,
    this.initialCategory = 'Semua',
  });

  @override
  State<CatalogScreen> createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedCategory;
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;

  final List<Map<String, String>> _categories = const [
    {'label': 'Semua', 'icon': '🍲'},
    {'label': 'Hemat', 'icon': '💰'},
    {'label': 'Cepat', 'icon': '⚡'},
    {'label': 'Tanpa Kompor', 'icon': '🔌'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Memungkinkan navigasi eksternal (dari Beranda) untuk memperbarui kategori.
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilter();
  }

  Future<void> _loadRecipes() async {
    setState(() => _isLoading = true);
    final recipes = await widget.recipeService.getAllRecipes();
    if (mounted) {
      setState(() {
        _allRecipes = recipes;
        _isLoading = false;
        _filteredRecipes = _filterRecipes();
      });
    }
  }

  void _applyFilter() {
    setState(() => _filteredRecipes = _filterRecipes());
  }

  List<Recipe> _filterRecipes() {
    final query = _searchController.text.trim().toLowerCase();
    return _allRecipes.where((recipe) {
      final matchCategory = recipe.matchesCategory(_selectedCategory);
      final matchQuery = recipe.matchesQuery(query);
      return matchCategory && matchQuery;
    }).toList();
  }

  void _resetSearchAndFilter() {
    _searchController.clear();
    _selectedCategory = 'Semua';
    _applyFilter();
  }

  void _openDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(recipe: recipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamScaffold,
      appBar: AppBar(
        title: const Text('Katalog Resep Kos'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.darkGreenSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_filteredRecipes.length} Resep',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkGreen,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Kolom Pencarian
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _applyFilter(),
                decoration: InputDecoration(
                  hintText: 'Cari resep (misal: telur, mie, nasi)...',
                  prefixIcon: const Icon(Icons.search, size: 22),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _applyFilter();
                          },
                        )
                      : null,
                ),
              ),
            ),

            // Filter Kategori (Pill Bar)
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final label = cat['label']!;
                  final icon = cat['icon']!;
                  final isSelected = _selectedCategory == label;

                  return CategoryChipItem(
                    label: label,
                    icon: icon,
                    isSelected: isSelected,
                    onTap: () {
                      _selectedCategory = label;
                      _applyFilter();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Daftar Resep atau Empty State
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.warmOrange,
                      ),
                    )
                  : _filteredRecipes.isEmpty
                  ? EmptyStateView(
                      searchQuery: _searchController.text,
                      selectedCategory: _selectedCategory,
                      onReset: _resetSearchAndFilter,
                    )
                  : RefreshIndicator(
                      color: AppTheme.warmOrange,
                      onRefresh: _loadRecipes,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                        itemCount: _filteredRecipes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final recipe = _filteredRecipes[index];
                          return RecipeCatalogCard(
                            recipe: recipe,
                            onTap: () => _openDetail(recipe),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
