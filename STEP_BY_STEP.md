# 📱 Step-by-Step Installation Guide

## 🎯 What You Have

You downloaded a package with:
- `lib/` folder (14 files)
- `assets/` folder  
- `pubspec.yaml` file
- Documentation files

## ⚠️ IMPORTANT

**DO NOT** open this package directly in VS Code!

This is NOT a complete Flutter project. You need to create one first.

---

## 📝 Step-by-Step Instructions

### ✅ Step 1: Open Terminal

**Windows:**
- Press `Win + R`
- Type: `powershell`
- Press Enter

**Or in VS Code:**
- Press `Ctrl + ~`

### ✅ Step 2: Navigate to Desktop

```bash
cd Desktop
```

### ✅ Step 3: Create Flutter Project

```bash
flutter create shop_app
```

Wait 30 seconds. You'll see:
```
Creating project shop_app...
...
All done!
```

### ✅ Step 4: Enter Project Folder

```bash
cd shop_app
```

### ✅ Step 5: Delete Old lib Folder

**Windows Command:**
```bash
rmdir /s /q lib
```

**Or manually:**
- Open File Explorer
- Go to `Desktop\shop_app`
- Delete `lib` folder

### ✅ Step 6: Copy Files from Package

Copy these from the downloaded package to `Desktop\shop_app`:

1. **lib/** folder
   - Copy entire folder

2. **assets/** folder
   - Copy entire folder
   - Create if doesn't exist

3. **pubspec.yaml** file
   - Replace the existing one

**Result:**
```
Desktop\shop_app\
├── android/         (already there)
├── ios/             (already there)
├── lib/             (✅ NEW - from package)
├── assets/          (✅ NEW - from package)
├── pubspec.yaml     (✅ REPLACED)
└── ...
```

### ✅ Step 7: Install Dependencies

```bash
flutter pub get
```

Wait 30 seconds. You'll see:
```
Running "flutter pub get" in shop_app...
...
Got dependencies!
```

### ✅ Step 8: Run the App

**On Chrome (fastest):**
```bash
flutter run -d chrome
```

**On Android Emulator:**
```bash
flutter run
```

**Check devices first:**
```bash
flutter devices
```

---

## 🎉 Success!

You should see:
1. Terminal shows: "Running with sound null safety"
2. App opens in Chrome or Emulator
3. Login screen appears

---

## 🐛 Troubleshooting

### Problem: "flutter: command not found"

**Solution:**

1. Install Flutter from: https://docs.flutter.dev/get-started/install/windows

2. Extract to: `C:\src\flutter`

3. Add to PATH:
   - Press `Win + R`
   - Type: `sysdm.cpl`
   - Advanced tab → Environment Variables
   - Edit "Path" → Add: `C:\src\flutter\bin`

4. Restart terminal

### Problem: "pubspec.yaml not found"

**Solution:**
```bash
# Make sure you're in the right folder
cd Desktop\shop_app
dir
# You should see pubspec.yaml
```

### Problem: "Dependency version conflict"

**Solution:**
```bash
flutter clean
flutter pub get
```

### Problem: "No devices available"

**Solution:**
```bash
# Enable web
flutter config --enable-web

# Check devices
flutter devices

# Run on chrome
flutter run -d chrome
```

---

## 📹 Visual Guide

### Before (Downloaded Package):
```
shop_app_clean/
├── lib/
├── assets/
└── pubspec.yaml
```

### After (Complete Project):
```
shop_app/                    (created by flutter create)
├── android/                 (created by flutter create)
├── ios/                     (created by flutter create)
├── lib/                     (✅ from package)
├── assets/                  (✅ from package)
└── pubspec.yaml             (✅ from package)
```

---

## ⚡ Quick Command Summary

```bash
# 1. Create project
cd Desktop
flutter create shop_app
cd shop_app

# 2. Delete old lib
rmdir /s /q lib

# 3. Copy lib/, assets/, pubspec.yaml from package

# 4. Install
flutter pub get

# 5. Run
flutter run -d chrome
```

---

## 📞 Still Having Issues?

1. Run: `flutter doctor`
2. Check Flutter version: `flutter --version`
3. Make sure Flutter SDK ≥ 3.5.0

**Need help? Read README.md for detailed information.**

---

**Happy coding! 🚀💜**
