import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'update_password_page.dart';  // Import your UpdatePasswordPage
import 'package:flutter_spinkit/flutter_spinkit.dart';  // Import SpinKit package
import 'dart:async';  // Import Timer for countdown functionality

class NewPasswordVerification extends StatefulWidget {
  final String email;
  const NewPasswordVerification({super.key, required this.email});

  @override
  _NewPasswordVerificationState createState() => _NewPasswordVerificationState();
}

class _NewPasswordVerificationState extends State<NewPasswordVerification> {
  final TextEditingController _otpController = TextEditingController();
  String _message = "";
  bool _isLoading = false; // Add loading state
  late DateTime _otpSentTime;
  late Timer _timer;
  int _otpExpiryTime = 600; // OTP expiry time in seconds (10 minutes)

  @override
  void initState() {
    super.initState();
    _otpSentTime = DateTime.now(); // Record when OTP was sent
    _startCountdown(); // Start the countdown timer
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  // Function to verify OTP
  Future<void> verifyOtp(String email, String otp) async {
    setState(() {
      _isLoading = true;  // Start the spinner when the request is sent
      _message = "";
    });

    try {
      final response = await http.post(
        Uri.parse('https://farmsmart-0yqz.onrender.com/users/otp/verify'),  // Update with actual API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final bool? activationStatus = responseData['activationstatus'];  // Check activation status

        if (activationStatus != null && activationStatus) {
          // If account is activated, extract userId and navigate to the UpdatePasswordPage
          final String userId = responseData['userid'].toString(); // Ensure userId is a String

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UpdatePasswordPage(
                email: widget.email,
                userId: userId, // Pass the extracted userId to UpdatePasswordPage
              ),
            ),
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
    } finally {
      setState(() {
        _isLoading = false;  // Stop the spinner once the response is received
      });
    }
  }

  // Function to check if OTP has expired
  bool isOtpExpired() {
    return _otpExpiryTime <= 0;
  }

  // Function to start countdown for OTP expiry
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_otpExpiryTime > 0) {
        setState(() {
          _otpExpiryTime--;
        });
      } else {
        _timer.cancel(); // Stop the timer once OTP expires
      }
    });
  }

  // Format remaining time (seconds to mm:ss format)
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // Add padding for better spacing
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
                  color: Colors.grey.shade700, // Vibrant blue for visibility
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter OTP',
                  labelStyle: TextStyle(color: Colors.grey.shade700), // Blue label
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
                  backgroundColor: Colors.green.shade500, // Vibrant green button color
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  minimumSize: Size(double.infinity, 40), // Full width button
                ),
                child: Text('Verify OTP', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 20),
              if (_isLoading)
                SpinKitThreeBounce(color: Colors.green, size: 50.0), // Spinner when loading
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
              if (!isOtpExpired()) 
                Text(
                  "OTP expires in: ${_formatTime(_otpExpiryTime)}",
                  style: TextStyle(color: Colors.red.shade700, fontSize: 16),
                ),
              if (isOtpExpired())
                Text(
                  "OTP has expired. Please request a new one.",
                  style: TextStyle(color: Colors.red.shade700, fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
