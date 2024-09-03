import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'author_books_list.dart';
import 'package:tbr/src/constants/colors.dart';

class AuthorDetailsPage extends StatelessWidget {
  final String authorName;
  final String authorDesignation;
  final String authorImageUrl;
  final int authorId;

  AuthorDetailsPage({
    required this.authorName,
    required this.authorDesignation,
    required this.authorImageUrl,
    required this.authorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(authorName),
        centerTitle: true,
        backgroundColor: tSecondaryColorWithOpacity,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*
             SizedBox(height: 20),
              CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(authorImageUrl),
              onBackgroundImageError: (error, stackTrace) {
                print('Error loading image: $error');
              },
            ),
            SizedBox(height: 20),
            Text(
              authorName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              authorDesignation,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
             */
            SizedBox(
              width: double.infinity, // Full width of the screen
              child: Container(
                color:
                    tSecondaryColorWithOpacity, // Set your desired background color here
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: 16), // Optional padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center align content horizontally
                  children: [
                    /* CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(authorImageUrl),
                      onBackgroundImageError: (error, stackTrace) {
                        print('Error loading image: $error');
                      },
                    ), */
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: authorImageUrl.isNotEmpty
                          ? NetworkImage(authorImageUrl)
                          : AssetImage('assets/images/man.png')
                              as ImageProvider,
                      onBackgroundImageError: (error, stackTrace) {
                        print('Error loading image: $error');
                      },
                      child: authorImageUrl.isEmpty
                          ? Image.asset(
                              'assets/images/man.png',
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    SizedBox(height: 20),
                    Text(
                      authorName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      authorDesignation,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            // Display the list of books by the author
            AuthorBooksList(authorId: authorId),
          ],
        ),
      ),
    );
  }
}
