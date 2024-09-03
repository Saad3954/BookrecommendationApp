import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget  {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with
    SingleTickerProviderStateMixin{

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  //
  //   Future.delayed(const Duration(seconds: 2), (){
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (_) => const OnBoardingScreen(),
  //     ));
  //   });
  // }

  @override
  // void dispose() {
  //   // TODO: implement dispose
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFBBDEFB), Colors.deepPurpleAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.library_books,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height:20),
            Text(
              "Book Recomendation",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontSize: 32
              ),
            )
          ],
        ),
      ),
    );
  }
}

