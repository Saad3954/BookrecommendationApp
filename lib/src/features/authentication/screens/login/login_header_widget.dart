import 'package:flutter/material.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/text_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0), // Standard space from the top
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Align items at the start of the column
        children: [
          ClipOval(
            child: Image(
              image: AssetImage('assets/images/image3.jpeg'),
              height: size.height * 0.2,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 20.0), // Space between image and title
          Center(
            child: Text(
              tLoginTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center, // Center the text
            ),
          ),
          SizedBox(height: 10.0), // Space between title and subtitle
          Center(
            child: Text(
              tLoginSubTitle,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center, // Center the text
            ),
          ),
        ],
      ),
    );
  }
}
