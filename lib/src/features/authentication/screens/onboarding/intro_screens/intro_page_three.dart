import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart';
import '../../../../../constants/sizes.dart';

class PageThree extends StatelessWidget {
  const PageThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // Changed background color to white
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: tbrDefaultSize), // Space between image and text
              // Heading
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: Text(
                    'Select a type of book you enjoy reading',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: tPrimaryColor, // Changed heading text color to primary color
                      fontFamily: "Inter"
                    ),
                  ),
                ),
              ),
              // Genres
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12.0, // Adjust spacing between genres
                runSpacing: 12.0, // Adjust spacing between rows
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          tSecondaryColorWithOpacity),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    label: Text(
                      'Fiction', // Changed button text to primary color
                      style: TextStyle(
                        fontSize: 16,
                        color: tPrimaryColor,
                      ),
                    ),
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: tPrimaryColor,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    label: Text(
                      'Poetry', // Changed button text to primary color
                      style: TextStyle(
                        fontSize: 16,
                        color: tPrimaryColor,
                      ),
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: tPrimaryColor,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    label: Text(
                      'Novel', // Changed button text to primary color
                      style: TextStyle(
                        fontSize: 16,
                        color: tPrimaryColor,
                      ),
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: tPrimaryColor,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    label: Text(
                      'Narrative', // Changed button text to primary color
                      style: TextStyle(
                        fontSize: 16,
                        color: tPrimaryColor,
                      ),
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: tPrimaryColor,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    label: Text(
                      'Non-fiction', // Changed button text to primary color
                      style: TextStyle(
                        fontSize: 16,
                        color: tPrimaryColor,
                      ),
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: tPrimaryColor,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    label: Text(
                      'Mystery', // Changed button text to primary color
                      style: TextStyle(
                        fontSize: 16,
                        color: tPrimaryColor,
                      ),
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: tPrimaryColor,
                    ),
                  ),
                  // Add more genres as needed
                ],
              ),
              // Show More Button
              Center(
                child: TextButton(
                  onPressed: () {
                    // Show popup
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Show More"),
                          content: Text("Popup content goes here."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Show More',
                    style: TextStyle(
                      color: tPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
