import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CropManagementPage(),
    );
  }
}

class CropManagementPage extends StatefulWidget {
  @override
  _CropManagementPageState createState() => _CropManagementPageState();
}

class _CropManagementPageState extends State<CropManagementPage> {
  List<Map<String, String>> savedDetails = [];

  void addCrop(Map<String, String> details) {
    setState(() {
      savedDetails.add(details);
    });
  }

  void deleteCrop(int index) {
    setState(() {
      savedDetails.removeAt(index);
    });
  }

  void updateCrop(int index, Map<String, String> updatedDetails) {
    setState(() {
      savedDetails[index] = updatedDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 212, 102),
        title: Text("Crop Management"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Back arrow functionality
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ...savedDetails.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, String> details = entry.value;
            return Card(
              child: ListTile(
                title: Text(details['Crop variety'] ?? 'Unnamed'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropAnalyticsPage(
                              initialDetails: details,
                              onSave: (updatedDetails) {
                                updateCrop(index, updatedDetails);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: const Color.fromARGB(255, 10, 2, 2)),
                      onPressed: () => deleteCrop(index),
                    ),
                  ],
                ),
              ),
            );
          }),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CropAnalyticsPage(
                    onSave: addCrop,
                  ),
                ),
              );
            },
            child: Text("Add Crop Analytics"),
          ),
        ],
      ),
    );
  }
}

class CropAnalyticsPage extends StatefulWidget {
  final Map<String, String>? initialDetails;
  final Function(Map<String, String>) onSave;

  CropAnalyticsPage({this.initialDetails, required this.onSave});

  @override
  _CropAnalyticsPageState createState() => _CropAnalyticsPageState();
}

class _CropAnalyticsPageState extends State<CropAnalyticsPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> details = {
    'Crop variety': '',
    'Crop growth': '',
    'Pest control': '',
    'Harvestation': ''
  };

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
