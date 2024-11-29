import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'full_screen_image_page.dart';  // Import FullScreenImage widget
import 'inbox_messages.dart';


class ContactsScreen extends StatefulWidget {
  final String myUserId; // The ID of the logged-in user

  const ContactsScreen({Key? key, required this.myUserId}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<dynamic> users = [];
  bool loading = true;
  String error = '';
  bool creatingInbox = false;

  // Fetch users from the API
  Future<void> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('https://farmsmart-0yqz.onrender.com/users/allusers'));
      if (response.statusCode == 200 || response.statusCode == 2001) {
        setState(() {
          users = json.decode(response.body);
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to fetch users';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching users: $e';
        loading = false;
      });
    }
  }

  // Create inbox conversation and navigate to the chat page
  Future<void> createInboxAndNavigate(int userId) async {
    setState(() {
      creatingInbox = true;
    });

    final requestData = {
      'firstuserid': int.parse(widget.myUserId), // Logged-in user's ID
      'seconduserid': userId.toInt(),
    };

    try {
      final response = await http.post(
        Uri.parse('https://farmsmart-0yqz.onrender.com/creatingnewconversation/startconva'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          creatingInbox = false;
        });
        final inbox = json.decode(response.body);
        if (inbox.isNotEmpty) {
          // Navigate to the chat page with the inboxId of the newly created conversation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chills(
                userId: userId.toString(),
                myUserId: widget.myUserId,  // Pass the logged-in user's ID
              ),
            ),
          );
        }
      } else {
        setState(() {
          creatingInbox = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create inbox')));
      }
    } catch (e) {
      setState(() {
        creatingInbox = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error creating inbox: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch users on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : users.isEmpty
                  ? Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return GestureDetector(
                          onTap: () => createInboxAndNavigate(user['userid']), // Create conversation and navigate
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                // Navigate to FullScreenImage when the profile picture is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                      imageUrl: user['profilepicture'] ?? 'assets/default_profile.png',
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: user['profilepicture'] != null && user['profilepicture'].isNotEmpty
                                    ? NetworkImage(user['profilepicture'])  // Load network image if available
                                    : AssetImage('assets/default_profile.png') as ImageProvider, // Fallback to default image
                              ),
                            ),
                            title: Text('${user['firstname']} ${user['lastname']}'),
                          ),
                        );
                      },
                    ),
    );
  }
}
