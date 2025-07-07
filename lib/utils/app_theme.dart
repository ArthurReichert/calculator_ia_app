import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color userMessage = Color(
    0xFFDCF8C6,
  );
  static const Color aiMessage = Color(
    0xFFFFFFFF,
  );
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
