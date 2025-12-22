import 'package:flutter/material.dart';
import 'app_colors.dart';

/// نظام الخطوط الكامل للتطبيق
class AppTypography {
  AppTypography._();

  // ============ Headings ============
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.neutral900,
    fontFamily: 'Cairo',
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: AppColors.neutral900,
    fontFamily: 'Cairo',
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.neutral900,
    fontFamily: 'Cairo',
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.neutral900,
    fontFamily: 'Cairo',
  );

  // ============ Body Text ============
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.neutral800,
    fontFamily: 'Cairo',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.neutral800,
    fontFamily: 'Cairo',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.neutral600,
    fontFamily: 'Cairo',
  );

  // ============ Button Text ============
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Colors.white,
    fontFamily: 'Cairo',
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Colors.white,
    fontFamily: 'Cairo',
  );

  // ============ Special Text ============
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.neutral600,
    fontFamily: 'Cairo',
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppColors.neutral600,
    fontFamily: 'Cairo',
  );

  // ============ Price Text ============
  static const TextStyle priceRegular = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary600,
    fontFamily: 'Cairo',
  );

  static const TextStyle priceOld = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.neutral400,
    decoration: TextDecoration.lineThrough,
    fontFamily: 'Cairo',
  );
}
