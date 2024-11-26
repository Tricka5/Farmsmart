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
        '/': (context) => EquipmentListPage(),
        '/details': (context) => EquipmentDetailsPage(),
      },
    );
  }
}

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

class EquipmentListPage extends StatefulWidget {
  @override
  _EquipmentListPageState createState() => _EquipmentListPageState();
}

class _EquipmentListPageState extends State<EquipmentListPage> {
  List<Equipment> equipmentList = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 225, 229, 233),
        appBar: AppBar(
          backgroundColor: Colors.grey[600],
          title: Text('Depreciation Schedule'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: equipmentList.length,
                  itemBuilder: (context, index) {
                    final equipment = equipmentList[index];
                    return Card(
                      child: ListTile(
                        title: Text(equipment.name),
                        subtitle: Text(
                            "Current Value: \$${equipment.currentValue.toStringAsFixed(2)}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                // Show loading indicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                final updatedEquipment = await Navigator.push(
                                  context,
                                  _createSlideTransition(
                                    EquipmentDetailsPage(equipment: equipment),
                                  ),
                                );

                                if (updatedEquipment != null &&
                                    updatedEquipment is Equipment) {
                                  setState(() {
                                    equipmentList[index] = updatedEquipment;
                                  });
                                }

                                Navigator.pop(
                                    context); // Close the loading dialog
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  equipmentList.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    final newEquipment = await Navigator.push(
                      context,
                      _createSlideTransition(
                        EquipmentDetailsPage(),
                      ),
                    );

                    if (newEquipment != null && newEquipment is Equipment) {
                      setState(() {
                        equipmentList.add(newEquipment);
                      });
                    }

                    Navigator.pop(context); // Close the loading dialog
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 23, 112, 20))),
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: Text(
                    "TRACK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom page transition with sliding effect
  PageRouteBuilder _createSlideTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

class EquipmentDetailsPage extends StatelessWidget {
  final Equipment? equipment;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _salvageController = TextEditingController();
  final TextEditingController _usefulLifeController = TextEditingController();
  final TextEditingController _yearsInUseController = TextEditingController();

  EquipmentDetailsPage({this.equipment}) {
    if (equipment != null) {
      _nameController.text = equipment!.name;
      _costController.text = equipment!.cost.toString();
      _salvageController.text = equipment!.salvageValue.toString();
      _usefulLifeController.text = equipment!.usefulLife.toString();
      _yearsInUseController.text = equipment!.yearsInUse.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(equipment == null ? 'Add Equipment' : 'Edit Equipment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Equipment Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(_nameController, "Equipment Name"),
              SizedBox(height: 16),
              _buildTextField(_costController, "Enter Cost", isNumber: true),
              SizedBox(height: 16),
              _buildTextField(_salvageController, "Enter Salvage Value",
                  isNumber: true),
              SizedBox(height: 16),
              _buildTextField(
                  _usefulLifeController, "Enter Useful Life (Years)",
                  isNumber: true),
              SizedBox(height: 16),
              _buildTextField(_yearsInUseController, "Enter Years in Use",
                  isNumber: true),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel, color: Colors.white),
                    label: Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 29, 133, 32))),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final updatedEquipment = Equipment(
                        name: _nameController.text,
                        cost: double.tryParse(_costController.text) ?? 0.0,
                        salvageValue:
                            double.tryParse(_salvageController.text) ?? 0.0,
                        usefulLife:
                            int.tryParse(_usefulLifeController.text) ?? 1,
                        yearsInUse:
                            int.tryParse(_yearsInUseController.text) ?? 0,
                      );
                      Navigator.pop(context, updatedEquipment);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 20, 117, 36))),
                    icon: Icon(
                      Icons.save_rounded,
                      color: Colors.white,
                    ),
                    label: Text(
                      "SAVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return SizedBox(
      height: 40,
      width: 500,
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
