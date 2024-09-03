import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/author_screen.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/dashboard_screen.dart';
import 'package:tbr/src/features/authentication/screens/login/login_screen.dart';
import 'package:tbr/src/features/authentication/screens/welcome/welcome_screen.dart';

import '../../../../constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenB extends StatefulWidget {
  const SplashScreenB({Key? key}) : super(key: key);

  @override
  State<SplashScreenB> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenB> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _imageAnimation;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _imageAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _textAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward().whenComplete(_checkAuthentication);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? userData = prefs.getString('user_data');
    if (userData != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: tSecondaryColorWithOpacity,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _imageAnimation,
              child: ClipOval(
                child: Image.asset(
                  'assets/logo/splash_logo.jpeg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _textAnimation,
              child: const Text(
                "meet your favorite book.",
                style: TextStyle(
                  // fontStyle: FontStyle.italic,
                  fontFamily: '',
                  color: tSecondaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}