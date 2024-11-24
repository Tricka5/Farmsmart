import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Login_SignUp.dart'; // Import LoginPage
import 'otp_request_screen.dart'; // Import OTP request screen

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController(); // Last name controller
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  // Secure storage instance to store JWT
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // API endpoint for registration
  final String _apiUrl = 'https://192.168.1.123:3000/users/createuser'; // Replace with your actual API URL

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // Add padding dynamically
        child: Center(
          child: SingleChildScrollView( // Added scrollable container for smaller screens
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    'assets/Logo.png', // Replace with your logo path
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Create a new account", 
                  style: TextStyle(fontSize: screenWidth * 0.06), // Dynamic font size
                ),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction, // Instant feedback
                  child: Column(
                    children: [
                      // Full Name Field
                      _buildTextField(
                        controller: firstnameController,
                        hintText: 'Enter first name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Last Name Field
                      _buildTextField(
                        controller: lastNameController,
                        hintText: 'Enter last name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Email Field
                      _buildTextField(
                        controller: emailController,
                        hintText: 'Enter email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,}$")
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Password Field
                      _buildTextField(
                        controller: passwordController,
                        hintText: 'Enter password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Error Message (if any)
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 16),
                      // Sign-Up Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          minimumSize: Size(screenWidth * 0.8, 50), // Responsive button width
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('SIGN UP', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 16),
                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to login page
                              );
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(color: Colors.green[700]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      validator: validator,
    );
  }

  // Handle Sign Up API request
  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = ''; // Clear previous error message
      });

      try {
        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'firstname': firstnameController.text.trim(),
            'lastname': lastNameController.text.trim(), // Use last name input
            'profilepicture': 'default.jpg', // Optional: implement profile picture upload
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final String token = responseData['access_token'];

          // Store the JWT token securely
          await _storage.write(key: 'jwt_token', value: token);

          // Navigate to OTP request screen with the email
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OtpRequestScreen(email: emailController.text.trim())), // Pass email to OtpRequestScreen
          );
        } else {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          if (response.statusCode == 400 && responseData.containsKey('message')) {
            setState(() {
              _errorMessage = responseData['message'] ?? 'Failed to create account.'; // Show error message from API
            });
          } else {
            setState(() {
              _errorMessage = 'Failed to create account. Please try again.'; // Generic error
            });
          }
        }
      } catch (e) {
        // Handle different types of errors
        if (e is http.ClientException) {
          setState(() {
            _errorMessage = 'No internet connection. Please try again later.'; // No internet connection error
          });
        } else if (e is TimeoutException) {
          setState(() {
            _errorMessage = 'Request timed out. Please try again later.'; // Timeout error
          });
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
