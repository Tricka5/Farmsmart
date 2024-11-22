import 'package:flutter/material.dart';

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
                      onPressed: () => print('clicked'),
                    ),
                    CustomButtonWithIcon(
                      text: 'Farm Asset Management',
                      icon: Icons.agriculture,
                      onPressed: () => print('Farm Asset Management clicked'),
                    ),
                    CustomButtonWithIcon(
                      text: 'Task Reminder',
                      icon: Icons.notifications_active,
                      onPressed: () => print('Task Reminder clicked'),
                    ),
                    CustomButtonWithIcon(
                      text: 'Depreciation Schedule',
                      icon: Icons.schedule,
                      onPressed: () => print('Depreciation Schedule clicked'),
                    ),
                    CustomButtonWithIcon(
                      text: 'Financial Management',
                      icon: Icons.attach_money,
                      onPressed: () => print('Financial Management clicked'),
                    ),
                    CustomButtonWithIcon(
                      text: 'Crop Management',
                      icon: Icons.eco,
                      onPressed: () => print('Crop Management clicked'),
                    ),
                    CustomButtonWithIcon(
                      text: 'Livestock Management',
                      icon: Icons.pets,
                      onPressed: () => print('Livestock Management clicked'),
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
                          print('Logout clicked');
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
