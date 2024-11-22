import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agriculture Management',
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
        title: Text('Agriculture Management'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Agriculture Components',
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
              title: Text('Fertilization'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FertilizationScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Crop Variety'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CropVarietyScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Crop Growth'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CropGrowthScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Pest Control'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PestControlScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Harvestation'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HarvestationScreen()),
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

// Fertilization Screen
class FertilizationScreen extends StatefulWidget {
  @override
  _FertilizationScreenState createState() => _FertilizationScreenState();
}

class _FertilizationScreenState extends State<FertilizationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? fertilizerType;
  DateTime? applicationDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fertilization'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Fertilizer Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fertilizer type';
                  }
                  return null;
                },
                onSaved: (value) {
                  fertilizerType = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Application Date'),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: applicationDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (date != null) {
                    setState(() {
                      applicationDate = date;
                    });
                  }
                },
                controller: TextEditingController(
                  text: applicationDate != null
                      ? "${applicationDate!.toLocal()}".split(' ')[0]
                      : '',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fertilizer applied: $fertilizerType on ${applicationDate!.toLocal()}')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Crop Variety Screen (Placeholder)
class CropVarietyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Variety'),
      ),
      body: Center(
        child: Text('Crop Variety Information goes here.'),
      ),
    );
  }
}

// Crop Growth Screen (Placeholder)
class CropGrowthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Growth'),
      ),
      body: Center(
        child: Text('Crop Growth Information goes here.'),
      ),
    );
  }
}

// Pest Control Screen (Placeholder)
class PestControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pest Control'),
      ),
      body: Center(
        child: Text('Pest Control Information goes here.'),
      ),
    );
  }
}

// Harvestation Screen (Placeholder)
class HarvestationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harvestation'),
      ),
      body: Center(
        child: Text('Harvestation Information goes here.'),
      ),
    );
  }
}
