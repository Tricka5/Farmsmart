import 'package:flutter/material.dart';

void main() {
  runApp(FarmSmartApp());
}

class FarmSmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FarmSmartHomePage(),
    );
  }
}

// Home Page
class FarmSmartHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Center(
          child: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 206, 234, 176),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to Farm Smart mobile farm record designed and implemented to give a simple and friendly user interface for your farm record keeping.\n\nTo begin click the menu bar on the top left corner of the home page',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
