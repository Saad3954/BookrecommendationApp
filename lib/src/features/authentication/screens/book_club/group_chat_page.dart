import 'package:flutter/material.dart';
import 'package:tbr/src/constants/colors.dart';

class GroupChatPage extends StatefulWidget {
  final String bookClubId;
  final String bookClubName; // Add this to accept the club name

  GroupChatPage({required this.bookClubId, required this.bookClubName});

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // List to store chat messages
  List<Map<String, String>> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tSecondaryColorWithOpacity,
        title: Text('${widget.bookClubName}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // Show the latest messages at the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                return ListTile(
                  title: Text(message['text']!),
                  subtitle: Text(message['senderName']!),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    // Add the message to the local list
    setState(() {
      messages.insert(0, {
        'text': _messageController.text,
        'senderName': 'User', // Replace with actual user name
      });
    });

    // Clear the text field
    _messageController.clear();

    // Scroll to the bottom to show the latest message
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
