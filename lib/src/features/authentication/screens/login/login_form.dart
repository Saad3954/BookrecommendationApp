import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tbr/src/features/authentication/screens/dashboard/dashboard_screen.dart';
import 'package:tbr/src/features/authentication/screens/login/password/forgot_password_page.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    final String apiUrl = 'https://recommend.orbixcode.com/recommend/api/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_data', response.body);
        String? userDataJson = prefs.getString('user_data');
        if (userDataJson != null) {
          Map<String, dynamic> userData = json.decode(userDataJson);
          prefs.setString('token', userData['token']);
        } else {
          print('No user data found in SharedPreferences.');
        }

        // Reset fields
        emailController.clear();
        passwordController.clear();

        // Redirect to dashboard screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email or Password Incorrect. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Handle any exceptions that occur during the HTTP request
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: 'Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye_sharp),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage(),
                    ),
                  );
                },
                child: Text('Forget Password?'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  loginUser(context, email, password); // Pass context here
                },
                child: Text('Login'.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//
// class LoginForm extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   Future<void> loginUser(String email, String password) async {
//     final String apiUrl = 'https://recommend.orbixcode.com/recommend/api/login'; // Replace with your Laravel API endpoint
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         body: {
//           'email': email,
//           'password': password,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         debugPrint('Login Successful');
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString('user_data', response.body);
//         // Reset fields
//         emailController.clear();
//         passwordController.clear();
//
//         // Redirect to dashboard screen
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => DashboardScreen()), // Replace NextScreen with the name of your screen
//         );
//       } else {
//         debugPrint('Login Failed');
//       }
//     } catch (error) {
//       // Handle any exceptions that occur during the HTTP request
//       print('Error: $error');
//     }
//   }
//
//   Future<void> saveUserEmail(String email) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('userEmail', email);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.person_outline_outlined),
//                 labelText: 'Email',
//                 hintText: 'Enter your email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: passwordController,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.fingerprint),
//                 labelText: 'Password',
//                 hintText: 'Enter your password',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   onPressed: null,
//                   icon: Icon(Icons.remove_red_eye_sharp),
//                 ),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {},
//                 child: Text('Forget Password?'),
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   String email = emailController.text.trim();
//                   String password = passwordController.text.trim();
//                   loginUser(email, password);
//                 },
//                 child: Text('Login'.toUpperCase()),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class LoginForm extends StatelessWidget {
//   const LoginForm({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: tbrFormHeight - 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.person_outline_outlined),
//                     labelText: tEmail,
//                     hintText: tEmail,
//                     border: OutlineInputBorder()),
//               ),
//               SizedBox(
//                 height: tbrFormHeight - 20,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.fingerprint),
//                   labelText: tPassword,
//                   hintText: tPassword,
//                   border: OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                       onPressed: null,
//                       icon: Icon(Icons.remove_red_eye_sharp)),
//                 ),
//               ),
//               const SizedBox(height: tbrFormHeight - 20),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                     onPressed: () {}, child: Text(tForgetPassword)),
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   child: Text(tLogin.toUpperCase()),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }