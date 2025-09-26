import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/home_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primary = Color(0xFF0B5ED7); // light-dark blue
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unique School System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: primary, elevation: 2),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primary),
        textTheme: TextTheme(bodyText2: TextStyle(fontFamily: 'Roboto')),
      ),
      home: SplashScreen(),
      routes: {
        '/dashboard': (_) => HomeDashboard(),
      },
    );
  }
}
