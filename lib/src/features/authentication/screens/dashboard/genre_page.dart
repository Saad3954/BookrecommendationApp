import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart'; // Import your color constants here

class GenrePage extends StatefulWidget {
  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  // Define genres data
  List<Map<String, dynamic>> genres = [
    {'name': 'Thriller', 'image': 'assets/thriller.jpg', 'icon': Icons.dangerous},
    {'name': 'Mystery', 'image': 'assets/mystery.jpg', 'icon': Icons.search},
    {'name': 'Historical Drama', 'image': 'assets/historical_drama.jpg', 'icon': Icons.history},
    {'name': 'Fantasy', 'image': 'assets/fantasy.jpg', 'icon': Icons.star},
    {'name': 'Sci-Fi Thriller', 'image': 'assets/sci_fi_thriller.jpg', 'icon': Icons.science},
    {'name': 'Romance', 'image': 'assets/romance.jpg', 'icon': Icons.favorite},
    {'name': 'Action', 'image': 'assets/action.jpg', 'icon': Icons.sports},
    // Add more genres as needed
  ];

  bool showAllGenres = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tSecondaryColor,
        title: Text('Genres'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0, // Decrease spacing between items
                mainAxisSpacing: 10.0, // Decrease spacing between items
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: genres.take(showAllGenres ? genres.length : 6).map((genre) {
                  return GestureDetector(
                    onTap: () {
                      // Handle genre tile click
                    },
                    child: AspectRatio(
                      aspectRatio: 1, // Ensure square aspect ratio
                      child: Container(
                        decoration: BoxDecoration(
                          color: tAccentColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max, // Ensure column takes up all available vertical space
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              genre['icon'],
                              color: tPrimaryColor,
                              size: 60, // Increase the size of the icon
                            ),
                            SizedBox(height: 10),
                            Text(
                              genre['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: tPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAllGenres = !showAllGenres;
                    });
                  },
                  child: Text(
                    showAllGenres ? 'Show Less' : 'Show More',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: tPrimaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
