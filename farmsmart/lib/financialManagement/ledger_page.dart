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
  final Map<int, bool> _ledgerVisibility = {};
  final Map<int, List<LedgerEntry>> _ledgerEntries = {};

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

  void _createLedgerEntry(int ledgerAccountId) async {
    Map<String, dynamic> entryData = {
      'ledgerAccountid': ledgerAccountId,
      'type': _typeController.text.isNotEmpty ? _typeController.text : 'dr',
      'description': _itemController.text,
      'amount': int.tryParse(_amountController.text) ?? 0,
      'date': DateTime.now().toIso8601String(),
    };

    try {
      await _ledgerService.createLedgerEntry(entryData);
      _itemController.clear();
      _amountController.clear();
      _typeController.clear();

      final updatedEntries = await _ledgerService.fetchLedgerEntries(ledgerAccountId);
      setState(() {
        _ledgerEntries[ledgerAccountId] = updatedEntries;
      });
    } catch (e) {
      print("Error creating ledger entry: $e");
    }
  }

  void _createLedger() async {
    Map<String, dynamic> ledgerData = {
      'itemname': _itemController.text,
      'transactor': _transactorController.text,
      'type': _typeController.text,
    };

    try {
      await _ledgerService.createLedger(ledgerData);
      setState(() {
        _ledgers = _ledgerService.fetchLedgers();
      });
      _itemController.clear();
      _transactorController.clear();
      _typeController.clear();
    } catch (e) {
      print("Error creating ledger: $e");
    }
  }

  void _updateLedger(int ledgerId) async {
    Map<String, dynamic> updatedLedgerData = {
      'itemname': _itemController.text,
      'transactor': _transactorController.text,
      'type': _typeController.text,
    };

    try {
      await _ledgerService.updateLedger(ledgerId, updatedLedgerData);
      setState(() {
        _ledgers = _ledgerService.fetchLedgers();
      });
      _itemController.clear();
      _transactorController.clear();
      _typeController.clear();
    } catch (e) {
      print("Error updating ledger: $e");
    }
  }

  void _deleteLedger(int ledgerId) async {
    try {
      await _ledgerService.deleteLedger(ledgerId);
      setState(() {
        _ledgers = _ledgerService.fetchLedgers();
      });
    } catch (e) {
      print("Error deleting ledger: $e");
    }
  }

  void _deleteLedgerEntry(int ledgerAccountId, int entryId) async {
    try {
      await _ledgerService.deleteLedgerEntry(entryId);
      setState(() {
        _ledgerEntries[ledgerAccountId]?.removeWhere((entry) => entry.id == entryId);
      });
    } catch (e) {
      print("Error deleting ledger entry: $e");
    }
  }

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
              value: _typeController.text.isNotEmpty ? _typeController.text : null,
              onChanged: (String? newValue) {
                setState(() {
                  _typeController.text = newValue ?? '';
                });
              },
              items: const [
                DropdownMenuItem<String>(value: 'dr', child: Text('Debit (dr)')),
                DropdownMenuItem<String>(value: 'cr', child: Text('Credit (cr)')),
              ],
              decoration: const InputDecoration(labelText: 'Type (dr/cr)'),
            ),
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
      appBar: AppBar(
        title: const Text(
          'Ledger List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
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
                        title: Text(ledger.itemname, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                        subtitle: Text('${ledger.transactor} | ${ledger.date}', style: const TextStyle(color: Colors.grey)),
                        onTap: () => _onLedgerClick(ledger.id),
                      ),
                      if (isExpanded && entries.isNotEmpty) ...[
                        Column(
                          children: entries.map((entry) {
                            bool isCredit = entry.type == 'cr';
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: isCredit ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: isCredit ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      children: [
                                        Text(entry.description ?? '', style: const TextStyle(fontSize: 16)),
                                        Text('Amount: ${entry.amount ?? 0}', style: const TextStyle(fontSize: 16)),
                                        Text('Type: ${entry.type ?? ''}', style: const TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteLedgerEntry(ledger.id, entry.id),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      TextButton(
                        onPressed: () => _showCreateEntryDialog(ledger.id),
                        child: const Text('Add Entry'),
                      ),
                      TextButton(
                        onPressed: () => _deleteLedger(ledger.id),
                        child: const Text('Delete Ledger'),
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
                    value: _typeController.text.isNotEmpty ? _typeController.text : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        _typeController.text = newValue ?? '';
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(value: 'expense', child: Text('Expense')),
                      DropdownMenuItem<String>(value: 'income', child: Text('Income')),
                    ],
                    decoration: const InputDecoration(labelText: 'Type (expense/income)'),
                  ),
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
                      _createLedger();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
