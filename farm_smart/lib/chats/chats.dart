import 'package:farmsmart/chats/contacts_screen.dart';
import 'package:farmsmart/chats/full_screen_image_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart'; // Import CachedNetworkImage

import 'inbox_messages.dart';
class Chats extends StatefulWidget {
  final String myUserId; // The ID of the logged-in user

  const Chats({Key? key, required this.myUserId}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<dynamic> users = [];
  bool loading = true;
  String error = '';
  bool creatingInbox = false;
  double _imageSize = 30.0; // Initial image size for the CircleAvatar

  // Fetch users from the API
  Future<void> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.123:3000/inboxparticipants/${widget.myUserId}/chat'));
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
  Future<void> NavigateToInbox(int userId) async {
    setState(() {
      creatingInbox = true;
    });

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

  // Function to toggle image size when tapped
  void _toggleImageSize() {
    setState(() {
      _imageSize = _imageSize == 30.0 ? 50.0 : 30.0; // Toggle between two sizes
    });
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
                        String profilepicture = user['profilepicture'] ?? '';  // Safely handle null profilePicture
                        // Log the profile picture URL for debugging
                        print('Profile Picture URL: $profilepicture');
                        
                        return GestureDetector(
                          onTap: () => NavigateToInbox(user['userid']),
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                // Navigate to the full-screen image view
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                      imageUrl: profilepicture.isNotEmpty 
                                          ? profilepicture 
                                          : 'assets/default_profile.png', // Use default image if null
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: _imageSize, // Dynamically change the size
                                backgroundImage: profilepicture.isNotEmpty
                                    ? CachedNetworkImageProvider(profilepicture)
                                    : AssetImage('assets/default_profile.png') as ImageProvider,
                              ),
                            ),
                            title: Text('${user['firstname']} ${user['lastname']}'),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactsScreen(myUserId: widget.myUserId),
            ),
          );
        },
        child: Icon(Icons.contacts),
        backgroundColor: Colors.green,
      ),
    );
  }
}
