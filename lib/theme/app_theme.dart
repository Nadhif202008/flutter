import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00B14F); // Grab Green
  static const Color primaryDark = Color(0xFF008D3F);
  static const Color primaryLight = Color(0xFFE6F7ED);
  
  static const Color background = Color(0xFFF7F8FA);
  static const Color cardBg = Colors.white;
  
  static const Color textPrimary = Color(0xFF1C1C1C);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFB0B0B0);
  
  static const Color discountRed = Color(0xFFEE2737);
  static const Color ratingYellow = Color(0xFFFFB800);
  static const Color orangeAccent = Color(0xFFFF6D00);
  
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF0F0F0);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.orangeAccent,
        surface: AppColors.cardBg,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
