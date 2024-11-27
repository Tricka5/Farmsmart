import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_profile_page.dart';  // Import UserProfilePage

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
          await http.get(Uri.parse('http://localhost:3000/users/allusers'));
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
      'first_userid': int.parse(widget.myUserId), // Logged-in user's ID
      'second_userid': userId,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/creatingnewconversation/startconva'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          creatingInbox = false;
        });
        final inbox = json.decode(response.body);
        if (inbox.isNotEmpty) {
          // Navigate to UserProfilePage with the inboxId of the newly created conversation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(
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
                            title: Text('${user['firstname']} ${user['lastname']}'),
                          ),
                        );
                      },
                    ),
    );
  }
}
