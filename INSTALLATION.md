# 📦 Installation Guide

## Method 1: Manual Installation (Recommended)

### Step 1: Create Base Project
```bash
flutter create shop_app
cd shop_app
```

### Step 2: Replace Files
1. Delete the existing `lib/` folder
2. Copy the provided `lib/` folder
3. Copy the provided `assets/` folder
4. Replace `pubspec.yaml` with the provided one

### Step 3: Install Dependencies
```bash
flutter pub get
```

### Step 4: Run
```bash
flutter run -d chrome
```

---

## Method 2: Using Setup Script (Windows Only)

### Step 1: Extract Files
Extract all files to `Desktop\shop_app`

### Step 2: Run Setup Script
Open PowerShell as Administrator in the project folder:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup.ps1
```

The script will:
- Check Flutter installation
- Install dependencies
- Check available devices
- Optionally run the app

---

## Method 3: Quick Start (If Flutter Already Installed)

```bash
cd Desktop\shop_app
flutter pub get
flutter run -d chrome
```

---

## Verifying Installation

### Check Flutter
```bash
flutter doctor
```

Should show:
- ✅ Flutter (Channel stable)
- ✅ Android toolchain
- ✅ Chrome (for web)

### Check Dependencies
```bash
flutter pub get
```

Should complete without errors.

### Check Devices
```bash
flutter devices
```

Should show at least Chrome (web-javascript).

---

## Common Issues

### Issue: "flutter: command not found"

**Solution:**
```bash
# Add Flutter to PATH
# Windows: Add C:\src\flutter\bin to System PATH
# Restart terminal
```

### Issue: "Dependency conflict"

**Solution:**
```bash
flutter clean
flutter pub get
```

### Issue: "No devices available"

**Solution:**
```bash
# Enable web
flutter config --enable-web

# Or start Android emulator
# Or connect physical device
```

### Issue: "Building for Android fails"

**Solution:**
```bash
cd android
gradlew clean
cd ..
flutter pub get
flutter run
```

---

## File Structure After Installation

```
shop_app/
├── android/           (Created by flutter create)
├── ios/              (Created by flutter create)
├── web/              (Created by flutter create)
├── windows/          (Created by flutter create)
├── lib/              (✅ FROM PACKAGE)
│   ├── core/
│   ├── data/
│   ├── features/
│   └── main.dart
├── assets/           (✅ FROM PACKAGE)
│   ├── images/
│   └── icons/
├── pubspec.yaml      (✅ FROM PACKAGE)
└── README.md
```

---

## Next Steps

1. **Customize the app:**
   - Edit colors in `lib/core/theme/app_colors.dart`
   - Add products in `lib/data/dummy_data.dart`
   - Add coupons in `lib/data/providers/cart_provider.dart`

2. **Test features:**
   - Try login (any email/password works)
   - Browse products
   - Add to cart
   - Try coupon codes: SUMMER20, SAVE50, WELCOME

3. **Build for production:**
   ```bash
   flutter build apk --release
   ```

---

## Support

If you encounter any issues:
1. Check README.md
2. Run `flutter doctor`
3. Clean and reinstall: `flutter clean && flutter pub get`

**Happy coding! 🚀**
