# 🤖 AI Assistant Instructions for Gadget Market

## Recommended AI: Claude (via Cline Extension in VS Code)

---

## 📁 Project Structure Overview

```
lib/
├── core/theme/           # 🎨 Design System (DO NOT MODIFY without reason)
│   ├── app_colors.dart   # Color palette - Purple family
│   ├── app_typography.dart # Font styles
│   ├── app_spacing.dart  # Spacing tokens
│   └── app_theme.dart    # Material 3 theme
│
├── data/
│   ├── models/           # 📦 Data Models
│   ├── providers/        # 🔄 State Management (Provider)
│   └── repositories/     # 💾 Demo Data (replace with Firebase)
│
└── presentation/
    ├── screens/          # 📱 Full Pages
    └── widgets/          # 🧩 Reusable Components
```

---

## 🎯 Common Tasks & Instructions

### Adding a New Product
```
File: lib/data/repositories/demo_data.dart
Action: Add new Product() to the products list
Follow existing product structure
```

### Changing Colors
```
File: lib/core/theme/app_colors.dart
Primary color: #6750A4 (line 9)
Modify related colors for consistency
```

### Adding a New Screen
```
1. Create file in lib/presentation/screens/[feature]/
2. Add route in lib/presentation/screens/app_shell.dart
3. Follow existing screen patterns
```

### Connecting to Firebase
```
1. Add firebase packages to pubspec.yaml
2. Replace DemoData calls with Firestore queries
3. Models already have toJson()/fromJson() methods
```

---

## ⚠️ Important Rules

1. **Keep Design System Consistent** - Use AppColors, AppTypography, AppSpacing
2. **Use Existing Widgets** - Check lib/presentation/widgets/common/ first
3. **Follow Provider Pattern** - State in providers, UI in screens
4. **Test After Changes** - Run `flutter analyze` before committing

---

## 🔧 VS Code Setup with Claude (Cline)

1. Install "Cline" extension
2. Add Anthropic API key
3. Open project folder
4. Use Cline chat to modify code

### Example Prompts:
- "Add a wishlist feature to the product card"
- "Change the primary color to blue"
- "Add Firebase authentication"
- "Create a new category for 'Laptops'"

---

## 📞 Quick Reference

| Task | File Location |
|------|---------------|
| Add Product | `lib/data/repositories/demo_data.dart` |
| Change Colors | `lib/core/theme/app_colors.dart` |
| Modify Navigation | `lib/presentation/screens/app_shell.dart` |
| Edit Home Page | `lib/presentation/screens/home/home_screen.dart` |
| Cart Logic | `lib/data/providers/cart_provider.dart` |
| Product Card UI | `lib/presentation/widgets/common/product_card.dart` |

---

## 🚀 Run Commands

```bash
flutter pub get          # Install dependencies
flutter run -d chrome    # Run on web
flutter build web        # Build for production
flutter analyze          # Check for errors
```
