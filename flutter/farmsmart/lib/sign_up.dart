import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bluechat/screens/navigation.dart';
import 'package:bluechat/Login_SignUp.dart'; // Import your LoginPage
import 'package:bluechat/screens/task_list_page.dart'; // Import your HomePage
import 'otp_request_screen.dart'; // Import the OTP request screen

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController(); // Last name controller
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  // Secure storage instance to store JWT
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // API endpoint for registration
  final String _apiUrl = 'http://localhost:3000/users/createuser'; // Replace with your actual API URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(90.0),
        child: Center(
          child: SingleChildScrollView( // Added scrollable container for smaller screens
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    'Logo.png', // Replace with your logo path
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Text("Create a new account", style: TextStyle(fontSize: 20)),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction, // Instant feedback
                  child: Column(
                    children: [
                      // Full Name Field
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter full name',
                          filled: true,
                          fillColor: Colors.white,
                          // Use UnderlineInputBorder for underline style
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Last Name Field
                      TextFormField(
                        controller: lastNameController, // Last name input field
                        decoration: InputDecoration(
                          hintText: 'Enter last name',
                          filled: true,
                          fillColor: Colors.white,
                          // Underline style
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Email Field
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter email',
                          filled: true,
                          fillColor: Colors.white,
                          // Underline style
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
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
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          filled: true,
                          fillColor: Colors.white,
                          // Underline style
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6 || !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$').hasMatch(value)) {
                            return 'Password must be at least 6 characters, with an uppercase, number, and special character';
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
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('SIGN UP', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          minimumSize: Size(150, 50),
                        ),
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
            'firstname': fullNameController.text.trim(),
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
              _errorMessage = responseData['message'] ?? 'Failed to create account.';
            });
          } else {
            setState(() {
              _errorMessage = 'Failed to create account. Please try again.';
            });
          }
        }
      } catch (e) {
        // Handle different types of errors
        if (e is http.ClientException) {
          setState(() {
            _errorMessage = 'No internet connection. Please try again later.';
          });
        } else if (e is TimeoutException) {
          setState(() {
            _errorMessage = 'Request timed out. Please try again later.';
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
