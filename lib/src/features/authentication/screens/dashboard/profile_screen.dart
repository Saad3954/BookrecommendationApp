import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart';
import 'package:tbr/src/features/authentication/screens/blogs/blog_post_screen.dart';
import 'package:tbr/src/features/authentication/screens/book_club/group_chat_page.dart';
import 'package:tbr/src/features/authentication/screens/books/create_book_club_modal.dart';
import 'package:tbr/src/features/authentication/screens/books/rules_and_regulations_page.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/profile_setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tbr/src/features/authentication/screens/dashboard/update_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int userId = 1;
  //ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? userData;
  late Future<List<Review>> _reviews;
  late Future<List<BookClub>> futureBookClubs;

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('user_data');
    if (userDataJson != null) {
      setState(() {
        userData = json.decode(userDataJson);
        if (userData != null) {
          _reviews = fetchReviews(userData!['user']['id']);
          futureBookClubs = fetchBookClubs(userData!['user']['id']);
        } else {
          // Provide a default value or placeholder Future
          _reviews = Future.value([]);
        }
      });
    } else {
      print('No user data found in SharedPreferences.');
    }
  }

  Future<List<Review>> fetchReviews(int userId) async {
    final response = await http.get(Uri.parse(
        'https://recommend.orbixcode.com/recommend/api/reviews/user/${userId}'));

    if (response.statusCode == 200) {
      String responseBody = response.body;

      List<dynamic> data;
      try {
        data = jsonDecode(responseBody);
      } catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }

      List<Review> reviews = data.map((json) => Review.fromJson(json)).toList();
      return reviews;
    } else {
      print('Failed to load reviews with status code: ${response.statusCode}');
      return [];
    }
  }

  Future<List<BookClub>> fetchBookClubs(int userId) async {
    final response = await http.get(Uri.parse(
        'https://recommend.orbixcode.com/recommend/api/book-clubs?userId=$userId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['bookClubs'];
      return jsonResponse.map((club) => BookClub.fromJson(club)).toList();
    } else {
      throw Exception('Failed to load book clubs');
    }
  }

  // Join a book club API call
  Future<void> joinBookClub(int userId, int bookClubId) async {
    final response = await http.post(
      Uri.parse(
          'https://recommend.orbixcode.com/recommend/api/book-clubs/join'),
      body: {
        'user_id': userId.toString(),
        'book_club_id': bookClubId.toString(),
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to join book club');
    }
  }

// Exit a book club API call
  Future<void> exitBookClub(int userId, int bookClubId) async {
    final response = await http.post(
      Uri.parse(
          'https://recommend.orbixcode.com/recommend/api/book-clubs/exit'),
      body: {
        'user_id': userId.toString(),
        'book_club_id': bookClubId.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to exit book club');
    }
  }

  void handleJoinGroup(int bookClubId) async {
    try {
      await joinBookClub(widget.userId, bookClubId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined the group successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join the group')),
      );
    }
  }

  void handleExitGroup(int bookClubId) async {
    try {
      await exitBookClub(widget.userId, bookClubId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exited the group successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to exit the group')),
      );
    }
  }

  void _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear 'user_data'
    prefs.remove('user_data');

    // Clear 'token'
    prefs.remove('token');

    // Redirect to login screen
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tSecondaryColorWithOpacity,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.invert_colors_on),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Color Change"),
                    content: Text("Change color functionality goes here."),
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
          ),
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Upload"),
                    content: Text("Upload functionality goes here."),
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
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.settings),
            onSelected: (String value) {
              switch (value) {
                case 'EmailPasswordUpdate':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProfilePage()),
                  );
                  break;
                case 'ProfilePictureEdit':
                  break;
                case 'CreateBook':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RulesAndRegulationsPage()),
                  );
                  break;
                case 'CreateGroup':
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CreateBookClubModal();
                    },
                  );
                  break;
                case 'Logout':
                  _logout(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'EmailPasswordUpdate',
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Update Profile'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'CreateBook',
                child: ListTile(
                  leading: Icon(Icons.create_new_folder),
                  title: Text('Create Book'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'CreateGroup',
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text('Create Group Club'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: ListTile(
                  leading: Icon(
                      Icons.exit_to_app), // Replace this with your desired icon
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  tSecondaryColorWithOpacity,
                  Colors.white,
                ],
                stops: [0.5, 0.5],
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You didn't go through all that for nothing",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "${userData?['user']['profile_picture']}",
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "${userData?['user']['name']}!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FutureBuilder<List<Review>>(
                  future: _reviews,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No reviews found.'));
                    } else {
                      final reviews = snapshot.data!;

                      return ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://recommend.orbixcode.com/recommend/${review.userPicture}'),
                            ),
                            title: Text(review.userName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review.bookName),
                                Row(
                                  children: List.generate(5, (i) {
                                    if (i < review.rating) {
                                      return Icon(Icons.star,
                                          color: Colors.yellow);
                                    } else if (i <
                                        review.rating.floor() + 0.5) {
                                      return Icon(Icons.star_half,
                                          color: Colors.yellow);
                                    } else {
                                      return Icon(Icons.star_border,
                                          color: Colors.yellow);
                                    }
                                  }),
                                ),
                                Text(review.rating.toString()),
                                Text(review.comment),
                              ],
                            ),
                            onTap: () {
                              // Add action for tapping the review
                            },
                          );
                        },
                      );
                    }
                  },
                ),

                // Blogs Tab
                /* Center(
                  child: Text("Blogs"),
                ), */
                BlogPostScreen(),
                // Groups Tab

                FutureBuilder<List<BookClub>>(
                  future: futureBookClubs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No book clubs found'));
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          BookClub club = snapshot.data![index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/profile_pictures/user${index % 5 + 1}.jpg'), // Example logic for images
                            ),
                            title: Text(club.name),
                            subtitle: Text('Type: ${club.type}'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'join') {
                                  handleJoinGroup(club.id);
                                } else if (value == 'exit') {
                                  handleExitGroup(club.id);
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<String>>[
                                  if (club.joinGroup)
                                    PopupMenuItem<String>(
                                      value: 'join',
                                      child: Text('Join'),
                                    ),
                                  if (club.exitGroup)
                                    PopupMenuItem<String>(
                                      value: 'exit',
                                      child: Text('Exit'),
                                    ),
                                ];
                              },
                            ),
                            onTap: () {
                              if (club.joinGroup) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'You need to join this group first.')),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return GroupChatPage(
                                        bookClubId: club.id.toString(),
                                        bookClubName: club.name,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: tSecondaryColorWithOpacity,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: "Reviews"),
            Tab(text: "Blogs"),
            Tab(text: "Groups"),
          ],
        ),
      ),
    );
  }
}

class Review {
  final String bookName;
  final String userName;
  final String userPicture;
  final double rating;
  final String comment;

  Review({
    required this.bookName,
    required this.userName,
    required this.userPicture,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      bookName: json['book_name'] ?? 'Unknown',
      userName: json['user_name'] ?? 'Anonymous',
      userPicture: json['user_picture'] ?? '',
      rating: double.tryParse(json['rating']) ?? 0.0,
      comment: json['comment'] ?? 'No comment',
    );
  }
}

class BookClub {
  final int id;
  final String name;
  final String type;
  final int peopleLimit;
  final bool joinGroup;
  final bool exitGroup;

  BookClub({
    required this.id,
    required this.name,
    required this.type,
    required this.peopleLimit,
    required this.joinGroup,
    required this.exitGroup,
  });

  factory BookClub.fromJson(Map<String, dynamic> json) {
    return BookClub(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      peopleLimit: int.parse(json['people_limit']),
      joinGroup: json['joinGroup'],
      exitGroup: json['exitGroup'],
    );
  }
}
