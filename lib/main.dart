import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livestock Management',
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
        title: Text('Livestock Management'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Livestock Components',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text('Animal Identification'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnimalIdentificationScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Health & Veterinary Records'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HealthVeterinaryRecordsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Feeding Records'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedingRecordsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Production Records'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductionRecordsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Select an option from the menu.'),
      ),
    );
  }
}

// Animal Identification Screen
class AnimalIdentificationScreen extends StatefulWidget {
  @override
  _AnimalIdentificationScreenState createState() => _AnimalIdentificationScreenState();
}

class _AnimalIdentificationScreenState extends State<AnimalIdentificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? animalId;
  String? animalSpecies;
  String? gender;
  DateTime? birthDate;

  final TextEditingController _birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Identification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Animal ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter animal ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  animalId = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Animal Species/Breed'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter species/breed';
                  }
                  return null;
                },
                onSaved: (value) {
                  animalSpecies = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gender'),
                value: gender, // Set the initial value
                items: ['Male', 'Female'].map((String value) {
  child: Text(value),
