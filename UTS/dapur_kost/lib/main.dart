import 'package:flutter/material.dart';

import 'screens/main_screen.dart';
import 'services/recipe_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final recipeService = RecipeService();
  runApp(DapurKostApp(recipeService: recipeService));
}

/// Root widget aplikasi DapurKost.
class DapurKostApp extends StatelessWidget {
  final RecipeService recipeService;

  const DapurKostApp({super.key, required this.recipeService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DapurKost - Resep Praktis Anak Kos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MainScreen(recipeService: recipeService),
    );
  }
}
