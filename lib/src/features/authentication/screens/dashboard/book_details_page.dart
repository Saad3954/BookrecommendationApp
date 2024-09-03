import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tbr/src/constants/colors.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/genre_page.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/my_books.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tbr/src/features/authentication/screens/reviews/review_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetailsPage extends StatefulWidget {
  final int bookId;
  final String bookName;
  final String authorName;
  final String publisherCompany;
  final String publisherDate;
  final String pageNumbers;

  BookDetailsPage({
    required this.bookId,
    required this.bookName,
    required this.authorName,
    required this.publisherCompany,
    required this.publisherDate,
    required this.pageNumbers,
  });

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late Future<Book> bookFuture;

  @override
  void initState() {
    super.initState();
    bookFuture = fetchBookDetails(widget.bookId);
  }

  Future<Book> fetchBookDetails(int bookId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://recommend.orbixcode.com/recommend/api/books/$bookId'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Book.fromJson(jsonResponse['book']);
      } else {
        throw Exception('Failed to load book details');
      }
    } catch (e) {
      print('Error fetching book details: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tSecondaryColorWithOpacity,
        title: Text('Book Details'),
      ),
      body: Stack(
        children: [
          FutureBuilder<Book>(
            future: bookFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitFadingCircle(
                    color: tSecondaryColor,
                    size: 50.0,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                final book = snapshot.data!;
                return Column(
                  children: [
                    HeaderWidget(
                      bookName: book.title,
                      authorName: widget.authorName,
                      coverImageUrl: book.coverImage,
                      summary: book.summary,
                      publisherCompany: book.publishingCompany,
                      publisherDate: book.publishDate,
                      pageNumbers: book.numberOfPages,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: BodyWidget(book: book),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text('No data found'),
                );
              }
            },
          ),
          Positioned(
            top:
                200.0, // Adjust this value according to your header widget height
            left: 0,
            right: 0,
            bottom: 0,
            child: FutureBuilder<Book>(
              future: bookFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text('Loading..'),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: BodyWidget(book: snapshot.data!),
                  );
                } else {
                  return Center(
                    child: Text('No data found'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String bookName;
  final String authorName;
  final String publisherCompany;
  final String publisherDate;
  final String pageNumbers;
  final String coverImageUrl;
  final String summary;

  HeaderWidget({
    required this.bookName,
    required this.authorName,
    required this.publisherCompany,
    required this.publisherDate,
    required this.pageNumbers,
    required this.coverImageUrl,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tSecondaryColorWithOpacity, // Header background color
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book image
          Container(
            width: 100.0,
            height: 150.0,
            decoration: BoxDecoration(
              color: Colors.white, // Image background color
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(coverImageUrl), // Placeholder image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating stars
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: tPrimaryColor,
                      size: 18.0,
                    ),
                    Icon(
                      Icons.star,
                      color: tPrimaryColor,
                      size: 18.0,
                    ),
                    Icon(
                      Icons.star,
                      color: tPrimaryColor,
                      size: 18.0,
                    ),
                    Icon(
                      Icons.star,
                      color: tPrimaryColor,
                      size: 18.0,
                    ),
                    Icon(
                      Icons.star_half,
                      color: tPrimaryColor,
                      size: 18.0,
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                // Book name
                Text(
                  bookName,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0),
                // Author name
                Text(
                  'Author: $authorName',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white, // Text color
                  ),
                ),
                SizedBox(height: 10.0),
                // Publisher Company
                Text(
                  'Publisher: $publisherCompany',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white, // Text color
                  ),
                ),

                SizedBox(height: 10.0),
                // Publisher Company
                Text(
                  'Publisher Date: $publisherDate',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white, // Text color
                  ),
                ),
                SizedBox(height: 10.0),
                // Publisher Company
                Text(
                  'Pages: $pageNumbers',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white, // Text color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  final Book book;

  BodyWidget({required this.book});

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  Map<String, dynamic>? userData;
  String? _authToken;
  List<dynamic> _shelves = [];

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('user_data');
    String? authToken = prefs.getString('token');

    if (userDataJson != null) {
      setState(() {
        userData = json.decode(userDataJson);
        _authToken = authToken;
      });
      _fetchShelves();
    } else {
      print('No user data found in SharedPreferences.');
    }
  }

  Future<List<Review>> fetchReviews(int bookId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://recommend.orbixcode.com/recommend/api/books/$bookId/reviews'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      rethrow;
    }
  }

  Future<void> _fetchShelves() async {
    if (_authToken == null) return;

    final response = await http.get(
      Uri.parse('https://recommend.orbixcode.com/recommend/api/shelves'),
      headers: {
        'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> shelves = json.decode(response.body);
      setState(() {
        _shelves = shelves;
      });
    } else {
      print('Failed to load shelves, response: ${response.body}');
      // Optionally, show an error message or handle the error case here.
    }
  }

  void _showAddToShelfModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int? selectedShelfId; // To keep track of selected shelf

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select Shelf"),
              content: _shelves.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _shelves.map((shelf) {
                        return RadioListTile<int>(
                          title: Text(shelf['name']),
                          value: shelf['id'],
                          groupValue: selectedShelfId,
                          activeColor: tSecondaryColor,
                          onChanged: (int? value) {
                            setState(() {
                              selectedShelfId = value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: tSecondaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedShelfId != null) {
                      _addBookToShelf(selectedShelfId!);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a shelf')));
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(color: tSecondaryColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addBookToShelf(int shelfId) async {
    if (_authToken == null) return;

    final bookId = widget.book.bookId; // Assuming this is the actual book ID

    // Print the shelfId and bookId
    print('Shelf ID: $shelfId');
    print('Book ID: $bookId');

    final response = await http.post(
      Uri.parse(
          'https://recommend.orbixcode.com/recommend/api/shelves/add-book-shelf'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'shelf_id': shelfId,
        'book_id': bookId,
      }),
    );

    if (response.statusCode == 200) {
      // Book added successfully
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book added to shelf successfully')));
    } else {
      // Handle errors
      print('Failed to add book to shelf: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row for help icon, dropdown, and download icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Help icon
              IconButton(
                icon: Icon(Icons.help),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Help icon clicked')));
                },
              ),
              // Dropdown to select book status
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 0.5, horizontal: 7.0), // Adjusted padding
                decoration: BoxDecoration(
                  border: Border.all(color: tSecondaryColor), // Border color
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                ),
                child: DropdownButton<String>(
                  value: 'Add to shelve', // Pre-selected value
                  items: <String>['Add to shelve'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    _showAddToShelfModal(
                        context); // Show modal instead of navigating
                    /*  ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected: $newValue')));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyBookScreen()),
                    ); */
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  elevation: 0,
                  iconSize: 24, // Adjusted dropdown icon size
                  underline: SizedBox(), // Remove default underline
                ),
              ),
              // Download icon
              IconButton(
                icon: Icon(Icons.download),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Download icon clicked')));
                },
              ),
            ],
          ),

          SizedBox(height: 20.0),
          // Book name
          Text(
            widget.book.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          // Rating stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 18.0,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 18.0,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 18.0,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 18.0,
              ),
              Icon(
                Icons.star_half,
                color: Colors.yellow,
                size: 18.0,
              ),
            ],
          ),
          SizedBox(height: 20.0),
          // Row for About and Reviews buttons
          Row(
            children: [
              // About button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('About button clicked')));
                  },
                  child: Text('About'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        tPrimaryColor, // Use primary color for the button
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
              ),
              SizedBox(width: 10.0), // Add spacing between buttons
              // Reviews button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (userData != null) {
                      showReviewModal(
                          context, widget.book.bookId, userData!['user']['id']);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User data not available')));
                    }
                  },
                  child: Text('Reviews'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          // Book description
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(
              widget.book.summary,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(height: 20.0),
          // Rating and Review section
          FutureBuilder<List<Review>>(
            future: fetchReviews(widget.book.bookId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: tSecondaryColorWithOpacity,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final reviews = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rating',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      reviews.first.rating.toString(),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: tSecondaryColor,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return ListTile(
                          title: Text(review.userName),
                          subtitle: Text(review.comment),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return Center(child: Text('No reviews available'));
              }
            },
          ),
        ],
      ),
    );
  }
}

class Book {
  final int bookId;
  final String title;
  final String genreId;
  final String isbn;
  final String publishingCompany;
  final String publishDate;
  final String officialWebsiteLink;
  final String emailId;
  final String numberOfPages;
  final String isSeries;
  final String? seriesName;
  final String? seriesNumber;
  final String summary;
  final String coverImage;

  Book({
    required this.bookId,
    required this.title,
    required this.genreId,
    required this.isbn,
    required this.publishingCompany,
    required this.publishDate,
    required this.officialWebsiteLink,
    required this.emailId,
    required this.numberOfPages,
    required this.isSeries,
    this.seriesName,
    this.seriesNumber,
    required this.summary,
    required this.coverImage,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'],
      title: json['title'],
      genreId: json['genre_id'],
      isbn: json['isbn'],
      publishingCompany: json['publishing_company'],
      publishDate: json['publishDate'],
      officialWebsiteLink: json['official_website_link'],
      emailId: json['email_id'],
      numberOfPages: json['number_of_pages'],
      isSeries: json['is_series'],
      seriesName: json['series_name'],
      seriesNumber: json['series_number'],
      summary: json['summary'],
      coverImage: json['cover_image'],
    );
  }
}

class Review {
  final String bookName;
  final int rating; // Ensure this is int
  final String comment;
  final String userName;
  final String userPicture;

  Review({
    required this.bookName,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.userPicture,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      bookName: json['book_name'],
      rating: int.tryParse(json['rating']) ?? 0, // Safely parse rating
      comment: json['comment'],
      userName: json['user_name'],
      userPicture: json['user_picture'],
    );
  }
}
