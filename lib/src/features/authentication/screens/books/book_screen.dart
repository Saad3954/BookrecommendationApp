import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tbr/src/features/authentication/screens/dashboard/book_details_page.dart';
import 'package:tbr/src/constants/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/* class Book {
  final int bookId;
  final String title;
  final String authorName;
  final String coverImage;

  Book({
    required this.title,
    required this.bookId,
    required this.authorName,
    required this.coverImage,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'] as int,
      title: json['title'] as String,
      authorName: json['author']['name'] as String,
      coverImage: json['cover_image'] as String,
    );
  }
}
 */

class Book {
  final int bookId;
  final String title;
  final String authorName;
  final String coverImage;
  final String publisherCompany;
  final String publisherDate;
  final String pageNumbers;

  Book({
    required this.title,
    required this.bookId,
    required this.authorName,
    required this.coverImage,
    required this.publisherCompany,
    required this.publisherDate,
    required this.pageNumbers,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'] as int,
      title: json['title'] as String,
      authorName: json['author']['name'] as String,
      coverImage: json['cover_image'] as String,
      publisherCompany: json['publisher_company'] as String,
      publisherDate: json['publisher_date'] as String,
      pageNumbers: json['page_numbers'] as String,
    );
  }
}

// Example function to fetch books with pagination
Future<List<Book>> fetchBooks(int page) async {
  final response = await http.get(Uri.parse(
      'https://recommend.orbixcode.com/recommend/api/dashboard?page=$page'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> booksJson = jsonResponse['books'] as List<dynamic>;
    return booksJson
        .map((bookJson) => Book.fromJson(bookJson as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to load books');
  }
}

class BookScreen extends StatefulWidget {
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  List<Book> _books = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchBooks();
      }
    });
  }

  Future<void> _fetchBooks() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newBooks = await fetchBooks(_page);
      setState(() {
        _isLoading = false;
        if (newBooks.isNotEmpty) {
          _books.addAll(newBooks);
          _page++;
        } else {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        centerTitle: true,
        backgroundColor: tSecondaryColorWithOpacity,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Two books per row
                crossAxisSpacing: 6.0, // Decreased horizontal spacing
                mainAxisSpacing: 8.0, // Decreased vertical spacing
                childAspectRatio: 0.6, // Adjusted aspect ratio for better fit
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(
                          bookName: book.title,
                          bookId: book.bookId,
                          authorName: book.authorName,
                          publisherCompany: book.publisherCompany,
                          publisherDate: book.publisherDate,
                          pageNumbers: book.pageNumbers,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.all(2.0), // Decreased margin between items
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio:
                                0.7, // Adjust this to match your desired image ratio
                            child: Image.network(
                              book.coverImage,
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
                        Flexible(
                          // Adjusting content within available space
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Truncate text with "..."
                                maxLines:
                                    1, // Ensure only one line is displayed
                                softWrap:
                                    false, // Prevent text from wrapping to the next line
                              ),
                              SizedBox(
                                  height: 2), // Space between title and ratings
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
                                  SizedBox(
                                      width:
                                          4), // Space between stars and count
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
                      ],
                    ),
                  ),
                );
              },
            ),
            if (_isLoading)
              Positioned(
                bottom: 16,
                left: MediaQuery.of(context).size.width / 2 - 20,
                child: SpinKitFadingCircle(
                  color: tSecondaryColor,
                  size: 50.0,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Icon(Icons.arrow_upward),
        backgroundColor: tSecondaryColorWithOpacity,
      ),
    );
  }
}
