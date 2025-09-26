# Firebase Setup (Unique School System)

1. Create a Firebase project named "Unique School System".
2. Add an Android app:
   - Package name: use com.itsmeirtza.unique_school_app (or the package in android/app/src/main/AndroidManifest.xml once generated).
   - Download google-services.json and place it into unique_school_app/android/app/ (already placed here).
3. Enable Authentication -> Email/Password (optionally Phone).
4. Create Firestore database (Start in test mode for development).
5. Enable Cloud Storage (for images/docs).
6. For push notifications, configure Firebase Cloud Messaging.
7. In Flutter project, after running `flutter create .` inside unique_school_app, update gradle files if needed:
   - Project-level android/build.gradle: ensure classpath 'com.google.gms:google-services:4.3.15' (or latest) in buildscript dependencies.
   - App-level android/app/build.gradle: apply plugin: 'com.google.gms.google-services' at bottom.
8. Initialize Firebase in Dart before runApp (e.g., in main() add Firebase.initializeApp()).
9. When ready for production, tighten Firestore rules to restrict access by role and auth.uid.
