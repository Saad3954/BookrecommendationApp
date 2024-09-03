import 'package:flutter/material.dart';
import 'package:tbr/src/constants/image_strings.dart';
import 'package:tbr/src/constants/sizes.dart';
import 'package:tbr/src/constants/text_strings.dart';
import 'package:tbr/src/features/authentication/screens/login/login_form.dart';

import 'login_footer_widget.dart';
import 'login_header_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(tbrDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoginHeaderWidget(size: size),
              LoginForm(),
              const LoginFooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

