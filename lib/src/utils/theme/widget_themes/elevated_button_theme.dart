import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart';

import '../../../constants/sizes.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Match the border radius
      ),
      backgroundColor: tSecondaryColor,
      foregroundColor: tAccentColor,
      side: BorderSide(color: tSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Match the padding
      textStyle: TextStyle(fontSize: 16), // Ensure the font size is consistent
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Match the border radius
      ),
      backgroundColor: tPrimaryColor,
      foregroundColor: tbrWhiteColor,
      side: BorderSide(color: tSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Match the padding
      textStyle: TextStyle(fontSize: 16), // Ensure the font size is consistent
    ),
  );
}
