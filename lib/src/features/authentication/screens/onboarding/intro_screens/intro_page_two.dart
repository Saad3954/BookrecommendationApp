import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart';
import 'package:tbr/src/constants/sizes.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // color: tPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: tbrDefaultSize), // Space between image and text
              // Image as circle
              CircleAvatar(
                radius: 160, // Adjust the radius dynamically
                backgroundImage: AssetImage('assets/images/image2.jpeg'), // Replace with your image path
                backgroundColor: tSecondaryColorWithOpacity,
              ),
              SizedBox(height: tbrDefaultSize), // Space between image and text
              // Title
              Text(
                'Reading and sharing',
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
                  'In Recomreads you can share your reviews on books & also read your friends reviews',
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
