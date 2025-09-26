# Unique School System - Flutter Scaffold

This repository contains the Flutter app in `unique_school_app/`.

Highlights:
- Splash with Lottie + Rive + 3D placeholder
- Parent & Teacher forms
- Dashboard with Star-of-the-Month demo
- Firebase packages planned (google-services.json placed)
- GitHub Actions workflow to build APK automatically

Quick start (Windows):
1) Install Flutter and add to PATH (PowerShell):
   - winget install -e --id Flutter.Flutter
2) Create platform folders, fetch deps, run:
```powershell
cd unique_school_app
flutter create .
flutter pub get
flutter run
```

Common commands:
- Analyze: `flutter analyze`
- Test all: `flutter test`
- Run one test: `flutter test test/path_to_test.dart`
- Build APK: `flutter build apk --release`

Firebase:
- See `unique_school_app/FIREBASE_SETUP.md`.
- Android JSON is already at `unique_school_app/android/app/google-services.json`.

CI/CD:
- GitHub Actions workflow is at `.github/workflows/build-android.yml` and is configured to work from `unique_school_app/`.
