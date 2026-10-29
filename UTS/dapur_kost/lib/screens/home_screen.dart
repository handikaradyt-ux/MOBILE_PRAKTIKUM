import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/recipe_card.dart';
import 'detail_screen.dart';

/// Halaman Beranda (Home) DapurKost.
///
/// Menampilkan pengantar aplikasi, pemilihan kategori cepat (Hemat, Cepat, Tanpa Kompor),
/// resep pilihan hari ini, dan tips praktis memasak anak kos.
class HomeScreen extends StatefulWidget {
  final RecipeService recipeService;
  final Function(String category) onCategorySelected;
  final VoidCallback onSeeAllPressed;

  const HomeScreen({
    super.key,
    required this.recipeService,
    required this.onCategorySelected,
    required this.onSeeAllPressed,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> _featuredRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeaturedRecipes();
  }

  Future<void> _loadFeaturedRecipes() async {
    setState(() => _isLoading = true);
    final recipes = await widget.recipeService.getFeaturedRecipes();
    if (mounted) {
      setState(() {
        _featuredRecipes = recipes;
        _isLoading = false;
      });
    }
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
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.warmOrange,
          onRefresh: _loadFeaturedRecipes,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Identitas Aplikasi & Sapaan
                _buildHeader(),
                const SizedBox(height: 18),

                // 2. Banner Inspirasi Masak
                _buildHeroBanner(),
                const SizedBox(height: 22),

                // 3. Pilihan Kategori Cepat (Hemat, Cepat, Tanpa Kompor)
                _buildCategorySection(),
                const SizedBox(height: 24),

                // 4. Bagian Resep Pilihan Hari Ini
                _buildFeaturedSection(),
                const SizedBox(height: 24),

                // 5. Tips Dapur Kos Praktis
                _buildTipsBanner(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo, Mahasiswa Kos! 👋',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Text(
                  'Dapur',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.darkGreen,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Kost',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.warmOrange,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warmOrangeSoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'UTS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.warmOrange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text('🍳', style: TextStyle(fontSize: 22)),
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.warmOrange, AppTheme.warmOrangeLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.warmOrange.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'MASAK HEMAT & LEZAT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Solusi Masak Praktis Anak Kos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Temukan 12 ide hidangan sederhana berbasis bahan terjangkau, cepat matang, dan ramah kantong kosan.',
            style: TextStyle(fontSize: 12, color: Colors.white, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kategori Pilihan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            InkWell(
              onTap: widget.onSeeAllPressed,
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  'Lihat Semua →',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.warmOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            HomeCategoryCard(
              title: 'Hemat',
              subtitle: 'Ramah Kantong',
              icon: '💰',
              accentColor: const Color(0xFFD97706),
              onTap: () => widget.onCategorySelected('Hemat'),
            ),
            const SizedBox(width: 10),
            HomeCategoryCard(
              title: 'Cepat',
              subtitle: '≤ 15 Menit',
              icon: '⚡',
              accentColor: const Color(0xFFDC2626),
              onTap: () => widget.onCategorySelected('Cepat'),
            ),
            const SizedBox(width: 10),
            HomeCategoryCard(
              title: 'Tanpa Kompor',
              subtitle: 'Rice Cooker',
              icon: '🔌',
              accentColor: const Color(0xFF16A34A),
              onTap: () => widget.onCategorySelected('Tanpa Kompor'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Resep Pilihan Hari Ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.darkGreenSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Rekomendasi',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(color: AppTheme.warmOrange),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _featuredRecipes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final recipe = _featuredRecipes[index];
              return RecipeFeaturedCard(
                recipe: recipe,
                onTap: () => _openDetail(recipe),
              );
            },
          ),
      ],
    );
  }

  Widget _buildTipsBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.darkGreenSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppTheme.darkGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Cerdas Anak Kos 💡',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Siapkan bumbu dasar di akhir pekan dan simpan dalam wadah tertutup di kulkas agar persiapan masak berikutnya lebih cepat.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
