import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agriculture Menu',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agriculture Menu'),
      ),
      body: ListView(
        children: [
          MenuItem(
            title: 'Fertilization',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FertilizationScreen()),
              );
            },
          ),
          MenuItem(
            title: 'Crop Variety',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CropVarietyScreen()),
              );
            },
          ),
          MenuItem(
            title: 'Crop Growth',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CropGrowthScreen()),
              );
            },
          ),
          MenuItem(
            title: 'Pest Control',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PestControlScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  MenuItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}

class FertilizationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fertilization'),
      ),
      body: Center(
        child: Text('Information about Fertilization'),
      ),
    );
  }
}

class CropVarietyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Variety'),
      ),
      body: Center(
        child: Text('Information about Crop Variety'),
      ),
    );
  }
}

class CropGrowthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Growth'),
      ),
      body: Center(
        child: Text('Information about Crop Growth'),
      ),
    );
  }
}

class PestControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pest Control'),
      ),
      body: Center(
        child: Text('Information about Pest Control'),
      ),
    );
  }
}