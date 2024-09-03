import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tbr/src/constants/colors.dart';
import 'package:tbr/src/features/authentication/screens/dashboard/profile_screen.dart';

class BookUploadPage extends StatefulWidget {
  @override
  _BookUploadPageState createState() => _BookUploadPageState();
}

class _BookUploadPageState extends State<BookUploadPage> {
  final _formKey = GlobalKey<FormState>();

  // Providing default values
  String _bookTitle = '';
  String _bookAuthor = '';
  String _isbnNumber = '';
  String _publishingCompany = '';
  String _officialWebsiteLink = '';
  String _emailId = '';
  String _genre = '';
  int _numberOfPages = 0;
  bool _isSeries = false;
  String _seriesName = '';
  int _seriesNumber = 0;
  String _bookSummary = '';
  XFile? _bookCoverImage;

  List<dynamic> _authors = [];
  List<dynamic> _genres = [];

  @override
  void initState() {
    super.initState();
    _fetchAuthors();
    _fetchGenres();
  }

  Future<void> _fetchAuthors() async {
    final response = await http.get(
        Uri.parse('https://recommend.orbixcode.com/recommend/api/authors'));
    if (response.statusCode == 200) {
      setState(() {
        _authors = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load authors');
    }
  }

  Future<void> _fetchGenres() async {
    final response = await http
        .get(Uri.parse('https://recommend.orbixcode.com/recommend/api/genres'));
    if (response.statusCode == 200) {
      setState(() {
        _genres = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _bookCoverImage = pickedImage;
    });
  }

  Future<void> _createNewItem(String itemType) async {
    TextEditingController _nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $itemType'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: '$itemType Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(
                    color: tSecondaryColor, // Change this to your desired color
                  )),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse(
                      'https://recommend.orbixcode.com/recommend/api/${itemType.toLowerCase()}s/create'),
                  body: {'name': _nameController.text},
                );
                if (response.statusCode == 201) {
                  if (itemType == 'Author') {
                    await _fetchAuthors();
                  } else {
                    await _fetchGenres();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$itemType added successfully')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add $itemType')),
                  );
                }
              },
              child: Text('Add',
                  style: TextStyle(
                    color: tSecondaryColor, // Change this to your desired color
                  )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tSecondaryColorWithOpacity,
        title: Text('Book Information Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Book Title'),
                onSaved: (value) => _bookTitle = value ?? '',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a book title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Container(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Book Author'),
                  items: _authors.map<DropdownMenuItem<String>>((author) {
                    return DropdownMenuItem<String>(
                      value: author['id'].toString(),
                      child: Text(author['name']),
                    );
                  }).toList()
                    ..add(
                      DropdownMenuItem<String>(
                        value: 'add_new',
                        child: Text('Create New'),
                      ),
                    ),
                  onChanged: (value) {
                    if (value == 'add_new') {
                      _createNewItem('Author');
                    } else {
                      _bookAuthor = value ?? '';
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'ISBN Number'),
                onSaved: (value) => _isbnNumber = value ?? '',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the ISBN number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Publishing Company'),
                onSaved: (value) => _publishingCompany = value ?? '',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the publishing company';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Official Website Link'),
                onSaved: (value) => _officialWebsiteLink = value ?? '',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the official website link';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email ID'),
                onSaved: (value) => _emailId = value ?? '',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Container(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Genre'),
                  items: _genres.map<DropdownMenuItem<String>>((genre) {
                    return DropdownMenuItem<String>(
                      value: genre['id'].toString(),
                      child: Text(genre['name']),
                    );
                  }).toList()
                    ..add(
                      DropdownMenuItem<String>(
                        value: 'add_new',
                        child: Text('Create New'),
                      ),
                    ),
                  onChanged: (value) {
                    if (value == 'add_new') {
                      _createNewItem('Genre');
                    } else {
                      _genre = value ?? '';
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Pages'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _numberOfPages = int.tryParse(value ?? '0') ?? 0,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the number of pages';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Upload Book Cover'),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: _bookCoverImage == null
                    ? Container(
                        height: 150,
                        width: 150,
                        color: Colors.grey[300],
                        child: Icon(Icons.add_a_photo, color: Colors.white),
                      )
                    : _bookCoverImage != null
                        ? Image.file(
                            File(_bookCoverImage!.path),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey[300],
                            child: Icon(Icons.add_a_photo, color: Colors.white),
                          ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Standalone'),
                leading: Radio(
                  value: false,
                  groupValue: _isSeries,
                  onChanged: (bool? value) {
                    setState(() {
                      _isSeries = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Series'),
                leading: Radio(
                  value: true,
                  groupValue: _isSeries,
                  onChanged: (bool? value) {
                    setState(() {
                      _isSeries = value ?? true;
                    });
                  },
                ),
              ),
              if (_isSeries) ...[
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Series Name'),
                  onSaved: (value) => _seriesName = value ?? '',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the series name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number in Series'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      _seriesNumber = int.tryParse(value ?? '0') ?? 0,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the number in the series';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
              ],
              TextFormField(
                decoration: InputDecoration(labelText: 'Book Summary'),
                maxLines: 3,
                onSaved: (value) => _bookSummary = value ?? '',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a summary';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Cancel action
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()),
                        );
                      },
                      child: Text("Cancel".toUpperCase()),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        print('Book Title: $_bookTitle');
                        print('Book Author: $_bookAuthor');
                        print('ISBN Number: $_isbnNumber');
                        print('Publishing Company: $_publishingCompany');
                        print('Official Website Link: $_officialWebsiteLink');
                        print('Email ID: $_emailId');
                        print('Genre: $_genre');
                        print('Number of Pages: $_numberOfPages');
                        print('Is Series: $_isSeries');
                        print('Series Name: $_seriesName');
                        print('Series Number: $_seriesNumber');
                        print('Book Summary: $_bookSummary');

                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          // Proceed with saving or submitting data
                          try {
                            var request = http.MultipartRequest(
                              'POST',
                              Uri.parse(
                                  'https://recommend.orbixcode.com/recommend/api/book/create'),
                            );
                            print(_bookTitle);
                            request.fields['title'] = _bookTitle;
                            request.fields['author_id'] = _bookAuthor;
                            request.fields['genre_id'] = _genre;
                            request.fields['isbn'] = _isbnNumber;
                            request.fields['publishing_company'] =
                                _publishingCompany;
                            request.fields['official_website_link'] =
                                _officialWebsiteLink;
                            request.fields['email_id'] = _emailId;
                            request.fields['number_of_pages'] =
                                _numberOfPages.toString();
                            request.fields['summary'] = _bookSummary;
                            request.fields['is_series'] = _isSeries.toString();
                            request.fields['series_name'] = _seriesName;
                            request.fields['series_number'] =
                                _seriesNumber.toString();

                            if (_bookCoverImage != null) {
                              var fileStream =
                                  http.ByteStream(_bookCoverImage!.openRead());
                              var length = await _bookCoverImage!.length();
                              var multipartFile = http.MultipartFile(
                                'cover_image',
                                fileStream,
                                length,
                                filename: _bookCoverImage!.path.split('/').last,
                              );
                              request.files.add(multipartFile);
                            }

                            var response = await request.send();
                            if (response.statusCode == 201) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Book created successfully')),
                              );
                              // Clear form fields
                              _formKey.currentState?.reset();
                              setState(() {
                                _bookCoverImage = null;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to create book')),
                              );
                            }
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('An error occurred')),
                            );
                          }
                        }
                      },
                      child: Text("Done".toUpperCase()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
