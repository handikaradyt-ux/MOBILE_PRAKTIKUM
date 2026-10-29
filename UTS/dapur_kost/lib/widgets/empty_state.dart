import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Widget tampilan saat pencarian atau filter resep tidak menemukan hasil.
class EmptyStateView extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final VoidCallback onReset;

  const EmptyStateView({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lingkaran Ikon Ilustrasi Kosong
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.warmOrangeSoft,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.warmOrangeLight.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: const Text('🍳', style: TextStyle(fontSize: 46)),
            ),
            const SizedBox(height: 20),

            // Judul
            const Text(
              'Resep Tidak Ditemukan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Keterangan spesifik filter/query
            Text(
              searchQuery.isNotEmpty
                  ? 'Tidak ada resep yang cocok dengan kata kunci "$searchQuery"${selectedCategory != 'Semua' ? ' pada kategori $selectedCategory' : ''}.'
                  : 'Belum ada resep yang terdaftar untuk kategori "$selectedCategory".',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Tombol Reset Filter yang benar-benar berfungsi
            ElevatedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset Pencarian & Filter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
