import 'package:farmsmart/user_verification/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:farmsmart/home/home.dart';  // Import the correct file where FarmSmartScreen is defined
import 'sign_up.dart';  // Import the file for SignUpPage


class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String currentUserId;
  final String currentUserEmail;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.currentUserId,
    required this.currentUserEmail,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _message = "";
  late DateTime _otpSentTime;

  static const String baseUrl = "https://farmsmart-0yqz.onrender.com";
  final Uri verifyOtpUrl = Uri.parse('$baseUrl/users/otp/verify');
  final Uri resendOtpUrl = Uri.parse('$baseUrl/users/otp/send');

  @override
  void initState() {
    super.initState();
    _otpSentTime = DateTime.now();
  }

  // Verify OTP
  Future<void> verifyOtp(String email, String otp) async {
    if (otp.isEmpty || otp.length != 6 || int.tryParse(otp) == null) {
      setState(() {
        _message = "Please enter a valid 6-digit OTP.";
      });
      return;
    }

    try {
      final response = await http.post(
        verifyOtpUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final bool activationStatus = responseData['activationstatus'];

        if (activationStatus) {
          // Navigate to the home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FarmSmartScreen(
                currentUserId: widget.currentUserId,
                currentUserEmail: widget.currentUserEmail,
              ),
            ),
          );
        } else {
          setState(() {
            _message = "Your account is not activated yet. Please contact support.";
          });
        }
      } else {
        setState(() {
          _message = "Invalid OTP. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error: Unable to verify OTP. Please check your internet connection.";
      });
    }
  }

  // Check if OTP can be resent
  bool canResendOtp() {
    return DateTime.now().difference(_otpSentTime).inMinutes >= 10;
  }

  // Resend OTP
  Future<void> resendOtp() async {
    if (!canResendOtp()) {
      setState(() {
        _message = "You can resend OTP after 10 minutes.";
      });
      return;
    }

    try {
      setState(() {
        _message = "Resending OTP...";
      });

      final response = await http.post(
        resendOtpUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = "OTP resent successfully! Check your email.";
          _otpSentTime = DateTime.now();
        });
      } else {
        setState(() {
          _message = "Failed to resend OTP. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error: Unable to resend OTP. Please check your internet connection.";
      });
    }
  }

  // Navigate back to the sign-up screen
  void navigateBackToRequestScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  // Format remaining time for OTP resend
  String getFormattedTime(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Duration remainingTime = Duration(minutes: 10) - DateTime.now().difference(_otpSentTime);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                'Enter the OTP sent to your email:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter OTP',
                  labelStyle: TextStyle(color: Colors.green.shade700),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade400),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade600),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  verifyOtp(widget.email, _otpController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Verify OTP', style: TextStyle(fontSize: 16,color:Colors.white)),
              ),
              const SizedBox(height: 20),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    fontSize: 16,
                    color: _message.startsWith('Error') || _message.startsWith('Invalid')
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: resendOtp,
                child: Text(
                  canResendOtp()
                      ? 'Resend OTP'
                      : "Resend available in ${getFormattedTime(remainingTime)}",
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: navigateBackToRequestScreen,
                child: Text(
                  'Wrong email? Go back and try again.',
                  style: TextStyle(
                    color: Colors.grey[900],
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
