/// ثوابت التطبيق
class AppConstants {
  AppConstants._();

  // ============ Spacing ============
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0; // Default
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  // ============ Border Radius ============
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0; // Default
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // ============ Elevation ============
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // ============ Animation Duration ============
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============ Hero Carousel ============
  static const Duration heroAutoPlayInterval = Duration(seconds: 5);
  static const int heroImageCount = 5;

  // ============ App Info ============
  static const String appName = 'متجري';
  static const String appVersion = '1.0.0';
  static const String companyName = 'شركة التجارة الإلكترونية المحدودة';
  static const String commercialRegister = '1234567890';
  static const String licenseNumber = 'LIC-2024-5678';
  static const String companyAddress = 'الرياض، المملكة العربية السعودية\nطريق الملك فهد، برج الأعمال';
}
