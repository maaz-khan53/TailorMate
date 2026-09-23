import 'package:flutter/material.dart';

/// ==========================================================
/// TailorX Color Palette
/// Light + Dark Theme Ready
/// ==========================================================
class AppColors {
  AppColors._();

  // ==========================================================
  // Primary Brand Colors
  // ==========================================================

  static const Color primary = Color(0xFF0F766E);
  static const Color primaryDark = Color(0xFF0B5E57);
  static const Color primaryLight = Color(0xFF2DD4BF);

  // ==========================================================
  // Secondary Brand Colors
  // ==========================================================

  static const Color secondary = Color(0xFFF59E0B);
  static const Color secondaryDark = Color(0xFFD97706);
  static const Color secondaryLight = Color(0xFFFCD34D);
  static const Color gold = Color(0xFFFFC83D);

  // ==========================================================
  // Light Backgrounds
  // ==========================================================

  static const Color background = Color(0xFFF8FAFC);
  static const Color scaffold = Color(0xFFF5F7FA);

  /// Common aliases used throughout TailorX screens.
  static const Color surface = Colors.white;
  static const Color surfaceSoft = Color(0xFFEAF5F1);

  // ==========================================================
  // Dark Backgrounds
  // ==========================================================

  static const Color darkBackground = Color(0xFF071712);
  static const Color darkScaffold = Color(0xFF0A1F19);
  static const Color darkSurface = Color(0xFF0D211B);
  static const Color darkSurfaceSoft = Color(0xFF132D25);

  // ==========================================================
  // Cards
  // ==========================================================

  static const Color card = Colors.white;
  static const Color darkCard = Color(0xFF0D211B);

  // ==========================================================
  // Text Colors
  // ==========================================================

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  static const Color whiteText = Colors.white;
  static const Color darkText = Color(0xFFE2E8F0);

  // ==========================================================
  // Borders
  // ==========================================================

  static const Color border = Color(0xFFE2E8F0);
  static const Color darkBorder = Color(0xFF29443A);

  // ==========================================================
  // Status Colors
  // ==========================================================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ==========================================================
  // Grey Palette
  // ==========================================================

  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);

  // ==========================================================
  // Primary Gradients
  // ==========================================================

  /// Main premium teal gradient used by cards, icons and selectors.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      primaryDark,
      primary,
      primaryLight,
    ],
  );

  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      primaryDark,
      primary,
      Color(0xFF14B8A6),
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      primary,
      Color(0xFF14B8A6),
    ],
  );

  // ==========================================================
  // Secondary Gradients
  // ==========================================================

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      Color(0xFFFFD54F),
      Color(0xFFFFB300),
    ],
  );
}
