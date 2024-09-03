import 'package:flutter/material.dart';
import 'package:tbr/src/common_widgets/form/form_header_widget.dart';
import 'package:tbr/src/constants/colors.dart';
import 'package:tbr/src/constants/image_strings.dart';
import 'package:tbr/src/constants/sizes.dart';
import 'package:tbr/src/constants/text_strings.dart';
import 'package:tbr/src/features/authentication/screens/singup/signup_form_widget.dart';

import '../login/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(tbrDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHeaderWidget(
                  image: tWelcomeScreenImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle),
              SignupFormWidget(),
              Column(
                children: [
                  const Text("OR"),
                  SizedBox(height: tbrFormHeight - 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image(
                          image: AssetImage(tGoogleLogoImage), width: 20.0),
                      label: Text(tSignInWithGoogle.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen()), // Replace NextScreen with the name of your screen
                      );
                    },
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: tAlreadyHaveAnAccount,
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(text: tLogin.toUpperCase()),
                    ])),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
