

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FarmRecordsScreen(),
    );
  }
}

class FarmRecordsScreen extends StatefulWidget {
  @override
  _FarmRecordsScreenState createState() => _FarmRecordsScreenState();
}

class _FarmRecordsScreenState extends State<FarmRecordsScreen> {
  // Selected crop variety, planting date, fertilizer date, pesticide date, and harvest details
  String? selectedCrop;
  DateTime? plantingDate;
  DateTime? fertilizerDate;
  DateTime? pesticideDate;
  DateTime? harvestDate;
  String? yieldAmount;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    final DateTime initialDate = DateTime.now();
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2101);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Records Management'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Planting Date and Crop Variety
                    Text(
                      'Planting Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Crop Variety',
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedCrop = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Text('Planting Date: '),
                        TextButton(
                          onPressed: () => _selectDate(context, (date) {
                            plantingDate = date;
                          }),
                          child: Text(
                            plantingDate == null
                                ? 'Select Date'
                                : '${plantingDate?.toLocal()}'.split(' ')[0],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
            
                    // Fertilizer Application Date
                    Text(
                      'Fertilizer Application',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      
                      
                    ),
                    
                    Column(
                      children: [
                        Text('Application Date: '),
                        TextButton(
                          onPressed: () => _selectDate(context, (date) {
                            fertilizerDate = date;
                          }),
                          child: TextField(
                             decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'select Date',
                      ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
            
                    // Pesticide Application Date (Optional)
                    Text(
                      'Pesticide Application (Optional)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Text('Application Date: '),

                        TextButton(
                          onPressed: () => _selectDate(context, (date) {
                            pesticideDate = date;
                          }),
                          child: Text(
                            pesticideDate == null
                                ? 'Select Date'
                                : '${pesticideDate?.toLocal()}'.split(' ')[0],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
            
                    // Harvest Details
                    Text(
                      'Harvest Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Text('Harvest Date: '),
                        TextButton(
                          onPressed: () => _selectDate(context, (date) {
                            harvestDate = date;
                          }),
                          child: Text(
                            harvestDate == null
                                ? 'Select Date'
                                : '${harvestDate?.toLocal()}'.split(' ')[0],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Yield Amount',
                      ),
                      onChanged: (value) {
                        setState(() {
                          yieldAmount = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
            
                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        if (selectedCrop != null && plantingDate != null && fertilizerDate != null) {
                          // Process the data
                          print('Crop Variety: $selectedCrop');
                          print('Planting Date: ${plantingDate?.toLocal()}');
                          print('Fertilizer Application Date: ${fertilizerDate?.toLocal()}');
                          if (pesticideDate != null) {
                            print('Pesticide Application Date: ${pesticideDate?.toLocal()}');
                          }
                          if (harvestDate != null && yieldAmount != null) {
                            print('Harvest Date: ${harvestDate?.toLocal()}');
                            print('Yield Amount: $yieldAmount');
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill in all mandatory fields')),
                          );
                        }
                      },
                      child: Text('Submit Record'),
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
