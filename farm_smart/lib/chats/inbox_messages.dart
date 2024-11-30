import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add the import here
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chills extends StatefulWidget {
  final String userId;
  final String myUserId;
  final String firstName; // Add this
  final String lastName;  // Add this

  const Chills({super.key, required this.userId, required this.myUserId, required this.firstName, required this.lastName});

  @override
  State<Chills> createState() => _ChillsState();
}

class _ChillsState extends State<Chills> {
  late Future<Map<String, dynamic>> thisChatInboxFuture;
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> currentMessages = [];
  bool isSending = false;
  String inboxId = "";
  final ScrollController _scrollController = ScrollController();

  // WebSocket connection
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    thisChatInboxFuture = _fetchCommonInboxData();

    // Initialize WebSocket connection
    socket = IO.io('http://<your-nestjs-server-url>:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Listen for refresh event from the WebSocket server
    socket.on('refresh', (data) {
      print('Received refresh event: ${data['message']}');
      // Handle the refresh event, e.g., by fetching new messages
      setState(() {
        _fetchMessages();  // Fetch messages again or refresh UI
      });
    });
  }

  // Fetch common inbox data
  Future<Map<String, dynamic>> _fetchCommonInboxData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://farmsmart-0yqz.onrender.com/inboxparticipants/currentinbox/${widget.userId}/${widget.myUserId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data); // This will print the whole data to the console

        if (data.isNotEmpty) {
          return {'inboxid': data['inboxid']};
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
      final response = await http.get(Uri.parse('https://farmsmart-0yqz.onrender.com/message/$inboxId/message'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data.isNotEmpty ? data : [];
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (error) {
      throw Exception('Failed to fetch messages: $error');
    }
  }

  // Handle message send action
  Future<void> _sendMessage(String messageText) async {
    if (messageText.isEmpty || isSending) return;

    final newMessage = {
      'message': messageText,
      'userid': widget.myUserId,
      'createdat': DateTime.now().toIso8601String(),
    };

    setState(() {
      currentMessages.add(newMessage);
      isSending = true;
    });

    final requestData = {
      'inboxid': inboxId,
      'userid': widget.myUserId,
      'message': messageText,
    };

    try {
      final response = await http
          .post(
            Uri.parse('https://farmsmart-0yqz.onrender.com/message/send'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestData),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Emit the new message through WebSocket to notify other clients
        socket.emit('newMessage', requestData); // Emit the message to WebSocket
      } else {
        throw Exception('Failed to send message');
      }
    } on TimeoutException catch (_) {
      setState(() {
        currentMessages.removeLast();
        isSending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sending timed out. Please try again.')),
      );
    } catch (error) {
      setState(() {
        currentMessages.removeLast();
        isSending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message. Please try again.')),
      );
    }

    _messageController.clear();
    setState(() {
      isSending = false;
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    socket.disconnect(); // Disconnect WebSocket when widget is disposed
    socket.dispose(); // Clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.firstName} ${widget.lastName}', // Display full name
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: thisChatInboxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitThreeBounce(
                color: Colors.green, // Customize the spinner color
                size: 50.0,           // Customize the size of the spinner
              ),
            );
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
                  return Center(
                    child: SpinKitThreeBounce(
                      color: Colors.green, // Customize the spinner color
                      size: 50.0,           // Customize the size of the spinner
                    ),
                  );
                } else if (messageSnapshot.hasError) {
                  return Center(child: Text('Error: ${messageSnapshot.error}'));
                } else {
                  if (currentMessages.isEmpty) {
                    currentMessages = messageSnapshot.data ?? [];
                  }

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
                                _sendMessage(messageText);
                                _scrollToBottom();
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

  Widget _buildMessageWidget(String messageText, String time, bool isCurrentUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.white : Colors.green[300],
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
                    color: isCurrentUser ? Colors.green : Colors.white,
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
