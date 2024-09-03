import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbr/src/constants/colors.dart';
import 'package:tbr/src/constants/image_strings.dart';
import 'package:tbr/src/features/authentication/screens/authors/authors_screen.dart';
import 'package:tbr/src/features/authentication/screens/books/book_screen.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/book_details_page.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/my_books.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/profile_screen.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/discover_screen.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/search_books.dart';
import 'package:tbr/src/utils/theme/theme.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? userData;
  late Future<List<Author>> futureAuthors;
  late Future<List<Book>> futureBooks;
  final TextEditingController _searchController = TextEditingController();
  List _searchResults = [];
  String? _authToken;

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
    futureAuthors = fetchAuthors();
    futureBooks = fetchBooks();
    _showGenreSelectionModal(context);
  }

  Future<void> checkUserGenres() async {
    final url = Uri.parse(
        'https://your-api-domain.com/user/genres'); // Replace with your API domain
    final token = 'your-auth-token'; // Retrieve the user's auth token

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Add Authorization header if required
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> genreIds = json.decode(response.body);

      if (genreIds.isEmpty) {
        _showGenreSelectionModal(context);
      }
      // No need to set selectedGenres state here since it's not used.
    } else {
      print('Failed to fetch user genres');
      print(response.body);
    }
  }

  Future<List<Author>> fetchAuthors() async {
    final response = await http.get(
        Uri.parse('https://recommend.orbixcode.com/recommend/api/dashboard'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['authors'];
      return data.map((author) => Author.fromJson(author)).toList();
    } else {
      throw Exception('Failed to load authors');
    }
  }

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(
        Uri.parse('https://recommend.orbixcode.com/recommend/api/dashboard'));

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

  Future<List<Genre>> fetchGenres() async {
    final response = await http
        .get(Uri.parse('https://recommend.orbixcode.com/recommend/api/genres'));

    if (response.statusCode == 200) {
      final List<dynamic> genresJson = json.decode(response.body);
      return genresJson
          .map((genreJson) => Genre.fromJson(genreJson as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load genres');
    }
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
    } else {
      print('No user data found in SharedPreferences.');
    }
  }

  Future<void> _searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://recommend.orbixcode.com/recommend/api/books/search?query=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _searchResults = data;
        });
      } else {
        setState(() {
          _searchResults = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch search results')),
        );
      }
    } catch (e) {
      setState(() {
        _searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  _onTapBook(BuildContext context, Map<String, dynamic> book) {
    final bookId = book['book_id']; // Adjust based on your book data structure
    final bookName = book['title'];
    final authorName = book['author']?['name'] ?? 'Unknown Author';
    final publisherCompany = book['publisher_company'] ?? 'Unknown Publisher';
    final publisherDate = book['publisher_date'] ?? 'Unknown Date';
    final pageNumbers = book['page_numbers'] ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          bookId: bookId,
          bookName: bookName,
          authorName: authorName,
          publisherCompany: publisherCompany,
          publisherDate: publisherDate,
          pageNumbers: pageNumbers,
        ),
      ),
    );
  }

  void _showGenreSelectionModal(BuildContext context) async {
    final genres = await fetchGenres();
    final selectedGenres = <int>{}; // Store selected genre IDs

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select Genres'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: genres.map((genre) {
                    return CheckboxListTile(
                      title: Text(genre.name),
                      value: selectedGenres.contains(genre.id),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            selectedGenres.add(genre.id);
                          } else {
                            selectedGenres.remove(genre.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child:
                      Text('Cancel', style: TextStyle(color: tSecondaryColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('OK', style: TextStyle(color: tPrimaryColor)),
                  onPressed: () async {
                    // Use selectedGenres as needed
                    print('Selected Genres: $selectedGenres');
                    await submitGenres(selectedGenres);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> submitGenres(Set<int> selectedGenres) async {
    final url = Uri.parse(
        'https://your-api-domain.com/user/genres'); // Replace with your API domain
    final token = 'your-auth-token'; // Retrieve the user's auth token

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Add Authorization header if required
      },
      body: json.encode({
        'genres':
            selectedGenres.toList(), // Convert Set to List for JSON encoding
      }),
    );

    if (response.statusCode == 200) {
      print('Genres updated successfully');
      final responseData = json.decode(response.body);
      print(responseData[
          'message']); // Should print "Genres updated successfully"
    } else {
      print('Failed to update genres');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommend Read'),
        centerTitle: true,
        backgroundColor: tSecondaryColorWithOpacity,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: tSecondaryColorWithOpacity,
              padding: EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${userData?['user']['name']}!',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.fontSize,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'What would you like to read today?',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Add notification functionality here
                              },
                            ),
                            Positioned(
                              right: 11,
                              top: 11,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 10,
                                  minHeight: 10,
                                ),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText:
                              'Search by title, author, ISBN, or genre...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (query) {
                          if (query.length > 2) {
                            _searchBooks(query);
                          } else {
                            setState(() {
                              _searchResults = [];
                            });
                          }
                        },
                      ),
                    ),
                    _searchResults.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              height: 300, // Set a fixed height for the list
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics:
                                    NeverScrollableScrollPhysics(), // Avoid scroll issues
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final book = _searchResults[index];
                                  final coverImage =
                                      book['cover_image'] as String?;
                                  final title = book['title'] as String?;
                                  final authorName =
                                      book['author']?['name'] as String?;
                                  final genreName =
                                      book['genre']?['name'] as String?;

                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 16.0),
                                    leading: coverImage != null
                                        ? Container(
                                            width: 75,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                coverImage,
                                                width: 75,
                                                height: 100,
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Center(
                                                    child: Icon(Icons.error),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : SizedBox(width: 75, height: 100),
                                    title: Text(title ?? 'Unknown Title'),
                                    subtitle: Text(
                                        '${authorName ?? 'Unknown Author'} • ${genreName ?? 'Unknown Genre'}'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookDetailsPage(
                                            bookName: title ?? 'Unknown Title',
                                            bookId: book['id'],
                                            authorName:
                                                authorName ?? 'Unknown Author',
                                            publisherCompany:
                                                book['publisher_company'] ??
                                                    'Unknown Publisher',
                                            publisherDate:
                                                book['publisher_date'] ??
                                                    'Unknown Date',
                                            pageNumbers:
                                                book['page_numbers'] ?? '0',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: Text('No results found'),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            // Add the second container or any other widgets here
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Most liked authors',
                          style: TextStyle(
                            color: tPrimaryColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AuthorScreen(), // Replace with your BooksPage widget
                              ),
                            );
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: tPrimaryColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.0),

                  FutureBuilder<List<Author>>(
                    future: futureAuthors,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No authors found.');
                      } else {
                        // Take the first 10 authors from the data
                        final authors = snapshot.data!.take(10).toList();

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: authors.map((author) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(author.imageUrl),
                                      onBackgroundImageError:
                                          (error, stackTrace) {
                                        // Handle image loading errors
                                      },
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      author.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      author.designation,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),

                  // Trending Books section
                  SizedBox(
                      height:
                          30.0), // Space between authors section and trending books section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending this year',
                        style: TextStyle(
                          color: tPrimaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookScreen(), // Replace with your BooksPage widget
                            ),
                          );
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: tPrimaryColor,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                      height:
                          20.0), // Space between authors section and trending books section
                  Container(
                    height: 220, // Adjust the height as needed
                    child: FutureBuilder<List<Book>>(
                      future: fetchBooks(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No books found'));
                        }

                        final books = snapshot.data!;

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];

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
                                width:
                                    120, // Adjust the width of each book image container
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          180, // Maintain the height of the book image container
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            10), // Set the border radius
                                        child: Container(
                                          width: double
                                              .infinity, // Take full width of the container
                                          child: Image.network(
                                            book.coverImage,
                                            width: double
                                                .infinity, // Take full width of the container
                                            fit: BoxFit
                                                .cover, // Ensure the image covers the container
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                    ),
                                    SizedBox(
                                        height:
                                            5), // Space between image and title
                                    Expanded(
                                      child: Text(
                                        book.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Handle long titles
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            3), // Space between title and ratings
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.orange,
                                        ),
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.orange,
                                        ),
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.orange,
                                        ),
                                        Icon(
                                          Icons.star_half,
                                          size: 16,
                                          color: Colors.orange,
                                        ),
                                        Icon(
                                          Icons.star_outline,
                                          size: 16,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                            width:
                                                5), // Space between stars and count
                                        Text(
                                          '(100)', // Replace with actual count if available
                                          style: TextStyle(
                                            fontSize: 12,
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
                      },
                    ),
                  ),
                  // Trending Books section
                  SizedBox(
                      height:
                          30.0), // Space between authors section and trending books section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top this month',
                        style: TextStyle(
                          color: tPrimaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Add functionality to see all trending books
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: tPrimaryColor,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                      height:
                          20.0), // Space between authors section and trending books section
                  Container(
                    height: 220, // Adjust the height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // Number of books in the slider
                      itemBuilder: (context, index) {
                        final List<Map<String, String>> books = [
                          {
                            'image': 'assets/books/book.png',
                            'title': 'Book Title 1'
                          },
                          {
                            'image': 'assets/books/book1.jpg',
                            'title': 'Book Title 2'
                          },
                          {
                            'image': 'assets/books/book2.jpeg',
                            'title': 'Book Title 3'
                          },
                          {
                            'image': 'assets/books/book4.jpeg',
                            'title': 'Book Title 4'
                          },
                          {
                            'image': 'assets/books/book5.jpeg',
                            'title': 'Book Title 5'
                          },
                        ];

                        final book = books[index];
                        return Container(
                          width:
                              120, // Adjust the width of each book image container
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Book image
                              SizedBox(
                                height:
                                    180, // Maintain the height of the book image container
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the border radius
                                  child: Container(
                                    width: double
                                        .infinity, // Take full width of the container
                                    child: Image.asset(
                                      book[
                                          'image']!, // Replace with your asset image path
                                      width: double
                                          .infinity, // Take full width of the container
                                      fit: BoxFit
                                          .cover, // Ensure the image covers the container
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                              ),
                              SizedBox(
                                  height: 5), // Space between image and title

                              // Expanded Book title
                              Expanded(
                                child: Text(
                                  book[
                                      'title']!, // Replace with actual book title
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Handle long titles
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                  height: 3), // Space between title and ratings

                              // Star ratings with count
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star_half,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star_outline,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                      width:
                                          5), // Space between stars and count
                                  Text(
                                    '(100)', // Replace with actual count
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home),
                      color: tSecondaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()),
                        );
                      },
                    ),
                    Text('Home',
                        style:
                            TextStyle(color: tSecondaryColor, fontSize: 10.0)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu_book_sharp),
                      color: tSecondaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyBookScreen()),
                        );
                      },
                    ),
                    Text('My Books',
                        style:
                            TextStyle(color: tSecondaryColor, fontSize: 10.0)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.explore),
                      color: tSecondaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiscoverScreen()),
                        );
                      },
                    ),
                    Text('Discover',
                        style:
                            TextStyle(color: tSecondaryColor, fontSize: 10.0)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.person),
                      color: tSecondaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()),
                        );
                      },
                    ),
                    Text('Profile',
                        style:
                            TextStyle(color: tSecondaryColor, fontSize: 10.0)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Author {
  final String name;
  final String designation;
  final String imageUrl;

  Author({
    required this.name,
    required this.designation,
    required this.imageUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] ?? 'Admin',
      designation: json['designation'] ?? 'Writer',
      imageUrl: json['picture_path'] != null && json['picture_path'] is String
          ? json['picture_path']
          : '',
    );
  }
}

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
      title: json['title'] as String? ?? 'Unknown Title',
      authorName: json['author']?['name'] as String? ?? 'Unknown Author',
      coverImage: json['cover_image'] as String? ?? 'Unknown Cover',
      publisherCompany:
          json['publisher_company'] as String? ?? 'Unknown Publisher',
      publisherDate: json['publisher_date'] as String? ?? 'Unknown Date',
      pageNumbers: json['page_numbers'] as String? ??
          '0', // Default to '0' pages if null
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

class GenreScrollView extends StatelessWidget {
  final List<Map<String, dynamic>> genres = [
    {'name': 'Popular', 'icon': Icons.star},
    {'name': 'Thriller', 'icon': Icons.gavel},
    {'name': 'Romance', 'icon': Icons.favorite},
    {'name': 'Fantasy', 'icon': Icons.all_inclusive},
    {'name': 'Mystery', 'icon': Icons.search},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Set the height of the scroll view
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 120, // Set the width of each tile
            margin: EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: tAccentColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(genres[index]['icon'],
                      color: Color(0xFFffb548), size: 40),
                ),
                SizedBox(height: 5),
                Text(
                  genres[index]['name'],
                  style: TextStyle(
                    color: tPrimaryColor,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final int bookId;
  final String bookName;
  final String authorName;
  final IconData tagIcon;
  final bool showPlus;
  final bool showCheck;

  BookCard({
    required this.bookId,
    required this.bookName,
    required this.authorName,
    required this.tagIcon,
    this.showPlus = false,
    this.showCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the book details page
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsPage(
                bookName: bookName, bookId: bookId, authorName: authorName),
          ),
        ); */
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Trending",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  alignment: Alignment.topRight,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      tagIcon,
                      color: tPrimaryColor,
                      size: 30.0, // Increased tag size
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey, // Placeholder color for the image box
                    image: DecorationImage(
                      image: AssetImage(tSplashImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            Icons.star,
                            color: tPrimaryColor.withOpacity(0.5),
                            size: 18.0,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            "4.5",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      SizedBox(height: 10.0),
                      Text(
                        bookName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        authorName,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showPlus || showCheck) // Show plus or check icons
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    if (showPlus)
                      Icon(Icons.add, color: Colors.white, size: 20.0),
                    if (showCheck)
                      Icon(Icons.check, color: Colors.white, size: 20.0),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
