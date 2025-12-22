
import 'package:flutter/material.dart';

/// نظام الألوان الكامل للتطبيق - درجات البنفسجي
class AppColors {
  // منع إنشاء instance من الكلاس
  AppColors._();

  // ============ الألوان الأساسية (Primary Colors) ============
  static const Color primary100 = Color(0xFFE8DEFF); // بنفسجي فاتح جداً
  static const Color primary200 = Color(0xFFD0BDFF); // بنفسجي فاتح
  static const Color primary300 = Color(0xFFB89CFF); // بنفسجي متوسط فاتح
  static const Color primary400 = Color(0xFFA07BFF); // بنفسجي متوسط
  static const Color primary500 = Color(0xFF8B5CF6); // بنفسجي أساسي ★
  static const Color primary600 = Color(0xFF7C3AED); // بنفسجي داكن
  static const Color primary700 = Color(0xFF6D28D9); // بنفسجي داكن جداً
  static const Color primary800 = Color(0xFF5B21B6); // بنفسجي عميق
  static const Color primary900 = Color(0xFF4C1D95); // بنفسجي أعمق

  // ============ الألوان الثانوية (Secondary Colors) ============
  static const Color secondary100 = Color(0xFFFCE7F3); // وردي فاتح
  static const Color secondary500 = Color(0xFFEC4899); // وردي متوسط
  static const Color accent500 = Color(0xFF10B981); // أخضر للنجاح
  static const Color warning500 = Color(0xFFF59E0B); // برتقالي للتحذير
  static const Color error500 = Color(0xFFEF4444); // أحمر للأخطاء

  // ============ الألوان الحيادية (Neutral Colors) ============
  static const Color neutral50 = Color(0xFFFAFAFA); // أبيض مائل للرمادي
  static const Color neutral100 = Color(0xFFF5F5F5); // رمادي فاتح جداً
  static const Color neutral200 = Color(0xFFEEEEEE); // رمادي فاتح
   static const Color neutral300 = Color(0xFFE5E7EB);
  static const Color neutral400 = Color(0xFFBDBDBD); // رمادي متوسط
  static const Color neutral600 = Color(0xFF757575); // رمادي داكن
  static const Color neutral800 = Color(0xFF424242); // رمادي داكن جداً
  static const Color neutral900 = Color(0xFF212121); // أسود تقريباً

  // ============ الألوان الوظيفية (Functional Colors) ============
  static const Color backgroundPrimary = Color(0xFFFFFFFF); // خلفية رئيسية
  static const Color backgroundSecondary = Color(0xFFF8F7FF); // خلفية بنفسجية خفيفة
  static const Color surface = Color(0xFFFFFFFF); // سطح الكروت
  static const Color divider = Color(0xFFE0E0E0); // فواصل

  // ============ Gradients ============
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary600, primary500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0xCC000000), // شفاف إلى أسود 80%
    ],
  );
}
