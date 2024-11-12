import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserInboxPage extends StatefulWidget {
  final String userId;
  final String currentUserId;
  final String inboxId; // Inbox ID passed from the previous screen

  UserInboxPage({required this.userId, required this.currentUserId, required this.inboxId});

  @override
  _UserInboxPageState createState() => _UserInboxPageState();
}

class _UserInboxPageState extends State<UserInboxPage> {
  List<dynamic> messageBox = [];
  bool loading = true;
  String message = '';

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // Fetch messages from the server based on the inboxId
  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/message/${widget.inboxId}/message'),
      );
      if (response.statusCode == 200) {
        setState(() {
          messageBox = json.decode(response.body);
          loading = false;
        });
      }
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  // Send a message to the user
  Future<void> _sendMessage() async {
    final requestData = {
      'inboxid': widget.inboxId,
      'userid': widget.currentUserId,
      'message': message,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/message/send'),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        setState(() {
          messageBox.add({
            'userid': widget.currentUserId,
            'message': message,
            'id': messageBox.length + 1,
          });
          message = ''; // Clear the message input
        });
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with User ${widget.userId}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            loading
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: messageBox.length,
                itemBuilder: (context, index) {
                  final messageItem = messageBox[index];
                  return ListTile(
                    title: Text(messageItem['message']),
                    subtitle: Text('User ID: ${messageItem['userid']}'),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) => setState(() {
                message = value;
              }),
              decoration: InputDecoration(hintText: 'Type your message...'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
