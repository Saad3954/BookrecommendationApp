import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart';
import 'package:tbr/src/constants/sizes.dart';

class PageOne extends StatelessWidget {
  const PageOne({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: tAccentColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Image as circle
              CircleAvatar(
                radius: 160, // Adjust the radius as needed
                backgroundImage: AssetImage('assets/images/library.jpeg'),
                backgroundColor: tSecondaryColorWithOpacity,// Replace with your image path
              ),
              SizedBox(height: tbrDefaultSize), // Space between image and text
              //
              // CircleAvatar(
              //   radius: MediaQuery.of(context).size.width / 4, // Adjust the radius dynamically
              //   backgroundImage: AssetImage('assets/images/library.jpeg'),
              //   backgroundColor: tSecondaryColorWithOpacity, // or any other color you prefer
              // ),
              SizedBox(height: tbrDefaultSize), // Space between image and text
              // Title
              Text(
                'Create your library',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter Medium'
                ),
              ),
              SizedBox(height: 10), // Space between title and description

              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'In Recomreads you have your own library with you lists',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter'
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
