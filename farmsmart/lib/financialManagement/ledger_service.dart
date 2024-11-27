import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ledger.dart';
import 'ledger_entry.dart';

class LedgerService {
  final String baseUrl = 'http://192.168.1.123:3000'; // Use your correct API URL

  // Fetch ledger list
  Future<List<Ledger>> fetchLedgers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ledger'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((item) => Ledger.fromJson(item)).toList();
      } else {
        print('Failed to load ledgers: ${response.statusCode}');
        throw Exception('Failed to load ledgers');
      }
    } catch (e) {
      print('Error fetching ledgers: $e');
      throw Exception('Failed to load ledgers');
    }
  }

  // Fetch ledger entries by ledger ID
  Future<List<LedgerEntry>> fetchLedgerEntries(int ledgerAccountId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ledger-entry/getall/$ledgerAccountId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((item) => LedgerEntry.fromJson(item)).toList();
      } else {
        print('Failed to load ledger entries: ${response.statusCode}');
        throw Exception('Failed to load ledger entries');
      }
    } catch (e) {
      print('Error fetching ledger entries: $e');
      throw Exception('Failed to load ledger entries');
    }
  }

  // POST: Create a new ledger entry
  Future<void> createLedgerEntry(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ledger-entry/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 201) {
        print('Ledger entry created successfully!');
      } else {
        String errorResponse = response.body.isEmpty ? 'No error details provided' : response.body;
        print('Error details: $errorResponse');
        throw Exception('Failed to create ledger entry');
      }
    } catch (e) {
      print('Error creating ledger entry: $e');
      throw Exception('Failed to create ledger entry');
    }
  }

  // POST: Create a new ledger
  Future<void> createLedger(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ledger/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 201) {
        print('Ledger created successfully!');
      } else {
        String errorResponse = response.body.isEmpty ? 'No error details provided' : response.body;
        print('Error details: $errorResponse');
        throw Exception('Failed to create ledger');
      }
    } catch (e) {
      print('Error creating ledger: $e');
      throw Exception('Failed to create ledger');
    }
  }

  // PUT: Edit an existing ledger
  Future<void> updateLedger(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/ledger/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        print('Ledger updated successfully!');
      } else {
        String errorResponse = response.body.isEmpty ? 'No error details provided' : response.body;
        print('Error details: $errorResponse');
        throw Exception('Failed to update ledger');
      }
    } catch (e) {
      print('Error updating ledger: $e');
      throw Exception('Failed to update ledger');
    }
  }

  // PUT: Edit an existing ledger entry
  Future<void> updateLedgerEntry(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/ledger-entry/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        print('Ledger entry updated successfully!');
      } else {
        String errorResponse = response.body.isEmpty ? 'No error details provided' : response.body;
        print('Error details: $errorResponse');
        throw Exception('Failed to update ledger entry');
      }
    } catch (e) {
      print('Error updating ledger entry: $e');
      throw Exception('Failed to update ledger entry');
    }
  }

  // DELETE: Delete a ledger entry
  Future<void> deleteLedgerEntry(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/ledger-entry/$id'),
      );
      if (response.statusCode == 200) {
        print('Ledger entry deleted successfully!');
      } else {
        String errorResponse = response.body.isEmpty ? 'No error details provided' : response.body;
        print('Error details: $errorResponse');
        throw Exception('Failed to delete ledger entry');
      }
    } catch (e) {
      print('Error deleting ledger entry: $e');
      throw Exception('Failed to delete ledger entry');
    }
  }

  // DELETE: Delete a ledger
  Future<void> deleteLedger(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/ledger/$id'),
      );
      if (response.statusCode == 200) {
        print('Ledger deleted successfully!');
      } else {
        String errorResponse = response.body.isEmpty ? 'No error details provided' : response.body;
        print('Error details: $errorResponse');
        throw Exception('Failed to delete ledger');
      }
    } catch (e) {
      print('Error deleting ledger: $e');
      throw Exception('Failed to delete ledger');
    }
  }
}
