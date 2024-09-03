import 'package:flutter/material.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/dashboard_screen.dart';
import 'package:tbr/src/features/authentication/screens/singup/signup_screen.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  Future<void> googleLogin(BuildContext context) async {
    print("googleLogin method Called");
    final _googleSignIn = GoogleSignIn();
    var result = await _googleSignIn.signIn();

    if (result != null) {
      // Extract user details from GoogleSignInAccount
      String displayName = result.displayName ?? "Unknown";
      String email = result.email;
      String photoUrl = result.photoUrl ?? "";

      // Create a map to store user details in the required structure
      Map<String, dynamic> userData = {
        'user': {
          'name': displayName,
          'email': email,
          'profile_picture': photoUrl,
        }
      };

      // Convert the map to a JSON string
      String userDataJson = json.encode(userData);

      // Save user details to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', userDataJson);

      // Retrieve and use the saved user data
      String? retrievedUserDataJson = prefs.getString('user_data');
      if (retrievedUserDataJson != null) {
        Map<String, dynamic> retrievedUserData =
            json.decode(retrievedUserDataJson);
        print(retrievedUserData);

        // Optionally, save a specific field like a token (if available)
        // prefs.setString('token', retrievedUserData['user']['token']);
      } else {
        print('No user data found in SharedPreferences.');
      }

      // Show result in a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signed in as: $displayName"),
          duration: Duration(seconds: 3),
        ),
      );
      // Redirect to dashboard screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      print("Google Sign-In failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("OR"),
        SizedBox(height: tbrFormHeight - 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image(
              image: AssetImage(tGoogleLogoImage),
              width: 20.0,
            ),
            onPressed: () {
              googleLogin(context);
            },
            label: Text(tSignInWithGoogle),
          ),
        ),
        SizedBox(height: tbrFormHeight - 20),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SignupScreen()), // Replace NextScreen with the name of your screen
            );
          },
          child: Text.rich(TextSpan(
              text: tDontHaveAnAccount,
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(text: tSignup, style: TextStyle(color: Colors.blue)),
              ])),
        ),
      ],
    );
  }
}
