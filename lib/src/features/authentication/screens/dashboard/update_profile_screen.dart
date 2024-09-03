import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbr/src/constants/colors.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  File? _profilePicture; // To store the selected profile picture

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
        fullNameController.text = userData['user']['name'];
        emailController.text = userData['user']['email'];
        phoneNumberController.text = userData['user']['phone_number'] ?? '';
      });
    } else {
      print('No user data found in SharedPreferences.');
    }
  }

  Future<void> updateProfile(
      BuildContext context, String fullName, String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('No authentication token found. Please log in again.')),
      );
      return;
    }

    var request = http.MultipartRequest('POST',
        Uri.parse('https://recommend.orbixcode.com/recommend/api/profile'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = fullName;
    request.fields['phone_number'] = phoneNumber;

    if (_profilePicture != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profile_picture', _profilePicture!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      Map<String, dynamic> userData = {
        'user': {
          'name': fullName,
          'email': emailController.text,
          'phone_number': phoneNumber,
          // Save the path of the profile picture
          // 'profile_picture': _profilePicture?.path,
        },
        'token': token,
      };
      prefs.setString('user_data', json.encode(userData));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  Future<void> _pickProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;
    Color cursorColor = currentBrightness == Brightness.light
        ? Colors.blueAccent
        : Colors.orangeAccent;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: tSecondaryColorWithOpacity,
        title: Text('Update Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickProfilePicture,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profilePicture != null
                        ? FileImage(_profilePicture!)
                        : AssetImage('assets/images/default_profile.png')
                            as ImageProvider, // Default image
                    child: _profilePicture == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.white70,
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: fullNameController,
                  cursorColor: cursorColor,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline_outlined),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  readOnly: true,
                  cursorColor: cursorColor,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: phoneNumberController,
                  cursorColor: cursorColor,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      String fullName = fullNameController.text.trim();
                      String phoneNumber = phoneNumberController.text.trim();
                      updateProfile(context, fullName, phoneNumber);
                    },
                    child: Text('Update Profile'.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
