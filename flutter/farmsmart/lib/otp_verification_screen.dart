import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bluechat/screens/navigation.dart';
import 'package:bluechat/sign_up.dart';  // Import your SignUpPage for navigation
import 'package:bluechat/screens/task_list_page.dart'; // HomePage

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  OtpVerificationScreen({required this.email});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _message = "";
  bool _isOtpSent = false;  // Flag to check if OTP was sent
  late DateTime _otpSentTime;  // Track OTP sent time

  @override
  void initState() {
    super.initState();
    _otpSentTime = DateTime.now(); // Record when OTP was sent
  }

  // Function to verify OTP
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/users/otp/verify'),  // Update with actual API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final bool activationStatus = responseData['activationstatus'];  // Check activation status

        if (activationStatus) {
          // If account is activated, navigate to the homepage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),  // Navigate to HomePage
          );
        } else {
          // If account is not activated, show a message
          setState(() {
            _message = "Your account is not activated yet. Please check your email or contact support.";
          });
        }
      } else {
        setState(() {
          _message = "Failed to verify OTP. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error: $e";
      });
    }
  }

  // Function to check if 10 minutes have passed since OTP was sent
  bool canResendOtp() {
    return DateTime.now().difference(_otpSentTime).inMinutes >= 10;
  }

  // Function to resend OTP if 10 minutes have passed
  Future<void> resendOtp() async {
    if (canResendOtp()) {
      setState(() {
        _message = "Resending OTP...";
      });

      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/users/otp/send'),  // Update with actual API URL
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': widget.email}),
        );

        if (response.statusCode == 200) {
          setState(() {
            _message = "OTP resent successfully! Check your email.";
            _otpSentTime = DateTime.now(); // Reset the OTP sent time
          });
        } else {
          setState(() {
            _message = "Failed to resend OTP. Please try again.";
          });
        }
      } catch (e) {
        setState(() {
          _message = "Error: $e";
        });
      }
    } else {
      setState(() {
        _message = "You can resend OTP after 10 minutes.";
      });
    }
  }

  // Function to navigate back to the OtpRequestScreen if email is wrong
  void navigateBackToRequestScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Light background color
      
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the OTP sent to your email:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                // Underline the text field, remove the border
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                hintText: 'Enter OTP',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_otpController.text.isNotEmpty) {
                  verifyOtp(widget.email, _otpController.text);
                } else {
                  setState(() {
                    _message = "Please enter the OTP.";
                  });
                }
              },
              child: Text('Verify OTP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade200,  // Button color
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
            ),
            SizedBox(height: 16),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  fontSize: 16,
                  color: _message.startsWith('Error') || _message.startsWith('Failed')
                      ? Colors.red
                      : Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            SizedBox(height: 20),
            // Resend OTP button with 10 minutes delay logic
            TextButton(
              onPressed: resendOtp,
              child: Text(
                'Resend OTP',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Back to Request OTP screen button
            TextButton(
              onPressed: navigateBackToRequestScreen,
              child: Text(
                'Wrong email? Go back and try again.',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
