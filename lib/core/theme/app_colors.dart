import 'package:flutter/material.dart';

/// Gadget Market Color System
/// Based on Material Design 3 with Deep Purple primary palette
class AppColors {
  AppColors._();

  // === PRIMARY COLORS (Deep Purple) ===
  static const Color primary = Color(0xFF6750A4);
  static const Color primaryLight = Color(0xFF7E67B2);
  static const Color primaryDark = Color(0xFF4A3880);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimaryContainer = Color(0xFF21005D);

  // === SECONDARY COLORS ===
  static const Color secondary = Color(0xFF625B71);
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondaryContainer = Color(0xFF1D192B);

  // === TERTIARY COLORS (Accent) ===
  static const Color tertiary = Color(0xFF7D5260);
  static const Color tertiaryContainer = Color(0xFFFFD8E4);
  static const Color onTertiaryContainer = Color(0xFF31111D);

  // === SURFACE COLORS ===
  static const Color surface = Color(0xFFFFFBFE);
  static const Color surfaceVariant = Color(0xFFF5F0FA);
  static const Color surfaceContainer = Color(0xFFF3EDF7);
  static const Color surfaceContainerHigh = Color(0xFFECE6F0);
  static const Color surfaceContainerHighest = Color(0xFFE6E0E9);

  // === BACKGROUND COLORS ===
  static const Color background = Color(0xFFFFFBFE);
  static const Color scaffoldBackground = Color(0xFFFAF8FC);

  // === TEXT COLORS ===
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textTertiary = Color(0xFF79747E);
  static const Color textDisabled = Color(0xFFB0ACB5);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // === BORDER COLORS ===
  static const Color border = Color(0xFFE7E0EC);
  static const Color borderLight = Color(0xFFF0EBF5);
  static const Color divider = Color(0xFFCAC4D0);

  // === STATUS COLORS ===
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFB3261E);
  static const Color errorLight = Color(0xFFF9DEDC);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // === SPECIAL COLORS ===
  static const Color sale = Color(0xFFE53935);
  static const Color badge = Color(0xFFE53935);
  static const Color rating = Color(0xFFFFB400);
  static const Color overlay = Color(0x80000000);
  static const Color shadow = Color(0x1A000000);

  // === GRADIENT COLORS ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6750A4), Color(0xFF9575CD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFF5F0FA), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // === SHIMMER COLORS ===
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
