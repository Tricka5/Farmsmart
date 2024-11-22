import 'package:flutter/material.dart';

void main() {
  runApp(FarmSmartApp());
}

class FarmSmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FarmSmartHomePage(),
    );
  }
}

// Home Page
class FarmSmartHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.lightGreen[100],
        child: Center(
          child: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to Farm Smart mobile farm record designed and implemented to give a simple and friendly user interface for your farm record keeping.\n\nTo begin click the menu bar on the top left corner of the home page',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the About Developers page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutDevelopersPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'About Developers',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// About Developers Page
class AboutDevelopersPage extends StatelessWidget {
  final List<Map<String, String>> developers = [
    {'name': 'Gizzoh', 'photo': 'assets/gizzoh.jpg'},
    {'name': 'Joshua', 'photo': 'assets/joshua.jpg'},
    {'name': 'Mziliwe', 'photo': 'assets/mziliwe.jpg'},
    {'name': 'Tricka Bita', 'photo': 'assets/tricka_bita.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text('Developers', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        color: Colors.lightGreen[100],
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: developers.length,
          itemBuilder: (context, index) {
            final developer = developers[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        developer['photo']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    developer['name']!,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
