import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tbr/src/constants/colors.dart';
import 'dart:convert';

class Book {
  final String title;
  final String coverImageUrl;

  Book({
    required this.title,
    required this.coverImageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',
      coverImageUrl: json['cover_image'] ?? '',
    );
  }
}

Future<List<Book>> fetchBooksByAuthor(int authorId) async {
  final response = await http.get(
    Uri.parse(
        'https://recommend.orbixcode.com/recommend/api/authors/$authorId/books'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((book) => Book.fromJson(book)).toList();
  } else {
    throw Exception('Failed to load books');
  }
}

class AuthorBooksList extends StatelessWidget {
  final int authorId;

  AuthorBooksList({required this.authorId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: fetchBooksByAuthor(authorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No books found for this author.'),
          );
        } else {
          return GridView.builder(
            controller: ScrollController(), // Adding a scroll controller
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Two books per row
              crossAxisSpacing: 6.0, // Decreased horizontal spacing
              mainAxisSpacing: 8.0, // Decreased vertical spacing
              childAspectRatio: 0.6, // Adjusted aspect ratio for better fit
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailsPage(
                        bookName: book.title,
                        bookId: index, // Replace with actual book ID
                        authorName:
                            'Author Name', // Replace with actual author name
                      ),
                    ),
                  ); */
                },
                child: Container(
                  margin: EdgeInsets.all(4.0), // Decreased margin between items
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio:
                              0.7, // Adjust this to match your desired image ratio
                          child: Image.network(
                            book.coverImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 4), // Space between image and title
                      Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Truncate text with "..."
                        maxLines: 1, // Ensure only one line is displayed
                      ),
                      SizedBox(height: 2), // Space between title and ratings
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14, // Adjusted icon size
                            color: Colors.orange,
                          ),
                          Icon(
                            Icons.star,
                            size: 14, // Adjusted icon size
                            color: Colors.orange,
                          ),
                          Icon(
                            Icons.star,
                            size: 14, // Adjusted icon size
                            color: Colors.orange,
                          ),
                          Icon(
                            Icons.star_half,
                            size: 14, // Adjusted icon size
                            color: Colors.orange,
                          ),
                          Icon(
                            Icons.star_outline,
                            size: 14, // Adjusted icon size
                            color: Colors.orange,
                          ),
                          SizedBox(width: 4), // Space between stars and count
                          Text(
                            '(100)', // Replace with actual count if available
                            style: TextStyle(
                              fontSize: 10, // Adjusted font size
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
