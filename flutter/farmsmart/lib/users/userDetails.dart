import 'package:flutter/material.dart';
import '/users/users.dart';

class UserDetails extends StatelessWidget {
  final User user;

  UserDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black54,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                if (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty)
                  ClipOval(
                    child: Image.network(
                      user.profileImageUrl!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 20),

                // User Full Name
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),

                // User Details
                _buildUserDetail('Profile: ${user.profile}'),

                SizedBox(height: 30), // Space before button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/user_inbox', arguments: user);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text('Message'), // Complete the label here
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetail(String detail) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          detail,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ),
    );
  }
}
