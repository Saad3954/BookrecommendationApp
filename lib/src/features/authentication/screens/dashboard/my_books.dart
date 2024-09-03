import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbr/src/constants/colors.dart';

class MyBookScreen extends StatefulWidget {
  @override
  _MyBookScreenState createState() => _MyBookScreenState();
}

class _MyBookScreenState extends State<MyBookScreen> {
  List<dynamic> _shelves = [];
  String? _authToken;

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('user_data');
    if (userDataJson != null) {
      Map<String, dynamic> userData = json.decode(userDataJson);
      setState(() {
        _authToken = userData['token'];
      });
      _fetchShelves(); // Fetch shelves after token is loaded
    } else {
      print('No user data found in SharedPreferences.');
    }
  }

  Future<void> _createShelf(String name) async {
    if (_authToken == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('user_data');
    if (userDataJson != null) {
      Map<String, dynamic> userData = json.decode(userDataJson);
      String userId = userData['id'].toString();

      final response = await http.post(
        Uri.parse('https://recommend.orbixcode.com/recommend/api/shelves'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 201) {
        // Shelf created successfully, refresh the shelf list
        _fetchShelves();
      } else {
        // Handle errors
        print('Failed to create shelf: ${response.statusCode}');
      }
    } else {
      print('No user data found in SharedPreferences.');
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
      setState(() {
        _shelves = json.decode(response.body);
      });
    } else {
      // Handle errors
      print('Failed to load shelves');
    }
  }

  Future<void> _updateShelf(int shelfId, String newName) async {
    if (_authToken == null) return;

    final response = await http.post(
      Uri.parse(
          'https://recommend.orbixcode.com/recommend/api/shelves/$shelfId'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': newName, // Send only the fields that need to be updated
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        // Update the local shelf data
        final index = _shelves.indexWhere((shelf) => shelf['id'] == shelfId);
        if (index != -1) {
          _shelves[index]['name'] = newName;
        }
      });
    } else {
      // Handle errors
      print('Failed to update shelf');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }

  Future<void> _deleteShelf(int shelfId) async {
    if (_authToken == null) return;

    final response = await http.delete(
      Uri.parse(
          'https://recommend.orbixcode.com/recommend/api/shelves/$shelfId'),
      headers: {
        'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _shelves.removeWhere((shelf) => shelf['id'] == shelfId);
      });
    } else {
      // Handle errors
      print('Failed to delete shelf');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }

  void _showEditDeleteDialog(int shelfId, String shelfName) {
    final TextEditingController _nameController =
        TextEditingController(text: shelfName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Manage Shelf"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Shelf Name'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final newName = _nameController.text.trim();
                  if (newName.isNotEmpty) {
                    await _updateShelf(shelfId, newName);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _deleteShelf(shelfId);
                  Navigator.of(context).pop();
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Books'),
        centerTitle: true,
        backgroundColor: tSecondaryColorWithOpacity,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'My Shelves',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                height: 155.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _shelves.length,
                  itemBuilder: (context, index) {
                    final shelf = _shelves[index];
                    return GestureDetector(
                      onLongPress: () {
                        _showEditDeleteDialog(shelf['id'], shelf['name']);
                      },
                      child: BookCard(
                        name: shelf['name'],
                        booksCount: '7 books', // Placeholder for books count
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog to create a new shelf
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final TextEditingController _nameController =
                  TextEditingController();

              return AlertDialog(
                title: Text("Create Shelf"),
                content: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Shelf Name'),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      final name = _nameController.text.trim();
                      if (name.isNotEmpty) {
                        // Call the API to create a new shelf
                        await _createShelf(name);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Create"),
                  ),
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
        child: Icon(Icons.add),
        backgroundColor: tSecondaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class BookCard extends StatelessWidget {
  final String name;
  final String booksCount;

  BookCard({required this.name, required this.booksCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      width: 150.0,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 50.0, color: tSecondaryColorWithOpacity),
          SizedBox(height: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: tSecondaryColor,
                ),
              ),
              Text(
                booksCount,
                style: TextStyle(
                  fontSize: 11.0,
                  color: tSecondaryColorWithOpacity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
