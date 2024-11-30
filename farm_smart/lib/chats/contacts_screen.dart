import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'full_screen_image_page.dart';  // Import FullScreenImage widget
import 'inbox_messages.dart';  // Assuming this is the chat screen you want to navigate to
import 'package:flutter_spinkit/flutter_spinkit.dart';  // Import flutter_spinkit

class ContactsScreen extends StatefulWidget {
  final String myUserId; // The ID of the logged-in user

  const ContactsScreen({Key? key, required this.myUserId}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool creatingInbox = false;

  // Fetch users from the API
  Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('https://farmsmart-0yqz.onrender.com/users/allusers'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Create inbox conversation and navigate to the chat page
  Future<void> createInboxAndNavigate(int userId, String firstName, String lastName) async {
    setState(() {
      creatingInbox = true; // Show the spinner when the inbox is being created
    });

    final requestData = {
      'firstuserid': int.parse(widget.myUserId), // Logged-in user's ID
      'seconduserid': userId,
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
                firstName: firstName,       // Pass the user's first name
                lastName: lastName,         // Pass the user's last name
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitThreeBounce(
                color: Colors.green,  // Customize the spinner color
                size: 30.0,            // Customize the size of the spinner
              ),
            ); // Show a progress indicator while loading
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return GestureDetector(
                  onTap: () => createInboxAndNavigate(
                    user['userid'],              // Pass user ID
                    user['firstname'],           // Pass the user's first name
                    user['lastname'],            // Pass the user's last name
                  ),
                  child: Padding(  // Wrap the ListTile in Padding widget to add padding
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),  // Add padding around each user
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
                  ),
                );
              },
            );
          }
        },
      ),
      // Show the spinner while creating inbox
      floatingActionButton: creatingInbox
          ? Center(
              child: SpinKitThreeBounce(
                color: Colors.green,  // Customize the spinner color
                size: 30.0,            // Customize the size of the spinner
              ),
            )
          : null,  // No spinner when not creating inbox
    );
  }
}
