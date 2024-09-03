import 'package:flutter/material.dart';
import 'package:tbr/src/features/authentication/screens/login/login_screen.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

import 'package:http/http.dart' as http;

class SignupFormWidget extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUp(BuildContext context, String fullName, String email, String password) async {
    final String apiUrl = 'https://recommend.orbixcode.com/recommend/api/signup'; // Replace with your signup API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'name': fullName,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Signup successful
        debugPrint('Signup Successful');

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Signed up successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );


        fullNameController.clear();
        emailController.clear();
        passwordController.clear();

        // Redirect to dashboard screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

      } else {
        // Signup failed
        debugPrint('Signup Failed: ${response.body}');
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Something went wrong.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Handle any exceptions that occur during the HTTP request
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;
    Color cursorColor = currentBrightness == Brightness.light ? tSecondaryColor : tPrimaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: fullNameController,
              cursorColor: cursorColor, // Customize cursor color as needed
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(
                  Icons.person_outline_outlined,
                  // color: tSecondaryColor, // Customize icon color as needed
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              cursorColor: cursorColor, // Customize cursor color as needed
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  // color: tSecondaryColor, // Customize icon color as needed
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              cursorColor: cursorColor, // Customize cursor color as needed
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  // color: tSecondaryColor, // Customize icon color as needed
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String fullName = fullNameController.text.trim();
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  signUp(context,fullName, email, password);
                },
                child: Text('Sign Up'.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// class SignupFormWidget extends StatelessWidget {
//   const SignupFormWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding:
//       const EdgeInsets.symmetric(vertical: tbrFormHeight - 10),
//       child: Form(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               cursorColor: tSecondaryColor,
//               decoration: const InputDecoration(
//                 label: Text(tFullName),
//                 prefixIcon: Icon(
//                   Icons.person_outline_outlined,
//                   color: tSecondaryColor,
//                 ),
//               ),
//             ),
//             SizedBox(height: tbrFormHeight - 20),
//             TextFormField(
//               cursorColor: tSecondaryColor,
//               decoration: const InputDecoration(
//                 label: Text(tEmail),
//                 prefixIcon: Icon(
//                   Icons.email_outlined,
//                   color: tSecondaryColor,
//                 ),
//               ),
//             ),
//             SizedBox(height: tbrFormHeight - 20),
//             TextFormField(
//               cursorColor: tSecondaryColor,
//               decoration: const InputDecoration(
//                 label: Text(tPassword),
//                 prefixIcon: Icon(
//                   Icons.fingerprint,
//                   color: tSecondaryColor,
//                 ),
//               ),
//             ),
//             SizedBox(height: tbrFormHeight - 10),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                   onPressed: () {}, child: Text(tSignup.toUpperCase())),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }