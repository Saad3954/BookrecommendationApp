import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
      ),
      foregroundColor: tSecondaryColor,
      side: BorderSide(color: tSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Add vertical and horizontal padding
      textStyle: TextStyle(fontSize: 16), // Ensuring the font size is consistent
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
      ),
      foregroundColor: tPrimaryColor,
      side: BorderSide(color: tPrimaryColor),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Add vertical and horizontal padding
      textStyle: TextStyle(fontSize: 16), // Ensuring the font size is consistent
    ),
  );
}
