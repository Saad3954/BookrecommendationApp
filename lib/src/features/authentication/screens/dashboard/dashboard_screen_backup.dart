import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbr/src/constants/colors.dart';
import 'package:tbr/src/constants/image_strings.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/book_details_page.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/my_books.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/profile_screen.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/discover_screen.dart';
import 'dart:convert';

import 'package:tbr/src/utils/theme/theme.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? userData; // Make userData nullable

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson =
    prefs.getString('user_data'); // Make userDataJson nullable
    if (userDataJson != null) {
      setState(() {
        userData = json.decode(userDataJson);
      });
    } else {
      // Handle the case where no user data is stored in SharedPreferences
      // For example, navigate the user back to the login screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tSecondaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Read',
              style: TextStyle(
                fontSize: 20.0,
                color: tPrimaryColor,
              ),
            ),
            SizedBox(width: 5), // Adding space between Read and Recommend
            Text(
              'Recommend',
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: tPrimaryColor,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Add functionality to settings icon
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Add functionality to notification icon
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // Set the background color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0), // Standard spacing
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Rachele!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 12.0), // Standard space
                    Text(
                      'What would you like to read today?',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // userData != null
              //     ? Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Text('Email: ${userData!['user']['email']}'),
              //     // Other widgets to display user data
              //   ],
              // )
              //     : Container(),
              // Add the horizontal scroll view here
              GenreScrollView(),
              SizedBox(height: 20.0), // Standard spacing
              BookCard(
                bookName: 'Sample Book 1',
                authorName: 'Sample Author 1',
                tagIcon: Icons.label,
                showPlus: true,
              ),
              BookCard(
                bookName: 'Sample Book 2',
                authorName: 'Sample Author 2',
                tagIcon: Icons.label,
                showCheck: true,
              ),
              BookCard(
                bookName: 'Sample Book 3',
                authorName: 'Sample Author 3',
                tagIcon: Icons.label,
              ),
              BookCard(
                bookName: 'Sample Book 4',
                authorName: 'Sample Author 4',
                tagIcon: Icons.label,
                showPlus: true,
              ),
              BookCard(
                bookName: 'Sample Book 5',
                authorName: 'Sample Author 5',
                tagIcon: Icons.label,
                showCheck: true,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for the center floating action button
        },
        child: Icon(
          Icons.add,
          size: 40, // Increase icon size
          color: tPrimaryColor, // Change icon color
        ),
        backgroundColor: tAccentColor,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    // Navigate to the DashboardScreen when the home button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Navigate to the SearchScreen when the search button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiscoverScreen()),
                    );
                  },
                ),
                SizedBox(), // Spacer for the center
                IconButton(
                  icon: Icon(Icons.menu_book_sharp),
                  onPressed: () {
                    // Navigate to the AddScreen when the books button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyBookScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    // Navigate to the ProfileScreen when the profile button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
  final String bookName;
  final String authorName;
  final IconData tagIcon;
  final bool showPlus;
  final bool showCheck;

  BookCard({
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsPage(bookName: bookName, authorName: authorName, bookId: 3),
          ),
        );
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
