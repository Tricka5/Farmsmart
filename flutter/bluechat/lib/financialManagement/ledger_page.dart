import 'package:flutter/material.dart';
import 'ledger.dart';
import 'ledger_entry.dart';
import 'ledger_service.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  final LedgerService _ledgerService = LedgerService();
  late Future<List<Ledger>> _ledgers;
  Map<int, bool> _ledgerVisibility = {};
  Map<int, List<LedgerEntry>> _ledgerEntries = {};

  // Separate controllers for ledger entry fields
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _transactorController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ledgers = _ledgerService.fetchLedgers();
  }

  void _onLedgerClick(int ledgerAccountId) {
    print(ledgerAccountId);
    setState(() {
      if (_ledgerVisibility.containsKey(ledgerAccountId)) {
        _ledgerVisibility[ledgerAccountId] = !_ledgerVisibility[ledgerAccountId]!;
      } else {
        _ledgerVisibility[ledgerAccountId] = true;
      }
    });

    if (_ledgerVisibility[ledgerAccountId] == true && _ledgerEntries[ledgerAccountId] == null) {
      _ledgerService.fetchLedgerEntries(ledgerAccountId).then((entries) {
        setState(() {
          _ledgerEntries[ledgerAccountId] = entries;
        });
      }).catchError((error) {
        print("Error fetching entries: $error");
      });
    }
  }

  // Function to create a new ledger entry for a given ledger
  void _createLedgerEntry(int ledgerAccountId) async {
    Map<String, dynamic> entryData = {
      'ledgerAccountid': ledgerAccountId,
      'type': _typeController.text.isNotEmpty ? _typeController.text : 'dr', // Default to 'dr' if type is empty
      'description': _itemController.text,
      'amount': int.tryParse(_amountController.text) ?? 0,
      'date': DateTime.now().toIso8601String(),
    };

    try {
      await _ledgerService.createLedgerEntry(entryData);
      _itemController.clear();
      _amountController.clear();
      _typeController.clear();

      // Fetch the updated list of entries for this ledger after creating the new entry
      final updatedEntries = await _ledgerService.fetchLedgerEntries(ledgerAccountId);
      setState(() {
        _ledgerEntries[ledgerAccountId] = updatedEntries;
      });
    } catch (e) {
      print("Error creating ledger entry: $e");
    }
  }

  // Function to create a new ledger
  void _createLedger() async {
    Map<String, dynamic> ledgerData = {
      'itemname': _itemController.text,
      'transactor': _transactorController.text,
      'type': _typeController.text,
    };

    try {
      await _ledgerService.createLedger(ledgerData);
      setState(() {
        _ledgers = _ledgerService.fetchLedgers(); // Refresh the list of ledgers after creation
      });
      _itemController.clear();
      _transactorController.clear();
      _typeController.clear();
    } catch (e) {
      print("Error creating ledger: $e");
    }
  }

  // Function to show the ledger entry creation dialog
  void _showCreateEntryDialog(int ledgerAccountId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Ledger Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            DropdownButtonFormField<String>(
              value: _typeController.text.isNotEmpty ? _typeController.text : null, // Default to empty if not set
              onChanged: (String? newValue) {
                setState(() {
                  _typeController.text = newValue ?? ''; // Update the text controller with the selected value
                });
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'dr',
                  child: Text('Debit (dr)'),
                ),
                DropdownMenuItem<String>(
                  value: 'cr',
                  child: Text('Credit (cr)'),
                ),
              ],
              decoration: const InputDecoration(labelText: 'Type (dr/cr)'),
            )


          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_itemController.text.isNotEmpty &&
                  _amountController.text.isNotEmpty &&
                  _typeController.text.isNotEmpty) {
                _createLedgerEntry(ledgerAccountId);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text(
        'Ledger List',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white, // Set the color to white
        ),
      ),
        backgroundColor: Colors.green, // You can keep the background color as is
      ),
      body: FutureBuilder<List<Ledger>>(
        future: _ledgers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ledgers available.'));
          } else {
            List<Ledger> ledgers = snapshot.data!;

            return ListView.builder(
              itemCount: ledgers.length,
              itemBuilder: (context, index) {
                final ledger = ledgers[index];
                bool isExpanded = _ledgerVisibility[ledger.id] ?? false;
                List<LedgerEntry> entries = _ledgerEntries[ledger.id] ?? [];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        title: Text(ledger.itemname, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.grey)),
                        subtitle: Text('${ledger.transactor} | ${ledger.date}', style: const TextStyle(color: Colors.grey)),
                        onTap: () {
                          print("Clicked on Ledger: ${ledger.itemname}");
                          _onLedgerClick(ledger.id);
                        },
                      ),
                      if (isExpanded && entries.isNotEmpty) ...[
                        Column(
                          children: entries.map((entry) {
                            bool isCredit = entry.type == 'cr';
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: isCredit ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: isCredit ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    children: [
                                      Text(entry.description ?? '', style: const TextStyle(fontSize: 16)),
                                      const SizedBox(width: 8),
                                      Text('Amount: ${entry.amount ?? 0}', style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Text('Type: ${entry.type ?? ''}', style: const TextStyle(color: Colors.grey)),
                                  const Divider(),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      // Add button for creating a ledger entry
                      TextButton(
                        onPressed: () => _showCreateEntryDialog(ledger.id),
                        child: const Text('Add Entry'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Create Ledger Account'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                  ),
                  TextField(
                    controller: _transactorController,
                    decoration: const InputDecoration(labelText: 'Transactor'),
                  ),
                  DropdownButtonFormField<String>(
                    value: _typeController.text.isNotEmpty ? _typeController.text : null, // Default to empty if not set
                    onChanged: (String? newValue) {
                      setState(() {
                        _typeController.text = newValue ?? ''; // Update the text controller with the selected value
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'expense',
                        child: Text('Expense'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'income',
                        child: Text('Income'),
                      ),
                    ],
                    decoration: const InputDecoration(labelText: 'Type (expense/income)'),
                  )

                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_itemController.text.isNotEmpty &&
                        _transactorController.text.isNotEmpty &&
                        _typeController.text.isNotEmpty) {
                      _createLedger(); // This method is now defined
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add,color: Colors.white, ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
