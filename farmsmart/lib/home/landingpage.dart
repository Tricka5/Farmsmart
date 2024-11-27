import 'package:flutter/material.dart';
import 'package:farmsmart/user_verification/Login_SignUp.dart';

void main() => runApp(FarmSmartApp());

class FarmSmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FarmSmartPage(),
    );
  }
}

class FarmSmartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/females.jpg', // Replace with your background image path
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top logo with rounded square shape and custom image
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                ),
              ),
              // Centered text
              Column(
                children: [
                  Text(
                    'Farm Smart',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 225, 255, 255),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome to Farm Smart your Preferred\nRecord Keeping App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                ],
              ),
              // Bottom-right button
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, right: 20.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(), // Pass user ID to ContactsScreen
                      ),
                    );
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
