import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center, // Center align the children
        children: [
          CircleAvatar(
            radius: size.height * 0.1, // Adjust the radius as needed
            backgroundImage: AssetImage('assets/images/image1.jpeg'),
          ),
          SizedBox(height: 20.0), // Add some space between the image and title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center, // Center the text
          ),
          SizedBox(height: 10.0), // Add some space between the title and subtitle
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center, // Center the text
          ),
        ],
      ),
    );
  }
}
