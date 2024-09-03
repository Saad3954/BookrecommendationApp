import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
      borderSide: BorderSide(color: Colors.grey), // Customize the color as needed
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
      borderSide: BorderSide(width: 2, color: tSecondaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
      borderSide: BorderSide(color: Colors.red), // Customize the color as needed
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
      borderSide: BorderSide(width: 2, color: Colors.red), // Customize the color as needed
    ),
    prefixIconColor: tSecondaryColor,
    floatingLabelStyle: TextStyle(color: tSecondaryColor),
  );

  static InputDecorationTheme darkInputDecorationTheme = const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
      borderSide: BorderSide(color: Colors.grey), // Customize the color as needed
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
      borderSide: BorderSide(width: 2, color: tPrimaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
      borderSide: BorderSide(color: Colors.red), // Customize the color as needed
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(17.0)), // Increased border radius
      borderSide: BorderSide(width: 2, color: Colors.red), // Customize the color as needed
    ),
    prefixIconColor: tPrimaryColor,
    floatingLabelStyle: TextStyle(color: tPrimaryColor),
  );
}
