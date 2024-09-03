import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateBookClubModal extends StatefulWidget {
  @override
  _CreateBookClubModalState createState() => _CreateBookClubModalState();
}

class _CreateBookClubModalState extends State<CreateBookClubModal> {
  String _selectedType = 'Author';
  String _name = '';
  int _peopleLimit = 0;

  Future<void> _submitForm() async {
    if (_name.isNotEmpty && _peopleLimit > 0) {
      try {
        final url = Uri.parse('https://recommend.orbixcode.com/recommend/api/book-clubs/create');
        final response = await http.post(
          url,
          body: json.encode({
            'name': _name,
            'type': _selectedType,
            'people_limit': _peopleLimit,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 201) {
          // Book club created successfully
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Book club created successfully')),
          );
        } else {
          // Error creating book club
          throw Exception('Failed to create book club');
        }
      } catch (e) {
        // Exception handling
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create book club')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create Book Club', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Type:', style: TextStyle(fontSize: 16.0)),
                ListTile(
                  title: Text('Author'),
                  leading: Radio<String>(
                    value: 'Author',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Genre'),
                  leading: Radio<String>(
                    value: 'Genre',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Title'),
                  leading: Radio<String>(
                    value: 'Title',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: 'People Limit'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _peopleLimit = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
