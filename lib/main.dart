import 'package:flutter/material.dart';
import 'package:tbr/src/features/authentication/screens/books/book_screen.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/profile_screen.dart';
import 'package:tbr/src/features/authentication/screens/login/login_screen.dart';
import 'package:tbr/src/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:tbr/src/features/authentication/screens/splash_screen/splash_screen_backup.dart';
import 'package:tbr/src/utils/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Recommendation',
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
      initialRoute: '/splash', // Set SplashScreen as the initial route
      routes: {
        '/login': (context) => LoginScreen(),
        '/splash': (context) => const SplashScreenB(),
        '/onboarding': (context) => OnBoardingScreen(),
        // Add other routes as needed
      },
    );
  }
}
