import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void getData() async{
    final response= await http.get(Uri.parse('http://localhost:3000/users/allusers'));

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed (context, '/contacts',arguments:(){

      } );
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('loading'),
    );
  }
}
