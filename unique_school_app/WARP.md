# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Repository type: Flutter app with Firebase (Auth, Firestore, Storage, Messaging) and Provider for state management. Android build is configured (compileSdk 35, Google Services plugin). No existing WARP.md or README found.

- Primary entry point: lib/main.dart
- State: lib/providers/* (AuthProvider, ThemeProvider, FirestoreProvider)
- Notifications: lib/services/push_notifications.dart
- UI: lib/screens/* and theme/app_theme.dart
- Assets declared in pubspec.yaml (assets/logo, assets/animations, assets/3d)

Common commands (run from repo root)

- Setup
  ```powershell path=null start=null
  flutter pub get
  ```

- Run the app (Android)
  ```powershell path=null start=null
  # List devices
  flutter devices

  # Run on a specific device (replace <device_id> from the list)
  flutter run -d <device_id>
  ```

- Analyze and format
  ```powershell path=null start=null
  # Static analysis (uses flutter_lints via pubspec)
  flutter analyze

  # Format Dart code in-place
  dart format .

  # (Optional) apply recommended fixes
  dart fix --apply
  ```

- Tests
  Note: flutter_test is declared but no test files were found yet.
  ```powershell path=null start=null
  # Run all tests
  flutter test

  # Run a single test file
  flutter test test/<file>_test.dart

  # Run tests matching a name pattern
  flutter test -n "pattern"
  ```

- Build (Android)
  ```powershell path=null start=null
  # Debug run is usually sufficient during development (flutter run)
  
  # Release APK
  flutter build apk --release

  # Play Store bundle
  flutter build appbundle --release
  ```

Android + Firebase notes

- The Android module applies: id 'com.google.gms.google-services' and uses the Firebase BoM. Ensure android/app/google-services.json is present (not committed) before running release builds or Firebase features.
- MultiDex is enabled; compileSdkVersion/targetSdkVersion are 35.

Architecture overview

- App entry and bootstrap (lib/main.dart)
  - Ensures WidgetsFlutterBinding, sets system UI overlays, registers FirebaseMessaging background handler, initializes Firebase, and initializes PushNotificationService before runApp.
  - Wraps MaterialApp in a MultiProvider (ThemeProvider and AuthProvider).
  - Routes:
    - '/' resolved by AuthWrapper -> HomeDashboard when authenticated, SplashScreen otherwise
    - Named: '/dashboard', '/splash'

- State management (Provider)
  - ThemeProvider: ChangeNotifier that persists ThemeMode to SharedPreferences and exposes user-friendly labels/icons.
  - AuthProvider: Wraps FirebaseAuth, manages loading/error state, email/password auth, password reset, email verification helpers, and persists a user-specific role (parent/teacher) in SharedPreferences. Listens to authStateChanges and updates UI via notifyListeners.
  - FirestoreProvider: Thin data layer for writes to Cloud Firestore (user profiles for parents/teachers, class student star-of-the-month toggle).

- Notifications (Firebase Messaging + Local Notifications)
  - lib/services/push_notifications.dart centralizes FCM setup, permission requests, Android channel creation, and foreground display via flutter_local_notifications.
  - Background handler is a top-level @pragma('vm:entry-point') function (firebaseMessagingBackgroundHandler).
  - Topic subscription helpers normalize class names (class_<normalized>) and persist subscription state to SharedPreferences.

- UI composition
  - AuthScreen: Tab-based Sign In / Sign Up with role-aware title, form validation, and integration with AuthProvider (navigates to '/dashboard' on success).
  - HomeDashboard: Demo data for classes and a star toggle (with a TODO to persist in Firestore via FirestoreProvider).
  - AppTheme (theme/app_theme.dart): Provides light/dark themes used by MaterialApp based on ThemeProvider.themeMode.

What Warp should prioritize

- Use flutter analyze and dart format before suggesting diffs affecting many files.
- Prefer Provider patterns already established (ChangeNotifier + Consumer) when adding app-level state.
- For Firebase features in Android builds, ensure google-services.json exists locally before attempting release builds.
