/* import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tbr/src/constants/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      imageUrl: json['picture_path'] ?? '',
    );
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

class AuthorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authors'),
        centerTitle: true,
        backgroundColor: tSecondaryColorWithOpacity,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder<List<Author>>(
          future: fetchAuthors(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFadingCircle(
                  color: tSecondaryColor,
                  size: 50.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No authors found.'));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Three books per row
                  crossAxisSpacing: 4.0, // Decreased horizontal spacing
                  mainAxisSpacing: 0.4, // Decreased vertical spacing
                  childAspectRatio: 0.7, // Adjusted aspect ratio
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final author = snapshot.data![index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthorDetailsPage(
                            authorName: author.name,
                            authorDesignation: author.designation,
                            authorImageUrl: author.imageUrl,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*  CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(author.imageUrl),
                            onBackgroundImageError: (error, stackTrace) {
                              // Handle image loading errors
                              print('Error loading image: $error');
                            },
                          ), */
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors
                                .grey[200], // Background color while loading
                            backgroundImage: NetworkImage(author.imageUrl),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    author.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/man.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            author.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 3),
                          /* Text(
                            author.designation,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ), */
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class AuthorDetailsPage extends StatelessWidget {
  final String authorName;
  final String authorDesignation;
  final String authorImageUrl;

  AuthorDetailsPage({
    required this.authorName,
    required this.authorDesignation,
    required this.authorImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Implement your author details page here
    return Scaffold(
      appBar: AppBar(
        title: Text(authorName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(authorImageUrl),
              onBackgroundImageError: (error, stackTrace) {
                // Handle image loading errors
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
          ],
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tbr/src/constants/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'author_details_page.dart';

class Author {
  final String name;
  final String designation;
  final String imageUrl;
  final int authorId;

  Author({
    required this.name,
    required this.designation,
    required this.imageUrl,
    required this.authorId,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] ?? 'Admin',
      designation: json['designation'] ?? 'Writer',
      imageUrl: json['picture_path'] != null && json['picture_path'] is String
          ? json['picture_path']
          : '',
      authorId: json['id'] ?? '83',
    );
  }
}

class AuthorScreen extends StatefulWidget {
  @override
  _AuthorScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Author> _authors = [];
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchAuthors();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchAuthors() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://recommend.orbixcode.com/recommend/api/dashboard?page=$_page'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['authors'];
        setState(() {
          _authors
              .addAll(data.map((author) => Author.fromJson(author)).toList());
          _page++;
        });
      } else {
        throw Exception('Failed to load authors');
      }
    } catch (e) {
      // Handle errors as needed
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      _fetchAuthors();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authors'),
        centerTitle: true,
        backgroundColor: tSecondaryColorWithOpacity,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: _authors.isEmpty && _isLoading
            ? Center(
                child: SpinKitFadingCircle(
                  color: tSecondaryColor,
                  size: 50.0,
                ),
              )
            : GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Three authors per row
                  crossAxisSpacing: 4.0, // Horizontal spacing
                  mainAxisSpacing: 0.4, // Vertical spacing
                  childAspectRatio: 0.7, // Adjusted aspect ratio
                ),
                itemCount: _authors.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _authors.length) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: tSecondaryColor,
                        size: 50.0,
                      ),
                    );
                  }

                  final author = _authors[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthorDetailsPage(
                            authorName: author.name,
                            authorDesignation: author.designation,
                            authorImageUrl: author.imageUrl,
                            authorId: author.authorId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors
                                .grey[200], // Background color while loading
                            backgroundImage: author.imageUrl.isNotEmpty
                                ? NetworkImage(author.imageUrl)
                                : null,
                            child: author.imageUrl.isEmpty
                                ? Image.asset(
                                    'assets/images/man.png',
                                    fit: BoxFit.cover,
                                  )
                                : Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.network(
                                          author.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/man.png',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            author.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 3),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

/* class AuthorDetailsPage extends StatelessWidget {
  final String authorName;
  final String authorDesignation;
  final String authorImageUrl;

  AuthorDetailsPage({
    required this.authorName,
    required this.authorDesignation,
    required this.authorImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(authorName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(authorImageUrl),
              onBackgroundImageError: (error, stackTrace) {
                // Handle image loading errors
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
          ],
        ),
      ),
    );
  }
}
 */