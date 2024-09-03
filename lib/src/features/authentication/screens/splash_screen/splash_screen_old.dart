import 'package:flutter/material.dart';
import 'package:tbr/src/constants/sizes.dart';
import 'package:tbr/src/constants/text_strings.dart';
import '../../../../constants/image_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          // Positioned(
          //     top: 0,
          //     left: 0,
          //     child: Image(image: AssetImage(tbrSplashImage),)
          // ),
          Positioned(
              top: 80,
              left: tbrDefaultSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tbrAppName),
                  Text(tbrAppTagLine),
                ],
              )
          ),
          Positioned(
              bottom: 80,
              child: Image(image: AssetImage(tbrSplashImage))
          ),
        ],
      ),
    );
  }
}
