import 'package:flutter/material.dart';

/// Konfigurasi tema dan palet warna resmi aplikasi DapurKost.
///
/// Menggunakan kombinasi warna krem hangat (latar), oranye hangat (primer/energi),
/// dan hijau tua (sekunder/kesegaran) yang ramah serta membangkitkan selera makan.
class AppTheme {
  // Palet Warna Utama
  static const Color creamBackground = Color(0xFFFDFBF7);
  static const Color creamScaffold = Color(0xFFFAF7F2);
  static const Color creamCard = Color(0xFFFFFFFF);
  static const Color creamAccent = Color(0xFFFFF6ED);

  static const Color warmOrange = Color(0xFFE05A2B);
  static const Color warmOrangeLight = Color(0xFFFF7A45);
  static const Color warmOrangeSoft = Color(0xFFFFECE5);

  static const Color darkGreen = Color(0xFF1B4D3E);
  static const Color darkGreenLight = Color(0xFF2C6B57);
  static const Color darkGreenSoft = Color(0xFFE8F5EE);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color borderLight = Color(0xFFEFEAE2);
  static const Color dividerColor = Color(0xFFF1EDE6);

  /// Menghasilkan ThemeData lengkap untuk aplikasi DapurKost.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: creamScaffold,
      primaryColor: warmOrange,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: warmOrange,
        onPrimary: Colors.white,
        secondary: darkGreen,
        onSecondary: Colors.white,
        error: Color(0xFFDC2626),
        onError: Colors.white,
        surface: creamCard,
        onSurface: textPrimary,
      ),

      // Konfigurasi AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: creamScaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),

      // Konfigurasi Card
      cardTheme: CardThemeData(
        color: creamCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),

      // Konfigurasi Input / TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          color: textMuted,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIconColor: textMuted,
        suffixIconColor: textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: warmOrange, width: 1.8),
        ),
      ),

      // Konfigurasi BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: warmOrange,
        unselectedItemColor: textMuted,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
      ),

      // Konfigurasi Tombol
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: warmOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
