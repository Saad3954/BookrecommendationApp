import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tbr/src/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BlogPostScreen extends StatefulWidget {
  @override
  _BlogPostScreenState createState() => _BlogPostScreenState();
}

class _BlogPostScreenState extends State<BlogPostScreen> {
  TextEditingController _contentController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<dynamic>> _fetchBlogPosts() async {
    final String? token = await getToken();
    print(token);
    if (token == null) {
      print('No token found. Please log in.');
      return [];
    }
    try {
      final response = await http.get(
        Uri.parse('https://recommend.orbixcode.com/recommend/api/blog-posts'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Log the response body
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load blog posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e'); // Log the exception
      throw e;
    }
  }

  Future<bool> createBlogPost(String content, File? image) async {
    final String? token = await getToken();
    if (token == null) {
      print('No token found. Please log in.');
      return false;
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://recommend.orbixcode.com/recommend/api/create/blog-post'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['content'] = content;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    var response = await request.send();
    return response.statusCode == 201;
  }

  void _submitBlogPost() async {
    String content = _contentController.text;
    if (content.isNotEmpty || _selectedImage != null) {
      bool success = await createBlogPost(content, _selectedImage);
      if (success) {
        _contentController.clear();
        setState(() {
          _selectedImage = null;
        });
        // Refresh the blog posts
        setState(() {});
      } else {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'What\'s on your mind?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),

            // Image Display
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.file(
                  _selectedImage!,
                  height: 150, // Adjust as needed
                  fit: BoxFit.cover,
                ),
              ),

            // Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                ),
                SizedBox(width: 10), // Add spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitBlogPost,
                    child: Text('Post'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add some space before the blog post list

            // Blog Posts List
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _fetchBlogPosts(), // Fetch blog posts
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            tSecondaryColorWithOpacity),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No posts found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var post = snapshot.data![index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display the post content
                                Text(
                                  post['content'] ?? 'No content available',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(height: 8.0),

                                // Conditionally display the image if available
                                if (post['image'] != null &&
                                    post['image'].isNotEmpty)
                                  Image.network(
                                    post['image'],
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(Icons.error,
                                            color: Colors.red),
                                      );
                                    },
                                  ),
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
          ],
        ),
      ),
    );
  }
}
