import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_verification_screen.dart';

class OtpRequestScreen extends StatefulWidget {
  final String email; // Receive the email from the previous screen

  OtpRequestScreen({required this.email});  // Constructor to accept email

  @override
  _OtpRequestScreenState createState() => _OtpRequestScreenState();
}

class _OtpRequestScreenState extends State<OtpRequestScreen> {
  String _message = "";

  @override
  void initState() {
    super.initState();
    // Automatically send OTP when the screen loads
    sendOtp(widget.email);
  }

  // Send OTP function
  Future<void> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/users/otp/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200 || response.statusCode == 2001) {
        setState(() {
          _message = "OTP sent successfully to $email!";
        });
        // Navigate to OTP verification screen after successful OTP request
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OtpVerificationScreen(email: email)),
        );
      } else {
        setState(() {
          _message = "Failed to send OTP.";
        });
        // Navigate to OTP verification screen after failed OTP request
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OtpVerificationScreen(email: email)),
        );
      }
    } catch (e) {
      setState(() {
        _message = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This will not take much time!!!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54, // Standard text color
                ),
              ),
              SizedBox(height: 20),
              Text(
                // Display the email passed from the previous screen
                'A verification OTP has been sent to ${widget.email}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700], // Email display color
                ),
              ),
              SizedBox(height: 20),
              _message.isNotEmpty
                  ? Text(
                      _message,
                      style: TextStyle(
                        fontSize: 16,
                        color: _message.startsWith('Error') || _message.startsWith('Failed')
                            ? Colors.red // Error message in red
                            : Colors.green,  // Success message in green
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Container(), // If no message, display nothing
            ],
          ),
        ),
      ),
    );
  }
}
