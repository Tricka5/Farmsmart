import 'package:flutter/material.dart';
import 'package:bluechat/messaging/chats.dart';
import 'package:bluechat/page/loading.dart';
import 'package:bluechat/users/users.dart';
import 'package:bluechat/messaging/user_provider.dart';
import 'package:bluechat/messaging/user_profile.dart';
import 'package:bluechat/messaging/user_inbox.dart';
import 'package:bluechat/loadingWidgets/api_service.dart';
import 'package:bluechat/loadingWidgets/current_user_api_service.dart';


class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _MyAppState();
}

class _MyAppState extends State<Contacts> {
  List<User> _users = [];
  Future<void> _loadUsers() async {
    final apiService = ApiService();
    final users = await apiService.getUser();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Wrap your widget tree with MaterialApp
      home: Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_users[index].firstName),
              subtitle: Text(_users[index].lastName),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _loadUsers,
          tooltip: 'Load Users',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
