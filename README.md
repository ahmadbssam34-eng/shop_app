# 🛍️ Shop App - E-Commerce Flutter Application

Modern e-commerce app with purple theme, built with Flutter.

---

## 📋 Prerequisites

- Flutter SDK 3.5.0 or higher
- Dart SDK 3.5.0 or higher
- Android Studio (for Android Emulator)
- VS Code or Android Studio IDE

---

## 🚀 Installation Steps

### Step 1: Create Flutter Project

```bash
cd Desktop
flutter create shop_app
cd shop_app
```

### Step 2: Replace Files

Replace these files/folders from the downloaded package:

- Delete existing `lib/` folder
- Copy new `lib/` folder
- Copy `assets/` folder
- Replace `pubspec.yaml`

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Run the App

**Option A: Chrome (Web)**
```bash
flutter run -d chrome
```

**Option B: Android Emulator**
```bash
# Start your emulator first, then:
flutter run
```

**Option C: Check Available Devices**
```bash
flutter devices
flutter run -d <device-id>
```

---

## 📁 Project Structure

```
shop_app/
├── lib/
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_typography.dart
│   │   │   └── app_theme.dart
│   │   ├── widgets/
│   │   │   └── product_card.dart
│   │   └── constants/
│   │       └── app_constants.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── product_model.dart
│   │   │   └── cart_item_model.dart
│   │   ├── providers/
│   │   │   └── cart_provider.dart
│   │   └── dummy_data.dart
│   ├── features/
│   │   ├── auth/
│   │   │   └── presentation/screens/login_screen.dart
│   │   ├── home/
│   │   │   └── presentation/screens/home_screen.dart
│   │   ├── products/
│   │   │   └── presentation/screens/product_detail_screen.dart
│   │   └── cart/
│   │       └── presentation/screens/cart_screen.dart
│   └── main.dart
├── assets/
│   ├── images/
│   └── icons/
└── pubspec.yaml
```

---

## ✨ Features

### Implemented
- ✅ Login Screen (Email, Google, Phone)
- ✅ Home Screen with Hero Carousel (auto-rotates every 5s)
- ✅ Product Categories & Filtering
- ✅ Product Detail Page with Gallery
- ✅ Shopping Cart with Quantity Control
- ✅ Coupon System (SUMMER20, SAVE50, WELCOME)
- ✅ Auto Shipping Calculation
- ✅ RTL Support for Arabic
- ✅ Purple Theme Design System

### Coupon Codes
| Code | Discount |
|------|----------|
| `SUMMER20` | 20% off |
| `SAVE50` | 50 SAR off |
| `WELCOME` | 10% off |

---

## 🎨 Color Palette

```dart
Primary Colors (Purple):
- Primary 500: #8B5CF6 (Main)
- Primary 600: #7C3AED
- Primary 700: #6D28D9

Functional Colors:
- Success: #10B981
- Warning: #F59E0B
- Error: #EF4444
```

---

## 🔧 Troubleshooting

### Error: "Flutter SDK not found"

```bash
# Add Flutter to PATH (Windows PowerShell)
[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")

# Verify
flutter doctor
```

### Error: "Dependency version conflict"

```bash
flutter clean
flutter pub get
```

### Error: "No devices available"

```bash
# Enable web
flutter config --enable-web

# Check devices
flutter devices

# Run on chrome
flutter run -d chrome
```

### Error: "Android build fails"

```bash
cd android
./gradlew clean
cd ..
flutter run
```

---

## 📱 Running on Physical Device

### Android
1. Enable Developer Options on your phone
2. Enable USB Debugging
3. Connect phone via USB
4. Run: `flutter devices`
5. Run: `flutter run`

---

## 🏗️ Building Release APK

```bash
# Build release APK
flutter build apk --release

# Output location:
# build/app/outputs/flutter-apk/app-release.apk

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

---

## 📊 Project Stats

- **Files:** 14 Dart files
- **Lines of Code:** ~1,800
- **Screens:** 4 main screens
- **Features:** 20+ features
- **Dependencies:** 12 packages

---

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 📝 Adding Products

Edit `lib/data/dummy_data.dart`:

```dart
Product(
  id: 'new_id',
  title: 'Product Name',
  description: 'Product description...',
  price: 299.0,
  originalPrice: 399.0,
  discountPercentage: 25,
  imageUrl: 'https://example.com/image.jpg',
  category: 'Electronics',
  brand: 'Brand Name',
  rating: 4.5,
  reviewCount: 100,
  stock: 20,
),
```

---

## 🎟️ Adding Coupons

Edit `lib/data/providers/cart_provider.dart`:

```dart
final coupons = {
  'NEWCODE': 0.15,  // 15% off
  'FIXED100': 100.0, // 100 SAR off
};
```

---

## 🌐 Multi-Language Support

Current: Arabic (RTL) + English support ready

To add more languages, edit `main.dart`:

```dart
supportedLocales: const [
  Locale('ar', 'SA'),
  Locale('en', 'US'),
  Locale('fr', 'FR'), // Add new language
],
```

---

## 📞 Support

For issues or questions:
1. Check Flutter version: `flutter --version`
2. Run: `flutter doctor`
3. Clean project: `flutter clean && flutter pub get`

---

## 📄 License

MIT License - Feel free to use for learning and commercial projects.

---

## 🎉 Quick Start Summary

```bash
# 1. Create project
flutter create shop_app && cd shop_app

# 2. Replace lib/ assets/ pubspec.yaml with downloaded files

# 3. Install
flutter pub get
update test

# 4. Run
flutter run -d chrome
```

**Enjoy building! 🚀💜**
local change test