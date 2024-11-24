import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/screens/navigation.dart';
import 'sign_up.dart';  

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _message = "";
  late DateTime _otpSentTime;

  @override
  void initState() {
    super.initState();
    _otpSentTime = DateTime.now(); // Record when OTP was sent
  }

  // Function to verify OTP
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('https://192.168.1.123:3000/users/otp/verify'),  // Update with actual API URL
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
          Uri.parse('https://192.168.1.123:3000/users/otp/send'),  // Update with actual API URL
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
    // Get screen width for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // Add padding for better spacing on mobile screens
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50), // Space at the top
              Text(
                'Enter the OTP sent to your email:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800, // Vibrant blue for visibility
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter OTP',
                  labelStyle: TextStyle(color: Colors.blue.shade700), // Blue label
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade400), // Blue underline
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade600), // Green focused border
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600, // Vibrant green button color
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
                child: Text('Verify OTP', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 20),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    fontSize: 16,
                    color: _message.startsWith('Error') || _message.startsWith('Failed')
                        ? Colors.red.shade700 // Red for error messages
                        : Colors.green.shade700, // Green for success messages
                    fontWeight: FontWeight.w500,
                  ),
                ),
              SizedBox(height: 20),
              TextButton(
                onPressed: resendOtp,
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: Colors.orange.shade700, // Vibrant orange for resend button
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: navigateBackToRequestScreen,
                child: Text(
                  'Wrong email? Go back and try again.',
                  style: TextStyle(
                    color: Colors.red.shade700, // Red color for wrong email message
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
