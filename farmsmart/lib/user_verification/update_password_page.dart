import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/screens/navigation.dart';

class UpdatePasswordPage extends StatefulWidget {
  final String email;  // Email passed from the previous screen
  const UpdatePasswordPage({super.key, required this.email});

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _passwordController = TextEditingController();
  String _message = "";
  bool _isLoading = false;

  // Function to update password
  Future<void> _updatePassword() async {
    setState(() {
      _isLoading = true;
      _message = "";
    });

    final newPassword = _passwordController.text;

    if (newPassword.isEmpty) {
      setState(() {
        _message = "Please enter the new password.";
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/user-aunthentication/update-password'),  // Update with the actual URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,  // Send the email from the previous screen
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = "Password updated successfully!";
          _isLoading = false;
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),  // Navigate to HomePage
          );
        });
      } else {
        setState(() {
          _message = "Failed to update password. Please try again.";
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _message = "Error: $error";
        _isLoading = false;
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
              // Introduction with context
              Text(
                'We are here to help you update your password.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
              ),
              SizedBox(height: 10),

              // Instruction to the user
              Text(
                'Please enter your new password below to reset your account security.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),

              // Password input field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),  // Rounded corners for the input field
                    borderSide: BorderSide(color: Colors.green.shade500),  // Blue border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade700, width: 2),  // Darker blue on focus
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                keyboardType: TextInputType.text
              ),
              SizedBox(height: 20),

              // Update button
              ElevatedButton(
                onPressed: _isLoading ? null : _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400, // Primary button color (blue)
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Update Password', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 20),

              // Display feedback message (error or success)
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    fontSize: 16,
                    color: _message.startsWith('Error') || _message.startsWith('Failed')
                        ? Colors.red.shade700  // Red for errors
                        : Colors.green.shade700,  // Green for success
                    fontWeight: FontWeight.w500,
                  ),
                ),
              SizedBox(height: 10),

              // Additional note for the user
              if (_message.isEmpty)
                Text(
                  'Remember, your password should be at least 8 characters long and include a mix of letters and numbers for better security.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
