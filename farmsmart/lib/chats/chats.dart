import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chart_item.dart'; // Assuming this is your ChatItem widget
import 'contacts_screen.dart'; // Import ContactsScreen (make sure this exists)

class Chats extends StatefulWidget {
  final String myUserId;

  const Chats({super.key, required this.myUserId});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<dynamic> users = [];
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch chat participants from the API
  Future<void> _fetchData() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/inboxparticipants/${widget.myUserId}/chat'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          users = data;
        });
      } else {
        setState(() {
          error = 'Failed to load chat data';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching data: $e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // Navigate to ContactsScreen when FAB is pressed
  void _navigateToContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactsScreen(myUserId: widget.myUserId), // Pass user ID to ContactsScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.green, // Set green as primary color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loading
                ? Center(child: CircularProgressIndicator())
                : error.isNotEmpty
                    ? Center(child: Text(error, style: TextStyle(color: Colors.red)))
                    : users.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                final userId = user['userid'].toString(); // Ensure userId is a string

                                // Find the chat name from users based on the userId
                                final chatName = user['firstname'] ?? 'Unknown User';

                                return ChatItem(
                                  userId: userId,
                                  chatName: chatName,
                                  myUserId: widget.myUserId,
                                );
                              },
                            ),
                          )
                        : Center(child: Text('No chats available.', style: TextStyle(fontSize: 18))),
          ],
        ),
      ),
      // Add FloatingActionButton to navigate to Contacts
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToContacts,
        child: Icon(Icons.add), // Use add icon for creating a new chat
        backgroundColor: Colors.green, // You can customize the color of the FAB
      ),
    );
  }
}
