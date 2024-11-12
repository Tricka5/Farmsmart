import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  Map<String, dynamic>? _currentUserProfile;

  Map<String, dynamic>? get currentUserProfile => _currentUserProfile;

  void setCurrentUserProfile(Map<String, dynamic> userProfile) {
    _currentUserProfile = userProfile;
    notifyListeners();
  }
}
