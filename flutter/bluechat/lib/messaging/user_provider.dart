// user_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bluechat/users/users.dart';

class UserProvider with ChangeNotifier {
  User? _currentUserProfile;
  bool _loading = true;
  String? _error;

  User? get currentUserProfile => _currentUserProfile;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchUser(String userId) async {
    if (userId.isEmpty) return; // Exit if userId is not provided

    _loading = true; // Set loading to true before fetching
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('http://localhost:3000/users/$userId'));
      if (response.statusCode == 200) {
        _currentUserProfile = User.fromJson(json.decode(response.body));
        _error = null;
      } else {
        _error = 'Error: ${response.statusCode}';
      }
    } catch (err) {
      _error = err.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
