import 'package:flutter/material.dart';
import 'package:bluechat/page/choose_location.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextButton(
              onPressed: () {
                // Action when button is pressed
                Navigator.pushNamed(context, '/location');
              },
              child: Text('Press Me'), // Complete the label here

            ),
          ],
        ),
      ),
    );
  }
}
