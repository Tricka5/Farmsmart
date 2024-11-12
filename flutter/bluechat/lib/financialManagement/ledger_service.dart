import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ledger.dart';
import 'ledger_entry.dart';

class LedgerService {
  // Use a more flexible base URL configuration
  final String baseUrl = 'http://localhost:3000'; // Use your correct API URL

  // Fetch ledger list
  Future<List<Ledger>> fetchLedgers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ledger'));
      if (response.statusCode == 200) {
        // Decode the response as a Map and extract the 'data' field containing the list
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];  // Access the 'data' key

        // Convert each item in the 'data' list into a Ledger object
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
    print('service $ledgerAccountId');
    try {
      final response = await http.get(Uri.parse('$baseUrl/ledger-entry/getall/$ledgerAccountId'));  // Pass ledgerAccountId as query parameter
      if (response.statusCode == 200) {
        // Decode the response as a Map and extract the 'data' field containing the list
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];  // Access the 'data' key

        // Convert each item in the 'data' list into a LedgerEntry object
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
        // Handle specific response errors for better debugging
        print('Failed to create ledger entry: ${response.statusCode}');
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
        print('Failed to create ledger: ${response.statusCode}');
        String errorResponse = response.body.isEmpty ? 'No error details provided' : response.body;
        print('Error details: $errorResponse');
        throw Exception('Failed to create ledger');
      }
    } catch (e) {
      print('Error creating ledger: $e');
      throw Exception('Failed to create ledger');
    }
  }

  // PUT: Edit an existing ledger entry
  Future<void> editLedgerEntry(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/ledger-entry/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        print('Ledger entry updated successfully!');
      } else {
        print('Failed to update ledger entry: ${response.statusCode}');
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
        print('Failed to delete ledger entry: ${response.statusCode}');
        String errorResponse = response.body.isEmpty ? 'No error details provided' : response.body;
        print('Error details: $errorResponse');
        throw Exception('Failed to delete ledger entry');
      }
    } catch (e) {
      print('Error deleting ledger entry: $e');
      throw Exception('Failed to delete ledger entry');
    }
  }

}
