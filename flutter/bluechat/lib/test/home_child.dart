import 'package:flutter/material.dart';

class HomeChildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments passed during navigation
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Access the integer value
    final int myInteger = arguments['intiger'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Child Page'),
      ),
      body: Center(
        child: Text('The integer is: $myInteger'),
      ),
    );
  }
}
