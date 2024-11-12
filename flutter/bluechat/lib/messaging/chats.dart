import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bluechat/messaging/chatitem.dart'; // Adjust the path based on your project structure


class Chats extends StatefulWidget {
  final String myUserId;

  const Chats({Key? key, required this.myUserId}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<dynamic> users = [];
  List<dynamic> contacts = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/inboxparticipants/${widget.myUserId}/chat'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          users = data;
          contacts = data; // Assuming contacts are the same
        });
      } else {
        throw Exception('Failed to load chat data');
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load chat data';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Chats',
            style: TextStyle(color: Colors.grey[600], fontSize: 24),
          ),
        ),
        loading
            ? CircularProgressIndicator()
            : error != null
            ? Text(error!)
            : users.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final chatName = contacts.firstWhere(
                    (contact) => contact['userid'] == user['userid'],
                orElse: () => {'firstname': 'Unknown User'})['firstname'];
            return ChatItem(
              userId: user['userid'],
              chatName: chatName,
            );
          },
        )
            : Text('No chats available.'),
      ],
    );
  }
}
