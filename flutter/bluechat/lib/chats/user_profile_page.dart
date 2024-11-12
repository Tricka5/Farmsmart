import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  final String userId;
  final String myUserId;

  UserProfilePage({required this.userId, required this.myUserId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<Map<String, dynamic>> thisChatInboxFuture;
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> currentMessages = []; // Holds current messages
  bool isSending = false; // Track the sending state to disable UI during message sending
  String inboxId = "";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    thisChatInboxFuture = _fetchCommonInboxData();
  }

  // Fetch common inbox data
  Future<Map<String, dynamic>> _fetchCommonInboxData() async {
    try {
      final response = await http.get(
        Uri.parse('https://record-keeping.onrender.com/inboxparticipants/currentinbox/${widget.userId}/${widget.myUserId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          inboxId = data[0]['inboxid'].toString(); // Store inboxId
          return data[0]; // Return the first chat inbox data
        } else {
          throw Exception('No inbox data found');
        }
      } else {
        throw Exception('Failed to load inbox data');
      }
    } catch (error) {
      throw Exception('Failed to fetch inbox: $error');
    }
  }

  // Fetch messages for the current chat inbox
  Future<List<dynamic>> _fetchMessages() async {
    try {
      final response = await http.get(Uri.parse('https://record-keeping.onrender.com/message/$inboxId/message'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data.isNotEmpty ? data : [];  // Return an empty list if no messages
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (error) {
      throw Exception('Failed to fetch messages: $error');
    }
  }

  // Handle message send action
  Future<void> _sendMessage(String messageText) async {
    if (messageText.isEmpty || isSending) return;  // Don't send if there's no text or already sending

    final newMessage = {
      'message': messageText,
      'userid': widget.myUserId,
      'createdat': DateTime.now().toIso8601String(), // Use current time as timestamp
    };

    // Immediately update the UI by adding the new message to the list
    setState(() {
      currentMessages.add(newMessage);
      isSending = true;  // Mark sending as true to disable UI and prevent sending multiple times
    });

    final requestData = {
      'inboxid': inboxId,
      'userid': widget.myUserId,
      'message': messageText,
    };

    try {
      final response = await http.post(
        Uri.parse('https://record-keeping.onrender.com/message/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      ).timeout(Duration(seconds: 10)); // Set timeout for the request

      if (response.statusCode == 200) {
        // Message sent successfully, you could handle response here if needed
      } else {
        throw Exception('Failed to send message');
      }
    } on TimeoutException catch (_) {
      // Handle timeout error
      setState(() {
        currentMessages.removeLast();  // Remove the message from UI since it wasn't sent
        isSending = false;  // Reset sending state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sending timed out. Please try again.')),
      );
    } catch (error) {
      // Handle general errors
      print('Error sending message: $error');
      setState(() {
        currentMessages.removeLast();  // Remove the message from UI since it wasn't sent
        isSending = false;  // Reset sending state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message. Please try again.')),
      );
    }

    // Clear the message input field after sending
    _messageController.clear();
    setState(() {
      isSending = false;  // Reset sending state once the message is sent or failed
    });
  }

  // Scroll to the bottom of the ListView when a new message is added
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.userId}',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: thisChatInboxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No inbox data found.'));
          } else {
            final inboxData = snapshot.data!;
            inboxId = inboxData['inboxid'].toString();

            return FutureBuilder<List<dynamic>>(
              future: _fetchMessages(),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (messageSnapshot.hasError) {
                  return Center(child: Text('Error: ${messageSnapshot.error}'));
                } else if (!messageSnapshot.hasData || messageSnapshot.data!.isEmpty) {
                  return Center(child: Text('No messages available.'));
                } else {
                  if (currentMessages.isEmpty) {
                    currentMessages = messageSnapshot.data!;
                  }

                  // Scroll to bottom when messages are loaded or updated
                  _scrollToBottom();

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: currentMessages.length,
                          itemBuilder: (context, index) {
                            final message = currentMessages[index];
                            final messageText = message['message'] ?? 'No content';
                            final timestamp = message['createdat'];

                            final time = DateTime.parse(timestamp).toLocal();
                            final formattedTime = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

                            bool isCurrentUser = message['userid'].toString() == widget.myUserId;

                            return _buildMessageWidget(messageText, formattedTime, isCurrentUser);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                maxLines: 4,
                                minLines: 1,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send, color: Colors.black),
                              onPressed: () {
                                String messageText = _messageController.text.trim();
                                _sendMessage(messageText); // Send the message and trigger UI update
                                _scrollToBottom(); // Scroll to bottom when a new message is added
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  // Build individual message widget
  Widget _buildMessageWidget(String messageText, String time, bool isCurrentUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageText,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.black : Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.black54 : Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
