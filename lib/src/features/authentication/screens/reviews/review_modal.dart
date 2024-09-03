import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Add this dependency in pubspec.yaml
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void showReviewModal(BuildContext context, int bookId, int userId) {
  final _commentController = TextEditingController();
  double _rating = 0.0;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Write a Review',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              itemSize: 30.0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _rating = rating;
              },
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Write your comment',
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final comment = _commentController.text;
                if (_rating > 0 && comment.isNotEmpty) {
                  // Call your API to save the review
                  await saveReview(bookId, userId, _rating, comment);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please provide a rating and comment')),
                  );
                }
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> saveReview( int bookId, int userId, double rating, String comment) async {
  try {
    final response = await http.post(
      Uri.parse('https://recommend.orbixcode.com/recommend/api/review/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'book_id': bookId,
        'user_id': userId,
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Review saved successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      // Print the response body and status code for debugging
      print('Failed to save review: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to save review: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    // Print the error for debugging
    print('Error: $e');
    Fluttertoast.showToast(
      msg: "Error saving review: $e",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    // Rethrow the error to be caught by the caller
    throw e;
  }
}


Future<void> saveReviewold(int bookId, int userId, double rating, String comment) async {
  // Implement your API call to save the review here
  final response = await http.post(
    Uri.parse('https://recommend.orbixcode.com/recommend/api/review/add'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'book_id': bookId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
    }),
  );
  print("Created Review...");
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
      msg: "Review saved successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else {
    throw Exception('Failed to save review');
  }
}
