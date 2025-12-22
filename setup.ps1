# Shop App - Setup Script for Windows
# Run this script in PowerShell as Administrator

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Shop App - Flutter Setup Script      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "✅ Flutter is already installed" -ForegroundColor Green
    flutter --version
} else {
    Write-Host "❌ Flutter not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Flutter first:" -ForegroundColor Yellow
    Write-Host "1. Download: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
    Write-Host "2. Extract to: C:\src\flutter" -ForegroundColor White
    Write-Host "3. Add to PATH: C:\src\flutter\bin" -ForegroundColor White
    Write-Host ""
    
    $install = Read-Host "Do you want to download Flutter now? (y/n)"
    if ($install -eq "y") {
        Write-Host "Downloading Flutter..." -ForegroundColor Yellow
        $url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip"
        $output = "$env:USERPROFILE\Downloads\flutter.zip"
        
        Invoke-WebRequest -Uri $url -OutFile $output
        
        Write-Host "Extracting Flutter to C:\src\..." -ForegroundColor Yellow
        New-Item -Path "C:\src" -ItemType Directory -Force | Out-Null
        Expand-Archive -Path $output -DestinationPath "C:\src\" -Force
        
        Write-Host "Adding Flutter to PATH..." -ForegroundColor Yellow
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
        $newPath = $currentPath + ";C:\src\flutter\bin"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        
        Write-Host "✅ Flutter installed successfully!" -ForegroundColor Green
        Write-Host "⚠️  Please restart your terminal/VS Code" -ForegroundColor Yellow
    }
    exit
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Checking Flutter environment..." -ForegroundColor Yellow
flutter doctor

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing project dependencies..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencies installed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Checking available devices..." -ForegroundColor Yellow
flutter devices

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup complete! 🎉" -ForegroundColor Green
Write-Host ""
Write-Host "To run the app:" -ForegroundColor Yellow
Write-Host "  flutter run -d chrome          (Web)" -ForegroundColor White
Write-Host "  flutter run                    (Default device)" -ForegroundColor White
Write-Host "  flutter run -d <device-id>     (Specific device)" -ForegroundColor White
Write-Host ""
Write-Host "To build release APK:" -ForegroundColor Yellow
Write-Host "  flutter build apk --release" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Ask if user wants to run the app now
Write-Host ""
$run = Read-Host "Do you want to run the app now on Chrome? (y/n)"
if ($run -eq "y") {
    Write-Host ""
    Write-Host "Starting app on Chrome..." -ForegroundColor Yellow
    flutter run -d chrome
}
