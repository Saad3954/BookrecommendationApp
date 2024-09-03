import 'package:flutter/material.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/profile_screen.dart';
import 'book_upload_page.dart';

class RulesAndRegulationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Rules and Regulations',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '''
When uploading or registering a book on our site or app, please adhere to the following guidelines to ensure a smooth and professional process:

1. Compliance with Community Standards and Legal Regulations:
    - All content must adhere to our community standards.
    - Avoid plagiarism, offensive material, and any form of illegal content.

2. Accurate and Complete Metadata:
    - Ensure the book's metadata, including title, author name, genre, and description, is accurate and complete.
    - Accurate metadata helps in correctly categorizing and recommending your book to potential readers.

3. High-Quality Cover Images:
    - Upload high-quality cover images that meet our technical specifications for format and size.
    - A compelling cover image attracts more readers and enhances the professional presentation of your book.

4. File Format and Size Specifications:
    - Ensure all book files meet our technical requirements for format and size.
    - Adhering to these specifications ensures compatibility with our platform and provides a seamless reading experience.

5. Review and Agree to Terms of Service and Privacy Policy:
    - Carefully review our terms of service and privacy policy before final submission.
    - Agreement to these terms is mandatory for the registration of your book on our platform.

6. Quality and Content Verification:
    - Your submission may undergo a review process to ensure it meets our quality standards.
    - Books that do not meet these standards may be subject to removal.

7. Accountability for Violations:
    - Any violations of these rules may result in the removal of your book.
    - Serious or repeated violations could lead to the suspension of your account.

8. Support and Assistance:
    - If you encounter any issues during the upload or registration process, our support team is available to assist you.
    - Contact us via the provided support channels for any questions or concerns.

By following these guidelines, you help us maintain a respectful, high-quality platform that benefits all users. Thank you for your cooperation.
                      ''',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Add space above the buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to book upload page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookUploadPage()),
                        );
                      },
                      child: Text('Proceed'.toUpperCase()),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Add space between the buttons
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Cancel action
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen()),
                        );
                      },
                      child: Text('Cancel'.toUpperCase()),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
