import 'package:flutter/material.dart';

class FarmRecordsScreen extends StatefulWidget {
  const FarmRecordsScreen({super.key});

  @override
  _FarmRecordsScreenState createState() => _FarmRecordsScreenState();
}

class _FarmRecordsScreenState extends State<FarmRecordsScreen> {
  // Selected crop variety, planting date, and fertilizer date
  String? selectedCrop;
  DateTime? plantingDate;
  DateTime? fertilizerDate;

  // List of available crop varieties
  final List<String> cropVarieties = [
    'Maize',
    'Tobacco',
    'Rice',
    'Tea',
    'Sugar',
    'Cotton',
    'Cassava',
    'Sweet potatoes',
    'Coffee',
    'Groundnuts',
    'Pulses',
    'Sorghum',
    'Millet',
  ];

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context, bool isFertilizer) async {
    final DateTime initialDate = DateTime.now();
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2101);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != plantingDate) {
      setState(() {
        if (isFertilizer) {
          fertilizerDate = picked;
        } else {
          plantingDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
          appBar: AppBar(
        title: Text('Farm Records Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop Variety Dropdown
            DropdownButtonFormField<String>(
              value: selectedCrop,
              hint: Text('Select Crop Variety'),
              items: cropVarieties.map((String crop) {
                return DropdownMenuItem<String>(
                  value: crop,
                  child: Text(crop),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCrop = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                
              ),
            ),
            SizedBox(height: 20),

            // Planting Date Picker
            Row(
              children: [
                Text('Planting Date: '),
                TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(
                    plantingDate == null
                        ? 'Select Date'
                        : '${plantingDate?.toLocal()}'.split(' ')[0],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Fertilizer Application Date Picker
            Row(
              children: [
                Text('Fertilizer Application Date: '),
                TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(
                    fertilizerDate == null
                        ? 'Select Date'
                        : '${fertilizerDate?.toLocal()}'.split(' ')[0],
                  ),
                ),
              ],
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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: Text('Submit Record'),
            ),
          ],
        ),
      ),
    );
  }
}