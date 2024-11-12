import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String userId;
  final String chatName;

  const ChatItem({
    Key? key,
    required this.userId,
    required this.chatName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/$userId'); // Replace with your route
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            chatName.isNotEmpty ? chatName : "Unknown User",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
