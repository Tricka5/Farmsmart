import 'package:flutter/material.dart';
import 'user_profile_page.dart';

class ChatItem extends StatelessWidget {
  final String userId;
  final String chatName;
  final String myUserId; // Adding myUserId for passing to UserProfilePage

  const ChatItem({super.key, required this.userId, required this.chatName, required this.myUserId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
      ),
      child: ListTile(
        title: Text(chatName, style: TextStyle(color: Colors.grey.shade600)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(userId: userId, myUserId: myUserId),
            ),
          );
        },
      ),
    );
  }
}
