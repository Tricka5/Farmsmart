// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AssetListPage(),
        '/addAsset': (context) => AddAssetPage(),
        '/depreciationSchedule': (context) => EquipmentListPage(),
      },
    );
  }
}

// Asset Model
class Asset {
  String name;
  String shortDescription;
  String longDescription;

  Asset({
    required this.name,
    required this.shortDescription,
    required this.longDescription,
  });
}

// Equipment Model for Depreciation
class Equipment {
  final String name;
  final double cost;
  final double salvageValue;
  final int usefulLife;
  final int yearsInUse;

  Equipment({
    required this.name,
    required this.cost,
    required this.salvageValue,
    required this.usefulLife,
    required this.yearsInUse,
  });

  double get currentValue {
    double depreciationPerYear = (cost - salvageValue) / usefulLife;
    double totalDepreciation = yearsInUse * depreciationPerYear;
    return (cost - totalDepreciation).clamp(salvageValue, cost);
  }
}

// Global lists
List<Asset> assets = [];
List<Equipment> equipmentList = [];

// Asset Management Page
class AssetListPage extends StatefulWidget {
  @override
  _AssetListPageState createState() => _AssetListPageState();
}

class _AssetListPageState extends State<AssetListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 221, 221),
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: Text('Farm Asset Management'),
      ),
      body: assets.isEmpty
          ? Center(
              child: Text(
                "No assets added yet.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                return Card(
                  child: ListTile(
                    title: Text(asset.name),
                    subtitle: Text(asset.shortDescription),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _editAsset(context, index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              assets.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 20, 121, 23),
        label: Text(
          "add asset",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await Navigator.pushNamed(context, '/addAsset');
          setState(() {}); // Refresh the page after adding an asset
        },
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: "Add Asset",
      ),
    );
  }

  void _editAsset(BuildContext context, int index) {
    final asset = assets[index];
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: asset.name);
        final shortDescController =
            TextEditingController(text: asset.shortDescription);
        final longDescController =
            TextEditingController(text: asset.longDescription);

        return AlertDialog(
          title: Text('Edit Asset'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Asset Name'),
              ),
              TextField(
                controller: shortDescController,
                decoration: InputDecoration(labelText: 'Short Description'),
              ),
              TextField(
                controller: longDescController,
                decoration: InputDecoration(labelText: 'Long Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  asset.name = nameController.text;
                  asset.shortDescription = shortDescController.text;
                  asset.longDescription = longDescController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

// Add Asset Page
class AddAssetPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortDescController = TextEditingController();
  final TextEditingController longDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 232, 232),
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: Text('Enter Asset Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter Asset Name...",
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(255, 124, 125, 126)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 500,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextField(
                  controller: shortDescController,
                  decoration: InputDecoration(
                    hintText: "Enter Short Description...",
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(255, 124, 125, 126)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 500,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextField(
                  controller: longDescController,
                  decoration: InputDecoration(
                    hintText: "Enter Long Description...",
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(255, 124, 125, 126)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 200),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 20, 117, 36))),
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      shortDescController.text.isNotEmpty &&
                      longDescController.text.isNotEmpty) {
                    assets.add(Asset(
                      name: nameController.text,
                      shortDescription: shortDescController.text,
                      longDescription: longDescController.text,
                    ));
                    Navigator.pop(context); // Pop back and refresh
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill in all fields.")),
                    );
                  }
                },
                label: Text(
                  "Create Asset",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Depreciation Schedule Page
class EquipmentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Depreciation Schedule'),
      ),
      body: Center(
        child: Column(
          children: [
            equipmentList.isEmpty
                ? Text("No equipment added.")
                : Expanded(
                    child: ListView.builder(
                      itemCount: equipmentList.length,
                      itemBuilder: (context, index) {
                        final equipment = equipmentList[index];
                        return ListTile(
                          title: Text(equipment.name),
                          subtitle: Text(
                              "Current Value: \$${equipment.currentValue.toStringAsFixed(2)}"),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
