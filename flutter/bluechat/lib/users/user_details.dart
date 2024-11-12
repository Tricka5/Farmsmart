import 'package:flutter/material.dart';
import 'package:bluechat/loadingWidgets/current_user_api_service.dart';
import 'package:bluechat/users/users.dart';

class UserDetails extends StatefulWidget {

  final int? userId;
  UserDetails({required this.userId});


  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late User _user;

  Future<void> _loadUser() async{
    final currentUserApiService=CurrentUserApiService();
    final user=await currentUserApiService.getCurrentUser(5);
    setState(() {
      _user=user;
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
