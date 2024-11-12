import 'package:flutter/material.dart';
import 'package:bluechat/users/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bluechat/users/userDetails.dart';

// contacts.dart
// contacts.dart

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<User> users = [];
  bool isLoading = true;
  String? errorMessage;

  void fetchContacts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/users/allusers'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          users = data.map((userJson) => User.fromJson(userJson)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.grey,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                ? CircleAvatar(
              backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKW18v8AAyb8U0Z3M2EkSLlzetK72DhYGBkA&s'),
            )
                : CircleAvatar(child: Icon(Icons.person)), // Default avatar
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.profile),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserDetails(user: user)),
              );
            },
          );
        },
      ),
    );
  }
}
