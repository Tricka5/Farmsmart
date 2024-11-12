import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_profile_provider.dart'; // Import the provider
import 'package:bluechat/users/users.dart'; // Import the User model

class UserInbox extends StatefulWidget {
  final User user; // Accept User object

  const UserInbox({Key? key, required this.user}) : super(key: key);

  @override
  _UserInboxState createState() => _UserInboxState();
}

class _UserInboxState extends State<UserInbox> {
  String? thisChatInbox;
  List<dynamic> messageBox = [];
  String message = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCommonInbox();
  }

  Future<void> fetchCommonInbox() async {
    final currentUserProfile = context.read<UserProfileProvider>().currentUserProfile;
    if (currentUserProfile != null) {
      try {
        final response = await http.get(Uri.parse(
            'http://localhost:3000/inboxparticipants/currentinbox/${widget.user.userid}/${currentUserProfile['userid']}'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data.isNotEmpty) {
            setState(() {
              thisChatInbox = data[0]['inboxid'];
              fetchMessages();
            });
          } else {
            setState(() {
              isLoading = false; // No inbox found
            });
          }
        } else {
          setState(() {
            isLoading = false; // Handle error response
          });
        }
      } catch (e) {
        print('Error fetching common inbox: $e');
        setState(() {
          isLoading = false; // Handle error
        });
      }
    }
  }

  Future<void> fetchMessages() async {
    if (thisChatInbox != null) {
      setState(() {
        isLoading = true; // Start loading messages
      });
      try {
        final response = await http.get(Uri.parse('http://localhost:3000/message/$thisChatInbox/message'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            messageBox = data; // Update message box
            isLoading = false; // Stop loading
          });
        } else {
          setState(() {
            isLoading = false; // Handle error response
          });
        }
      } catch (e) {
        print('Error fetching messages: $e');
        setState(() {
          isLoading = false; // Handle error
        });
      }
    }
  }

  Future<void> handleSubmit() async {
    final currentUserProfile = context.read<UserProfileProvider>().currentUserProfile;
    if (thisChatInbox != null && currentUserProfile != null && message.isNotEmpty) {
      final requestData = {
        'inboxid': thisChatInbox,
        'userid': currentUserProfile['userid'],
        'message': message,
      };

      try {
        await http.post(
          Uri.parse('http://localhost:3000/message/send'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestData),
        );
        fetchMessages(); // Fetch messages again after sending
        setState(() {
          message = ''; // Clear message input
        });
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.user.firstName}'), // Set the app bar title
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Text(widget.user.firstName, style: const TextStyle(fontSize: 24)), // Display user's first name
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : messageBox.isEmpty
                ? const Center(child: Text('No messages to display.'))
                : ListView.builder(
              itemCount: messageBox.length,
              itemBuilder: (context, index) {
                final messageData = messageBox[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  alignment: messageData['userid'] == context.read<UserProfileProvider>().currentUserProfile?['userid']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: messageData['userid'] == context.read<UserProfileProvider>().currentUserProfile?['userid']
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(messageData['message']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        message = value; // Update message
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: handleSubmit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
