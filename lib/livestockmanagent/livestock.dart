import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LivestockManagementPage(),
    );
  }
}

class LivestockManagementPage extends StatefulWidget {
  @override
  _LivestockManagementPageState createState() =>
      _LivestockManagementPageState();
}


  void deleteLivestock(int index) {
    setState(() {
      savedDetails.removeAt(index);
    });
  }

  void updateLivestock(int index, Map<String, String> updatedDetails) {
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
        title: Text("Livestock Management"),
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
                title: Text(details['Livestock details'] ?? 'Unnamed'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LivestockAnalyticsPage(
                              initialDetails: details,
                              onSave: (updatedDetails) {
                                updateLivestock(index, updatedDetails);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteLivestock(index),
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
                  builder: (context) => LivestockAnalyticsPage(
                    onSave: addLivestock,
                  ),
                ),
              );
            },
            child: Text("Add Livestock Analytics"),
          ),
        ],
      ),
    );
  }
}

class LivestockAnalyticsPage extends StatefulWidget {
  final Map<String, String>? initialDetails;
  final Function(Map<String, String>) onSave;

  LivestockAnalyticsPage({this.initialDetails, required this.onSave});

  @override
  _LivestockAnalyticsPageState createState() => _LivestockAnalyticsPageState();
}

class _LivestockAnalyticsPageState extends State<LivestockAnalyticsPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> details = {
    'Livestock details': '',
    'Production summary': '',
    'Feed summary': '',
    'Other resources': ''
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialDetails != null) {
      details = Map.from(widget.initialDetails!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 226, 227),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 200, 98),
        title: Text("Livestock Analytics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              for (var field in details.keys)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 216, 216, 216),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: TextEditingController(text: details[field]),
                          decoration: InputDecoration(
                            hintText: 'Enter $field',
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          onChanged: (value) {
                            details[field] = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              Spacer(),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text("Save"),
                onPressed: () {
                  if (details.values.every((element) => element.isNotEmpty)) {
                    widget.onSave(details);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please fill out all fields."),
                    ));
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
