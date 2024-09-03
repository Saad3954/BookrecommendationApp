import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart';
import 'package:tbr/src/constants/image_strings.dart';
import 'package:tbr/src/constants/sizes.dart';
import 'package:tbr/src/constants/text_strings.dart';
import 'package:tbr/src/features/authentication/screens/login/login_screen.dart';
import 'package:tbr/src/features/authentication/screens/singup/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      // backgroundColor: isDarkMode ? tSecondaryColor : tPrimaryColor,
      body: Container(
        padding: EdgeInsets.all(tbrDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width /
                  4, // Adjust the radius dynamically
              backgroundImage: AssetImage('assets/images/image4.jpeg'),
              backgroundColor:
                  tSecondaryColorWithOpacity, // or any other color you prefer
            ),
            // Image(image: AssetImage('assets/images/image4.jpeg'), height: height * 0.6),
            Column(
              children: [
                Text(
                  tWelcomeTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 3),
                Text(
                  tWelcomeSubTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen()), // Replace NextScreen with the name of your screen
                          );
                        },
                        child: Text("Login".toUpperCase()))),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SignupScreen()), // Replace NextScreen with the name of your screen
                          );
                        },
                        child: Text("Signup".toUpperCase()))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
