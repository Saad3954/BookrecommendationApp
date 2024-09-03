import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchBooks extends StatefulWidget {
  @override
  _SearchBooksState createState() => _SearchBooksState();
}

class _SearchBooksState extends State<SearchBooks> {
  final TextEditingController _searchController = TextEditingController();
  List _searchResults = [];

  Future<void> _searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://recommend.orbixcode.com/recommend/api/search-books?query=$query'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Books'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title, author, ISBN, or genre...',
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
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final book = _searchResults[index];
                      return ListTile(
                        leading: Image.network(
                          book['cover_image'],
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                        title: Text(book['title']),
                        subtitle: Text(
                            '${book['author']['name']} • ${book['genre']['name']}'),
                        onTap: () {
                          // Handle book click, navigate to details or other actions
                        },
                      );
                    },
                  )
                : Center(
                    child: Text('No results found'),
                  ),
          ),
        ],
      ),
    );
  }
}
