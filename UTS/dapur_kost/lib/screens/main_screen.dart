import 'package:flutter/material.dart';

import '../services/recipe_service.dart';
import '../theme/app_theme.dart';
import 'catalog_screen.dart';
import 'home_screen.dart';

/// Kontainer navigasi utama aplikasi DapurKost.
///
/// Mengelola `BottomNavigationBar` antara Beranda dan Katalog Resep,
/// serta menjembatani perpindahan filter saat kategori ditekan dari Beranda.
class MainScreen extends StatefulWidget {
  final RecipeService recipeService;

  const MainScreen({super.key, required this.recipeService});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<CatalogScreenState> _catalogKey =
      GlobalKey<CatalogScreenState>();

  void _navigateToCatalogWithCategory(String category) {
    setState(() {
      _currentIndex = 1;
    });
    // Beri waktu 1 frame agar widget Katalog terbangun jika belum
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _catalogKey.currentState?.setCategory(category);
    });
  }

  void _navigateToCatalogAll() {
    _navigateToCatalogWithCategory('Semua');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            recipeService: widget.recipeService,
            onCategorySelected: _navigateToCatalogWithCategory,
            onSeeAllPressed: _navigateToCatalogAll,
          ),
          CatalogScreen(key: _catalogKey, recipeService: widget.recipeService),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: AppTheme.borderLight, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: 'Katalog Resep',
            ),
          ],
        ),
      ),
    );
  }
}
