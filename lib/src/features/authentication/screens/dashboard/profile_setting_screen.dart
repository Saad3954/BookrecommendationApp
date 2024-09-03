import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Email/Password Update'),
            onTap: () {
              // Navigate to email/password update screen
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Profile Picture Edit'),
            onTap: () {
              // Navigate to profile picture edit screen
            },
          ),
          ListTile(
            leading: Icon(Icons.create),
            title: Text('Create Book'),
            onTap: () {
              // Navigate to create book screen
            },
          ),
        ],
      ),
    );
  }
}
