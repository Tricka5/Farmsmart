import 'package:farmsmart/user_verification/sign_up.dart';
import 'package:flutter/material.dart';

import '/financialManagement/ledger_page.dart'; // Make sure this path is correct
import '/user_verification/Login_SignUp.dart';
import '/cropmanagement/farm_records.dart';
import '/user_verification/email_input.dart';
import '/chats/chats.dart';

import '/home/home.dart';
import '/home/landingpage.dart';
import '/home/navigation.dart';
import '/home/tasklistpage.dart';
import '/home/usernote.dart';

import 'package:farmsmart/crop_livestock/cropmana.dart';
import 'package:farmsmart/crop_livestock/livestock.dart';
import 'package:farmsmart/bishop/management.dart';
import 'package:farmsmart/bishop/schedule.dart';

void main() => runApp(FarmSmartApp());

class FarmSmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.teal[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Farm Smart',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreenAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // List of clickable buttons
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Individual buttons with icons
                    CustomButtonWithIcon(
                      text: 'Home',
                      icon: Icons.house,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FarmSmartScreen(),
                          ),
                        )
                      },
                    ),
                    CustomButtonWithIcon(
                      text: 'Farm Asset Management',
                      icon: Icons.agriculture,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssetListPage(),
                          ),
                        )
                      },
                    ),
                    CustomButtonWithIcon(
                      text: 'Task Reminder',
                      icon: Icons.notifications_active,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskReminderScreen(),
                          ),
                        )
                      },
                    ),
                    CustomButtonWithIcon(
                      text: 'Depreciation Schedule',
                      icon: Icons.schedule,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EquipmentDetailsPage(),
                          ),
                        )
                      },
                    ),
                    CustomButtonWithIcon(
                      text: 'Financial Management',
                      icon: Icons.attach_money,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LedgerPage(),
                          ),
                        )
                      },
                    ),
                    CustomButtonWithIcon(
                      text: 'Crop Management',
                      icon: Icons.eco,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropManagementPage(),
                          ),
                        )
                      },
                    ),
                    CustomButtonWithIcon(
                      text: 'Livestock Management',
                      icon: Icons.pets,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LivestockManagementPage(),
                          ),
                        )
                      },
                    ),

                    // Logout button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.logout, color: Colors.teal[900]),
                        label: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.teal[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButtonWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButtonWithIcon({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 110, 110, 110),
        elevation: 4,
        shadowColor: Colors.black26,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 24, color: Colors.teal[900]),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
