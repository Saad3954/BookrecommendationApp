import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthorScreen extends StatefulWidget {
  @override
  _AuthorScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  late Future<List<Author>> futureAuthors;

  @override
  void initState() {
    super.initState();
    futureAuthors = fetchAuthors();
  }

  Future<List<Author>> fetchAuthors() async {
    final response = await http.get(Uri.parse('https://recommend.orbixcode.com/recommend/api/dashboard'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['authors'];
      return data.map((author) => Author.fromJson(author)).toList();
    } else {
      throw Exception('Failed to load authors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommend Read'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section (as you have it)

            // Authors section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.zero,
              child: FutureBuilder<List<Author>>(
                future: futureAuthors,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No authors found'));
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: snapshot.data!.map((author) {
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: author.imageUrl.isNotEmpty
                                  ? NetworkImage(author.imageUrl)
                                  : AssetImage('assets/default_profile.jpg') as ImageProvider, // Default image
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
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Author {
  final String name;
  final String designation;
  final String imageUrl;

  Author({required this.name, required this.designation, required this.imageUrl});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] ?? 'Unknown', // Provide a default value
      designation: json['designation'] ?? 'Unknown', // Provide a default value
      imageUrl: json['image_url'] ?? '', // Provide a default value
    );
  }
}
